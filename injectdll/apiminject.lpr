library Project1;

{$mode objfpc}{$H+}

uses
  Classes,apimshared,sysutils,windows
  { you can add units after this };

var curHookID: thandle=0;
    apimMessageWnd: thandle;


procedure getInfo;
begin
  apimMessageWnd:=FindWindow(messageWindowClass,nil);
  if apimMessageWnd <>0 then curHookID:=GetProp(apimMessageWnd,propertyHookId);
end;

procedure performAction;
var buf: string;
    action,aim:longint;
begin
  action:=getprop(apimMessageWnd,propertyAction);
  if action<>0 then
    setprop(apimMessageWnd,propertyAction,0)
   else
    exit;
  aim:=GetProp(apimMessageWnd,propertyAim);
  case action of
    action_gettext: begin
      setlength(buf,GetWindowTextLength(aim)+2);
      GetWindowText(aim,@buf[1],length(buf));
      SetWindowText(apimMessageWnd,pchar(buf));
    end;
    action_setwindowlong:
      SetWindowLong(aim,longint(GetProp(apimMessageWnd,propertyParam1)),GetProp(apimMessageWnd,propertyParam2));
    action_setclasslong:
      SetClassLong(aim,longint(GetProp(apimMessageWnd,propertyParam1)),GetProp(apimMessageWnd,propertyParam2));
    action_sendmessage:
      Sendmessage(aim,longint(GetProp(apimMessageWnd,propertyMsg)),GetProp(apimMessageWnd,propertyParam1),GetProp(apimMessageWnd,propertyParam2));
  end;
end;

function CallWndRetProc(nCode:longint; wParam:WPARAM;lParam:LPARAM):lresult;stdcall;
var temp: dword;
begin
  if curHookID=0 then getInfo;
  if PCWPRETSTRUCT(lparam)^.message=actionNeededMessage then begin
    GetWindowThreadProcessId(GetProp(apimMessageWnd,propertyAim),@temp);
    if GetCurrentProcessId=temp then
      performAction;
  end;
  result:=CallNextHookEx(curHookID,ncode,wparam,lparam);
end;


procedure startHook;
begin
  getInfo;
  if apimMessageWnd=0 then exit;
  curHookID:=SetWindowsHookEx(WH_CALLWNDPROCRET,@CallWndRetProc,HINSTANCE,0);
  SetProp(apimMessageWnd,propertyHookId,curHookID);
end;

exports startHook;

begin

end.

