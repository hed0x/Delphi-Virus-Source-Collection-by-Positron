unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus;

type
  TForm5 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 mx, my : integer;
 p      : tpoint;
begin
 getcursorpos(p);
 mx := p.x;
 my := p.y;
 if button = mbright then
  popupmenu1.popup(mx, my); 
end;

procedure TForm5.Delete1Click(Sender: TObject);
begin
if listview1.Items.count <= 0 then exit;
if listview1.ItemIndex = -1 then exit;
listview1.ItemFocused.Delete;
end;

procedure TForm5.Add1Click(Sender: TObject);
var
 folder,
 names : string;
 item : tlistitem;
begin
 folder := inputbox('Enter folder name', 'Enter folder name', '');
 Names := inputbox('Name', 'Enter Name', 'file.exe');
 if trim(folder) = '' then exit;
 if trim(names) = '' then exit; 
 item := listview1.items.Add;
 item.Caption := folder;
 item.subitems.add(names);
end;

end.
