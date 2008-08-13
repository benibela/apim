{History:
  - 2008:
    Weiterentwicklung, Wechsel von Delphi -> Lazarus
    Umbenennung von APIV (API Verwalter??) in API Manager
    (wegen Namenskonflikt einem anderen APIV von 2000)
  - Ende 2002:
    Fertigstellung der Version 2
  - 2001:
    Erste Veröffentlichung von APIV (entweder Version 1 oder 2)
}

unit Unit1;

interface
{$mode delphi}{$h+}
uses
  LResources, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,  ComCtrls,registry,
  windowfuncs, Spin,sysutils,Menus,FileUtil,
  CheckLst,TreeListView,windowcontrolfuncs;

type

  { TmainForm }

  TmainForm = class(TForm)
    alphatrans_cb: TCheckBox;
    Button1: TButton;
    callAPI: TButton;
    callAPIDLL: TEdit;
    callAPIProc: TEdit;
    callAPIParameter: TEdit;
    Label14: TLabel;
    Label16: TLabel;
    callAPIResult_lbl: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    systemProperties: TListView;
    windowsListFilterThread: TEdit;
    Label12: TLabel;
    windowProcessIDedt: TEdit;
    windowThreadIdEdt: TEdit;
    showHandle: TButton;
    Label38: TLabel;
    posRBEdt: TEdit;
    sizeEdt: TEdit;
    Label37: TLabel;
    ownerWnd_edt: TEdit;
    hideAPIVwhenSearching: TCheckBox;
    Label35: TLabel;
    Label36: TLabel;
    windowStyles_lb: TLabel;
    windowExStyles_lb: TLabel;
    windowStyles: TCheckListBox;
    windowListFilterParentUp: TButton;
    windowsListfilterDirectChilds: TCheckBox;
    colorkey_cb: TCheckBox;
    userdata_edt: TEdit;
    windowExStyles: TCheckListBox;
    wndproc_edt: TEdit;
    Label33: TLabel;
    Label34: TLabel;
    windowListFilterParent_edt: TEdit;
    windowListFilterProgram_edt: TEdit;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    optwinconst_Edt: TEdit;
    Label29: TLabel;
    messagemes_cb: TComboBox;
    Label22: TLabel;
    Label25: TLabel;
    lablparam: TLabel;
    labwparam: TLabel;
    messagelparam_edt: TEdit;
    messagewparam_edt: TEdit;
    Panel2: TPanel;
    windowPropChange: TMenuItem;
    windowPropRemoveItem: TMenuItem;
    windowAddProperty: TMenuItem;
    windowPropertyListPopup: TPopupMenu;
    windowPropertyList: TListView;
    mouseRefreshAllLive: TCheckBox;
    linksoben: TPanel;
    miniScreen: TPanel;
    mouseToolImage: TImage;
    Label1: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    mouseHandleEdt: TEdit;
    Label26: TLabel;
    mouseWindowTextEdt: TEdit;
    mouseWindowClassEdt: TEdit;
    mouseWindowProgramEdt: TEdit;
    mouseWindowFamily: TListView;
    PageControl2: TPageControl;
    PaintBox1: TPaintBox;
    parentWndCmb: TComboBox;
    posLTEdt: TEdit;
    Label2: TLabel;
    Label24: TLabel;
    rechtsunten: TPanel;
    alphatrans_sp: TSpinEdit;
    colorKeyShape: TShape;
    stayOnTopCb: TCheckBox;
    classNameEdt: TEdit;
    handleEdt: TEdit;
    Label23: TLabel;
    TabSheet6: TTabSheet;
    windowListTabSheet: TTabSheet;
    findTimer: TTimer;
    Label7: TLabel;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    processTabSheet: TTabSheet;
    Panel5: TPanel;
    displayProcesses: TButton;
    TabSheet2: TTabSheet;
    Button26: TButton;
    TabSheet5: TTabSheet;
    CheckBox3: TCheckBox;
    Edit14: TEdit;
    Label21: TLabel;
    ImageList1: TImageList;
    windowPropertySheet: TScrollBox;
    Label8: TLabel;
    enabledCb: TCheckBox;
    visibleCb: TCheckBox;
    unicodeCb: TCheckBox;
    showStateCmb: TComboBox;
    messageSend_btn: TButton;
    windowtextEdt: TEdit;
    Splitter2: TSplitter;
    Label9: TLabel;
    Label10: TLabel;
    ComboBox2: TComboBox;
    Label11: TLabel;
    processidedit: TEdit;
    checkhex: TCheckBox;
    Label13: TLabel;
    labclassname: TLabel;
    Label15: TLabel;
    Button5: TButton;
    ColorDialog1: TColorDialog;
//    ss1: Tss;
    procedure Button1Click(Sender: TObject);
    procedure callAPIClick(Sender: TObject);
    procedure enabledCbChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure messagemes_cbKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ownerWnd_edtDblClick(Sender: TObject);
    procedure parentWndCmbDblClick(Sender: TObject);
    procedure posLTEdtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure processTabSheetResize(Sender: TObject);
    procedure showHandleClick(Sender: TObject);
    procedure processTabSheetShow(Sender: TObject);
    procedure systemPropertiesAdvancedCustomDrawSubItem(
      Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean
      );
    procedure TabSheet2Show(Sender: TObject);
    procedure windowListDblClick(Sender: TObject);
    procedure windowListFilterParentUpClick(Sender: TObject);
    procedure windowListFilterParent_edtChange(Sender: TObject);
    procedure windowProcessIDedtDblClick(Sender: TObject);
    procedure windowPropChangeClick(Sender: TObject);
    procedure windowPropertySheetClick(Sender: TObject);
    procedure windowsListfilterDirectChildsChange(Sender: TObject);
    procedure colorKeyShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure windowListFilterProgram_edtKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure windowConstOpenEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure linksobenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ComboBox2Change(Sender: TObject);
    procedure processideditChange(Sender: TObject);
    procedure checkhexClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label14Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure updatePropertyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure Button19Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure displayProcessesClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure findTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure messageSend_btnClick(Sender: TObject);       //
    procedure mouseToolImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mouseToolImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure parentwndEdtDblClick(Sender: TObject);
    procedure windowListTabSheetShow(Sender: TObject);
    procedure windowAddPropertyClick(Sender: TObject);
    procedure windowListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure windowListSelectItem(Sender: TObject; Item: TTreeListItem);
    procedure windowPropertyChanged1(Sender: TObject);
    procedure windowPropertyListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure windowPropertyListDeletion(Sender: TObject; Item: TListItem);
    procedure windowPropRemoveItemClick(Sender: TObject);
    procedure windowStylesClickCheck(Sender: TObject);
    procedure windowStylesItemClick(Sender: TObject; Index: integer);
    procedure windowtextEdtChange(Sender: TObject);
    procedure windowTreeListExpandItem(sender: TObject; item: TTreeListItem);
  private
    { Private-Deklarationen}
    procedure WM_HELP(var message:TMessage);message WM_HELP;
    procedure WM_SYSCOMMAND(var message:TMessage);message WM_SYSCOMMAND;
    
    

    //mouseToolActive: boolean;
    currentMouseWindow:HWND;
    
    currentWindow:HWND;
    displayCalls: longint;
    niceVisible: boolean;
    procedure niceSetVisible(vis: boolean; needMouseEvents: boolean);
    
    procedure displayProperty(prop:TObject);
    procedure changeProperty(prop:TObject);

    //Fensterliste
    windowTreeList: TTreeListView;
    procedure displayWindows(itemExtend:TTreeListItem=nil);

    procedure openWindowsConst;
    
    
    //Processliste
    processTreeList: TTreeListView;


    //System/Sonstiges
    procedure displaySysProperties();
  public
    { Public-Deklarationen}
//    procedure MessageHandler;
  end;

var
  edi:TEdit;
  mainForm: TmainForm;

  status:integer=0;
  helpon:boolean=false;

implementation
uses TLHelp32,proc9, wstyles, help, bbutils, win32proc, applicationConfig,winConstWindow;
const
  crScanner:integer=101;

{$R cursor.res}




function getWindowClassNameToDisplay(wnd:hwnd):string;
begin
  Result:=GetWindowClassNameS(wnd)+' ('+Cardinal2Str(GetClassLong(wnd,GCW_ATOM))+')';
end;
function GetFileNameFromHandleToDisplay(wnd:hwnd):string;
var pid:dword;
begin
  GetWindowThreadProcessId(wnd,@pid);
  Result:=GetFileNameFromHandle(wnd)+' ('+Cardinal2Str(pid)+')';
end;


procedure TmainForm.WM_HELP(var message:TMessage);
var helpinfo:tHELPINFO;
    comp,ocomp,tcomp:TWinControl;
    i:integer;
begin

  helpon:=false;
  helpinfo:=tHELPINFO(pointer(message.LParam)^);
  comp:=mainForm;ocomp:=nil;
  while (comp<>ocomp) do begin
    if ocomp<>nil then
      helpinfo.MousePos:=comp.ScreenToClient(ocomp.ClientToScreen( helpinfo.MousePos))
     else
      helpinfo.MousePos:=comp.ScreenToClient(helpinfo.MousePos);
    ocomp:=comp;
    for i:=comp.ControlCount-1 downto 0 do begin
      if not (comp.Controls[i] is TWinControl) then continue;
      tcomp:=comp.Controls[i] as TWinControl;
      if (tcomp.left<helpinfo.MousePos.x) and
            (tcomp.Top<helpinfo.MousePos.y) and
                 (tcomp.left+tcomp.Width>helpinfo.MousePos.x) and
                     (tcomp.Top+tcomp.Height>helpinfo.MousePos.y) then begin
                       comp:=tcomp;
                       break;
                     end;

    end;

//    comp:=comp.ControlAtPos(helpinfo.MousePos,true) as TWinControl;
  end;
  if (comp<>nil) and (comp.hint<>'') then
    ShowMessage(comp.hint)
   else
    ShowMessage('Keine Hilfe verfügbar');
  inherited;
end;
procedure TmainForm.WM_SYSCOMMAND(var message:TMessage);
begin
  if message.WParam=SC_CONTEXTHELP then begin
    if helpon then begin
      helpform.ShowModal;
      helpon:=false;
      exit;
    end;
    helpon:=true;
  end;
  inherited;
end;

procedure TmainForm.niceSetVisible(vis: boolean; needMouseEvents: boolean);
var i:longint;
begin
  if niceVisible=vis then exit;
  niceVisible:=vis;
  if runonNT then begin;
    if vis then begin
      for i:=7 to 25 do begin
        windowfuncs.SetLayeredWindowAttributes(handle,0,10*i+5,LWA_ALPHA);
        Application.ProcessMessages;
      end;
      windowfuncs.SetLayeredWindowAttributes(handle,0,0,0);
      if (PageControl2.ActivePage=windowListTabSheet) or
         (PageControl1.ActivePage=processTabSheet) then //TreeList doesn't like layered windows
        SetWindowLong(handle, GWL_EXSTYLE, GetWindowLong(handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
    end else begin
      SetWindowLong(handle, GWL_EXSTYLE, GetWindowLong(handle, GWL_EXSTYLE) or WS_EX_LAYERED);
      Application.ProcessMessages;
      for i:=25 downto 7 do begin
        windowfuncs.SetLayeredWindowAttributes(handle,0,10*i,LWA_ALPHA);
        Application.ProcessMessages;
        if niceVisible then exit;
      end;
    end;
  end else begin
    if needMouseEvents then exit;
    visible:=vis;
  end;
end;

function WindowPropertyEnumProc(wnd:HWND;  name:LPTSTR;  hData:HANDLE;  listView: TListView):boolean;stdcall;
var nameStr: array[0..255] of char;
begin
  with listView.Items.add do begin
    if dword(name) and $FFFF0000 =0 then
      if GlobalGetAtomName(Atom(name),@nameStr[0],255) <> 0 then
        name:=@nameStr[0];
    caption:=string(name);
    subitems.add(Cardinal2Str(hdata));
    subitems.add(caption); //need old name when renaming
  end;
  result:=true;
end;


procedure TmainForm.displayProperty(prop: TObject);
var propEdt:TEdit;
    rect:TRect;
    tempHandle: THandle;
    parent: hwnd;
    s:string;
    color:COLORREF;
    i,flags:longint;
    alpha:byte;
begin
  displayCalls+=1;
  try
  if prop=handleEdt then handleEdt.Text:=Cardinal2Str(currentWindow)
  else if prop=parentWndCmb then begin
    parent:=GetParent(currentWindow);
    parentWndCmb.Clear;
    parentWndCmb.Text:=Cardinal2Str(parent);
    while parent<>0 do begin
      s:=GetWindowTextS(parent);
      if s<>'' then parentWndCmb.Items.Add(Cardinal2Str(parent) + ' - '+s)
      else parentWndCmb.Items.Add(Cardinal2Str(parent));
      parent:=GetParent(parent);
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
    windows.ScreenToClient(getParent(currentWindow),rect.TopLeft);
    windows.ScreenToClient(getParent(currentWindow),rect.BottomRight);
    posLTEdt.Text:='('+IntToStr(rect.left) + ', '+IntToStr(rect.top)+')';
    posRBEdt.Text:='('+IntToStr(rect.Right) + ', '+IntToStr(rect.Bottom)+')';
    sizeEdt.Text:=IntToStr(rect.Right-rect.Left) + 'x'+IntToStr(rect.Bottom-rect.Top);
  end else if (prop=alphatrans_cb) or (prop=alphatrans_sp) or
          (prop=colorkey_cb) or (prop=colorKeyShape)  then begin
    if runonNT and GetWindowAlphaColorKey(currentWindow,color,alpha,flags) then begin
      alphatrans_cb.Caption:='Transparent:';
      colorkey_cb.Caption:='ColorKey:';
      alphatrans_cb.Checked:=flags and lwa_alpha = lwa_alpha;
      colorkey_cb.Checked:=flags and lwa_colorkey= lwa_colorkey;
      if alphatrans_cb.Checked then
        alphatrans_sp.Value:=alpha;//trunc(100-(alpha * 100) / 255);
      if colorkey_cb.Checked then
        colorKeyShape.Brush.Color:=color;
    end else begin
      alphatrans_cb.Caption:='Transparent??';
      colorkey_cb.Caption:='ColorKey??';
    end;
  end else if prop=windowPropertyList then begin
    windowPropertyList.Clear;
    EnumPropsEx(currentWindow,@WindowPropertyEnumProc,lparam(windowPropertyList));
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
  else if prop=windowStyles then windowStylesToCheckListBox(currentWindow,windowStyles,windowStyles_lb)
  else if prop=windowExStyles then windowExStylesToCheckListBox(currentWindow,windowExStyles,windowExStyles_lb)
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

procedure TmainForm.changeProperty(prop: TObject);
var i,flags:longint;
    s,sf:string;
    rec: trect;
begin
  if displayCalls>0 then exit;
  if prop=handleEdt then begin
    //Alle Werte aktualisieren
    currentWindow:=Str2Cardinal(handleEdt.Text);
    for i:=0 to  windowPropertySheet.ControlCount-1 do
      if windowPropertySheet.Controls[i].Tag=1 then
//      if Controls[i].Parent=windowPropertySheet then
        displayProperty(windowPropertySheet.Controls[i]);

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
    if pos(' - ',s)>0 then s:=splitGet(' - ',s);
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
    rec.Left:=StrToInt(splitGet(',',s));
    rec.top:=StrToInt(splitGet(')',s));
    SetWindowPos(currentWindow,0,rec.Left,rec.top,0,0,SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE);
    RedrawWindow(currentWindow,nil,0,RDW_ERASE or RDW_INVALIDATE);
  end else if prop=posRBEdt then begin
    s:=StringReplace(posLTEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Left:=StrToInt(splitGet(',',s));
    rec.top:=StrToInt(splitGet(')',s));
    s:=StringReplace(posRBEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Right:=StrToInt(splitGet(',',s));
    rec.Bottom:=StrToInt(splitGet(')',s));
    SetWindowPos(currentWindow,0,0,0,rec.Right-Rec.Left,rec.Bottom-Rec.Top,SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOMOVE)
  end else if prop=sizeEdt then begin
    s:=StringReplace(sizeEdt.text,' ','',[rfReplaceAll]);
    rec.Right:=StrToInt(splitGet('x',s));
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
      if flags <> 0 then  windowfuncs.SetLayeredWindowAttributes(currentWindow,colorKeyShape.Brush.Color,alphatrans_sp.Value,flags)
      else SetWindowLong(currentWindow,GWL_EXSTYLE,GetWindowLong(currentWindow,GWL_EXSTYLE) and not WS_EX_LAYERED);
    {end else if flags and WS_EX_LAYERED = WS_EX_LAYERED then
        SetWindowLong(currentWindow,GWL_EXSTYLE,flags and not WS_EX_LAYERED);}
  end else if prop=userdata_edt then SetWindowLong(currentWindow,GWL_USERDATA,Str2Cardinal(userdata_edt.Text));



  ;
  displayProperty(prop);
end;

procedure TmainForm.displayWindows(itemExtend:TTreeListItem);
var i,j:longint;
    wnd,parentWnd:hwnd;
    parentItem: TTreeListItem;
    list:TIntArray;
    s,programS:string;
    filterParentWnd: thandle;
    filterProgram: string;
begin
  filterProgram:=lowercase(windowListFilterProgram_edt.Text);
  if itemExtend <> nil then filterParentWnd:=Str2Cardinal(itemExtend.Text)
  else if windowListFilterParent_edt.text<>'' then filterParentWnd:=Str2Cardinal(windowListFilterParent_edt.text)
  else filterParentWnd:=0;
  list:=EnumWindowsToIntList(filterParentWnd,not windowsListfilterDirectChilds.Checked);
  windowTreeList.BeginUpdate;
  if itemExtend=nil then windowTreeList.Items.Clear
  else itemExtend.SubItems.Clear;
  for i:=0 to high(list) do begin
    wnd:=list[i];
    programS:=GetFileNameFromHandleToDisplay(wnd);
    if (filterProgram<>'') and (pos(filterProgram,LowerCase(programS))<=0) then continue;
    parentWnd:=GetParent(wnd);
    parentItem:=nil;
    if (parentWnd<>0) and (filterParentWnd <> 0) then
      parentItem:=windowTreeList.Items.FindItemWithText(Cardinal2Str(parentWnd));
    with windowTreeList.Items.Add(parentItem) do begin
      if (filterParentWnd = 0) then
        if GetWindow(wnd,GW_CHILD)<>0 then begin
          SubItems.Add('Dummy'); //will be expanded later
          Expanded:=false;
        end;

      Text:=Cardinal2Str(wnd);
{      if filterParentWnd <> 0 then begin
        nextParent:=getparent(wnd);
        while nextParent<>filterParentWnd do begin
          nextParent:=getparent(nextParent);
          Caption:='  '+Caption;
        end;
      end;}
      
      RecordItems.Add(getwindowtexts(wnd));
      RecordItems.Add(getWindowClassNameToDisplay(wnd));
      s:='';
      if IsWindowVisible(wnd) then s:=s+'visible';//'Visible: true | ' else s:=s+'Visible: false | ';
      if IsWindowEnabled(wnd) then begin
        if s<>'' then s:=s+', ';//Enable: true' else s:=s+'Enable: false';
        s+='enabled';
      end;
      RecordItems.Add(s);
      RecordItems.Add(GetWindowPosStr(wnd));
      RecordItems.Add(programS);
    end;
  end;
  windowTreeList.EndUpdate;
end;

procedure TmainForm.openWindowsConst;
var p:tpoint;
    current: twincontrol;
begin
  current:=FindControl(GetFocus);
  if current=nil then  current:=FindOwnerControl(GetFocus);
  if current=nil then exit;
  if not ((current is tedit) or (current is TComboBox)) then exit;
  p.x:=0;
  p.y:=0;//current.Height;
  p:=current.ClientToScreen(p);
  windowConstForm.Left:=p.x;
  windowConstForm.top:=p.y;
    if current is tedit then windowConstForm.currentConst:=TEdit(current).Text
    else if current is TComboBox then windowConstForm.currentConst:=TComboBox(current).Text;
  windowConstForm.currentConst:=trim(windowConstForm.currentConst);
  windowConstForm.ShowModal;
  if windowConstForm.currentConst<>'' then
    if current is tedit then begin
      TEdit(current).Text:=windowConstForm.currentConst;
      TEdit(current).SelStart:=length(TEdit(current).Text);
    end else if current is TComboBox then begin
      TComboBox(current).Text:=windowConstForm.currentConst;
      TComboBox(current).SelStart:=length(TComboBox(current).Text);
    end;
end;

procedure AddProcF1(text:string);
begin
  //mainForm.ListBox1.items.add(text);
end;


procedure TmainForm.displaySysProperties();
var i:longint;
begin
  systemProperties.BeginUpdate;
  systemProperties.items.Clear;
  for i:=0 to high(systemPropertiesArray) do
    with systemProperties.Items.add,
         systemPropertiesArray[i] do begin
      Caption:=name;
      subitems.Add(value);
    end;
  systemProperties.EndUpdate;

end;




procedure TmainForm.messagemes_cbKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then messageSend_btn.Click;
end;

procedure TmainForm.ownerWnd_edtDblClick(Sender: TObject);
begin
  handleEdt.Text:=ownerWnd_edt.Text;
  changeProperty(handleEdt);
end;

procedure TmainForm.parentWndCmbDblClick(Sender: TObject);
var s:string;
begin
  s:=parentWndCmb.text;
  if pos(' - ',s)>0 then s:=splitGet(' - ',s);
  handleEdt.Text:=s;
  changeProperty(handleEdt);
end;

procedure TmainForm.posLTEdtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TmainForm.processTabSheetResize(Sender: TObject);
begin

end;

procedure TmainForm.showHandleClick(Sender: TObject);
begin
  if GetWindowThreadProcessId(currentWindow,0)<>MainThreadID then
    niceSetVisible(false,false);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  sleep(125);
  toggleWindowMarkStatus(currentWindow);
  if GetWindowThreadProcessId(currentWindow,0)<>MainThreadID then
    niceSetVisible(true,false);
end;

procedure TmainForm.processTabSheetShow(Sender: TObject);
begin
  SetWindowLong(Handle,GWL_EXSTYLE,GetWindowLong(handle,GWL_EXSTYLE) and not WS_EX_LAYERED);
  displayProcesses.Click;
end;

procedure TmainForm.systemPropertiesAdvancedCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin

end;

procedure TmainForm.TabSheet2Show(Sender: TObject);
begin
  threadedCall(calculateSysProperties,displaySysProperties);
end;

procedure TmainForm.windowListDblClick(Sender: TObject);
var temp:word;
begin
//TODO: windowslist
{  if windowList.Selected=nil then exit;
  windowListFilterParent_edt.Text:=trim(windowList.Selected.Caption);
  temp:=vk_return;
  windowListFilterProgram_edtKeyUp(nil,temp,[]);}
end;

procedure TmainForm.windowListFilterParentUpClick(Sender: TObject);
var temp:word;
begin
  windowListFilterParent_edt.text:=Cardinal2Str(GetParent(Str2Cardinal(windowListFilterParent_edt.text)));
  temp:=vk_return;
  windowListFilterProgram_edtKeyUp(nil,temp,[]);
end;

procedure TmainForm.windowListFilterParent_edtChange(Sender: TObject);
begin
  windowsListfilterDirectChilds.Enabled:=StrToIntDef(windowListFilterParent_edt.Text,0)<>0;
end;

procedure TmainForm.windowProcessIDedtDblClick(Sender: TObject);
begin
  processidedit.Text:=windowProcessIDedt.text;
  processTabSheet.Show;
end;

procedure TmainForm.windowPropChangeClick(Sender: TObject);
begin

end;

procedure TmainForm.windowPropertySheetClick(Sender: TObject);
begin

end;


procedure TmainForm.windowsListfilterDirectChildsChange(Sender: TObject);
begin
  displayWindows;
end;

procedure TmainForm.colorKeyShapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color:=colorKeyShape.brush.color;
  if not ColorDialog1.Execute then exit;
  colorKeyShape.Brush.Color:=ColorDialog1.Color;
  changeProperty(colorKeyShape);
end;

procedure TmainForm.windowListFilterProgram_edtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then displayWindows;
end;

procedure TmainForm.windowConstOpenEvent(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (shift = [ssCtrl]) and (key=VK_SPACE) then begin
    openWindowsConst;
    key:=0;
  end;
end;

procedure TmainForm.FormShow(Sender: TObject);
var reg:TRegistry;
begin
  reg:=TRegistry.create;
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKey('\Software\BeniBela\APIV\1.5\',true);
    if reg.ValueExists('WindowLeft') then self.left:=reg.ReadInteger('WindowLeft')
                                          else reg.WriteInteger('WindowLeft',self.left);
    if reg.ValueExists('WindowTop') then self.top:=reg.ReadInteger('WindowTop')
                                          else reg.WriteInteger('WindowTop',self.Top);
    if reg.ValueExists('WindowWidth') then self.Width:=reg.ReadInteger('WindowWidth')
                                          else reg.WriteInteger('WindowWidth',self.Width);
    if reg.ValueExists('WindowHeight') then self.Height:=reg.ReadInteger('WindowHeight')
                                          else reg.WriteInteger('WindowHeight',self.Height);

    if reg.ValueExists('ScreenWindowLeft') then miniScreen.left:=reg.ReadInteger('ScreenWindowLeft')
                                          else reg.WriteInteger('ScreenWindowLeft',miniScreen.left);
    if reg.ValueExists('ScreenWindowTop') then miniScreen.top:=reg.ReadInteger('ScreenWindowTop')
                                          else reg.WriteInteger('ScreenWindowTop',miniScreen.Top);
    if reg.ValueExists('ScreenWindowWidth') then PaintBox1.Width:=reg.ReadInteger('ScreenWindowWidth')
                                          else reg.WriteInteger('ScreenWindowWidth',PaintBox1.Width);
    if reg.ValueExists('ScreenWindowHeight') then PaintBox1.Height:=reg.ReadInteger('ScreenWindowHeight')
                                          else reg.WriteInteger('ScreenWindowHeight',PaintBox1.Height);

    linksoben.left:=miniScreen.left;
    linksoben.Top:=miniScreen.Top;
    rechtsunten.left:=miniScreen.left+PaintBox1.width;
    rechtsunten.Top:=miniScreen.Top+PaintBox1.Height;


  finally
    reg.free;
  end;
end;

procedure TmainForm.enabledCbChange(Sender: TObject);
begin

end;

procedure TmainForm.Button1Click(Sender: TObject);
begin
  windowListFilterParent_edt.Text:=Cardinal2Str(currentWindow);
  windowListFilterProgram_edt.Text:='';
  if PageControl2.ActivePage<>windowListTabSheet then windowListTabSheet.Show
  else displayWindows;
end;

procedure TmainForm.callAPIClick(Sender: TObject);
begin
  callAPIResult_lbl.Caption:=Cardinal2Str(genericCall(callAPIDLL.Text,callAPIProc.Text,createMemoryBlocks(callAPIParameter.Text)));

end;


procedure TmainForm.windowPropertyListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
//TODO:??
  {if change<>ctText then exit;
  if item=nil then exit;
  if displayCalls>0 then exit; //change is called when internally changing *grr*
  ShowMessage(item.Caption);
  systemProperties.EditingDone;
  RemoveProp(currentWindow, pchar(item.SubItems[2]));
  SetProp(currentWindow, pchar(item.Caption), Str2Cardinal(item.SubItems[0]));
  displayProperty(windowPropertyList);}
end;

procedure TmainForm.windowPropertyListDeletion(Sender: TObject; Item: TListItem
  );
begin
  if item=nil then exit;
  if displayCalls>0 then exit; //save is save
  RemoveProp(currentWindow, pchar(item.Caption));
  displayProperty(windowPropertyList);
end;

procedure TmainForm.windowPropRemoveItemClick(Sender: TObject);
begin
  if windowPropertyList.Selected<>nil then begin
    RemoveProp(currentWindow, pchar(windowPropertyList.Selected.Caption));
    displayProperty(windowPropertyList);
  end else ShowMessage('Keine Eigenschaft ausgewählt');
end;

procedure TmainForm.windowStylesClickCheck(Sender: TObject);
begin

end;

procedure TmainForm.windowStylesItemClick(Sender: TObject; Index: integer);
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
  //TCheckListBox(sender).ItemIndex:=TCheckListBox(sender).items.IndexOf(currentSelected);
//  caption:=caption+TCheckListBox(sender).items[TCheckListBox(sender).itemindex];
end;

procedure TmainForm.windowtextEdtChange(Sender: TObject);
begin

end;

procedure TmainForm.windowTreeListExpandItem(sender: TObject;
  item: TTreeListItem);
begin
  if item.SubItems.count=0 then exit;
  if item.SubItems[0].Text='Dummy' then begin
    displayWindows(item);
  end;
end;

procedure TmainForm.windowAddPropertyClick(Sender: TObject);
var name,value:string;
begin
  if sender=windowAddProperty then begin
    if not InputQuery('','Name der neuen Eigenschaft: ',name) then exit;
    value:=Cardinal2Str(0);
  end else if windowPropertyList.Selected<>nil then begin
    name:=windowPropertyList.selected.Caption;
    value:=windowPropertyList.Selected.SubItems[0];
  end;
  if not InputQuery('','Neuer Wert der Eigenschaft: ',value) then exit;
  SetPropA(currentWindow,pchar(name),Str2Cardinal(value));
  displayProperty(windowPropertyList);
end;

procedure TmainForm.mouseToolImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:longint;
begin
  if button=mbLeft then begin
    screen.Cursor:=crScanner;
    currentMouseWindow:=0;

    if hideAPIVwhenSearching.Checked then
      niceSetVisible(false, true);
  end;
end;

procedure TmainForm.mouseToolImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:longint;
begin
  if button=mbLeft then begin
    screen.Cursor:=crDefault;
    toggleWindowMarkStatus(currentMouseWindow);
    
    if hideAPIVwhenSearching.Checked then
      niceSetVisible(true,true);
    
    handleEdt.Text:=Cardinal2Str(currentMouseWindow);
    changeProperty(handleEdt);
  end;
end;

procedure TmainForm.PaintBox1Click(Sender: TObject);
begin
  handleEdt.Text:=mouseHandleEdt.Text;
  changeProperty(handleEdt);
end;

procedure TmainForm.parentwndEdtDblClick(Sender: TObject);
var s:string;
begin
  s:=parentWndCmb.text;
  if pos(' - ',s)>0 then
    s:=splitGet(' - ',s);
  handleEdt.Text:=s;
  changeProperty(handleEdt);
end;

procedure TmainForm.windowListTabSheetShow(Sender: TObject);
begin
  //Workaround treelistview works not correct when enabled
  if GetWindowLong(handle, GWL_EXSTYLE) or WS_EX_LAYERED <>0then
    SetWindowLong(handle, GWL_EXSTYLE, GetWindowLong(handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
  displayWindows;
end;

procedure TmainForm.windowListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_F5 then displayWindows;
end;

procedure TmainForm.windowListSelectItem(Sender: TObject; Item: TTreeListItem);
begin
  if item=nil then exit;
  handleEdt.Text:=item.Text;
  changeProperty(handleEdt);
end;

{procedure TmainForm.setString(x:THandle;Spalte:integer);
var     s,s2:array[0..102]of char;

begin
s:='';
if x=0 then exit;
StringGrid1.Cells[spalte,1]:=Cardinal2Str(x);
GetWindowText(x,s,100);
StringGrid1.Cells[spalte,2]:=s;
GetClassName(x,s2,100);
StringGrid1.Cells[spalte,3]:=s2;
s:='';
end;  }
procedure TmainForm.findTimerTimer(Sender: TObject);
  procedure addWindow(wnd: thandle);
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
  end;
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
(*    GetWindowRect(currentMouseWindow,rec);
    if getparent(currentMouseWindow)<>0 then begin
    ShowWindow(currentMouseWindow,SW_HIDE);
    ShowWindow(currentMouseWindow,SW_show);
//      RedrawWindow(getparent(currentMouseWindow),nil,0,RDW_ERASE or RDW_FRAME or RDW_INTERNALPAINT or RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
  //    RedrawWindow(currentMouseWindow,nil,0,RDW_FRAME or RDW_INTERNALPAINT or RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
    end else
      RedrawWindow(currentMouseWindow,nil,0,RDW_ERASE or RDW_FRAME or RDW_INTERNALPAINT or RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
    //RedrawWindow(currentMouseWindow,nil,0,RDW_INVALIDATE or RDW_UPDATENOW);
    //messagemes_cb(currentMouseWindow, WM_PAINT,0,0);

{    InvalidateRect(currentMouseWindow,0,true);
    UpdateWindow(currentMouseWindow);}

    markDC:=GetWindowDC(mouseHandle);
    SelectObject(markDC,CreatePen(PS_SOLID,3,0));
    lb.lbStyle:=BS_NULL;
    SelectObject(markDC,CreateBrushIndirect(lb));
    //GetWindowRect(mouseHandle,rec);
    windows.GetWindowRect(mouseHandle,rec);
    Rectangle(markDC,1,1,rec.right-rec.left-1,rec.bottom-rec.top-1);//  rec.Left+1,rec.top+1,rec.Right-1,rec.Bottom-1);
    ReleaseDC(mouseHandle, markDC);            *)
  end;
  currentMouseWindow:=mouseHandle;
  if mouseRefreshAllLive.Checked then begin
    handleEdt.Text:=Cardinal2Str(currentMouseWindow);
    changeProperty(handleEdt);
  end;
end;

procedure TmainForm.messageSend_btnClick(Sender: TObject);
var wp,lp: cardinal;
    blockWP,blockLP: TMemoryBlocks;
    msgStr: string;
begin
  msgStr:=messagemes_cb.text;
  if pos('=',msgStr)>0 then begin
    splitGet('=',msgStr);
    if pos(';',msgStr)>0 then msgStr:=splitGet(';',msgStr);
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
  SendMessage(currentWindow,Str2Cardinal(msgStr),wp,lp);
end;


procedure TmainForm.displayProcessesClick(Sender: TObject);  //Sucht alle Processe
type
  TProcess32FN = FUNCTION(hSnapshot: DWORD; VAR lppe: tagPROCESSENTRY32): BOOL; stdcall;
  TCreateTHSnap = FUNCTION(dwFlags, th32ProcessID: DWORD): DWORD; stdcall;

VAR
  hKernel, hProcessSnap: DWORD;
  CreateToolhelp32Snapshot: TCreateTHSnap;
  Process32First, Process32Next: TProcess32FN;
  pe32: tagProcessEntry32;
  noerr: bool;
  procedure makeSnapshot;//taken from Assarbad
  BEGIN
    //init variables
  //  hKernel := 0;
    hProcessSnap := dword(-1);
    
    @CreateToolhelp32Snapshot := NIL;
    @Process32First := NIL;
    @Process32Next := NIL;

    //I still don't understand, WHY 'kernel32.dll' is always loaded ;)
    hKernel := GetModuleHandle('KERNEL32.DLL');
    IF BOOL(hKernel) THEN BEGIN
      @CreateToolhelp32Snapshot := GetProcAddress(hKernel, 'CreateToolhelp32Snapshot');
      @Process32First := GetProcAddress(hKernel, 'Process32First');
      @Process32Next := GetProcAddress(hKernel, 'Process32Next');
    END;
    //quit if we did not get all function addresses
    IF NOT (assigned(@Process32Next) AND assigned(@Process32First) AND assigned(@CreateToolhelp32Snapshot)) THEN exit;
    //take a snapshot of all processes at the moment
    hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    //make sure we got, what we wanted ... else quit ...
    IF hProcessSnap = DWORD(-1) THEN exit;
    pe32.dwSize := sizeof(tagPROCESSENTRY32);
  end;

VAR
  i: integer;
  prio:integer;
  ttt:string;
  item:TTreeListItem;
  parentItem: TTreeListItem;
BEGIN
  if processTreeList=nil then exit;//wtf??
  processTreeList.BeginUpdate;
  //processTreeList.multiSelect:=true;
  processTreeList.items.clear;
  makeSnapshot;
  if hProcessSnap=dword(-1) then exit;
  if not  Process32First(hProcessSnap, pe32) then exit;
  repeat
    parentItem:=processTreeList.Items.FindItemWithRecordText(1,Cardinal2Str(pe32.th32ParentProcessID));
    item:=processTreeList.Items.Add(parentItem, ExtractFileName(string(pe32.szExeFile)));
    item.recordItems.Add(Cardinal2Str(pe32.th32ProcessID));
    //item.recordItems.AddWithText(string(pe32.szExeFile));

    ttt:='';
    prio:=GetProcessPriority( pe32.th32ProcessID);
    if prio=HIGH_PRIORITY_CLASS then ttt:='HOHE';
    if prio=IDLE_PRIORITY_CLASS then ttt:='NIEDRIG';
    if prio=NORMAL_PRIORITY_CLASS then ttt:='NORMAL';
    if prio=REALTIME_PRIORITY_CLASS then ttt:='ECHT ZEIT';
    ttt:=ttt+'('+Cardinal2Str(prio)+')';
    item.recordItems.Add(ttt);

//    item.recordItems.AddWithText(inttostr(pe32.cntUsage));// string(pe32.szExeFile));
    item.recordItems.Add(inttostr(pe32.cntThreads));// string(pe32.szExeFile));
  until not Process32Next(hProcessSnap, pe32);
  CloseHandle(hProcessSnap);
  processTreeList.EndUpdate;
end;

procedure TmainForm.Button26Click(Sender: TObject);
begin
  KillProcess(Str2Cardinal(processidedit.text));
end;



procedure TmainForm.PaintBox1Paint(Sender: TObject);

var x:THandle;
    pos:TRect;
    ty,tx:single;
begin
if PaintBox1.Width=0 then exit;
if PaintBox1.Height=0 then exit;
tx:=screen.Width / PaintBox1.Width;//120;
ty:=screen.Height / PaintBox1.Height;//90;
x:=FindWindow('PROGMAN',nil);
while x>0 do begin
PaintBox1.Canvas.Brush.Color:=clBtnFace;
if IsWindowVisible(x) then begin
GetWindowRect(x,pos);
pos.Left:=trunc(pos.Left / tx);
pos.Right:=trunc(pos.Right / tx);
pos.top:=trunc(pos.top /ty);
pos.Bottom:=trunc(pos.Bottom /ty);
if x=handle then
PaintBox1.Canvas.Brush.Color:=clGreen;
if x=FindWindow('PROGMAN',nil) then
PaintBox1.Canvas.Brush.Color:=clBackground;
PaintBox1.Canvas.Rectangle(pos.Left,pos.top,pos.Right,pos.Bottom);
end;
x:=GetWindow(x,GW_HWNDPREV);
end;

end;

procedure TmainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
    ty,tx:single;

    pp:TPoint;
begin
//timer3.Enabled:=false;
tx:=screen.Width / PaintBox1.Width;//120;
ty:=screen.Height / PaintBox1.Height;//90;
pp.x:=trunc(X*tx);
pp.y:=trunc(y*ty);

//TODO: MAUSHANDLE:=WindowFromPoint(pp);

end;

procedure TmainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    tx,ty:single;

    pp:TPoint;
begin
//TODO;timer3.Enabled:=false;
tx:=screen.Width / PaintBox1.Width;//120;
ty:=screen.Height / PaintBox1.Height;//90;
pp.x:=trunc(X*tx);
pp.y:=trunc(y*ty);

mouseHandleEdt.text:=Cardinal2Str(WindowFromPoint(pp));

end;



procedure TmainForm.PageControl1Change(Sender: TObject);
begin
end;

procedure TmainForm.Button19Click(Sender: TObject);
begin
end;



procedure TmainForm.CheckBox3Click(Sender: TObject);
begin
findTimer.Interval:=StrToIntDef(edit14.text,3000);
findTimer.Enabled:=CheckBox3.Checked;
end;

procedure TmainForm.Edit1Change(Sender: TObject);
begin
end;

procedure TmainForm.windowPropertyChanged1(Sender: TObject);
begin
  changeProperty(sender);
end;

procedure TmainForm.FormCreate(Sender: TObject);
var reg:TRegistry;
    lb:LOGBRUSH  ;

begin
  niceVisible:=true;
  
  //=========Fensterliste===========
  windowTreeList:= TTreeListView.create(windowListTabSheet);
  windowTreeList.Parent:=windowListTabSheet;
  windowTreeList.Visible:=true;
  windowTreeList.Align:=alClient;
  windowTreeList.OnExpandItem:=windowTreeListExpandItem;
  windowTreeList.OnKeyUp:=windowListKeyUp;
  windowTreeList.OnSelect:=windowListSelectItem;
  windowTreeList.OnDblClick:=windowListDblClick;
  windowTreeList.sorted:=true;
  windowTreeList.ColumnsDragable:=true;
  windowTreeList.Columns.Clear;
  with windowTreeList.Columns.add do begin
    Text:='Handle';
    Width:=140;
  end;
  with windowTreeList.Columns.Add do begin
    text:='Titel';
    Width:=140;
  end;
  with windowTreeList.Columns.Add do begin
    text:='Klasse';
    Width:=100;
  end;
  with windowTreeList.Columns.Add do begin
    text:='Status';
    Width:=100;
  end;
  with windowTreeList.Columns.Add do begin
    text:='Größe';
    Width:=130;
  end;
  with windowTreeList.Columns.Add do begin
    text:='Programm';
    Width:=150;
  end;

  //Processliste
  processTreeList:= TTreeListView.create(processTabSheet);
  processTreeList.Parent:=processTabSheet;
  processTreeList.Visible:=true;
  processTreeList.Align:=alClient;
{  processTreeList.OnExpandItem:=processTreeListExpandItem;
  processTreeList.OnKeyUp:=windowListKeyUp;
  processTreeList.OnSelect:=windowListSelectItem;
  processTreeList.OnDblClick:=windowListDblClick;}
  processTreeList.sorted:=true;
  processTreeList.ColumnsDragable:=true;
  if processTreeList.Columns.Count>0 then
    processTreeList.Columns[0].Text:='Programm'
   else
    processTreeList.Columns.add.Text:='Programm';
  processTreeList.Columns[0].Width:=180;
  with processTreeList.Columns.Add do begin
    text:='PID';
    Width:=40;
  end;
  with processTreeList.Columns.Add do begin
    text:='Priority';
    Width:=100;
  end;
  with processTreeList.Columns.Add do begin
    text:='Threads';
    Width:=100;
  end;

  //================================
  
//  desktopDC:=createDc('DISPLAY',nil,nil,nil);//getdc(GetDesktopWindow);
//     messageho

  screen.cursors[crScanner]:=LoadCursor(HINSTANCE,makeintresource(101));
  reg:=TRegistry.create;
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKey('\Software\BeniBela\APIV\1.5\',true);
    if reg.ValueExists('HexZahl') then checkhex.Checked:=reg.ReadBool('HexZahl')
                                          else reg.WriteBool('HexZahl',checkhex.Checked);

    if reg.ValueExists('status') then status:=reg.ReadInteger('status')
                                          else reg.WriteInteger('status',status);
  finally
    reg.free;
  end;
  
end;

procedure TmainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin

end;


procedure TmainForm.linksobenMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
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

procedure TmainForm.ComboBox2Change(Sender: TObject);
var x,prio:cardinal;
begin
if runonNT then
  SetPrivilege(SE_DEBUG_NAME,true);
x:=OpenProcess(PROCESS_SET_INFORMATION,false, Str2Cardinal(processidedit.text));
case ComboBox2.ItemIndex of
//  1:prio:=NORMAL_PRIORITY_CLASS;
  0: prio:=IDLE_PRIORITY_CLASS;
  1: prio:=$4000;
  3: prio:=$8000;
  4: prio:=HIGH_PRIORITY_CLASS;
  5: prio:=REALTIME_PRIORITY_CLASS;
  else prio:=NORMAL_PRIORITY_CLASS;
end;
SetPriorityClass(x,prio);
closeHandle(x);
if runonNT then
  SetPrivilege(SE_DEBUG_NAME,false);
end;

procedure TmainForm.processideditChange(Sender: TObject);
begin
case GetProcessPriority(Str2Cardinal(processidedit.text)) of
  IDLE_PRIORITY_CLASS: ComboBox2.ItemIndex:= 0;
  HIGH_PRIORITY_CLASS: ComboBox2.ItemIndex:= 4;
  REALTIME_PRIORITY_CLASS: ComboBox2.ItemIndex:= 5;
  $4000:ComboBox2.ItemIndex:= 1;
  $8000:ComboBox2.ItemIndex:= 3;
  else ComboBox2.ItemIndex:= 2;
end;
end;

procedure TmainForm.checkhexClick(Sender: TObject);
begin
hexa:=checkhex.Checked;
end;

procedure TmainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var reg:TRegistry;
begin
  reg:=TRegistry.create;
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKey('\Software\BeniBela\APIV\1.5\',true);
    reg.WriteInteger('WindowLeft',self.left);
    reg.WriteInteger('WindowTop',self.Top);
    reg.WriteInteger('WindowWidth',self.Width);
    reg.WriteInteger('WindowHeight',self.Height);

    reg.WriteInteger('ScreenWindowLeft',miniScreen.left);
    reg.WriteInteger('ScreenWindowTop',miniScreen.Top);
    reg.WriteInteger('ScreenWindowWidth',PaintBox1.Width);
    reg.WriteInteger('ScreenWindowHeight',PaintBox1.Height);

    reg.WriteBool('HexZahl',checkhex.Checked);

    reg.WriteInteger('status',status);
    reg.DeleteKey('\Software\BeniBela\APIV\1.5\temp\');
  finally
    reg.free;
  end;
end;

procedure TmainForm.Label14Click(Sender: TObject);
begin
end;

procedure TmainForm.Button5Click(Sender: TObject);
begin
windowstyleform.han:=currentWindow;
windowstyleform.ShowModal;
end;

procedure TmainForm.ComboBox3Change(Sender: TObject);
begin
end;

procedure TmainForm.Button8Click(Sender: TObject);
begin
end;




procedure TmainForm.updatePropertyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then displayProperty(sender)
  else if key=VK_RETURN then changeProperty(sender);
end;

initialization

  {$I unit1.lrs}
end.







