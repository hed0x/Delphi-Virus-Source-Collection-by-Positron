program rbn;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, Winsock;

//------------- Server/Client Part

Procedure SendData(Sock: TSocket; Text: String);
Begin
  If Send(Sock, Text[1], Length(Text), 0) = -1 Then
    CloseSocket(Sock);
End;

function GetRemoteAddress(FSocket: TSocket): string;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
begin
  Size := sizeof(SockAddrIn);
  getpeername(FSocket, SockAddrIn, Size);
  Result := inet_ntoa(SockAddrIn.sin_addr);
end;

//------------- EOF Server/Client Part

//------------- Server Part

Procedure ServerRead(Sock: TSocket);
Var
  RecvBuf: Array[0..1600] Of Char;
  Data: String;
Begin

  WriteLn('Connection from '+GetRemoteAddress(Sock));
  While Recv(Sock, RecvBuf, SizeOf(RecvBuf), 0) > 0 Do
  Begin
    Data := String(RecvBuf);
    ZeroMemory(@RecvBuf, SizeOf(RecvBuf));

    WriteLn('Recv: '+Data);

    If Copy(Data,1,4) = 'SERV' Then
      WriteLn(GetRemoteAddress(Sock)+': '+Data);

    If Data = 'HELO' Then
      SendData(Sock, 'SERV VERS 1.0');
  End;
  WriteLn('Disconnection from '+GetRemoteAddress(Sock));
  CloseSocket(Sock);

End;

Procedure Server;
Const
  Port = 86;
Var
  Size: Integer;
  Sock: TSocket;
  Rmte: TSocket;
  AdIn: TSockAddr;
  Addr: TSockAddrIn;
  Wsa : TWSAData;
Begin
  WSAStartUp(257, WSA);

    Sock := Socket(PF_INET, 1, 0);
    Addr.sin_family := AF_INET;
    Addr.sin_port := hTons(Port);
    Addr.sin_addr.S_addr := INADDR_ANY;

    Bind(Sock, Addr, SizeOf(Addr));

    Winsock.Listen(Sock, 5);

    Repeat
      Size := SizeOf(TSockAddr);
      If Sock <> INVALID_SOCKET Then
      Begin
        Rmte := Winsock.Accept(Sock, @Addr, @Size);
        ServerRead(Rmte);
        Rmte := INVALID_SOCKET;
      End;
    Until Sock = INVALID_SOCKET;
  WSACleanUp;
End;

//------------- EOF Server part

//------------- Client part

Procedure Client;
Var
  WSA  : TWSAData;
  Sock : TSocket;
  Addr : TSockAddrIn;
  Ip   : String;

  Buff : Array[0..1600] Of Char;
  Data : String;
Begin
  WSAStartUp(257, WSA);
  Repeat
//    IP := IntToStr(Random(255))+'.'+IntToStr(Random(255))+'.'+IntToStr(Random(255))+'.'+IntToStr(Random(255));
    IP := '127.0.0.1';

    Sock := INVALID_SOCKET;
    Sock := Socket(AF_INET, 1, 0);

    Addr.sin_family := AF_INET;
    Addr.sin_port := hTons(86);
    Addr.sin_addr.S_addr := inet_addr(pchar(ip));

    If Connect(Sock, Addr, SizeOf(Addr)) > 0 Then
    Begin
      WriteLn('Connection Accepted By '+ip);

      SendData(Sock, 'HELO');

      Recv(Sock, Buff, SizeOf(Buff), 0);
      Data := String(Buff);
      FillChar(Buff, SizeOf(Buff), #0);

      SendData(Sock, 'SERV VERS 1.0');
      Recv(Sock, Buff, SizeOf(Buff), 0);
    End;
  Until False;
  WSACleanUp;
End;

//------------- EOF Client part

begin

  WriteLn('Real BotNet Test');
  WriteLn('Written by p0ke');
  WriteLn;WriteLn;WriteLn;

  If ParamStr(1) = '+s' Then
  Begin
    WriteLn('Server Listening on port 86');
    WriteLn;
    Server;
  End Else
  If ParamStr(1) = '+c' Then
  Begin
    WriteLn('Client scanning is on');
    WriteLn;
    Client;
  End;

  WriteLn('You have to choose if you want to run the server or the client.');
  WriteLn('To do this, launch the application with either +c or +s parameters.');
  WriteLn('Exemple: application.exe +c');
  WriteLn('this starts client.');
  WriteLn('Example: application.exe +s');
  WriteLn('this starts server.');

  ReadLn;
end.
