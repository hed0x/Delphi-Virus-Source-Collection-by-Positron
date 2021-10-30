unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellApi, StdCtrls, ExtCtrls;

type
  TForm5 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Label5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Label5Click(Sender: TObject);
begin
 Shellexecute(0,'open','http://www.imafraid.com',nil,nil,1);
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
form5.Hide;
end;

end.
