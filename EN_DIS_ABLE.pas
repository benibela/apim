(****************************************************************
 ****************************************************************
 ***                                                          ***
 ***        Copyright (c) 2001 by -=Assarbad [GoP]=-          ***
 ***       ____________                 ___________           ***
 ***      /\   ________\               /\   _____  \          ***
 ***     /  \  \       /    __________/  \  \    \  \         ***
 ***     \   \  \   __/___ /\   _____  \  \  \____\  \        ***
 ***      \   \  \ /\___  \  \  \    \  \  \   _______\       ***
 ***       \   \  \ /   \  \  \  \    \  \  \  \      /       ***
 ***        \   \  \_____\  \  \  \____\  \  \  \____/        ***
 ***         \   \___________\  \__________\  \__\            ***
 ***          \  /           /  /          /  /  /            ***
 ***           \/___________/ \/__________/ \/__/             ***
 ***                                                          ***
 ***  May the source be with you, stranger ... :-)            ***
 ***                                                          ***
 ***  Greets from -=Assarbad [GoP]=- ...                      ***
 ***  Special greets go 2 Nico, Casper, SA, Pizza, Navarion...***
 ***[for questions/proposals drop a mail to Assarbad@ePost.de]***
 *****************************************ASCII by Assa [GoP]****
 ****************************************************************)

unit EN_DIS_ABLE;
{$R main.res}
(*v.1.14
implemented killing of processes, too ;)
implemented closing,minimizing,restoring the target window. enhanced GU interface
*)

uses
  Windows, Messages;

const
  DIALOG1 = 101;
  ICON1 = 103;
  ICON2 = 104;
  DRAGCURSOR = 105;

  IDC_BUTTON1 = 1003;
  IDC_BUTTON2 = 1012;
  IDC_BUTTON3 = 1019;
  IDC_EDIT1 = 1008;
  IDC_EDIT2 = 1004;
  IDC_EDIT3 = 1005;
  TARGETER = 1007;
  IDC_CHECK1 = 1013;
  IDC_CHECK2 = 1006;
  IDC_CHECK3 = 1014;
  IDC_EDIT4 = 1017;
  IDC_EDIT5 = 1018;

  SE_DEBUG_NAME = 'SeDebugPrivilege';
  handle_text = 'Handle'#0;
  tid_text = 'Thread ID'#0;
  pid_text = 'Process ID'#0;
  err_gotnokill = 'Process could not be killed!'#0;
  err_noOS = 'OS version could not be determined.'#0;
var
  fix8, appicon, NormIcon, DragIcon: Cardinal;
  runonNT: boolean = false;

function frmt(mformat: string; args: array of POINTER; Size: integer = $400): string;
var
  bla: pchar;
begin
  getmem(bla, size);
  ZeroMemory(bla, size);
//according to PSDK 4/2000 there's no limit for the buffer
//according to PSDK 10/2000 and later the limit is 1024 byte!
  wvsprintf(bla, pchar(mformat), pchar(@args));
  result := string(bla);
  freemem(bla, size);
end;

function SetPrivilege(sPrivilegeName: string; bEnabled: boolean): boolean;
var
  TPPrev, TP: TTokenPrivileges;
  Token: THandle;
  dwRetLen: Cardinal;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token);
  TP.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, PChar(sPrivilegeName), TP.Privileges[0].LUID) then begin
    if (bEnabled) then
      TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      TP.Privileges[0].Attributes := 0;
    dwRetLen := 0;
    Result := AdjustTokenPrivileges(Token, False, TP, SizeOf(TPPrev), TPPrev, dwRetLen);
  end;
  CloseHandle(Token);
end;

function KillProcess(PID: Cardinal): boolean;
var
  hProcess: Cardinal;
begin
  result := false;
  case runonNT of
    TRUE:
      if not SetPrivilege(SE_DEBUG_NAME, true) then begin
        exit;
      end;
  end;
  hProcess := OpenProcess(PROCESS_TERMINATE, FALSE, PID);
  if hProcess = 0 then exit;
  result := BOOL(TerminateProcess(hProcess, 1));
  CloseHandle(hProcess);
  case runonNT of
    TRUE:
      SetPrivilege(SE_DEBUG_NAME, false);
  end;
end;

function dlgfunc(hwnd: hwnd; umsg: Cardinal; wparam: wparam; lparam: lparam): bool; stdcall;
var
  TID, PID, target: Cardinal;
  buffer1, buffer2: array[0..1024] of Char;
  pt: TPoint;
  enabled: boolean;
begin
  Result := TRUE;
  case umsg of
    WM_INITDIALOG:
      begin
        hidecaret(hwnd);
        SendMessage(hwnd, WM_SETICON, ICON_SMALL, appIcon);
        SendMessage(hwnd, WM_SETICON, ICON_BIG, appIcon);

        fix8 := CreateFont(-MulDiv(8, GetDeviceCaps(GetWindowDC(hwnd), LOGPIXELSY), 72), 0, 0, 0, FW_NORMAL, 0, 0, 0, ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, FIXED_PITCH or FF_MODERN, 'Courier New');

        sendmessage(Getdlgitem(hwnd, IDOK), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_BUTTON3), WM_SETFONT, fix8, LongInt(TRUE));

        sendmessage(Getdlgitem(hwnd, IDC_EDIT1), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_EDIT2), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_EDIT4), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_EDIT5), WM_SETFONT, fix8, LongInt(TRUE));

        sendmessage(Getdlgitem(hwnd, IDC_CHECK1), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_CHECK2), WM_SETFONT, fix8, LongInt(TRUE));
        sendmessage(Getdlgitem(hwnd, IDC_CHECK3), WM_SETFONT, fix8, LongInt(TRUE));
      end;
    WM_CLOSE:
      EndDialog(hwnd, 0);
    WM_LBUTTONDOWN:
      begin
        pt.x := Word(lParam);
        pt.y := Word(lParam shr 16);
        if childwindowfrompoint(hwnd, pt) = getdlgitem(hwnd, TARGETER) then begin
          setcapture(hwnd);
          setcursor(loadcursor(hInstance, MAKEINTRESOURCE(DRAGCURSOR)));
          SendMessage(Getdlgitem(hwnd, TARGETER), STM_SETIMAGE, IMAGE_ICON, DragIcon);
        end;
      end;
    WM_MOUSEMOVE:
      if ((GetCapture = hwnd) and Getcursorpos(pt)) then begin
        target := windowfrompoint(pt);
        screentoclient(target,pt);
        target := childwindowfrompoint(target, pt);
        setprop(Getdlgitem(hwnd, IDC_EDIT2), handle_text, target);
        if not BOOL(getclassname(target, buffer1, sizeof(buffer1))) then
          ZeroMemory(@buffer1, sizeof(buffer1));
        getdlgitemtext(hwnd, IDC_EDIT1, @buffer2[0], sizeof(buffer2));
        if lstrcmpi(@buffer1[0], @buffer2[0]) <> 0 then setdlgitemtext(hwnd, IDC_EDIT1, @buffer1[0]);

        ZeroMemory(@buffer1, sizeof(buffer1));
        lstrcpy(@buffer1[0], pchar(frmt('0x%8.8X', [PDWORD(target)])));
        getdlgitemtext(hwnd, IDC_EDIT2, @buffer2[0], sizeof(buffer2));
        if lstrcmpi(@buffer1[0], @buffer2[0]) <> 0 then setdlgitemtext(hwnd, IDC_EDIT2, @buffer1[0]);

        ZeroMemory(@buffer1, sizeof(buffer1));
        sendmessage(target, WM_GETTEXT, 256, integer(@buffer1[0]));
        getdlgitemtext(hwnd, IDC_EDIT3, @buffer2[0], sizeof(buffer2));
        if lstrcmpi(@buffer1[0], @buffer2[0]) <> 0 then setdlgitemtext(hwnd, IDC_EDIT3, @buffer1[0]);

        case IsDlgButtonChecked(hwnd, IDC_CHECK1) of
          BST_CHECKED: enabled := true;
        else enabled := false;
        end;

        if enabled <> IsWindowEnabled(target) then
          case enabled of
            TRUE: CheckDlgButton(hwnd, IDC_CHECK1, BST_UNCHECKED);
            FALSE: CheckDlgButton(hwnd, IDC_CHECK1, BST_CHECKED);
          end;

        case IsDlgButtonChecked(hwnd, IDC_CHECK2) of
          BST_CHECKED: enabled := true;
        else enabled := false;
        end;
        if enabled <> IsWindowUnicode(target) then
          case enabled of
            TRUE: CheckDlgButton(hwnd, IDC_CHECK2, BST_UNCHECKED);
            FALSE: CheckDlgButton(hwnd, IDC_CHECK2, BST_CHECKED);
          end;

        case IsDlgButtonChecked(hwnd, IDC_CHECK3) of
          BST_CHECKED: enabled := true;
        else enabled := false;
        end;
        if enabled <> IsWindowVisible(target) then
          case enabled of
            TRUE: CheckDlgButton(hwnd, IDC_CHECK3, BST_UNCHECKED);
            FALSE: CheckDlgButton(hwnd, IDC_CHECK3, BST_CHECKED);
          end;

        TID := GetWindowThreadProcessID(target, @PID);

        if getprop(getdlgitem(hwnd, IDC_EDIT4), tid_text) <> TID then begin
          setprop(getdlgitem(hwnd, IDC_EDIT4), tid_text, TID);
          lstrcpy(@buffer1[0], pchar(frmt('0x%8.8X', [PDWORD(TID)])));
          setdlgitemtext(hwnd, IDC_EDIT4, @buffer1[0]);
        end;

        if getprop(getdlgitem(hwnd, IDC_EDIT5), pid_text) <> PID then begin
          setprop(getdlgitem(hwnd, IDC_EDIT5), pid_text, PID);
          lstrcpy(@buffer1[0], pchar(frmt('0x%8.8X', [PDWORD(PID)])));
          setdlgitemtext(hwnd, IDC_EDIT5, @buffer1[0]);
        end;

      end;
    WM_LBUTTONUP:
      if GetCapture = hwnd then ReleaseCapture;
    WM_CAPTURECHANGED:
      begin
        setcursor(loadcursor(hinstance, IDC_ARROW));
        senddlgitemmessage(hwnd, TARGETER, STM_SETIMAGE, IMAGE_ICON, normicon);
      end;
    WM_COMMAND:
      if HiWord(WParam) = BN_CLICKED then
        case LOWORD(wParam) of
          IDOK:
            EndDialog(hwnd, 0);
          IDC_BUTTON2:
          //Close Window
            begin
                 target := Cardinal(getprop(Getdlgitem(hwnd, IDC_EDIT2), handle_text));
                 postmessage(target,WM_CLOSE,0,0);
            end;
          IDC_BUTTON1:
          //Minimize Restore
            begin
                 target := Cardinal(getprop(Getdlgitem(hwnd, IDC_EDIT2), handle_text));
                 enabled := IsIconic(target);
              case enabled of
                TRUE:
                    Showwindow(target, SW_RESTORE);
                FALSE:
                    Showwindow(target, SW_MINIMIZE);
              end;
            end;
          IDC_BUTTON3:
          //Close program
            begin
              case KillProcess(getprop(getdlgitem(hwnd, IDC_EDIT5), pid_text)) of
                false: messagebox(hwnd, err_gotnokill, nil, 0);
              end;
            end;
  IDC_CHECK1://
  begin
              target := Cardinal(getprop(Getdlgitem(hwnd, IDC_EDIT2), handle_text));
              enabled := IsWindowEnabled(target);
              EnableWindow(target, LongBool(not enabled));
              case enabled of
                TRUE: CheckDlgButton(hwnd, IDC_CHECK1, BST_UNCHECKED);
                FALSE: CheckDlgButton(hwnd, IDC_CHECK1, BST_CHECKED);
              end;
  end;
  IDC_CHECK3://
  begin
              target := Cardinal(getprop(Getdlgitem(hwnd, IDC_EDIT2), handle_text));
              enabled := IsWindowVisible(target);
              case enabled of
                TRUE:
                  begin
                    Showwindow(target, SW_HIDE);
                    CheckDlgButton(hwnd, IDC_CHECK3, BST_UNCHECKED);
                  end;
                FALSE: begin
                    Showwindow(target, SW_SHOWNOACTIVATE);
                    CheckDlgButton(hwnd, IDC_CHECK3, BST_CHECKED);
                  end;
              end;
  end;
        end;
  else result := false;
  end;
end;

var
  osinfo: TOSVERSIONinfo;
begin
  osinfo.dwOSVersionInfoSize := sizeof(TOSVERSIONinfo);
  if not BOOL(GetVersionEx(osinfo)) then begin
    messagebox(0, err_noOS, nil, 0);
    halt($FF);
  end else runonNT := osinfo.dwPlatformId = VER_PLATFORM_WIN32_NT;
  DragIcon := LoadIcon(hInstance, MAKEINTRESOURCE(ICON1));
  NormIcon := LoadIcon(hInstance, MAKEINTRESOURCE(ICON2));
  appIcon := LoadIcon(hInstance, MAKEINTRESOURCE(1));
  DialogBoxParam(HInstance, MAKEINTRESOURCE(DIALOG1), 0, @dlgfunc, 0);
end.

