unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ScktComp, Registry, ShellApi;

const
  WM_CAllBack = WM_USER;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressBar1: TProgressBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ListView1: TListView;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListView2: TListView;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Label2: TLabel;
    Button9: TButton;
    ListView3: TListView;
    Label4: TLabel;
    Button10: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Button11: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Button12: TButton;
    CheckBox2: TCheckBox;
    Button13: TButton;
    GroupBox2: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    balle: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    count_declare: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    count_vars: TLabel;
    Memo3: TMemo;
    count_consts: TLabel;
    Memo4: TMemo;
    count_types: TLabel;
    Memo5: TMemo;
    count_snippet: TLabel;
    Button19: TButton;
    Button20: TButton;
    Label9: TLabel;
    Label11: TLabel;
    Button21: TButton;
    Update: TClientSocket;
    Submit: TClientSocket;
    up: TLabel;
    Edit2: TEdit;
    Label10: TLabel;
    Edit3: TEdit;
    Button22: TButton;
    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    Exit1: TMenuItem;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    Edit4: TEdit;
    Label12: TLabel;
    Timer2: TTimer;
    procedure Button9Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
    procedure Memo4Change(Sender: TObject);
    procedure Memo5Change(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure UpdateList;
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListView2Click(Sender: TObject);
    procedure ListView2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button10Click(Sender: TObject);
    procedure UpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UpdateConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure UpdateDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UpdateError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure UpdateRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button11Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button22Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WM_CALLBACKPRO(var msg : TMessage); message wm_callBack;
    procedure Exit1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure SubmitConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SubmitConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure SubmitDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SubmitError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Button19Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    Function  FixThing:String;
    Function  FilePart(Part:Integer; FileName:String):String;
    Function  FixVars(C:Integer):String;
    Function  GetSex(FileName:String):String;
  private
    { Private declarations }
  public
    { Public declarations }
    Str_ : String;
  end;

var
  Form1: TForm1;
  Path : String;

  blah : HICON;
  TrayIcon : TNotifyIconData;

implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}

 Function TForm1.FilePart(Part:Integer; FileName:String):String;
 Var
   F   :File;
   Buf :String;
   I   :Integer;
 Begin

   {$i-}

    AssignFile(F, FileName);
    FileMode := 0;
    Reset(F, 1);
//    Buf := '';
    ZeroMemory(@Buf, SizeOf(F));
    SetLength(Buf, SizeOf(F));
    BlockRead(F, Buf[1], SizeOf(F));
    CloseFile(F);

   {$i+}

    Case Part Of

     0 : Result := Copy(Buf, Pos('!----![VARS]!----!',    Buf)+18, Length(Buf));
     1 : Result := Copy(Buf, Pos('!----![PUBLIC]!----!',  Buf)+20, Length(Buf));
     2 : Result := Copy(Buf, Pos('!----![SNIPPET]!----!', Buf)+21, Length(Buf));
     3 : Result := Copy(Buf, Pos('!----![USES]!----!',    Buf)+18, Length(Buf));
     4 : Result := Copy(Buf, Pos('!----![TYPE]!----!',    Buf)+18, Length(Buf));
     5 : Result := Copy(Buf, Pos('!----![DECLARE]!----!', Buf)+21, Length(Buf));

    End;

    If Copy(Result,1,2) = #13#10 Then
     Result := Copy(Result, 3, Length(Result));

    Case Part Of

    0 : Result := Copy(Result,1 , Pos('!----![VARS]!----!',    Result)-1);
    1 : Result := Copy(Result,1 , Pos('!----![PUBLIC]!----!',  Result)-1);
    2 : Result := Copy(Result,1 , Pos('!----![SNIPPET]!----!', Result)-1);
    3 : Result := Copy(Result,1 , Pos('!----![USES]!----!',    Result)-1);
    4 : Result := Copy(Result,1 , Pos('!----![TYPE]!----!',    Result)-1);
    5 : Result := Copy(Result,1 , Pos('!----![DECLARE]!----!', Result)-1);

    End;

 End;

 Function TForm1.FixThing:String;
 Var
   Tmp:String;
   I  :Integer;
   Us :Array[0..36000] Of String;
   Nr :Integer;
   Str:String;
 Begin

   For I := 0 To ListView1.Items.Count -1 Do

   If ListView1.Items[i].Selected Then
    Tmp := Tmp + FilePart(3, Path + ListView1.Items[i].Caption);

   Nr  := 0;
   Str := '';
   For I := 1 To Length(Tmp) Do
    If Pos(LowerCase(Copy(Tmp, I, 1)), 'abcdefghijklmnopqrstuvwxyz_-1234567890')=0 Then Begin
     If Str <> '' Then Begin
      Us[Nr] := Str;
      Inc(Nr);
      Str := '';
     End;
    End
    Else Str := Str + LowerCase(Copy(Tmp, I, 1));

   Result := '';
   For I := 0 To 36000 Do Begin
     If Us[I] = '' Then Break;

     
     If Pos(LowerCase(Us[i]+','), LowerCase(Result))=0 Then
      Result := Result + UpperCase(Copy(Us[i],1,1)) + LowerCase(Copy(Us[i],2,Length(Us[i]))) + ', ';

   End;

   Result := Copy(Result, 1, Length(Result) -2);
   Result := Result + ';';

 End;

 Function TForm1.FixVars(C:Integer):String;
 Var
 Tmp:String;
 I  :Integer;
 Us :Array[0..36000] Of String;
 Nr :Integer;
 Str:String;
 Tmp2:String;
 Tmp3:String;
 Begin

 For I := 0 To ListView1.Items.Count -1 Do

 If ListView1.Items[i].Selected Then
  Tmp := Tmp + FilePart(C, Path + ListView1.Items[i].Caption);

 Nr  := 0;
 Str := '';
 
 While Pos(#13#10, Tmp)>0 Do
  Delete(Tmp, Pos(#13#10, Tmp), 2);
 
 Result := '';

 While Tmp <> '' Do Begin
   Str := Copy(Tmp, 1, Pos(':', Tmp)-1)+'?';
   Tmp := Copy(Tmp, Pos(':', Tmp)+1, Length(Tmp));
   Tmp2 := Copy(Tmp, 1, Pos(';', Tmp)-1);
   Tmp := Copy(Tmp, Pos(';', Tmp)+1, Length(Tmp));

   Tmp3 := '';
   For I := 1 To Length(Str) Do
   If Pos(LowerCase(Copy(Str, I, 1)), 'abcdefghijklmnopqrstuvwxyz_-0123456789')=0 Then Begin
     If Tmp3 <> '' Then Begin
       Us[Nr] := Tmp3;
       Tmp3 := '';
       Inc(Nr);
     End;
   End Else Tmp3 := Tmp3 + LowerCase(Copy(Str, I, 1));

   For I := 0 To 36000 Do Begin
     If Us[I] = '' Then Break;

     If Pos(LowerCase(Us[i]+':'), LowerCase(Result))=0 Then
      Result := Result + UpperCase(Copy(Us[i], 1, 1)) + LowerCase(Copy(Us[i], 2, Length(Us[i])))+':'+
      UpperCase(Copy(Tmp2, 1, 1)) + LowerCase(Copy(Tmp2, 2, Length(Tmp2))) +';'#13#10;

   End;
 End;
 
 End;

procedure TForm1.WM_CALLBACKPRO(var msg : TMessage);
var
p : TPoint;
begin
case msg.LParam of
WM_LBUTTONDOWN :
begin
Shell_NotifyIcon(NIM_DELETE,@TrayIcon);
Form1.Visible := True;
end;
WM_RBUTTONDOWN :
begin
//Shell_NotifyIcon(NIM_DELETE,@TrayIcon);
GetCursorPos(p);
Popupmenu1.Popup(p.x,p.y); 
end;
end;
end;

procedure TForm1.UpdateList;
Var
 SR:TSearchRec;
 item:TListItem;
 i:integer;
 F:TextFile;
 T:String;
Begin
 ListView1.Items.Clear;
 ListView2.Items.Clear;

 If FindFirst(Path+'*.snp', faDirectory, SR) = 0 then
  Repeat
   item := listview1.Items.Add;
   item.Caption := sr.Name;
   item.SubItems.Add(IntToStr(SR.Size));
   item.SubItems.Add('');
   item.SubItems.Add('');
  Until FindNext(SR) <> 0;
 FindClose(SR);

 ProgressBar1.Max := ListView1.Items.Count;
 For I :=0 to ListView1.Items.Count -1 Do Begin
  ProgressBar1.Position := I;
  AssignFile(F, Path + ListView1.Items[i].Caption);
  Reset(F);
//  ListView1.Items[i].SubItems[0] := IntToStr(FileSize(F));
  Read(F, T);
  ListView1.Items[i].SubItems[2] := Copy(T, Pos(':',T)+2, Length(T));
  ReadLn(F, T);
  Read(F, T);
  ListView1.Items[i].SubItems[1] := Copy(T, Pos(':',T)+2, Length(T));
  ReadLn(F, T);
  CloseFile(F);

  Item := ListView2.Items.Add;
  Item.Caption := ListView1.Items[i].Caption;
  Item.SubItems.Add(ListView1.Items[i].SubItems[0]);
  Item.SubItems.Add(ListView1.Items[i].SubItems[1]);
  Item.SubItems.Add(ListView1.Items[i].SubItems[2]);
 End;
 ProgressBar1.Position := 0;

End;

procedure TForm1.Button9Click(Sender: TObject);
begin
 MessageBox(0,
 'Mark the file(s) you want to use in your own source before build.','Help',mb_ok);
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
 count_declare.Caption :=
 inttostr(memo1.CaretPos.Y)+':'+
 inttostr(memo1.CaretPos.X)+' ['+
 inttostr(memo1.Lines.Count)+' lines; '+
 inttostr(length(memo1.text))+' chars]';
end;

procedure TForm1.Memo2Change(Sender: TObject);
begin
 count_vars.Caption :=
 inttostr(memo2.CaretPos.Y)+':'+
 inttostr(memo2.CaretPos.X)+' ['+
 inttostr(memo2.Lines.Count)+' lines; '+
 inttostr(length(memo2.text))+' chars]';
end;

procedure TForm1.Memo3Change(Sender: TObject);
begin
 count_consts.Caption :=
 inttostr(memo3.CaretPos.Y)+':'+
 inttostr(memo3.CaretPos.X)+' ['+
 inttostr(memo3.Lines.Count)+' lines; '+
 inttostr(length(memo3.text))+' chars]';
end;

procedure TForm1.Memo4Change(Sender: TObject);
begin
 count_types.Caption :=
 inttostr(memo4.CaretPos.Y)+':'+
 inttostr(memo4.CaretPos.X)+' ['+
 inttostr(memo4.Lines.Count)+' lines; '+
 inttostr(length(memo4.text))+' chars]';
end;

procedure TForm1.Memo5Change(Sender: TObject);
begin
 count_snippet.Caption :=
 inttostr(memo5.CaretPos.Y)+':'+
 inttostr(memo5.CaretPos.X)+' ['+
 inttostr(memo5.Lines.Count)+' lines; '+
 inttostr(length(memo5.text))+' chars]';
end;

procedure TForm1.Button20Click(Sender: TObject);
var
 str:string;
begin
 str := '1. Submit'#13#10'This will connect to p0ke.no-ip.com'#13#10+
        'and post all code'#13#10#13#10'2. Upload a new .pas'#13#10+
        'This does same, but is used for a side-off .pas file.'#13#10+
        'Good for a new library, example : ircbot.pas';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button12Click(Sender: TObject);
var
 str:string;
begin
 str := 'Removes all comments that will'#13#10'be found while building source';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button13Click(Sender: TObject);
var
 str:string;
begin
 str := 'Check for new updates every ten minute';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button15Click(Sender: TObject);
var
 str:string;
begin
 str := 'Saves windows position for next startup';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button16Click(Sender: TObject);
var
 str:string;
begin
 str := 'Checks for snippet-update on every startup';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button17Click(Sender: TObject);
var
 str:string;
begin
 str := 'This will show a message on the screen'#13#10'everytime a new update is found';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button18Click(Sender: TObject);
var
 str:string;
begin
 str := 'When minimize a icon will be inserted in system tray'#13#10'instead of statusbar.';
 MessageBox(0, pChar(Str), 'Help', mb_ok);
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView1.Items.Count -1 Do
  If ListView1.Items[i].Selected Then Inc(Nr);
 If ListView1.ItemIndex = -1 Then Exit;

 If Nr = 1 Then
  FileName := ListView1.ItemFocused.Caption
 Else
  FileName := 'these files';

 If
 MessageBox(0,
 pChar('Are you sure you want to remove '+FileName+' ?'),
 'Information', mb_yesno) = ID_YES Then
 For I := 0 to ListView1.Items.Count-1 Do
  If ListView1.Items[i].Selected Then
   DeleteFile(pChar(Path+ListView1.Items[i].Caption));
 UpdateList;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
 Reg:TRegIniFile;
 Settings,
 WH,Ip,Port:String;
begin
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Library\';
 If Not DirectoryExists(Path) Then
  CreateDirectory(pChar(Path), NIL);
 UpdateList;
 If CheckBox4.Checked Then
  Timer2.Enabled:=true;

 Reg := TRegIniFile.Create;
 Reg.RootKey := HKEY_LOCAL_MACHINE;
 If Reg.KeyExists('Software\WormGen31') Then Begin
  Settings := Reg.ReadString('Software\WormGen31','Settings','');
  IP := Reg.ReadString('Software\WormGen31','Ip','');
  Port := Reg.ReadString('Software\WormGen31','Port','');
  WH := Reg.ReadString('Software\WormGen31','WH','');

  Form1.Left := StrToInt(Copy(wh, 1, pos(':',wh)-1));
  Form1.Top := StrToInt(Copy(wh, pos(':',wh)+1, Length(wh)));

  Edit2.Text := Ip;
  Edit3.Text := Port;

  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;

  If Copy(Settings, 1, 1) = '1' Then CheckBox1.Checked := True;
  If Copy(Settings, 2, 1) = '1' Then CheckBox2.Checked := True;
  If Copy(Settings, 2, 1) = '1' Then Timer1.Enabled := True;
  If Copy(Settings, 3, 1) = '1' Then CheckBox3.Checked := True;
  If Copy(Settings, 4, 1) = '1' Then CheckBox4.Checked := True;
  If Copy(Settings, 5, 1) = '1' Then CheckBox5.Checked := True;
  If Copy(Settings, 6, 1) = '1' Then CheckBox6.Checked := True;

 End;
 Reg.Free;

end;

procedure TForm1.Button3Click(Sender: TObject);
Var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView1.Items.Count -1 Do
  If ListView1.Items[i].Selected Then Inc(Nr);
 If Nr > 1 Then Exit;
 If ListView1.ItemIndex = -1 Then Exit;
 FileName := ListView1.ItemFocused.Caption;

 Form2.Label2.Caption := 'Library\'+FileName;
 Form2.Edit1.Text := 'newname';
 Form2.Show;
 UpdateList;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView1.Items.Count -1 Do
  If ListView1.Items[i].Selected Then Inc(Nr);
 If Nr > 1 Then Exit;
 If ListView1.ItemIndex = -1 Then Exit;
 FileName := ListView1.ItemFocused.Caption;

 Form3.Memo1.Text := ListView1.itemFocused.SubItems[1];
 Form3.Label2.Caption := FileName;
 Form3.Show;
  UpdateList;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Panel1.Caption := 'File: '+Edit1.Text+'.dpr';
end;

procedure TForm1.Button6Click(Sender: TObject);
Var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView2.Items.Count -1 Do
  If ListView2.Items[i].Selected Then Inc(Nr);
 If ListView2.ItemIndex = -1 Then Exit;

 If Nr = 1 Then
  FileName := ListView2.ItemFocused.Caption
 Else
  FileName := 'these files';

 If
 MessageBox(0,
 pChar('Are you sure you want to remove '+FileName+' ?'),
 'Information', mb_yesno) = ID_YES Then
 For I := 0 to ListView2.Items.Count-1 Do
  If ListView2.Items[i].Selected Then
   DeleteFile(pChar(Path+ListView2.Items[i].Caption));
 UpdateList;
end;

procedure TForm1.Button7Click(Sender: TObject);
Var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView2.Items.Count -1 Do
  If ListView2.Items[i].Selected Then Inc(Nr);
 If Nr > 1 Then Exit;
 If ListView2.ItemIndex = -1 Then Exit;
 FileName := ListView2.ItemFocused.Caption;

 Form2.Label2.Caption := 'Library\'+FileName;
 Form2.Edit1.Text := 'newname';
 Form2.Show;
 UpdateList;
end;

procedure TForm1.Button8Click(Sender: TObject);
Var
 FileName:String;
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView2.Items.Count -1 Do
  If ListView2.Items[i].Selected Then Inc(Nr);
 If Nr > 1 Then Exit;
 If ListView2.ItemIndex = -1 Then Exit;
 FileName := ListView2.ItemFocused.Caption;

 Form3.Memo1.Text := '';
 Form3.Label2.Caption := FileName;
 Form3.Show;
  UpdateList;
end;

procedure TForm1.ListView2Click(Sender: TObject);
Var
 Nr:Integer;
 I :Integer;
begin
 If ListView2.ItemIndex = -1 Then
  Label2.Caption := 'No file selected.'
 Else Begin
  Nr := 0;
  For I := 0 To ListView2.Items.Count -1 Do
   If ListView2.Items[i].Selected Then Nr := Nr + 1;
  Label2.Caption := IntToStr(Nr) + ' file(s) selected';
 End;
end;

procedure TForm1.ListView2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
 Nr:Integer;
 I :Integer;
begin
 If ListView2.ItemIndex = -1 Then
  Label2.Caption := 'No file selected.'
 Else Begin
  Nr := 0;
  For I := 0 To ListView2.Items.Count -1 Do
   If ListView2.Items[i].Selected Then Nr := Nr + 1;
  Label2.Caption := IntToStr(Nr) + ' file(s) selected';
 End;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
 If Update.Active Then Exit;
 ListView3.Items.Clear;
 Up.Caption := 'GU';
 Panel5.Caption := ' Connecting';
 Update.Host := Edit2.text;
 Update.Port := StrToInt(Edit3.text);
 Update.Active := True;
end;

procedure TForm1.UpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
var
 tmp:string;
begin
 Panel5.Caption := ' Connected';
 Panel4.Caption := ' 50%';
 If Up.Caption = 'GU' Then Socket.SendText('GU') Else
 If Copy(Up.Caption,1,2) = 'IN' Then
  Socket.SendText(Up.Caption)
 Else
 Socket.Close;
 Up.Caption := '';
end;

procedure TForm1.UpdateConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Panel5.Caption := ' Connecting';
 Panel4.Caption := ' 20%';
end;

procedure TForm1.UpdateDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Panel5.Caption := ' Disconnected';
 Panel4.Caption := ' 0%';
end;

procedure TForm1.UpdateError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 ErrorCode := 0;
 Panel5.Caption := ' Disconnected';
 Panel4.Caption := ' 0%';
end;

procedure TForm1.UpdateRead(Sender: TObject; Socket: TCustomWinSocket);
var
 Data:String;
 Item:TListItem;
 Tmp :String;

 F   :TextFile;

 Name,
 Size,
 Desc,
 Fil,
 By  :String;
 nr:integer;
begin
 Data := Socket.ReceiveText;

 If Copy(Data, 1, 2) = '&_' Then Begin
  Data := Copy(Data, 3, Length(Data));
  Panel5.Caption := 'Installling';

  Tmp := Data;

  Fil := Copy(Tmp, 1, Pos(#0160, Tmp)-1);
  Tmp := Copy(Tmp, Pos(#0160, Tmp)+1, Length(Tmp));
  AssignFile(f, Path+Fil);
  ReWrite(F);
  Write(F, Tmp);
  CloseFile(F);

  Socket.Close;
  Panel5.Caption := 'Done';
  UpdateList;
  Exit;
 End;

 Panel4.Caption := ' 100%';
 Socket.Close;

 nr := 0;
 While Data <> '' Do Begin
  Tmp := Copy(Data, 1, Pos(#13#10, Data)-1);
  If Not FileExists(Path+Copy(Tmp,1,pos(#0160,tmp)-1)) Then Begin
   Tmp := Data;
   Item := ListView3.Items.Add;
   Name := Copy(Tmp, 1, Pos(#0160, Tmp)-1);
   Tmp := Copy( Tmp, Pos(#0160, Tmp)+1, Length(Tmp));
   Size := Copy(Tmp, 1, Pos(#0160, Tmp)-1);
   Tmp := Copy( Tmp, Pos(#0160, Tmp)+1, Length(Tmp));
   By  := Copy(Tmp, 1, Pos(#0160, Tmp)-1);
   Tmp := Copy( Tmp, Pos(#0160, Tmp)+1, Length(Tmp));
   Desc  := Copy(Tmp, 1, Pos(#0160, Tmp)-1);
   Tmp := Copy( Tmp, Pos(#0160, Tmp)+1, Length(Tmp));
   Item.Caption := Name;
   Item.SubItems.Add(Size);
   Item.SubItems.Add(Desc);
   Item.SubItems.Add(By);
   Inc(Nr);
  End;
  Data := Copy(Data, Pos(#13#10, Data)+2, Length(Data));
 End;
 Panel4.Caption := ' 0%';
 Label4.Caption := IntToStr(NR)+' New updates';
 If Nr > 0 Then
  If (Form1.Visible = False) And
     (CheckBox5.Checked) Then Begin
      Form4.Label1.Caption := IntToStr(Nr)+' new updates for download';
      Form4.top := (Screen.Height - Form4.Height) - 60;
      Form4.Left := Screen.Width - form4.width;
      Form4.Timer1.Enabled := true; 
      Form4.Show;
     End;

end;

procedure TForm1.Button11Click(Sender: TObject);
Var
 I       :Integer;
 Nr      :Integer;
begin
 Nr := 0;
 For I := 0 To ListView3.Items.Count -1 Do
  If ListView3.Items[i].Selected Then Inc(Nr);
 If Update.Active Then Exit;
 If ListView3.ItemIndex = -1 Then Exit;
 Up.Caption := '';
 If Nr = 1 Then
  Up.Caption := 'IN'+ListView3.ItemFocused.Caption
 Else
  Exit;

 Panel5.Caption := ' Connecting';
 Update.Host := Edit2.text;
 Update.Port := StrToInt(Edit3.text);
 Update.Active := True;
 ListView3.ItemFocused.Delete;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
 CheckBox1.Checked := False;
 CheckBox2.Checked := True;
 CheckBox3.Checked := True;
 CheckBox4.Checked := True;
 CheckBox5.Checked := False;
 CheckBox6.Checked := False;

 Edit2.Text := 'p0ke.no-ip.com';
 Edit3.Text := '23064';

 Button22Click(Self);

end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
 If Pos(Key, '123456789'#8) = 0 Then
  ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.Button22Click(Sender: TObject);
var
 Reg:TRegIniFile;
 Str:String;
begin
 Reg := TRegIniFile.Create;
 Reg.RootKey := HKEY_LOCAL_MACHINE;
 If Not Reg.KeyExists('Software\WormGen31') Then
  Reg.CreateKey('Software\WormGen31');
 Str := '';
 If Not CheckBox1.Checked Then Str := Str + '0' Else Str := Str + '1';
 If Not CheckBox2.Checked Then Str := Str + '0' Else Str := Str + '1';
 If Not CheckBox3.Checked Then Str := Str + '0' Else Str := Str + '1';
 If Not CheckBox4.Checked Then Str := Str + '0' Else Str := Str + '1';
 If Not CheckBox5.Checked Then Str := Str + '0' Else Str := Str + '1';
 If Not CheckBox6.Checked Then Str := Str + '0' Else Str := Str + '1';
 Reg.WriteString('Software\WormGen31','Settings',Str);
 Reg.WriteString('Software\WormGen31','WH',IntToStr(Form1.Width)+':'+IntToStr(Form1.Height));
 Reg.WriteString('Software\WormGen31','IP',Edit2.text);
 Reg.WriteString('Software\WormGen31','Port',Edit3.text);
 Reg.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
 Reg:TRegIniFile;
 Str:String;
begin
 If Not CheckBox3.Checked Then Exit;
 Reg := TRegIniFile.Create;
 Reg.RootKey := HKEY_LOCAL_MACHINE;
 If Reg.KeyExists('Software\WormGen31') Then
  Reg.WriteString('Software\WormGen31','WH',IntToStr(Form1.Left)+':'+IntToStr(Form1.Top));
 Reg.Free;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Shell_NotifyIcon(NIM_DELETE,@TrayIcon);
 ExitProcess(0);
end;

procedure TForm1.Show1Click(Sender: TObject);
begin
 Form1.Visible := true;
 Shell_NotifyIcon(NIM_DELETE,@TrayIcon);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 If CheckBox6.Checked Then Begin
   CanClose := false;
   blah := application.Icon.Handle;

   Trayicon.cbSize := SizeOf(TNotifyIconData);
   Trayicon.Wnd := handle;
   Trayicon.szTip := 'WormGen 3.1';
   Trayicon.uID := 1;
   TrayIcon.hIcon := blah;
   TrayIcon.uCallbackMessage := WM_CAllBack;
   Trayicon.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;

   Shell_NotifyIcon(NIM_ADD,@trayicon);

   Form1.Visible := False;
 End;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Button10Click(Self);
end;

procedure TForm1.SubmitConnect(Sender: TObject; Socket: TCustomWinSocket);
var
 str:string;
begin
 Label8.Caption := 'Connected';

 Str := 'Author: '+Form5.edit1.text+#13#10;
 Str := Str + 'Description: '+Form5.edit2.text+#13#10;
 Str := Str + '!----![USES]!----!'#13#10    + Edit4.Text + #13#10'!----![USES]!----!'   + #13#10;
 Str := Str + '!----![PUBLIC]!----!'#13#10  + Memo3.text + #13#10'!----![PUBLIC]!----!' + #13#10;
 Str := Str + '!----![VARS]!----!'#13#10    + Memo2.Text + #13#10'!----![VARS]!----!'   + #13#10;
 Str := Str + '!----![SNIPPET]!----!'#13#10 + Memo5.Text + #13#10'!----![SNIPPET]!----!'+ #13#10;
 Str := Str + '!----![TYPE]!----!'#13#10    + Memo4.Text + #13#10'!----![TYPE]!----!'   + #13#10;
 Str := Str + '!----![DECLARE]!----!'#13#10 + Memo1.Text + #13#10'!----![DECLARE]!----!'+ #13#10;

 Socket.SendText('ADD'+Form5.Edit3.text+#0160+Str);
 Socket.Close;
 Form5.Hide;
end;

procedure TForm1.SubmitConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Label8.Caption := 'Connecting';
end;

procedure TForm1.SubmitDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Label8.Caption := 'Disconnected';
end;

procedure TForm1.SubmitError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 ErrorCode := 0;
 Label8.Caption := 'Disconnected (Error)';
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
 Form5.Edit3.Enabled := True;
 Form5.Edit3.Text := 'Unknown.snp';
 Form5.Show;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
 If OpenDialog1.Execute Then
  Form5.Edit3.Text := ExtractFileName(OpenDialog1.FileName);
 Form5.Edit3.Enabled := False;
 Form5.Show;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 button10click(self);
 timer2.enabled := False;
end;

Function TForm1.GetSex(FileName:String):String;
Var
 F:File;
 Buf:String;
 Bu2:String;
 Tmp :String;
 Tmp2:String;
Begin

 {$i-}

  AssignFile(F, Path+FileName);
  FileMode:=0;
  Reset(F, 1);
  ZeroMemory(@Buf, Length(Buf));
  SetLength(Buf, SizeOf(F));
  BlockRead(F, Buf[1], SizeOf(F));
  CloseFile(F);

 {$i+}

 Bu2 := Buf;

 While Pos('function ',LowerCase(Buf))>0 Do Begin
   Tmp := Copy(Buf, Pos('function ',LowerCase(Buf)), Length(Buf));

   If (Pos(';', tmp) > Pos('(', tmp)) Then Begin

     Tmp2 := Copy(Tmp, Pos('(', Tmp), Length(Tmp));
     Tmp2 := Copy(Tmp2, 1, Pos(';', Tmp2));
     Tmp  := Copy(Tmp, 1, Pos('(', Tmp)-1);

     Tmp := Tmp + Tmp2;

   End Else Begin
    Tmp := Copy(Tmp, 1, Pos(';', Tmp));
   End;

   Result := Result + Trim(Tmp) + #13#10;

   Buf := Copy(Buf, Pos('function ',LowerCase(Buf))+1, Length(Buf));
 End;

 While Pos('procedure',LowerCase(Bu2))>0 Do Begin
   Tmp := Copy(Bu2, Pos('procedure',LowerCase(Bu2)), Length(Bu2));

   If (Pos(';', tmp) > Pos('(', tmp)) Then Begin

     Tmp2 := Copy(Tmp, Pos('(', Tmp), Length(Tmp));
     Tmp2 := Copy(Tmp2, 1, Pos(';', Tmp2));
     Tmp  := Copy(Tmp, 1, Pos('(', Tmp)-1);

     Tmp := Tmp + Tmp2;

   End Else Begin
    Tmp := Copy(Tmp, 1, Pos(';', Tmp));
   End;

   Result := Result + Trim(Tmp) + #13#10;

   Buf := Copy(Buf, Pos('procedure',LowerCase(Buf))+1, Length(Buf));
 End;



End;

procedure TForm1.Button5Click(Sender: TObject);
var
 G:THandle;
 i:integer;
 P:DWorD;
 Str:String;
 fname:string;
 TMP:String;
 AllFunc:String;
begin
// MessageBox(0, pChar('Uses'#13#10+FixThing), '', mb_ok);
// MessageBox(0, pChar('Var'#13#10+FixVars(0)), '', mb_ok);
// MessageBox(0, pChar('Const'#13#10+FixVars(1)), '', mb_ok);

 fname := ExtractFilePath(Copy(Path, 1, Length(Path)-1))+Copy(Form1.Panel1.Caption, pos(':',Form1.Panel1.Caption)+2, length(Form1.panel1.caption));
 Str := 'Program '+extractfilename(fname)+';'#13#10#13#10;

 I := 0;
 For I := 0 to ListView1.Items.Count-1 Do
  If ListView1.items[i].Selected Then
   AllFunc := AllFunc + #13#10 + GetSex(listview1.items[i].caption);

 I := 0;
 For I := 0 to ListView1.Items.Count-1 Do
  If ListView1.items[i].Selected Then
   Tmp := Tmp + #13#10 + FilePart(4, listview1.items[i].caption);

 If Tmp <> #13#10#13#10 Then
 Str := Str + '{Types}'#13#10+
        Tmp+#13#10#13#10;
 Tmp := '';
 If FixVars(1) <> '' Then
 Str := Str + 'Const'#13#10+
        FixVars(1)+#13#10#13#10;

 Str := Str + 'Uses'#13#10 + fixthing+#13#10#13#10;
 If FixVars(0) <> '' Then
 Str := Str + 'Var'#13#10+
        FixVars(0)+#13#10#13#10;
 I := 0;
 For I := 0 to ListView1.Items.Count-1 Do
  If ListView1.items[i].Selected Then
   Tmp := Tmp + #13#10 + FilePart(5, listview1.items[i].caption);

 If Tmp <> #13#10#13#10 Then
 Str := Str + '{Declares}'#13#10+
        TMP+#13#10#13#10;
 Tmp := '';
 I := 0;
 For I := 0 to ListView1.Items.Count-1 Do
  If ListView1.items[i].Selected Then
   Str := Str + FilePart(2, listview1.items[i].caption) + #13#10;

// Str := Str + TMP+#13#10;
 Tmp := '';
 Str := Str +
 'Begin'#13#10+
 ''#13#10+
 '{ I Leave this part for you, i aint gonna do all work. }'#13#10+
 '{'#13#10+
 AllFunc+
 '}'#13#10+
 ''#13#10+
 'End;';
 Str_ := Str;
 While Pos(#13#10#13#10#13#10, Str_)>0 Do
  Delete(Str_, Pos(#13#10#13#10#13#10, Str_), 2);

 If FileExists(
 pChar(ExtractFilePath(Copy(Path, 1, Length(Path)-1))+Copy(Form1.Panel1.Caption, pos(':',Form1.Panel1.Caption)+2, length(Form1.panel1.caption)))
 ) Then DeleteFile(
 pChar(ExtractFilePath(Copy(Path, 1, Length(Path)-1))+Copy(Form1.Panel1.Caption, pos(':',Form1.Panel1.Caption)+2, length(Form1.panel1.caption)))
 );
 G := CreateFile(pChar(ExtractFilePath(Copy(Path, 1, Length(Path)-1))+Copy(Form1.Panel1.Caption, pos(':',Form1.Panel1.Caption)+2, length(Form1.panel1.caption))),
                 GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_NEW, 0, 0);
 SetFilePointer(G, 0, 0, FILE_BEGIN);
 WriteFile(G, Str_[1], Length(Str_), P, 0);
 CloseHandle(G);


// AssignFile(G, ExtractFilePath(Copy(Path, 1, Length(Path)-1))+Copy(Form1.Panel1.Caption, pos(':',Form1.Panel1.Caption)+2, length(Form1.panel1.caption)));
// ReWrite(G);

// CloseFile(G);


end;

end.
