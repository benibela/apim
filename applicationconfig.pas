unit applicationConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,windows;

var hexa:boolean=false;
    winConstPath:string='winconst\';
    runonNT: boolean;
function Str2Cardinal(s:string):cardinal;
function Cardinal2Str(nr:cardinal):string;
function Pointer2Str(p: pointer):string;

implementation

//Konvertiert einen String zu einer Zahl und umgekehr:
function Str2Cardinal(s:string):cardinal;
begin
  s:=trim(s);
  if hexa then
    Result:=StrToInt64(s)
   else
    Result:=StrToInt64(s);
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

initialization
  runonNT:=Win32Platform=VER_PLATFORM_WIN32_NT;
end.

