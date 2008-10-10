{$undef RESSTRSECTIONS}
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
unit processList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls,TreeListView,StdCtrls,LDockCtrl,windowcontrolfuncs, Menus;

type

  { TprocessListFrm }

  TprocessListFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    killProcessbtn: TButton;
    listWindows: TButton;
    ComboBox2: TComboBox;
    displayProcesses: TButton;
    memScrolledAddress: TEdit;
    Label6: TLabel;
    memScreen: TPaintBox;
    memScroll: TScrollBar;
    memStat: TPanel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    ramMinEdt: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Splitter1: TSplitter;
    starttimeedt: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Panel5: TPanel;
    processidedit: TEdit;
    kerneltimeedt: TEdit;
    autorefreshtimer: TTimer;
    usertimeedt: TEdit;
    ramMaxEdt: TEdit;
    procedure autorefreshtimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure killProcessbtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure displayProcessesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure listWindowsClick(Sender: TObject);
    procedure memScreenClick(Sender: TObject);
    procedure memScreenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure memScreenPaint(Sender: TObject);
    procedure memScreenResize(Sender: TObject);
    procedure memScrolledAddressChange(Sender: TObject);
    procedure memScrollScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure processideditChange(Sender: TObject);
    procedure processTreeListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure processTreeListSelect(sender: TObject; item: TTreeListItem);
  private
    { private declarations }
    procedure showHandle(sender:tobject; wnd: THandle;func:longint);
    processTreeList: TTreeListView;
  public
    { public declarations }
    //Processliste
    callback: TCallbackComponent;
    Docker: TLazControlDocker;
    pageInfos: array of TPageInfo;
    pageSize,memScreenLineLength: longint;
  end;

var
  processListFrm: TprocessListFrm;
  processIconCache: TImageList;
  processIconCacheNames: TStringList;


implementation

uses applicationConfig, windows,TLHelp32,proc9,bbutils,math,ptranslateutils,Translations;

{$I processlist.atr}

const BELOW_NORMAL_PRIORITY_CLASS=$4000;
      ABOVE_NORMAL_PRIORITY_CLASS=$8000;
      PAGE_ICON_SIZE = 5;
{ TprocessListFrm }

function ExtractIconExA(  lpszFile:LPCTSTR ;  nIconIndex:longint;  phiconLarge:PHANDLE;  phiconSmall:PHANDLE;  nIcons:UINT ):uint; stdcall;external 'shell32.dll';

procedure TprocessListFrm.displayProcessesClick(Sender: TObject);
type
  TProcess32FN = FUNCTION(hSnapshot: DWORD; VAR lppe: tagPROCESSENTRY32): BOOL; stdcall;
  TCreateTHSnap = FUNCTION(dwFlags, th32ProcessID: DWORD): DWORD; stdcall;
  TGetModuleFileNameEx = function(hProcess:HANDLE ;  hModule:HMODULE ;  lpFilename:LPTSTR ;  nSize:DWORD):longint; stdcall;
VAR
  hKernel, hProcessSnap: DWORD;
  CreateToolhelp32Snapshot: TCreateTHSnap;
  Process32First, Process32Next: TProcess32FN;
  GetModuleFileNameEx: TGetModuleFileNameEx;
  pe32: tagProcessEntry32;
  noerr: bool;
  procedure makeSnapshot;//mostly taken from Assarbad
  BEGIN
    //init variables
  //  hKernel := 0;
    hProcessSnap := dword(-1);

    CreateToolhelp32Snapshot := NIL;
    Process32First := NIL;
    Process32Next := NIL;

    //I still don't understand, WHY 'kernel32.dll' is always loaded ;)
    hKernel := GetModuleHandle('KERNEL32.DLL');
    IF BOOL(hKernel) THEN BEGIN
      CreateToolhelp32Snapshot := TCreateTHSnap(GetProcAddress(hKernel, 'CreateToolhelp32Snapshot'));
      Process32First := TProcess32FN(GetProcAddress(hKernel, 'Process32First'));
      Process32Next := TProcess32FN(GetProcAddress(hKernel, 'Process32Next'));
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
  tempBitmap: graphics.TBITMAP;
  fullPath: ansistring;
  fullPathUTF8: UTF8String;
  curProcess,processIcon: THANDLE;
  selected: string;
BEGIN
  if processTreeList=nil then exit;//wtf??
  selected:=processidedit.Text;
  processTreeList.BeginUpdate;
  //processTreeList.multiSelect:=true;
  processTreeList.items.clear;
  makeSnapshot;
  if hProcessSnap=dword(-1) then exit;
  if not  Process32First(hProcessSnap, pe32) then exit;

  GetModuleFileNameEx:=nil;
  if runonNT then
    GetModuleFileNameEx:=TGetModuleFileNameEx(GetProcAddress(LoadLibrary('psapi.dll'),'GetModuleFileNameExA')); //no need to free psapi.dll, it will be freed at program end


  tempBitmap:=graphics.TBITMAP.Create;
  tempBitmap.SetSize(processIconCache.Width,processIconCache.Height);
  repeat
    //get id/name
    parentItem:=processTreeList.Items.FindItemWithRecordText(Cardinal2Str(pe32.th32ParentProcessID),1);
    item:=processTreeList.Items.Add(parentItem,ExtractFileName(string(SysToUTF8(pe32.szExeFile))));
    item.recordItems.Add(Cardinal2Str(pe32.th32ProcessID));
    //item.recordItems.AddWithText(string(pe32.szExeFile));

    //get priority
    ttt:='';
    prio:=GetProcessPriority( pe32.th32ProcessID);
    if prio=HIGH_PRIORITY_CLASS then ttt:=tr['hoch'];
    if prio=IDLE_PRIORITY_CLASS then ttt:=tr['niedrig'];
    if prio=BELOW_NORMAL_PRIORITY_CLASS then ttt:=tr['unter normal'];
    if prio=NORMAL_PRIORITY_CLASS then ttt:=tr['normal'];
    if prio=ABOVE_NORMAL_PRIORITY_CLASS then ttt:=tr['über normal'];
    if prio=REALTIME_PRIORITY_CLASS then ttt:=tr['echtzeit'];
    ttt:=ttt+'('+Cardinal2Str(prio)+')';
    item.recordItems.Add(ttt);


//    item.recordItems.AddWithText(inttostr(pe32.cntUsage));// string(pe32.szExeFile));
    //get thread count
    item.recordItems.Add(inttostr(pe32.cntThreads));// string(pe32.szExeFile));

    //get full file path
    //#todo -1: check on 64bit
    if assigned(GetModuleFileNameEx) then begin
      curProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, pe32.th32ProcessID);
      SetLength(fullPath,256);
      if curProcess<>0 then begin
        i:=GetModuleFileNameEx(curProcess, 0, @fullpath[1], length(fullPath)-2);
        setlength(fullpath,i);
      end else fullPath:=pe32.szExeFile; //better than nothing
      CloseHandle(curProcess);
    end else fullPath:=pe32.szExeFile;//full path on 9x
    fullPathUTF8:=SysToUTF8(fullPath);
    ITEm.RecordItems.Add(fullPathUTF8);

    //get icon
    ITEM.ImageIndex:=processIconCacheNames.IndexOf(lowercase(fullPathUTF8));
    if ITEM.ImageIndex>=0 then ITEM.ImageIndex:=longint(processIconCacheNames.Objects[ITEM.ImageIndex])
    else begin
      ExtractIconExA(pchar(fullpath),0,nil,@processIcon,1);    //#todo -1 :find a way read the process icon from memory
      if processIcon=0 then item.ImageIndex:=-1
      else begin
        tempBitmap.Canvas.brush.color:=clwhite;
        tempBitmap.Canvas.rectangle(-1,-1,tempBitmap.Width+2,tempBitmap.Height+2);
        DrawIconEx(tempBitmap.Canvas.Handle,0,0,processIcon,tempBitmap.width,tempBitmap.Height,0,0,DI_IMAGE or DI_MASK);
        item.ImageIndex:=processIconCache.Add(tempBitmap,nil);
        //DestroyIcon(tempIcon.handle);
      end;
      processIconCacheNames.AddObject(LowerCase(fullPathUTF8),tobject(item.ImageIndex));
    end;
  until not Process32Next(hProcessSnap, pe32);
  tempBitmap.free;
  CloseHandle(hProcessSnap);
  processTreeList.EndUpdate;

  parentitem:=processTreeList.Items.FindItemWithRecordText(selected,1);
  if parentitem<>nil then processTreeList.Selected:=parentItem;
  processideditChange(nil);
end;

procedure TprocessListFrm.FormCreate(Sender: TObject);
var i,j,TableID,TableCount:longint;
begin
  initUnitTranslation('processlist',tr);
  tr.translate(self);
  //Processliste
  processTreeList:= TTreeListView.create(self);
  processTreeList.Visible:=true;
  processTreeList.Align:=alClient;
  processTreeList.OnSelect:=@processTreeListSelect;
  processTreeList.OnKeyDown:=@processTreeListKeyDown;
{  processTreeList.OnExpandItem:=processTreeListExpandItem;
  windowListKeyUp;

  processTreeList.OnDblClick:=windowListDblClick;}
  processTreeList.Options:=processTreeList.Options+[tlvoSorted,tlvoColumnsDragable];
  processTreeList.Columns.clear;
  processTreeList.Columns.add.Text:=tr['Programm'];
  processTreeList.Columns[0].Width:=180;
  with processTreeList.Columns.Add do begin
    text:='PID';
    Width:=40;
  end;
  with processTreeList.Columns.Add do begin
    text:=tr['Priorität'];
    Width:=100;
  end;
  with processTreeList.Columns.Add do begin
    text:=tr['Threads'];
    Width:=40;
  end;
  with processTreeList.Columns.Add do begin
    text:=tr['Pfad'];
    Width:=200;
  end;
  processTreeList.RowHeight:=16;
  processTreeList.Parent:=self;
  processTreeList.CreateSearchBar();

  if processIconCache = nil then begin  //GUI is always single threaded
    processIconCache:=TImageList.Create(nil); //#TODO -1: remove unnecessary icons
    processIconCacheNames:=TStringList.Create;
    processIconCache.Width:=16;
    processIconCache.height:=16;
  end;
  processTreeList.Images:=processIconCache;
  processTreeList.PopupMenu:=PopupMenu1;

  Docker:=TLazControlDocker.Create(Self);
  callback:=TCallbackComponent.create(self);
  callback.onShowHandle:=@showHandle;
  Panel5.Height:=Panel5.Constraints.MinHeight;

end;

procedure TprocessListFrm.FormDestroy(Sender: TObject);
begin
  processTreeList.Free;
end;

procedure TprocessListFrm.FormShow(Sender: TObject);
begin
  displayProcessesClick(nil);
end;

procedure TprocessListFrm.listWindowsClick(Sender: TObject);
begin
  callback.showHandle(Str2Cardinal(processidedit.Text),WINDOWLISTFRM_ID,1);
end;

procedure TprocessListFrm.memScreenClick(Sender: TObject);
begin

end;

procedure TprocessListFrm.memScreenMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var s:string;
    p:longint;
begin
  p:=memScreenLineLength * (memScroll.Position+y div PAGE_ICON_SIZE)+x div PAGE_ICON_SIZE;
  if (p<0)or(p>=high(pageInfos)) then begin
    memscreen.hint:='';
    exit;
  end;
  s:=Cardinal2Str(longword(p)*longword(pageSize))+'-'+Cardinal2Str(longword(p)*longword(pageSize)+longword(pageSize-1))+': ';
  case pageInfos[p] of
    piFree: s+=tr['frei'];
    piReserved: s+=tr['nur reserviert'];
    piNoAccess: s+=tr['kein Zugriff'];
    piReadOnly: s+=tr['nur lesbar'];
    piReadWrite: s+=tr['les/beschreibbar'];
    piWriteCopy: s+=tr['les/beschreibbar, schreiben erzeugt Kopie'];
    piExecute: s+=tr['ausführbar'];
    piExecuteRead: s+=tr['ausführbar, lesbar'];
    piExecuteReadWrite: s+=tr['ausführbar, les/beschreibar'];
    piExecuteWriteCopy: s+=tr['ausführbar, les/beschreibar, schreiben erzeugt Kopie'];
    {piUnknown,}else s+=tr['unbekannt'];
  end;
  memScreen.Hint:=s;
end;

procedure TprocessListFrm.memScreenPaint(Sender: TObject);
var x,y,i:longint;
    page:TPageInfo;
begin
  if (memStat.height<5) or (length(pageInfos)=0) then exit;
  x:=0;
  y:=0;
  i:=memScreenLineLength * (memScroll.Position+2+memScreen.height div PAGE_ICON_SIZE);
  if i>high(pageInfos) then i:=high(pageInfos);
  memScreen.Canvas.pen.color:=clBlack;
  for i:=memScroll.Position*memScreenLineLength to i do begin
    page:=pageInfos[i];
    memScreen.Canvas.Brush.Color:=pageInfoColors[page];
    memScreen.Canvas.Rectangle(x,y,x+PAGE_ICON_SIZE,y+PAGE_ICON_SIZE);
    if x+PAGE_ICON_SIZE>=memScreen.width then begin
      x:=0;
      y:=y+PAGE_ICON_SIZE;
    end else x:=x+PAGE_ICON_SIZE;
  end;
  memScreen.Canvas.brush.color:=clBlack;
  memScreen.Canvas.Rectangle(x,y,memScreen.Width,y+PAGE_ICON_SIZE);
  memScreen.Canvas.Rectangle(0,y+PAGE_ICON_SIZE,memScreen.Width,memScreen.Height);
end;

procedure TprocessListFrm.memScreenResize(Sender: TObject);
begin
  if (memStat.Height > 0) and (memScreen.width>0) then begin
    memScreenLineLength:=(memScreen.width+PAGE_ICON_SIZE) div PAGE_ICON_SIZE;
    memScroll.Max:=length(pageInfos) div memScreenLineLength;
  end else memScreenLineLength:=1;
end;

procedure TprocessListFrm.memScrolledAddressChange(Sender: TObject);
begin
  memScroll.Position:=Str2Cardinal(memScrolledAddress.Text)div memScreenLineLength;
  memScreenPaint(nil);
end;

procedure TprocessListFrm.memScrollScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  memScrolledAddress.Text:=Cardinal2Str(memScroll.Position*memScreenLineLength);
  //memScreenPaint(nil);
end;

procedure TprocessListFrm.MenuItem1Click(Sender: TObject);
begin
  killProcessbtn.Click;
end;

procedure TprocessListFrm.MenuItem2Click(Sender: TObject);
begin
  listWindows.Click;
end;

procedure TprocessListFrm.MenuItem3Click(Sender: TObject);
begin
  displayProcesses.Click;
end;

procedure TprocessListFrm.processideditChange(Sender: TObject);
type
  TPROCESS_MEMORY_COUNTERS = record
    cb : DWORD;
    PageFaultCount : DWORD;
    PeakWorkingSetSize : SIZE_T;
    WorkingSetSize : SIZE_T;
    QuotaPeakPagedPoolUsage : SIZE_T;
    QuotaPagedPoolUsage : SIZE_T;
    QuotaPeakNonPagedPoolUsage : SIZE_T;
    QuotaNonPagedPoolUsage : SIZE_T;
    PagefileUsage : SIZE_T;
    PeakPagefileUsage : SIZE_T;
  end;
  TGetProcessMemoryInfo=function(Process:HANDLE;var ppsmemCounters:TPROCESS_MEMORY_COUNTERS;cb:DWORD):boolean;stdcall;

  function formatFileTimeInterval(const ft: tfiletime):string;
  var time:int64;
  begin
    time:=int64(ft.dwHighDateTime) shl 32 or ft.dwLowDateTime;
    time:=time div 10 div 1000;//->ms
    result:='';
    if time>=3600*1000 then begin
      result:=result+IntToStr(time div 3600000)+':';
      time:=time mod 3600000;
    end;
    if (time>60*1000) or (result<>'') then begin
      result:=result+format('%.2u:',[time div 60000]);
      time:=time mod 60000;
    end;
    if (time>1000) or (result<>'') then begin
      result:=result+format('%.2u',[time div 1000]);
      time:=time mod 1000;
    end;
    result:=result+format('.%.4u',[time]);
  end;
var curProcess: thandle;
    creationTime,exittime,kerneltime,userTime: tfiletime;
    GetProcessMemoryInfo: TGetProcessMemoryInfo;
    memInfo: TPROCESS_MEMORY_COUNTERS;
begin
  if processidedit.text='' then exit;
  try
    curProcess:=OpenProcess(PROCESS_QUERY_INFORMATION,false,Str2Cardinal(processidedit.text));
  except
    on EConvertError do exit;
  end;
  startTimeEdt.text:='';
  kernelTimeEdt.text:='';
  userTimeEdt.text:='';
  ramMinEdt.Text:='';
  ramMaxEdt.Text:='';
  case GetProcessPriority(Str2Cardinal(processidedit.text)) of
    IDLE_PRIORITY_CLASS: ComboBox2.ItemIndex:= 0;
    HIGH_PRIORITY_CLASS: ComboBox2.ItemIndex:= 4;
    REALTIME_PRIORITY_CLASS: ComboBox2.ItemIndex:= 5;
    BELOW_NORMAL_PRIORITY_CLASS:ComboBox2.ItemIndex:= 1;
    ABOVE_NORMAL_PRIORITY_CLASS:ComboBox2.ItemIndex:= 3;
    else ComboBox2.ItemIndex:= 2;
  end;
  if curProcess=0 then exit;
  try


    GetProcessTimes(curProcess,creationTime,exittime,kernelTime,userTime);
    startTimeEdt.text:=datetimetostr(fileTimeToDateTime(creationTime));
    kerneltimeedt.text:=formatFileTimeInterval(kernelTime);
    usertimeedt.text:=formatFileTimeInterval(usertime);
    if processTreeList.items.FindItemWithRecordText(processidedit.text,1)<>nil then
      processTreeList.selected:=processTreeList.items.FindItemWithRecordText(processidedit.text,1);

    GetProcessMemoryInfo:=TGetProcessMemoryInfo(GetProcAddress(LoadLibrary('psapi.dll'),'GetProcessMemoryInfo'));
    if assigned(GetProcessMemoryInfo) then begin
      FillChar(memInfo,sizeof(memInfo),0);
      memInfo.cb:=sizeof(memInfo);
      GetProcessMemoryInfo(curProcess, memInfo,sizeof(memInfo));
      ramMinEdt.text:=strFromSize( memInfo.PagefileUsage);
      ramMaxEdt.text:=strFromSize( memInfo.PeakWorkingSetSize);
    end;
{    GetProcessWorkingSetSize(curProcess,minRam,maxRam);
    ramMinEdt.Text:=IntToStr(minRam);
    ramMaxEdt.Text:=IntToStr(maxRam);     }
    Panel5.Height:=Panel5.Constraints.MinHeight;
  finally
    CloseHandle(curProcess);
  end;
end;

procedure TprocessListFrm.processTreeListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    vk_f5: displayProcesses.Click;
    VK_DELETE: killProcessbtn.click;
  end;
end;

procedure TprocessListFrm.processTreeListSelect(sender: TObject;
  item: TTreeListItem);
begin
  processidedit.Text:=item.RecordItemsText[1];
end;

procedure TprocessListFrm.showHandle(sender: tobject; wnd: THandle;func:longint);
begin
  processidedit.Text:=Cardinal2Str(wnd);
end;

procedure TprocessListFrm.killProcessbtnClick(Sender: TObject);
begin
  KillProcess(Str2Cardinal(processidedit.text));
  Application.ProcessMessages;sleep(200);
  displayProcesses.Click;
end;

procedure TprocessListFrm.Button2Click(Sender: TObject);
var i,temp:longint;
begin
  for i:=memScreenLineLength * (memScroll.Position+memScreen.height div PAGE_ICON_SIZE) to high(pageInfos) do
    if not (pageInfos[i] in [piFree,piReserved,piNoAccess]) then begin
      memScroll.Position:=i div memScreenLineLength;
      temp:=memScroll.Position;
      memScrollScroll(nil,scPosition,temp);
      exit;
    end;
end;

procedure TprocessListFrm.ComboBox2Change(Sender: TObject);
begin

end;

procedure TprocessListFrm.Button1Click(Sender: TObject);
var sysInfo: TSYSTEMINFO;
    curProcess: THANDLE;
    i,j,address: longword;
    meminfo: TMEMORYBASICINFORMATION;
begin
  GetSystemInfo(sysInfo);
  pageSize:=sysInfo.dwPageSize;
  curProcess:=OpenProcess(PROCESS_QUERY_INFORMATION,false,Str2Cardinal(processidedit.text));
  if curProcess=0 then exit;
  setlength(pageInfos,4*1024*1024*1024 div pageSize+1);
  i:=0;
  while i<=high(pageInfos) do begin
    VirtualQueryEx(curProcess,pointer(i*pageSize),memInfo,sizeof(meminfo));
    pageInfos[i]:=piUnknown;
    if meminfo.State=MEM_FREE then pageInfos[i]:=piFree
    else if meminfo.State=MEM_RESERVE then pageInfos[i]:=piReserved
    else if meminfo.State=MEM_COMMIT then
      case memInfo.Protect of
        PAGE_NOACCESS: pageInfos[i]:=piNoAccess;
        PAGE_READONLY: pageInfos[i]:=piReadOnly;
        PAGE_READWRITE:pageInfos[i]:=piReadWrite;
        PAGE_WRITECOPY:pageInfos[i]:=piWriteCopy;
        PAGE_EXECUTE:pageInfos[i]:=piExecute;
        PAGE_EXECUTE_READ:pageInfos[i]:=piExecuteRead;
        PAGE_EXECUTE_READWRITE:pageInfos[i]:=piExecuteReadWrite;
        PAGE_EXECUTE_WRITECOPY:pageInfos[i]:=piExecuteWriteCopy;
      end;
    if meminfo.RegionSize>=MAXINT then inc(i)
    else begin
      meminfo.RegionSize:=meminfo.RegionSize div PAGESize+i-1;
      if meminfo.RegionSize>=length(pageInfos) then meminfo.RegionSize:=high(pageInfos);
      for j:=i+1 to meminfo.RegionSize do
        pageInfos[j]:=pageInfos[i];
      i:=j;
    end;
  end;


  memScroll.Position:=0;
  memScreen.Invalidate;

  CloseHandle(curProcess);
  Panel5.Height:=Panel5.Constraints.MinHeight+200;
end;

procedure TprocessListFrm.autorefreshtimerTimer(Sender: TObject);
begin
  if defaultRefreshTimeInterval=0 then exit;
  autorefreshtimer.Interval:=defaultRefreshTimeInterval;
  displayProcesses.Click;
end;

procedure TprocessListFrm.ComboBox2Select(Sender: TObject);
var x,prio:cardinal;
begin
  if runonNT then
    SetPrivilege(SE_DEBUG_NAME,true);
  x:=OpenProcess(PROCESS_SET_INFORMATION,false, Str2Cardinal(processidedit.text));
  case ComboBox2.ItemIndex of
  //  1:prio:=NORMAL_PRIORITY_CLASS;
    0: prio:=IDLE_PRIORITY_CLASS;
    1: prio:=BELOW_NORMAL_PRIORITY_CLASS;
    3: prio:=ABOVE_NORMAL_PRIORITY_CLASS;
    4: prio:=HIGH_PRIORITY_CLASS;
    5: prio:=REALTIME_PRIORITY_CLASS;
    else prio:=NORMAL_PRIORITY_CLASS;
  end;
  SetPriorityClass(x,prio);
  closeHandle(x);
  if runonNT then
    SetPrivilege(SE_DEBUG_NAME,false);
  //update all
  displayProcesses.Click;

end;

initialization
  {$I processlist.lrs}
  TranslateUnitResourceStrings('processlist','i18n\apim.de.po');
finalization
  FreeAndNil(processIconCache);
  FreeAndNil(processIconCacheNames);
end.

