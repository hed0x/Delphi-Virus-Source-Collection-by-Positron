unit Unit7;

interface

CONST
 // INFO PART
 INFO_COMPUTER  : integer = 11;
 INFO_OS        : integer = 10;
 MAKE_BAT       : integer = 12;
 INFO_SERVER    : integer = 13;

 // TRANSFER PART
 TRANSFER_CANCEL: integer = 14;

 // MANAGER PART  '
 // FILE
 FILE_GETDRIVES : integer = 15;
 FILE_REFRESH   : integer = 16;
 FILE_DELETE    : integer = 17;
 FILE_DELETEDIR : integer = 18;
 FILE_EXECUTE   : integer = 19;
 FILE_UPLOAD    : integer = 20;
 FILE_DOWNLOAD  : integer = 21;
 // PROCESS
 PROCESS_REFRESH: integer = 22;
 PROCESS_KILL   : integer = 23;
 // WINDOW

 WIN_CAPTION    : integer = 24;
 WIN_HIDE       : integer = 25;
 WIN_SHOW       : integer = 26;
 WIN_CLOSE      : integer = 27;
 WIN_REFRESH    : integer = 28;

 // CONFIG SERV
 // SETTINGS
 SERV_TRAFFICP  : integer = 29;
 SERV_TRANSP    : integer = 30;
 SERV_AUTOSTART : integer = 31;
 SERV_REGKEY    : integer = 32;
 SERV_REGVALUE  : integer = 33;
 SERV_WINNAME   : integer = 34;
 SERV_SYSNAME   : integer = 35;
 SERV_SETTINGS  : integer = 36;
 // NOTIFICATION
 IRC_NICK1      : integer = 37;
 IRC_NICK2      : integer = 38;
 IRC_CHAN1      : integer = 39;
 IRC_CHAN2      : integer = 40;
 IRC_SERV1      : integer = 41;
 IRC_SERV2      : integer = 42;
 IRC_CKEY1      : integer = 43;
 IRC_CKEY2      : integer = 44;
 IRC_MASTER1    : integer = 45;
 IRC_MASTER2    : integer = 46;
 IRC_SETTINGS   : integer = 47;
 SERV_CGI       : integer = 48;
 SERV_PHP       : integer = 50; 
 // SECURE
 PASSWORD_SAVE  : integer = 49;
 REG_REFRESH_DIR: integer = 53;
 REG_DELETE_KEY : integer = 54;
 REG_DELETE_VAL : integer = 55;
 REG_SET_VAL    : integer = 56;
 REG_GET_VAL    : integer = 57;

implementation

end.
