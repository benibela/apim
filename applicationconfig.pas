unit applicationConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

var hexa:boolean=false;
    winConstPath:string='winconst\';
function Str2Cardinal(s:string):cardinal;
function Cardinal2Str(nr:cardinal):string;

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
end.

