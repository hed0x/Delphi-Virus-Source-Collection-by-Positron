unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ScktComp;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Edit5: TEdit;
    Button3: TButton;
    ClientSocket1: TClientSocket;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
//    Procedure AddWords(Str:String);
    Function WordsExist(Str:String):Boolean;
    Function SubjectWord(Str:String):Integer;
    Procedure Speak(Str:String);
    procedure Button2Click(Sender: TObject);
    function StripWord(Str:String):String;
    procedure Button3Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  teh_string:string;

implementation

{$R *.dfm}

function TForm1.StripWord(Str:String):String;
Var
 Words:Array[0..63556]of String;
 F : Integer;
 I : Integer;
Begin
 Repeat
  F := Pos(chr(0160),str);
  Delete(Str, F, 1);
  Insert(' ', str, F);
 Until pos(chr(0160),Str)=0;

 If Str[Length(Str)] <> ' ' Then
  Str := Str + ' ';
 I:=0;
 Repeat
  F := Pos(' ', Str);
  if Copy(Str, 1, F-1) <> '' then begin
   Words[i] := Copy(Str, 1, F-1);
   Inc(I);
  End;
  Str := Copy(Str, F+1, Length(Str));  
 Until Pos(' ', Str)=0;

 Randomize;
 Result := Words[Random(I)];

End;

Function TForm1.SubjectWord(Str:String):Integer;
Var
 I:Integer;
 F:Integer;
 Numbers:Array[0..99999]of Integer;
Begin
 F:=0;
 I:=0;
 Numbers[0] := 0;
 For i:=0 To ListView1.Items.Count -1 Do Begin
  If AnsiLowerCase(ListView1.Items[i].Caption) = AnsiLowerCase(Str) Then Begin
   Numbers[F] := I;
   Inc(F);
  End;
 End;

 Randomize;
 F := Random(F);

 Result := Numbers[F];
End;

Procedure TForm1.Speak(Str:String);
Var
 S,A:String;
 F:Integer;
 I:Integer;
 G:Integer;
 Words:Array[0..2048]of string;
Begin
 Randomize;
 If Str[Length(Str)] <> ' ' Then
  Str := Str + ' ';

 G := 0;
 Repeat
  F := Pos(' ', Str);
  Words[G] := Copy(Str, 1, F-1);
  Str := Copy(Str, F+1, Length(Str));
  Inc(G);
 Until Pos(' ', Str)=0;

 Randomize;
 I := SubjectWord(edit2.text);
 If i = 0 Then Begin
  I := SubjectWord(words[Random(G)]);
  If i = 0 then Random(ListView1.items.Count);
 End;
 S := ListView1.items[i].Caption+' ';
 F:=0;
 F:=Random(20)+9000;
 Repeat
  S := S + StripWord(ListView1.Items[I].SubItems[0])+' ';
  S := S + StripWord(ListView1.Items[I].SubItems[1])+' ';
  A := StripWord(ListView1.Items[I].SubItems[2]);
  S := S + A;
  I := 0;
  I := SubjectWord(A);
  If I = 0 Then Begin
   S := S +'.';
   Break;
  End Else S := S +' ';
  Dec(F);
 Until F <= 0;
 Randomize;
 ClientSocket1.Socket.SendText('PRIVMSG '+Edit4.text+' :'+S+#13#10);
End;

Function TForm1.WordsExist(Str:String):Boolean;
Var
 Words:Array[0..2048]of string;
 F:Integer;
 I:Integer;
 W1,W2,W3,W4:Integer;
 Q1,Q2,Q3,Q4:boolean;
Begin
 Result := True;
 If Str[Length(Str)] <> ' ' Then
  Str := Str + ' ';
 I:=0;
 Repeat
  F := Pos(' ', Str);
  Words[i] := Copy(Str, 1, F-1);
  Str := Copy(Str, F+1, Length(Str));
  Inc(I);
 Until Pos(' ', Str)=0;

 F := 0;

 Repeat
  Q1 := false;
  Q2 := false;
  Q3 := false;
  Q4 := false;
  For W1 := 0 To ListView1.Items.Count -1 Do Begin
   If ansilowercase(ListView1.Items[W1].Caption) = ansilowercase(Words[F]) Then Begin
   Q1 := True;
// found word 1
    For W2 := 0 To ListView1.Items.Count -1 Do Begin
    If (ansilowercase(ListView1.Items[W2].Caption) = ansilowercase(Words[F])) and
       (Pos(ansilowercase(Words[F+1]),ansilowercase(ListView1.Items[W2].SubItems[0]))>0) Then
    Q2 := True;
// found word 2
     For W3 := 0 To ListView1.Items.Count -1 Do Begin
     If (Pos(ansilowercase(Words[F+1]),ansilowercase(ListView1.Items[W3].SubItems[0]))>0)
        and (Pos(ansilowercase(Words[F+2]),ansilowercase(ListView1.Items[W3].SubItems[1]))>0) Then
     Q3 := True;
// found word 3
      For W4 := 0 To ListView1.Items.Count -1 Do Begin
      If (Pos(ansilowercase(Words[F+2]),ansilowercase(ListView1.Items[W4].SubItems[1]))>0)
         and (Pos(ansilowercase(Words[F+3]),ansilowercase(ListView1.Items[W4].SubItems[2]))>0) Then
      Q4 := True;
// found word 4
      End;
// end w4
     End;
// end w3
    End;
// end w2
   If Not Q2 Then
    if Words[F+1] <> '' then
    ListView1.Items[W1].SubItems[0] := ListView1.Items[W1].SubItems[0] + chr(0160)+Words[F+1];
   If Not Q3 Then
    if Words[F+2] <> '' then
    ListView1.Items[W1].SubItems[1] := ListView1.Items[W1].SubItems[1] + chr(0160)+Words[F+2];
   If Not Q4 Then
    if Words[F+3] <> '' then
    ListView1.Items[W1].SubItems[2] := ListView1.Items[W1].SubItems[2] + chr(0160)+Words[F+3];
   End;
// end w1
  End;
  Inc(F);
  Dec(I);
 Until I = 0;
 IF (q1) Then Result := True else Result := False;
End;

Procedure AddWords;
Var
 Words:Array[0..2048]of string;
 F:Integer;
 I:Integer;
 US:TListItem;
 str:string;
Begin
 str:= teh_string;
 If Str[Length(Str)] <> ' ' Then
  Str := Str + ' ';
 I:=0;
 Repeat
  F := Pos(' ', Str);
  Words[i] := Copy(Str, 1, F-1);
  Str := Copy(Str, F+1, Length(Str));
  Inc(I);
 Until Pos(' ', Str)=0;

 F := 0;
 if Words[0] = '' Then Exit;
 Repeat
  If (Words[F] <> '') Then Begin
   if (not form1.wordsexist(ansilowercase(Words[F])+' '+ansilowercase(Words[F+1])+' '+ansilowercase(Words[F+2])+' '+ansilowercase(Words[F+3]))) and
      (not form1.wordsexist(ansilowercase(Words[F])+' '+ansilowercase(Words[F+1])+' '+ansilowercase(Words[F+2]))) and
      (not form1.wordsexist(ansilowercase(Words[F])+' '+ansilowercase(Words[F+1]))) and
      (not form1.wordsexist(ansilowercase(Words[F]))) then begin
    US := form1.ListView1.Items.Add;
    US.Caption := Words[F];
    US.SubItems.Add(Words[F+1]);
    US.SubItems.Add(Words[F+2]);
    US.SubItems.Add(chr(0160)+Words[F+3]);
   end;
  End;
  Inc(F);
  Dec(i);
 Until i = 0;

End;

procedure TForm1.Button1Click(Sender: TObject);
var
 a:dword;
begin
 teh_String := Edit1.text;

  CreateThread(0,0,@AddWords,0,0,a);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 If CheckBox1.Checked Then
  Speak('9943ofifd9g9adf90g0fdh');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ClientSocket1.Host := Edit3.text;
ClientSocket1.Active := true;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 S,H:String;
 F:Integer;
begin
 S:= Socket.ReceiveText;
 If Pos('PRIVMSG',S)>0 Then Begin
  Edit1.text := Copy(S, Pos('PRIVMSG',S)+8, Length(S));
  Edit1.Text := Copy(Edit1.text, Pos(':',Edit1.text)+1, Length(Edit1.text));
  Edit1.text := Copy(Edit1.text, 1, pos(#13#10, edit1.text)-1);
  Button1Click(Self);
  H := ansilowercase(Edit1.text);
  If pos('your',H)>0 then begin
   F := pos('your',H);
   Delete(H,Pos('your',h),4);
   randomize;
   if random(100) > 50 then
    Insert('mine',H,F)
   else
    Insert('my',H,F);
  end;

  If pos('mine',H)>0 then begin
   F := pos('mine',H);
   Delete(H,Pos('mine',h),4);
   if random(100) > 50 then
    Insert('your',H,F)
   else
    Insert('ur',H,F);
  end;

  If pos('me',H)>0 then begin
   F := pos('me',H);
   Delete(H,Pos('me',h),2);
   Insert('you',H,F);
  end;

  If pos('you',H)>0 then begin
   F := pos('you',H);
   Delete(H,Pos('you',h),3);
   Insert('me',H,F);
  end;

  If pos('i',H)>0 then begin
   F := pos('i',H);
   Delete(H,Pos('i',h),4);
   Insert('you',H,F);
  end;
  Edit1.text := H;
  Edit2.text := StripWord(Edit1.text);
  Randomize;
  If Random(100) > 20 then
   Button2Click(Self);
 End;
 If Pos('MOTD',S)>0 Then Socket.SendText('JOIN '+Edit4.text+#13#10);
 If Pos('PING',S)>0 then Socket.SendText('PONG :'+copy(s, pos('PING',S)+6,length(S))); 
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Socket.SendText('USER '+edit5.text+' '+edit5.text+'@food.com 0 0'+#13#10);
Socket.SendText('NICK '+edit5.text+#13#10);
end;

end.
