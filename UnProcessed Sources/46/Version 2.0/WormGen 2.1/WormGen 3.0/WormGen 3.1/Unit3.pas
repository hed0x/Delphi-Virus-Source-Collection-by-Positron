unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
 Path:String;
 F   :TextFile;
 Text:String;
 Tmp1:String;
 Tmp2:String;
begin
 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Library\' + Label2.caption;
 If Not FileExists(Path) Then Begin
  MessageBox(0, 'Error saving description', 'Error', mb_ok);
  Form1.UpdateList;
  Close;
  Exit;
 End;

 AssignFile(F, Path);
 Reset(F);
 Read(F, Tmp1);
 Text := Tmp1 + #13#10;
 ReadLn(F, Tmp1);
 While Not Eof(F) Do Begin
  Read(F, Tmp1);
  Text := Text + Tmp1 + #13#10;
  ReadLn(F, Tmp1);
 End;
 CloseFile(F);

 Tmp1 := Copy(Text,1, Pos('Description', Text)-1);
 Tmp2 := Copy(Text, Pos('Description', Text), Length(Text));
 Tmp2 := Copy(Tmp2, pos(#13#10, Tmp2)+2, length(Tmp2));

 Text := Tmp1 +
 'Description: '+Memo1.Text+#13#10+Tmp2;

 AssignFile(F, Path);
 ReWrite(F);
 Write(F, Text);
 CloseFile(F);
 Form1.UpdateList;
 Close;

end;

procedure TForm3.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = 13 then zeromemory(@key, sizeof(key));
end;

procedure TForm3.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
 if key = #13 then zeromemory(@key, sizeof(key));
end;

end.
