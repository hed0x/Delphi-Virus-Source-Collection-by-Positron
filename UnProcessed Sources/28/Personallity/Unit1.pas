unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ClientSocket1: TClientSocket;
    Label5: TLabel;
    Timer2: TTimer;
    Button2: TButton;
    Button3: TButton;
    Timer_Drink: TTimer;
    ListView2: TListView;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer5: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer_DrinkTimer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Forced_Wakeup:Boolean;
  SleepNick:Boolean;
  DefaultPosition:Integer;

implementation

uses Unit2, Unit3;

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var
 hour, min : integer;
 fmin:string;
begin
Label1.caption := 'Time now is : '+TimeToStr(Time);
hour := strToInt(copy(TimeToStr(Time),1,pos(':',TimeToStr(Time))-1));
fmin := copy(label1.Caption,pos(':',label1.caption)+1, length(label1.caption));
fmin := copy(fmin,pos(':',fmin)+1,length(fmin));
fmin := copy(fmin,1,pos(':',fmin)-1);
min := strtoint(fmin);
Case Hour of
 0:if not Forced_Wakeup Then Label3.Caption := 'I''m sleeping.' else Label3.Caption := 'Forced woken up.';
 6:begin
  Label3.Caption := 'I just woke up.';
   end;
 12:Label3.Caption := 'I''m awake.';
 24:if not Forced_Wakeup Then Label3.Caption := 'I''m sleeping.' else Label3.Caption := 'Forced woken up.';
end;
Case Hour of
 0:if not timer_drink.enabled then Progressbar1.Position := 0;
 1:if not timer_drink.enabled then Progressbar1.Position := 5;
 2:if not timer_drink.enabled then Progressbar1.Position := 10;
 3:if not timer_drink.enabled then Progressbar1.Position := 15;
 4:if not timer_drink.enabled then Progressbar1.Position := 20;
 5:if not timer_drink.enabled then Progressbar1.Position := 25;
 6:if not timer_drink.enabled then Progressbar1.Position := 30;
 7:if not timer_drink.enabled then Progressbar1.Position := 35;
 8:if not timer_drink.enabled then Progressbar1.Position := 100;
 9:if not timer_drink.enabled then Progressbar1.Position := 100;
 10:if not timer_drink.enabled then Progressbar1.Position := 100;
 11:if not timer_drink.enabled then Progressbar1.Position := 100;
 12:if not timer_drink.enabled then Progressbar1.Position := 100;
 13:if not timer_drink.enabled then Progressbar1.Position := 100;
 14:if not timer_drink.enabled then Progressbar1.Position := 100;
 15:if not timer_drink.enabled then Progressbar1.Position := 100;
 16:if not timer_drink.enabled then Progressbar1.Position := 100;
 17:if not timer_drink.enabled then Progressbar1.Position := 100;
 18:if not timer_drink.enabled then Progressbar1.Position := 100;
 19:if not timer_drink.enabled then Progressbar1.Position := 100;
 20:if not timer_drink.enabled then Progressbar1.Position := 100;
 21:if not timer_drink.enabled then Progressbar1.Position := 100;
 22:if not timer_drink.enabled then Progressbar1.Position := 50;
 23:if not timer_drink.enabled then Progressbar1.Position := 25;
end;
Case hour of
 13:begin
  if min = 13 then
   clientsocket1.Socket.SendText('PRIVMSG '+form3.Edit4.text+' :Time is 13:37'+#13#10); 
 end;
 24:begin
  If SleepNick then exit;
  SleepNick := true;
  ClientSocket1.Socket.SendText('NICK '+Form3.Edit4.text+'|sleep'+#13#10);
  ClientSocket1.Socket.SendText('PRIVMSG '+Form3.Edit3.text+' :Nite y''all.'+#13#10);
 end;
 6:begin
  If not SleepNick then exit;
  SleepNick := False;
  ClientSocket1.Socket.SendText('NICK '+Form3.Edit4.text+#13#10);
  ClientSocket1.Socket.SendText('PRIVMSG '+Form3.Edit3.text+' :Morning y''all.'+#13#10);
 end;
End;

end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
socket.sendtext('USER '+Form3.Edit4.text+' '+Form3.Edit4.text+'@food.com '+Form3.Edit4.text+' '+Form3.Edit4.text+#13#10);
socket.sendtext('NICK '+Form3.Edit4.text+#13#10);
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
Errorcode := 0;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 YSE:Boolean;
 G: String;
 S: String;
 F: String;
 Proc:String;
 US:TListItem;
 go:boolean;
 I : integer;
 J : Integer;
 K : Integer;
begin
 go := false;
S := Socket.ReceiveText;
F := Copy(S, Pos('353',S), length(s));
F := Copy(F, pos(':', F)+1, Length(F));
F := Copy(F, 1, Pos(#13#10, F)-1);
If Copy(F, length(F),1)<> ' ' then f := f + ' ';

If Pos('MOTD',s)>0 then
 socket.sendtext('JOIN '+Form3.Edit3.text+#13#10);
If Pos('PING',s)>0 then begin
 proc := copy(s, pos('PING',S)+6,length(s));
 Proc := copy(Proc,1,pos(#13#10,proc)-1);
 socket.sendtext('PONG :'+proc+#13#10);
end;
if pos('PART',S)>0 then begin
 if listview1.items.count = 0 then exit;
 For i := 0 to listview1.items.count -1 do
  if listview1.items[i].caption = copy(s, 2, pos('!',s)-2) then begin
   listview1.items[i].Delete;
   break;
  end;
end;
if pos('QUIT',S)>0 then begin
 if listview1.items.count = 0 then exit;
 For i := 0 to listview1.items.count -1 do
  if listview1.items[i].caption = copy(s, 2, pos('!',s)-2) then begin
   listview1.items[i].Delete;
   break;
  end;
end;
if pos('KICK',S)>0 then begin
 if listview1.items.count = 0 then exit;
 if pos('PRIVMSG',S)>0 then exit;
 F := copy(S, pos('KICK',S)+6, length(s));
 F := Copy(F, 1, pos(#13#10,F)-1);
 F := copy(F, pos(' ',F)+1, length(f));
 F := copy(F, 1, pos(' ',F)-1);
 For i := 0 to listview1.items.count -1 do
  if listview1.items[i].caption = F then begin
   listview1.items[i].Delete;
   break;
  end;
end;
if pos('NICK',S)>0 then begin
 F := copy(S, pos('NICK',S)+6, length(s));
 F := Copy(F, 1, pos(#13#10,F)-1);
 for i:=0 to listview1.items.Count-1 do
  if listview1.items[i].caption = copy(s,2,pos('!',s)-2) then
   listview1.items[i].Caption := F;
 for i:=0 to listview2.items.Count-1 do
  if listview2.items[i].caption = copy(s,2,pos('!',s)-2) then
   listview2.items[i].Caption := F;
end;
if pos('JOIN',S)>0 then begin
 if Copy(S, 2, pos('!',S)-2) <> Form3.Edit4.text then begin
  Us := ListView1.Items.Add;
  Us.Caption := Copy(S, 2, pos('!',S)-2);
  Us.SubItems.Add('50%');
 end;
end;


if ((pos('wake',lowercase(s))>0) or
    (pos('dont sleep',lowercase(s))>0)) and (pos(ansilowercase(Form3.Edit4.text),lowercase(s))>0) Then begin
 If listview1.items.Count = 0 then exit;
 for i := 0 to listview1.items.count -1 do
  if listview1.items[i].Caption = copy(S, 2, pos('!',s)-2) then begin
   Proc := copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1);
   if strtoint(Proc) > 0 then
    Case strtoint(copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1)) of
     0  : ListView1.Items[i].SubItems[0] := '0%';
     10 : ListView1.Items[i].SubItems[0] := '0%';
     30 : ListView1.Items[i].SubItems[0] := '10%';
     50 : ListView1.Items[i].SubItems[0] := '30%';
     70 : ListView1.Items[i].SubItems[0] := '50%';
     90 : ListView1.Items[i].SubItems[0] := '70%';
     100: ListView1.Items[i].SubItems[0] := '90%';
    End;
  end;
  If ListView1.Items.Count = 0 then exit;
  if ListView1.Items[i].SubItems[0] <> '0%' then begin
   Forced_Wakeup := True;
   Progressbar1.Position := 10;
   ClientSocket1.Socket.SendText('NICK '+Form3.Edit4.text+#13#10);
  end;
end;

if ((pos('sozz',lowercase(s))>0) or
    (pos('sry',lowercase(s))>0) or
    (pos('sory',lowercase(s))>0) or
    (pos('sorry',lowercase(s))>0) or
    (pos('forgive',lowercase(s))>0) or
    (pos('frgve',lowercase(s))>0)) and (pos(ansilowercase(Form3.Edit4.text),lowercase(s))>0) Then begin
 if listview2.items.count > 0 then
 For j := 0 to listview2.items.Count -1 do
  if listview2.items[j].Caption = copy(S, 2, pos('!',s)-2) then exit;
 US := ListView2.items.Add;
 US.Caption := copy(S, 2, pos('!',s)-2);
 US.SubItems.Add('100%');
 If listview1.items.Count = 0 then exit;
 for i := 0 to listview1.items.count -1 do
  if listview1.items[i].Caption = copy(S, 2, pos('!',s)-2) then begin
    Case strtoint(copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1)) of
     0  : ListView1.Items[i].SubItems[0] := '10%';
     10 : ListView1.Items[i].SubItems[0] := '30%';
     30 : ListView1.Items[i].SubItems[0] := '50%';
     50 : ListView1.Items[i].SubItems[0] := '70%';
     70 : ListView1.Items[i].SubItems[0] := '90%';
     90 : ListView1.Items[i].SubItems[0] := '100%';
     100: ListView1.Items[i].SubItems[0] := '100%';
    End;
  end;
  exit;
end;

if ((pos('coke',lowercase(s))>0) or
    (pos('pepsi',lowercase(s))>0) or
    (pos('weed',lowercase(s))>0) or
    (pos('drug',lowercase(s))>0) or
    (pos('cock',lowercase(s))>0) or
    (pos('penis',lowercase(s))>0) or
    (pos('sex',lowercase(s))>0) or
    (pos('love',lowercase(s))>0) or
    (pos('cookie',lowercase(s))>0) or
    (pos('candy',lowercase(s))>0)) and (pos(ansilowercase(Form3.Edit4.text),lowercase(s))>0) Then begin
 if timer_drink.Enabled = true then exit;
 If listview1.items.Count = 0 then exit;
 for i := 0 to listview1.items.count -1 do
  if listview1.items[i].Caption = copy(S, 2, pos('!',s)-2) then begin
    Case strtoint(copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1)) of
     0  : ListView1.Items[i].SubItems[0] := '10%';
     10 : ListView1.Items[i].SubItems[0] := '30%';
     30 : ListView1.Items[i].SubItems[0] := '50%';
     50 : ListView1.Items[i].SubItems[0] := '70%';
     70 : ListView1.Items[i].SubItems[0] := '90%';
     90 : ListView1.Items[i].SubItems[0] := '100%';
     100: ListView1.Items[i].SubItems[0] := '100%';
    End;
    timer_drink.Enabled := true;
    DefaultPosition := progressbar1.position;

    if pos('sex',lowercase(s))>0        then progressbar1.position := progressbar1.position - 20;
    if pos('love',lowercase(s))>0       then progressbar1.position := progressbar1.position - 20;
    if pos('cock',lowercase(s))>0       then progressbar1.position := progressbar1.position - 20;
    if pos('penis',lowercase(s))>0      then progressbar1.position := progressbar1.position - 20;
    if pos('pepsi',lowercase(s))>0      then progressbar1.position := progressbar1.position + 30;
    if pos('coke',lowercase(s))>0       then progressbar1.position := progressbar1.position + 40;
    if pos('cookie',lowercase(s))>0     then progressbar1.position := progressbar1.position + 10;
    if pos('weed',lowercase(s))>0       then progressbar1.position := progressbar1.position + 100;
    if pos('drug',lowercase(s))>0       then progressbar1.position := progressbar1.position + 100;
    if pos('candy',lowercase(s))>0      then progressbar1.position := progressbar1.position + 20;

    if pos('sex',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|resting'+#13#10);
    if pos('love',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|resting'+#13#10);
    if pos('cock',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|resting'+#13#10);
    if pos('penis',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|resting'+#13#10);
    if pos('pepsi',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|pepsi'+#13#10);
    if pos('coke',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|coke'+#13#10);
    if pos('cookie',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|cookie'+#13#10);
    if pos('weed',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|stoned'+#13#10);
    if pos('drug',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|stoned'+#13#10);
    if pos('candy',lowercase(s))>0 then Socket.SendText('NICK '+form3.edit4.text+'|candy'+#13#10);

  end;
end;

if (pos(ansilowercase(Form3.Edit4.text),lowercase(s))>0) Then begin
 Go := False;
 For i:=0 to form2.listview2.items.count -1 do
  if pos(lowercase(form2.ListView2.Items[i].Caption),lowercase(s))>0 then go:=true;
 if go then begin
 If listview1.items.Count = 0 then exit;
 for i := 0 to listview1.items.count -1 do
  if listview1.items[i].Caption = copy(S, 2, pos('!',s)-2) then begin
   Proc := copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1);
    Case strtoint(copy(listview1.items[i].SubItems[0],1,length(listview1.items[i].SubItems[0])-1)) of
     0  : socket.sendtext('KICK '+form3.edit3.text+' '+copy(S, 2, pos('!',s)-2)+' :'+form2.ListView2.Items[random(form2.listview2.items.count)].Caption+#13#10);
     10 : ListView1.Items[i].SubItems[0] := '0%';
     30 : ListView1.Items[i].SubItems[0] := '10%';
     50 : ListView1.Items[i].SubItems[0] := '30%';
     70 : ListView1.Items[i].SubItems[0] := '50%';
     90 : ListView1.Items[i].SubItems[0] := '70%';
     100: ListView1.Items[i].SubItems[0] := '90%';
    End;
  end;
  end;
end;


if pos('353',s)>0 Then begin
//  f := copy(f, 1, length(f));
  ListView1.Items.Clear;
 Repeat
  Us := ListView1.Items.Add;
  Repeat
   Delete(F,pos('@',F),1);
  Until pos('@',F)=0;
  Repeat
   Delete(F,pos('+',F),1);
  Until pos('+',F)=0;
  Repeat
   Delete(F,pos('&',F),1);
  Until pos('&',F)=0;

  Us.Caption := Copy(F, 1, pos(' ',F)-1);
  Us.SubItems.Add('50%');
  F := Copy(F, Pos(' ',F)+1, length(F));
 Until Pos(' ',F)=0;
End;

if pos('PRIVMSG',s)>0 then begin
  F := Copy(S, Pos('PRIVMSG',S)+8, Length(S));
  F := Copy(F, pos(':',F)+1, Length(F));
  F := Copy(F, 1, pos(#13#10,F)-1);
  if copy(F,1,7) = #1+'ACTION' then exit;
 Form2.Label2.Caption := Copy(S,2,pos('!',S)-2);
 // check if person is liked, else if not, look if insule shall appear
 // ---------------- INSULTING -----------------------
 For i:=0 to listview1.items.Count -1 do
  if listview1.items[i].Caption = form2.label2.caption then begin
   If strtoint(Copy(Listview1.Items[i].SubItems[0],1,length(Listview1.Items[i].SubItems[0])-1)) < 20 then begin
    randomize;
    if form2.CheckBox4.Checked then
     If (random(100)>70) then begin
      Socket.SendText('PRIVMSG '+form3.Edit3.text+' :'+Copy(S,2,pos('!',S)-2)+', you are a '+form2.ListView2.Items[random(form2.listview2.items.count)].Caption+#13#10);
      Label5.caption := 'Time since last spoken : 00:00';
     end;

   end;
  end;
 // ---------------- INSULTING -----------------------

 // ---------------- FREESPEAK -----------------------
 Randomize;
 If Random(100)>(100-progressbar1.Position) Then Begin
  if pos('and',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('and',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('and',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('and',ansilowercase(f))+3,1)=' ') or (copy(ansilowercase(f),pos('and',ansilowercase(f))+3,1)='')) then
  delete(f,pos('and',ansilowercase(f)), 3);
  if pos('is',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('is',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('is',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('is',ansilowercase(f))+2,1)=' ') or (copy(ansilowercase(f),pos('is',ansilowercase(f))+2,1)='')) then
  delete(f,pos('is',ansilowercase(f)), 2);
  if pos('was',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('was',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('was',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('was',ansilowercase(f))+3,1)=' ') or (copy(ansilowercase(f),pos('was',ansilowercase(f))+3,1)='')) then
  delete(f,pos('was',ansilowercase(f)), 3);
  if pos('had',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('had',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('had',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('had',ansilowercase(f))+3,1)=' ') or (copy(ansilowercase(f),pos('had',ansilowercase(f))+3,1)='')) then
  delete(f,pos('had',ansilowercase(f)), 3);
  if pos('be',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('be',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('be',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('be',ansilowercase(f))+2,1)=' ') or (copy(ansilowercase(f),pos('be',ansilowercase(f))+2,1)='')) then
  delete(f,pos('and',ansilowercase(f)), 3);
  if pos('i',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('i',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('i',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('i',ansilowercase(f))+1,1)=' ') or (copy(ansilowercase(f),pos('i',ansilowercase(f))+1,1)='')) then
  delete(f,pos('i',ansilowercase(f)), 1);
  if pos('you',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('you',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('you',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('you',ansilowercase(f))+3,1)=' ') or (copy(ansilowercase(f),pos('you',ansilowercase(f))+3,1)='')) then
  delete(f,pos('you',ansilowercase(f)), 3);
  if pos('he',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('he',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('he',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('he',ansilowercase(f))+2,1)=' ') or (copy(ansilowercase(f),pos('he',ansilowercase(f))+2,1)='')) then
  delete(f,pos('he',ansilowercase(f)), 2);
  if pos('she',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('she',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('she',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('she',ansilowercase(f))+3,1)=' ') or (copy(ansilowercase(f),pos('she',ansilowercase(f))+3,1)='')) then
  delete(f,pos('she',ansilowercase(f)), 3);
  if pos('it',ansilowercase(f))>0 then if ((copy(ansilowercase(f),pos('it',ansilowercase(f))-1,1)=' ') or (copy(ansilowercase(f),pos('it',ansilowercase(f))-1,1)='')) and ((copy(ansilowercase(f),pos('it',ansilowercase(f))+2,1)=' ') or (copy(ansilowercase(f),pos('it',ansilowercase(f))+2,1)='')) then
   delete(f,pos('it',ansilowercase(f)), 2);
  F := Trim(F);
  i:=0;
  For k:=1 to Length(F) do
   if copy(f, k, 1)=' ' then
    i := i+1;
  // create a line

  I := Random(I);
  repeat
   f := copy(f,pos(' ',f)+1, length(f));
   dec(i);
  until i <= 0;
  if pos(' ',f)>0 then f := copy(f,1,pos(' ',f)-1);
  Randomize;
  if copy(s, length(s)-2,1)='?' then if random(101)> 50 then f := 'yes' else f := 'no';
  For J := 0 to form2.listview1.Items.Count -1 do
   if form2.listview1.items[J].Caption = F then begin
    If F = 'yes' Then F := F +', '+ form2.listview1.items[j].Caption
    Else
    If F = 'no' Then F := F +', '+ form2.listview1.items[j].Caption
    Else
     F := form2.listview1.items[j].Caption;

    S := form2.listview1.items[j].SubItems[0];
    While 1<>2 do begin
    If S = '' Then Begin
     Repeat
      Delete(F,pos(chr(0160),f),1);
     Until pos(chr(0160),F)=0;
     F := Trim(F);
     F := F + '.';
     If Not Form2.CheckBox1.Checked Then
      Socket.SendText('PRIVMSG '+form3.Edit3.text+' :'+F+#13#10);
     Exit;
    End;
    I := 0;
    S := Trim(S);
     For k:=0 to Length(S) do
      if copy(S, k, 1)=chr(0160) then
       i := i+1;
     Randomize;
     inc(i);
     I := Random(i);
     While i >0 do begin
      S := Copy(S, Pos(chr(0160),S)+1, Length(s));
      Dec(I);
     end;
     if pos(' ',s)>0 then s := copy(s,1,pos(' ',s)-1);
     if pos(chr(0160),s)>0 then s := copy(s,1,pos(chr(0160),s)-1);
     F := F +' '+ S;
     G:=S;
     S:='';
     For K := 0 to form2.listview1.Items.Count -1 do
      if form2.ListView1.Items[k].Caption = G then
       S := form2.listview1.items[K].SubItems[0];
    End;
   end;

  // /createline

 End;
 // ---------------- FREESPEAK -----------------------

 // ---------------- BAD WORDS -----------------------
 if (pos('you are',ansilowercase(s))>0) or
    (pos('your',ansilowercase(s))>0) or
    (pos('ur',ansilowercase(s))>0) or
    (pos('you is',ansilowercase(s))>0) then begin
    if Form2.CheckBox2.Checked then begin
     US := Form2.ListView2.Items.Add;
     If pos('you are',ansilowercase(s))>0 then
      F := Copy(S, pos('you are',ansilowercase(s))+8, length(s));
     If pos('your',ansilowercase(s))>0 then
      F := Copy(S, pos('your',ansilowercase(s))+5, length(s));
     If pos('ur',ansilowercase(s))>0 then
      F := Copy(S, pos('ur',ansilowercase(s))+3, length(s));
     If pos('you is',ansilowercase(s))>0 then
      F := Copy(S, pos('you is',ansilowercase(s))+7, length(s));
     If pos(' ',F)>0 then
      if Copy(F, 1, pos(' ',F)-1) = 'a' then begin
       f := copy(f, pos(' ',f)+1, length(f));
       if pos(' ',f)>0 then
        f := Copy(F, 1, pos(' ',F)-1);
       f := copy(f, 1, pos(#13#10,f)-1);
      end;
     If pos(#13#10,F)>0 then
      F := Copy(F, 1, pos(#13#10,F)-1);
     US.Caption := F;
    end;
 end;
 // ---------------- BAD WORDS -----------------------
 // --------------- LEARN WORDS -----------------------

 If Form2.CheckBox3.Checked then Begin
  F := Copy(S, Pos('PRIVMSG',S)+8, Length(S));
  F := Copy(F, pos(':',F)+1, Length(F));
  F := Copy(F, 1, pos(#13#10,F)-1);
  If Copy(F, Length(F), 1) <> ' ' Then
   F := F + ' ';
  Repeat
   For i:=0 to Form2.ListView1.Items.Count -1 Do
    If Form2.ListView1.Items[i].Caption = Copy(F, 1, pos(' ',f)-1) Then Begin
     F:= Copy(F, Pos(' ',F)+1, Length(F));
     If (Copy(F, 1, pos(' ',F)-1)<> '')and(Pos(Copy(F, 1, pos(' ',F)-1),Form2.ListView1.Items[i].SubItems[0])=0) then
      Form2.ListView1.Items[i].SubItems[0] := Form2.ListView1.Items[i].SubItems[0]+chr(0160)+copy(f, 1, pos(' ',f)-1);
    End;
   If F <> '' Then Begin
    US := Form2.ListView1.Items.Add;
    US.Caption := Copy(F, 1, pos(' ',F)-1);
    F:= Copy(F, Pos(' ',F)+1, Length(F));
    If Copy(F, 1, pos(' ',F)-1)='' then begin
     US.Delete;
     Break;
    end;
    US.SubItems.Add(Copy(F, 1, pos(' ',F)-1));
   End;
  Until F = '';
 End;

 // --------------- LEARN WORDS -----------------------
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ClientSocket1.Active := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
 Min, Sec:String;
begin
 Min := Copy(Label5.caption, pos(':', Label5.caption)+2, length(label5.caption));
 Sec := Copy(Min, pos(':',Min)+1, Length(Min));
 Min := Copy(Min, 1, pos(':',Min)-1);
 Sec := IntTostr(StrToInt(Sec) + 1);
 If Sec = '60' Then Begin
  Min := IntTostr(StrToInt(Min) + 1);
  Sec := '0';
 End;
 Label5.Caption := 'Time since last spoken : '+Min+':'+Sec;
 if Forced_wakeup then
  if strtoint(min) >= 5 then begin
   ClientSocket1.Socket.SendText('NICK '+Form3.Edit4.text+'|sleep'+#13#10);
   Forced_wakeup := false;
   progressbar1.Position := 0;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Form2.show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Form3.Show;
end;

procedure TForm1.Timer_DrinkTimer(Sender: TObject);
begin
timer_drink.Enabled := false;
progressbar1.Position := DefaultPosition;
ClientSocket1.Socket.SendText('NICK '+form3.Edit4.text+#13#10);
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var
 i:integer;
 H:integer;
begin
 H := 0 - 1 ;
 if listview2.items.count = 0 then exit;
 For i:=0 to listview2.items.count -1 do begin
  if listview2.Items[i].SubItems[0] = '0%' then
   h:=i;
  listview2.Items[i].SubItems[0] := inttostr(strtoint(copy(listview2.Items[i].SubItems[0],1,length(listview2.Items[i].SubItems[0])-1))-1)+'%';
 end;
 if H > -1 then
  listview2.Items[h].Delete;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
var
  F:TextFile;
  I:Integer;
begin

  if form1.ListView2.Items.Count = 0 then exit;

  AssignFile(F,'database1.txt');
  ReWrite(f);
  For I:=0 To Form2.ListView1.Items.Count -1 Do
  Begin
    WriteLn(F, Form2.listview1.items[i].caption);
    WriteLn(F, Form2.listview1.items[i].subitems[0]);
  End;
  CloseFile(F);

  if form1.ListView1.Items.Count = 0 then exit;

  AssignFile(F,'database2.txt');
  ReWrite(f);
  For I:=0 To Form2.ListView2.Items.Count -1 Do
  Begin
    WriteLn(F, Form2.listview2.items[i].caption);
  End;
  CloseFile(F);

end;

procedure TForm1.Timer5Timer(Sender: TObject);
var
  F:TextFile;
  S:String;
  Item:TListItem;
begin

  if not fileexists('database1.txt') then exit;
  if not fileexists('database2.txt') then exit;

  AssignFile(F, 'database1.txt');
  reset(f);
  read(f, s);
  Item := Form2.ListView1.Items.Add;
  Item.Caption := s;
  Readln(f, s);
  read(f, s);
  Item.SubItems.Add(S);
  Readln(f, s);
  While Not Eof(F) Do
  Begin
    read(f, s);
    Item := Form2.ListView1.Items.Add;
    Item.Caption := s;
    Readln(f, s);
    read(f, s);
    Item.SubItems.Add(S);
    Readln(f, s);
  End;
  CloseFile(F);

  AssignFile(F, 'database2.txt');
  reset(f);
  read(f, s);
  Item := Form2.ListView2.Items.Add;
  Item.Caption := s;
  readln(f, s);
  While Not Eof(F) Do
  Begin
    read(f, s);
    Item := Form2.ListView2.Items.Add;
    Item.Caption := s;
    readln(f, s);
  End;
  CloseFile(F);
  timer5.Enabled := false;
end;

end.

