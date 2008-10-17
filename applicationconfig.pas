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

unit applicationConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,windows, forms,graphics,windowcontrolfuncs,XMLCfg,XMLConf;


const SEARCHTOOLFRM_ID=1;
      WINDOWLISTFRM_ID=2;
      PROCESSLISTFRM_ID=3;
      SYSTEMOPTIONSFRM_ID=4;
      OPTIONSFRM_ID=5;
      PROPERTYSHEETFRM_ID=6;
      WINDOWSTYLELISTFRM_ID=7;

var hexa:boolean=false; //#TODO -1: different number outputs
    winConstPath:string='winconst\';
    curlang:string='auto';
    maxSubFormPerPage,defaultRefreshTimeInterval: longint;

    globalConfig: TXMLConfig;

    pageInfoColors: array[tpageinfo] of tcolor;

    runonNT: boolean;
    niceVisible: boolean=true;//visible at start
    messageWindow,globalHook: THandle;

//these convert functions use the user output format (int, pascal-hex,..)
function isStrCardinal(s:string): boolean;
function Str2Cardinal(s:string):cardinal;
function Str2CardinalDef(s:string;def:cardinal):cardinal;
function Cardinal2Str(nr:cardinal):string;
function Pointer2Str(p: pointer):string;

procedure niceSetVisible(vis: boolean; needMouseEvents: boolean);

//procedure showHandle(sender: TForm; handle: THANDLE; where: longint);
  procedure readConfig;
  function initAll:boolean;
  procedure finitAll;
implementation
uses  windowfuncs,mainunit,apimshared,ptranslateutils;

function isStrCardinal(s: string): boolean;
var i:longint;
begin
  s:=trim(s);
  if s='' then exit(true);
  if s[1]='$' then begin
    for i:=1 to length(s) do
      if not (s[i] in ['0'..'9','A'..'F','a'..'f']) then exit(false);
  end else
    for i:=1 to length(s) do
      if not (s[i] in ['0'..'9']) then exit(false);
  result:=true;
end;

//Konvertiert einen String zu einer Zahl und umgekehr:
function Str2Cardinal(s:string):cardinal;
begin
  s:=trim(s);
  if s='' then exit(0);
  if hexa then
    Result:=StrToInt64(s)
   else
    Result:=StrToInt64(s);
end;

function Str2CardinalDef(s: string; def: cardinal): cardinal;
begin
  if not isStrCardinal(s) then exit(def)
  else exit(Str2Cardinal(s));
end;

function Cardinal2Str(nr:cardinal):string;
begin
  if hexa then
    Result:='$'+IntToHex(nr,8)
   else
    Result:= IntToStr(nr);
end;

function Pointer2Str(p: pointer): string;
begin
  result:=Cardinal2Str(cardinal(p));
end;

procedure niceSetVisible(vis: boolean; needMouseEvents: boolean);
//type TAnimateWindow=function (hwnd:HWND; dwTime:DWORD; dwFlags:DWORD):boolean;stdcall;
var i,f:longint;
begin
  if niceVisible=vis then exit;
  niceVisible:=vis;                               {
  animation:=TAnimateWindow(GetProcAddress(GetModuleHandle('user32.dll'),'AnimateWindow'));
  if not assigned(animation) then begin
    if not needMouseEvents then visible:=niceVisible;
    exit;
  end;

  if vis then  animation(handle,1000,AW_BLEND)
  else animation(handle,1000,AW_BLEND or AW_HIDE);
  exit;

  }
  if runonNT then begin
    if vis then begin //#TODO -1: optimize
      for i:=7 to 25 do
        for f:=0 to Screen.FormCount-1 do
          if (Screen.Forms[f].parent=nil) then begin
            windowfuncs.SetLayeredWindowAttributes(Screen.forms[f].handle,0,10*i+5,LWA_ALPHA);
            Application.ProcessMessages;
          end;
        for f:=0 to Screen.FormCount-1 do
          SetWindowLong(Screen.forms[f].handle, GWL_EXSTYLE, GetWindowLong(Screen.forms[f].handle, GWL_EXSTYLE) and not WS_EX_LAYERED); //layered slows down lcl
     end else begin
       for f:=0 to Screen.FormCount-1 do
         SetWindowLong(Screen.forms[f].handle, GWL_EXSTYLE, GetWindowLong(Screen.forms[f].handle, GWL_EXSTYLE) or WS_EX_LAYERED);
       Application.ProcessMessages;
       for i:=25 downto 7 do
         for f:=0 to Screen.FormCount-1 do
           if (Screen.Forms[f].parent=nil) then begin
             windowfuncs.SetLayeredWindowAttributes(Screen.forms[f].handle,0,10*i,LWA_ALPHA);
             Application.ProcessMessages;
             if niceVisible then exit;
           end;
     end;
  end else if vis or not needMouseEvents then begin
    for f:=0 to Screen.FormCount-1 do
      if (Screen.Forms[f].parent=nil) then
        Screen.Forms[f].Visible:=vis;
  end;
end;

{procedure showHandle(sender: TForm; handle: THANDLE; where: longint);
begin
  mainForm.showHandle(sender,handle,where);
end;


function findPropertySheet(): TWindowPropertySheetFrm;
var i:longint;
begin
  for i:=Application.ComponentCount -1 downto 0 do
    if Application.Components[i] is TWindowPropertySheetFrm then
      exit(Application.Components[i] as TWindowPropertySheetFrm);
  result:=TWindowPropertySheetFrm.Create(Application);
  result.Visible:=true;
end;

procedure selectWindowToPropertySheet(wnd: hwnd; var propertySheet: TWindowPropertySheetFrm; sender: Tform);
begin
  if propertySheet=nil then propertySheet:=findPropertySheet();
  propertySheet.selectWnd(wnd);
end;
                                                     }

  procedure readConfig;
  begin
    //size/position/some default informations are stored by the forms itself.
    hexa:= globalConfig.GetValue('look/numberKind','0')<>'1';
    winConstPath:=globalConfig.GetValue('paths/winconst','winconst\');
    maxSubFormPerPage:=globalConfig.GetValue('look/maxSubFormPerPage',3);
    defaultRefreshTimeInterval:=globalConfig.GetValue('look/defaultRefreshTime',0);
    curlang:=globalConfig.GetValue('look/language','auto');
  end;

  function initAll:boolean;
  begin
    if FindWindow(messageWindowClass,nil)<>0 then begin
      SetForegroundWindow(GetPropA(FindWindow(messageWindowClass,''),propertyMainWindow));
      exit(false);
    end;
    result:=true;
    runonNT:=Win32Platform=VER_PLATFORM_WIN32_NT;
    pageInfoColors[piUnknown]:=clBlack;
    pageInfoColors[piFree]:=clBlack;
    pageInfoColors[piReserved]:=clSilver;
    pageInfoColors[piNoAccess]:=clGray;
    pageInfoColors[piReadOnly]:=clLime;
    pageInfoColors[piReadWrite]:=clYellow;
    pageInfoColors[piWriteCopy]:=clOlive;
    pageInfoColors[piExecute]:=clAqua;
    pageInfoColors[piExecuteRead]:=clAqua;
    pageInfoColors[piExecuteReadWrite]:=clFuchsia;
    pageInfoColors[piExecuteWriteCopy]:=clPurple;

    globalConfig:=TXMLConfig.Create(Application);
    globalConfig.Filename:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'apim.config'; //#TODO -1:
    readConfig;


    messageWindow:=createAPIMMessageWindow;
    if curlang='auto' then initGlobalTranslation('i18n\','apim','','de')
    else initGlobalTranslation('i18n\','apim',curlang,'de');
  end;

  procedure finitAll;
  begin
    UnhookWindowsHookEx(globalHook);
  end;

initialization
end.

