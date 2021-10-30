unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Unit3;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = 13 Then
  Begin
    Form1.ClientSocket1.Socket.SendText(
    'PRIVMSG '+Copy(Caption, Pos('#', Caption), Length(Caption))+' :'+Edit1.Text+#13#10);
    Memo1.Lines.Add('['+TimeToStr(Now)+'] <You> '+Edit1.Text);
    Edit1.Text := '';
    ZeroMemory(@Key, SizeOf(Key));
  End;
end;

procedure TForm2.ListView1DblClick(Sender: TObject);
var
 Nick:String;
begin
 If ListView1.ItemIndex = -1 Then Exit;

 Nick := ListView1.ItemFocused.Caption;
 Application.CreateForm(TForm3, PM[PN]);
 PM[PN].Caption := 'PrivMsg $'+Nick;
 PM[PN].Show;
 Inc(PN);

end;

end.
