program RemoveBrofiaM;

uses
  Windows,
  SysUtils,
  Registry,
  TLHelp32;

var
  Reg           :TRegIniFile;
  Sys           :Array[0..255] Of Char;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot
                     (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,
                                 FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
         UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(
                        PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,
                                  FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;


begin
  KillTask('ISASS.EXE');
  KillTask('titanic2.jpg.pif');
  KillTask('Beautiful Ass.pif');
  KillTask('John Kerry as Super Chicken.scr');
  KillTask('Kool.pif');
  KillTask('Me & you pic!.pif');
  KillTask('Me Pissed!.pif');
  KillTask('sexy.pif');
  KillTask('She Could Fit her Ass in a Teacup.pif');
  KillTask('she''s fuckin fit.pif');
  KillTask('titanic2.jpg.pif');

  GetSystemDirectory(Sys, 256);
  DeleteFile(pChar(String(Sys)+'\ISASS.EXE'));

  DeleteFile('C:\titanic2.jpg.pif');
  DeleteFile('C:\Beautiful Ass.pif');
  DeleteFile('C:\John Kerry as Super Chicken.scr');
  DeleteFile('C:\Kool.pif');
  DeleteFile('C:\Me & you pic!.pif');
  DeleteFile('C:\Me Pissed!.pif');
  DeleteFile('C:\sexy.pif');
  DeleteFile('C:\She Could Fit her Ass in a Teacup.pif');
  DeleteFile('C:\she''s fuckin fit.pif');
  DeleteFile('C:\titanic2.jpg.pif');

  Reg := TRegIniFile.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run', 'Isass');
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run', 'Anti');
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run', 'NvMsnW');
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\RunServices', 'Isass');
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\RunServices', 'Anti');
  Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\RunServices', 'NvMsnW');

  MessageBox(0, 'Your computer is clean from Brofia.M', 'Remover', mb_ok);
end.
