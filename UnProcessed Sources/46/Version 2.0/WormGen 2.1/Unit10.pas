unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls;

type
  TForm10 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure Add1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.Add1Click(Sender: TObject);
var
 s:tlistitem;
begin
 s := listview1.Items.add;
 s.Caption := inputbox('Add url','Add following url to visit', 'http://');
end;

procedure TForm10.Delete1Click(Sender: TObject);
begin
 if listview1.ItemIndex = -1 then exit;
 if listview1.Items.Count = 0 then exit;
 listview1.ItemFocused.Delete;
end;

procedure TForm10.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
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
