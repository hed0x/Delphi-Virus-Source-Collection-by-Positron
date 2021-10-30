unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm4 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
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
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button3Click(Sender: TObject);
begin
if listview1.Items.count <= 0 then exit;
if listview1.ItemIndex = -1 then exit;
listview1.ItemFocused.Delete;
end;

procedure TForm4.Button2Click(Sender: TObject);
var
 item   :tlistitem;
 i      :integer;
begin
 if listview1.items.count > 0 then begin
  For i:=0 to listview1.items.count -1 do begin
   if listview1.items[i].caption = edit3.text then begin
    if listview1.Items[i].subitems[0] = edit1.text + ' <'+edit2.text+'>' then
     if listview1.Items[i].subitems[1] = memo1.text then
      if listview1.Items[i].subitems[2] = edit4.text then
       if listview1.Items[i].subitems[3] = edit5.text then
        exit;
   end;
  end;
 end;
 item := listview1.items.add;
 item.caption := edit3.text;
 item.subitems.add(edit1.text + ' <'+edit2.text+'>');
 While Copy(Memo1.Text, length(memo1.text)-1, 2) = #13#10 Do
  Memo1.text := Copy(Memo1.text, 1, Length(Memo1.text)-2);
 item.subitems.add(memo1.text);
 item.subitems.add(edit4.text);
 item.subitems.add(edit5.text);
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
 If ListView1.items.Count = 1 Then Begin
  Messagebox(0, 'You need more then 1 item in list', 'Error', mb_ok);
  Exit;
 End;
 form4.Hide;
end;

procedure TForm4.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose := False;
Button1Click(Self);
end;

end.
