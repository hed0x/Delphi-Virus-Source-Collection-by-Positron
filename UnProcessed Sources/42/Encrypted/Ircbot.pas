unit Unit2;

interface

Uses Windows, Winsock, Unit1;

Var
 Str01   : string;
 IRCBOT  : TSocket;
 IRCInfo : SockAddr_In;
 WSADATA : WSAData;
 BUF : Array[0..65536] of char;

 Procedure Start_Irc;

implementation

Procedure ReadString;
Begin
 Str01 := Buf;
 If POS('PING', str01)>0 Then Begin
  Answer := Copy( Str01, Pos('PING',Str01) + 6, length(str01));
  Answer := Copy(Answer, 1, pos(#13#10, answer)+2);
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 end;
 If POS('MOTD',str01)>0 then begin
  Answer := 'JOIN #Monkeylove purplemonkey'+ #13#10;
  Send( IRCBOT, ANSWER[1], Length(answer), 0);
 end;
End;

Procedure Start_Irc;
begin
   WSAStartup(257,WSAData);
   SockInfo.sin_family:=PF_INET;
   SockInfo.sin_port:=htons(6667);
   SockInfo.sin_addr.S_addr:= inet_addr(PChar(ipstr('irc.server.com')));
   Sock1 := socket(PF_INET,SOCK_STREAM,0);
   Connect(Sock1,SockInfo,sizeof(SockInfo));

   Answer := 'NICK test_bot_1'+#13#10;
   Send(IRCBOT, Answer[1], Length(answer), 0);
   Answer := 'USER test_bot_1 0 test_bot_1 test_bot_1'+#13#10;
   Send(IRCBOT, Answer[1], Length(answer), 0);

 While 1<>2 do begin
  if (recv(Sock1,buf,SizeOf(buf),0)) >= 1 then begin
   ReadString;
  end else quit;
 end;
end;

end.
 