unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure Delete1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

Uses Unit3;

{$R *.dfm}

procedure TForm2.Delete1Click(Sender: TObject);
begin
if listview1.Items.count <= 0 then exit;
if listview1.ItemIndex = -1 then exit;
listview1.ItemFocused.Delete;
end;

procedure TForm2.Add1Click(Sender: TObject);
begin
Form3.Show;
end;

procedure TForm2.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 p: TPoint;
 mx, my : integer;
begin
GetCursorPos(P);
Mx := P.X;
My := P.Y;
if button = mbright then
 popupmenu1.Popup(mx, my);
end;

end.
