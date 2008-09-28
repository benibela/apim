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
{$mode delphi}{$h+}
uses
  LResources, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls{,richedit},LCLType,windowcontrolfuncs;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure windowexstylesItemClick(Sender: TObject; Index: integer);
    procedure windowstylesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure windowstylesClickCheck(Sender: TObject);
    procedure windowexstylesClickCheck(Sender: TObject);
    procedure classstylesClickCheck(Sender: TObject);
    procedure windowstylesItemClick(Sender: TObject; Index: integer);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
    han:THandle;
  end;

var
  windowstyleform: Twindowstyleform;
  
implementation

uses applicationConfig,ptranslateutils;

{$i wstyles.atr}

//function InstallHookNewStyle(Hwnd: Cardinal;_style:cardinal;exstyle:boolean): Boolean; stdcall;external 'hook.dll';

procedure Twindowstyleform.FormShow(Sender: TObject);
var styles,i:longint;
    classname:array[0..255] of char;
begin
 windowStylesToCheckListBox(han, windowstyles, labelws);
// labelws.Caption:='Window styles:   '+labelws.Caption;

 windowCustomStylesToCheckListBox(han,extrawindowstyle,labeles);
 extraclass.Visible:=extrawindowstyle.Items.Count>0;
 //labeles.Caption:=string(classname)+' Styles (=Window Styles): '+labeles.Caption;

 windowExStylesToCheckListBox(han,windowexstyles, labelwsex);
 //labelwsex.Caption:='Extended Window styles:   '+labelwsex.caption;

 classStylesToCheckListBox(styles,classstyles,labelcs);
 //labelcs.Caption:='Window Class styles:   '+labelcs.Caption;
end;

procedure Twindowstyleform.FormCreate(Sender: TObject);
begin
  initUnitTranslation('wstyles',tr);
  tr.translate(self);
end;

procedure Twindowstyleform.Button1Click(Sender: TObject);
begin
ModalResult:=mrOk;
Close;
end;

procedure Twindowstyleform.windowexstylesItemClick(Sender: TObject;
  Index: integer);
begin

end;

procedure Twindowstyleform.windowstylesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
end;

procedure Twindowstyleform.windowstylesClickCheck(Sender: TObject);
var i:integer;
    style:Cardinal;
begin
  style:=0;
  for i:=0 to windowstyles.Items.Count-1 do begin
    if windowstyles.Checked[i] then begin
    end;
  end;
  if extraclass.Visible then begin
    for i:=0 to extrawindowstyle.Items.Count-1 do begin
      if extrawindowstyle.Checked[i] then begin
        //Button Styles
        if extrawindowstyle.Items[i]=TBS_3STATE then style:=style or BS_3STATE else
        if extrawindowstyle.Items[i]=TBS_AUTO3STATE then style:=style or BS_AUTO3STATE else
        if extrawindowstyle.Items[i]=TBS_AUTOCHECKBOX then style:=style or BS_AUTOCHECKBOX else
        if extrawindowstyle.Items[i]=TBS_AUTORADIOBUTTON then style:=style or BS_AUTORADIOBUTTON else
        if extrawindowstyle.Items[i]=TBS_CHECKBOX then style:=style or BS_CHECKBOX else
        if extrawindowstyle.Items[i]=TBS_DEFPUSHBUTTON then style:=style or BS_DEFPUSHBUTTON else
        if extrawindowstyle.Items[i]=TBS_GROUPBOX then style:=style or BS_GROUPBOX else
        if extrawindowstyle.Items[i]=TBS_LEFTTEXT then style:=style or BS_LEFTTEXT else
        if extrawindowstyle.Items[i]=TBS_OWNERDRAW then style:=style or BS_OWNERDRAW else
        if extrawindowstyle.Items[i]=TBS_PUSHBUTTON then style:=style or BS_PUSHBUTTON else
        if extrawindowstyle.Items[i]=TBS_RADIOBUTTON then style:=style or BS_RADIOBUTTON else
        if extrawindowstyle.Items[i]=TBS_USERBUTTON then style:=style or BS_USERBUTTON else
        if extrawindowstyle.Items[i]=TBS_BITMAP then style:=style or BS_BITMAP else
        if extrawindowstyle.Items[i]=TBS_BOTTOM then style:=style or BS_BOTTOM else
        if extrawindowstyle.Items[i]=TBS_CENTER then style:=style or BS_CENTER else
        if extrawindowstyle.Items[i]=TBS_ICON then style:=style or BS_ICON else
        if extrawindowstyle.Items[i]=TBS_FLAT then style:=style or BS_FLAT else
        if extrawindowstyle.Items[i]=TBS_LEFT then style:=style or BS_LEFT else
        if extrawindowstyle.Items[i]=TBS_MULTILINE then style:=style or BS_MULTILINE else
        if extrawindowstyle.Items[i]=TBS_NOTIFY then style:=style or BS_NOTIFY else
        if extrawindowstyle.Items[i]=TBS_PUSHLIKE then style:=style or BS_PUSHLIKE else
        if extrawindowstyle.Items[i]=TBS_RIGHT then style:=style or BS_RIGHT else
        if extrawindowstyle.Items[i]=TBS_RIGHTBUTTON then style:=style or BS_RIGHTBUTTON else
        if extrawindowstyle.Items[i]=TBS_TEXT then style:=style or BS_TEXT else
        if extrawindowstyle.Items[i]=TBS_TOP then style:=style or BS_TOP else
        if extrawindowstyle.Items[i]=TBS_VCENTER then style:=style or BS_VCENTER else
        //ComboBoxStyle
        if extrawindowstyle.Items[i]=TCBS_AUTOHSCROLL then style:=style or CBS_AUTOHSCROLL else
        if extrawindowstyle.Items[i]=TCBS_DISABLENOSCROLL then style:=style or CBS_DISABLENOSCROLL  else
        if extrawindowstyle.Items[i]=TCBS_DROPDOWN then style:=style or CBS_DROPDOWN else
        if extrawindowstyle.Items[i]=TCBS_DROPDOWNLIST then style:=style or CBS_DROPDOWNLIST else
        if extrawindowstyle.Items[i]=TCBS_HASSTRINGS then style:=style or CBS_HASSTRINGS else
        if extrawindowstyle.Items[i]=TCBS_LOWERCASE then style:=style or CBS_LOWERCASE else
        if extrawindowstyle.Items[i]=TCBS_NOINTEGRALHEIGHT then style:=style or CBS_NOINTEGRALHEIGHT else
        if extrawindowstyle.Items[i]=TCBS_OEMCONVERT then style:=style or CBS_OEMCONVERT else
        if extrawindowstyle.Items[i]=TCBS_OWNERDRAWFIXED then style:=style or CBS_OWNERDRAWFIXED else
        if extrawindowstyle.Items[i]=TCBS_OWNERDRAWVARIABLE then style:=style or CBS_OWNERDRAWVARIABLE else
        if extrawindowstyle.Items[i]=TCBS_SIMPLE then style:=style or CBS_SIMPLE else
        if extrawindowstyle.Items[i]=TCBS_SORT then style:=style or CBS_SORT else
        if extrawindowstyle.Items[i]=TCBS_UPPERCASE then style:=style or CBS_UPPERCASE else
        //EditStyles
        if extrawindowstyle.Items[i]=TES_AUTOHSCROLL then style:=style or ES_AUTOHSCROLL  else
        if extrawindowstyle.Items[i]=TES_AUTOVSCROLL then style:=style or ES_AUTOVSCROLL else
        if extrawindowstyle.Items[i]=TES_CENTER then style:=style or ES_CENTER else
        if extrawindowstyle.Items[i]=TES_LEFT then style:=style or ES_LEFT else
        if extrawindowstyle.Items[i]=TES_LOWERCASE then style:=style or ES_LOWERCASE else
        if extrawindowstyle.Items[i]=TES_MULTILINE then style:=style or ES_MULTILINE else
        if extrawindowstyle.Items[i]=TES_NOHIDESEL then style:=style or ES_NOHIDESEL else
        if extrawindowstyle.Items[i]=TES_NUMBER then style:=style or ES_NUMBER else
        if extrawindowstyle.Items[i]=TES_OEMCONVERT then style:=style or ES_OEMCONVERT else
        if extrawindowstyle.Items[i]=TES_PASSWORD then style:=style or ES_PASSWORD else
        if extrawindowstyle.Items[i]=TES_READONLY then style:=style or ES_READONLY else
        if extrawindowstyle.Items[i]=TES_RIGHT then style:=style or ES_RIGHT else
        if extrawindowstyle.Items[i]=TES_UPPERCASE then style:=style or ES_UPPERCASE else
        if extrawindowstyle.Items[i]=TES_WANTRETURN then style:=style or ES_WANTRETURN else
        //ListBoxStyles
        if extrawindowstyle.Items[i]=TLBS_DISABLENOSCROLL then style:=style or LBS_DISABLENOSCROLL else
        if extrawindowstyle.Items[i]=TLBS_EXTENDEDSEL then style:=style or LBS_EXTENDEDSEL else
        if extrawindowstyle.Items[i]=TLBS_HASSTRINGS then style:=style or LBS_HASSTRINGS else
        if extrawindowstyle.Items[i]=TLBS_MULTICOLUMN then style:=style or LBS_MULTICOLUMN else
        if extrawindowstyle.Items[i]=TLBS_MULTIPLESEL then style:=style or LBS_MULTIPLESEL else
        if extrawindowstyle.Items[i]=TLBS_NODATA then style:=style or LBS_NODATA else
        if extrawindowstyle.Items[i]=TLBS_NOINTEGRALHEIGHT then style:=style or LBS_NOINTEGRALHEIGHT else
        if extrawindowstyle.Items[i]=TLBS_NOREDRAW then style:=style or LBS_NOREDRAW else
        if extrawindowstyle.Items[i]=TLBS_NOSEL then style:=style or LBS_NOSEL else
        if extrawindowstyle.Items[i]=TLBS_NOTIFY then style:=style or LBS_NOTIFY else
        if extrawindowstyle.Items[i]=TLBS_OWNERDRAWFIXED then style:=style or LBS_OWNERDRAWFIXED else
        if extrawindowstyle.Items[i]=TLBS_OWNERDRAWVARIABLE then style:=style or LBS_OWNERDRAWVARIABLE else
        if extrawindowstyle.Items[i]=TLBS_SORT then style:=style or LBS_SORT else
        if extrawindowstyle.Items[i]=TLBS_STANDARD then style:=style or LBS_STANDARD else
        if extrawindowstyle.Items[i]=TLBS_USETABSTOPS then style:=style or LBS_USETABSTOPS else
        if extrawindowstyle.Items[i]=TLBS_WANTKEYBOARDINPUT then style:=style or LBS_WANTKEYBOARDINPUT else
        //Richedit (fast alle Edit Styles siind auch benutzbar)
        if extrawindowstyle.Items[i]=TES_DISABLENOSCROLL  then style:=style or ES_DISABLENOSCROLL else
        if extrawindowstyle.Items[i]=TES_NOIME then style:=style or ES_NOIME else
        if extrawindowstyle.Items[i]=TES_SELFIME then style:=style or ES_SELFIME else
        if extrawindowstyle.Items[i]=TES_SUNKEN then style:=style or ES_SUNKEN else
        if extrawindowstyle.Items[i]=TES_VERTICAL then style:=style or ES_VERTICAL else
        //SCROLLBARS
        if extrawindowstyle.Items[i]=TSBS_BOTTOMALIGN then style:=style or SBS_BOTTOMALIGN else
        if extrawindowstyle.Items[i]=TSBS_HORZ then style:=style or SBS_HORZ else
        if extrawindowstyle.Items[i]=TSBS_LEFTALIGN then style:=style or SBS_LEFTALIGN else
        if extrawindowstyle.Items[i]=TSBS_RIGHTALIGN then style:=style or SBS_RIGHTALIGN else
        if extrawindowstyle.Items[i]=TSBS_SIZEBOX then style:=style or SBS_SIZEBOX else
        if extrawindowstyle.Items[i]=TSBS_SIZEBOXBOTTOMRIGHTALIGN then style:=style or SBS_SIZEBOXBOTTOMRIGHTALIGN else
        if extrawindowstyle.Items[i]=TSBS_SIZEBOXTOPLEFTALIGN then style:=style or SBS_SIZEBOXTOPLEFTALIGN else
        if extrawindowstyle.Items[i]=TSBS_SIZEGRIP then style:=style or SBS_SIZEGRIP else
        if extrawindowstyle.Items[i]=TSBS_TOPALIGN then style:=style or SBS_TOPALIGN  else
        if extrawindowstyle.Items[i]=TSBS_VERT then style:=style or SBS_VERT else
        //STATIC
        if extrawindowstyle.Items[i]=TSS_BITMAP then style:=style or SS_BITMAP else
        if extrawindowstyle.Items[i]=TSS_BLACKFRAME then style:=style or SS_BLACKFRAME  else
        if extrawindowstyle.Items[i]=TSS_BLACKRECT then style:=style or SS_BLACKRECT else
        if extrawindowstyle.Items[i]=TSS_CENTER then style:=style or SS_CENTER else
        if extrawindowstyle.Items[i]=TSS_CENTERIMAGE then style:=style or SS_CENTERIMAGE else
  {TODO: wieder einfügen      if extrawindowstyle.Items[i]=TSS_ENDELLIPSIS  then style:=style or SS_ENDELLIPSIS  else
        if extrawindowstyle.Items[i]=TSS_ENHMETAFILE then style:=style or SS_ENHMETAFILE else
        if extrawindowstyle.Items[i]=TSS_ENHMETAFILE then style:=style or SS_ENHMETAFILE else
        if extrawindowstyle.Items[i]=TSS_ETCHEDHORZ then style:=style or SS_ETCHEDHORZ else
        if extrawindowstyle.Items[i]=TSS_ETCHEDVERT then style:=style or SS_ETCHEDVERT else
        if extrawindowstyle.Items[i]=TSS_GRAYFRAME then style:=style or SS_GRAYFRAME else
        if extrawindowstyle.Items[i]=TSS_GRAYRECT then style:=style or SS_GRAYRECT else
        if extrawindowstyle.Items[i]=TSS_ICON then style:=style or SS_ICON else
        if extrawindowstyle.Items[i]=TSS_LEFT then style:=style or SS_LEFT else
        if extrawindowstyle.Items[i]=TSS_LEFTNOWORDWRAP then style:=style or SS_LEFTNOWORDWRAP else
        if extrawindowstyle.Items[i]=TSS_NOPREFIX  then style:=style or SS_NOPREFIX else
        if extrawindowstyle.Items[i]=TSS_NOTIFY then style:=style or SS_NOTIFY else
        if extrawindowstyle.Items[i]=TSS_OWNERDRAW then style:=style or SS_OWNERDRAW else
        if extrawindowstyle.Items[i]=TSS_PATHELLIPSIS then style:=style or SS_PATHELLIPSIS else
        if extrawindowstyle.Items[i]=TSS_REALSIZEIMAGE then style:=style or SS_REALSIZEIMAGE else
        if extrawindowstyle.Items[i]=TSS_RIGHT then style:=style or SS_RIGHT else
        if extrawindowstyle.Items[i]=TSS_RIGHTJUST then style:=style or SS_RIGHTJUST else
        if extrawindowstyle.Items[i]=TSS_SIMPLE then style:=style or SS_SIMPLE else
        if extrawindowstyle.Items[i]=TSS_SUNKEN then style:=style or SS_SUNKEN else
        if extrawindowstyle.Items[i]=TSS_WHITEFRAME then style:=style or SS_WHITEFRAME else
        if extrawindowstyle.Items[i]=TSS_WHITERECT then style:=style or SS_WHITERECT else
        if extrawindowstyle.Items[i]=TSS_WORDELLIPSIS then style:=style or SS_WORDELLIPSIS else
}
      end;
    end;
  end;
  if (CheckBox1.Checked)  then  begin
    //InstallHookNewStyle(han,style,false);
  end else begin
    SetWindowLong(han,GWL_STYLE,style);
  end;
  if windows.getParent(han)=0 then
    RedrawWindow(han,nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE)
   else
    RedrawWindow(windows.getParent(han),nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE);
  windowstyles.Refresh;
//  FormShow(mainform);
end;



procedure Twindowstyleform.windowexstylesClickCheck(Sender: TObject);
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

procedure Twindowstyleform.windowstylesItemClick(Sender: TObject; Index: integer
  );
begin
  if index<0 then exit;
  changeWindowStyle(han,windowstyles.Items[index],windowstyles.checked[index]);
end;

initialization
  {$I wstyles.lrs}
end.
