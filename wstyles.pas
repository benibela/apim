unit wstyles;

interface
{$mode delphi}{$h+}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls{,richedit},LCLType;
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
 { T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';
  T:String = '';          }

type
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
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure windowstylesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure windowstylesClickCheck(Sender: TObject);
    procedure windowexstylesClickCheck(Sender: TObject);
    procedure classstylesClickCheck(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
    han:THandle;
  end;

var
  windowstyleform: Twindowstyleform;
  
implementation

uses applicationConfig;


function InstallHookNewStyle(Hwnd: Cardinal;_style:cardinal;exstyle:boolean): Boolean; stdcall;external 'hook.dll';

procedure Twindowstyleform.FormShow(Sender: TObject);
var styles,i:longint;
    wsout:TStringList;
    classname:array[0..255] of char;
begin
 windowstyles.Clear;
 windowexstyles.Clear;
 classstyles.Clear;
 extrawindowstyle.Clear;
 wsout:=TStringList.create;
 styles:=GetWindowLong(han,GWL_STYLE);
 labelws.Caption:='Window styles:   '+Cardinal2Str(styles);
 if styles and WS_BORDER = WS_BORDER then windowstyles.Items.Add(TWS_BORDER) else wsout.Add(TWS_BORDER);
 if styles and WS_CAPTION = WS_CAPTION then windowstyles.Items.Add(TWS_CAPTION) else wsout.Add(TWS_CAPTION);
 if styles and WS_CHILD = WS_CHILD then windowstyles.Items.Add(TWS_CHILD) else wsout.Add(TWS_CHILD);
 if styles and WS_CHILDWINDOW = WS_CHILDWINDOW then windowstyles.Items.Add(TWS_CHILDWINDOW) else wsout.Add(TWS_CHILDWINDOW);
 if styles and WS_CLIPCHILDREN = WS_CLIPCHILDREN then windowstyles.Items.Add(TWS_CLIPCHILDREN) else wsout.Add(TWS_CLIPCHILDREN);
 if styles and WS_CLIPSIBLINGS = WS_CLIPSIBLINGS then windowstyles.Items.Add(TWS_CLIPSIBLINGS) else wsout.Add(TWS_CLIPSIBLINGS);
 if styles and WS_DISABLED = WS_DISABLED then windowstyles.Items.Add(TWS_DISABLED) else wsout.Add(TWS_DISABLED);
 if styles and WS_DLGFRAME = WS_DLGFRAME then windowstyles.Items.Add(TWS_DLGFRAME) else wsout.Add(TWS_DLGFRAME);
 if styles and WS_GROUP = WS_GROUP then windowstyles.Items.Add(TWS_GROUP) else wsout.Add(TWS_GROUP);
 if styles and WS_HSCROLL = WS_HSCROLL then windowstyles.Items.Add(TWS_HSCROLL) else wsout.Add(TWS_HSCROLL);
 if styles and WS_ICONIC = WS_ICONIC then windowstyles.Items.Add(TWS_ICONIC) else wsout.Add(TWS_ICONIC);
 if styles and WS_MAXIMIZE = WS_MAXIMIZE then windowstyles.Items.Add(TWS_MAXIMIZE) else wsout.Add(TWS_MAXIMIZE);
 if styles and WS_MAXIMIZEBOX = WS_MAXIMIZEBOX then windowstyles.Items.Add(TWS_MAXIMIZEBOX) else wsout.Add(TWS_MAXIMIZEBOX);
 if styles and WS_MINIMIZE = WS_MINIMIZE then windowstyles.Items.Add(TWS_MINIMIZE) else wsout.Add(TWS_MINIMIZE);
 if styles and WS_MINIMIZEBOX = WS_MINIMIZEBOX then windowstyles.Items.Add(TWS_MINIMIZEBOX) else wsout.Add(TWS_MINIMIZEBOX);
 if styles and WS_OVERLAPPED = WS_OVERLAPPED then windowstyles.Items.Add(TWS_OVERLAPPED)else wsout.Add(TWS_OVERLAPPED);
 if styles and WS_OVERLAPPEDWINDOW = WS_OVERLAPPEDWINDOW then windowstyles.Items.Add(TWS_OVERLAPPEDWINDOW) else wsout.Add(TWS_OVERLAPPEDWINDOW);

 if styles and WS_POPUP = WS_POPUP then windowstyles.Items.Add(TWS_POPUP) else wsout.Add(TWS_POPUP);
 if styles and WS_POPUPWINDOW = WS_POPUPWINDOW then windowstyles.Items.Add(TWS_POPUPWINDOW) else wsout.Add(TWS_POPUPWINDOW);
 if styles and WS_SIZEBOX = WS_SIZEBOX then windowstyles.Items.Add(TWS_SIZEBOX) else wsout.Add(TWS_SIZEBOX);
 if styles and WS_SYSMENU = WS_SYSMENU then windowstyles.Items.Add(TWS_SYSMENU) else wsout.Add(TWS_SYSMENU);
 if styles and WS_TABSTOP = WS_TABSTOP then windowstyles.Items.Add(TWS_TABSTOP)else wsout.Add(TWS_TABSTOP);
 if styles and WS_THICKFRAME = WS_THICKFRAME then windowstyles.Items.Add(TWS_THICKFRAME)else wsout.Add(TWS_THICKFRAME);
 if styles and WS_TILED = WS_TILED then windowstyles.Items.Add(TWS_TILED)else wsout.Add(TWS_TILED);
 if styles and WS_TILEDWINDOW = WS_TILEDWINDOW then windowstyles.Items.Add(TWS_TILEDWINDOW)else wsout.Add(TWS_TILEDWINDOW);
 if styles and WS_VISIBLE = WS_VISIBLE then windowstyles.Items.Add(TWS_VISIBLE)else wsout.Add(TWS_VISIBLE);
 if styles and WS_VSCROLL = WS_VSCROLL then windowstyles.Items.Add(TWS_VSCROLL)else wsout.Add(TWS_VSCROLL);
 for i:=0 to windowstyles.Items.Count-1 do
   windowstyles.Checked[i]:=true;
 windowstyles.Items.AddStrings(wsout);
 wsout.Clear;

 GetClassName(han,classname,255);
 extraclass.Visible:=false;
 if UpperCase(string( classname))='BUTTON' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Button Styles (=Window Styles): '+Cardinal2Str(styles);
   if styles and BS_3STATE = BS_3STATE then extrawindowstyle.Items.Add(TBS_3STATE)else wsout.Add(TBS_3STATE);
   if styles and BS_AUTO3STATE = BS_AUTO3STATE then extrawindowstyle.Items.Add(TBS_AUTO3STATE)else wsout.Add(TBS_AUTO3STATE);
   if styles and BS_AUTOCHECKBOX = BS_AUTOCHECKBOX then extrawindowstyle.Items.Add(TBS_AUTOCHECKBOX)else wsout.Add(TBS_AUTOCHECKBOX);
   if styles and BS_AUTORADIOBUTTON = BS_AUTORADIOBUTTON then extrawindowstyle.Items.Add(TBS_AUTORADIOBUTTON)else wsout.Add(TBS_AUTORADIOBUTTON);
   if styles and BS_CHECKBOX = BS_CHECKBOX then extrawindowstyle.Items.Add(TBS_CHECKBOX)else wsout.Add(TBS_CHECKBOX);
   if styles and BS_DEFPUSHBUTTON = BS_DEFPUSHBUTTON then extrawindowstyle.Items.Add(TBS_DEFPUSHBUTTON)else wsout.Add(TBS_DEFPUSHBUTTON);
   if styles and BS_GROUPBOX = BS_GROUPBOX then extrawindowstyle.Items.Add(TBS_GROUPBOX)else wsout.Add(TBS_GROUPBOX);
   if styles and BS_LEFTTEXT = BS_LEFTTEXT then extrawindowstyle.Items.Add(TBS_LEFTTEXT)else wsout.Add(TBS_LEFTTEXT);
   if styles and BS_OWNERDRAW = BS_OWNERDRAW then extrawindowstyle.Items.Add(TBS_OWNERDRAW)else wsout.Add(TBS_OWNERDRAW);
   if styles and BS_PUSHBUTTON = BS_PUSHBUTTON then extrawindowstyle.Items.Add(TBS_PUSHBUTTON)else wsout.Add(TBS_PUSHBUTTON);
   if styles and BS_RADIOBUTTON = BS_RADIOBUTTON then extrawindowstyle.Items.Add(TBS_RADIOBUTTON)else wsout.Add(TBS_RADIOBUTTON);
   if styles and BS_USERBUTTON = BS_USERBUTTON then extrawindowstyle.Items.Add(TBS_USERBUTTON)else wsout.Add(TBS_USERBUTTON);
   if styles and BS_BITMAP = BS_BITMAP then extrawindowstyle.Items.Add(TBS_BITMAP)else wsout.Add(TBS_BITMAP);
   if styles and BS_BOTTOM = BS_BOTTOM then extrawindowstyle.Items.Add(TBS_BOTTOM)else wsout.Add(TBS_BOTTOM);
   if styles and BS_CENTER = BS_CENTER then extrawindowstyle.Items.Add(TBS_CENTER)else wsout.Add(TBS_CENTER);
   if styles and BS_ICON = BS_ICON then extrawindowstyle.Items.Add(TBS_ICON)else wsout.Add(TBS_ICON);
   if styles and BS_FLAT = BS_FLAT then extrawindowstyle.Items.Add(TBS_FLAT)else wsout.Add(TBS_FLAT);
   if styles and BS_LEFT = BS_LEFT then extrawindowstyle.Items.Add(TBS_LEFT)else wsout.Add(TBS_LEFT);
   if styles and BS_MULTILINE = BS_MULTILINE then extrawindowstyle.Items.Add(TBS_MULTILINE)else wsout.Add(TBS_MULTILINE);
   if styles and BS_NOTIFY = BS_NOTIFY then extrawindowstyle.Items.Add(TBS_NOTIFY)else wsout.Add(TBS_NOTIFY);
   if styles and BS_PUSHLIKE = BS_PUSHLIKE then extrawindowstyle.Items.Add(TBS_PUSHLIKE)else wsout.Add(TBS_PUSHLIKE);
   if styles and BS_RIGHT = BS_RIGHT then extrawindowstyle.Items.Add(TBS_RIGHT)else wsout.Add(TBS_RIGHT);
   if styles and BS_RIGHTBUTTON = BS_RIGHTBUTTON then extrawindowstyle.Items.Add(TBS_RIGHTBUTTON)else wsout.Add(TBS_RIGHTBUTTON);
   if styles and BS_TEXT = BS_TEXT then extrawindowstyle.Items.Add(TBS_TEXT)else wsout.Add(TBS_TEXT);
   if styles and BS_TOP = BS_TOP then extrawindowstyle.Items.Add(TBS_TOP)else wsout.Add(TBS_TOP);
   if styles and BS_VCENTER = BS_VCENTER then extrawindowstyle.Items.Add(TBS_VCENTER)else wsout.Add(TBS_VCENTER);
  { if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
}
 end;
 if UpperCase(string( classname))='COMBOBOX' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Combobox styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and CBS_AUTOHSCROLL = CBS_AUTOHSCROLL then extrawindowstyle.Items.Add(TCBS_AUTOHSCROLL)else wsout.Add(TCBS_AUTOHSCROLL);
   if styles and CBS_DISABLENOSCROLL = CBS_DISABLENOSCROLL then extrawindowstyle.Items.Add(TCBS_DISABLENOSCROLL)else wsout.Add(TCBS_DISABLENOSCROLL);
   if styles and CBS_DROPDOWN = CBS_DROPDOWN then extrawindowstyle.Items.Add(TCBS_DROPDOWN)else wsout.Add(TCBS_DROPDOWN);
   if styles and CBS_DROPDOWNLIST = CBS_DROPDOWNLIST then extrawindowstyle.Items.Add(TCBS_DROPDOWNLIST)else wsout.Add(TCBS_DROPDOWNLIST);
   if styles and CBS_HASSTRINGS = CBS_HASSTRINGS then extrawindowstyle.Items.Add(TCBS_HASSTRINGS)else wsout.Add(TCBS_HASSTRINGS);
   if styles and CBS_LOWERCASE = CBS_LOWERCASE then extrawindowstyle.Items.Add(TCBS_LOWERCASE)else wsout.Add(TCBS_LOWERCASE);
   if styles and CBS_NOINTEGRALHEIGHT = CBS_NOINTEGRALHEIGHT then extrawindowstyle.Items.Add(TCBS_NOINTEGRALHEIGHT)else wsout.Add(TCBS_NOINTEGRALHEIGHT);
   if styles and CBS_OEMCONVERT = CBS_OEMCONVERT then extrawindowstyle.Items.Add(TCBS_OEMCONVERT)else wsout.Add(TCBS_OEMCONVERT);
   if styles and CBS_OWNERDRAWFIXED = CBS_OWNERDRAWFIXED then extrawindowstyle.Items.Add(TCBS_OWNERDRAWFIXED)else wsout.Add(TCBS_OWNERDRAWFIXED);
   if styles and CBS_OWNERDRAWVARIABLE = CBS_OWNERDRAWVARIABLE then extrawindowstyle.Items.Add(TCBS_OWNERDRAWVARIABLE)else wsout.Add(TCBS_OWNERDRAWVARIABLE);
   if styles and CBS_SIMPLE = CBS_SIMPLE then extrawindowstyle.Items.Add(TCBS_SIMPLE)else wsout.Add(TCBS_SIMPLE);
   if styles and CBS_SORT = CBS_SORT then extrawindowstyle.Items.Add(TCBS_SORT)else wsout.Add(TCBS_SORT);
   if styles and CBS_UPPERCASE = CBS_UPPERCASE then extrawindowstyle.Items.Add(TCBS_UPPERCASE)else wsout.Add(TCBS_UPPERCASE);

  { if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
}
 end;
 if UpperCase(string( classname))='EDIT' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Edit Styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and  ES_AUTOHSCROLL=ES_AUTOHSCROLL  then extrawindowstyle.Items.Add(TES_AUTOHSCROLL)else wsout.Add(TES_AUTOHSCROLL);
   if styles and  ES_AUTOVSCROLL=ES_AUTOVSCROLL  then extrawindowstyle.Items.Add(TES_AUTOVSCROLL)else wsout.Add(TES_AUTOVSCROLL);
   if styles and  ES_CENTER=ES_CENTER  then extrawindowstyle.Items.Add(TES_CENTER)else wsout.Add(TES_CENTER);
   if styles and  ES_LEFT=ES_LEFT  then extrawindowstyle.Items.Add(TES_LEFT)else wsout.Add(TES_LEFT);
   if styles and  ES_LOWERCASE=ES_LOWERCASE  then extrawindowstyle.Items.Add(TES_LOWERCASE)else wsout.Add(TES_LOWERCASE);
   if styles and ES_MULTILINE = ES_MULTILINE then extrawindowstyle.Items.Add(TES_MULTILINE)else wsout.Add(TES_MULTILINE);
   if styles and  ES_NOHIDESEL=ES_NOHIDESEL  then extrawindowstyle.Items.Add(TES_NOHIDESEL)else wsout.Add(TES_NOHIDESEL);
   if styles and ES_NUMBER =ES_NUMBER  then extrawindowstyle.Items.Add(TES_NUMBER)else wsout.Add(TES_NUMBER);
   if styles and ES_OEMCONVERT =ES_OEMCONVERT  then extrawindowstyle.Items.Add(TES_OEMCONVERT)else wsout.Add(TES_OEMCONVERT);
   if styles and ES_PASSWORD =ES_PASSWORD  then extrawindowstyle.Items.Add(TES_PASSWORD)else wsout.Add(TES_PASSWORD);
   if styles and ES_READONLY = ES_READONLY then extrawindowstyle.Items.Add(TES_READONLY)else wsout.Add(TES_READONLY);
   if styles and ES_RIGHT = ES_RIGHT then extrawindowstyle.Items.Add(TES_RIGHT)else wsout.Add(TES_RIGHT);
   if styles and ES_UPPERCASE =ES_UPPERCASE  then extrawindowstyle.Items.Add(TES_UPPERCASE)else wsout.Add(TES_UPPERCASE);
   if styles and ES_WANTRETURN = ES_WANTRETURN then extrawindowstyle.Items.Add(TES_WANTRETURN)else wsout.Add(TES_WANTRETURN);
 {  if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);

   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
}
 end;
 if UpperCase(string( classname))='LISTBOX' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Listbox Styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and LBS_DISABLENOSCROLL = LBS_DISABLENOSCROLL then extrawindowstyle.Items.Add(TLBS_DISABLENOSCROLL)else wsout.Add(TLBS_DISABLENOSCROLL);
   if styles and LBS_EXTENDEDSEL = LBS_EXTENDEDSEL then extrawindowstyle.Items.Add(TLBS_EXTENDEDSEL)else wsout.Add(TLBS_EXTENDEDSEL);
   if styles and LBS_HASSTRINGS = LBS_HASSTRINGS then extrawindowstyle.Items.Add(TLBS_HASSTRINGS)else wsout.Add(TLBS_HASSTRINGS);
   if styles and LBS_MULTICOLUMN = LBS_MULTICOLUMN then extrawindowstyle.Items.Add(TLBS_MULTICOLUMN)else wsout.Add(TLBS_MULTICOLUMN);
   if styles and LBS_MULTIPLESEL = LBS_MULTIPLESEL then extrawindowstyle.Items.Add(TLBS_MULTIPLESEL)else wsout.Add(TLBS_MULTIPLESEL);
   if styles and LBS_NODATA = LBS_NODATA then extrawindowstyle.Items.Add(TLBS_NODATA)else wsout.Add(TLBS_NODATA);
   if styles and LBS_NOINTEGRALHEIGHT = LBS_NOINTEGRALHEIGHT then extrawindowstyle.Items.Add(TLBS_NOINTEGRALHEIGHT)else wsout.Add(TLBS_NOINTEGRALHEIGHT);
   if styles and LBS_NOREDRAW = LBS_NOREDRAW then extrawindowstyle.Items.Add(TLBS_NOREDRAW)else wsout.Add(TLBS_NOREDRAW);
   if styles and LBS_NOSEL =  LBS_NOSEL  then extrawindowstyle.Items.Add(TLBS_NOSEL)else wsout.Add(TLBS_NOSEL);
   if styles and LBS_NOTIFY = LBS_NOTIFY then extrawindowstyle.Items.Add(TLBS_NOTIFY)else wsout.Add(TLBS_NOTIFY);
   if styles and LBS_OWNERDRAWFIXED = LBS_OWNERDRAWFIXED then extrawindowstyle.Items.Add(TLBS_OWNERDRAWFIXED)else wsout.Add(TLBS_OWNERDRAWFIXED);
   if styles and LBS_OWNERDRAWVARIABLE = LBS_OWNERDRAWVARIABLE then extrawindowstyle.Items.Add(TLBS_OWNERDRAWVARIABLE)else wsout.Add(TLBS_OWNERDRAWVARIABLE);
   if styles and LBS_SORT = LBS_SORT then extrawindowstyle.Items.Add(TLBS_SORT)else wsout.Add(TLBS_SORT);
   if styles and LBS_STANDARD = LBS_STANDARD then extrawindowstyle.Items.Add(TLBS_STANDARD)else wsout.Add(TLBS_STANDARD);
   if styles and LBS_USETABSTOPS = LBS_USETABSTOPS then extrawindowstyle.Items.Add(TLBS_USETABSTOPS)else wsout.Add(TLBS_USETABSTOPS);
   if styles and LBS_WANTKEYBOARDINPUT = LBS_WANTKEYBOARDINPUT then extrawindowstyle.Items.Add(TLBS_WANTKEYBOARDINPUT)else wsout.Add(TLBS_WANTKEYBOARDINPUT);
   {if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);

   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
}
 end;
 if (UpperCase(string( classname))='RICHEDIT') or (UpperCase(string( classname))='RICHEDIT_CLASS') then begin
   extraclass.Visible:=true;
   labeles.Caption:='Richedit Styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and  ES_AUTOHSCROLL=ES_AUTOHSCROLL  then extrawindowstyle.Items.Add(TES_AUTOHSCROLL)else wsout.Add(TES_AUTOHSCROLL);
   if styles and  ES_AUTOVSCROLL=ES_AUTOVSCROLL  then extrawindowstyle.Items.Add(TES_AUTOVSCROLL)else wsout.Add(TES_AUTOVSCROLL);
   if styles and  ES_CENTER=ES_CENTER  then extrawindowstyle.Items.Add(TES_CENTER)else wsout.Add(TES_CENTER);
   if styles and  ES_LEFT=ES_LEFT  then extrawindowstyle.Items.Add(TES_LEFT)else wsout.Add(TES_LEFT);
   if styles and ES_MULTILINE = ES_MULTILINE then extrawindowstyle.Items.Add(TES_MULTILINE)else wsout.Add(TES_MULTILINE);
   if styles and  ES_NOHIDESEL=ES_NOHIDESEL  then extrawindowstyle.Items.Add(TES_NOHIDESEL)else wsout.Add(TES_NOHIDESEL);
   if styles and ES_NUMBER =ES_NUMBER  then extrawindowstyle.Items.Add(TES_NUMBER)else wsout.Add(TES_NUMBER);
   if styles and ES_PASSWORD =ES_PASSWORD  then extrawindowstyle.Items.Add(TES_PASSWORD)else wsout.Add(TES_PASSWORD);
   if styles and ES_READONLY = ES_READONLY then extrawindowstyle.Items.Add(TES_READONLY)else wsout.Add(TES_READONLY);
   if styles and ES_RIGHT = ES_RIGHT then extrawindowstyle.Items.Add(TES_RIGHT)else wsout.Add(TES_RIGHT);
   if styles and ES_WANTRETURN = ES_WANTRETURN then extrawindowstyle.Items.Add(TES_WANTRETURN)else wsout.Add(TES_WANTRETURN);
   if styles and  ES_DISABLENOSCROLL=ES_DISABLENOSCROLL then extrawindowstyle.Items.Add(TES_DISABLENOSCROLL)else wsout.Add(TES_DISABLENOSCROLL);
   if styles and ES_NOIME = ES_NOIME then extrawindowstyle.Items.Add(TES_NOIME)else wsout.Add(TES_NOIME);
   if styles and ES_SELFIME = ES_SELFIME then extrawindowstyle.Items.Add(TES_SELFIME)else wsout.Add(TES_SELFIME);
   if styles and  ES_SUNKEN=ES_SUNKEN  then extrawindowstyle.Items.Add(TES_SUNKEN)else wsout.Add(TES_SUNKEN);
   if styles and ES_VERTICAL = ES_VERTICAL then extrawindowstyle.Items.Add(TES_VERTICAL)else wsout.Add(TES_VERTICAL);
{   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);

   if styles and  =  then extrawindowstyle.Items.Add(T)else wsout.Add(T);
}
 end;
 if UpperCase(string( classname))='SCROLLBAR' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Scrollbar Styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and SBS_BOTTOMALIGN = SBS_BOTTOMALIGN then extrawindowstyle.Items.Add(TSBS_BOTTOMALIGN)else wsout.Add(TSBS_BOTTOMALIGN);
   if styles and SBS_HORZ = SBS_HORZ then extrawindowstyle.Items.Add(TSBS_HORZ)else wsout.Add(TSBS_HORZ);
   if styles and SBS_LEFTALIGN =SBS_LEFTALIGN  then extrawindowstyle.Items.Add(TSBS_LEFTALIGN)else wsout.Add(TSBS_LEFTALIGN);
   if styles and SBS_RIGHTALIGN =SBS_RIGHTALIGN then extrawindowstyle.Items.Add(TSBS_RIGHTALIGN)else wsout.Add(TSBS_RIGHTALIGN);
   if styles and SBS_SIZEBOX =SBS_SIZEBOX  then extrawindowstyle.Items.Add(TSBS_SIZEBOX)else wsout.Add(TSBS_SIZEBOX);
   if styles and SBS_SIZEBOXBOTTOMRIGHTALIGN= SBS_SIZEBOXBOTTOMRIGHTALIGN then extrawindowstyle.Items.Add(TSBS_SIZEBOXBOTTOMRIGHTALIGN)else wsout.Add(TSBS_SIZEBOXBOTTOMRIGHTALIGN);
   if styles and SBS_SIZEBOXTOPLEFTALIGN = SBS_SIZEBOXTOPLEFTALIGN then extrawindowstyle.Items.Add(TSBS_SIZEBOXTOPLEFTALIGN)else wsout.Add(TSBS_SIZEBOXTOPLEFTALIGN);
   if styles and SBS_SIZEGRIP = SBS_SIZEGRIP then extrawindowstyle.Items.Add(TSBS_SIZEGRIP)else wsout.Add(TSBS_SIZEGRIP);
   if styles and SBS_TOPALIGN = SBS_TOPALIGN then extrawindowstyle.Items.Add(TSBS_TOPALIGN)else wsout.Add(TSBS_TOPALIGN);
   if styles and SBS_VERT = SBS_VERT then extrawindowstyle.Items.Add(TSBS_VERT)else wsout.Add(TSBS_VERT);
 end;
 if UpperCase(string( classname))='STATIC' then begin
   extraclass.Visible:=true;
   labeles.Caption:='Static Styles(=Window Styles): '+Cardinal2Str(styles);
   if styles and SS_BITMAP = SS_BITMAP then extrawindowstyle.Items.Add(TSS_BITMAP)else wsout.Add(TSS_BITMAP);
   if styles and SS_BLACKFRAME = SS_BLACKFRAME then extrawindowstyle.Items.Add(TSS_BLACKFRAME)else wsout.Add(TSS_BLACKFRAME);
   if styles and SS_BLACKRECT = SS_BLACKRECT then extrawindowstyle.Items.Add(TSS_BLACKRECT)else wsout.Add(TSS_BLACKRECT);
   if styles and SS_CENTER = SS_CENTER then extrawindowstyle.Items.Add(TSS_CENTER)else wsout.Add(TSS_CENTER);
   if styles and SS_CENTERIMAGE = SS_CENTERIMAGE then extrawindowstyle.Items.Add(TSS_CENTERIMAGE)else wsout.Add(TSS_CENTERIMAGE);
 {TODO: wieder einfügen
   if styles and SS_ENDELLIPSIS  = SS_ENDELLIPSIS  then extrawindowstyle.Items.Add(TSS_ENDELLIPSIS )else wsout.Add(TSS_ENDELLIPSIS );
   if styles and SS_ENHMETAFILE = SS_ENHMETAFILE then extrawindowstyle.Items.Add(TSS_ENHMETAFILE)else wsout.Add(TSS_ENHMETAFILE);
   if styles and SS_ETCHEDFRAME = SS_ETCHEDFRAME then extrawindowstyle.Items.Add(TSS_ETCHEDFRAME)else wsout.Add(TSS_ETCHEDFRAME);
   if styles and SS_ETCHEDHORZ = SS_ETCHEDHORZ then extrawindowstyle.Items.Add(TSS_ETCHEDHORZ)else wsout.Add(TSS_ETCHEDHORZ);
   if styles and SS_ETCHEDVERT = SS_ETCHEDVERT then extrawindowstyle.Items.Add(TSS_ETCHEDVERT)else wsout.Add(TSS_ETCHEDVERT);
   if styles and SS_GRAYFRAME = SS_GRAYFRAME then extrawindowstyle.Items.Add(TSS_GRAYFRAME)else wsout.Add(TSS_GRAYFRAME);
   if styles and SS_GRAYRECT = SS_GRAYRECT then extrawindowstyle.Items.Add(TSS_GRAYRECT)else wsout.Add(TSS_GRAYRECT);
   if styles and SS_ICON = SS_ICON then extrawindowstyle.Items.Add(TSS_ICON)else wsout.Add(TSS_ICON);
   if styles and SS_LEFT = SS_LEFT then extrawindowstyle.Items.Add(TSS_LEFT)else wsout.Add(TSS_LEFT);
   if styles and SS_LEFTNOWORDWRAP = SS_LEFTNOWORDWRAP then extrawindowstyle.Items.Add(TSS_LEFTNOWORDWRAP)else wsout.Add(TSS_LEFTNOWORDWRAP);
   if styles and SS_NOPREFIX = SS_NOPREFIX then extrawindowstyle.Items.Add(TSS_NOPREFIX)else wsout.Add(TSS_NOPREFIX);
   if styles and SS_NOTIFY = SS_NOTIFY then extrawindowstyle.Items.Add(TSS_NOTIFY)else wsout.Add(TSS_NOTIFY);
   if styles and SS_OWNERDRAW = SS_OWNERDRAW then extrawindowstyle.Items.Add(TSS_OWNERDRAW)else wsout.Add(TSS_OWNERDRAW);
   if styles and SS_PATHELLIPSIS = SS_PATHELLIPSIS then extrawindowstyle.Items.Add(TSS_PATHELLIPSIS)else wsout.Add(TSS_PATHELLIPSIS);
//   if styles and SS_REALSIZECONTROL = SS_REALSIZECONTROL then extrawindowstyle.Items.Add(TSS_REALSIZECONTROL)else wsout.Add(TSS_REALSIZECONTROL);
   if styles and SS_REALSIZEIMAGE = SS_REALSIZEIMAGE then extrawindowstyle.Items.Add(TSS_REALSIZEIMAGE)else wsout.Add(TSS_REALSIZEIMAGE);
   if styles and SS_RIGHT = SS_RIGHT then extrawindowstyle.Items.Add(TSS_RIGHT)else wsout.Add(TSS_RIGHT);
   if styles and SS_RIGHTJUST = SS_RIGHTJUST then extrawindowstyle.Items.Add(TSS_RIGHTJUST)else wsout.Add(TSS_RIGHTJUST);
   if styles and SS_SIMPLE = SS_SIMPLE then extrawindowstyle.Items.Add(TSS_SIMPLE)else wsout.Add(TSS_SIMPLE);
   if styles and SS_SUNKEN = SS_SUNKEN then extrawindowstyle.Items.Add(TSS_SUNKEN)else wsout.Add(TSS_SUNKEN);
   if styles and SS_WHITEFRAME = SS_WHITEFRAME then extrawindowstyle.Items.Add(TSS_WHITEFRAME)else wsout.Add(TSS_WHITEFRAME);
   if styles and SS_WHITERECT = SS_WHITERECT then extrawindowstyle.Items.Add(TSS_WHITERECT)else wsout.Add(TSS_WHITERECT);
   if styles and SS_WORDELLIPSIS = SS_WORDELLIPSIS then extrawindowstyle.Items.Add(TSS_WORDELLIPSIS)else wsout.Add(TSS_WORDELLIPSIS);
   }
 end;
 if extraclass.Visible then begin
   for i:=0 to extrawindowstyle.Items.Count-1 do
     extrawindowstyle.Checked[i]:=true;
   extrawindowstyle.Items.AddStrings(wsout);
   wsout.Clear;
 end;
 //WS_EX_STYLES:
 styles:=GetWindowLong(han,GWL_EXSTYLE);
 labelwsex.Caption:='Extended Window styles:   '+Cardinal2Str(styles);
 if styles and  WS_EX_ACCEPTFILES=WS_EX_ACCEPTFILES  then windowexstyles.Items.Add(TWS_EX_ACCEPTFILES) else wsout.Add(TWS_EX_ACCEPTFILES);
 if styles and  WS_EX_APPWINDOW=WS_EX_APPWINDOW  then windowexstyles.Items.Add(TWS_EX_APPWINDOW) else wsout.Add(TWS_EX_APPWINDOW);
 if styles and  WS_EX_CLIENTEDGE=WS_EX_CLIENTEDGE  then windowexstyles.Items.Add(TWS_EX_CLIENTEDGE) else wsout.Add(TWS_EX_CLIENTEDGE);
 if styles and  WS_EX_COMPOSITED=WS_EX_COMPOSITED   then windowexstyles.Items.Add(TWS_EX_COMPOSITED ) else wsout.Add(TWS_EX_COMPOSITED );
 if styles and  WS_EX_CONTEXTHELP=WS_EX_CONTEXTHELP  then windowexstyles.Items.Add(TWS_EX_CONTEXTHELP) else wsout.Add(TWS_EX_CONTEXTHELP);
 if styles and  WS_EX_CONTROLPARENT=WS_EX_CONTROLPARENT  then windowexstyles.Items.Add(TWS_EX_CONTROLPARENT) else wsout.Add(TWS_EX_CONTROLPARENT);
 if styles and  WS_EX_DLGMODALFRAME=WS_EX_DLGMODALFRAME  then windowexstyles.Items.Add(TWS_EX_DLGMODALFRAME) else wsout.Add(TWS_EX_DLGMODALFRAME);
 if styles and  WS_EX_LAYERED=WS_EX_LAYERED  then windowexstyles.Items.Add(TWS_EX_LAYERED) else wsout.Add(TWS_EX_LAYERED);
 if styles and  WS_EX_LAYOUTRTL=WS_EX_LAYOUTRTL  then windowexstyles.Items.Add(TWS_EX_LAYOUTRTL) else wsout.Add(TWS_EX_LAYOUTRTL);
 if styles and  WS_EX_LEFT=WS_EX_LEFT  then windowexstyles.Items.Add(TWS_EX_LEFT) else wsout.Add(TWS_EX_LEFT);
 if styles and  WS_EX_LEFTSCROLLBAR=WS_EX_LEFTSCROLLBAR  then windowexstyles.Items.Add(TWS_EX_LEFTSCROLLBAR) else wsout.Add(TWS_EX_LEFTSCROLLBAR);
 if styles and  WS_EX_LTRREADING=WS_EX_LTRREADING  then windowexstyles.Items.Add(TWS_EX_LTRREADING) else wsout.Add(TWS_EX_LTRREADING);
 if styles and  WS_EX_MDICHILD=WS_EX_MDICHILD  then windowexstyles.Items.Add(TWS_EX_MDICHILD) else wsout.Add(TWS_EX_MDICHILD);
// if styles and  WS_EX_MDICHILD=WS_EX_MDICHILD  then windowexstyles.Items.Add(TWS_EX_MDICHILD) else wsout.Add(TWS_EX_MDICHILD);
 if styles and  WS_EX_NOACTIVATE=WS_EX_NOACTIVATE  then windowexstyles.Items.Add(TWS_EX_NOACTIVATE) else wsout.Add(TWS_EX_NOACTIVATE);
 if styles and  WS_EX_NOINHERITLAYOUT=WS_EX_NOINHERITLAYOUT  then windowexstyles.Items.Add(TWS_EX_NOINHERITLAYOUT) else wsout.Add(TWS_EX_NOINHERITLAYOUT);
 if styles and  WS_EX_NOPARENTNOTIFY=WS_EX_NOPARENTNOTIFY  then windowexstyles.Items.Add(TWS_EX_NOPARENTNOTIFY) else wsout.Add(TWS_EX_NOPARENTNOTIFY);
 if styles and  WS_EX_OVERLAPPEDWINDOW=WS_EX_OVERLAPPEDWINDOW  then windowexstyles.Items.Add(TWS_EX_OVERLAPPEDWINDOW) else wsout.Add(TWS_EX_OVERLAPPEDWINDOW);
 if styles and  WS_EX_PALETTEWINDOW=WS_EX_PALETTEWINDOW  then windowexstyles.Items.Add(TWS_EX_PALETTEWINDOW) else wsout.Add(TWS_EX_PALETTEWINDOW);
 if styles and  WS_EX_RIGHT=WS_EX_RIGHT  then windowexstyles.Items.Add(TWS_EX_RIGHT) else wsout.Add(TWS_EX_RIGHT);
 if styles and  WS_EX_RIGHTSCROLLBAR=WS_EX_RIGHTSCROLLBAR  then windowexstyles.Items.Add(TWS_EX_RIGHTSCROLLBAR) else wsout.Add(TWS_EX_RIGHTSCROLLBAR);
 if styles and  WS_EX_RTLREADING=WS_EX_RTLREADING  then windowexstyles.Items.Add(TWS_EX_RTLREADING) else wsout.Add(TWS_EX_RTLREADING);
 if styles and  WS_EX_STATICEDGE=WS_EX_STATICEDGE  then windowexstyles.Items.Add(TWS_EX_STATICEDGE) else wsout.Add(TWS_EX_STATICEDGE);
 if styles and  WS_EX_TOOLWINDOW=WS_EX_TOOLWINDOW  then windowexstyles.Items.Add(TWS_EX_TOOLWINDOW) else wsout.Add(TWS_EX_TOOLWINDOW);
 if styles and  WS_EX_TOPMOST=WS_EX_TOPMOST  then windowexstyles.Items.Add(TWS_EX_TOPMOST) else wsout.Add(TWS_EX_TOPMOST);
 if styles and  WS_EX_TRANSPARENT=WS_EX_TRANSPARENT  then windowexstyles.Items.Add(TWS_EX_TRANSPARENT) else wsout.Add(TWS_EX_TRANSPARENT);
 if styles and  WS_EX_WINDOWEDGE=WS_EX_WINDOWEDGE  then windowexstyles.Items.Add(TWS_EX_WINDOWEDGE) else wsout.Add(TWS_EX_WINDOWEDGE);
 for i:=0 to windowexstyles.Items.Count-1 do
   windowexstyles.Checked[i]:=true;
 windowexstyles.Items.AddStrings(wsout);

 wsout.Clear;
 styles:=GetClassLong(han,GCL_STYLE);
 labelcs.Caption:='Window Class styles:   '+Cardinal2Str(styles);
 if styles and CS_BYTEALIGNCLIENT =CS_BYTEALIGNCLIENT then classstyles.Items.Add(TCS_BYTEALIGNCLIENT) else wsout.Add(TCS_BYTEALIGNCLIENT) ;
 if styles and CS_BYTEALIGNWINDOW =CS_BYTEALIGNWINDOW then classstyles.Items.Add(TCS_BYTEALIGNWINDOW)else wsout.Add(TCS_BYTEALIGNWINDOW);
 if styles and CS_CLASSDC =CS_CLASSDC then classstyles.Items.Add(TCS_CLASSDC) else wsout.Add(TCS_CLASSDC) ;
 if styles and CS_DBLCLKS =CS_DBLCLKS then classstyles.Items.Add(TCS_DBLCLKS) else wsout.Add(TCS_DBLCLKS) ;
 if styles and CS_DROPSHADOW =CS_DROPSHADOW then classstyles.Items.Add(TCS_DROPSHADOW) else wsout.Add(TCS_DROPSHADOW) ;
 if styles and CS_GLOBALCLASS =CS_GLOBALCLASS then classstyles.Items.Add(TCS_GLOBALCLASS)else wsout.Add(TCS_GLOBALCLASS);
 if styles and CS_HREDRAW =CS_HREDRAW then classstyles.Items.Add(TCS_HREDRAW) else wsout.Add(TCS_HREDRAW) ;
 if styles and CS_NOCLOSE =CS_NOCLOSE then classstyles.Items.Add(TCS_NOCLOSE) else wsout.Add(TCS_NOCLOSE) ;
 if styles and CS_OWNDC =CS_OWNDC then classstyles.Items.Add(TCS_OWNDC) else wsout.Add(TCS_OWNDC) ;
 if styles and CS_PARENTDC =CS_PARENTDC then classstyles.Items.Add(TCS_PARENTDC) else wsout.Add(TCS_PARENTDC) ;
 if styles and CS_SAVEBITS =CS_SAVEBITS then classstyles.Items.Add(TCS_SAVEBITS)else wsout.Add(TCS_SAVEBITS);
 if styles and CS_VREDRAW =CS_VREDRAW then classstyles.Items.Add(TCS_VREDRAW) else wsout.Add(TCS_VREDRAW);
 for i:=0 to classstyles.Items.Count-1 do
   classstyles.Checked[i]:=true;
 classstyles.Items.AddStrings(wsout);
 wsout.free;

 windowexstyles.Perform(LB_SETHORIZONTALEXTENT,windowexstyles.Canvas.TextWidth(TWS_EX_PALETTEWINDOW)+30,0);
 windowstyles.Perform(LB_SETHORIZONTALEXTENT,windowstyles.Canvas.TextWidth(TWS_OVERLAPPEDWINDOW)+30,0);
end;

procedure Twindowstyleform.Button1Click(Sender: TObject);
begin
ModalResult:=mrOk;
Close;
end;

procedure Twindowstyleform.windowstylesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var sender:TCheckListBox;
begin
sender:=(control as TCheckListBox);
sender.Canvas.brush.Color:=clBlack;
if not (odFocused in State) then begin
  sender.Canvas.pen.Color:=clBlack;
end else begin
  sender.Canvas.pen.Color:=clBlack;
end;
sender.Canvas.Rectangle(rect.left,rect.top,Rect.Right,rect.Bottom);
if sender.Checked[index] then begin
  sender.Canvas.Font.Color:=clLime;
end else begin
  sender.Canvas.Font.Color:=clRed;
end;
sender.Canvas.TextOut(rect.Left,rect.top,sender.Items[index]);
//exit;
end;

procedure Twindowstyleform.windowstylesClickCheck(Sender: TObject);
var i:integer;
    style:Cardinal;
begin
  style:=0;
  for i:=0 to windowstyles.Items.Count-1 do begin
    if windowstyles.Checked[i] then begin
      if windowstyles.Items[i]=TWS_BORDER then style:=style or WS_BORDER else
      if windowstyles.Items[i]=TWS_CAPTION then style:=style or WS_CAPTION else
      if windowstyles.Items[i]=TWS_CHILD then style:=style or WS_CHILD else
      if windowstyles.Items[i]=TWS_CHILDWINDOW then style:=style or WS_CHILDWINDOW else
      if windowstyles.Items[i]=TWS_CLIPCHILDREN then style:=style or WS_CLIPCHILDREN else
      if windowstyles.Items[i]=TWS_CLIPSIBLINGS then style:=style or WS_CLIPSIBLINGS else
      if windowstyles.Items[i]=TWS_DISABLED then style:=style or WS_DISABLED else
      if windowstyles.Items[i]=TWS_DLGFRAME then style:=style or WS_DLGFRAME else
      if windowstyles.Items[i]=TWS_GROUP then style:=style or WS_GROUP else
      if windowstyles.Items[i]=TWS_HSCROLL then style:=style or WS_HSCROLL else
      if windowstyles.Items[i]=TWS_ICONIC then style:=style or WS_ICONIC else
      if windowstyles.Items[i]=TWS_MAXIMIZE then style:=style or WS_MAXIMIZE else
      if windowstyles.Items[i]=TWS_MAXIMIZEBOX then style:=style or WS_MAXIMIZEBOX else
      if windowstyles.Items[i]=TWS_MINIMIZE then style:=style or WS_MINIMIZE else
      if windowstyles.Items[i]=TWS_MINIMIZEBOX then style:=style or WS_MINIMIZEBOX else
      if windowstyles.Items[i]=TWS_OVERLAPPED then style:=style or WS_OVERLAPPED else
      if windowstyles.Items[i]=TWS_OVERLAPPEDWINDOW then style:=style or WS_OVERLAPPEDWINDOW else
      if windowstyles.Items[i]=TWS_POPUP then style:=style or WS_POPUP else
      if windowstyles.Items[i]=TWS_POPUPWINDOW then style:=style or WS_POPUPWINDOW else
      if windowstyles.Items[i]=TWS_SIZEBOX then style:=style or WS_SIZEBOX else
      if windowstyles.Items[i]=TWS_SYSMENU then style:=style or WS_SYSMENU else
      if windowstyles.Items[i]=TWS_TABSTOP then style:=style or WS_TABSTOP else
      if windowstyles.Items[i]=TWS_THICKFRAME then style:=style or WS_THICKFRAME else
      if windowstyles.Items[i]=TWS_TILED then style:=style or WS_TILED else
      if windowstyles.Items[i]=TWS_TILEDWINDOW then style:=style or WS_TILEDWINDOW else
      if windowstyles.Items[i]=TWS_VISIBLE then style:=style or WS_VISIBLE else
      if windowstyles.Items[i]=TWS_VSCROLL then style:=style or WS_VSCROLL;
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
    InstallHookNewStyle(han,style,false);
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
var i:integer;
    style:Cardinal;
begin
//  if not runonNT then exit;
  style:=0;
  for i:=0 to windowexstyles.Items.Count-1 do begin
    if windowexstyles.Checked[i] then begin
      if windowexstyles.Items[i]=TWS_EX_ACCEPTFILES then style:=style or WS_EX_ACCEPTFILES else
      if windowexstyles.Items[i]=TWS_EX_APPWINDOW then style:=style or WS_EX_APPWINDOW else
      if windowexstyles.Items[i]=TWS_EX_CLIENTEDGE then style:=style or WS_EX_CLIENTEDGE else
      if windowexstyles.Items[i]=TWS_EX_COMPOSITED  then style:=style or WS_EX_COMPOSITED  else
      if windowexstyles.Items[i]=TWS_EX_CONTEXTHELP then style:=style or WS_EX_CONTEXTHELP else
      if windowexstyles.Items[i]=TWS_EX_CONTROLPARENT then style:=style or WS_EX_CONTROLPARENT else
      if windowexstyles.Items[i]=TWS_EX_DLGMODALFRAME then style:=style or WS_EX_DLGMODALFRAME else
      if windowexstyles.Items[i]=TWS_EX_LAYERED then style:=style or WS_EX_LAYERED else
      if windowexstyles.Items[i]=TWS_EX_LAYOUTRTL then style:=style or WS_EX_LAYOUTRTL else
      if windowexstyles.Items[i]=TWS_EX_LEFT then style:=style or WS_EX_LEFT else
      if windowexstyles.Items[i]=TWS_EX_LEFTSCROLLBAR then style:=style or WS_EX_LEFTSCROLLBAR else
      if windowexstyles.Items[i]=TWS_EX_LTRREADING then style:=style or WS_EX_LTRREADING else
      if windowexstyles.Items[i]=TWS_EX_MDICHILD then style:=style or WS_EX_MDICHILD else
      if windowexstyles.Items[i]=TWS_EX_NOACTIVATE then style:=style or WS_EX_NOACTIVATE else
      if windowexstyles.Items[i]=TWS_EX_NOINHERITLAYOUT then style:=style or WS_EX_NOINHERITLAYOUT else
      if windowexstyles.Items[i]=TWS_EX_NOPARENTNOTIFY then style:=style or WS_EX_NOPARENTNOTIFY else
      if windowexstyles.Items[i]=TWS_EX_OVERLAPPEDWINDOW then style:=style or WS_EX_OVERLAPPEDWINDOW else
      if windowexstyles.Items[i]=TWS_EX_PALETTEWINDOW then style:=style or WS_EX_PALETTEWINDOW else
      if windowexstyles.Items[i]=TWS_EX_RIGHT then style:=style or WS_EX_RIGHT else
      if windowexstyles.Items[i]=TWS_EX_RIGHTSCROLLBAR then style:=style or WS_EX_RIGHTSCROLLBAR else
      if windowexstyles.Items[i]=TWS_EX_RTLREADING then style:=style or WS_EX_RTLREADING else
      if windowexstyles.Items[i]=TWS_EX_STATICEDGE then style:=style or WS_EX_STATICEDGE else
      if windowexstyles.Items[i]=TWS_EX_TOOLWINDOW then style:=style or WS_EX_TOOLWINDOW else
      if windowexstyles.Items[i]=TWS_EX_TOPMOST then style:=style or WS_EX_TOPMOST else
      if windowexstyles.Items[i]=TWS_EX_TRANSPARENT then style:=style or WS_EX_TRANSPARENT else
      if windowexstyles.Items[i]=TWS_EX_WINDOWEDGE then style:=style or WS_EX_WINDOWEDGE else
    end;
  end;
  if (CheckBox1.Checked)  then  begin
    InstallHookNewStyle(han,style,true);
  end else begin
    SetWindowLong(han,GWL_EXSTYLE,style);
  end;
  if windows.getParent(han)=0 then
    RedrawWindow(han,nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE)
   else
    RedrawWindow(windows.getParent(han),nil,0,RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_ERASENOW or RDW_ERASE);
  windowexstyles.Refresh;

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

end.
