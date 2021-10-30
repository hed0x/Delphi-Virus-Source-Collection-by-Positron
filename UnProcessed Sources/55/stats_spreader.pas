unit stats_spreader;

interface

Uses
  Windows, Spreader_Bot;

Var
        NetBios_Infect          :Integer=0;
        MyDoom_Infect           :Integer=0;
        Beagle1_Infect          :Integer=0;
        Beagle2_Infect          :Integer=0;
        NetDevil_Infect         :Integer=0;
        Optix_Infect            :Integer=0;
        Sub7_Infect             :Integer=0;
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
  Stats := '[no spread info aviable in LITE version]';
End;

end.
