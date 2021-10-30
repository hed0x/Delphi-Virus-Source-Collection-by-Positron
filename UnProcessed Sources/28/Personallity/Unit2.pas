unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ListView1: TListView;
    Button1: TButton;
    ListView2: TListView;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
If CheckBox1.Checked Then begin
 Checkbox4.Enabled := False;
 Checkbox4.Checked := False;
End Else
 Checkbox4.Enabled := True;
end;

end.                                        
