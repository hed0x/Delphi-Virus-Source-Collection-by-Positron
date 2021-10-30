unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TForm6 = class(TForm)
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    procedure RichEdit1Change(Sender: TObject);
    procedure RichEdit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.RichEdit1Change(Sender: TObject);
begin
Panel1.Caption := IntToStr(RichEdit1.CaretPos.Y) + ':' + IntToStr(RichEdit1.CaretPos.X);
end;

procedure TForm6.RichEdit1KeyPress(Sender: TObject; var Key: Char);
begin
if ((key) = ';') or ((key) = ':') or ((key) = '.') or
   ((key) = '!') or ((key) = '$') or ((key) = ',') or
   ((key) = '{') or ((key) = '(') or ((key) = '[') or
   ((key) = '}') or ((key) = ')') or ((key) = ']') or ((key) = '%') or
   ((key) = '*') or ((key) = '&') or ((key) = '|') then begin
    Richedit1.SelText := '';
    Richedit1.SelAttributes.Color := ClBlue;
    Richedit1.SelText := Richedit1.SelText + (Key);
    Richedit1.SelAttributes.Color := ClBlack;
    ZeroMemory(@Key, SizeOf(Key));
   end else
    Richedit1.SelAttributes.Color := ClBlack;

end;

end.
