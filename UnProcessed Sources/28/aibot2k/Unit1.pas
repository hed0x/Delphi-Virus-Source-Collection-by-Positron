unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, StdCtrls, ComCtrls, ExtCtrls, Unit2, Unit3;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    ListView1: TListView;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Memo2: TMemo;
    Button1: TButton;
    TabSheet4: TTabSheet;
    ListView2: TListView;
    ClientSocket1: TClientSocket;
    ListView3: TListView;
    Label6: TLabel;
    ListView4: TListView;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Timer1: TTimer;
    ListView5: TListView;
    ComboBox1: TComboBox;
    CheckBox5: TCheckBox;
    Procedure LearnWords(Line:String);
    Procedure AddWords(Line:String);
    Function CheckForExistence(Word1, Word2:String):Boolean;
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Connecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    Procedure SayWords(Words, Channel:String);
    Function  CreateLine(S:String):String;
    Function GetRandomWord(List:String):String;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Procedure WriteToChanOrUser(Data:String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Question: Boolean;
  MyNick: String;

  CN, PN : Integer;
  CH     : Array[0..36000]Of TForm2;
  PM     : Array[0..36000]Of TForm3;

implementation

{$R *.dfm}

Function GetNick(Param:String):String;
Begin
 Result := Copy(Param, 2, Pos('!', Param)-2);
End;

Function GetIdent(Param:String):String;
Begin
 Result := Copy(Param, Pos('!', Param)+1, Pos('@', Param)-2);
End;

Function GetHost(Param:String):String;
Begin
 Result := Copy(Param, Pos('@', Param)+1, Pos(' ', Param)-2);
End;

Function GetFullHost(Param:String):String;
Begin
 Result := Copy(Param, Pos('!', Param)+1, Pos(' ', Param)-2);
End;

Function GetChannel(Param:String):String;
Begin
 Result := Copy(Param, Pos('PRIVMSG', Param)+8, Length(Param));
 Result := Copy(Result, 1, Pos(':', result)-2);
End;

Function GetMessage(Param:String):String;
Begin
 Result := Copy(Param, Pos('PRIVMSG', Param)+8, Length(Param));
 Result := Copy(Result, Pos(':', result)+1, Length(Result));
 If Copy(Result, Length(Result)-1, 2) = #13#10 Then
   Result := Copy(Result, 1, Length(Result)-2);
End;

Procedure TForm1.WriteToChanOrUser(Data:String);
Var
 Nick,
 Channel :String;
 I:Integer;
 Butt: Boolean;
Begin
  randomize;
 {
  :p0ke\afk!~p0ke@CGNTuser-88B62C6.cust.bredbandsbolaget.se PRIVMSG #box :testing message
  :p0ke\afk!~p0ke@CGNTuser-88B62C6.cust.bredbandsbolaget.se PRIVMSG AiBot :testing message
 }

 Nick := TRIM(Copy(Data, 2, Pos('!',Data)-2));
 Data := TRIM(Copy(Data, Pos('PRIVMSG', Data)+8, Length(Data)));
 Channel := Trim(Copy(Data, 1, Pos(' ', Data)-1));
 Data := TRIM(Copy(Data, Pos(':', Data)+1, Length(Data)));
// Data := TRIM(COpy(Data, 1, Pos(#13#10, Data)-1));

 Butt := False;

 If Copy(Channel, 1, 1) = '#' Then
 Begin

   For I := 0 TO CN-1 Do
   Begin
     If CH[I].Caption = 'Channel '+Channel Then
     Begin
       Butt := True;
       CH[I].Memo1.Lines.Add('['+TimeToStr(Now)+'] <'+Nick+'> '+Data);
       CH[I].Show;
     End;
   End;

   If Not Butt Then
   Begin
     Application.CreateForm(TForm2, CH[CN]);
     CH[CN].Caption := 'Channel '+Channel;
     CH[CN].Memo1.Lines.Add('['+TimeToStr(Now)+'] <'+Nick+'> '+Data);
     CH[CN].Show;
     Inc(CN);
   End;

 End
 Else
 Begin
   For I := 0 TO PN-1 Do
   Begin
     If PM[I].Caption = 'PrivMsg $'+Nick Then
     Begin
       Butt := True;
       PM[I].Memo1.Lines.Add('['+TimeToStr(Now)+'] <'+Nick+'> '+Data);
       PM[i].Show;
     End;
   End;

   If Not Butt Then
   Begin
     Application.CreateForm(TForm3, PM[PN]);
     PM[PN].Caption := 'PrivMsg $'+Nick;
     PM[PN].Memo1.Lines.Add('['+TimeToStr(Now)+'] <'+Nick+'> '+Data);
     PM[PN].Show;
     Inc(PN);
   End;
 End;

End;

Function TForm1.GetRandomWord(List:String):String;
Var
 Words:Array[0..36000]of string;
 Nr   :Integer;
 Tmp1,
 Tmp2 :String;
Begin

 Nr := 0;

 Tmp1 := List + ',';
 While Tmp1 <> '' Do
 Begin
   Tmp2 := Copy(Tmp1, 1, Pos(',', Tmp1)-1);
   Words[Nr] := Tmp2;
   Inc(Nr);
   Tmp1 := Trim(Copy(Tmp1, Pos(',', Tmp1)+1, Length(Tmp1)));
 End;

 Randomize;
 Result := Words[Random(Nr)];

End;

Function TForm1.CreateLine(S:String):String;
Var
 I   :Integer;
 Tmp,
 Tmp2:String;
 Words:Array[0..36000] of string;
 Nr : Integer;
Begin
 Nr := 0;
 If Pos(',', S)>0 Then Begin
  While Pos(',',S)>0 Do Begin
   If Trim(Copy(S,1, pos(',', S)-1)) <> '' Then Begin
    Words[nr] := Trim(Copy(S,1, pos(',', S)-1));
    Inc(NR);
   End;
   S := Copy(S, pos(',', S)+1, length(S));
  End;
  If Trim(S) <> '' Then Begin
   Words[nr] := Trim(S);
   Inc(NR);
  End;
  Randomize;
  S := Words[Random(Nr)];
  Tmp := S;
 End Else Begin
  For I := 0 to ListView2.items.Count -1 Do Begin
   If LowerCase(ListView2.Items[i].Caption) = Lowercase(S) Then
   Begin
    Tmp := ListView2.Items[i].SubItems[0];
    Tmp2 := ListView2.Items[i].SubItems[1];
   End;
   If LowerCase(ListView2.Items[i].Caption) = Lowercase('&_'+S) Then
   Begin
    Tmp := ListView2.Items[i].SubItems[0];
    Tmp2 := ListView2.Items[i].SubItems[1];
   End;
  End;
 End;

 While Nr > 0 Do Begin
  Words[nr] := '';
  Dec(NR);
 End;

 Result := Tmp;
 S := Result;

 If Pos(',', S)>0 Then Begin
  While Pos(',',S)>0 Do Begin
   If Trim(Copy(S,1, pos(',', S)-1)) <> '' Then Begin
    Words[nr] := Trim(Copy(S,1, pos(',', S)-1));
    Inc(NR);
   End;
   S := Copy(S, pos(',', S)+1, length(S));
  End;
  If Trim(S) <> '' Then Begin
   Words[nr] := Trim(S);
   Inc(NR);
  End;
  Randomize;
  S := Words[Random(Nr)];
  Result := S + ' ' + GetRandomWord(Tmp2);
 End;

End;

Procedure TForm1.SayWords(Words, Channel:String);
Var
 i,j:integer;
 Line,
 Line2: String;
 Tmp:String;
Begin

 line := words;
 For I := 1 To Length(Line2) Do
  If Pos(Copy(Line2, i, 1), ':;=)([] abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')>0 Then
   Line := Line + Copy(Line2, i, 1);

 if copy(Line, length(line), 1)<> ' ' then line := line + ' ';
 while Line <> '' do begin
  line2 := copy(line, 1, pos(' ',line)-1);
  line := copy(line, pos(' ',line)+1, length(line));
  For i:=0 to listview5.items.count-1 do
   if lowercase(listview5.items[i].caption) = lowercase(line2) then begin

    // first-word in line found.           Line 2 = SubWord
    If CheckBox3.Checked Then
    Begin
      Randomize;

      If Random(100) < 20 Then
      Begin

        Tmp := 'PRIVMSG '+Channel+' :'+ListView3.Items[Random(ListView3.Items.count)].Caption+
               ', '+Line2+' ';

      End
      Else
        Tmp := 'PRIVMSG '+Channel+' :'+Line2+' ';

    End
    Else
      Tmp := 'PRIVMSG '+Channel+' :'+Line2+' ';

    Line2 := GetRandomWord(ListView5.Items[i].SubItems[0]);
    Tmp := Tmp + Line2 + ' ';

    line := CreateLine(Line2);
    repeat
     if copy(tmp, length(tmp)-length(line), length(line)) = line then break;
     Tmp := Tmp + line +' ';
     If Pos(' ', Line)>0 Then
      line := CreateLine(Copy(Line, Pos(' ', Line)+1, length(Line)))
     else
      Line := CreateLine(Line);
    until line = '';
    TMp := Tmp + #13#10;

    For J := 0 To CN-1 Do
    Begin
      If CH[J].Caption = 'Channel '+Channel Then
      Begin
        Ch[J].Memo1.Lines.Add('['+TimeToStr(Now)+'] <You> '+Tmp); 
      End;
    End;

    ClientSocket1.Socket.SendText(Tmp);
    Break;

   end;
 end;

End;

Function TForm1.CheckForExistence(Word1, Word2:String):Boolean;
Var
 I:Integer;
 Penis:string;
Begin
 Result := False;
 if copy(Word2,1,2) = '&_' then Word2 := copy(Word2, 3, length(Word2));
 if copy(Word1,1,2) = '&_' then Word1 := copy(Word1, 3, length(Word1));

 If ListView2.Items.Count <= 0 Then Exit;
 For I := 0 To ListView2.Items.Count -1 Do Begin
  penis := ListView2.Items[i].Caption;
  if copy(penis,1,2) = '&_' then penis := copy(penis, 3, length(penis));
  If LowerCase(penis) = LowerCase(Word1) Then Begin
   If Pos(lowercase(word2), listview2.items[i].SubItems[0])=0 Then begin
    If Word2 <> '' Then
     listview2.items[i].SubItems[0] := listview2.items[i].SubItems[0]+','+Word2;
   end;
   Result := True;
   Break;
  End;
 End;
End;

Procedure TForm1.AddWords(Line:String);
Var
 TmpWord: String;
 W2,W3  : String;
 Item   : TListItem;
 Nr     : Integer;
 Line2  : String;
 I      : Integer;
 Hej    : Boolean;
Begin
 Nr := 0;

 Line2 := Line;
 Line := '';

 For I := 1 To Length(Line2) Do
  If Pos(Copy(Line2, i, 1), '\/<>|:;=)([] abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')>0 Then
   Line := Line + Copy(Line2, i, 1);

 While Pos('  ',Line)>0 Do Begin
  Delete(Line, Pos('  ',Line), 1);
 End;

 If Pos(' ', Line)=0 Then line := line + ' ';
 If Copy(Line, Length(Line),1) <> ' ' Then line := line + ' ';
 While Line <> '' Do Begin
  TmpWord := Copy(Line, 1, Pos(' ',Line)-1);
  Line := Copy(Line, Pos(' ',Line)+1, Length(Line));
  Line2 := Line;

  W2 := Copy(Line2, 1, Pos(' ',Line2)-1);
  Line2 := Copy(Line2, Pos(' ',Line2)+1, Length(Line2));
  W3 := Copy(Line2, 1, Pos(' ',Line2)-1);
  Line2 := Copy(Line2, Pos(' ',Line2)+1, Length(Line2));

  If Nr = 0 Then
  Begin
    If W2 <> '' Then
    Begin

      Hej := False;
      For I := 0 To ListView5.Items.Count -1 Do
      Begin
        If Lowercase(ListView5.Items[i].Caption) = Lowercase(TmpWord) Then
        Begin
          Hej := True;
          If Pos(' '+W2+' ', ' '+ListView5.Items[i].SubItems[0]+' ') = 0 Then
          Begin
            If ListView5.Items[i].SubItems[0] <> '' Then
              ListView5.Items[i].SubItems[0] := ListView5.Items[i].SubItems[0] + ', ' + W2
            Else
              ListView5.Items[i].SubItems[0] := W2;            
          End;
        End;
      End;

      If Not Hej Then
      Begin
        Item := ListView5.Items.Add;
        Item.Caption := TmpWord;
        Item.SubItems.Add(W2);
      End;
    End;
  End;

  Inc(Nr);

  If Not (CheckForExistence(TmpWord, W2)) And
  Not (CheckForExistence(W2, W3)) Then Begin
   Item := ListView2.Items.Add;
   Item.Caption := TmpWord;
   Item.SubItems.Add(W2);
   Item.SubItems.Add(W3);
  End;

 End;
End;

Procedure TForm1.LearnWords(Line:String);
Var
 AllLines : Array[0..90000]Of String;
 Dot      : Integer;
 Tmp      : String;
 Tmp2     : String;
 Str      : String;
 Nr       : Integer;
 I        : Integer;
Begin

// ListView2
 Nr := 0;
 Dot := Pos('.',Line);
 If Dot > 0 Then Begin
  Tmp := '';
  Tmp2:= '';
  Str := Line;
  While Dot > 0 Do Begin
   Tmp := Copy(Str, 1, Dot-1);
   Tmp2:= Copy(Str, Dot+1, Length(Str));
   AllLines[Nr] := TRIM(Tmp);
   Inc(Nr);
   Str := Tmp2;
   Dot := Pos('.',Tmp2);
  End;
  If Tmp2 <> '' Then Begin
   AllLines[Nr] := Tmp2;
   Inc(Nr);
  End;
 End;

 If Nr = 0 Then
  AddWords(Line)
 Else
  For I:=0 To Nr-1 Do
   If AllLines[i] <> '' Then
    AddWords(AllLines[I]);

End;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  temp:string;
  chan:String;
  data:String;
  i,j :integer;
  Item:TListItem;
  nick:String;
  TMPData:String;
begin

  data := socket.ReceiveText;
  memo1.Lines.Add(data);

  TMPData := Data;

  {
  Repeat
  Data := Copy(TMPData, 1, Pos(#13#10, TMPData)+1);
  If Pos(#13#10, TMPData)=0 Then
    TMPData := TMPData + #13#10;

  TMPData := Copy(TmpData, Pos(#13#10, Data)+2, Length(Data));
  }

  If Pos('353', Data)>0 Then begin
   Data := Copy(Data, pos(' 353 ',data)+4, length(Data));
   Data := Copy(Data, 1, pos(#13#10, data)-1);
   If Copy(Data, length(data), 1)<> ' ' then data := data + ' ';
   temp := Copy(data, pos('#', data), length(data));
   temp := copy(temp, 1, pos(' ', temp)-1);
   data := copy(data, pos(':', data)+1, length(data));
   While Data <> '' Do Begin
    Item := ListView1.Items.Add;
    If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '@' Then
      item.Caption := Copy(Data, 2, pos(' ',data)-1)
    else
    If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '&' Then
      item.Caption := Copy(Data, 2, pos(' ',data)-1)
    else
    If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '~' Then
      item.Caption := Copy(Data, 2, pos(' ',data)-1)
    else
    If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '+' Then
      item.Caption := Copy(Data, 2, pos(' ',data)-1)
    else
    If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '%' Then
      item.Caption := Copy(Data, 2, pos(' ',data)-1)
    else
      item.Caption := Copy(Data, 1, pos(' ',data)-1);
    Item.SubItems.Add('00:00:00');
    Item.SubItems.Add('');
    Item.SubItems.Add('?');
    Item.SubItems.Add(Temp);

    For I := 0 To CN-1 Do
    Begin
      If CH[I].Caption = 'Channel '+Temp Then
      Begin

        Item := CH[I].ListView1.Items.Add;
        If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '@' Then
          item.Caption := Copy(Data, 2, pos(' ',data)-1)
        else
        If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '&' Then
          item.Caption := Copy(Data, 2, pos(' ',data)-1)
        else
        If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '~' Then
          item.Caption := Copy(Data, 2, pos(' ',data)-1)
        else
        If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '+' Then
          item.Caption := Copy(Data, 2, pos(' ',data)-1)
        else
        If Copy(Copy(Data, 1, pos(' ',data)-1), 1, 1) = '%' Then
          item.Caption := Copy(Data, 2, pos(' ',data)-1)
        else
          item.Caption := Copy(Data, 1, pos(' ',data)-1);
        If copy(data, pos(' ',data)+1, length(data)) = '' Then
          CH[I].Label1.Caption := IntToStr(CH[I].ListView1.Items.Count) + ' users in '+Temp;

      End;
    End;

    data := copy(data, pos(' ',data)+1, length(data));
   End;
   Data := TMPData;
  end;

  If pos('MOTD', data)>0 Then Begin
   if memo2.Text = '' then exit;
   for i :=0 to memo2.Lines.Count -1 do
   Begin
    socket.SendText('JOIN '+memo2.Lines.Strings[i]+#13#10);
    Application.CreateForm(TForm2, CH[CN]);
    CH[CN].Caption := 'Channel '+Memo2.Lines.Strings[i];
    CH[CN].Show;
    Inc(CN);
   End;
   Data := TMPData;
  End;

  If Pos('PING :',data)>0 Then Begin
   Data := Copy(Data, pos('PING',data)+4, length(Data));
   Data := Copy(Data, 1, pos(#13#10, data)-1);
   Socket.SendText('PONG'+Data+#13#10);
  End;

  If Pos('NICK', Data)>0 Then
  Begin
    Nick := Copy(Data, 2, Pos('!',Data)-2);
    Temp := Copy(Data, Pos('NICK', Data)+6, length(Data));
    Temp := Copy(Temp, 1, Pos(#13, Temp)-1);

    For I := 0 To ListView1.Items.Count -1 Do
    Begin
      If ListView1.Items[i].Caption = Nick Then
      Begin
        ListView1.Items[i].Caption := Trim(Temp);
      End;
    End;

    For I := 0 To CN-1 Do
    Begin

      For J := 0 To CH[I].ListView1.Items.Count -1 Do
      Begin
        If Ch[i].ListView1.Items[j].Caption = Nick Then
        Begin
          Ch[i].Memo1.Lines.Add('['+TimeToStr(NOW)+'] ~~~ '+Nick+' changed to '+Temp+' ~~~');
          Ch[i].ListView1.Items[j].Caption := Temp;
        End;
      End;

    End;
    For I := 0 To PN-1 Do
    Begin

      If PM[I].Caption = 'PrivMsg $'+Nick Then
      Begin
        PM[i].Caption := 'PrivMsg $'+Temp;
        PM[i].Memo1.Lines.Add('['+TimeToStr(NOW)+'] ~~~ '+Nick+' changed to '+Temp+' ~~~');
      End;

    End;
    Data := TMPData;
  End;

  If Pos('JOIN', Data)>0 Then
  Begin
  {
    :p0ke\afk!~p0ke@CGNTuser-88B62C6.cust.bredbandsbolaget.se JOIN :#box
  }
    Nick := Copy(Data, 2, Pos('!',Data)-2);
    Data := Copy(Data, Pos('#',Data), length(Data));
    Data := Copy(Data, 1, Pos(#13#10, Data)-1);
    If Nick <> MyNick Then
    Begin
      Item := ListView1.Items.Add;
      Item.Caption := Nick;
      Item.SubItems.Add('00:00:00');
      Item.SubItems.Add('');
      Item.SubItems.Add('?');
      Item.SubItems.Add(Data);
    End;

    For I := 0 To CN -1 Do
    Begin
      If CH[i].Caption = 'Channel '+Trim(Data) Then
      Begin
        If Nick <> MyNick Then
        Begin
          Item := CH[i].ListView1.Items.Add;
          Item.Caption := Nick;
          CH[i].Label1.Caption := IntToStr(CH[i].ListView1.Items.Count)+' users in '+Data;
          CH[i].Memo1.Lines.Add('['+TimeToStr(NOW)+'] ~~~ '+Nick+' joined '+Data+' ~~~');
        End;
      End;
    End;
    Data := TMPData;
  End;

  If Pos('QUIT', Data)>0 Then
  Begin
    Nick := Copy(Data, 2, Pos('!',Data)-2);
    Data := CopY(Data, Pos('#',Data), Length(Data));
    Data := Copy(Data, 1, Pos(#13#10, Data)-1);

    For I := 0 To ListView1.Items.Count -1 Do
    Begin
      If ListView1.Items[i].Caption = Nick Then
      Begin

        ListView1.Items[i].Delete;
        Break;
      End;
    End;

    For J := 0 To CN-1 Do
    Begin
      For I := 0 To CH[j].ListView1.Items.Count -1 Do
      Begin
        If CH[j].ListView1.Items[i].Caption = Nick Then
        Begin
          CH[j].ListView1.Items[i].Delete;
          CH[j].Label1.Caption := IntToStr(CH[j].ListView1.Items.Count)+' users in '+Data;
          CH[j].Memo1.Lines.Add('['+TimeToStr(NOW)+'] ~~~ '+Nick+' quit from '+Data+' ~~~');
          Break;
        End;
      End;
    End;
    Data := TMPData;
  End;

  If Pos('PART', Data)>0 Then
  Begin
    Nick := Copy(Data, 2, Pos('!',Data)-2);
    Data := CopY(Data, Pos('#',Data), Length(Data));
    Data := Copy(Data, 1, Pos(#13#10, Data)-1);

    For I := 0 To ListView1.Items.Count -1 Do
    Begin
      If ListView1.Items[i].Caption = Nick Then
      Begin
        ListView1.Items[i].Delete;
        Break;
      End;
    End;

    For J := 0 To CN-1 Do
    Begin
      For I := 0 To CH[j].ListView1.Items.Count -1 Do
      Begin
        If CH[j].ListView1.Items[i].Caption = Nick Then
        Begin
          CH[j].ListView1.Items[i].Delete;
          CH[j].Label1.Caption := IntToStr(CH[j].ListView1.Items.Count)+' users in '+Data;
          CH[j].Memo1.Lines.Add('['+TimeToStr(NOW)+'] ~~~ '+Nick+' part from '+Data+' ~~~');
          Break;
        End;
      End;
    End;
    Data := TMPData;
  End;



  if pos('PRIVMSG', data)>0 then begin
   Nick := Copy(Data, 2, Pos('!',Data)-2);

   WriteToChanOrUser(Data);

   Chan := Copy(Data, Pos(' #',Data)+1, Length(Data));
   Chan := Copy(Chan, 1, Pos(' ', Chan)-1);
   Data := Copy(data, pos('PRIVMSG',data)+8, length(data));
   Data := Copy(Data, pos(':',data)+1, length(data));
   data := copy(Data, 1, pos(#13#10, data)-1);
   If CheckBox1.Checked Then
     LearnWords(Data);

   If Pos(Lowercase(Edit1.Text), Lowercase(Data)) >0 Then
   Begin
     For I := 0 To ListView3.Items.Count -1 Do
     Begin

       If Pos(Lowercase(ListView3.Items[i].Caption), LowerCase(Data))>0 Then
       Begin

         If CheckBox4.Checked Then
         Begin

           Randomize;
           Temp := 'PRIVMSG '+Chan+' :'+Nick+' == '+
                   ListView3.Items[Random(ListView3.Items.count)].Caption+#13#10;
           Socket.SendText(Temp);
           Exit;

         End;

       End;

     End;
   End;

   If Pos('female',lowercase(Data)) > 0 Then
   Begin
     If Question Then
     Begin
       Question := False;
       For I:=0 To ListView1.Items.Count -1 Do
       Begin
         If ListView1.Items[i].Caption = Nick Then
         Begin
           ListView1.Items[i].SubItems[2] := 'F';
           Temp := 'PRIVMSG '+Chan+' :Hurray \o/'#13#10;
           Socket.SendText(Temp);
         End;
       End;
     End;
   End
   else
   If Pos('male',lowercase(Data)) > 0 Then
   Begin
     If Question Then
     Begin
       Question := False;
       For I:=0 To ListView1.Items.Count -1 Do
       Begin
         If ListView1.Items[i].Caption = Nick Then
         Begin
           ListView1.Items[i].SubItems[2] := 'M';
           Temp := 'PRIVMSG '+Chan+' :Awww :/'#13#10;
           Socket.SendText(Temp);
         End;
       End;
     End;
   End;

   If Pos(' ',Data) = 0 Then
     Data := Data + ' ';
{
   For I := 0 To ListView4.Items.Count -1 Do
   Begin
     If LowerCase(Trim(ListView4.Items[i].Caption)) =
        LowerCase(Trim(Copy(Data, 1, Pos(' ', Data)-1))) Then
     Begin
       Temp := 'PRIVMSG '+Chan+' :';
       Randomize;
       Temp := Temp + ListView4.Items[ Random(ListView4.Items.Count) ].Caption;
       Temp := Temp + ', ' + Nick + #13#10;
       If Not CheckBox2.Checked Then
         Socket.SendText (Temp);
       Exit;
     End;
   End;
}
   If Not CheckBox2.Checked Then
   Begin
     Randomize;
     If Random(200) > 150 Then
     Begin
       SayWords(Data, Chan);
     End;
   End;

   For I := 0 To ListView1.Items.Count -1 Do
   Begin
     If Trim(ListView1.Items[i].Caption) = Trim(Nick) Then
     Begin
       If ListView1.Items[i].SubItems[1] = '' Then
       Begin
         If Pos(' ',Data) = 0 Then
           Data := Data + ' ';
         ListView1.Items[i].SubItems[1] := Copy(Data, 1, Pos(' ',Data)-1);
         Item := ListView4.Items.Add;
         Item.Caption := Copy(Data, 1, Pos(' ',Data)-1);

         If CheckBox5.Checked Then
         Begin
           Temp := 'PRIVMSG '+Chan+' :'+Nick+', Are you female ?'#13#10;
           Socket.SendText(Temp);
           Question := True;
         End;

       End;
     End;
   End;
    Data := TMPData;
  end;

  If pos('VERSION', data)>0 Then
  Begin
    socket.SendText('VERSION reply p0kebot made by SiC'#13#10);
  End;

//  Until TMPData = '';

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ClientSocket1.Port := StrToInt(Edit5.text);
  ClientSocket1.Host := Edit4.text;
  ClientSocket1.Active := true;
  MyNick := Edit1.Text;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Panel1.Caption := 'IrcBot - Connected to '+Socket.RemoteAddress;

  //PING :1577254265
  Socket.SendText('USER '+Edit3.Text+' '+Edit3.text+'@gayman.com '+Edit3.Text+' '+Edit3.text+#13#10);
  Socket.SendText('NICK '+Edit1.Text+#13#10);
end;

procedure TForm1.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Panel1.Caption := 'IrcBot - Connecting';
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ListView1.Clear;
  Panel1.Caption := 'IrcBot - Disconnected';
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Panel1.Caption := 'IrcBot - Disconnected';
  ListView1.Clear;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var
  I,
  Hour,
  Min,
  Sec : Integer;
  Temp:String;
begin

  If ListView1.Items.Count = 0 Then
    Exit;

  For I := 0 to ListView1.Items.Count -1 Do
  Begin

    Temp := ListView1.Items[i].SubItems[0];
    Hour := StrToInt(Copy(Temp, 1, Pos(':', Temp)-1));
    Temp := Copy(Temp, Pos(':', Temp)+1, Length(Temp));
    Min  := StrToInt(Copy(Temp, 1, Pos(':', Temp)-1));
    Temp := Copy(Temp, Pos(':', Temp)+1, Length(Temp));
    Sec  := StrToInt(Temp);

    Inc(Sec);
    If Sec = 60 Then
    Begin

      Sec := 0;

      Inc(Min);
      If Min = 60 Then
      Begin

        Inc(Hour);
        Min := 0;

      End;

    End;

    If Hour < 10 Then
      Temp := '0'+IntToStr(Hour)+':'
    Else
      Temp := IntToStr(Hour)+':';

    If Min  < 10 Then
      Temp := Temp + '0'+IntToStr(Min)+':'
    Else
      Temp := Temp + IntToStr(Min)+':';

    If Sec  < 10 Then
      Temp := Temp + '0'+IntToStr(Sec)
    Else
      Temp := Temp + IntToStr(Sec);

    ListView1.Items[i].SubItems[0] := Temp;

  End;

end;

procedure TForm1.Button2Click(Sender: TObject);
Var
 I:Integer;
begin
  For I := 0 To Memo2.Lines.Count -1 Do
  Begin
    Randomize;
    SayWords(
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption+','+
    ListView2.Items[Random(ListView2.Items.Count)].Caption,
    Memo2.Lines.Strings[i]);
  End;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 F:TextFile;
 T:String;
 Item:TListItem;
begin
 CN := 0;
 PN := 0;
 If FileExists('l1.dat') Then
 Begin
   AssignFile(F, 'l1.dat');
   Reset(f);
   Read(F, T);
   Item := ListView5.Items.Add;
   Item.Caption := Copy(T, 1, Pos(' ', T)-1);
   Item.SubItems.Add(Copy(T, Pos(' ', T)+1, Length(T)));
   ReadLn(F, T);
   While Not Eof(F) Do
   Begin
     Read(F, T);
     Item := ListView5.Items.Add;
     Item.Caption := Copy(T, 1, Pos(' ', T)-1);
     Item.SubItems.Add(Copy(T, Pos(' ', T)+1, Length(T)));
     ReadLn(F, T);
   End;
   CloseFile(F);
 End;

 If FileExists('l2.dat') Then
 Begin
   AssignFile(F, 'l2.dat');
   Reset(f);
   Read(F, T);
   Item := ListView2.Items.Add;
   Item.Caption := Copy(T, 1, Pos(' ', T)-1);
   Item.SubItems.Add(Copy(T, Pos(' ', T)+1, Pos(#0160, T)-2));
   Item.SubItems.Add(Copy(T, Pos(#0160, T)+1, Length(T)));
   ReadLn(F, T);
   While Not Eof(F) Do
   Begin
     Read(F, T);
     Item := ListView2.Items.Add;
     Item.Caption := Copy(T, 1, Pos(' ', T)-1);
     Item.SubItems.Add(Copy(T, Pos(' ', T)+1, Pos(#0160, T)-2));
     Item.SubItems.Add(Copy(T, Pos(#0160, T)+1, Length(T)));
     ReadLn(F, T);
   End;
   CloseFile(F);
 End;

 If FileExists('l3.dat') Then
 Begin
   ListView3.Clear;
   AssignFile(F, 'l3.dat');
   Reset(f);
   Read(F, T);
   Item := ListView3.Items.Add;
   Item.Caption := T;
   ReadLn(F, T);
   While Not Eof(F) Do
   Begin
     Read(F, T);
     Item := ListView3.Items.Add;
     Item.Caption := T;
     ReadLn(F, T);
   End;
   CloseFile(F);
 End;

 If FileExists('l4.dat') Then
 Begin
   ListView4.Clear;
   AssignFile(F, 'l4.dat');
   Reset(f);
   Read(F, T);
   Item := ListView4.Items.Add;
   Item.Caption := T;
   ReadLn(F, T);
   While Not Eof(F) Do
   Begin
     Read(F, T);
     Item := ListView4.Items.Add;
     Item.Caption := T;
     ReadLn(F, T);
   End;
   CloseFile(F);
 End;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Var
 F:TextFile;
 I:Integer;
begin

 AssignFile(F, 'l1.dat');
 ReWrite(F);
 For I := 0 To ListView5.Items.Count -1 Do
 Begin
   WriteLn(F, ListView5.Items[i].Caption + ' ' + ListView5.Items[i].Subitems[0]);
 End;
 CloseFile(F);

 AssignFile(F, 'l2.dat');
 ReWrite(F);
 For I := 0 To ListView2.Items.Count -1 Do
 Begin
   WriteLn(F, ListView2.Items[i].Caption + ' ' + ListView2.Items[i].Subitems[0] +
              #0160 + ListView2.Items[i].SubItems[1]);
 End;
 CloseFile(F);

 AssignFile(F, 'l3.dat');
 ReWrite(F);
 For I := 0 To ListView3.Items.Count -1 Do
 Begin
   WriteLn(F, ListView3.Items[i].Caption);
 End;
 CloseFile(F);

 AssignFile(F, 'l4.dat');
 ReWrite(F);
 For I := 0 To ListView4.Items.Count -1 Do
 Begin
   WriteLn(F, ListView4.Items[i].Caption);
 End;
 CloseFile(F);

end;

procedure TForm1.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
    clientsocket1.Socket.SendText(ComboBox1.text+#13#10);
    ComboBox1.Items.Add(ComboBox1.Text);
    If ComboBox1.Items.Count > 0 then
    ComboBox1.Items.Move(ComboBox1.Items.Count-1,0);
    ComboBox1.text := '';
    ZeroMemory(@Key, SizeOf(Key));
  end;
end;

end.
