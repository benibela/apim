unit passwort;

interface
{$mode delphi}{$h+}
uses windows,sysutils;
type
 PWinPassword = ^TWinPassword;
 TWinPassword = record
   EntrySize: Word;
   ResourceSize: Word;
   PasswordSize: Word;
   EntryIndex: Byte;
   EntryType: Byte;
   PasswordC: Char;
  end;
type TAddProc=procedure (text:string);
const
  Count: Integer = 0;
var
  addproc:TAddProc=nil;
function AddPassword(WinPassword: PWinPassword; dw: DWord): LongBool; stdcall;
function ScrDecode(enc: STRING): String;
implementation



function AddPassword(WinPassword: PWinPassword; dw: DWord): LongBool; stdcall;
var
  login,password: String;
  PC: Array[0..$FF] of Char;
begin
  result:=false;
  if not Assigned(addproc) then exit;
  inc(Count);

  Move(WinPassword.PasswordC, PC, WinPassword.ResourceSize);
  PC[WinPassword.ResourceSize] := #0;
  CharToOem(PC, PC);
  login := StrPas(PC);

  Move(WinPassword.PasswordC, PC, WinPassword.PasswordSize + WinPassword.ResourceSize);
  Move(PC[WinPassword.ResourceSize], PC, WinPassword.PasswordSize);
  PC[WinPassword.PasswordSize] := #0;
  CharToOem(PC, PC);
  password:=StrPas(PC);
  addproc(login+' : '+password);
//  Form1.ListBox1.Items.Add(login+' : '+password);
  Result := True;
end;

{function GetProcessPriority(ProcessID: Cardinal): DWord;
var
Handle : HWND;
begin
if runonNT then
  SetPrivilege(SE_DEBUG_NAME,true);
Handle := OpenProcess(PROCESS_QUERY_INFORMATION, True, ProcessID);
Result := GetPriorityClass(Handle);
CloseHandle(Handle);
if form1.runonNT then
  SetPrivilege(SE_DEBUG_NAME,false);
end; (* GetProcessPriority *)
}

function ScrDecode(enc: STRING): String;
var digit: array [1..16] of char;
    s: String;
    i:integer;
begin
     // Das Passwort ist mit XOR (dem exclusiven Oder) verschlüsselt
     // Der Schlüssel ist für jeden Buchstaben festgelegt
     // Ein $-Zeichen vor einer Zahl bedeutet, dass es eine Hex-Zahl ist

     digit[1] :=Chr(StrToInt('$'+enc[1]+enc[2])   xor $48); // 1.Buchstabe des dec. Passworts
     digit[2] :=Chr(StrToInt('$'+enc[3]+enc[4])   xor $EE); // 2.Buchstabe des ...
     digit[3] :=Chr(StrToInt('$'+enc[5]+enc[6])   xor $76); // ...
     digit[4] :=Chr(StrToInt('$'+enc[7]+enc[8])   xor $1D);
     digit[5] :=Chr(StrToInt('$'+enc[9]+enc[10])  xor $67);
     digit[6] :=Chr(StrToInt('$'+enc[11]+enc[12]) xor $69);
     digit[7] :=Chr(StrToInt('$'+enc[13]+enc[14]) xor $A1);
     digit[8] :=Chr(StrToInt('$'+enc[15]+enc[16]) xor $1B);
     digit[9] :=Chr(StrToInt('$'+enc[17]+enc[18]) xor $7A);
     digit[10]:=Chr(StrToInt('$'+enc[19]+enc[20]) xor $8C);
     digit[11]:=Chr(StrToInt('$'+enc[21]+enc[22]) xor $47);
     digit[12]:=Chr(StrToInt('$'+enc[23]+enc[24]) xor $F8);
     digit[13]:=Chr(StrToInt('$'+enc[25]+enc[26]) xor $54);
     digit[14]:=Chr(StrToInt('$'+enc[27]+enc[28]) xor $95);
     digit[15]:=Chr(StrToInt('$'+enc[29]+enc[30]) xor $97);
     digit[16]:=Chr(StrToInt('$'+enc[31]+enc[32]) xor $5F);
     s:='';
     for i:= 1 to length(enc) div 2 do // Buchstaben zum Passwort zusammenfügen
       s:=s+digit[i];
//     Result:=UpperCase(s); // Rückgabe des entschlüsselten Passworts (in Großbuchstaben)

  result:=s;                         // Windows ist beim Bildschirmschoner-Passwort nicht 'case-sensitive'
end;


end.
