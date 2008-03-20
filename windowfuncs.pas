unit windowfuncs;

interface
{$mode delphi}{$h+}
uses Windows,classes,forms,tlhelp32,messages{,sysutils,dialogs};
const
   EM_SETBKGNDCOLOR=1091;
   EM_SHOWSCROLLBAR=WM_USER + 96;
   EM_SETZOOM=WM_USER + 225;
   EM_SETFONTSIZE=WM_USER + 223;
const
  // Use crKey as the transparency color.
  LWA_COLORKEY = 1;
  // Use bAlpha to determine the opacity of the layered window..
  LWA_ALPHA = 2;
  WS_EX_LAYERED = $80000;

type THandleTemp=record
  handle:HWND;
  temp:integer;
end;
type TIntArray=array of integer;
type THandleTempArray=array of THandleTemp;
type TIntList=class
  arra:TIntArray;
  procedure Add(const i:integer);
  constructor Create;
  destructor destroy;override;
end;
function LoadFuncFromDLL(dll,func:pchar):pointer;

function EnumWindowsToIntList(parent:HWND;subChilds:boolean):TIntArray; //Liefert die Handles sämtlicher Top-Level-Fenster in einem Array zurück
function GetRealWindowFromPoint(p:TPoint; ignoreOurWindows:boolean=false):THANDLE; //Findet das Fenster an der Position p. Entspricht der Funktion von EDA 6.0f (funktionieren beide nicht richtig)
function GetRealWindowsFromPoint(p:TPoint):TIntArray; //Findet alle Fenster an der Position p. Hat den Vorteil gegenüber GetRealWindowFromPoint, das es auf jeden Fall geht ;-)
function GetWindowTextS(handle:HWND):string; //Entspricht GetWindowText, nur liefert es einen String zurück
function GetWindowClassNameS(handle:HWND):string; //Entspricht GetClassName, nur liefert es einen String zurück
function GetShowWindow(handle:hwnd):integer;//Liefert SW_MAXIMIZE bei maximierten, SW_MINIMIZE bei minimierten und SW_NORMAL bei normalen Fenstern zurück.
function GetFileNameFromHandle(Handle: hwnd):string;//Von Leo, liefert den Dateinamen eines WIndows zurück

function GetWindowPosStr(handle: hwnd): string;//Liefert formatierten String (l,t)-(r,b)
procedure toggleWindowMarkStatus(handle: hwnd);

function GetWindowAlphaColorKey(wnd:HWND;var color:COLORREF;var alpha:Byte;var Flags:Longint):boolean;//Liefert transparents Informationen
function GetWindowColorKey(wnd:HWND):COLORREF; //Liefert eine einzige Transparentsinformation (ColorKey), benutzt GetWindowAlphaColorKey
function GetWindowAlpha(wnd:HWND):byte; //Liefert eine einzige Transparentsinformation , benutzt GetWindowAlphaColorKey
function GetWindowLayeredFlags(wnd:HWND):integer; //Liefert eine einzige Transparentsinformation , benutzt GetWindowAlphaColorKey

function SetLayeredWindowAttributes(wnd: HWND; crKey: COLORREF; bAlpha: Byte; dwFlags: Longint): boolean;

(* //set both at the same time!!!
function MakeWndTrans(Wnd: HWND; bAlpha: Integer = 240): Boolean;
function MakeWndOpaque(wnd:HWND):boolean;//Macht ein Fenster undurchlässig

function MakeWndColorKeyOn(Wnd: HWND; color:COLORREF): Boolean;
function MakeWndColorKeyOff(Wnd: HWND): Boolean;
*)

implementation
uses unit1,sysutils;
function LoadFuncFromDLL(dll,func:pchar):pointer;
var
  hUser32: HMODULE;
begin
  hUser32 := GetModuleHandle(dll);
  if hUser32 <> 0 then
  begin
  result := GetProcAddress(hUser32,func);
  end
  else
  result:=nil;
end;
procedure TIntList.Add(const i:integer);
var len:integer;
begin
  len:=length(arra);
  setlength(arra,len+1);
  arra[len]:=i;
end;
constructor TIntList.Create;
begin
  setlength(arra,0);
end;
destructor TIntList.destroy;
begin
  setlength(arra,0);
  inherited;
end;


type TEnumChildWindowsProcParameters = record
      parent:hwnd;
      list:TIntList;
    end;
    PEnumChildWindowsProcParameters=^TEnumChildWindowsProcParameters;
function EnumWindowsProc(handle:hwnd;lP:LPARAM):boolean;stdcall;
var List:TIntList;
begin
  list:=TIntList(lp);
  list.add(handle);
  result:=true;
end;
function EnumChildWindowsProc(handle:hwnd;data:PEnumChildWindowsProcParameters):boolean;stdcall;
begin
  if (data^.parent=0) or (GetParent(handle)=data^.parent) then
    data^.list.Add(handle);
  result:=true;
end;

function EnumWindowsToIntList(parent:HWND;subChilds:boolean):TIntArray;
var list:TIntList;
    childData: ^TEnumChildWindowsProcParameters;
begin
  list:=TIntList.create;
  try
    if parent=0 then EnumWindows(@EnumWindowsProc,lparam(list))
    else begin
      new(childData);
      if subChilds then childData^.parent:=0
      else childData^.parent:=parent;
      childData^.list:=list;
      EnumChildWindows(parent,@EnumChildWindowsProc,lparam(childData));
      dispose(childData);
    end;
  finally
    result:=list.arra;
    list.free;
  end;
end;

type TPointResult=record
  point:TPoint;
  result:THandle;
  diff:cardinal;
  rect:TRect;
end;
PPointResult=^TPointResult;


function EnumWindowsChildProc(handle:hwnd;lP:LPARAM):boolean;stdcall;
var
  pr:TPointResult;
  rect:TRect;
  ndiff:cardinal;
begin
  pr:=tpointresult(pointer(lp)^);
  GetWindowRect(handle,rect);
  result:=true;
  if not (PtInRect(rect,pr.point) and (IsWindowVisible(handle))) then  exit;
      ndiff:=abs(rect.Right-rect.left)+abs(rect.Bottom-rect.Top);
      if (ndiff < tpointresult(pointer(lp)^).diff) then begin
        tpointresult(pointer(lp)^).result:=handle;
        tpointresult(pointer(lp)^).diff:=ndiff;
        //EnumChildWindows(handle,@EnumWindowsChildProc,lp);
      end;
end;

function RealWindowFromPointEnumWindowsProc(wnd:HWND; pr: PPointResult):WINBOOL;stdcall;
var q:TPoint;
    r:TRect;
begin
  if not IsWindowVisible(wnd) then exit(true);
  if GetWindowThreadProcessId(wnd,0)=MainThreadID then exit(true);//skip ours
  GetWindowRect(wnd,r);
  q:=pr.point;
  if (q.x<r.left) or (q.y<r.top) or (q.x>r.Right) or (q.y>r.Bottom) then
    exit(true);
  ScreenToClient(wnd,q);
  pr.result:=ChildWindowFromPointEx(wnd,q,CWP_SKIPINVISIBLE);
  if pr.result=0 then pr.result:=wnd;
  result:=pr.result=0;
end;

function GetRealWindowFromPoint(p:TPoint; ignoreOurWindows:boolean=false):THANDLE;
var
    pr:TPointResult;
begin
  pr.Result:=WindowFromPoint(p);
  if pr.result=0 then exit(0);
  if ignoreOurWindows and (GetWindowThreadProcessId(pr.result,0)=MainThreadID) then begin
     pr.point:=p;
     EnumWindows(@RealWindowFromPointEnumWindowsProc,lparam(@pr));
  end;
  if GetWindowLong(pr.result,GWL_STYLE) and ws_child = ws_child then begin
    pr.point:=p;
    pr.diff:=MAXLONG;
    EnumChildWindows(getparent(pr.result),@EnumWindowsChildProc,integer(@pr));
  end;
  result:=pr.result;
end;

function GetRealWindowsFromPoint(p:TPoint):TIntArray;
type TPointResult=record
  point:TPoint;
  result:THandleTempArray;
  rect:TRect;
end;
var
    pr:TPointResult;
  function EnumWindowsChildProc(handle:hwnd;lP:LPARAM):boolean;stdcall;
  var
    pr:TPointResult;
    rect:TRect;
    ndiff,i,lengthpr:cardinal;
    temp:THandleTemp;
    tausch:boolean;
  begin
    pr:=tpointresult(pointer(lp)^);
    GetWindowRect(handle,rect);
    result:=true;
    if not (PtInRect(rect,pr.point) and (IsWindowVisible(handle))) then  exit;
      setlength(tpointresult(pointer(lp)^).result,length(pr.result)+1);
      ndiff:=abs(rect.Right-rect.left)+abs(rect.Bottom-rect.Top);
      lengthpr:=length(pr.result);
      tpointresult(pointer(lp)^).result[lengthpr].handle:=handle;
      tpointresult(pointer(lp)^).result[lengthpr].temp:=ndiff;
      tausch:=true;
      while tausch do begin
        tausch:=false;
        for i:=1 to lengthpr do begin
          if tpointresult(pointer(lp)^).result[i-1].temp>tpointresult(pointer(lp)^).result[i].temp then begin
            temp:=tpointresult(pointer(lp)^).result[i-1];
            tpointresult(pointer(lp)^).result[i-1]:=tpointresult(pointer(lp)^).result[i];
            tpointresult(pointer(lp)^).result[i]:=temp;
            tausch:=true;
          end;
        end;
      end;
//        if (ndiff < tpointresult(pointer(lp)^).diff) then begin
{          tpointresult(pointer(lp)^).result:=handle;
          tpointresult(pointer(lp)^).diff:=ndiff;}
          //EnumChildWindows(handle,@EnumWindowsChildProc,lp);
  //      end;
  end;
var i:integer;
begin

  setlength(result,1);
  result[0]:=WindowFromPoint(p);
  if GetWindowLong(result[0],GWL_STYLE) and ws_child = ws_child then begin
   // setlength(result,0);
    pr.point:=p;
//    pr.diff:=MAXLONG;}
    setlength(pr.result,0);
    EnumChildWindows(getparent(result[0]),@EnumWindowsChildProc,integer(@pr));
    setlength(Result,length(pr.Result));
    for i:=0 to high(pr.Result) do begin
      result[i]:=pr.Result[i].handle;
    end;
  end;
end;



function GetWindowTextS(handle:HWND):string;
var text:array[0..255] of char;
begin
  GetWindowText(handle,text,255);
  result:=text;
end;

function GetWindowClassNameS(handle:HWND):string;
var text:array[0..255] of char;
begin
  GetClassName(handle,text,255);
  result:=text;
end;

function GetShowWindow(handle:hwnd):integer;
begin
  if IsZoomed(handle) then
    result:=SW_MAXIMIZE
   else if IsIconic(handle) then
    Result:=SW_MINIMIZE
   else
    Result:=SW_NORMAL; 
end;


//Diese Funktionist von Leo, alle Credits gehen zu ihm!!!!!!!!!!!!!!!
//Leo: www.leoworld.de; leo@leoworld.de
function GetFileNameFromHandle(Handle: hwnd):string;
var
	PID: DWord;
	aSnapShotHandle: THandle;
	ContinueLoop: Boolean;
	aProcessEntry32: TProcessEntry32;
begin
GetWindowThreadProcessID(Handle, @PID);
aSnapShotHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
aProcessEntry32.dwSize := SizeOf(aProcessEntry32);
ContinueLoop := Process32First(aSnapShotHandle, aProcessEntry32);
while Integer(ContinueLoop) <> 0 do
begin
	if aProcessEntry32.th32ProcessID = PID then
	begin
		result:=aProcessEntry32.szExeFile;
		break;
	end;
	ContinueLoop := Process32Next(aSnapShotHandle, aProcessEntry32);
end;
CloseHandle(aSnapShotHandle);
end;

function GetWindowPosStr(handle: hwnd): string;
var rect:Trect;
begin
  GetWindowRect(handle, rect);
  windows.ScreenToClient(getParent(handle),rect.TopLeft);
  windows.ScreenToClient(getParent(handle),rect.BottomRight);
  result:='('+IntToStr(rect.left) + ', '+IntToStr(rect.top)+') - ('+IntToStr(rect.Right)+', '+IntToStr(rect.Bottom)+')';
end;

procedure toggleWindowMarkStatus(handle: hwnd);
var markDC:HDC;
    rec:TRect;
begin
  if handle=0 then exit;
  markDC:=GetWindowDC(handle);
  GetWindowRect(handle,rec);
  rec.right-=rec.left;
  rec.bottom-=rec.top;
  rec.left:=0;
  rec.top:=0;
  {InvertRect(markDC,rec);
  rec.left+=3;
  rec.top+=3;
  rec.bottom-=3;
  rec.right-=3;
  InvertRect(markDC,rec);}
  InvertRect(markDC,rect(0,0,rec.Right,3));
  InvertRect(markDC,rect(0,rec.bottom-3,rec.Right,rec.Bottom));
  InvertRect(markDC,rect(0,3,3,rec.Bottom-3));
  InvertRect(markDC,rect(rec.Right-3,3,rec.Right,rec.Bottom-3));
  ReleaseDC(handle, markDC);
end;


function GetWindowAlphaColorKey(wnd:HWND;var color:COLORREF;var alpha:Byte;var Flags:Longint):boolean;
type
  PCOLORREF=^COLORREF;
type
  TGetLayeredWindowAttributes  = function(hwnd: HWND; crKey: PCOLORREF; bAlpha: PByte; dwFlags: PLongint): Longint; stdcall;
var
  GetLayeredWindowAttributes: TGetLayeredWindowAttributes;
  col:COLORREF;
  alph:Byte;
  flag:longint;
begin
  Result := False;
  if GetWindowLong(wnd,GWL_EXSTYLE) and ws_ex_layered = 0 then begin
//    showmessage('fehler');
    color:=0;
    alpha:=255;
    Flags:=0;
    exit(true);
  end;
  // Here we import the function from USER32.DLL
  @GetLayeredWindowAttributes := LoadFuncFromDLL('USER32.DLL','GetLayeredWindowAttributes');
  // If the import did not succeed, make sure your app can handle it!
  if @GetLayeredWindowAttributes <> nil then
  begin
    // The SetLayeredWindowAttributes function sets the opacity and
    // transparency color key of a layered window
    GetLayeredWindowAttributes(Wnd,@col,@alph,@flag);
    color:=col;
    alpha:=alph;
    flags:=flag;
{    showmessage('color:'+INttoStr(color));
    showmessage('alpa:'+INttoStr(alpha));
    showmessage('flags:'+INttoStr(flags));}
    Result := True;
  end;

end;

function GetWindowColorKey(wnd:HWND):COLORREF;
var dummybyte:byte;
    dummyint:Integer;
begin
  GetWindowAlphaColorKey(wnd,result,dummybyte,dummyint);
end;

function GetWindowAlpha(wnd:HWND):byte;
var dummycol:COLORREF;
    dummyint:Integer;
begin
  GetWindowAlphaColorKey(wnd,dummycol,result,dummyint);
  //showmessage(INtToStr(result));
//  showmessage(INtToStr(trunc(100-(result * 100) / 255)));
end;

function GetWindowLayeredFlags(wnd:HWND):integer;
var dummycol:COLORREF;
    dummybyte:byte;
begin
  GetWindowAlphaColorKey(wnd,dummycol,dummybyte,result);
end;

function SetLayeredWindowAttributes(wnd: HWND; crKey: COLORREF; bAlpha: Byte; dwFlags: Longint): boolean;
type
TSetLayeredWindowAttributes = function(hwnd: HWND; crKey: COLORREF; bAlpha: Byte; dwFlags: Longint): Longint; stdcall;
var
  SetLayeredWindowAttributesf: TSetLayeredWindowAttributes;
begin
  Result := false;
  //disabling layered makes the window black, so we don't do it

  // Here we import the function from USER32.DLL
  @SetLayeredWindowAttributesf := LoadFuncFromDLL('USER32.DLL','SetLayeredWindowAttributes');
  // If the import did not succeed, make sure your app can handle it!
  if @SetLayeredWindowAttributesf <> nil then
  begin
    // Check the current state of the dialog, and then add the WS_EX_LAYERED attribute
    if dwFlags<>0 then SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
    // The SetLayeredWindowAttributes function sets the opacity and
  // transparency color key of a layered window
    SetLayeredWindowAttributesf(Wnd, crKey, bAlpha, dwFlags);
    Result := True;
  end;
end;                      (*
function MakeWndTrans(Wnd: HWND; bAlpha: Integer = 240): Boolean;
var flags:cardinal;
begin
{  flags:=GetWindowLayeredFlags(wnd);
  if (flags=lwa_colorkey or lwa_alpha) or (flags=lwa_colorkey) then
    result:=SetLayeredWindowAttributes(Wnd, GetWindowColorKey(wnd), bAlpha, LWA_COLORKEY or LWA_ALPHA)
   else}
    result:=SetLayeredWindowAttributes(Wnd, 0, bAlpha, LWA_ALPHA);
end;

function MakeWndOpaque(wnd:HWND):boolean;
var flags:cardinal;
begin
  flags:=GetWindowLayeredFlags(wnd);
  if (flags = lwa_alpha) then
    result:=SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) and not WS_EX_LAYERED)<>0
   else
    result:=SetLayeredWindowAttributes(wnd,0,255,LWA_ALPHA);
       {
  result:=false;
   else if (flags<>0) then
    result:=SetLayeredWindowAttributes(wnd,GetWindowColorKey(wnd),0,LWA_COLORKEY);}
end;


function MakeWndColorKeyOn(Wnd: HWND; color:COLORREF): Boolean;
begin
{  if (GetWindowLayeredFlags(wnd)and lwa_alpha=lwa_alpha) then
    result:=SetLayeredWindowAttributes(Wnd, color, GetWindowAlpha(wnd), LWA_COLORKEY or lwa_alpha)
   else                 }
    result:=SetLayeredWindowAttributes(Wnd, color, 0, LWA_COLORKEY);
end;

function MakeWndColorKeyOff(Wnd: HWND): Boolean;
var flags:cardinal;
begin
  result:=false;
  flags:=GetWindowLayeredFlags(wnd);
  if (flags = lwa_colorkey) then
    result:=SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) and not WS_EX_LAYERED)<>0
   else {if (flags<>0) then
    result:=SetLayeredWindowAttributes(wnd,0,GetWindowAlpha(wnd),LWA_ALPHA);}
    result:=SetLayeredWindowAttributes(Wnd, 0, 0, LWA_COLORKEY);
end;                    *)
end.
