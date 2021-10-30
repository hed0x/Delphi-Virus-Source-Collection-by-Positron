unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

Uses
 Unit2;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
 Item : TListItem;
 I    : Integer;
begin
 If Form2.ListView1.Items.Count > 0 Then Begin
  For I := 0 To Form2.ListView1.Items.Count -1 Do
   If Form2.ListView1.Items[i].Caption = Edit1.text Then Exit;
 End;
 Item := Form2.ListView1.Items.Add;
 Item.Caption := Edit1.text;
 Item.SubItems.Add(Edit2.text);
 Form3.Hide;
end;

end.
