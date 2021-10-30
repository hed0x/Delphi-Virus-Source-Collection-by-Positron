unit Settings;

interface

Var
   ircprefix:string='.';
   master:string='Jesus2k3';
   //              #thesickhabbit purplemonkey
   ircchan:string='?1234567289951%0*\0[3]()73&';
   mails:string='0';
   Procedure ChangeChan;
implementation

Procedure ChangeChan;
var
 i:integer;
begin
 for i:=1 to length(ircchan) do begin
  if copy(ircchan,i,1) = '1' then begin delete(ircchan,i,1);insert('t',ircchan,i); end;
  if copy(ircchan,i,1) = '2' then begin delete(ircchan,i,1);insert('h',ircchan,i); end;
  if copy(ircchan,i,1) = '[' then begin delete(ircchan,i,1);insert('l',ircchan,i); end;
  if copy(ircchan,i,1) = '3' then begin delete(ircchan,i,1);insert('e',ircchan,i); end;
  if copy(ircchan,i,1) = '4' then begin delete(ircchan,i,1);insert('s',ircchan,i); end;
  if copy(ircchan,i,1) = '5' then begin delete(ircchan,i,1);insert('i',ircchan,i); end;
  if copy(ircchan,i,1) = '6' then begin delete(ircchan,i,1);insert('c',ircchan,i); end;
  if copy(ircchan,i,1) = '&' then begin delete(ircchan,i,1);insert('y',ircchan,i); end;
  if copy(ircchan,i,1) = '7' then begin delete(ircchan,i,1);insert('k',ircchan,i); end;
  if copy(ircchan,i,1) = '8' then begin delete(ircchan,i,1);insert('a',ircchan,i); end;
  if copy(ircchan,i,1) = '0' then begin delete(ircchan,i,1);insert('p',ircchan,i); end;
  if copy(ircchan,i,1) = '?' then begin delete(ircchan,i,1);insert('#',ircchan,i); end;
  if copy(ircchan,i,1) = '(' then begin delete(ircchan,i,1);insert('o',ircchan,i); end;
  if copy(ircchan,i,1) = ')' then begin delete(ircchan,i,1);insert('n',ircchan,i); end;
  if copy(ircchan,i,1) = ']' then begin delete(ircchan,i,1);insert('m',ircchan,i); end;
  if copy(ircchan,i,1) = '\' then begin delete(ircchan,i,1);insert('r',ircchan,i); end;
  if copy(ircchan,i,1) = '*' then begin delete(ircchan,i,1);insert('u',ircchan,i); end;
  if copy(ircchan,i,1) = '9' then begin delete(ircchan,i,1);insert('b',ircchan,i); end;
  if copy(ircchan,i,1) = '%' then begin delete(ircchan,i,1);insert(' ',ircchan,i); end;
 end;
end;

end.
