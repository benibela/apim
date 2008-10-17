{
    Copyright (C) 2001-2008 Benito van der Zander, www.benibela.de

    This file is part of API Manager.

    API Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    API Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with API Manager.  If not, see <http://www.gnu.org/licenses/>.
}
unit searchTool;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,windowcontrolfuncs,LDockCtrl,applicationConfig;

type

  { TsearchToolFrm }

  TsearchToolFrm = class(TForm)
    findTimer: TTimer;
    hideAPIVwhenSearching: TCheckBox;
    Label1: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    linksoben: TPanel;
    mouseHandleEdt: TEdit;
    mouseRefreshAllLive: TCheckBox;
    mouseToolImage: TImage;
    mouseWindowClassEdt: TEdit;
    mouseWindowProgramEdt: TEdit;
    mouseWindowTextEdt: TEdit;
    miniScreen: TPanel;
    miniScreenPaintbox: TPaintBox;
    rechtsunten: TPanel;
    procedure closeProperties(Sender: TObject; var CloseAction: TCloseAction);
    procedure findTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure linksobenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure linksobenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miniScreenPaintboxPaint(Sender: TObject);
    procedure miniScreenTimerTimer(Sender: TObject);
    procedure mouseToolImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mouseToolImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { private declarations }
    procedure drawMiniScreen;
    currentMouseWindow: thandle;
    callback:TCallbackComponent;
    miniscreendbl: graphics.TBitmap;
  public
    { public declarations }
    Docker: TLazControlDocker;
  end;

var
  searchToolFrm: TsearchToolFrm;

implementation
uses windows,windowfuncs,bbutils,ptranslateutils;


{$I searchtool.atr}


const
  crScanner:integer=101;

{$R cursor.res}

{ TsearchToolFrm }

procedure TsearchToolFrm.mouseToolImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then begin
    screen.Cursor:=crScanner;
    currentMouseWindow:=0;

    if hideAPIVwhenSearching.Checked then
      niceSetVisible(false, true);
  end;
end;

procedure TsearchToolFrm.findTimerTimer(Sender: TObject);
 { procedure addWindow(wnd: thandle);
  var     s:array[0..255]of char;
  begin
    s:='';
    if wnd=0 then exit;
    with mouseWindowFamily.Items.add do begin;
      caption:=Cardinal2Str(wnd);
      GetWindowText(wnd,s,255);
      subitems.Add(s);
      GetClassName(wnd,s,255);
      subitems.Add(s);
    end;
  end;      }
var x,xx:THandle;
    p:TPoint;
    A:integer;
    mouseHandle: THandle;
    rec:trect;

    markDC: HDC;
    lb:LOGBRUSH;
begin
  GetCursorPos(p);
  mouseHandle:=GetRealWindowFromPoint(p,hideAPIVwhenSearching.Checked);
  if mouseHandle=currentMouseWindow then exit;

  if mouseHandle = miniScreen.Handle then begin
    p:=miniScreen.ScreenToClient(p);
    p.x:=p.x*screen.width div miniScreen.clientWidth;
    p.y:=p.y*screen.Height div miniScreen.ClientHeight;
    mouseHandle:=GetRealWindowFromPoint(p);
    if mouseHandle=currentMouseWindow then exit;
  end;


  mouseHandleEdt.text:=Cardinal2Str(mouseHandle);
  mouseWindowTextEdt.Text:=GetWindowTextS(mouseHandle);
  mouseWindowClassEdt.Text:=getWindowClassNameToDisplay(mouseHandle);
  mouseWindowProgramEdt.Text:=GetFileNameFromHandleToDisplay(mouseHandle);

  if screen.cursor=crScanner then begin
    toggleWindowMarkStatus(currentMouseWindow);
    toggleWindowMarkStatus(mouseHandle);
  end;
  currentMouseWindow:=mouseHandle;
  if mouseRefreshAllLive.Checked then callback.showHandle(currentMouseWindow,PROPERTYSHEETFRM_ID);
end;

procedure TsearchToolFrm.closeProperties(Sender: TObject;
  var CloseAction: TCloseAction);
begin
end;

procedure TsearchToolFrm.FormCreate(Sender: TObject);
begin
  Docker:=TLazControlDocker.Create(Self);
  miniscreendbl:=graphics.TBitmap.Create;
  callback:=TCallbackComponent.create(self);
  miniScreen.OnPaint:=@PaintBox1Paint;
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);

  hideAPIVwhenSearching.Checked:=globalConfig.GetValue('searchTool/hideAPIV',hideAPIVwhenSearching.Checked);
  linksoben.Left:=globalConfig.GetValue('searchTool/miniScreen/x1',linksoben.Left);
  linksoben.top:=globalConfig.GetValue('searchTool/miniScreen/y1',linksoben.top);
  rechtsunten.Left:=globalConfig.GetValue('searchTool/miniScreen/x2',rechtsunten.Left);
  rechtsunten.top:=globalConfig.GetValue('searchTool/miniScreen/y2',rechtsunten.top);
  mouseRefreshAllLive.checked:=defaultRefreshTimeInterval>0;
  linksobenMouseMove(linksoben,[ssleft],3,3);
end;

procedure TsearchToolFrm.FormDestroy(Sender: TObject);
begin
  miniscreendbl.free;
  globalConfig.SetValue('searchTool/miniScreen/x1',linksoben.Left);
  globalConfig.SetValue('searchTool/miniScreen/y1',linksoben.top);
  globalConfig.SetValue('searchTool/miniScreen/x2',rechtsunten.Left);
  globalConfig.SetValue('searchTool/miniScreen/y2',rechtsunten.top);
  globalConfig.SetValue('searchTool/hideAPIV',hideAPIVwhenSearching.Checked);
end;

procedure TsearchToolFrm.FormPaint(Sender: TObject);
begin
end;

procedure TsearchToolFrm.linksobenMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TsearchToolFrm.linksobenMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var senderp:TPanel;
begin
  if ssLeft in shift then begin
    senderp:=(sender as TPAnel);
    senderp.Left:=senderp.Left-3+x;
    senderp.Top:=senderp.Top-3+y;
    if linksoben.left<rechtsunten.Left then begin
      miniScreen.Left:=linksoben.left;
      miniScreen.Width:=rechtsunten.left- miniScreen.left;
    end else begin
      miniScreen.Left:=rechtsunten.left;
      miniScreen.Width:=linksoben.left- miniScreen.left;
    end;
    if linksoben.Top<rechtsunten.Top then begin
      miniScreen.Top:=linksoben.Top;
      miniScreen.Height:=rechtsunten.Top- miniScreen.Top;
    end else begin
      miniScreen.Top:=rechtsunten.Top;
      miniScreen.Height:=linksoben.Top- miniScreen.Top;
    end;
  end;
end;

procedure TsearchToolFrm.miniScreenPaintboxPaint(Sender: TObject);
begin
  drawMiniScreen;
end;

procedure TsearchToolFrm.miniScreenTimerTimer(Sender: TObject);
begin
  drawMiniScreen;
end;

procedure TsearchToolFrm.mouseToolImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then begin
    screen.Cursor:=crDefault;
    toggleWindowMarkStatus(currentMouseWindow);

    if hideAPIVwhenSearching.Checked then
      niceSetVisible(true,true);

    callback.showHandle(currentMouseWindow,PROPERTYSHEETFRM_ID);
  end;
end;

procedure TsearchToolFrm.PaintBox1Click(Sender: TObject);
begin
  callback.showHandle(currentMouseWindow,PROPERTYSHEETFRM_ID);
end;

procedure TsearchToolFrm.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TsearchToolFrm.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TsearchToolFrm.drawMiniScreen;
var h:THandle;
    pos:TRect;
    i:longint;
    ty,tx:single;
    orderedwindows:array of thandle;
    backgroundwindow: thandle;
    can: tcanvas;

begin
  if miniScreen.Width=0 then exit;
  if miniScreen.Height=0 then exit;
  if miniScreen.Canvas=nil then exit;


  miniscreendbl.setSize(miniScreen.width-2,miniScreen.Height-2);
  can:=miniscreendbl.Canvas ;
  tx:=screen.Width / miniScreen.Width;//120;
  ty:=screen.Height / miniScreen.Height;//90;
  //find
  h:=GetTopWindow(0);
  repeat
    arrayAdd(orderedwindows,h);
    h:=GetNextWindow(h, GW_HWNDNEXT);
  until h=0;

  //draw
  backgroundwindow:=FindWindow('PROGMAN',nil);
  for i:=high(orderedwindows) downto 0 do begin
    h:=orderedwindows[i];
    if not IsWindowVisible(h) then continue;
    GetWindowRect(orderedwindows[i],pos);
    pos.Left:=round(pos.Left / tx);
    pos.Right:=round(pos.Right / tx);
    pos.top:=round(pos.top /ty);
    pos.Bottom:=round(pos.Bottom /ty);
    if GetWindowThreadProcessId(orderedwindows[i],nil) = MainThreadID then can.Brush.Color:=clGreen
    else if orderedwindows[i]=backgroundwindow then  can.Brush.Color:=clBackground
    else can.Brush.Color:=clBtnFace;
    can.Rectangle(pos.Left,pos.top,pos.Right,pos.Bottom);
  end;
  miniScreenPaintbox.Canvas.Draw(0,0,miniscreendbl);
  miniScreen.Canvas.Draw(1,1,miniscreendbl);
end;

initialization
  {$I searchtool.lrs}

  screen.cursors[crScanner]:=LoadCursor(HINSTANCE,makeintresource(101));
end.

