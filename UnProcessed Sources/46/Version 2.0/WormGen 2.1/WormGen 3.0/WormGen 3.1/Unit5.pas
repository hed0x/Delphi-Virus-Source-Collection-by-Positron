unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
 If Form1.Submit.Active Then Exit;
  Form1.Submit.Port := StrToInt(Form1.Edit3.text);
  Form1.Submit.Host := Form1.Edit2.Text;
  Form1.Submit.Active := True;
end;

end.
