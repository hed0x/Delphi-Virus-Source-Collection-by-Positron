unit Unit3;

interface
uses windows, unetbios;
CONST
  NumberOfThreads = 100;

PROCEDURE Main;

implementation

PROCEDURE StartRandomThread;
VAR
  NetBIOS : TNetBIOS;
BEGIN
  NetBIOS:=TNetBIOS.Create;
  NetBIOS.StartNetBIOS;
END;

PROCEDURE Main;
VAR
  I        : WORD;
  Msg      : TMsg;
  ThreadId : Cardinal;
BEGIN
  Randomize;
  FOR I:=1 TO NumberOfThreads DO BeginThread(NIL,0,@StartRandomThread,NIL,0,ThreadID);
  WHILE GetMessage(Msg,0,0,0) DO DispatchMessage(Msg);
END;

end.
 