unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    ClientSocket1: TClientSocket;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure StripLine(str:string);
    Function Exist(w,l:string):Boolean;
    Function SayRandom(LstNr, Length:integer):String;
    Function PickRword(I:Integer):string;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure FormCreate(Sender: TObject);
    Procedure GetSubWord(s:string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SubWord : string;
  OPEN : BOOLEAN;
  Nick : String = 'p3wk';
  Channel : string;
implementation

{$R *.dfm}

Procedure TForm1.GetSubWord(s:string);
var
 I,F:integer;
Begin
if s = '' then begin
 Subword := 'SiC';
 exit;
end;
S := ' '+S+' ';
F := 0;
While Pos(' ',S)>0 do begin
 I:= Pos(' ',S);
 Delete(S, i, 1);
 Insert(chr(0160), s, i);
 Inc(F);
End;
F:=F-1;
While F > 0 Do Begin
SubWord := Copy(S,Pos(chr(0160),S)+1, length(s));
F:=F-1;
S := Copy(S,Pos(chr(0160),S)+1, length(s));
End;
SubWord := Copy(SubWord,1,Pos(Chr(0160),SubWord)-1);
End;

Function TForm1.PickRword(I:Integer):string;
var
 s:string;
 G:Integer;
 F,H:Integer;
begin
 Randomize;
 IF I < 0 Then I := 0;
 s := listview1.items[i].subitems[0];
 f := 0;
 For G:=0 to length(s)-1 do
  if copy(s,G,1) = chr(0160) then inc(f);
 F:=F-1;
 H := F;
 repeat
  F := Random(F);
 until F < H;
 While F >= 0 Do Begin
 Result := Copy(S,pos(chr(0160),s)+1,length(s));
 S := Copy(S,pos(chr(0160),s)+1,length(s));
 Dec(F,1);
 End;
 Result := Copy(Result, 1, pos(chr(0160),result)-1);
 If Copy(Result,1,1) = chr(0160) then Result := Copy(Result, 2, length(Result));
 If Copy(Result,length(result),1) = chr(0160) then Result := Copy(Result, 1, length(Result)-1);
end;

Function TForm1.SayRandom(LstNr, Length:integer):String;
var
 Str:string;
 WR:String;
 H,J,I:integer;
 FAGGET: BOOLEAN;
begin
 if length < 2 then length := length + 2;
 IF H >= ListView1.Items.Count Then H := ListView1.Items.Count-1;
 IF LstNR >= ListView1.Items.Count Then LstNR := ListView1.Items.Count-1;
 if lstnr < 0 then lstnr := 0;
 If SubWord = '' Then
 str := listview1.items[lstnr].Caption
 Else
 Str := SubWord;
 IF SUBWORD <> '' THEN BEGIN
 For I:=0 to ListView1.Items.Count -1 Do
  if ansilowercase(listview1.Items[i].Caption) = ansilowercase(subword) then H := I;
 END ELSE H := LSTNR;
 For i:=0 To Length-1 do begin
  Wr := PickRword(H);
  if Wr <> '' then
   Str := Str + ' ' + Wr;
  H := 0;
  Randomize;
  For J :=0 To ListView1.Items.Count -1 Do
   If AnsiLowerCase(ListView1.Items[J].Caption) =
      AnsiLowerCase(Wr) Then H:=J;
  If H = 0 Then begin
  (*
  Randomize;
  Case random(5) of
   0:Str := Str +' :D ';
   1:Str := Str +' ;P ';
   2:Str := Str +' \o/ ';
   3:Str := Str +' ;) ';
   4:Str := Str +' (: ';
   5:Str := Str +' :( ';
  End;         *)
   H := Random(ListView1.Items.Count)-1;
   FAGGET := TRUE;
  end;
  IF FAGGET THEN BREAK;
 end;
 Str := Trim(Str);
 Randomize;
 Case random(3) of
  0:str := str + '...';
  1:str := str + '?';
  2:str := str + '!';
 end;
 Result := Str;
end;

Function TForm1.Exist(w,l:string):Boolean;
var
 i,j:integer;
begin
 result := false;
 i:=0;

 if listview1.items.count < 1 then exit;
 For i:=0 to ListView1.Items.Count-1 do begin
  if ansilowercase(listview1.Items[i].Caption) = ansilowercase(w) then begin
   for j:=0 to 65500 do begin
    if l = '' then break;
    if pos(ansilowercase(chr(0160)+l+chr(0160)),
    ansilowercase(listview1.items[i].SubItems[0]))=0 then begin
     listview1.items[i].SubItems[0] := listview1.items[i].SubItems[0] + chr(0160)+l+chr(0160);
    end;
   end;
   result := true;
  end;
 end;
end;

procedure TForm1.StripLine(str:string);
var
 us:tlistitem;
 i:integer;
 line, w0rd:string;
begin
 while pos(' ',str)>0 do begin
  i := pos(' ',str);
  delete(str,i,1);
  insert(chr(0160), str, i);
 end;
 If copy(str,length(str),1) <> chr(0160) then
  str := str + chr(0160);
 while pos(chr(0160),str)>0 do begin
  w0rd := copy(str,1,pos(chr(0160),str)-1);
  line := copy(str,pos(chr(0160),str)+1,length(str));
  Line := Copy(Line,1,Pos(Chr(0160),line)-1);
  line := trim(line);
  while copy(line,length(line),1) = ' ' do
   delete(line, length(line), 1);
  if line = '' then break;
  if not (Exist(w0rd,line)) and (w0rd <> '') and (line <> '') then begin
   us := listview1.Items.Add;
   us.Caption := w0rd;
   us.SubItems.Add(chr(0160)+line+chr(0160));
  end;
  str := copy(str,pos(chr(0160),str)+1,length(str));
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 str:string;
 i : integer;
 abc:string;
 Save:TextFile;
begin
 str := trim(edit1.text);
 Edit1.text := '';
 abc := '.!?';
 for i := 1 to length(str) do begin
  if pos(copy(str,i,1),abc)=0 then
   Edit1.text := Edit1.text + Copy(Str,i,1);
 end;
 str := edit1.text;
 if str = '' then exit;
 Edit1.text := '';
 StripLine(Str);
 IF NOT OPEN THEN BEGIN
 AssignFile(Save, 'C:\List.Lst');
 ReWrite(Save);
 For i:=0 to listview1.items.Count -1 do begin
  Writeln(save, listview1.items[i].caption + '.'+listview1.items[i].SubItems[0]);
 end;
 CloseFile(Save);
 END;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then button1click(self);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ClientSocket1.Active := true;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 S:String;
 P:String;
begin
 ZeroMemory(@S,Length(S));
 ZeroMemory(@Subword,Length(Subword));
 S := Socket.ReceiveText;
 Sleep(100);
 randomize;
 if pos('.RAW',S)>0 then begin
  P := Copy(S,Pos('.RAW',S)+5,length(s));
  P := Copy(P,1,pos(#13#10,p)-1);
  Socket.SendText(P+#13#10);
 end;
 if pos(AnsiUppercase('VERSION'),ansiuppercase(S))>0 then begin
  Socket.SendText('NOTICE SecureServ :'#1'VERSION bIRC v6.66 Jesus Mardam-Gay'#1+#13#10);
 end else
 if pos('PING',S)>0 then begin
  P := Copy(S,Pos('PING',S)+6,length(s));
  P := Copy(P,1,pos(#13#10,p)-1);
  Socket.SendText('PONG :'+P);
 end;
 if pos('MOTD',S)>0 then
  socket.SendText('JOIN #box'+#13#10);
 if pos('.LINE',S)>0 then
  if copy(s,2,pos('!',s)-2) = 'SiC' then
  Channel := Copy(S,pos('PRIVMSG',S)+8,length(S));
  Channel := Copy(Channel,1,pos(' ',Channel)-1);
  socket.SendText('PRIVMSG '+Channel+' :'+SayRandom(Random(listview1.items.Count)-1,Random(20))+#13#10);
  Sleep(300);
 if pos(NICK,S)>0 then begin
  Channel := Copy(S,pos('PRIVMSG',S)+8,length(S));
  Channel := Copy(Channel,1,pos(' ',Channel)-1);
  SUBWORD := '';
  Repeat
  Randomize;
  GetSubWord(P);
  until subword <> '';
  If Random(100)>40 then
   socket.SendText('PRIVMSG '+Channel+' :'+SayRandom(Random(listview1.items.Count)-1,Random(20))+#13#10);
 end;
 if pos('PRIVMSG',s)>0 then begin
  Channel := Copy(S,pos('PRIVMSG',S)+8,length(S));
  Channel := Copy(Channel,1,pos(' ',Channel)-1);
  SUBWORD := '';
  P := Copy(S,Pos('PRIVMSG',S)+8,length(s));
  p := Copy(P,Pos(':',P)+1, lengtH(P));
  P := Copy(P,1,Pos(#13#10,p)-1);
  Edit1.text := P;
  Button1click(self);

  Repeat
  Randomize;
  GetSubWord(P);
  until subword <> '';
  If Random(100)>40 then
   socket.SendText('PRIVMSG '+Channel+' :'+SayRandom(Random(listview1.items.Count)-1,Random(20))+#13#10);
 end;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Socket.SendText('USER '+NICK+' YourMom232@FOOD.COM YourMom232@FOOD.COM YourMom232@FOOD.COM'+#13#10);
Socket.SendText('NICK '+NICK+#13#10);
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
Errorcode := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 s:textfile;
 s1,s2,str:string;
 us:tlistitem;
begin
OPEN := FALSE;
If Fileexists('C:\List.LST') then begin
OPEN := TRUE;
 AssignFile(S, 'C:\List.LST');
 Reset(S);
 Read(S, S1);
 ReadLn(S, S2);
 Str := S1;
 US := ListView1.items.Add;
 US.Caption := Copy(Str,1, pos('.',str)-1);
 US.SubItems.Add(Copy(Str, pos('.',str)+1, length(str)));
 While not eof(S) Do begin
  Read(S, S1);
  ReadLn(S, S2);
  Str := S1;
  US := ListView1.items.Add;
  US.Caption := Copy(Str,1, pos('.',str)-1);
  US.SubItems.Add(Copy(Str, pos('.',str)+1, length(str)));
 end;
 closefile(S);
end;
OPEN := FALSE;
end;

end.
