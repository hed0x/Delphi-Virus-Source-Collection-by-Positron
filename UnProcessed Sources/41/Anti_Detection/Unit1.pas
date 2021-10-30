unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    Edit3: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Button5: TButton;
    Memo2: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function encode(s:String):string;
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
edit1.Height := 17;
edit2.Height := 17;
edit3.Height := 17;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if opendialog1.Execute then begin
 Statusbar1.Panels[0].Text := '0% Loaded';
 Statusbar1.Panels[1].Text := 'Opening File';
 Edit3.Text := Opendialog1.FileName;
 Memo1.Lines.LoadFromFile(Opendialog1.FileName);
 Statusbar1.Panels[0].Text := '100% Loaded';
 Statusbar1.Panels[1].Text := 'Just doing nothing..';
 listbox1.Clear;
end;
end;

function TForm1.encode(s:String):string;
var
 i:integer;
begin
 result := '';
 for i:=1 to length(s) do begin
  if pos(copy(s,i,1),edit1.text)>0 then
   result := result + copy(edit2.text,pos(copy(s,i,1),edit1.text),1)
  else result := result + copy(s,i,1);
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 a,f,i:integer;
 d:string;
begin
 Edit1.text := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |';
 Edit2.text := '';
 d := edit1.text;
 a:=length(edit1.text);
 for i:=1 to a do begin
  Statusbar1.Panels[1].Text := 'Updating Alpha';
  Statusbar1.Panels[0].Text := inttostr(i)+'/'+inttostr(a);
  Statusbar1.Update;
repeat
  randomize;
  f := random(length(d))+1;
  Sleep(20);
  if pos(copy(d, f, 1), edit2.text)>0 then
   Delete(d,f,1);
until (pos(copy(d, f, 1), edit2.text) = 0);
  Edit2.text := Edit2.text + copy(d, f, 1);
  Delete(d,f,1);
 end;
 Statusbar1.Panels[1].Text := 'Just doing nothing..';
 Statusbar1.Panels[0].Text := '100% Loaded';
 Statusbar1.Update;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
Memo1.Lines.SaveToFile(edit3.text); 
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 Max,
 Cur,
 Steps : integer;
 SPos : integer;
 Str2,str : string;
 tex : string;
 I, j : Integer;
 add, ignore, use:boolean;
begin
 listbox1.Clear;
 use := false;
 ignore := false;
 str2 := memo1.text;
 str := '';
 // filter out uses and ignores.
 For i:=1 to length(str2) do begin
  if (copy(str2,i,1)=';') and (use) then use:= false;
  if copy(str2,i,4)='uses' then use:= true;
  if copy(str2,i,10)='!!ignore!!' then if ignore then ignore := false else ignore := true;
  if (not use) and (not ignore) then
   str := str + copy(str2,i,1);
 end;
 memo2.text := str;
 For i:=1 to length(memo2.text) do begin
  if pos('''',str)>0 then begin
   spos := pos('''',str);
   str := copy(str,spos+1,length(str));
   tex := copy(str,1,pos('''',str)-1);
   str := copy(str,pos('''',str)+1,length(str));
   add := false;
   for j :=0 to listbox1.items.count -1 do
    if ansilowercase(listbox1.Items.strings[j]) = ansilowercase(''''+tex+'''') then add:=true;

   if (tex <> '') and (not add) then
    if length(tex) = 1 then begin
     if pos(tex,edit2.text)>0 then
      listbox1.items.add(''''+tex+'''');
     end else
      listbox1.items.add(''''+tex+'''');
  end;
 end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 Max,
 Cur,
 Steps : integer;
 SPos : integer;
 Str2,str,mem,apa : string;
 tex : string;
 I, j : Integer;
 dec, add, ignore, use:boolean;

begin
 Mem := memo1.text;
 Memo1.text := '';
 Repeat
  Spos := pos('''',mem);
  If spos=0 then begin
   memo1.text:=memo1.text + mem;
   break;
  end;
  apa := ansilowercase(Copy(mem, spos-7, 7));
  If apa = 'decode(' then dec := true else dec := false;
  Str := Copy(mem, spos, length(mem));
  Str := Copy(Str, 2, length(str));
  Str := Copy(str, 1,pos('''',str)-1);
  Add := true;
  For j:=0 to listbox1.items.count -1 do
   if listbox1.items.Strings[j] = ''''+str+'''' then add := false;
  If (Str <> '') and (not add) Then Begin
    Delete(Mem, spos, length(str)+2);
   If not dec then
    Str := 'decode('''+encode(str)+''')'
   else
    Str := ''''+Encode(str)+'''';
    Insert(str, mem, spos);
  End;
   Memo1.text := Memo1.text + Copy(mem,1,spos+length(str)+2);
   Mem := Copy(mem,spos+length(str)+3, length(mem));
 Until Mem = '';
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
listbox1.items.Delete(listbox1.ItemIndex); 
end;

end.
