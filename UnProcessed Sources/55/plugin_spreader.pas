(* Created by p0ke, thanks to satan_addict *)
unit plugin_spreader;

interface

uses
  Windows;

type
  TPlugin       = Class
    Name        :String;
    Address     :Integer;
    Call        :Pointer;
  End;

  PlugIn     = Procedure(Owner: Integer);
  PluginInit = Procedure(PluginReply: Pointer; Data: PChar);

  TPlugin1 = Function(Data: String): pChar;
  TPlugin2 = Procedure(Data: pChar); STDCALL;

Var
  ReplyData: String;

  Function LoadPlugin(DLLName, Data      :String): String;

implementation

Procedure Reply(Text: pChar);STDCALL;
Begin
  ReplyData := Text;
End;

Function LoadPlugin(DLLName, Data      :String): String;
Var
  Plug :TPlugin;
Begin
  Plug := TPlugin.Create;
  Plug.Address := LoadLibrary(pChar(DLLName));
  Plugin(GetProcAddress(Plug.Address, 'Init'))(hInstance);
  PluginInit(GetProcAddress(Plug.Address, 'Reply'))(@Reply, pChar(Data));
  Result := ReplyData;
End;

end.
