{****************************************************************
 ****************************************************************
 ***           This file belongs to PVIEW/PSKILL              ***
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
 ****************************************************************}
 unit proc9;
 interface
 {$mode delphi}{$h+}
  uses windows,sysutils,commontypes;

CONST
  //greets go to tlhelp32.h ;)))
  TH32CS_SNAPPROCESS = $00000002;
  SE_DEBUG_NAME:string = 'SeDebugPrivilege';

TYPE
  tagPROCESSENTRY32 = PACKED RECORD
    dwSize,
      cntUsage,
      th32ProcessID,
      th32DefaultHeapID,
      th32ModuleID,
      cntThreads,
      th32ParentProcessID: DWORD;
    pcPriClassBase: LongInt;
    dwFlags: DWORD;
    szExeFile: ARRAY[0..MAX_PATH - 1] OF char;
  END;

  TProcess32FN = FUNCTION(hSnapshot: DWORD; VAR lppe: tagPROCESSENTRY32): BOOL; stdcall;
  TCreateTHSnap = FUNCTION(dwFlags, th32ProcessID: DWORD): DWORD; stdcall;
  FUNCTION getprocesses9x: TProcessrecs;
  function KillProcess(PID: Cardinal): boolean; //von Assa? Ich weiﬂ es nicht, ich habs hier reinkopiert, weils hier passt.
  function SetPrivilege(sPrivilegeName: string; bEnabled: boolean): boolean;//von Assa? Ich weiﬂ es nicht, ich habs hier reinkopiert, weils hier passt.
  function GetProcessPriority(pid:THandle):dword;//von mir (BeniBela), benutzt SetPrivilege;
implementation
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
  case Win32Platform=VER_PLATFORM_WIN32_NT of
    TRUE:
      if not SetPrivilege(SE_DEBUG_NAME, true) then begin
        exit;
      end;
  end;
  hProcess := OpenProcess(PROCESS_TERMINATE, FALSE, PID);
  if hProcess = 0 then exit;
  result := BOOL(TerminateProcess(hProcess, 1));
  CloseHandle(hProcess);
  case Win32Platform=VER_PLATFORM_WIN32_NT of
    TRUE:
      SetPrivilege(SE_DEBUG_NAME, false);
  end;
end;

function GetProcessPriority(pid:THandle):dword;
var process:thandle;
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT then
    SetPrivilege(SE_DEBUG_NAME,true);
  process:=OpenProcess(PROCESS_QUERY_INFORMATION,false,pid);
  try
    result:=GetPriorityClass(process);
  finally
    CloseHandle(process);
  end;
  if Win32Platform=VER_PLATFORM_WIN32_NT then
    SetPrivilege(SE_DEBUG_NAME,false);
end;
FUNCTION getprocesses9x: TProcessrecs;
VAR
  hKernel, hProcessSnap: DWORD;
  CreateToolhelp32Snapshot: TCreateTHSnap;
  Process32First,
    Process32Next: TProcess32FN;
  pe32: tagProcessEntry32;
  noerr: bool;
BEGIN
  //init variables
//  hKernel := 0;
//  hProcessSnap := 0;
  @CreateToolhelp32Snapshot := NIL;
  @Process32First := NIL;
  @Process32Next := NIL;
  setlength(result, 0);
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
  noerr := Process32First(hProcessSnap, pe32);
  WHILE noerr DO BEGIN
    setlength(result, length(result) + 1);
    result[length(result) - 1].name := pe32.szExeFile;
    result[length(result) - 1].PID := pe32.th32ProcessID;
    noerr := Process32Next(hProcessSnap, pe32);
  END;
  CloseHandle(hProcessSnap);
END;

{$WARNINGS ON}
{$HINTS ON}
end.
