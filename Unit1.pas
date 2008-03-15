unit Unit1;

interface
{$mode delphi}{$h+}
uses
  LResources, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ComCtrls,registry,shellapi,proc9,commontypes,
  ImgList,windowfuncs,passwort, Spin,sysutils,richedit, Menus,FileUtil;

type

  { TmainForm }

  TmainForm = class(TForm)
    alphatrans_cb: TCheckBox;
    windowListFilterParentUp: TButton;
    windowsListfilterDirectChilds: TCheckBox;
    colorkey_cb: TCheckBox;
    userdata_edt: TEdit;
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
    posSizeEdt: TEdit;
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
    TabSheet7: TTabSheet;
    findTimer: TTimer;
    Label7: TLabel;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Panel5: TPanel;
    displayProcesses: TButton;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Button19: TButton;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    password: TLabel;
    Button26: TButton;
    TabSheet5: TTabSheet;
    CheckBox3: TCheckBox;
    Edit14: TEdit;
    Label21: TLabel;
    PaintBox2: TPaintBox;
    ListView1: TListView;
    ImageList1: TImageList;
    windowList: TListView;
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
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    labclassname: TLabel;
    Label15: TLabel;
    Button5: TButton;
    ColorDialog1: TColorDialog;
//    ss1: Tss;
    procedure enabledCbChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure messagemes_cbKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure parentWndCmbDblClick(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure windowListDblClick(Sender: TObject);
    procedure windowListFilterParentUpClick(Sender: TObject);
    procedure windowListFilterParent_edtChange(Sender: TObject);
    procedure windowPropChangeClick(Sender: TObject);
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
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure checkhexClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label14Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure updatePropertyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);


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
    procedure TabSheet7Show(Sender: TObject);
    procedure windowAddPropertyClick(Sender: TObject);
    procedure windowListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure windowListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure windowPropertyChanged1(Sender: TObject);
    procedure windowPropertyListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure windowPropertyListDeletion(Sender: TObject; Item: TListItem);
    procedure windowPropRemoveItemClick(Sender: TObject);
  private
    { Private-Deklarationen}
    procedure LoadWNetEnumCachedPasswords;

    procedure WM_HELP(var message:TMessage);message WM_HELP;
    procedure WM_SYSCOMMAND(var message:TMessage);message WM_SYSCOMMAND;
    

    mouseToolActive: boolean;
    currentMouseWindow:HWND;
    
    currentWindow:HWND;
    displayCalls: longint;
    procedure displayProperty(prop:TObject);
    procedure changeProperty(prop:TObject);

    procedure displayWindows;
    
    procedure openWindowsConst;
  public
  runonNT: boolean ;
    { Public-Deklarationen}
//    procedure MessageHandler;
  end;

var
  edi:TEdit;
  mainForm: TmainForm;

  status:integer=0;
  helpon:boolean=false;
type TWNetEnumCachedPasswords= function (lp: lpStr; windowList: Word; b: Byte; PC: PChar; dw: DWord): Word; stdcall;
var
   WNetEnumCachedPasswords:TWNetEnumCachedPasswords=nil;

implementation
{$R cursor.res}

uses wstyles, help, bbutils, win32proc, applicationConfig,winConstWindow;

type TMemoryBlock = array of byte;
     TMemoryBlocks = array of TMemoryBlock;
//Erzeugt Memory Blocks aus Strings mit Pascalsyntax
//Ein Block: ('1214', 65, $10, 27)  => '1214A'#16#27
//Erlaubt Nesting: ('abc',('test')) => 'abctest'#0
//Erlaubt Pointer: ('p',@'abc','q') => 'p????q'#0 mit ???? = 32 Bit Pointer auf 'abc'#0
//                                     (also gibt es zwei Blocks)
//
//Für Zahlen wird der kleinster LE Datentyp (signed/unsigned 1 Byte, 2 Byte, 4 Byte oder 8 Byte)
//gewählt, in die der Wert passt
//Beispiele: 255 => #255 (byte); 256 => #0#1 (LE word); -128 => #255 (shortint)
//           -129 => #$7F#$FF (LE small int)
//2147483647 => #$F9#$FF#$FF#$7F (LE dword)
//
//Letzte Strings in Klammern werden nullterminier
//Beispiele: ('hallo ','welt') => 'hallo welt'#0; (('hallo '),'welt') => 'hallo '#0'welt'#0
//Die Metazeichen ''' für ein ' und #xx für ein Zeichen mit Nummer xx werden nicht unterstützt
//(da man einfach Zahlen nehmen kann)
function createMemoryBlocks(s:string):TMemoryBlocks;
var p: pchar;
    brackets,currentBlock: longint;
    blocks:TMemoryBlocks;
    inStr: boolean;
    blockStack: array of record
      blockID: longint;
      bracketCount: longint;
    end;
    newBlock: boolean; //created a new block in the step before
  procedure currentBlockAddBuffer(block: pointer; size:longint);
  var oldSize:longint;
  begin
    oldSize:=length(blocks[currentBlock]);
    SetLength(blocks[currentBlock],length(blocks[currentBlock])+size);
    move(block^,blocks[currentBlock][oldSize],size);
  end;
  procedure currentBlockAddByte(b: byte);
  begin
    currentBlockAddBuffer(@b,1);
  end;
  procedure currentBlockAddPointer(p:pointer);
  begin
    currentBlockAddBuffer(@p,4);
  end;
  procedure closeBlocks;
  var block:longint;
  begin
    while (length(blockStack)>0) and (blockStack[high(blockStack)].bracketCount>=brackets) do begin
      block:=currentBlock;
      currentBlock:=blockStack[high(blockStack)].blockID;
      currentBlockAddPointer(@blocks[block][0]);
      setlength(blockStack,high(blockStack));
    end;
  end;
  var lastData: (ldNone,ldNum,ldStr);
      numStr: string;
      num:int64;
begin
  if s='' then exit(nil);
  p:=@s[1];
  brackets:=0;
  inStr:=false;
  currentBlock:=0;
  SetLength(blocks,1);
  newBlock:=false;
  lastData:=ldNone;
  while p^<>#0 do begin
    if inStr and (p^<>'''') then currentBlockAddByte(ord(p^))
    else case p^ of
      '@': begin
        SetLength(blockStack,length(blockStack)+1);
        blockStack[high(blockStack)].blockID:=currentBlock;
        blockStack[high(blockStack)].bracketCount:=brackets;
        SetLength(blocks,length(blocks)+1);
        currentBlock:=high(blocks);
      end;
      '(': brackets+=1;
      ')': begin
        if lastData = ldStr then currentBlockAddByte(0); //Str nullterminiert
        lastData:=ldNone;
        brackets-=1;
      end;
      ',',' ': closeBlocks;
      '''': begin
        inStr:=not inStr;
        if inStr then lastData:=ldStr;
      end;
      '$','-','0'..'9': begin
        numStr:=p^;
        repeat inc(p); until p^<>' ';
        if ((p^ = '$') or (p^='-')) and (numStr<>p^) then begin
          numStr+=p^;
          repeat inc(p); until p^<>' ';
        end;
        if pos('$',numStr)>0 then begin
          while p^ in ['0'..'9','A'..'F','a'..'f'] do begin
            numstr+=p^;
            inc(p);
          end;
        end else
          while p^ in ['0'..'9'] do begin
            numstr+=p^;
            inc(p);
          end;
        dec(p);
        num:=StrToInt64(numStr);
        if num>=0 then begin //Optimaler Datentyp
          if num<256 then currentBlockAddBuffer(@num,1)
          else if num<65536 then currentBlockAddBuffer(@num,2)
          else if num<4294967296 then currentBlockAddBuffer(@num,4)
          else currentBlockAddBuffer(@num,8);
        end else if num<0 then
          if num>=-128 then currentBlockAddBuffer(@num,1)
          else if num>=-32768 then currentBlockAddBuffer(@num,2)
          else if num>=-2147483648 then currentBlockAddBuffer(@num,4)
          else currentBlockAddBuffer(@num,8);
      end;
      else raise Exception.Create('Unexpected character '+p^+' at '+string(p));
    end;
    inc(p);
  end;
  if instr then raise Exception.Create('String nicht geschlossen');
  if lastData=ldStr then currentBlockAddByte(0);
  closeBlocks;
  result:=blocks;
end;

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

procedure AddProcF1(text:string);
begin
  mainForm.ListBox1.items.add(text);
end;
//Sucht Passwörter
procedure TmainForm.LoadWNetEnumCachedPasswords;
var lib:THandle;
begin
  if runonNT then exit;
  lib:=LoadLibrary(@mpr[1]);
  if lib=0 then exit;
  @WNetEnumCachedPasswords := GetProcAddress(lib, @'WNetEnumCachedPasswords'[1]);
  if not Assigned(WNetEnumCachedPasswords) then WNetEnumCachedPasswords:=nil;
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

function WindowPropertyEnumProc(wnd:HWND;  name:LPTSTR;  hData:HANDLE;  listView: TListView):boolean;stdcall;
begin
  with listView.Items.add do begin
    caption:=string(name);
    subitems.add(Cardinal2Str(hdata));
    subitems.add(caption); //need old name when renaming
  end;
  result:=true;
end;


procedure TmainForm.displayProperty(prop: TObject);
var propEdt:TEdit;
    rect:TRect;
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
  end else if prop=posSizeEdt then posSizeEdt.Text:=GetWindowPosStr(currentWindow)
  else if (prop=alphatrans_cb) or (prop=alphatrans_sp) or
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

  end else if prop=userdata_edt then userdata_edt.Text:=Cardinal2Str(GetWindowLong(currentWindow,GWL_USERDATA))
  else if prop=wndproc_edt then wndproc_edt.Text:=Cardinal2Str(GetWindowLong(currentWindow,GWL_WNDPROC))

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
  end else if prop=parentWndCmb then windows.SetParent(currentWindow,Str2Cardinal(parentWndCmb.Text))
  else if prop=windowtextEdt then SetWindowText(currentWindow,pchar(windowtextEdt.Text))
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
  end else if prop=posSizeEdt then begin
    s:=StringReplace(posSizeEdt.text,' ','',[rfReplaceAll]);
    delete(s,1,pos('(',s));
    rec.Left:=StrToInt(splitGet(',',s));
    rec.top:=StrToInt(splitGet(')-(',s));
    rec.Right:=StrToInt(splitGet(',',s));
    rec.Bottom:=StrToInt(splitGet(')',s));
    SetWindowPos(currentWindow,0,rec.Left,rec.top,rec.Right-Rec.Left,rec.Bottom-Rec.Top,SWP_NOACTIVATE or SWP_NOZORDER)
  end else if (prop=alphatrans_sp) or (prop=alphatrans_cb) or
              (prop=colorkey_cb) or (prop=colorKeyShape) then begin
    flags:=GetWindowLong(currentWindow,GWL_EXSTYLE);
    if colorkey_cb.checked or alphatrans_cb.checked then begin
      if flags and WS_EX_LAYERED <> WS_EX_LAYERED then
        SetWindowLong(currentWindow,GWL_EXSTYLE,flags or WS_EX_LAYERED);
      flags:=0;
      if colorkey_cb.checked then flags+=LWA_COLORKEY;
      if alphatrans_cb.checked then flags+=LWA_ALPHA;
      SetLayeredWindowAttributes(currentWindow,colorKeyShape.Brush.Color,alphatrans_sp.Value,flags);
    end else if flags and WS_EX_LAYERED = WS_EX_LAYERED then
        SetWindowLong(currentWindow,GWL_EXSTYLE,flags and not WS_EX_LAYERED);
  end else if prop=userdata_edt then SetWindowLong(currentWindow,GWL_USERDATA,Str2Cardinal(userdata_edt.Text));



  ;
  displayProperty(prop);
end;

procedure TmainForm.displayWindows;
var i:longint;
    wnd,nextParent:hwnd;
    list:TIntArray;
    s,programS:string;
    filterParentWnd: thandle;
    filterProgram: string;
begin
  filterProgram:=lowercase(windowListFilterProgram_edt.Text);
  if windowListFilterParent_edt.text<>'' then
    filterParentWnd:=Str2Cardinal(windowListFilterParent_edt.text)
   else
    filterParentWnd:=0;
  list:=EnumWindowsToIntList(filterParentWnd,not windowsListfilterDirectChilds.Checked);
  windowList.Clear;
  windowList.BeginUpdate;
  for i:=0 to high(list) do begin
    wnd:=list[i];
    programS:=GetFileNameFromHandleToDisplay(wnd);
    if (filterProgram<>'') and (pos(filterProgram,LowerCase(programS))<=0) then continue;
    with windowList.items.Add do begin
      caption:=Cardinal2Str(wnd);
      if filterParentWnd <> 0 then begin
        nextParent:=getparent(wnd);
        while nextParent<>filterParentWnd do begin
          nextParent:=getparent(nextParent);
          Caption:='  '+Caption;
        end;
      end;
      SubItems.add(getwindowtexts(wnd));
      SubItems.add(getWindowClassNameToDisplay(wnd));
      s:='';
      if IsWindowVisible(wnd) then s:=s+'visible';//'Visible: true | ' else s:=s+'Visible: false | ';
      if IsWindowEnabled(wnd) then begin
        if s<>'' then s:=s+', ';//Enable: true' else s:=s+'Enable: false';
        s+='enabled';
      end;
      SubItems.Add(s);
      SubItems.Add(GetWindowPosStr(wnd));
      SubItems.Add(programS);
    end;
  end;
  windowList.EndUpdate;
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



//---------------------------------------------------



procedure TmainForm.messagemes_cbKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then messageSend_btn.Click;
end;

procedure TmainForm.parentWndCmbDblClick(Sender: TObject);
begin
  handleEdt.Text:=parentWndCmb.text;
  changeProperty(handleEdt);
end;

procedure TmainForm.TabSheet3Show(Sender: TObject);
begin
  displayProcesses.Click;
end;

procedure TmainForm.windowListDblClick(Sender: TObject);
var temp:word;
begin
  if windowList.Selected=nil then exit;
  windowListFilterParent_edt.Text:=trim(windowList.Selected.Caption);
  temp:=vk_return;
  windowListFilterProgram_edtKeyUp(nil,temp,[]);
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

procedure TmainForm.windowPropChangeClick(Sender: TObject);
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

procedure CreateEdit(top:integer;name:string);
begin
edi:=TEdit.Create(mainForm);
edi.Name:=name;
edi.Parent:=mainForm.TabSheet2;
edi.Left:=87;
edi.Top:=top;
edi.BorderStyle:=bsNone;
edi.Text:='';
edi.Visible:=true;
edi.Height :=15;

end;
procedure TmainForm.FormShow(Sender: TObject);
var reg:TRegistry;
begin

{AppendMenu(GetSystemMenu(handleEdt,false),MF_STRING,$F200,'Desktop umschalten');
AppendMenu(GetSystemMenu(handleEdt,false),MF_STRING,$F201,'Delphi umschalten');
AppendMenu(GetSystemMenu(handleEdt,false),MF_STRING,$F202,'Winpopup umschalten');
AppendMenu(GetSystemMenu(handleEdt,false),MF_STRING,$F203,'Winpopup-Text umschalten');}
CreateEdit(127,'Edit12');
CreateEdit(143,'Edit13');
CreateEdit(175,'Edit2');
CreateEdit(191,'Edit7');
CreateEdit(207,'Edit10');
CreateEdit(223,'Edit11');
CreateEdit(239,'Edit8');
CreateEdit(255,'Edit9');



addproc:=AddProcF1;
//windowstyleform.mouseRefreshAllLive.Enabled:=runonNT;
//windowstyleform.mouseRefreshAllLive.Checked:=not runonNT;
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

procedure TmainForm.Button4Click(Sender: TObject);
var
    s:string;
begin
s:=InputBox('Text-Eingabe','Bitte geben sie den Text ein','');
SetWindowText(FindWindow('Winpopup',nil),Pchar(s));

end;

procedure TmainForm.windowPropertyListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
 { if change<>ctText then exit;
  if item=nil then exit;
  if displayCalls>0 then exit; //change is called when internally changing *grr*
  ShowMessage(item.Caption);
  ListView1.EditingDone;
  RemoveProp(currentWindow, pchar(item.SubItems[2]));
  SetProp(currentWindow, pchar(item.Caption), Str2Cardinal(item.SubItems[0]));
  displayProperty(windowPropertyList);       }
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
begin
  if button=mbLeft then begin
    screen.Cursor:=crScanner;
    currentMouseWindow:=0;
  end;
end;

procedure TmainForm.mouseToolImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then begin
    screen.Cursor:=crDefault;
    toggleWindowMarkStatus(currentMouseWindow);
    
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

procedure TmainForm.TabSheet7Show(Sender: TObject);
begin
  displayWindows;
end;

procedure TmainForm.windowListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_F5 then displayWindows;
end;

procedure TmainForm.windowListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    handleEdt.Text:=item.Caption;
    changeProperty(handleEdt);
  end;
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
  mouseHandle:=GetRealWindowFromPoint(p);
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
    b1,b0: PByteArray;
    msgStr: string;
begin
  msgStr:=messagemes_cb.text;
  if pos('=',msgStr)>0 then begin
    splitGet('=',msgStr);
    if pos(';',msgStr)>0 then msgStr:=splitGet(';',msgStr);
  end;

  blockWP:=createMemoryBlocks(messagewparam_edt.Text);
  blockLP:=createMemoryBlocks(messagelparam_edt.Text);
  b0:=PByteArray(blockLP[0]);
  b1:=PByteArray(blockLP[1]);
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
VAR
  i: integer;
  prio:integer;
  ttt:string;
  item:TListItem;
  processes: TProcessrecs;
BEGIN
  mainForm.listView1.Items.Clear;
  setlength(processes, 0);
  processes := proc9.GetProcesses9x ;
  IF length(processes) > 0 THEN
    FOR i := 0 TO length(processes) - 1 DO begin
      item:=mainForm.listView1.Items.Add;
      item.Caption:=Cardinal2Str {inttostr}(processes[i].PID);
      item.SubItems.Add(ExtractFileName( string(processes[i].name)));
      item.SubItems.Add(string(processes[i].name));
      ttt:='';
      prio:=GetProcessPriority( processes[i].pid);
      if prio=HIGH_PRIORITY_CLASS then ttt:='HOHE';
      if prio=IDLE_PRIORITY_CLASS then ttt:='NIEDRIG';
      if prio=NORMAL_PRIORITY_CLASS then ttt:='NORMAL';
      if prio=REALTIME_PRIORITY_CLASS then ttt:='ECHT ZEIT';
      ttt:=ttt+'('+Cardinal2Str(prio)+')';
      item.SubItems.Add(ttt);
    end;//Refreshlist;
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


function GetCPUSpeed: Double;
const
TimeOfDelay = 500;
var
TimerHigh,
TimerLow: DWord;
begin
SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
SetThreadPriority(GetCurrentThread,
THREAD_PRIORITY_TIME_CRITICAL);
asm
dw 310Fh
mov TimerLow, eax
mov TimerHigh, edx
end;
Sleep(TimeOfDelay);
asm
dw 310Fh
sub eax, TimerLow
sub edx, TimerHigh
mov TimerLow, eax
mov TimerHigh, edx
end;
Result := round (TimerLow / (1000.0 * TimeOfDelay));

end;

procedure TmainForm.PageControl1Change(Sender: TObject);
var buf:array[0..300] of  char;
    reg:TRegistry;
    a,b,anaus:integer;
    ptemp:array[0..1024] of char;
temp,pwd_dec:string;
    ed:TEdit;
    memory:TMemoryStatus;

begin
if PageControl1.ActivePage=TabSheet4 then begin//TODO:
listbox1.Clear;
  if assigned(WNetEnumCachedPasswords) then
  if WNetEnumCachedPasswords(nil, 0, $FF, @AddPassword, 0) <> 0 then
   begin
      ListBox1.Items.Add('Keine Passwörter gefunden!');
    end
  else
   if Count = 0 then
    ListBox1.Items.Add('Keine Passwörter gefunden!');

     reg:=TRegistry.Create;
     reg.Rootkey:=HKEY_CURRENT_USER;
anaus:=0;
     IF reg.OpenKey('\Control Panel\Desktop\',False) THEN // Registry öffnen
       BEGIN
         anaus:=reg.ReadInteger('ScreenSaveUsePassword'); // Passwortschutz aktiv ?
         reg.ReadBinaryData( 'ScreenSave_Data',ptemp,1000);  // verschlüsseltes Passwort lesen
       END;
     temp:=ptemp;
     IF (temp<>'')and(anaus<>0) THEN  // Wenn Passwort existiert dann ...
       BEGIN
         pwd_dec:=ScrDecode(temp); // Aufruf der Decoder-Funktion
         listBox1.items.add('Bildschirmschoner Passwort:  '+pwd_dec);// Entschlüsseltes Passwort ausgeben
       END
     ELSE
         listBox1.items.add('Bildschirmschoner Passwort:  NICHT DA');// Wenn kein Passwort existiert
reg.free;
end;
if PageControl1.ActivePage=TabSheet2 then begin
memory.dwLength:=sizeof(memory);
GlobalMemoryStatus(memory);
label16.Caption:='Gesamter Ram: '+inttostr(memory.dwTotalPhys div 1024000) +' MB';
label17.Caption:='Freiere Ram: '+inttostr(memory.dwAvailPhys div 1024000)+' MB';

GetWindowsDirectory(buf,256);
Label3.Caption:='Windows installiert nach: '+buf;
if Label3.Caption[Length(Label3.Caption)]<>'\' then
Label3.Caption:=Label3.Caption+'\';
buf:='';
GetTempPath( 256,buf);
Label5.Caption:='Temppfad: '+buf;
if Label5.Caption[Length(Label5.Caption)]<>'\' then
Label5.Caption:=Label5.Caption+'\';
GetSystemDirectory( buf,256);
Label4.Caption:='Systemverzeichnis: '+buf;
if Label4.Caption[Length(Label4.Caption)]<>'\' then
Label4.Caption:=Label4.Caption+'\';
Label6.Caption:='Prozessor: '+floatToStr(GetCPUSpeed);
reg:=TRegistry.create;
reg.RootKey:=HKEY_LOCAL_MACHINE;
reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion',true);
if reg.ValueExists('ProductId') then
  (findComponent('edit10') as TEdit).text:=reg.ReadString('ProductId');
if reg.ValueExists('ProductKey') then
  (findComponent('edit11')as TEdit).text:=reg.ReadString('ProductKey');
if reg.ValueExists('VersionNumber') then
  (FindComponent('edit13') as TEdit).text:=reg.ReadString('VersionNumber');


if reg.ValueExists('ProductName') then
  (findComponent('edit12')as TEdit).text:=reg.ReadString('ProductName');
  Application.ProcessMessages;
if reg.ValueExists('RegisteredOwner') then
  (findComponent('edit2') as TEdit ).text:=reg.ReadString('RegisteredOwner');
  Application.ProcessMessages;
if reg.ValueExists('RegisteredOrganization') then
  (findComponent('edit7')as TEdit).text:=reg.ReadString('RegisteredOrganization');
reg.OpenKey('\System\CurrentControlSet\Services\VxD\VNETSUP',true);
if reg.ValueExists('Workgroup') then
  (findComponent('edit8')as Tedit).text:=reg.ReadString('Workgroup')
  else begin
    (findComponent('edit8') as tedit).visible:=false;
  end;
if reg.ValueExists('ComputerName') then
  (findComponent('edit9') as tedit).text:=reg.ReadString('ComputerName')
  else begin
    (findComponent('edit9') as  tedit).visible:=false;
  end;
b:=0;
for a:=1 to 13 do begin
ed:=findcomponent('Edit'+IntToStr(a)) as Tedit;
if ed <> nil then begin
font:=ed.Font;
if (ed.width < canvas.textwidth(ed.text))and(b<canvas.textwidth(ed.text)) then
b:=canvas.textwidth(ed.text)+10;
end;
end;
if b<>0  then
for a:=1 to 13 do
(findcomponent('Edit'+IntToStr(a)) as Tedit).Width:=b;

  reg.free;
paintbox2.Canvas.TextOut(2,1,'Betriebsystem:');
paintbox2.Canvas.TextOut(2,16,'Version:');
paintbox2.Canvas.TextOut(2,48,'Benutzter:');
paintbox2.Canvas.TextOut(2,64,'Organisation:');
paintbox2.Canvas.TextOut(2,80,'Seriennummer:');
paintbox2.Canvas.TextOut(2,96,'Kodenummer:');
paintbox2.Canvas.TextOut(2,112,'Arbeitsgruppe:');
paintbox2.Canvas.TextOut(2,128,'ComputerName:');
  try
Label18.Caption := 'BIOS Name: '+String(Pchar(pointer($FE061))); // BIOS Name
Application.ProcessMessages;
Label19.Caption := 'BIOS Datum: '+String(Pchar(pointer($FFFF5))); // BIOS Datum
Application.ProcessMessages;
Label20.Caption := 'BIOS Seriennummer: '+String(Pchar(Pointer($FEC71))); // Seriennummer
Application.ProcessMessages;
except
ShowMessage('Unbekannter Fehler beim BIOS zugrief');
end;

end;
end;

procedure TmainForm.Button19Click(Sender: TObject);
var reg:TRegistry;
begin
reg:=TRegistry.create;
reg.RootKey:=HKEY_LOCAL_MACHINE;
reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion',true);
reg.WriteString('RegisteredOwner',(findComponent('edit2') as TEdit ).text);
reg.WriteString('RegisteredOrganization',(findComponent('edit7') as TEdit).text);

reg.WriteString('ProductId',(findComponent('edit10')as Tedit).text);
reg.WriteString('ProductKey',(findComponent('edit11') as tedit).text);
reg.WriteString('ProductName',  (findComponent('edit12')as TEdit).text);
reg.WriteString('VersionNumber',(FindComponent('edit13') as TEdit).text);
reg.OpenKey('\System\CurrentControlSet\Services\VxD\VNETSUP',true);
if (findComponent('edit8')as TEdit).Visible then
reg.WriteString('Workgroup',(findComponent('edit8') as Tedit).Text);
if (findComponent('edit9') as Tedit).Visible then
reg.WriteString('ComputerName',(findComponent('edit9')as Tedit).Text);

reg.free;
end;



procedure TmainForm.CheckBox3Click(Sender: TObject);
begin
findTimer.Interval:=StrToIntDef(edit14.text,3000);
findTimer.Enabled:=CheckBox3.Checked;
end;

procedure TmainForm.Edit1Change(Sender: TObject);
var han:THandle;
    temp:cardinal;
    flags:integer;
    rect:TRect;
    classNameEdt:string;
    color:COLORREF;
    alpha:byte;
begin                       //TODO: remoive
  if mouseHandleEdt.text='' then exit;
try
  han:=Str2Cardinal(mouseHandleEdt.text);
  enabledCb.Checked:= IsWindowEnabled(han);
  visibleCb.Checked:= IsWindowVisible(han);
  unicodeCb.Checked:= IsWindowUnicode(han);
  case getshowwindow(han) of
    SW_MAXIMIZE:showStateCmb.ItemIndex:=2;
    SW_MINIMIZE:showStateCmb.ItemIndex:=1;
    else showStateCmb.ItemIndex:=0;
  end;
  windowtextEdt.Text:=getwindowtextS(han);
  Label12.Caption:=Cardinal2Str( GetWindowThreadProcessId(han,@temp));
  Label14.Caption:=Cardinal2Str( temp);
  classNameEdt:=getWindowClassNameToDisplay(han);
  labclassname.Caption:='Classname: '+classNameEdt;
//  parentwndEdt.text:=Cardinal2Str(windows.getparent(han));
  GetWindowRect(han,rect);
  windows.ScreenToClient(getParent(han),rect.TopLeft);
  windows.ScreenToClient(getParent(han),rect.BottomRight);
  posSizeEdt.text:=IntToStr(rect.left);
{  posYEdt.text:=IntToStr(rect.top);
  sizeXEdt.text:=IntToStr(rect.Right-rect.left);
  sizeYEdt.text:=IntToStr(rect.Bottom-rect.Top);}
  messagemes_cb.ItemIndex:=-1;
  messagemes_cb.Clear;
  classNameEdt:=UpperCase(classNameEdt);
  if (classNameEdt='EDIT')or(classNameEdt='RICHEDIT')or(classNameEdt='RICHEDIT_CLASS') then begin
    messagemes_cb.Items.Add('EM_SETPASSWORDCHAR');
    messagemes_cb.Items.Add('EM_LIMITTEXT');
  end;
  if (classNameEdt='COMBOBOX') then begin
    messagemes_cb.Items.Add('CB_ADDSTRING');
    messagemes_cb.Items.Add('CB_DELETESTRING');
    messagemes_cb.Items.Add('CB_SETDROPPEDWIDTH');
    messagemes_cb.Items.Add('CB_SETHORIZONTALEXTENT');
    messagemes_cb.Items.Add('CB_SETITEMHEIGHT');
  end;
  if (classNameEdt='LISTBOX') then begin
    messagemes_cb.Items.Add('LB_ADDSTRING');
    messagemes_cb.Items.Add('LB_DELETESTRING');
    messagemes_cb.Items.Add('LB_SETCOLUMNWIDTH');
    messagemes_cb.Items.Add('LB_SETHORIZONTALEXTENT');
    messagemes_cb.Items.Add('LB_SETITEMHEIGHT');
  end;
  if (classNameEdt='RICHEDIT')or(classNameEdt='RICHEDIT_CLASS') then begin
    messagemes_cb.Items.Add('EM_SETBKGNDCOLOR');
    messagemes_cb.Items.Add('EM_SETFONTSIZE');
    messagemes_cb.Items.Add('EM_SETZOOM');
    messagemes_cb.Items.Add('EM_SHOWSCROLLBAR');
  end;
  if (classNameEdt='SCROLLBAR') then begin
    messagemes_cb.Items.Add('SBM_SETRANGE');
  end;

except
  exit;
end;
end;

procedure TmainForm.windowPropertyChanged1(Sender: TObject);
begin
  changeProperty(sender);
end;

procedure TmainForm.FormCreate(Sender: TObject);
var reg:TRegistry;
    lb:LOGBRUSH  ;

begin

  LoadWNetEnumCachedPasswords;
//  desktopDC:=createDc('DISPLAY',nil,nil,nil);//getdc(GetDesktopWindow);
//     messageho
  runonNT:=Win32Platform=VER_PLATFORM_WIN32_NT;
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
{var mes:TBenMessages;
    handles:TIntArray;
    p:TPoint;
    i:integer;} //TODO: ???
begin
{if status=2 then begin
  status:=1;
  Screen.Cursor:=crDefault;
  GetCursorPos(p);
  handles:=getrealwindowsfrompoint(p);
  if length(handles)>1 then begin
    mes:=TBenMessages.Create(nil);
    try
      mes.Text.Caption:='Es wurden mehrere verschiedene Fenster an der aktuellen Position gefunden, sie können sich eines aussuchen:';
      for i:=0 to high(handles) do begin
        mes.list.Items.add('Handle: '+Cardinal2Str(handles[i])+'  Text: '+GetWindowTextS(handles[i])+'  Classname: '+GetWindowClassNameS(handles[i]));
      end;
      if mes.ShowModal=mrok then begin
        MAUSHANDLE:=handles[mes.list.itemindex];
        Timer1Timer(nil);
      end;
    finally
      mes.free;
    end;
  end;
  if mouseWindowFamily.Items.Count=0 then exit;
  mouseHandleEdt.text:=mouseWindowFamily.Items[0].Caption;
end;              }
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
procedure TmainForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
if (processidedit<>nil)and(ListView1.Selected<>nil) then
  processidedit.text:=ListView1.Selected.Caption;

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
  processidedit.Text:=Label14.Caption;
  PageControl1.ActivePage:=TabSheet3;
end;

procedure TmainForm.Button5Click(Sender: TObject);
begin
windowstyleform.han:=currentWindow;
windowstyleform.ShowModal;
end;

procedure TmainForm.ComboBox3Change(Sender: TObject);
begin
labwparam.Caption:='WParam (nicht benutzt):';
lablparam.Caption:='LParam (nicht benutzt):';
if messagemes_cb.text='EM_SETPASSWORDCHAR' then begin
  labwparam.Caption:='WParam (Char oder nichts):';
end else if messagemes_cb.text='EM_LIMITTEXT' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='CB_ADDSTRING' then begin
  lablparam.Caption:='LParam (String):';
end else if messagemes_cb.text='CB_DELETESTRING' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='CB_SETDROPPEDWIDTH' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='CB_SETHORIZONTALEXTENT' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='CB_SETITEMHEIGHT' then begin
  labwparam.Caption:='WParam (Integer):';
  lablparam.Caption:='LParam (Integer):';
end else if messagemes_cb.text='LB_ADDSTRING' then begin
  lablparam.Caption:='LParam (String):';
end else if messagemes_cb.text='LB_DELETESTRING' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='LB_SETCOLUMNWIDTH' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='LB_SETHORIZONTALEXTENT' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='LB_SETITEMHEIGHT' then begin
  labwparam.Caption:='WParam (Integer):';
  lablparam.Caption:='LParam (Integer):';
end else if messagemes_cb.text='EM_SETBKGNDCOLOR' then begin
  labwparam.Caption:='WParam (Integer):';
  lablparam.Caption:='LParam (Colorref (in Hex)):';
end else if messagemes_cb.text='EM_SETFONTSIZE' then begin
  labwparam.Caption:='WParam (Integer):';
end else if messagemes_cb.text='EM_SETZOOM' then begin
  labwparam.Caption:='WParam (Integer):';
  lablparam.Caption:='LParam (Integer):';
end else if messagemes_cb.text='EM_SHOWSCROLLBAR' then begin
  labwparam.Caption:='WParam (SB_HORZ oder SB_VERT):';
  lablparam.Caption:='LParam (true oder false):';
end else if messagemes_cb.text='SBM_SETRANGE' then begin
  labwparam.Caption:='WParam (Integer):';
  lablparam.Caption:='LParam (Integer):';
end ;
end;

//function InstallHookSendMessage(Hwnd: Cardinal;mes:cardinal;wp:WPARAM; lp:LPARAM): Boolean; stdcall; external 'hook.dll';
procedure TmainForm.Button8Click(Sender: TObject);
var han:THandle;
    wp:WPARAM;
    lp:LPARAM;
    mes:Cardinal;
    s:string;
begin
han:=Str2Cardinal(mouseHandleEdt.text);
mes:=0;
lp:=0;
wp:=0;
if messagemes_cb.text='EM_SETPASSWORDCHAR' then begin
  if messagewparam_edt.text='' then
    wp:=integer(messagewparam_edt.text[1]);
  mes:=EM_SETPASSWORDCHAR;
end;
if messagemes_cb.text='EM_LIMITTEXT' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=EM_LIMITTEXT;
end;
if messagemes_cb.text='CB_ADDSTRING' then begin
  s:=messagelparam_edt.text+#0;
  lp:=integer(addr(s[1]));
  mes:=CB_ADDSTRING;
end;
if messagemes_cb.text='CB_DELETESTRING' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=CB_DELETESTRING;
end;
if messagemes_cb.text='CB_SETDROPPEDWIDTH' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=CB_SETDROPPEDWIDTH;
end;
if messagemes_cb.text='CB_SETHORIZONTALEXTENT' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=CB_SETHORIZONTALEXTENT;
end;
if messagemes_cb.text='CB_SETITEMHEIGHT' then begin
  lp:=StrToInt(messagelparam_edt.text);
  wp:=StrToInt(messagewparam_edt.text);
  mes:=CB_SETITEMHEIGHT;
end;
if messagemes_cb.text='LB_ADDSTRING' then begin
  s:=messagelparam_edt.text+#0;
  lp:=integer(addr(s[1]));
  mes:=LB_ADDSTRING;
end;
if messagemes_cb.text='LB_DELETESTRING' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=LB_DELETESTRING;
end;
if messagemes_cb.text='LB_SETCOLUMNWIDTH' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=LB_SETCOLUMNWIDTH;
end;
if messagemes_cb.text='LB_SETHORIZONTALEXTENT' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=LB_SETHORIZONTALEXTENT;
end;
if messagemes_cb.text='LB_SETITEMHEIGHT' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=LB_SETITEMHEIGHT;
end;
if messagemes_cb.text='EM_SETBKGNDCOLOR' then begin
  wp:=StrToInt(messagewparam_edt.text);
  lp:=StrToInt('$'+messagelparam_edt.text);
  mes:=EM_SETBKGNDCOLOR;
end;
if messagemes_cb.text='EM_SETFONTSIZE' then begin
  wp:=StrToInt(messagewparam_edt.text);
  mes:=EM_SETFONTSIZE;
end;
if messagemes_cb.text='EM_SETZOOM' then begin
  wp:=StrToInt(messagewparam_edt.text);
  lp:=StrToInt(messagelparam_edt.text);
  mes:=EM_SETZOOM;
end;
if messagemes_cb.text='EM_SHOWSCROLLBAR' then begin
  if pos('VERT',uppercase(messagewparam_edt.text))>0 then
    wp:=sb_vert
   else
    wp:=sb_horz;
  if (uppercase(messagelparam_edt.text)='true')or(messagelparam_edt.text='1') then
    lp:=word(true)
   else
    lp:=word(false);
  mes:=EM_SHOWSCROLLBAR;
end;
if messagemes_cb.text='SBM_SETRANGE' then begin
  wp:=StrToInt(messagewparam_edt.text);
  lp:=StrToInt(messagelparam_edt.text);
  mes:=SBM_SETRANGE;
end;

{if messagemes_cb.text='EM_LIMITTEXT' then begin
  lp:=0;
  wp:=StrToInt(messagewparam_edt.text);
  mes:=EM_LIMITTEXT;
end;
if messagemes_cb.text='EM_LIMITTEXT' then begin
  lp:=0;
  wp:=StrToInt(messagewparam_edt.text);
  mes:=EM_LIMITTEXT;
end;
if messagemes_cb.text='EM_LIMITTEXT' then begin
  lp:=0;
  wp:=StrToInt(messagewparam_edt.text);
  mes:=EM_LIMITTEXT;
end;
if mes<>0 then
  if hookcheck.Checked then
    InstallHookSendMessage(han,mes,wp,lp)
   else
    messagemes_cb(han,mes,wp,lp);}
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

