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
//TODO: hook
unit windowPropertySheet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, Menus,windowcontrolfuncs,StdCtrls,Spin,CheckLst,windowList,
  processList,applicationConfig;

type

  { TWindowPropertySheetFrm }

  TWindowPropertySheetFrm = class(TForm)
    alphatrans_cb: TCheckBox;
    alphatrans_sp: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label3: TLabel;
    messageresult: TLabel;
    messageInject: TCheckBox;
    classNameEdt: TEdit;
    ColorDialog1: TColorDialog;
    colorKeyShape: TShape;
    colorkey_cb: TCheckBox;
    enabledCb: TCheckBox;
    handleEdt: TEdit;
    labclassname: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lablparam: TLabel;
    labwparam: TLabel;
    messagelparam_edt: TEdit;
    messagemes_cb: TComboBox;
    messageSend_btn: TButton;
    messagewparam_edt: TEdit;
    ownerWnd_edt: TEdit;
    parentWndCmb: TComboBox;
    posLTEdt: TEdit;
    posRBEdt: TEdit;
    blinkWindow: TButton;
    showStateCmb: TComboBox;
    sizeEdt: TEdit;
    stayOnTopCb: TCheckBox;
    autorefreshtimer: TTimer;
    unicodeCb: TCheckBox;
    userdata_edt: TEdit;
    visibleCb: TCheckBox;
    windowAddProperty: TMenuItem;
    windowExStyles: TCheckListBox;
    windowExStyles_edt: TEdit;
    windowProcessIDedt: TEdit;
    windowPropChange: TMenuItem;
    windowPropertyList: TListView;
    windowPropertyListPopup: TPopupMenu;
    windowPropertyPanel: TPanel;
    windowPropRemoveItem: TMenuItem;
    windowStyles: TCheckListBox;
    windowStyles_edt: TEdit;
    windowtextEdt: TEdit;
    windowThreadIdEdt: TEdit;
    wndproc_edt: TEdit;
    procedure alphatrans_spKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure autorefreshtimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure colorKeyShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure jumptoWndDblClick(Sender: TObject);
    procedure messagemes_cbKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure messageSend_btnClick(Sender: TObject);
    procedure blinkWindowClick(Sender: TObject);
    procedure ownerWnd_edtDblClick(Sender: TObject);
    procedure updatePropertyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure propertyChanged(Sender: TObject);
    procedure windowAddPropertyClick(Sender: TObject);
    procedure windowProcessIDedtDblClick(Sender: TObject);
    procedure windowPropChangeClick(Sender: TObject);
    procedure windowPropertyListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure windowPropertyListDeletion(Sender: TObject; Item: TListItem);
    procedure windowPropertyPanelClick(Sender: TObject);
    procedure windowPropRemoveItemClick(Sender: TObject);
    procedure windowStylesClickCheck(Sender: TObject);
    procedure windowStylesItemClick(Sender: TObject; Index: integer);
  private
    { private declarations }
    displayCalls:longint;
    currentWindow:thandle;

    procedure showHandle(sender:tobject; wnd: THandle;func:longint);

    procedure displayProperty(prop:TObject);
    procedure changeProperty(prop:TObject);
  public
    { public declarations }
    callback: TCallbackComponent;
  end;

var
  WindowPropertySheetFrm: TWindowPropertySheetFrm;

implementation

uses windows,bbutils,windowfuncs,win32proc,wstyles,ptranslateutils;
{$i windowPropertySheet.atr}
{ TWindowPropertySheetFrm }

procedure TWindowPropertySheetFrm.windowPropertyListDeletion(Sender: TObject;
  Item: TListItem);
begin
  if item=nil then exit;
  if displayCalls>0 then exit; //save is save
  RemoveProp(currentWindow, pchar(item.Caption));
  displayProperty(windowPropertyList);
end;

procedure TWindowPropertySheetFrm.windowPropertyPanelClick(Sender: TObject);
begin

end;

procedure TWindowPropertySheetFrm.windowAddPropertyClick(Sender: TObject);
var n,v:string;
begin
  n:='';
  if sender=windowAddProperty then begin
    if not InputQuery('',tr['Name der neuen Eigenschaft: '],n) then exit;
    v:=Cardinal2Str(0);
  end else if windowPropertyList.Selected<>nil then begin
    n:=windowPropertyList.selected.Caption;
    v:=windowPropertyList.Selected.SubItems[0];
  end;
  if not InputQuery('',tr['Neuer Wert der Eigenschaft: '],v) then exit;
  SetPropA(currentWindow,pchar(n),Str2Cardinal(v));
  displayProperty(windowPropertyList);
end;

procedure TWindowPropertySheetFrm.windowProcessIDedtDblClick(Sender: TObject);
begin
  callback.showHandle(Str2Cardinal((sender as tedit).Text),PROCESSLISTFRM_ID);
end;

procedure TWindowPropertySheetFrm.windowPropChangeClick(Sender: TObject);
begin
end;

procedure TWindowPropertySheetFrm.windowPropertyListChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin         //#todo -1: check if renaming works in later lazarus
  if change<>ctText then exit;
  if item=nil then exit;
  if displayCalls>0 then exit; //change is called when internally changing *grr*

  //ShowMessage(item.Caption);
  //systemProperties.EditingDone;
  RemoveProp(currentWindow, pchar(item.SubItems[1]));
  SetProp(currentWindow, pchar(item.Caption), Str2Cardinal(item.SubItems[0]));
  displayProperty(windowPropertyList);
end;


procedure TWindowPropertySheetFrm.updatePropertyKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=VK_ESCAPE then displayProperty(sender)
  else if key=VK_RETURN then changeProperty(sender);
end;

procedure TWindowPropertySheetFrm.propertyChanged(Sender: TObject);
begin
  changeProperty(sender);
end;

procedure TWindowPropertySheetFrm.jumptoWndDblClick(Sender: TObject);
var s:string;
begin
  if not (sender is tedit) then exit;
  s:=tedit(sender).text;
  if pos(' - ',s)>0 then s:=strSplitGet(' - ',s);
  handleEdt.Text:=s;
  changeProperty(handleEdt);
end;

procedure TWindowPropertySheetFrm.messagemes_cbKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=VK_RETURN then messageSend_btn.Click;
end;

procedure TWindowPropertySheetFrm.messageSend_btnClick(Sender: TObject);
var wp,lp,res: cardinal;
    blockWP,blockLP: TMemoryBlocks;
    msgStr: string;
begin
  msgStr:=messagemes_cb.text;
  if pos('=',msgStr)>0 then begin
    strsplitGet('=',msgStr);
    if pos(';',msgStr)>0 then msgStr:=strsplitGet(';',msgStr);
  end;

  blockWP:=createMemoryBlocks(messagewparam_edt.Text);
  blockLP:=createMemoryBlocks(messagelparam_edt.Text);
//  b0:=PByteArray(blockLP[0]);
//  b1:=PByteArray(blockLP[1]);
  wp:=0;
  lp:=0;
  if blockWP<>nil then
     if length(blockWP[0])>4 then wp:=cardinal(@blockWP[0,0])
     else move(blockWP[0,0],wp,length(blockWP[0]));
  if blockLP<>nil then
    if length(blockLP[0])>4 then lp:=cardinal(@blockLP[0,0])
    else move(blockLP[0,0],lp,length(blockLP[0]));
  if messageInject.Checked and ((length(blockLP[0])>4)or(length(blockWP[0])>4)) then
    ShowMessage(tr['Injection mit größeren Block wird in dieser Version nicht unterstützt.']); //todo: injection with block
  if messageInject.Checked then SendMessageInjected(currentWindow,Str2Cardinal(msgStr),wp,lp)
  else res:=SendMessage(currentWindow,Str2Cardinal(msgStr),wp,lp);
  messageresult.Caption:=tr['Result: ']+Cardinal2Str(res);
end;

procedure TWindowPropertySheetFrm.blinkWindowClick(Sender: TObject);
begin
  if GetWindowThreadProcessId(currentWindow,nil)<>MainThreadID then
    niceSetVisible(false,false);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  if GetWindowThreadProcessId(currentWindow,nil)<>MainThreadID then
    niceSetVisible(true,false);
//#todo -1: not always blending
end;

procedure TWindowPropertySheetFrm.ownerWnd_edtDblClick(Sender: TObject);
begin

end;

procedure TWindowPropertySheetFrm.colorKeyShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color:=colorKeyShape.brush.color;
  if not ColorDialog1.Execute then exit;
  colorKeyShape.Brush.Color:=ColorDialog1.Color;
  changeProperty(colorKeyShape);
end;

procedure TWindowPropertySheetFrm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
end;

procedure TWindowPropertySheetFrm.FormCreate(Sender: TObject);
begin
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);
  callback:=TCallbackComponent.create(self);
  callback.onShowHandle:=@showHandle;
end;

procedure TWindowPropertySheetFrm.FormDestroy(Sender: TObject);
begin
end;

procedure TWindowPropertySheetFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (shift = [ssCtrl]) and (key=VK_SPACE) then begin
    openWindowsConst;
    key:=0;
  end;
end;

procedure TWindowPropertySheetFrm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TWindowPropertySheetFrm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TWindowPropertySheetFrm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TWindowPropertySheetFrm.alphatrans_spKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

end;

procedure TWindowPropertySheetFrm.autorefreshtimerTimer(Sender: TObject);
begin
  if defaultRefreshTimeInterval =0 then begin
    autorefreshtimer.Interval:=5000;
    exit;
  end;
  autorefreshtimer.Interval:=defaultRefreshTimeInterval;
  changeProperty(handleEdt);
end;

procedure TWindowPropertySheetFrm.Button1Click(Sender: TObject);
begin
  callback.showHandle(currentWindow,WINDOWLISTFRM_ID);
end;

procedure TWindowPropertySheetFrm.Button2Click(Sender: TObject);
begin
  windowtextEdt.Text:=GetWindowTextInjected(currentWindow);
end;

procedure TWindowPropertySheetFrm.Button5Click(Sender: TObject);
begin
  callback.showHandle(currentWindow, WINDOWSTYLELISTFRM_ID);
end;

procedure TWindowPropertySheetFrm.windowPropRemoveItemClick(Sender: TObject);
begin
  if windowPropertyList.Selected<>nil then begin
    RemoveProp(currentWindow, pchar(windowPropertyList.Selected.Caption));
    displayProperty(windowPropertyList);
  end else ShowMessage(tr['Keine Eigenschaft ausgewählt']);
end;

procedure TWindowPropertySheetFrm.windowStylesClickCheck(Sender: TObject);
begin
end;

procedure TWindowPropertySheetFrm.windowStylesItemClick(Sender: TObject;
  Index: integer);
var currentSelected: string;
begin
  if index<0 then exit;
  currentSelected:=TCheckListBox(sender).items[index];

  if Sender=windowStyles then changeWindowStyle(currentWindow, currentSelected,windowStyles.checked[index])
  else if Sender=windowExStyles then changeWindowExStyle(currentWindow, currentSelected,windowExStyles.checked[index]);

  //displayProperty(sender);
  changeProperty(handleEdt); //update all, window styles can have strange effects
  Application.ProcessMessages;
  PostMessage(TCheckListBox(sender).Handle,LB_SETCURSEL,TCheckListBox(sender).items.IndexOf(currentSelected),0);

end;

procedure TWindowPropertySheetFrm.showHandle(sender: tobject; wnd: THandle;func:longint);
begin
  handleEdt.text:=Cardinal2Str(wnd);
  changeProperty(handleEdt);
end;


procedure TWindowPropertySheetFrm.displayProperty(prop: TObject);
var propEdt:TEdit;
    rect:TRect;
    tempHandle: THandle;
    parentWnd: hwnd;
    s:string;
    wndcolor:COLORREF;
    i,flags:longint;
    alpha:byte;
begin
  displayCalls+=1;
  try
  if prop=handleEdt then handleEdt.Text:=Cardinal2Str(currentWindow)
  else if prop=parentWndCmb then begin
    parentWnd:=getRealParent(currentWindow);
    parentWndCmb.Clear;
    parentWndCmb.Text:=Cardinal2Str(parentWnd);
    while parentWnd<>0 do begin
      s:=GetWindowTextS(parentWnd);
      if s<>'' then parentWndCmb.Items.Add(Cardinal2Str(parentWnd) + ' - '+s)
      else parentWndCmb.Items.Add(Cardinal2Str(parentWnd));
      parentWnd:=getRealParent(parentWnd);
    end;
  end else if prop=windowtextEdt then windowtextEdt.Text:=GetWindowTextS(currentWindow)
  else if prop=ownerWnd_edt then ownerWnd_edt.Text:=Cardinal2Str(GetWindow(currentWindow,GW_OWNER))
  else if prop=classNameEdt then classNameEdt.text:=getWindowClassNameToDisplay(currentWindow)
  else if prop=enabledCb then enabledCb.Checked:=IsWindowEnabled(currentWindow)
  else if prop=visibleCb then visibleCb.Checked:=IsWindowVisible(currentWindow)
  else if prop=unicodeCb then unicodeCb.Checked:=IsWindowUnicode(currentWindow)
  else if prop=stayOnTopCb then stayOnTopCb.Checked:=GetWindowLong(currentWindow,GWL_EXSTYLE) and WS_EX_TOPMOST = WS_EX_TOPMOST
  else if prop=showStateCmb then begin
    case getshowwindow(currentWindow) of
      SW_MAXIMIZE:showStateCmb.ItemIndex:=2;
      SW_MINIMIZE:showStateCmb.ItemIndex:=1;
      else showStateCmb.ItemIndex:=0;
    end;
  end else if (prop=posLTEdt) or (prop=posRBEdt) or (prop=sizeEdt) then begin
    FillChar(rect,sizeof(rect),0);
    GetWindowRect(currentWindow, rect);
    windows.ScreenToClient(getRealParent(currentWindow),rect.TopLeft);
    windows.ScreenToClient(getRealParent(currentWindow),rect.BottomRight);
    posLTEdt.Text:='('+IntToStr(rect.left) + ', '+IntToStr(rect.top)+')';
    posRBEdt.Text:='('+IntToStr(rect.Right) + ', '+IntToStr(rect.Bottom)+')';
    sizeEdt.Text:=IntToStr(rect.Right-rect.Left) + 'x'+IntToStr(rect.Bottom-rect.Top);
  end else if (prop=alphatrans_cb) or (prop=alphatrans_sp) or
          (prop=colorkey_cb) or (prop=colorKeyShape)  then begin
    if runonNT and GetWindowAlphaColorKey(currentWindow,wndcolor,alpha,flags) then begin
      alphatrans_cb.Caption:='Transparent:';
      colorkey_cb.Caption:='ColorKey:';
      alphatrans_cb.Checked:=flags and lwa_alpha = lwa_alpha;
      colorkey_cb.Checked:=flags and lwa_colorkey= lwa_colorkey;
      if alphatrans_cb.Checked then
        alphatrans_sp.Value:=alpha;//trunc(100-(alpha * 100) / 255);
      if colorkey_cb.Checked then
        colorKeyShape.Brush.Color:=wndcolor;
    end else begin
      alphatrans_cb.Caption:='Transparent??';
      colorkey_cb.Caption:='ColorKey??';
    end;
  end else if prop=windowPropertyList then begin
    windowPropertyList.Clear;
    EnumPropsEx(currentWindow,PROPENUMPROCEX(@WindowPropertyEnumProc),lparam(windowPropertyList));
  end else if prop=messagemes_cb then begin
//    messagemes_cb.items.Text:='WM_DESTROY ($0002)'#13#10'WM_CLOSE ($0010)'#13#10'WM_QUIT ($0012)'#13#10+
  //                      'WM_ENDSESSION ($0016)'#13#10'WM_SHOWWINDOW ($0018)'#13#10'WM_SETCURSOR ($0020)'#13#10+
   //                     'WM_NEXTDLGCTL ($0028;
    messagemes_cb.items.Clear;
    for i:=1 to $00A9 do
      if not strbeginswith(WM_To_String(i),'Unknown') then
        messagemes_cb.items.Add(WM_To_String(i)+' = '+Cardinal2Str(i)+';');
    for i:=$100 to $03E8 do
      if not strbeginswith(WM_To_String(i),'Unknown') then
        messagemes_cb.items.Add(WM_To_String(i)+' = '+Cardinal2Str(i)+';');

  end else if prop=userdata_edt then userdata_edt.Text:=Cardinal2Str(cardinal(GetWindowLong(currentWindow,GWL_USERDATA)))
  else if prop=wndproc_edt then wndproc_edt.Text:=Cardinal2Str(cardinal(GetWindowLong(currentWindow,GWL_WNDPROC)))
  else if (prop=windowStyles) or (prop=windowStyles_edt) then windowStylesToCheckListBox(currentWindow,windowStyles,nil,windowStyles_edt)
  else if (prop=windowExStyles) or (prop=windowExStyles_edt) then windowExStylesToCheckListBox(currentWindow,windowExStyles,nil,windowExStyles_edt)
  else if (prop=windowProcessIDedt) or (prop=windowThreadIdEdt) then begin
    tempHandle:=0;
    windowThreadIdEdt.Text:=Cardinal2Str(GetWindowThreadProcessId(currentWindow,@tempHandle));
    windowProcessIDedt.Text:=Cardinal2Str(tempHandle);
  end;

  ;

  finally
    displayCalls-=1;
  end;
end;

procedure TWindowPropertySheetFrm.changeProperty(prop: TObject);
var i,flags:longint;
    s,sf:string;
    rec: trect;
begin
  if displayCalls>0 then exit;
  if prop=handleEdt then begin
    //Alle Werte aktualisieren
    currentWindow:=Str2Cardinal(handleEdt.Text);
    for i:=0 to  windowPropertyPanel.ControlCount-1 do
      if windowPropertyPanel.Controls[i].Tag=1 then
//      if Controls[i].parentWnd=windowPropertyPanel then
        displayProperty(windowPropertyPanel.Controls[i]);
    if callback.existsLinkTo(WINDOWSTYLELISTFRM_ID) then
      callback.showHandle(currentWindow,WINDOWSTYLELISTFRM_ID);
  {  displayProperty(parentwndEdt);
    displayProperty(windowtextEdt);
    displayProperty(classNameEdt);
    displayProperty(enabledCb);
    displayProperty(visibleCb);
    displayProperty(unicodeCb);
    displayProperty(stayOnTopCb);
    displayProperty(showStateCmb);}
  end else if prop=parentWndCmb then begin
    s:=parentWndCmb.Text;
    if pos(' - ',s)>0 then s:=strSplitGet(' - ',s);
    windows.SetParent(currentWindow,Str2Cardinal(s));
  end else if prop=windowtextEdt then SetWindowText(currentWindow,pchar(windowtextEdt.Text))
  else if prop=enabledCb then EnableWindow(currentWindow,enabledCb.Checked)
  else if prop=visibleCb then begin
    if visibleCb.Checked then showWindow(currentWindow,sw_show)
    else ShowWindow(currentWindow,SW_HIDE);
  end else if prop=unicodeCb then enabledCb.Checked:=IsWindowUnicode(currentWindow)
  else if prop=stayOnTopCb then begin
    if stayOnTopCb.Checked then SetWindowPos(currentWindow,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE)
    else SetWindowPos(currentWindow,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
  end else if prop=showStateCmb then begin
    case showStateCmb.ItemIndex of
      0: ShowWindow(currentWindow,SW_NORMAL);
      1: ShowWindow(currentWindow,SW_MINIMIZE);
      2: ShowWindow(currentWindow,SW_MAXIMIZE);
    end;
  end else if prop=posLTEdt then begin
    s:=StringReplace(posLTEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Left:=StrToInt(strSplitGet(',',s));
    rec.top:=StrToInt(strSplitGet(')',s));
    SetWindowPos(currentWindow,0,rec.Left,rec.top,0,0,SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE);
    RedrawWindow(currentWindow,nil,0,RDW_ERASE or RDW_INVALIDATE);
  end else if prop=posRBEdt then begin
    s:=StringReplace(posLTEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Left:=StrToInt(strSplitGet(',',s));
    rec.top:=StrToInt(strSplitGet(')',s));
    s:=StringReplace(posRBEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Right:=StrToInt(strSplitGet(',',s));
    rec.Bottom:=StrToInt(strSplitGet(')',s));
    SetWindowPos(currentWindow,0,0,0,rec.Right-Rec.Left,rec.Bottom-Rec.Top,SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOMOVE)
  end else if prop=sizeEdt then begin
    s:=StringReplace(sizeEdt.text,' ','',[rfReplaceAll]);
    rec.Right:=StrToInt(strSplitGet('x',s));
    rec.Bottom:=StrToInt(s);
    SetWindowPos(currentWindow,0,0,0,rec.Right,rec.Bottom,SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOMOVE)
  end else if (prop=alphatrans_sp) or (prop=alphatrans_cb) or
              (prop=colorkey_cb) or (prop=colorKeyShape) then begin
{    flags:=GetWindowLong(currentWindow,GWL_EXSTYLE);
    if colorkey_cb.checked or alphatrans_cb.checked then begin
      if flags and WS_EX_LAYERED <> WS_EX_LAYERED then
        SetWindowLong(currentWindow,GWL_EXSTYLE,flags or WS_EX_LAYERED);  }
      flags:=0;
      if colorkey_cb.checked then flags+=LWA_COLORKEY;
      if alphatrans_cb.checked then flags+=LWA_ALPHA;
      if flags <> 0 then  windowfuncs.SetLayeredWindowAttributes(currentWindow,ColorToRGB(colorKeyShape.Brush.Color),alphatrans_sp.Value,flags)
      else SetWindowLong(currentWindow,GWL_EXSTYLE,GetWindowLong(currentWindow,GWL_EXSTYLE) and not WS_EX_LAYERED);
    {end else if flags and WS_EX_LAYERED = WS_EX_LAYERED then
        SetWindowLong(currentWindow,GWL_EXSTYLE,flags and not WS_EX_LAYERED);}
  end else if prop=userdata_edt then SetWindowLong(currentWindow,GWL_USERDATA,Str2Cardinal(userdata_edt.Text))
  else if prop=windowStyles_edt then begin
    SetWindowLong(currentWindow,GWL_STYLE,Str2Cardinal(windowStyles_edt.Text));
    displayProperty(handleEdt);
    exit;
  end else if prop=windowExStyles_edt then begin
    SetWindowLong(currentWindow,GWL_EXSTYLE,Str2Cardinal(windowExStyles_edt.Text));
    displayProperty(handleEdt);
    exit;
  end;



  ;
  displayProperty(prop);
end;


initialization
  {$I windowpropertysheet.lrs}
end.

