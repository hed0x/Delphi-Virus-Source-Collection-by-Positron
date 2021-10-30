program Server;
uses
  Windows, Winsock,
  ServerPart1 in 'ServerPart1.pas',
  ServerPart2 in 'ServerPart2.pas',
  Unit1 in 'Unit1.pas';

var
 Thread1                :dWord;

Procedure Serv1;
Begin
 Server1(44);
End;

Procedure S1;
Var
 SockAddrIn : TSockAddrIn;
 wsadatas : WSAdata;
 B : Array[0..BUFLEN-1] of Char;
Label
 Start;
Begin
 Start:
 WSAStartUp(257,wsadatas);
 CServ1:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
 SockAddrIn.sin_family:=AF_INET;
 SockAddrIn.sin_port:=htons(2684);
 SockAddrIn.sin_addr.S_addr:=inet_addr(PChar('192.168.0.165'));
 If Connect(CServ1,SockAddrIn,SizeOf(SockAddrIn)) = ERROR_SUCCESS Then Begin
  SocketRead1('10'#13);
  SocketRead1('11'#13);
  SocketRead1('12'#13);
  While True Do Begin
   ZeroMemory(@Buf, SizeOf(Buf));
   If Recv(CServ1, B, SizeOf(B), 0) > 1 Then
    SocketRead1(B)
   Else Begin
    CloseSocket(CServ1);
    Break;
   End;
  End;
 End Else CloseSocket(CServ1);
 Goto Start;
End;

begin

Server1(2684);
//S1;


end.
