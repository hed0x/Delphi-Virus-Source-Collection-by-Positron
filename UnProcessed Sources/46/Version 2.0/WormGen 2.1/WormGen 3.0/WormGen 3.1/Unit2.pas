unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
 Path,
 nFile,
 oFile:String;
 Nr   :Integer;
begin

 Path := ExtractFilePath(ParamStr(0));
 Path := Path + 'Library\';

 oFile := ExtractFileName(Label2.caption);
 nFile := Edit1.Text;

 Nr := 0;
 While FileExists(Path+nFile+'.snp') Do Begin
  nFile := Edit1.Text+IntToStr(Nr);
  Inc(Nr);
 End;
 nFile := nFile + '.snp';

 RenameFile(Path+oFile, Path+nFile);
// CopyFile(pChar(Path+oFile), pChar(Path+nFile), False);
 Form1.UpdateList;
 Form2.Hide;
 
end;

end.
