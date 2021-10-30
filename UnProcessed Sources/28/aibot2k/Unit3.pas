unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Edit1: TEdit;
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = 13 Then
  Begin
    Form1.ClientSocket1.Socket.SendText(
    'PRIVMSG '+Copy(Caption, Pos('$', Caption)+1, Length(Caption))+' :'+Edit1.Text+#13#10);
    Memo1.Lines.Add('['+TimeToStr(Now)+'] <You> '+Edit1.Text);
    Edit1.Text := '';
    ZeroMemory(@Key, SizeOf(Key));
  End;
end;

end.
