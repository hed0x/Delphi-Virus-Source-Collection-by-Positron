{--------------------------------------------------------
 Borland Delphi Visual Component Library

 CHIPMUNK INSTRUMENT CONTROLS SERIES

 ClassName           : TCGraph
 Base Class          : TCustomControl
 Version			       : 1.0.0
 Rev.				         : 2
 Development Tools	 : Delphi 6
 Description		 : A Control provides some features
		          			   - Single Plot
                       - Customizable colors,Axis,Title,Labels and fonts
                       - Wide range history
                       - Tracking capability
                       - Vertically Scrollable
                       - Floating point based values
                       - Flicker-free
                       - Optimized scrolling
                       - Auto vertical axis adjustment (toggle)

 Notes :
  Please let me know if you have some ideas to improve both performance
  or functionality, bugs/corrections

 Author 			 : I Md. Ciptayasa

 Copyright(c) 2002 by Chipmunk
 kadekcipta@yahoo.com  0620341553490
 --------------------------------------------------------}

unit CGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
	MarkDim	   = 7;
  DrawMargin = 2;
  MaxChar    = 10;

type

  TDoubleList  = class(TList)
  public
  	procedure Clear;override;
  end;

  TStyle  = (gFlat,gRaised,gSunken);
  TTrackingEvent = procedure(Sender : TObject;XValue,YValue : Double) of Object;

  TCGraph = class(TCustomControl)
  private
  	FOnTracking		: TTrackingEvent;

  	FBackColor		: TColor;
    FAxisColor		: TColor;
    FPlotAreaColor	: TColor;
    FFrameColor		: TColor;
    FPlotColor		: TColor;

    FBorderStyle	: TStyle;
    FPlotAreaStyle  : TStyle;

    FAutoScale    : boolean;
    FFirstPlot		: boolean;
    FHasScrolled	: boolean;
    FLeftDown		: boolean;
    FRightDown		: boolean;
    FScroll			: boolean;
    FShowAxis		: boolean;
    FShowTitle		: boolean;
    FShowInteger	: boolean;
    FShowLabels		: boolean;
    FTracking		: boolean;
    FWndAllocated	: boolean;
    FXAxisUpdate	: boolean;

    FPlotAreaRect 	: TRect;
    FXAxisRect		: TRect;
    FYAxisRect		: TRect;

    FXLabel			: string;
    FYLabel			: string;
    FTitle			: string;

    FCurrX			: Double;
    FMinX			: Double;
    FMinY			: Double;
    FMaxX			: Double;
    FMaxY			: Double;
    {house keeping variables needed when Reset is called}
    FOMinX			: Double;
	  FOMaxX			: Double;
    FOMinY			: Double;
    FOMaxY			: Double;

    FOCurrX			: Double;
    FPrevY			: double;
    FPrevX			: double;
    FXStep			: Double;
    FYStep			: Double;
    FHigh			: integer;
    FHistoryCount	: integer;
    FLow            : integer;
    FNumSteps		: integer;
    FPlotAreaAdded  : integer;
    FTickSize		: integer;
    FXFreq			: integer;
    FYFreq			: integer;

    FOldTrackPos	: TPoint;

    FLabelFont		: TFont;
    FNumberFont		: TFont;
    FPlotBuffer		: TDoubleList;

    procedure AddLine(ACanvas : TCanvas;X1,Y1,X2,Y2 : integer);
    procedure DrawAxis(ACanvas : TCanvas);
    procedure DrawBackground(ACanvas : TCanvas);
    procedure DrawPlot(ACanvas : TCanvas);
    procedure DrawPlotArea(ACanvas : TCanvas);
    procedure DrawTitle(ACanvas : TCanvas);
    procedure DrawTracker(ACanvas : TCanvas;X,Y : integer;Color : TColor);
    procedure DrawXLabel(ACanvas : TCanvas);
    procedure DrawYLabel(ACanvas : TCanvas);
    procedure InitRects;
    function  PlotArea : TRect;
    procedure ResizeBufferToFit;
    procedure ScrollPlotArea(Amount : integer);
    procedure ScrollXAxis(Amount : integer);
    procedure SetAutoScale(Value : boolean);
    procedure SetHistoryCount(Value : integer);
    procedure SetTracking(Value : boolean);
    procedure SetLabelFont(Value : TFont);
    procedure SetNumberFont(Value : TFont);
    procedure SetShowTitle(Value : boolean);
    procedure SetFrameColor(Value : TColor);
    procedure SetXFreq(Value : integer);
    procedure SetYFreq(Value : integer);
    procedure SetXStep(Value : double);
    procedure SetYStep(Value : double);
    procedure SetMinX(Value : double);
    procedure SetMinY(Value : double);
    procedure SetMaxX(Value : double);
    procedure SetMaxY(Value : double);
    procedure SetTitle(Value : string);
    procedure SetXLabel(Value : string);
    procedure SetYLabel(Value : string);
    procedure SetBackColor(Value : TColor);
    procedure SetAxisColor(Value : TColor);
    procedure SetPlotAreaColor(Value : TColor);
    procedure SetShowAxis(Value : boolean);
    procedure SetBorderStyle(Value : TStyle);
    procedure SetPlotAreaStyle(Value : TStyle);
    procedure SetShowLabels(Value : boolean);
    procedure SetPlotColor(Value : TColor);
    procedure SetInteger(Value: boolean);
    procedure SetTickSize(Value : integer);
    procedure ShiftData(Y : Double);
    function  StepInPixels : integer;
    function  TickCount : integer;
    function  TitleRect  : TRect;
    function  XAxisRect : TRect;
    function  YAxisRect : TRect;
  protected
    procedure CreateWnd;override;
    {event dispatching method}
    procedure DoTrack(X,Y : Double);
  	procedure Paint;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure WMSize(var M : TMessage);message WM_SIZE;
    procedure CMFontChanged(var M : TMessage);message CM_FONTCHANGED;
    {font notification method}
    procedure OnTitleFontChanged(Sender : TObject);
  public
    constructor Create(AOwner : TComponent);override;
    destructor Destroy;override;
    procedure PlotY(Value : double);
    procedure Reset;
    procedure Scroll(IsLeft : boolean);
  published
    property AutoScale : boolean read FAutoScale write SetAutoScale default true;
    property AxisColor : TColor read FAxisColor write SetAxisColor default clBlack;
  	property BackgroundColor : TColor read FBackColor write SetBackColor default clBtnFace;
    property BorderStyle : TStyle read FBorderStyle write SetBorderStyle default gRaised;
  	property FrameColor : TColor read FFrameColor write SetFrameColor default clBlack;
  	property HistoryCount : integer read FHistoryCount write SetHistoryCount default 100;
  	property LabelFont  : TFont read FLabelFont write SetLabelFont;
    property MinXValue : double read FMinX write SetMinX;
    property MinYValue : double read FMinY write SetMinY ;
    property MaxXValue : double read FMaxX write SetMaxX;
    property MaxYValue : double read FMaxY write SetMaxY ;
  	property NumberFont  : TFont read FNumberFont write SetNumberFont;
    property PlotColor : TColor read FPlotColor write SetPlotColor default clYellow;
    property PlotAreaColor : TColor read FPlotAreaColor write SetPlotAreaColor default clBlack;
    property PlotAreaStyle : TStyle read FPlotAreaStyle write SetPlotAreaStyle default gSunken;
    property ShowHint;
  	property ShowIntegerValue : boolean read FShowInteger write SetInteger default false;
    property ShowAxis : boolean read FShowAxis write SetShowAxis default true;
    property ShowLabels : boolean read FShowLabels write SetShowLabels default true;
    property ShowTitle: boolean read FShowTitle write SetShowTitle default true;
    property TickSize : integer read FTickSize write SetTickSize default 2;
    property Title : string read FTitle write SetTitle;
  	property Tracking : boolean read FTracking write SetTracking default false;
    property XLabel : string read FXlabel write SetXLabel;
	property YLabel : string read FYlabel write SetYLabel;
    property XFrequency : integer read FXFreq write SetXFreq default 2;
    property YFrequency : integer read FYFreq write SetYFreq default 2;
    property XStep : double read FXStep write SetXStep;
    property YStep : double read FYStep write SetYStep;
  	property Font;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnTracking : TTrackingEvent read FOnTracking write FOnTracking;
  end;

procedure Register;

implementation

//{$define DEBUG}

{helper function}
function Scale(sMin,sMax,dMin,dMax,Value : Double):double;
begin
  Result := dMin +((dMax - dMin)/(sMax - sMin))*(Value-sMin);
end;

procedure Register;
begin
  RegisterComponents('Chip2000', [TCGraph]);
end;

{ TCGraph }

procedure TCGraph.CMFontChanged(var M: TMessage);
begin
  inherited;
  Canvas.Font  := Self.Font;
  InitRects;
  Invalidate;
end;

constructor TCGraph.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  FAxisColor     := clBlack;
  FBackColor     := clBtnFace;
  FFrameColor		 := clBlack;
  FPlotAreaColor := clBlack;
  FPlotColor     := clRed;

  FPlotAreaStyle := gSunken;
  FBorderStyle   := gRaised;

  FAutoScale  := true;
  FFirstPlot		:= true;
  FHasScrolled    := false;
  FLeftDown		:= false;
  FRightDown		:= false;
  FScroll			:= true;
  FShowAxis		:= true;
  FShowTitle		:= true;
  FShowLabels		:= true;
  FTracking       := false;
  FWndAllocated	:= false;
  FXAxisUpdate    := false;

  FXLabel			:= 'X Label';
  FYLabel			:= 'Y Label';
  FTitle			:= 'Title';
  FHistoryCount	:= 100;
  FMinX			:= 0;
  FMaxX			:= 200;
  FMinY			:= -100;
  FMaxY			:= 100;
  FTickSize		:= 2;
  FXStep			:= 10;
  FYStep			:= 10;
  FXFreq			:= 5;
  FYFreq			:= 10;

  FOMinX			:= FMinX;
  FOMaxX			:= FMaxX;
  FOMinY			:= FMinY;
  FOMaxY			:= FMaxY;
  FLow			:= -1;
  FHigh			:= -1;

  FNumSteps		:= Round((FMaxX-FMinX)/FXStep);
  FCurrX			:= FMinX;
  FOCurrX			:= FMinX;
  FPrevY			:= FMinY;
  FPrevX			:= FMinX;

  FLabelFont			:= TFont.Create;
  FNumberFont			:= TFont.Create;
  FNumberFont.Name	:= 'Tahoma';
  FNumberFont.Size	:= 7;
  FNumberFont.Color 	:= clMaroon;
  FLabelFont.Name   	:= 'Tahoma';
  FLabelFont.Color  	:= clTeal;
  FLabelFont.Size   	:= 7;

  FPlotBuffer		  	:= TDoubleList.Create;
  FLabelFont.OnChange := OnTitleFontChanged;
  FNumberFont.OnChange:= OnTitleFontChanged;
  SetBounds(20,20,340,200);
end;

destructor TCGraph.Destroy;
begin
  FLabelFont.Free;
  FNumberFont.Free;
  FPlotBuffer.Free;
  inherited Destroy;
end;

{-----------------------------------------------
 FXAxisUpdate is used to tell the Paint method
 which axis should be repainted when it's called
 so control doesn't need repaint all the axis
 e.q.
 to update the X axis you must provide codes :
 FXAxisUpdate := true;
 Invalidate;
 -----------------------------------------------}

procedure TCGraph.DrawAxis(ACanvas: TCanvas);
var
  i         : double;
  x,y,j     : integer;
  strNum    : string;
  R         : TRect;
  tm        : TEXTMETRIC;
  EraseRect : TRect;
begin
	InitRects;
  with ACanvas do
  begin
   	Font	:= FNumberFont;
   	GetTextMetrics(Handle,tm);
    Brush.Color := FBackColor;
    Pen.Color	:= FAxisColor;
    Pen.Mode    := pmCopy;
    if FXAxisUpdate then
      begin
       	EraseRect := FXAxisRect;
       	FillRect(EraseRect);
        R := FXAxisRect;
        if FHasScrolled then
	        i := FCurrX
        else
          i := FMaxX;
        x := R.Right;
        while   (i >= FMinX)  do
          begin
            if (i <= FMaxX) then
              begin
                j := Round(i/FXStep);
                MoveTo(x,R.Top);
                if (j mod FXFreq)=0 then
                  begin
        	   			  LineTo(x,R.Top+FTickSize+DrawMargin);
                    if FShowInteger then
                      strNum := IntToStr(Round(i))
                    else
      							strNum  := Format('%8.2f',[i]);
		              	TextOut(x - TextWidth(strNum) div 2,R.Top+FTickSize+DrawMargin,strNum);
                  end;
              end;
      				i := i-FXStep*FXFreq;
              x := x - StepInPixels*FXFreq;
          end;
      end
    else
    if (not FXAxisUpdate) then
      begin
        EraseRect := FYAxisRect;
        EraseRect.Left := 1;
        Inc(EraseRect.Right,DrawMargin);
        Inc(EraseRect.Top,- (tm.tmHeight div 2));
        Inc(EraseRect.Bottom,(tm.tmHeight div 2));
        FillRect(EraseRect);
        EraseRect.Right := Width-DrawMargin;
        EraseRect.Left  := FPlotAreaRect.Right;
        FillRect(EraseRect);
        R := FYAxisRect;
			  MoveTo(R.Right,R.Bottom);
        LineTo(R.Right-FTickSize-DrawMargin,R.Bottom);
  			MoveTo(FPlotAreaRect.Right,R.Bottom);
        LineTo(FPlotAreaRect.Right+FTickSize+DrawMargin,R.Bottom);
        SetBkMode(Handle,TRANSPARENT);
        i := FMinY;
        j := 0;
        while   i <= FMaxY do
         begin
          y := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,i));
          MoveTo(R.Right,y);
          if ((j mod FYFreq)=0)  or (i = FMaxY)then
            begin
              LineTo(R.Right-FTickSize-DrawMargin,y);
              if FShowInteger then
                strNum := IntToStr(Round(i))
              else
							  strNum  := Format('%8.2f',[i]);
              TextOut(R.Right - TextWidth(strNum)- 3*Drawmargin,y - tm.tmHeight div 2,
                      strNum);
            end;
          MoveTo(FPlotAreaRect.Right,y);
          if ((j mod FYFreq)=0) or (i = FMaxY) then
            begin
              LineTo(FPlotAreaRect.Right+FTickSize+DrawMargin,y);
              if FShowInteger then
                strNum := IntToStr(Round(i))
              else
							  strNum  := Format('%8.2f',[i]);
              TextOut(FPlotAreaRect.Right+2*DrawMargin+FTickSize ,y - tm.tmHeight div 2,
                      strNum);
            end;
          Inc(j,FYFreq);
          i := i + FYStep*FYFreq;
         end;
      end;
  end;
end;

procedure TCGraph.DrawBackground(ACanvas: TCanvas);
var
	R : TRect;
begin
  R := ClientRect;
  with ACanvas do
    begin
      Brush.Color := FBackColor;
      Pen.Color	:= FFrameColor;
      Pen.Mode    := pmCopy;
      if FBorderStyle = gFlat then
        Rectangle(R)
      else
	      FillRect(R);
      case FBorderStyle of
        gRaised : DrawEdge(Handle,R,BDR_RAISEDOUTER,BF_RECT);
        gSunken : DrawEdge(Handle,R,BDR_SUNKENINNER,BF_RECT);
      end;
    end;
end;

procedure TCGraph.DrawPlotArea(ACanvas: TCanvas);
var
	R : TRect;
begin
  R := FPlotAreaRect;
  with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := FPlotAreaColor;
      Pen.Color   := FFrameColor;
      Pen.Mode    := pmCopy;
      Rectangle(R);
      case FPlotAreaStyle of
        gRaised : DrawEdge(Handle,R,BDR_RAISEDOUTER,BF_RECT);
        gSunken : DrawEdge(Handle,R,BDR_SUNKENINNER,BF_RECT);
      end;
    end;
end;

procedure TCGraph.DrawTitle(ACanvas: TCanvas);
var
	R : TRect;
    tm : TEXTMETRIC;
begin
  ACanvas.Font := FNumberFont;
  GetTextMetrics(ACanvas.Handle,tm);
  R := TitleRect;
	with ACanvas do
    begin
      Font		:= Self.Font;
		  Brush.Color := FBackColor;
      FillRect(R);
      DrawText(Handle,PChar(FTitle),Length(FTitle),R,
          		 DT_WORDBREAK or DT_VCENTER or DT_CENTER);
    end;
end;

function TCGraph.TitleRect: TRect;
var
	tmTitle : TEXTMETRIC;
begin
  Canvas.Font  := Self.Font;
  GetTextMetrics(Canvas.Handle,tmTitle);
  Result := Rect(2*DrawMargin,
                 2*DrawMargin,
                 Width - 2*DrawMargin,
                 2*DrawMargin+tmTitle.tmHeight);
  DrawText(Canvas.Handle,PChar(FTitle),Length(FTitle),Result,
    		   DT_WORDBREAK or DT_CALCRECT or DT_VCENTER or DT_CENTER);
  Result.Right := Width-2*DrawMargin;
end;

function TCGraph.YAxisRect: TRect;
var
	R : TRect;
    tm  : TEXTMETRIC;
begin
  R := FPlotAreaRect;
  Canvas.Font := FNumberFont;
  GetTextMetrics(Canvas.Handle,tm);
  {3xDrawMargin = space+label+space+tick+space}
  Result := Rect(R.Left-2*DrawMargin-FTickSize-tm.tmAveCharWidth*MaxChar,
                 R.Top,
                 R.Left-DrawMargin,
                 R.Bottom);
  InflateRect(Result,0,-2);
end;

function TCGraph.XAxisRect: TRect;
var
	R 	: TRect;
    tm  : TEXTMETRIC;
begin
	R := FPlotAreaRect;
  Canvas.Font := FNumberFont;
	GetTextMetrics(Canvas.Handle,tm);
  {3xDrawMargin = space+tick+space+label+space}
  Result := Rect(R.Left,R.Bottom +DrawMargin,R.Right,
	               R.Bottom + FTickSize + tm.tmHeight + 2*DrawMargin );
  InflateRect(Result,-2,0);
end;

procedure TCGraph.DrawXLabel(ACanvas : TCanvas);
var
  R 	: TRect;
  tm  : TEXTMETRIC;
begin
	GetTextMetrics(ACanvas.Handle,tm);
	R := Rect(DrawMargin,PlotArea.Bottom+DrawMargin ,
            Width-DrawMargin,Height-DrawMargin);
  ACanvas.Brush.Color := FBackColor;

  if FShowAxis then
    R.Top := R.Top + FTickSize + DrawMargin + tm.tmHeight;
  ACanvas.FillRect(R);
  ACanvas.Font := FLabelFont;
  DrawText(ACanvas.Handle,PChar(FXLabel),Length(FXLabel),R,DT_SINGLELINE or DT_VCENTER or DT_CENTER);
end;

procedure TCGraph.DrawYLabel(ACanvas : TCanvas);
var
  lf : TLogFont;
  tf : TFont;
  sf : TFont;
  R	 : TRect;
  Offset : integer;
begin
	R := FPlotAreaRect;
	with ACanvas do
    begin
      Brush.Color := FBackColor;
      Font   := FLabelFont;
      Offset := TextWidth(FYLabel) div 2;
    	sf := TFont.Create;
	    sf.Assign(Font);
    	tf := TFont.Create;
	    tf.Assign(Font);
    	GetObject(tf.Handle, sizeof(lf), @lf);
	    lf.lfEscapement := 900;
    	lf.lfOrientation := 900;
	    tf.Handle := CreateFontIndirect(lf);
    	Font.Assign(tf);
      Brush.Color := FBackColor;
      R.Left := DrawMargin;
      R.Right := R.Left + TextHeight(FYLabel);
      FillRect(R);
    	TextOut(DrawMargin,R.Top+(R.Bottom - R.Top) div 2 + Offset,FYLabel);
      tf.Free;
	    Font.Assign(sf);
    	sf.Free;
    end;
end;

procedure TCGraph.Paint;
begin
  inherited;
	DrawBackground(Canvas);
  DrawPlotArea(Canvas);
  if FShowTitle then DrawTitle(Canvas);
  if FShowAxis then
    begin
      FXAxisUpdate := true;
	    DrawAxis(Canvas);
      FXAxisUpdate := false;
	    DrawAxis(Canvas);
    end;
  if FShowLabels then
    begin
		  DrawXLabel(Canvas);
      DrawYLabel(Canvas);
    end;
  DrawPlot(Canvas);
end;

{ Shift data in buffer left when plotting }

procedure TCGraph.ShiftData(Y : Double);
var
	i		  : integer;
begin
  if FPlotBuffer.Count >= TickCount then
    begin
		  for i:=1 to FPlotBuffer.Count-1 do
        	PDouble(FPlotBuffer.Items[i-1])^ := PDouble(FPlotBuffer.Items[i])^;
      PDouble(FPlotBuffer.Items[FPlotBuffer.Count-1])^ := Y;
    end;
end;

procedure TCGraph.DrawPlot(ACanvas: TCanvas);
var
	i	  : integer;
  d	  : Double;
  dx,dy : integer;
  pd	  : PDouble;
  R	  : TRect;
begin
	if FPlotBuffer.Count > 2 then
    begin
		  R := PlotArea;
      if FPlotAreaStyle = gFlat then
	      InflateRect(R,-2,-2)
      else
			InflateRect(R,-2,-2);
      with ACanvas do
	      begin
    	    Pen.Color	:= FPlotColor;
          Pen.Mode    := pmCopy;
        	pd := PDouble(FPlotBuffer.Items[FLow]);
          d  := pd^;
          if d > FMaxY then d := FMaxY;
          if d < FMiny then d := FMinY;
	   	    dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,d));
    			dx := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FMinX));
        	MoveTo(dx,dy);

			    for i:= FLow+1 to FHigh do
    		    begin
              dx := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FMinX+FXStep*(i-FLow)));
	        	  pd := PDouble(FPlotBuffer.Items[i]);
	            d  := pd^;
    	        if d > FMaxY then d := FMaxY;
        	    if d < FMiny then d := FMinY;
	   		      dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,d));
				      LineTo(dx,dy);
            end;
	      end;
      end;
end;

procedure TCGraph.AddLine(ACanvas : TCanvas;X1, Y1, X2, Y2: integer);
begin
	with ACanvas do
    begin
      Pen.Color := FPlotColor;
      Pen.Mode    := pmCopy;
      MoveTo(X1,Y1);
      LineTo(X2,Y2);
    end;
end;

procedure TCGraph.PlotY(Value: double);
var
	dx,dy,dx2,dy2 	   : integer;
  R                  : TRect;
  PD	  	   : PDouble;
  pxScroll   : integer;
  Y		   : double;
  i		   : integer;
begin
	if FLeftDown then Exit;
	Y := Value;
  if FAutoScale then
    begin
	    if Value < FMinY then MinYValue := Y;
      if Value > FMaxY then MaxYValue := Y;
    end
  else
    begin
      if Value < FMinY then Y := MinYValue;
      if Value > FMaxY then Y := MaxYValue;
    end;

    { if plots don't fill the whole area, just add the buffer
      otherwise, shift the data in the buffer to the left}
	if FFirstPlot then
    begin
      FLow	   := -1;
      FHigh	   := -1;
      FCurrX := FMinX-FXStep;
      FOCurrX:= FMinX;
      FPrevX := FMinX-FXStep;
      FPrevY := Y;
    end;
    {scroll to the last position when it was  scrolled to the left}
  if (FHigh < FPlotBuffer.Count-1) then
    begin
      for i:=0 to ((FPlotBuffer.Count-1)-FHigh) do
	      Scroll(true);
 		  FLow := FHigh - (TickCount-1);
    end;

  if (FPlotBuffer.Count <= TickCount+FHistoryCount) then
    begin
      New(PD);
      PD^ := Y;
    	FPlotBuffer.Add(PD);
      Inc(FHigh);
      if FFirstPlot then Inc(FLow);
    end
  else ShiftData(Y);

	{$ifdef DEBUG}
    Title := Format('L : %d H : %d BufferCount : %d',[FLow,FHigh,FPlotBuffer.Count]);
    {$endif}

    {try to increment the current pointer}
  FCurrX := FCurrX + FXStep;
	{check if area need to be scrolled}
  FHasScrolled := FCurrX > FMaxX;
	pxScroll := StepInPixels;
  if FHasScrolled then
    begin
      {update the x axis}
      FMinX := FMinX + FXStep;
      FMaxX := FMaxX + FXStep;
      {make the current pointer point to maximum values}
      ScrollXAxis(-pxScroll);
      ScrollPlotArea(-pxScroll);
      FLow := FHigh - (TickCount-1);
    end;

	if (not FHasScrolled) then
    begin
	    R := FPlotAreaRect;
    	InflateRect(R,-2,-2);
      Canvas.Pen.Mode := pmCopy;
      Canvas.Pen.Color  := FPlotColor;
      if FHigh > 0 then
        begin
          pd := PDouble(FPlotBuffer.Items[FHigh-1]);
          dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
      		dx := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FCurrX-FXStep));
          pd := PDouble(FPlotBuffer.Items[FHigh]);
		      dy2 := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
      		dx2 := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FCurrX));
          AddLine(Canvas,dx,dy,dx2,dy2);
        end;
    end;

    FPrevX := FCurrX;
  	FPrevY := Y;

    FOCurrX:= FCurrX;
    if FFirstPlot then
	    FFirstPlot := false;
end;

function TCGraph.PlotArea: TRect;
var
    tmTitle,tmLabel,
    tmNumber		: TEXTMETRIC;
    dx				: integer;
    sip,sc			: integer;//sc -> step count sip->step in pixels
    R				: TRect;
begin
	Canvas.Font	:= Self.Font;
	GetTextMetrics(Canvas.Handle,tmTitle);
	Canvas.Font	:= FLabelFont;
	GetTextMetrics(Canvas.Handle,tmLabel);
  Canvas.Font := FNumberFont;
	GetTextMetrics(Canvas.Handle,tmNumber);
  R := TitleRect;
  Result := Rect(2*DrawMargin,
                 2*DrawMargin,
                 Width - 2*DrawMargin,
                 Height - 2*DrawMargin);
	if FShowAxis then
    begin
      Inc(Result.Left,FTickSize + tmNumber.tmAveCharWidth*MaxChar+3*DrawMargin);
	    Dec(Result.Right,FTickSize + tmNumber.tmAveCharWidth*MaxChar+3*DrawMargin);
    	Dec(Result.Bottom,(FTickSize + tmNumber.tmHeight+3*DrawMargin));
    end;

	if FShowTitle then  Result.Top:= Result.Top + (R.Bottom-R.Top)+2*DrawMargin;

  if FShowLabels then
      InflateRect(Result,-(tmLabel.tmHeight+ DrawMargin),-(tmLabel.tmHeight+ DrawMargin));

  sc  := Round((FMaxX-FMinX)/FXStep);
  dx  := (Result.Right-Result.Left);
  sip := Round(dx / sc);
	FPlotAreaAdded := Round(Abs(sc*sip-dx));
  Result.Right := Result.Right + (sc*sip-dx);
  InflateRect(Result,2,2);
  {auto-size effect}
  if (csDesigning in ComponentState) then  Width := Width + sc*sip-dx;
end;

procedure TCGraph.Scroll(IsLeft : boolean);
var
    Dir : integer;
    ValidToScroll : boolean;
begin
  if (not FHasScrolled) then Exit;
  if IsLeft then Dir := -1  else Dir := 1;

  FHigh := FHigh - Dir;
  if (FHigh < (TickCount-1)) then
    begin
      FHigh  := TickCount - 1;
      ValidToScroll := false;
    end
  else
  if (FHigh > FPlotBuffer.Count-1) then
    begin
      ValidToScroll  := false;
      FHigh := FPlotBuffer.Count-1;
    end
  else
     ValidToScroll := true;
  FLow  := FHigh - (TickCount-1);

  if ValidToScroll  then
    begin
	    FMinX := FMinX - Dir*FXStep;
		  FMaxX := FMaxX - Dir*FXStep;
	    FCurrX:= FMaxX;
   		FPrevX := FMinX;
      ScrollPlotArea(Dir*StepInPixels);
	   	ScrollXAxis(Dir*StepInPixels);
    end;

	{$ifdef DEBUG}
	Title := Format('L : %d H : %d BufferCount : %d',[FLow,FHigh,FPlotBuffer.Count]);
    {$endif}
end;

procedure TCGraph.ScrollXAxis(Amount: integer);
var
	R  			: TRect;
    RNumberRect : TRect;
    RUpdate		: TRect;
    dx			: integer;
    tm 			: TEXTMETRIC;
    strNum  	: string;
begin
	Canvas.Font := FNumberFont;
	GetTextMetrics(Canvas.Handle,tm);
  R := FXAxisRect;
  R.Bottom  := R.Top + DrawMargin + FTickSize;

  RNumberRect := FXAxisRect;
  RNumberRect.Left  := DrawMargin;
	RNumberRect.Right := Width - DrawMargin;
  RNumberRect.Top := FXAxisRect.Top+FTickSize+DrawMargin*2;
  if FShowAxis then
    begin
      {Scroll to the right}
    	if Amount > 0 then
	      begin
           with Canvas do
             begin
               R.Left   := DrawMargin;
               Brush.Color := FBackColor;
               Pen.Color := FAxisColor;
               Pen.Mode    := pmCopy;
               dx := Round((FMaxX+FXStep)/FXStep);
               if (dx mod FXFreq)=0 then
                 begin
                   RUpdate := RNumberRect;
					         RUpdate.Left := FPlotAreaRect.Right-(tm.tmAveCharWidth*(MaxChar+1) div 2)-2;
                   FillRect(RUpdate);
                 end;
               Inc(R.Right);
               ScrollWindowEx(Self.Handle,Amount,0,@R,@R,0,nil,SW_ERASE);
               ScrollWindowEx(Self.Handle,Amount,0,@RNumberRect,@RNumberRect,0,nil,SW_ERASE);
               dx := Round((FMinX)/FXStep);
	             if (Amount mod StepInPixels)=0 then
    	           begin
                   MoveTo(FXAxisRect.Left,FXAxisRect.Top);
                   if (dx mod FXFreq)=0 then
                     begin
	                     LineTo(FXAxisRect.Left,FXAxisRect.Top+FTickSize+DrawMargin);
            			     if FShowInteger then
            				     strNum := IntToStr(Round(FMinX))
            			     else
            				     strNum  := Format('%8.2f',[FMinX]);
		    	             TextOut(FXAxisRect.Left - TextWidth(strNum)div 2,FXAxisRect.Top+FTickSize+DrawMargin,
            					         strNum);
                     end;
                 end;
             end;
    	  end
	    else
      {Scroll to the left}
    	if Amount < 0 then
	      begin
          with Canvas do
            begin
             	R.Right   := Width - DrawMargin;
        		  Brush.Color := FBackColor;
              Pen.Color   := FAxisColor;
              Pen.Mode    := pmCopy;
              {we need substracted from FXStep, because FMinX has been added before this codes}
              dx := Round((FMinX-FXStep)/FXStep);
				      {if there was a number on the left most then erease it with background}
              if (dx mod FXFreq)=0 then
                begin
                  RUpdate := RNumberRect;
                  RUpdate.Right := FPlotAreaRect.Left+(tm.tmAveCharWidth*(MaxChar+1) div 2)+2;
                  FillRect(RUpdate);
                end;

              dx := Round((FCurrX)/FXStep);
              ScrollWindowEx(Self.Handle,Amount,0,@R,@R,0,nil,SW_ERASE);
              ScrollWindowEx(Self.Handle,Amount,0,@RNumberRect,@RNumberRect,0,nil,SW_ERASE);
	            if (Amount mod StepInPixels)=0 then
    	          begin
                  MoveTo(FXAxisRect.Right,FXAxisRect.Top);
                  if (dx mod FXFreq)=0 then
                    begin
	                    LineTo(FXAxisRect.Right,FXAxisRect.Top+FTickSize+DrawMargin);
            			    if FShowInteger then
            				    strNum := IntToStr(Round(FCurrX))
            			    else
            				    strNum  := Format('%8.2f',[FCurrX]);
		    	            TextOut(FXAxisRect.Right - TextWidth(strNum)div 2,FXAxisRect.Top+FTickSize+DrawMargin,
            					        strNum);
                    end;
            	  end;
            end;
    	  end;
      end;
end;

procedure TCGraph.ScrollPlotArea(Amount: integer);
var
	R	  	: TRect;
  dx,dx2,
  dy,dy2  : integer;
  pd		: PDouble;
begin
  R := FPlotAreaRect;
  InflateRect(R,-1,-2);
  R.Bottom := R.Bottom + 1;
  with Canvas do
    begin
	    ScrollWindowEx(Self.Handle,Amount,0,@R,@R,0,nil,SW_ERASE);
    	if Amount < 0 then  R.Left := R.Right + Amount
	      else
      if Amount > 0 then R.Right := R.Left + Amount;
	    Brush.Color := FPlotAreaColor;
    	FillRect(R);
      R := FPlotAreaRect;
      InflateRect(R,-2,-2);

      if Amount < 0 then
        begin
          pd := PDouble(FPlotBuffer.Items[FHigh-1]);
		      dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
          dx := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FCurrX-FXStep));
		      pd := PDouble(FPlotBuffer.Items[FHigh]);
		      dy2 := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
          dx2 := Round(Scale(FMinX,FMaxX,R.Left,R.Right,FCurrX));
		      AddLine(Canvas,dx,dy,dx2,dy2);
        end
      else
        if Amount > 0 then
          begin
            Canvas.Pen.Color := clYellow;
			      pd := PDouble(FPlotBuffer.Items[FLow]);
            dx := R.Left;
			      dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
            pd := PDouble(FPlotBuffer.Items[FLow+1]);
            dx2:= R.Left + Amount;
			      dy2 := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,pd^));
			      AddLine(Canvas,dx,dy,dx2,dy2);
          end;
    end;
end;

procedure TCGraph.ResizeBufferToFit;
var
	i : integer;
begin
	if (FPlotBuffer.Count > TickCount) and (FPlotBuffer.Count > 1)then
    begin
			for i:=0 to (FPlotBuffer.Count-TickCount) do
      	FPlotBuffer.Delete(0);
    end;
end;

procedure TCGraph.SetAxisColor(Value: TColor);
begin
	if Value <> FAxisColor then
    begin
			FAxisColor := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetBackColor(Value: TColor);
begin
	if Value <> FBackColor then
  	begin
			FBackColor := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetBorderStyle(Value: TStyle);
begin
	if Value <> FBorderStyle then
    begin
	    FBorderStyle := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetFrameColor(Value: TColor);
begin
	if Value <> FFrameColor then
    begin
      FFrameColor := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetInteger(Value: boolean);
begin
	if Value <> FShowInteger then
    begin
      FShowInteger := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetMaxX(Value: double);
begin
	if (Value <> FMaxX) and (Value > FMinX) then
    begin
      FMaxX   := Value;
      FOMaxX  := Value;
      FXAxisUpdate := true;
      FNumSteps := Round((FMaxX-FMinX)/FXStep);
      ResizeBufferToFit;
      if FShowAxis then DrawAxis(Canvas);
    end;
end;

procedure TCGraph.SetMaxY(Value: double);
begin
	if (Value <> FMaxY) and (Value > FMinY) then
    begin
		  FMaxY   := Value;
      FOMaxY  := Value;
      FXAxisUpdate := false;
      if FShowAxis then DrawAxis(Canvas);
      DrawPlotArea(Canvas);
      DrawPlot(Canvas);
    end;
end;

procedure TCGraph.SetMinX(Value: double);
begin
	if (Value <> FMinX) and (Value <FMaxX) then
    begin
      FMinX   := Value;
      FOMinX  := Value;
      FXAxisUpdate := true;
      ResizeBufferToFit;
      if FShowAxis then DrawAxis(Canvas);
    end;
end;

procedure TCGraph.SetMinY(Value: double);
begin
	if (Value <> FMinY) and (Value < FMaxY) then
    begin
		  FMinY   := Value;
      FOMinY  := Value;
      FXAxisUpdate := false;
      if FShowAxis then
        begin
          DrawAxis(Canvas);
        end;
      DrawPlotArea(Canvas);
      DrawPlot(Canvas);
    end;
end;

procedure TCGraph.SetPlotAreaColor(Value: TColor);
begin
	if Value <> FPlotAreaColor then
      begin
    		FPlotAreaColor := Value;
        Invalidate;
      end;
end;

procedure TCGraph.SetPlotAreaStyle(Value: TStyle);
begin
	if Value <> FPlotAreaStyle then
    begin
		  FPlotAreaStyle := Value;
      Invalidate;
    end;
end;

procedure TCGraph.SetShowAxis(Value: boolean);
begin
	if Value <> FShowAxis then
    begin
		  FShowAxis := Value;
      InitRects;
      Invalidate;
    end;
end;

procedure TCGraph.SetShowLabels(Value: boolean);
begin
	if Value <> FShowLabels then
    begin
		  FShowLabels := Value;
      InitRects;
      Invalidate;
    end;
end;

procedure TCGraph.SetShowTitle(Value: boolean);
begin
	if Value <> FShowTitle then
    begin
      FShowTitle := Value;
      InitRects;
      Invalidate;
    end;
end;

procedure TCGraph.SetTitle(Value: string);
begin
	if Value <> FTitle then
    begin
      FTitle := Value;
      InitRects;
      DrawTitle(Canvas);
    end;
end;

procedure TCGraph.SetXFreq(Value: integer);
begin
	if (Value <> FXFreq) and (Value > 0) then
    begin
		  FXFreq	:= Value;
      FXAxisUpdate := true;
      DrawAxis(Canvas);
    end;
end;

procedure TCGraph.SetXLabel(Value: string);
begin
	if Value <> FXLabel then
    begin
		  FXLabel := Value;
      InitRects;
      DrawXLabel(Canvas);
    end;
end;

procedure TCGraph.SetXStep(Value: double);
begin
	if (Value <> FXStep) and (Value <> 0) then
    begin
      {checkin' for max-buffer size allowed - adjust to your need} 
      if  ((FMaxX-FMinX)/(Value)) < 500 then
        begin
		    	FXStep  := Value;
    	    FXAxisUpdate := true;
          ResizeBufferToFit;
        	DrawAxis(Canvas);
        end
      else
        	ShowMessage('Too values will degrade the performance');
    end;
end;

procedure TCGraph.SetYFreq(Value: integer);
begin
	if (Value <> FYFreq) and (Value > 0) then
    begin
      FYFreq	:= Value;
      FXAxisUpdate := false;
      DrawAxis(Canvas);
    end;
end;

procedure TCGraph.SetYLabel(Value: string);
begin
	if Value <> FYLabel then
    begin
		  FYLabel := Value;
  		InitRects;
      DrawYLabel(Canvas);
    end;
end;

procedure TCGraph.SetYStep(Value: double);
begin
	if (Value <> FYStep) and (Value <> 0) then
    begin
		  FYStep  := Value;
   	  FXAxisUpdate := false;
      DrawAxis(Canvas);
    end;
end;

procedure TCGraph.WMSize(var M: TMessage);
begin
	inherited;
  InitRects;
	Invalidate;
end;

function TCGraph.TickCount: integer;
begin
	Result := Round((FMaxX-FMinX)/FXStep)+1;
end;

procedure TCGraph.SetLabelFont(Value: TFont);
begin
	if Value <> nil then
    begin
  	  FLabelFont.Assign(Value);
      InitRects;
      Invalidate;
    end;
end;

procedure TCGraph.OnTitleFontChanged(Sender: TObject);
begin
	InitRects;
	Invalidate;
end;

function TCGraph.StepInPixels: integer;
var
	R : TRect;
begin
	R := FPlotAreaRect;
	Result := Round((R.Right-R.Left)/(TickCount-1));
end;

procedure TCGraph.SetNumberFont(Value: TFont);
begin
	if Value <> nil then
    begin
	    FNumberFont.Assign(Value);
      InitRects;
      Invalidate;
    end;
end;

procedure TCGraph.SetPlotColor(Value: TColor);
begin
    if Value <> FPlotColor then
      begin
    	FPlotColor := Value;
        if (not (csDesigning in ComponentState)) then
          begin
            DrawPlotArea(Canvas);
            DrawPlot(Canvas);
          end;
      end;
end;

procedure TCGraph.InitRects;
begin
  FPlotAreaRect := PlotArea;
  FXAxisRect	  := XAxisRect;
  FYAxisRect	  := YAxisRect;
end;

procedure TCGraph.CreateWnd;
begin
  inherited CreateWnd;
	FWndAllocated := true;
end;

procedure TCGraph.DrawTracker(ACanvas: TCanvas; X, Y: integer;
  Color: TColor);
var
	R : TRect;
begin
	with ACanvas do
    begin
      R := FPlotAreaRect;
      InflateRect(R,-2,-2);
    	Pen.Style := psSolid;
      Brush.Style := bsClear;
      Pen.Mode  := pmNot;
      Pen.Color := Color;
		  MoveTo(X,R.Top);
   	  LineTo(X,R.Bottom + DrawMargin*2 + FTickSize);
      MoveTo(R.Left-(DrawMargin+FTickSize),Y);
   	  LineTo(R.Right+(DrawMargin+FTickSize),Y);
    end;
end;

procedure TCGraph.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  	inherited MouseDown(Button,Shift,X,Y);
    if PtInRect(FPlotAreaRect,Point(X,Y))and(Button = mbLeft) then
      begin
      	FOldTrackPos.X := X;
	      FOldTrackPos.Y := Y;
      	FLeftDown  := true;
        if FTracking then
          DrawTracker(Canvas,FOldTrackPos.X,FOldTrackPos.Y,FFrameColor);
      end;
      if FTracking and FLeftDown and (Button = mbRight) then
        begin
          FLeftDown := false;
      		DrawTracker(Canvas,FOldTrackPos.X,FOldTrackPos.Y,FFrameColor);
        end;
end;

procedure TCGraph.MouseMove(Shift: TShiftState; X, Y: Integer);
var
	dy		: integer;
  YValue,
  XValue	: double;
  R		: TRect;
  nTick	: integer;
begin
	inherited MouseMove(Shift,X,Y);
  R := FPlotAreaRect;
  InflateRect(R,-2,-2);
  Inc(R.Right,StepInPixels);
	if not FTracking and PtInRect(R,Point(X,Y)) and (ssLeft in Shift) then
    begin
      if (X < FOldTrackPos.X) then Scroll(true);
      if (X > FOldTrackPos.X) then Scroll(false);
    end;

  if PtInRect(R,Point(X,Y)) and (((X-R.Left) mod StepInPixels)=0) then
    begin
      nTick 	:= ((X-R.Left) div StepInPixels)+ FLow;
  		XValue  := (FMinX) + (nTick-FLow)*FXStep;
      if (nTick >=0) and (nTick < FPlotBuffer.Count) then
        begin
		    	YValue  := PDouble(FPlotBuffer.Items[nTick])^;
          dy := Round(Scale(FMinY,FMaxY,R.Bottom,R.Top,YValue));
        end
      else
        begin
        	YValue  := FMinY;
          dy		:= R.Bottom;
        end;
      if FTracking and FLeftDown then
        begin
    			DrawTracker(Canvas,FOldTrackPos.X,FOldTrackPos.Y,FFrameColor);
		    	DrawTracker(Canvas,X,dy,FFrameColor);
          DoTrack(XValue,YValue);
        end;
      FOldTrackPos.X := X;
      FOldTrackPos.Y := dy;
    end;
end;

procedure TCGraph.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
	R  : TRect;
begin
	inherited;
    R := FPlotAreaRect;
    InflateRect(R,-2,-2);
    if FLeftDown and FTracking then
      begin
        DrawTracker(Canvas,FOldTrackPos.X,FOldTrackPos.Y,FFrameColor);
      end;
    FLeftDown  := false;
end;

procedure TCGraph.DoTrack(X, Y: Double);
begin
	if Assigned(FOnTracking) then
    FOnTracking(Self,X,Y);
end;

procedure TCGraph.SetTracking(Value: boolean);
begin
	FTracking := Value; 
end;

procedure TCGraph.Reset;
begin
	if FPlotBuffer <> nil then
    begin
		  FPlotBuffer.Clear;
      FMinX := FOMinX;
    	FMaxX := FOMaxX;
      FMinY := FOMinY;
		  FMaxY := FOMaxY;
      FLow  := -1;
      FHigh := -1;
      FCurrX	  := FMinX-FXStep;
      FHasScrolled := false;
      FFirstPlot	 := true;
      FXAxisUpdate := true;
      if ShowAxis then DrawAxis(Canvas);
      FXAxisUpdate := false;
      if ShowAxis then DrawAxis(Canvas);
      DrawPlotArea(Canvas);
    end;
end;

procedure TCGraph.SetHistoryCount(Value: integer);
begin
	if (Value <> FHistoryCount) and (Value >=0) then
    begin
      FHistoryCount := Value;
    end;
end;

procedure TCGraph.SetTickSize(Value: integer);
begin
	if (Value <> FTickSize) and (Value >0) then
    begin
		  FTickSize := Value;
      FXAxisUpdate := true;
      if FShowAxis then DrawAxis(Canvas);
      FXAxisUpdate := false;
      if FShowAxis then DrawAxis(Canvas);
    end;
end;

procedure TCGraph.SetAutoScale(Value: boolean);
begin
  FAutoScale := Value;
end;

{ TDoubleList }
{ .: Notes :.
 It would be slow with large of history content
 One sugestion would be replacing this list by dynamic-allocated
 memory to enhance access time with pointer operation,
 but you need to modify some places in codes !
}

procedure TDoubleList.Clear;
var
	i : integer;
begin
	for i:=0 to Count-1 do
      begin
	      Dispose(PDouble(Items[i]));
      end;
  inherited Clear;
end;

end.



