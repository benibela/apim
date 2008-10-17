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
unit wstyles;

interface
{$mode objfpc}{$h+}
uses
  LResources, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls{,richedit},LCLType,windowcontrolfuncs,LDockCtrl;
const
  WS_EX_COMPOSITED = $02000000;
  WS_EX_NOACTIVATE = $08000000;
  WS_EX_LAYERED = $00080000;
  WS_EX_NOINHERITLAYOUT = $00100000;
  WS_EX_LAYOUTRTL = $00400000;

  CS_DROPSHADOW = $00020000;

  ES_DISABLENOSCROLL                  = $00002000; //Richedit
  ES_NOIME                            = $00080000; //   "
  ES_SELFIME                          = $00040000; //   " 
  ES_SUNKEN                           = $00004000; //   "
  ES_VERTICAL                         = $00400000; //   " 


  TWS_BORDER:String = 'WS_BORDER';
  TWS_CAPTION:String = 'WS_CAPTION (WS_BORDER)';
  TWS_CHILD:String = 'WS_CHILD';
  TWS_CHILDWINDOW:String = 'WS_CHILDWINDOW (=WS_CHILD)';
  TWS_CLIPCHILDREN:String = 'WS_CLIPCHILDREN';
  TWS_CLIPSIBLINGS:String = 'WS_CLIPSIBLINGS';
  TWS_DISABLED:String = 'WS_DISABLED';
  TWS_DLGFRAME:String = 'WS_DLGFRAME';
  TWS_GROUP:String = 'WS_GROUP';
  TWS_HSCROLL:String = 'WS_HSCROLL';
  TWS_ICONIC:String = 'WS_ICONIC (=WS_MINIMIZE)';
  TWS_MAXIMIZE:String = 'WS_MAXIMIZE';
  TWS_MAXIMIZEBOX:String = 'WS_MAXIMIZEBOX';
  TWS_MINIMIZE:String = 'WS_MINIMIZE';
  TWS_MINIMIZEBOX:String = 'WS_MINIMIZEBOX';
  TWS_OVERLAPPED:String = 'WS_OVERLAPPED (=WS_TILED)';
  TWS_OVERLAPPEDWINDOW:String = 'WS_OVERLAPPEDWINDOW (=WS_TILEDWINDOW) (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX) ';
  TWS_POPUP:String = 'WS_POPUP';
  TWS_POPUPWINDOW:String = 'WS_POPUPWINDOW (WS_BORDER + WS_POPUP + WS_SYSMENU)';
  TWS_SIZEBOX:String = 'WS_SIZEBOX';
  TWS_SYSMENU:String = 'WS_SYSMENU';
  TWS_TABSTOP:String = 'WS_TABSTOP';
  TWS_THICKFRAME:String = 'WS_THICKFRAME (=WS_SIZEBOX)';
  TWS_TILED:String = 'WS_TILED (=WS_OVERLAPPED)';
  TWS_TILEDWINDOW:String = 'WS_TILEDWINDOW (=WS_OVERLAPPEDWINDOW) (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)';
  TWS_VISIBLE:String = 'WS_VISIBLE';
  TWS_VSCROLL:String = 'WS_VSCROLL';
  TWS_EX_ACCEPTFILES:String = 'WS_EX_ACCEPTFILES';
  TWS_EX_APPWINDOW:String = 'WS_EX_APPWINDOW';
  TWS_EX_CLIENTEDGE:String = 'WS_EX_CLIENTEDGE';
  TWS_EX_COMPOSITED :String = 'WS_EX_COMPOSITED ';
  TWS_EX_CONTEXTHELP:String = 'WS_EX_CONTEXTHELP';
  TWS_EX_CONTROLPARENT:String = 'WS_EX_CONTROLPARENT';
  TWS_EX_DLGMODALFRAME:String = 'WS_EX_DLGMODALFRAME';
  TWS_EX_LAYERED:String = 'WS_EX_LAYERED';
  TWS_EX_LAYOUTRTL:String = 'WS_EX_LAYOUTRTL';
  TWS_EX_LEFT:String = 'WS_EX_LEFT';
  TWS_EX_LEFTSCROLLBAR:String = 'WS_EX_LEFTSCROLLBAR';
  TWS_EX_LTRREADING:String = 'WS_EX_LTRREADING';
  TWS_EX_MDICHILD:String = 'WS_EX_MDICHILD';
  TWS_EX_NOACTIVATE:String = 'WS_EX_NOACTIVATE';
  TWS_EX_NOINHERITLAYOUT:String = 'WS_EX_NOINHERITLAYOUT';
  TWS_EX_NOPARENTNOTIFY:String = 'WS_EX_NOPARENTNOTIFY';
  TWS_EX_OVERLAPPEDWINDOW:String = 'WS_EX_OVERLAPPEDWINDOW (WS_EX_CLIENTEDGE + WS_EX_WINDOWEDGE)';
  TWS_EX_PALETTEWINDOW:String = 'WS_EX_PALETTEWINDOW (WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST)';
  TWS_EX_RIGHT:String = 'WS_EX_RIGHT';
  TWS_EX_RIGHTSCROLLBAR:String = 'WS_EX_RIGHTSCROLLBAR';
  TWS_EX_RTLREADING:String = 'WS_EX_RTLREADING';
  TWS_EX_STATICEDGE:String = 'WS_EX_STATICEDGE';
  TWS_EX_TOOLWINDOW:String = 'WS_EX_TOOLWINDOW';
  TWS_EX_TOPMOST:String = 'WS_EX_TOPMOST';
  TWS_EX_TRANSPARENT:String = 'WS_EX_TRANSPARENT';
  TWS_EX_WINDOWEDGE:String = 'WS_EX_WINDOWEDGE';
  TCS_BYTEALIGNCLIENT:String='CS_BYTEALIGNCLIENT';
  TCS_BYTEALIGNWINDOW:String = 'CS_BYTEALIGNWINDOW';
  TCS_CLASSDC:String = 'CS_CLASSDC';
  TCS_DBLCLKS:String = 'CS_DBLCLKS';
  TCS_DROPSHADOW:String = 'CS_DROPSHADOW';
  TCS_GLOBALCLASS:String = 'CS_GLOBALCLASS';
  TCS_HREDRAW:String = 'CS_HREDRAW';
  TCS_NOCLOSE:String = 'CS_NOCLOSE';
  TCS_OWNDC:String = 'CS_OWNDC';
  TCS_PARENTDC:String = 'CS_PARENTDC';
  TCS_SAVEBITS:String = 'CS_SAVEBITS';
  TCS_VREDRAW:String = 'CS_VREDRAW';

  TBS_3STATE:String='BS_3STATE';
  TBS_AUTO3STATE:String ='BS_AUTO3STATE';
  TBS_AUTOCHECKBOX:String = 'BS_AUTOCHECKBOX';
  TBS_AUTORADIOBUTTON:String = 'BS_AUTORADIOBUTTON';
  TBS_CHECKBOX:String = 'BS_CHECKBOX';
  TBS_DEFPUSHBUTTON:String ='BS_DEFPUSHBUTTON';
  TBS_GROUPBOX:String = 'BS_GROUPBOX';
  TBS_LEFTTEXT:String = 'BS_LEFTTEXT';
  TBS_OWNERDRAW:String = 'BS_OWNERDRAW';
  TBS_PUSHBUTTON:String ='BS_PUSHBUTTON';
  TBS_RADIOBUTTON:String = 'BS_RADIOBUTTON';
  TBS_USERBUTTON:String = 'BS_USERBUTTON';
  TBS_BITMAP:String = 'BS_BITMAP';
  TBS_BOTTOM:String ='BS_BOTTOM';
  TBS_CENTER:String = 'BS_CENTER';
  TBS_ICON:String = 'BS_ICON';
  TBS_FLAT:String = 'BS_FLAT';
  TBS_LEFT:String ='BS_LEFT';
  TBS_MULTILINE:String = 'BS_MULTILINE';
  TBS_NOTIFY:String = 'BS_NOTIFY';
  TBS_PUSHLIKE:String = 'BS_PUSHLIKE';
  TBS_RIGHT:String ='BS_RIGHT';
  TBS_RIGHTBUTTON:String = 'BS_RIGHTBUTTON';
  TBS_TEXT:String = 'BS_TEXT';
  TBS_TOP:String = 'BS_TOP';
  TBS_VCENTER:String = 'BS_VCENTER';

  //ComboBoxStyles
  TCBS_AUTOHSCROLL:String = 'CBS_AUTOHSCROLL';
  TCBS_DISABLENOSCROLL:String = 'CBS_DISABLENOSCROLL';
  TCBS_DROPDOWN:String = 'CBS_DROPDOWN';
  TCBS_DROPDOWNLIST:String = 'CBS_DROPDOWNLIST';
  TCBS_HASSTRINGS:String = 'CBS_HASSTRINGS';
  TCBS_LOWERCASE:String = 'CBS_LOWERCASE';
  TCBS_NOINTEGRALHEIGHT:String = 'CBS_NOINTEGRALHEIGHT';
  TCBS_OEMCONVERT:String = 'CBS_OEMCONVERT';
  TCBS_OWNERDRAWFIXED:String = 'CBS_OWNERDRAWFIXED';
  TCBS_OWNERDRAWVARIABLE:String = 'CBS_OWNERDRAWVARIABLE';
  TCBS_SIMPLE:String = 'CBS_SIMPLE';
  TCBS_SORT:String = 'CBS_SORT';
  TCBS_UPPERCASE:String = 'CBS_UPPERCASE';

  //Editstyles
  TES_AUTOHSCROLL:String = 'ES_AUTOHSCROLL';
  TES_AUTOVSCROLL:String = 'ES_AUTOVSCROLL';
  TES_CENTER:String = 'ES_CENTER';
  TES_LEFT:String = 'ES_LEFT';
  TES_LOWERCASE:String = 'ES_LOWERCASE';
  TES_MULTILINE:String = 'ES_MULTILINE';
  TES_NOHIDESEL:String = 'ES_NOHIDESEL';
  TES_NUMBER:String = 'ES_NUMBER';
  TES_OEMCONVERT:String = 'ES_OEMCONVERT';
  TES_PASSWORD:String = 'ES_PASSWORD';
  TES_READONLY:String = 'ES_READONLY';
  TES_RIGHT:String = 'ES_RIGHT';
  TES_UPPERCASE:String = 'ES_UPPERCASE';
  TES_WANTRETURN:String = 'ES_WANTRETURN';

  //ListBox Styles
  TLBS_DISABLENOSCROLL:String = 'LBS_DISABLENOSCROLL';
  TLBS_EXTENDEDSEL:String = 'LBS_EXTENDEDSEL';
  TLBS_HASSTRINGS:String = 'LBS_HASSTRINGS';
  TLBS_MULTICOLUMN:String = 'LBS_MULTICOLUMN';
  TLBS_MULTIPLESEL:String = 'LBS_MULTIPLESEL';
  TLBS_NODATA:String = 'LBS_NODATA';
  TLBS_NOINTEGRALHEIGHT:String = 'LBS_NOINTEGRALHEIGHT';
  TLBS_NOREDRAW:String = 'LBS_NOREDRAW';
  TLBS_NOSEL:String = 'LBS_NOSEL';
  TLBS_NOTIFY:String = 'LBS_NOTIFY';
  TLBS_OWNERDRAWFIXED:String = 'LBS_OWNERDRAWFIXED';
  TLBS_OWNERDRAWVARIABLE:String = 'LBS_OWNERDRAWVARIABLE';
  TLBS_SORT:String = 'LBS_SORT';
  TLBS_STANDARD:String = 'LBS_STANDARD';
  TLBS_USETABSTOPS:String = 'LBS_USETABSTOPS';
  TLBS_WANTKEYBOARDINPUT:String = 'LBS_WANTKEYBOARDINPUT';

  //Edit Styles (only for Richedit)
  TES_DISABLENOSCROLL:String = 'ES_DISABLENOSCROLL';
  TES_EX_NOCALLOLEINIT:String = 'ES_EX_NOCALLOLEINIT';
  TES_NOIME:String = 'ES_NOIME';
  TES_SELFIME:String = 'ES_SELFIME';
  TES_SUNKEN:String = 'ES_SUNKEN';
  TES_VERTICAL:String = 'ES_VERTICAL';

  //Scroll Bar Control
  TSBS_BOTTOMALIGN:String = 'SBS_BOTTOMALIGN';
  TSBS_HORZ:String = 'SBS_HORZ';
  TSBS_LEFTALIGN:String = 'SBS_LEFTALIGN';
  TSBS_RIGHTALIGN:String = 'SBS_RIGHTALIGN';
  TSBS_SIZEBOX:String = 'SBS_SIZEBOX';
  TSBS_SIZEBOXBOTTOMRIGHTALIGN:String = 'SBS_SIZEBOXBOTTOMRIGHTALIGN';
  TSBS_SIZEBOXTOPLEFTALIGN:String = 'SBS_SIZEBOXTOPLEFTALIGN';
  TSBS_SIZEGRIP:String = 'SBS_SIZEGRIP';
  TSBS_TOPALIGN:String = 'SBS_TOPALIGN';
  TSBS_VERT:String = 'SBS_VERT';

  //Static Styles
  TSS_BITMAP:String = 'SS_BITMAP';
  TSS_BLACKFRAME:String = 'SS_BLACKFRAME';
  TSS_BLACKRECT:String = 'SS_BLACKRECT';
  TSS_CENTER:String = 'SS_CENTER';
  TSS_CENTERIMAGE:String = 'SS_CENTERIMAGE';
  TSS_ENDELLIPSIS :String = 'SS_ENDELLIPSIS ';
  TSS_ENHMETAFILE:String = 'SS_ENHMETAFILE';
  TSS_ETCHEDFRAME:String = 'SS_ETCHEDFRAME';
  TSS_ETCHEDHORZ:String = 'SS_ETCHEDHORZ';
  TSS_ETCHEDVERT:String = 'SS_ETCHEDVERT';
  TSS_GRAYFRAME:String = 'SS_GRAYFRAME';
  TSS_GRAYRECT:String = 'SS_GRAYRECT';
  TSS_ICON:String = 'SS_ICON';
  TSS_LEFT:String = 'SS_LEFT';
  TSS_LEFTNOWORDWRAP:String = 'SS_LEFTNOWORDWRAP';
  TSS_NOPREFIX:String = 'SS_NOPREFIX';
  TSS_NOTIFY:String = 'SS_NOTIFY';
  TSS_OWNERDRAW:String = 'SS_OWNERDRAW';
  TSS_PATHELLIPSIS:String = 'SS_PATHELLIPSIS';
  TSS_REALSIZECONTROL:String = 'SS_REALSIZECONTROL';
  TSS_REALSIZEIMAGE:String = 'SS_REALSIZEIMAGE';
  TSS_RIGHT:String = 'SS_RIGHT';
  TSS_RIGHTJUST:String = 'SS_RIGHTJUST';
  TSS_SIMPLE:String = 'SS_SIMPLE';
  TSS_SUNKEN:String = 'SS_SUNKEN';
  TSS_WHITEFRAME:String = 'SS_WHITEFRAME';
  TSS_WHITERECT:String = 'SS_WHITERECT';
  TSS_WORDELLIPSIS:String = 'SS_WORDELLIPSIS';

type

  { Twindowstyleform }

  Twindowstyleform = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel3: TPanel;
    Button1: TButton;
    classstyles: TCheckListBox;
    Panel5: TPanel;
    windowexstyles: TCheckListBox;
    labelwsex: TPanel;
    labelcs: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    windowstyles: TCheckListBox;
    labelws: TPanel;
    Splitter3: TSplitter;
    extraclass: TPanel;
    extrawindowstyle: TCheckListBox;
    labeles: TPanel;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure windowstylesClickCheck(Sender: TObject);
    procedure classstylesClickCheck(Sender: TObject);
    procedure windowstylesItemClick(Sender: TObject; Index: integer);
  private
    { Private-Deklarationen}
    procedure showHandle(sender:tobject; wnd: THandle;func:longint);
  public
    { Public-Deklarationen}
    Docker: TLazControlDocker;
    callback: TCallbackComponent;
    han:THandle;
  end;

var
  windowstyleform: Twindowstyleform;
  
implementation

uses applicationConfig,ptranslateutils;

{$i wstyles.atr}

//function InstallHookNewStyle(Hwnd: Cardinal;_style:cardinal;exstyle:boolean): Boolean; stdcall;external 'hook.dll';

procedure Twindowstyleform.FormCreate(Sender: TObject);
begin
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);
  Docker:=TLazControlDocker.Create(Self);
  callback:=TCallbackComponent.create(self);
  callback.onShowHandle:=@showHandle;
end;

procedure Twindowstyleform.Button2Click(Sender: TObject);
begin
 windowStylesToCheckListBox(han, windowstyles, label1,edit1);

 windowCustomStylesToCheckListBox(han,extrawindowstyle,label2,edit2);
 extraclass.Visible:=extrawindowstyle.Items.Count>0;

 windowExStylesToCheckListBox(han,windowexstyles, label3,edit3);

 classStylesToCheckListBox(han,classstyles,label4,edit4);
end;

procedure Twindowstyleform.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then Button2.Click
  else if key=VK_RETURN then begin
    if sender=edit1 then SetWindowLongInjected(han,GWL_STYLE,Str2Cardinal(edit1.text),CheckBox1.Checked)
    else if sender=edit2 then SetWindowLongInjected(han,GWL_STYLE,Str2Cardinal(edit2.text),CheckBox1.Checked)
    else if sender=edit3 then SetWindowLongInjected(han,GWL_EXSTYLE,Str2Cardinal(edit3.text),CheckBox1.Checked)
    else if sender=edit4 then SetClassLongInjected(han,GCL_STYLE,Str2Cardinal(edit4.text),CheckBox1.Checked);
    Button2.Click;
  end;
end;

procedure Twindowstyleform.Edit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure Twindowstyleform.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Twindowstyleform.windowstylesClickCheck(Sender: TObject);
var i:integer;
    style:Cardinal;
begin
end;



procedure Twindowstyleform.classstylesClickCheck(Sender: TObject);
var i:integer;
    style:Cardinal;
begin
  style:=0;
  for i:=0 to classstyles.Items.Count-1 do begin
    if classstyles.Checked[i] then begin
      if classstyles.Items[i]=TCS_BYTEALIGNCLIENT then style:=style or CS_BYTEALIGNCLIENT else
      if classstyles.Items[i]=TCS_BYTEALIGNWINDOW then style:=style or CS_BYTEALIGNWINDOW else
      if classstyles.Items[i]=TCS_CLASSDC then style:=style or CS_CLASSDC else
      if classstyles.Items[i]=TCS_DBLCLKS then style:=style or CS_DBLCLKS else
      if classstyles.Items[i]=TCS_DROPSHADOW then style:=style or CS_DROPSHADOW else
      if classstyles.Items[i]=TCS_GLOBALCLASS  then style:=style or CS_GLOBALCLASS else
      if classstyles.Items[i]=TCS_HREDRAW then style:=style or CS_HREDRAW else
      if classstyles.Items[i]=TCS_NOCLOSE then style:=style or CS_NOCLOSE else
      if classstyles.Items[i]=TCS_OWNDC then style:=style or CS_OWNDC  else
      if classstyles.Items[i]=TCS_PARENTDC then style:=style or CS_PARENTDC else
      if classstyles.Items[i]=TCS_SAVEBITS then style:=style or CS_SAVEBITS else
      if classstyles.Items[i]=TCS_VREDRAW then style:=style or CS_VREDRAW else
//      if classstyles.Items[i]=TCS_ then style:=style or CS_ else
    end;
  end;
  SetClassLong(han,GCL_STYLE,style);
  if windows.getParent(han)=0 then
    RedrawWindow(han,nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE)
   else
    RedrawWindow(windows.getParent(han),nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE);

  classstyles.Refresh;
//  FormShow(mainform);
end;

procedure Twindowstyleform.windowstylesItemClick(Sender: TObject; Index: integer);
var currentSelected: string;
begin
  if index<0 then exit;
  currentSelected:=TCheckListBox(sender).items[index];

  if Sender=windowStyles then changeWindowStyle(han, currentSelected,windowStyles.checked[index],CheckBox1.Checked)
  else if Sender=windowExStyles then changeWindowExStyle(han, currentSelected,windowExStyles.checked[index],CheckBox1.Checked)
  else if Sender=extrawindowstyle then changeCustomStyle(han, currentSelected,extrawindowstyle.checked[index],CheckBox1.Checked)
  else if Sender=classstyles then changeClassStyle(han, currentSelected,classstyles.checked[index],CheckBox1.Checked);


  callback.showHandle(han,PROPERTYSHEETFRM_ID); //update all, window styles can have strange effects
  Application.ProcessMessages;
  PostMessage(TCheckListBox(sender).Handle,LB_SETCURSEL,TCheckListBox(sender).items.IndexOf(currentSelected),0);
{  if index<0 then exit;
  changeWindowStyle(han,windowstyles.Items[index],windowstyles.checked[index]);}
end;

procedure Twindowstyleform.showHandle(sender: tobject; wnd: THandle;
  func: longint);
begin
  han:=wnd;
  Button2.Click;
end;

initialization
  {$I wstyles.lrs}
end.
