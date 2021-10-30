unit ServerPart2;

interface

Uses
 Windows, Winsock, Messages, Unit1;

Const
 ServerClass = '0x0F1';
 BUFLEN = 65536;
 SM_CONNECT = WM_USER+156;
 SM_SOCKET = WM_USER+157;

Var
 ServerMsg2             : String = 'Transfer Server. Compiled : 2004/02/15'#13;

 Inst2                   : Hwnd;
 wClass2                 : TWndClass;
 MainWin2                : HWND;
 wsData2                 : WSADATA;
 Serv2                  : TSocket;
 SockAddrIn2             : SockAddr_in;
 RemoteSockAddr2         : pSockAddr;
 RemoteSockAddr2Len      : pInteger;
 msg2                    : Tmsg;

 ASiz                   : LongInt;
 CServ2                 : TSocket;
 SRIC2     : Boolean;
 Connected2              : Boolean;
 Buf2k                    : Array[0..BufLEN-1] of Char;

 Procedure Server2(Port:Integer);
 Procedure SocketRead2(Str2:String);

implementation

Function WReceive: String;
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
  ASiz := Recv(CServ2, Str[1], 255, 0);
  If ASiz = -1 Then Begin
   ASiz := wsaGetLastError;
   If ASiz = WSAEWOULDBLOCK Then Begin
    If SRIC2 Then Begin
     Res := 'e!'#13;
     Break;
    End;
    Continue;
   End Else
    Break;
  End;
  SetLength(Str, ASiz);
  Res := Res + Str;
  If Not Connected2 Then Break;
  If Tmp + 40000 <= GetTickCount Then Break;
  If Res = '' Then Goto Z;
  Until Res[Length(Res)] = #13;
 SetLength(Res, Length(Res)-1);
 Result := Res;
End;

Function SysDir:String;
Var
 Buf2k: Array[0..255]Of Char;
Begin
 GetSystemDirectory(Buf2k, 255);
 Result := Buf2k;
 Result := Result + '\';
End;

Procedure SocketRead2(Str2:String);
Var
// I      : Integer;
 Str    : ShortString;
// F      : TextFile;
 Cmd,
 Param  : String;
Begin
 If Str2 = '' Then Begin
  SRIC2 := True;
  Str := WReceive;
  SRIC2 := False;
 End Else Str := Str2;

 Str2 := '';

 Cmd := Copy(Str, 1, 2);
 Param := Copy(Str, 3, Length(Str));

 If Cmd = '20' Then // incomming
  ReceiveFile(Param, CServ2);
 If Cmd = '21' Then Begin // OutGoing
  Sleep(300);
  ReceiveFile(Param, CServ2);
 End;

End;

Function ServerProc2 (Win:Hwnd; Mess:Word; Wpr:Word; Lpr:LongInt):LongInt;Stdcall;
Begin
 Result := 0;
 Case mess Of
  SM_CONNECT: Begin
               If Connected2 Then Exit;
               RemoteSockAddr2Len^ := SizeOf(RemoteSockAddr2^);
               CServ2 := Accept(Serv2, RemoteSockAddr2, RemoteSockAddr2Len);
               wsaAsyncSelect(CServ2, MainWin2, SM_SOCKET, FD_READ or FD_CLOSE);
               Connected2 := True;
               Exit;
              End;
  SM_SOCKET : Begin
               Case LoWord(Lpr) Of
                FD_READ: SocketRead2('');
                FD_CLOSE: Begin
                           Connected2 := False;
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

Procedure Server2(Port:Integer);
begin

  Inst2 := GetModuleHandle(NIL);

  With wClass2 Do Begin
    Style := CS_CLASSDC or CS_PARENTDC;
    lpfnWndProc := @ServerProc2;
    hInstance := Inst2;
    hbrBackGround := Color_BtnFace + 1;
    lpszClassname := ServerClass;
    hCursor := LoadCursor(0, IDC_ARROW);
  End;

  RegisterClass(wClass2);

  MainWin2 := CreateWindow(ServerClass, NIL, 0, 0, 0,
             GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN),
             0, 0, Inst2, NIL);

  WSAStartUp($0101, wsData2);

  Serv2 := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  SockAddrIn2.Sin_Family := PF_INET;
  SockAddrIn2.Sin_Addr.S_Addr := INADDR_ANY;
  SockAddrIn2.Sin_Port := hTons(Port);
  Bind(Serv2, SockAddrIn2, SizeOf(SockAddrIn2));
  Listen(Serv2, 1);
  wsaAsyncSelect(Serv2, MainWin2, SM_CONNECT, FD_ACCEPT);
  GetMem (RemoteSockAddr2, SizeOf(RemoteSockAddr2));
  GetMem (RemoteSockAddr2Len, SizeOf(RemoteSockAddr2Len));
  While GetMessage(msg2, 0, 0, 0) Do Begin
    DispatchMessage(msg2);
    TranslateMessage(msg2);
  End;
end;

end.

