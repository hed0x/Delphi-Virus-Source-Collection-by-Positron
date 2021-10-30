unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
MessageBox(0, 'After this name, it will be random number', 'Info', Mb_ok);
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
Form7.hide;
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
MessageBox(0, 'This is only a simple ircbot.'+#13#10+
              'only commando for this is :'+#13#10+#13#10+
              '!DL;password;url;'+#13#10+#13#10+
              'you can easily add more commands'+#13#10+
              'by modify ircbot.pas', 'Info', mb_ok);
end;

end.
