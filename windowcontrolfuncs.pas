unit windowcontrolfuncs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CheckLst,windows,Controls;
  
type TMemoryBlock = array of byte;
     TMemoryBlocks = array of TMemoryBlock;

procedure setCommonText(control: tcontrol;caption:string);
procedure setCommonText(control: tcontrol;number:dword);

function createMemoryBlocks(s:string):TMemoryBlocks;

procedure windowStylesToCheckListBox(window:THandle;listbox:TCheckListBox;numeric:tcontrol);
procedure windowExStylesToCheckListBox(window:THandle;listbox:TCheckListBox;numeric:tcontrol);
procedure classStylesToCheckListBox(window:THandle;listbox:TCheckListBox;numeric:tcontrol);
procedure windowCustomStylesToCheckListBox(window:THandle;listbox:TCheckListBox;numeric:tcontrol);

procedure changeWindowStyle(window:THandle; name: string; enabled: boolean);
procedure changeWindowExStyle(window:THandle; name: string; enabled: boolean);
procedure changeCustomStyle(window:THandle; name: string; enabled: boolean);
implementation
uses ExtCtrls,StdCtrls,applicationConfig;
procedure setCommonText(control: tcontrol;caption:string);
begin
  if control = nil then exit;
  if control is TCustomPanel then TCustomPanel(control).Caption:=caption
  else if control is TCustomLabel then TCustomLabel(control).Caption:=caption
  else if control is TCustomEdit then TCustomEdit(control).Text:=caption
  else if control is TCustomComboBox then TCustomComboBox(control).Text:=caption
end;

procedure setCommonText(control: tcontrol; number: dword);
begin
  setCommonText(control,Cardinal2Str(number));
end;

//Erzeugt Memory Blocks aus Strings mit Pascalsyntax
//Ein Block: ('1214' 65 $10 27)  => '1214A'#16#27
// (aligned):('1214',65,$10,27)  => '1214A'#0#0#0#16#0#0#0#27#0#0#0
//Erlaubt Nesting: ('abc' ('test')) => 'abctest'#0
//Erlaubt Pointer: ('p' @'abc' 'q') => 'p????q'#0 mit ???? = 32 Bit Pointer auf 'abc'#0
//                                     (also gibt es zwei Blocks)
//
//Für Zahlen wird der kleinster LE Datentyp (signed/unsigned 1 Byte, 2 Byte, 4 Byte oder 8 Byte)
//gewählt, in die der Wert passt
//Beispiele: 255 => #255 (byte); 256 => #0#1 (LE word); -128 => #255 (shortint)
//           -129 => #$7F#$FF (LE small int)
//2147483647 => #$F9#$FF#$FF#$7F (LE dword)
//Ein folgendes , machte die Zahl zu einem 32 Bit Typ auf Grund 4 Bit alignment
//(also ,0, wird zu 64 Bit)
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
      ' ': closeBlocks;
      ',': begin
        closeBlocks();
        while length(blocks[currentBlock]) mod 4 <> 0 do
          currentBlockAddByte(0); //langsam, aber O(n), doesn't matter
      end;
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


const
  WS_EX_COMPOSITED = $02000000;
  WS_EX_NOACTIVATE = $08000000;
  WS_EX_LAYERED = $00080000;
  WS_EX_NOINHERITLAYOUT = $00100000;
  WS_EX_LAYOUTRTL = $00400000;

  CS_DROPSHADOW = $00020000;

  ES_DISABLENOSCROLL                  = $00002000; //Richedit
  ES_NOIME                            = $00080000; //   "
  ES_SELFIME                          = $00040000; //   "
  ES_SUNKEN                           = $00004000; //   "
  ES_VERTICAL                         = $00400000; //   "


  TWS_BORDER:String = 'WS_BORDER';
  TWS_CAPTION:String = 'WS_CAPTION';
  TWS_CHILD:String = 'WS_CHILD';
  TWS_CHILDWINDOW:String = 'WS_CHILDWINDOW (=WS_CHILD)';
  TWS_CLIPCHILDREN:String = 'WS_CLIPCHILDREN';
  TWS_CLIPSIBLINGS:String = 'WS_CLIPSIBLINGS';
  TWS_DISABLED:String = 'WS_DISABLED';
  TWS_DLGFRAME:String = 'WS_DLGFRAME';
  TWS_GROUP:String = 'WS_GROUP';
  TWS_HSCROLL:String = 'WS_HSCROLL';
  TWS_ICONIC:String = 'WS_ICONIC (=WS_MINIMIZE)';
  TWS_MAXIMIZE:String = 'WS_MAXIMIZE';
  TWS_MAXIMIZEBOX:String = 'WS_MAXIMIZEBOX';
  TWS_MINIMIZE:String = 'WS_MINIMIZE';
  TWS_MINIMIZEBOX:String = 'WS_MINIMIZEBOX';
  TWS_OVERLAPPED:String = 'WS_OVERLAPPED (=WS_TILED)';
  TWS_OVERLAPPEDWINDOW:String = 'WS_OVERLAPPEDWINDOW (=WS_TILEDWINDOW) (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX) ';
  TWS_POPUP:String = 'WS_POPUP';
  TWS_POPUPWINDOW:String = 'WS_POPUPWINDOW (WS_BORDER + WS_POPUP + WS_SYSMENU)';
  TWS_SIZEBOX:String = 'WS_SIZEBOX';
  TWS_SYSMENU:String = 'WS_SYSMENU';
  TWS_TABSTOP:String = 'WS_TABSTOP';
  TWS_THICKFRAME:String = 'WS_THICKFRAME (=WS_SIZEBOX)';
  TWS_TILED:String = 'WS_TILED (=WS_OVERLAPPED)';
  TWS_TILEDWINDOW:String = 'WS_TILEDWINDOW (=WS_OVERLAPPEDWINDOW) (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)';
  TWS_VISIBLE:String = 'WS_VISIBLE';
  TWS_VSCROLL:String = 'WS_VSCROLL';
  TWS_EX_ACCEPTFILES:String = 'WS_EX_ACCEPTFILES';
  TWS_EX_APPWINDOW:String = 'WS_EX_APPWINDOW';
  TWS_EX_CLIENTEDGE:String = 'WS_EX_CLIENTEDGE';
  TWS_EX_COMPOSITED :String = 'WS_EX_COMPOSITED ';
  TWS_EX_CONTEXTHELP:String = 'WS_EX_CONTEXTHELP';
  TWS_EX_CONTROLPARENT:String = 'WS_EX_CONTROLPARENT';
  TWS_EX_DLGMODALFRAME:String = 'WS_EX_DLGMODALFRAME';
  TWS_EX_LAYERED:String = 'WS_EX_LAYERED';
  TWS_EX_LAYOUTRTL:String = 'WS_EX_LAYOUTRTL';
  TWS_EX_LEFT:String = 'WS_EX_LEFT';
  TWS_EX_LEFTSCROLLBAR:String = 'WS_EX_LEFTSCROLLBAR';
  TWS_EX_LTRREADING:String = 'WS_EX_LTRREADING';
  TWS_EX_MDICHILD:String = 'WS_EX_MDICHILD';
  TWS_EX_NOACTIVATE:String = 'WS_EX_NOACTIVATE';
  TWS_EX_NOINHERITLAYOUT:String = 'WS_EX_NOINHERITLAYOUT';
  TWS_EX_NOPARENTNOTIFY:String = 'WS_EX_NOPARENTNOTIFY';
  TWS_EX_OVERLAPPEDWINDOW:String = 'WS_EX_OVERLAPPEDWINDOW (WS_EX_CLIENTEDGE + WS_EX_WINDOWEDGE)';
  TWS_EX_PALETTEWINDOW:String = 'WS_EX_PALETTEWINDOW (WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST)';
  TWS_EX_RIGHT:String = 'WS_EX_RIGHT';
  TWS_EX_RIGHTSCROLLBAR:String = 'WS_EX_RIGHTSCROLLBAR';
  TWS_EX_RTLREADING:String = 'WS_EX_RTLREADING';
  TWS_EX_STATICEDGE:String = 'WS_EX_STATICEDGE';
  TWS_EX_TOOLWINDOW:String = 'WS_EX_TOOLWINDOW';
  TWS_EX_TOPMOST:String = 'WS_EX_TOPMOST';
  TWS_EX_TRANSPARENT:String = 'WS_EX_TRANSPARENT';
  TWS_EX_WINDOWEDGE:String = 'WS_EX_WINDOWEDGE';
  TCS_BYTEALIGNCLIENT:String='CS_BYTEALIGNCLIENT';
  TCS_BYTEALIGNWINDOW:String = 'CS_BYTEALIGNWINDOW';
  TCS_CLASSDC:String = 'CS_CLASSDC';
  TCS_DBLCLKS:String = 'CS_DBLCLKS';
  TCS_DROPSHADOW:String = 'CS_DROPSHADOW';
  TCS_GLOBALCLASS:String = 'CS_GLOBALCLASS';
  TCS_HREDRAW:String = 'CS_HREDRAW';
  TCS_NOCLOSE:String = 'CS_NOCLOSE';
  TCS_OWNDC:String = 'CS_OWNDC';
  TCS_PARENTDC:String = 'CS_PARENTDC';
  TCS_SAVEBITS:String = 'CS_SAVEBITS';
  TCS_VREDRAW:String = 'CS_VREDRAW';

  TBS_3STATE:String='BS_3STATE';
  TBS_AUTO3STATE:String ='BS_AUTO3STATE';
  TBS_AUTOCHECKBOX:String = 'BS_AUTOCHECKBOX';
  TBS_AUTORADIOBUTTON:String = 'BS_AUTORADIOBUTTON';
  TBS_CHECKBOX:String = 'BS_CHECKBOX';
  TBS_DEFPUSHBUTTON:String ='BS_DEFPUSHBUTTON';
  TBS_GROUPBOX:String = 'BS_GROUPBOX';
  TBS_LEFTTEXT:String = 'BS_LEFTTEXT';
  TBS_OWNERDRAW:String = 'BS_OWNERDRAW';
  TBS_PUSHBUTTON:String ='BS_PUSHBUTTON';
  TBS_RADIOBUTTON:String = 'BS_RADIOBUTTON';
  TBS_USERBUTTON:String = 'BS_USERBUTTON';
  TBS_BITMAP:String = 'BS_BITMAP';
  TBS_BOTTOM:String ='BS_BOTTOM';
  TBS_CENTER:String = 'BS_CENTER';
  TBS_ICON:String = 'BS_ICON';
  TBS_FLAT:String = 'BS_FLAT';
  TBS_LEFT:String ='BS_LEFT';
  TBS_MULTILINE:String = 'BS_MULTILINE';
  TBS_NOTIFY:String = 'BS_NOTIFY';
  TBS_PUSHLIKE:String = 'BS_PUSHLIKE';
  TBS_RIGHT:String ='BS_RIGHT';
  TBS_RIGHTBUTTON:String = 'BS_RIGHTBUTTON';
  TBS_TEXT:String = 'BS_TEXT';
  TBS_TOP:String = 'BS_TOP';
  TBS_VCENTER:String = 'BS_VCENTER';

  //ComboBoxStyles
  TCBS_AUTOHSCROLL:String = 'CBS_AUTOHSCROLL';
  TCBS_DISABLENOSCROLL:String = 'CBS_DISABLENOSCROLL';
  TCBS_DROPDOWN:String = 'CBS_DROPDOWN';
  TCBS_DROPDOWNLIST:String = 'CBS_DROPDOWNLIST';
  TCBS_HASSTRINGS:String = 'CBS_HASSTRINGS';
  TCBS_LOWERCASE:String = 'CBS_LOWERCASE';
  TCBS_NOINTEGRALHEIGHT:String = 'CBS_NOINTEGRALHEIGHT';
  TCBS_OEMCONVERT:String = 'CBS_OEMCONVERT';
  TCBS_OWNERDRAWFIXED:String = 'CBS_OWNERDRAWFIXED';
  TCBS_OWNERDRAWVARIABLE:String = 'CBS_OWNERDRAWVARIABLE';
  TCBS_SIMPLE:String = 'CBS_SIMPLE';
  TCBS_SORT:String = 'CBS_SORT';
  TCBS_UPPERCASE:String = 'CBS_UPPERCASE';

  //Editstyles
  TES_AUTOHSCROLL:String = 'ES_AUTOHSCROLL';
  TES_AUTOVSCROLL:String = 'ES_AUTOVSCROLL';
  TES_CENTER:String = 'ES_CENTER';
  TES_LEFT:String = 'ES_LEFT';
  TES_LOWERCASE:String = 'ES_LOWERCASE';
  TES_MULTILINE:String = 'ES_MULTILINE';
  TES_NOHIDESEL:String = 'ES_NOHIDESEL';
  TES_NUMBER:String = 'ES_NUMBER';
  TES_OEMCONVERT:String = 'ES_OEMCONVERT';
  TES_PASSWORD:String = 'ES_PASSWORD';
  TES_READONLY:String = 'ES_READONLY';
  TES_RIGHT:String = 'ES_RIGHT';
  TES_UPPERCASE:String = 'ES_UPPERCASE';
  TES_WANTRETURN:String = 'ES_WANTRETURN';

  //ListBox Styles
  TLBS_DISABLENOSCROLL:String = 'LBS_DISABLENOSCROLL';
  TLBS_EXTENDEDSEL:String = 'LBS_EXTENDEDSEL';
  TLBS_HASSTRINGS:String = 'LBS_HASSTRINGS';
  TLBS_MULTICOLUMN:String = 'LBS_MULTICOLUMN';
  TLBS_MULTIPLESEL:String = 'LBS_MULTIPLESEL';
  TLBS_NODATA:String = 'LBS_NODATA';
  TLBS_NOINTEGRALHEIGHT:String = 'LBS_NOINTEGRALHEIGHT';
  TLBS_NOREDRAW:String = 'LBS_NOREDRAW';
  TLBS_NOSEL:String = 'LBS_NOSEL';
  TLBS_NOTIFY:String = 'LBS_NOTIFY';
  TLBS_OWNERDRAWFIXED:String = 'LBS_OWNERDRAWFIXED';
  TLBS_OWNERDRAWVARIABLE:String = 'LBS_OWNERDRAWVARIABLE';
  TLBS_SORT:String = 'LBS_SORT';
  TLBS_STANDARD:String = 'LBS_STANDARD';
  TLBS_USETABSTOPS:String = 'LBS_USETABSTOPS';
  TLBS_WANTKEYBOARDINPUT:String = 'LBS_WANTKEYBOARDINPUT';

  //Edit Styles (only for Richedit)
  TES_DISABLENOSCROLL:String = 'ES_DISABLENOSCROLL';
  TES_EX_NOCALLOLEINIT:String = 'ES_EX_NOCALLOLEINIT';
  TES_NOIME:String = 'ES_NOIME';
  TES_SELFIME:String = 'ES_SELFIME';
  TES_SUNKEN:String = 'ES_SUNKEN';
  TES_VERTICAL:String = 'ES_VERTICAL';

  //Scroll Bar Control
  TSBS_BOTTOMALIGN:String = 'SBS_BOTTOMALIGN';
  TSBS_HORZ:String = 'SBS_HORZ';
  TSBS_LEFTALIGN:String = 'SBS_LEFTALIGN';
  TSBS_RIGHTALIGN:String = 'SBS_RIGHTALIGN';
  TSBS_SIZEBOX:String = 'SBS_SIZEBOX';
  TSBS_SIZEBOXBOTTOMRIGHTALIGN:String = 'SBS_SIZEBOXBOTTOMRIGHTALIGN';
  TSBS_SIZEBOXTOPLEFTALIGN:String = 'SBS_SIZEBOXTOPLEFTALIGN';
  TSBS_SIZEGRIP:String = 'SBS_SIZEGRIP';
  TSBS_TOPALIGN:String = 'SBS_TOPALIGN';
  TSBS_VERT:String = 'SBS_VERT';

  //Static Styles
  TSS_BITMAP:String = 'SS_BITMAP';
  TSS_BLACKFRAME:String = 'SS_BLACKFRAME';
  TSS_BLACKRECT:String = 'SS_BLACKRECT';
  TSS_CENTER:String = 'SS_CENTER';
  TSS_CENTERIMAGE:String = 'SS_CENTERIMAGE';
  TSS_ENDELLIPSIS :String = 'SS_ENDELLIPSIS ';
  TSS_ENHMETAFILE:String = 'SS_ENHMETAFILE';
  TSS_ETCHEDFRAME:String = 'SS_ETCHEDFRAME';
  TSS_ETCHEDHORZ:String = 'SS_ETCHEDHORZ';
  TSS_ETCHEDVERT:String = 'SS_ETCHEDVERT';
  TSS_GRAYFRAME:String = 'SS_GRAYFRAME';
  TSS_GRAYRECT:String = 'SS_GRAYRECT';
  TSS_ICON:String = 'SS_ICON';
  TSS_LEFT:String = 'SS_LEFT';
  TSS_LEFTNOWORDWRAP:String = 'SS_LEFTNOWORDWRAP';
  TSS_NOPREFIX:String = 'SS_NOPREFIX';
  TSS_NOTIFY:String = 'SS_NOTIFY';
  TSS_OWNERDRAW:String = 'SS_OWNERDRAW';
  TSS_PATHELLIPSIS:String = 'SS_PATHELLIPSIS';
  TSS_REALSIZECONTROL:String = 'SS_REALSIZECONTROL';
  TSS_REALSIZEIMAGE:String = 'SS_REALSIZEIMAGE';
  TSS_RIGHT:String = 'SS_RIGHT';
  TSS_RIGHTJUST:String = 'SS_RIGHTJUST';
  TSS_SIMPLE:String = 'SS_SIMPLE';
  TSS_SUNKEN:String = 'SS_SUNKEN';
  TSS_WHITEFRAME:String = 'SS_WHITEFRAME';
  TSS_WHITERECT:String = 'SS_WHITERECT';
  TSS_WORDELLIPSIS:String = 'SS_WORDELLIPSIS';


procedure windowStylesToCheckListBox(window:THandle; listbox: TCheckListBox;numeric:tcontrol);
var wsout:tstringlist;
    i:longint;
    styles:long;
begin
 styles:=GetWindowLong(window,GWL_STYLE);
 setCommonText(numeric,'Window styles:   '+Cardinal2Str(cardinal(styles)));
 wsout:=tstringlist.create;
 listbox.Clear;
 if styles and WS_BORDER = WS_BORDER then listbox.Items.Add(TWS_BORDER) else wsout.add(TWS_BORDER);
 if styles and WS_CAPTION = WS_CAPTION then listbox.Items.Add(TWS_CAPTION) else wsout.add(TWS_CAPTION);
 if styles and WS_CHILD = WS_CHILD then listbox.Items.Add(TWS_CHILD) else wsout.add(TWS_CHILD);
 if styles and WS_CHILDWINDOW = WS_CHILDWINDOW then listbox.Items.Add(TWS_CHILDWINDOW) else wsout.add(TWS_CHILDWINDOW);
 if styles and WS_CLIPCHILDREN = WS_CLIPCHILDREN then listbox.Items.Add(TWS_CLIPCHILDREN) else wsout.add(TWS_CLIPCHILDREN);
 if styles and WS_CLIPSIBLINGS = WS_CLIPSIBLINGS then listbox.Items.Add(TWS_CLIPSIBLINGS) else wsout.add(TWS_CLIPSIBLINGS);
 if styles and WS_DISABLED = WS_DISABLED then listbox.Items.Add(TWS_DISABLED) else wsout.add(TWS_DISABLED);
 if styles and WS_DLGFRAME = WS_DLGFRAME then listbox.Items.Add(TWS_DLGFRAME) else wsout.add(TWS_DLGFRAME);
 if styles and WS_GROUP = WS_GROUP then listbox.Items.Add(TWS_GROUP) else wsout.add(TWS_GROUP);
 if styles and WS_HSCROLL = WS_HSCROLL then listbox.Items.Add(TWS_HSCROLL) else wsout.add(TWS_HSCROLL);
 if styles and WS_ICONIC = WS_ICONIC then listbox.Items.Add(TWS_ICONIC) else wsout.add(TWS_ICONIC);
 if styles and WS_MAXIMIZE = WS_MAXIMIZE then listbox.Items.Add(TWS_MAXIMIZE) else wsout.add(TWS_MAXIMIZE);
 if styles and WS_MAXIMIZEBOX = WS_MAXIMIZEBOX then listbox.Items.Add(TWS_MAXIMIZEBOX) else wsout.add(TWS_MAXIMIZEBOX);
 if styles and WS_MINIMIZE = WS_MINIMIZE then listbox.Items.Add(TWS_MINIMIZE) else wsout.add(TWS_MINIMIZE);
 if styles and WS_MINIMIZEBOX = WS_MINIMIZEBOX then listbox.Items.Add(TWS_MINIMIZEBOX) else wsout.add(TWS_MINIMIZEBOX);
 if styles and WS_OVERLAPPED = WS_OVERLAPPED then listbox.Items.Add(TWS_OVERLAPPED)else wsout.add(TWS_OVERLAPPED);
 if styles and WS_OVERLAPPEDWINDOW = WS_OVERLAPPEDWINDOW then listbox.Items.Add(TWS_OVERLAPPEDWINDOW) else wsout.add(TWS_OVERLAPPEDWINDOW);

 if styles and WS_POPUP = WS_POPUP then listbox.Items.Add(TWS_POPUP) else wsout.add(TWS_POPUP);
 if styles and WS_POPUPWINDOW = WS_POPUPWINDOW then listbox.Items.Add(TWS_POPUPWINDOW) else wsout.add(TWS_POPUPWINDOW);
 if styles and WS_SIZEBOX = WS_SIZEBOX then listbox.Items.Add(TWS_SIZEBOX) else wsout.add(TWS_SIZEBOX);
 if styles and WS_SYSMENU = WS_SYSMENU then listbox.Items.Add(TWS_SYSMENU) else wsout.add(TWS_SYSMENU);
 if styles and WS_TABSTOP = WS_TABSTOP then listbox.Items.Add(TWS_TABSTOP)else wsout.add(TWS_TABSTOP);
 if styles and WS_THICKFRAME = WS_THICKFRAME then listbox.Items.Add(TWS_THICKFRAME)else wsout.add(TWS_THICKFRAME);
 if styles and WS_TILED = WS_TILED then listbox.Items.Add(TWS_TILED)else wsout.add(TWS_TILED);
 if styles and WS_TILEDWINDOW = WS_TILEDWINDOW then listbox.Items.Add(TWS_TILEDWINDOW)else wsout.add(TWS_TILEDWINDOW);
 if styles and WS_VISIBLE = WS_VISIBLE then listbox.Items.Add(TWS_VISIBLE)else wsout.add(TWS_VISIBLE);
 if styles and WS_VSCROLL = WS_VSCROLL then listbox.Items.Add(TWS_VSCROLL)else wsout.add(TWS_VSCROLL);
 for i:=0 to listbox.Items.Count-1 do
   listbox.Checked[i]:=true;
 listbox.Items.AddStrings(wsout);
 wsout.Free;
 listbox.Perform(LB_SETHORIZONTALEXTENT,listbox.Canvas.TextWidth(TWS_OVERLAPPEDWINDOW)+30,0);
end;

procedure windowExStylesToCheckListBox(window:THANDLE; listbox: TCheckListBox;numeric:tcontrol);
var wsout:tstringlist;
    i,styles:longint;
begin
 styles:=GetWindowLong(window,GWL_EXSTYLE);
 setCommonText(numeric,'Extended Window styles:   '+Cardinal2Str(styles));
 wsout:=tstringlist.create;
 listbox.Clear;
 if styles and  WS_EX_ACCEPTFILES=WS_EX_ACCEPTFILES  then listbox.Items.Add(TWS_EX_ACCEPTFILES) else wsout.Add(TWS_EX_ACCEPTFILES);
 if styles and  WS_EX_APPWINDOW=WS_EX_APPWINDOW  then listbox.Items.Add(TWS_EX_APPWINDOW) else wsout.Add(TWS_EX_APPWINDOW);
 if styles and  WS_EX_CLIENTEDGE=WS_EX_CLIENTEDGE  then listbox.Items.Add(TWS_EX_CLIENTEDGE) else wsout.Add(TWS_EX_CLIENTEDGE);
 if styles and  WS_EX_COMPOSITED=WS_EX_COMPOSITED   then listbox.Items.Add(TWS_EX_COMPOSITED ) else wsout.Add(TWS_EX_COMPOSITED );
 if styles and  WS_EX_CONTEXTHELP=WS_EX_CONTEXTHELP  then listbox.Items.Add(TWS_EX_CONTEXTHELP) else wsout.Add(TWS_EX_CONTEXTHELP);
 if styles and  WS_EX_CONTROLPARENT=WS_EX_CONTROLPARENT  then listbox.Items.Add(TWS_EX_CONTROLPARENT) else wsout.Add(TWS_EX_CONTROLPARENT);
 if styles and  WS_EX_DLGMODALFRAME=WS_EX_DLGMODALFRAME  then listbox.Items.Add(TWS_EX_DLGMODALFRAME) else wsout.Add(TWS_EX_DLGMODALFRAME);
 if styles and  WS_EX_LAYERED=WS_EX_LAYERED  then listbox.Items.Add(TWS_EX_LAYERED) else wsout.Add(TWS_EX_LAYERED);
 if styles and  WS_EX_LAYOUTRTL=WS_EX_LAYOUTRTL  then listbox.Items.Add(TWS_EX_LAYOUTRTL) else wsout.Add(TWS_EX_LAYOUTRTL);
 if styles and  WS_EX_LEFT=WS_EX_LEFT  then listbox.Items.Add(TWS_EX_LEFT) else wsout.Add(TWS_EX_LEFT);
 if styles and  WS_EX_LEFTSCROLLBAR=WS_EX_LEFTSCROLLBAR  then listbox.Items.Add(TWS_EX_LEFTSCROLLBAR) else wsout.Add(TWS_EX_LEFTSCROLLBAR);
 if styles and  WS_EX_LTRREADING=WS_EX_LTRREADING  then listbox.Items.Add(TWS_EX_LTRREADING) else wsout.Add(TWS_EX_LTRREADING);
 if styles and  WS_EX_MDICHILD=WS_EX_MDICHILD  then listbox.Items.Add(TWS_EX_MDICHILD) else wsout.Add(TWS_EX_MDICHILD);
 if styles and  WS_EX_NOACTIVATE=WS_EX_NOACTIVATE  then listbox.Items.Add(TWS_EX_NOACTIVATE) else wsout.Add(TWS_EX_NOACTIVATE);
 if styles and  WS_EX_NOINHERITLAYOUT=WS_EX_NOINHERITLAYOUT  then listbox.Items.Add(TWS_EX_NOINHERITLAYOUT) else wsout.Add(TWS_EX_NOINHERITLAYOUT);
 if styles and  WS_EX_NOPARENTNOTIFY=WS_EX_NOPARENTNOTIFY  then listbox.Items.Add(TWS_EX_NOPARENTNOTIFY) else wsout.Add(TWS_EX_NOPARENTNOTIFY);
 if styles and  WS_EX_OVERLAPPEDWINDOW=WS_EX_OVERLAPPEDWINDOW  then listbox.Items.Add(TWS_EX_OVERLAPPEDWINDOW) else wsout.Add(TWS_EX_OVERLAPPEDWINDOW);
 if styles and  WS_EX_PALETTEWINDOW=WS_EX_PALETTEWINDOW  then listbox.Items.Add(TWS_EX_PALETTEWINDOW) else wsout.Add(TWS_EX_PALETTEWINDOW);
 if styles and  WS_EX_RIGHT=WS_EX_RIGHT  then listbox.Items.Add(TWS_EX_RIGHT) else wsout.Add(TWS_EX_RIGHT);
 if styles and  WS_EX_RIGHTSCROLLBAR=WS_EX_RIGHTSCROLLBAR  then listbox.Items.Add(TWS_EX_RIGHTSCROLLBAR) else wsout.Add(TWS_EX_RIGHTSCROLLBAR);
 if styles and  WS_EX_RTLREADING=WS_EX_RTLREADING  then listbox.Items.Add(TWS_EX_RTLREADING) else wsout.Add(TWS_EX_RTLREADING);
 if styles and  WS_EX_STATICEDGE=WS_EX_STATICEDGE  then listbox.Items.Add(TWS_EX_STATICEDGE) else wsout.Add(TWS_EX_STATICEDGE);
 if styles and  WS_EX_TOOLWINDOW=WS_EX_TOOLWINDOW  then listbox.Items.Add(TWS_EX_TOOLWINDOW) else wsout.Add(TWS_EX_TOOLWINDOW);
 if styles and  WS_EX_TOPMOST=WS_EX_TOPMOST  then listbox.Items.Add(TWS_EX_TOPMOST) else wsout.Add(TWS_EX_TOPMOST);
 if styles and  WS_EX_TRANSPARENT=WS_EX_TRANSPARENT  then listbox.Items.Add(TWS_EX_TRANSPARENT) else wsout.Add(TWS_EX_TRANSPARENT);
 if styles and  WS_EX_WINDOWEDGE=WS_EX_WINDOWEDGE  then listbox.Items.Add(TWS_EX_WINDOWEDGE) else wsout.Add(TWS_EX_WINDOWEDGE);
 for i:=0 to listbox.Items.Count-1 do
   listbox.Checked[i]:=true;
 listbox.Items.AddStrings(wsout);
 wsout.Free;
 listbox.Perform(LB_SETHORIZONTALEXTENT,listbox.Canvas.TextWidth(TWS_EX_PALETTEWINDOW)+30,0);
end;



procedure classStylesToCheckListBox(window:THandle;listbox: TCheckListBox;numeric:tcontrol);
var wsout:tstringlist;
    i,styles:longint;
begin
 styles:=GetClassLong(window,GCL_STYLE);
 setCommonText(numeric,'Window Class styles:   '+Cardinal2Str(styles));
 wsout:=tstringlist.create;
 listbox.Clear;
 if styles and CS_BYTEALIGNCLIENT =CS_BYTEALIGNCLIENT then listbox.Items.Add(TCS_BYTEALIGNCLIENT) else wsout.Add(TCS_BYTEALIGNCLIENT) ;
 if styles and CS_BYTEALIGNWINDOW =CS_BYTEALIGNWINDOW then listbox.Items.Add(TCS_BYTEALIGNWINDOW)else wsout.Add(TCS_BYTEALIGNWINDOW);
 if styles and CS_CLASSDC =CS_CLASSDC then listbox.Items.Add(TCS_CLASSDC) else wsout.Add(TCS_CLASSDC) ;
 if styles and CS_DBLCLKS =CS_DBLCLKS then listbox.Items.Add(TCS_DBLCLKS) else wsout.Add(TCS_DBLCLKS) ;
 if styles and CS_DROPSHADOW =CS_DROPSHADOW then listbox.Items.Add(TCS_DROPSHADOW) else wsout.Add(TCS_DROPSHADOW) ;
 if styles and CS_GLOBALCLASS =CS_GLOBALCLASS then listbox.Items.Add(TCS_GLOBALCLASS)else wsout.Add(TCS_GLOBALCLASS);
 if styles and CS_HREDRAW =CS_HREDRAW then listbox.Items.Add(TCS_HREDRAW) else wsout.Add(TCS_HREDRAW) ;
 if styles and CS_NOCLOSE =CS_NOCLOSE then listbox.Items.Add(TCS_NOCLOSE) else wsout.Add(TCS_NOCLOSE) ;
 if styles and CS_OWNDC =CS_OWNDC then listbox.Items.Add(TCS_OWNDC) else wsout.Add(TCS_OWNDC) ;
 if styles and CS_PARENTDC =CS_PARENTDC then listbox.Items.Add(TCS_PARENTDC) else wsout.Add(TCS_PARENTDC) ;
 if styles and CS_SAVEBITS =CS_SAVEBITS then listbox.Items.Add(TCS_SAVEBITS)else wsout.Add(TCS_SAVEBITS);
 if styles and CS_VREDRAW =CS_VREDRAW then listbox.Items.Add(TCS_VREDRAW) else wsout.Add(TCS_VREDRAW);

 for i:=0 to listbox.Items.Count-1 do
   listbox.Checked[i]:=true;
 listbox.Items.AddStrings(wsout);
 wsout.Free;
end;

procedure windowCustomStylesToCheckListBox(window:THandle;
  listbox: TCheckListBox; numeric:tcontrol);
var wsout:tstringlist;
    i,styles:longint;
    classname:string;
begin
 styles:=GetWindowLong(window,GWL_STYLE);
 SetLength(classname,256);
 SetLength(classname,GetClassName(window,@classname[1],255));
 wsout:=tstringlist.create;
 listbox.Clear;
 setCommonText(numeric,classname+' Styles (=Window Styles): '+Cardinal2Str(styles));
 classname:=UpperCase(string(classname));
 if classname='BUTTON' then begin
   if styles and BS_3STATE = BS_3STATE then listbox.Items.Add(TBS_3STATE)else wsout.Add(TBS_3STATE);
   if styles and BS_AUTO3STATE = BS_AUTO3STATE then listbox.Items.Add(TBS_AUTO3STATE)else wsout.Add(TBS_AUTO3STATE);
   if styles and BS_AUTOCHECKBOX = BS_AUTOCHECKBOX then listbox.Items.Add(TBS_AUTOCHECKBOX)else wsout.Add(TBS_AUTOCHECKBOX);
   if styles and BS_AUTORADIOBUTTON = BS_AUTORADIOBUTTON then listbox.Items.Add(TBS_AUTORADIOBUTTON)else wsout.Add(TBS_AUTORADIOBUTTON);
   if styles and BS_CHECKBOX = BS_CHECKBOX then listbox.Items.Add(TBS_CHECKBOX)else wsout.Add(TBS_CHECKBOX);
   if styles and BS_DEFPUSHBUTTON = BS_DEFPUSHBUTTON then listbox.Items.Add(TBS_DEFPUSHBUTTON)else wsout.Add(TBS_DEFPUSHBUTTON);
   if styles and BS_GROUPBOX = BS_GROUPBOX then listbox.Items.Add(TBS_GROUPBOX)else wsout.Add(TBS_GROUPBOX);
   if styles and BS_LEFTTEXT = BS_LEFTTEXT then listbox.Items.Add(TBS_LEFTTEXT)else wsout.Add(TBS_LEFTTEXT);
   if styles and BS_OWNERDRAW = BS_OWNERDRAW then listbox.Items.Add(TBS_OWNERDRAW)else wsout.Add(TBS_OWNERDRAW);
   if styles and BS_PUSHBUTTON = BS_PUSHBUTTON then listbox.Items.Add(TBS_PUSHBUTTON)else wsout.Add(TBS_PUSHBUTTON);
   if styles and BS_RADIOBUTTON = BS_RADIOBUTTON then listbox.Items.Add(TBS_RADIOBUTTON)else wsout.Add(TBS_RADIOBUTTON);
   if styles and BS_USERBUTTON = BS_USERBUTTON then listbox.Items.Add(TBS_USERBUTTON)else wsout.Add(TBS_USERBUTTON);
   if styles and BS_BITMAP = BS_BITMAP then listbox.Items.Add(TBS_BITMAP)else wsout.Add(TBS_BITMAP);
   if styles and BS_BOTTOM = BS_BOTTOM then listbox.Items.Add(TBS_BOTTOM)else wsout.Add(TBS_BOTTOM);
   if styles and BS_CENTER = BS_CENTER then listbox.Items.Add(TBS_CENTER)else wsout.Add(TBS_CENTER);
   if styles and BS_ICON = BS_ICON then listbox.Items.Add(TBS_ICON)else wsout.Add(TBS_ICON);
   if styles and BS_FLAT = BS_FLAT then listbox.Items.Add(TBS_FLAT)else wsout.Add(TBS_FLAT);
   if styles and BS_LEFT = BS_LEFT then listbox.Items.Add(TBS_LEFT)else wsout.Add(TBS_LEFT);
   if styles and BS_MULTILINE = BS_MULTILINE then listbox.Items.Add(TBS_MULTILINE)else wsout.Add(TBS_MULTILINE);
   if styles and BS_NOTIFY = BS_NOTIFY then listbox.Items.Add(TBS_NOTIFY)else wsout.Add(TBS_NOTIFY);
   if styles and BS_PUSHLIKE = BS_PUSHLIKE then listbox.Items.Add(TBS_PUSHLIKE)else wsout.Add(TBS_PUSHLIKE);
   if styles and BS_RIGHT = BS_RIGHT then listbox.Items.Add(TBS_RIGHT)else wsout.Add(TBS_RIGHT);
   if styles and BS_RIGHTBUTTON = BS_RIGHTBUTTON then listbox.Items.Add(TBS_RIGHTBUTTON)else wsout.Add(TBS_RIGHTBUTTON);
   if styles and BS_TEXT = BS_TEXT then listbox.Items.Add(TBS_TEXT)else wsout.Add(TBS_TEXT);
   if styles and BS_TOP = BS_TOP then listbox.Items.Add(TBS_TOP)else wsout.Add(TBS_TOP);
   if styles and BS_VCENTER = BS_VCENTER then listbox.Items.Add(TBS_VCENTER)else wsout.Add(TBS_VCENTER);
 end;
 if classname='COMBOBOX' then begin
   if styles and CBS_AUTOHSCROLL = CBS_AUTOHSCROLL then listbox.Items.Add(TCBS_AUTOHSCROLL)else wsout.Add(TCBS_AUTOHSCROLL);
   if styles and CBS_DISABLENOSCROLL = CBS_DISABLENOSCROLL then listbox.Items.Add(TCBS_DISABLENOSCROLL)else wsout.Add(TCBS_DISABLENOSCROLL);
   if styles and CBS_DROPDOWN = CBS_DROPDOWN then listbox.Items.Add(TCBS_DROPDOWN)else wsout.Add(TCBS_DROPDOWN);
   if styles and CBS_DROPDOWNLIST = CBS_DROPDOWNLIST then listbox.Items.Add(TCBS_DROPDOWNLIST)else wsout.Add(TCBS_DROPDOWNLIST);
   if styles and CBS_HASSTRINGS = CBS_HASSTRINGS then listbox.Items.Add(TCBS_HASSTRINGS)else wsout.Add(TCBS_HASSTRINGS);
   if styles and CBS_LOWERCASE = CBS_LOWERCASE then listbox.Items.Add(TCBS_LOWERCASE)else wsout.Add(TCBS_LOWERCASE);
   if styles and CBS_NOINTEGRALHEIGHT = CBS_NOINTEGRALHEIGHT then listbox.Items.Add(TCBS_NOINTEGRALHEIGHT)else wsout.Add(TCBS_NOINTEGRALHEIGHT);
   if styles and CBS_OEMCONVERT = CBS_OEMCONVERT then listbox.Items.Add(TCBS_OEMCONVERT)else wsout.Add(TCBS_OEMCONVERT);
   if styles and CBS_OWNERDRAWFIXED = CBS_OWNERDRAWFIXED then listbox.Items.Add(TCBS_OWNERDRAWFIXED)else wsout.Add(TCBS_OWNERDRAWFIXED);
   if styles and CBS_OWNERDRAWVARIABLE = CBS_OWNERDRAWVARIABLE then listbox.Items.Add(TCBS_OWNERDRAWVARIABLE)else wsout.Add(TCBS_OWNERDRAWVARIABLE);
   if styles and CBS_SIMPLE = CBS_SIMPLE then listbox.Items.Add(TCBS_SIMPLE)else wsout.Add(TCBS_SIMPLE);
   if styles and CBS_SORT = CBS_SORT then listbox.Items.Add(TCBS_SORT)else wsout.Add(TCBS_SORT);
   if styles and CBS_UPPERCASE = CBS_UPPERCASE then listbox.Items.Add(TCBS_UPPERCASE)else wsout.Add(TCBS_UPPERCASE);
 end;
 if classname='EDIT' then begin
   if styles and  ES_AUTOHSCROLL=ES_AUTOHSCROLL  then listbox.Items.Add(TES_AUTOHSCROLL)else wsout.Add(TES_AUTOHSCROLL);
   if styles and  ES_AUTOVSCROLL=ES_AUTOVSCROLL  then listbox.Items.Add(TES_AUTOVSCROLL)else wsout.Add(TES_AUTOVSCROLL);
   if styles and  ES_CENTER=ES_CENTER  then listbox.Items.Add(TES_CENTER)else wsout.Add(TES_CENTER);
   if styles and  ES_LEFT=ES_LEFT  then listbox.Items.Add(TES_LEFT)else wsout.Add(TES_LEFT);
   if styles and  ES_LOWERCASE=ES_LOWERCASE  then listbox.Items.Add(TES_LOWERCASE)else wsout.Add(TES_LOWERCASE);
   if styles and ES_MULTILINE = ES_MULTILINE then listbox.Items.Add(TES_MULTILINE)else wsout.Add(TES_MULTILINE);
   if styles and  ES_NOHIDESEL=ES_NOHIDESEL  then listbox.Items.Add(TES_NOHIDESEL)else wsout.Add(TES_NOHIDESEL);
   if styles and ES_NUMBER =ES_NUMBER  then listbox.Items.Add(TES_NUMBER)else wsout.Add(TES_NUMBER);
   if styles and ES_OEMCONVERT =ES_OEMCONVERT  then listbox.Items.Add(TES_OEMCONVERT)else wsout.Add(TES_OEMCONVERT);
   if styles and ES_PASSWORD =ES_PASSWORD  then listbox.Items.Add(TES_PASSWORD)else wsout.Add(TES_PASSWORD);
   if styles and ES_READONLY = ES_READONLY then listbox.Items.Add(TES_READONLY)else wsout.Add(TES_READONLY);
   if styles and ES_RIGHT = ES_RIGHT then listbox.Items.Add(TES_RIGHT)else wsout.Add(TES_RIGHT);
   if styles and ES_UPPERCASE =ES_UPPERCASE  then listbox.Items.Add(TES_UPPERCASE)else wsout.Add(TES_UPPERCASE);
   if styles and ES_WANTRETURN = ES_WANTRETURN then listbox.Items.Add(TES_WANTRETURN)else wsout.Add(TES_WANTRETURN);
 end;
 if classname='LISTBOX' then begin
   if styles and LBS_DISABLENOSCROLL = LBS_DISABLENOSCROLL then listbox.Items.Add(TLBS_DISABLENOSCROLL)else wsout.Add(TLBS_DISABLENOSCROLL);
   if styles and LBS_EXTENDEDSEL = LBS_EXTENDEDSEL then listbox.Items.Add(TLBS_EXTENDEDSEL)else wsout.Add(TLBS_EXTENDEDSEL);
   if styles and LBS_HASSTRINGS = LBS_HASSTRINGS then listbox.Items.Add(TLBS_HASSTRINGS)else wsout.Add(TLBS_HASSTRINGS);
   if styles and LBS_MULTICOLUMN = LBS_MULTICOLUMN then listbox.Items.Add(TLBS_MULTICOLUMN)else wsout.Add(TLBS_MULTICOLUMN);
   if styles and LBS_MULTIPLESEL = LBS_MULTIPLESEL then listbox.Items.Add(TLBS_MULTIPLESEL)else wsout.Add(TLBS_MULTIPLESEL);
   if styles and LBS_NODATA = LBS_NODATA then listbox.Items.Add(TLBS_NODATA)else wsout.Add(TLBS_NODATA);
   if styles and LBS_NOINTEGRALHEIGHT = LBS_NOINTEGRALHEIGHT then listbox.Items.Add(TLBS_NOINTEGRALHEIGHT)else wsout.Add(TLBS_NOINTEGRALHEIGHT);
   if styles and LBS_NOREDRAW = LBS_NOREDRAW then listbox.Items.Add(TLBS_NOREDRAW)else wsout.Add(TLBS_NOREDRAW);
   if styles and LBS_NOSEL =  LBS_NOSEL  then listbox.Items.Add(TLBS_NOSEL)else wsout.Add(TLBS_NOSEL);
   if styles and LBS_NOTIFY = LBS_NOTIFY then listbox.Items.Add(TLBS_NOTIFY)else wsout.Add(TLBS_NOTIFY);
   if styles and LBS_OWNERDRAWFIXED = LBS_OWNERDRAWFIXED then listbox.Items.Add(TLBS_OWNERDRAWFIXED)else wsout.Add(TLBS_OWNERDRAWFIXED);
   if styles and LBS_OWNERDRAWVARIABLE = LBS_OWNERDRAWVARIABLE then listbox.Items.Add(TLBS_OWNERDRAWVARIABLE)else wsout.Add(TLBS_OWNERDRAWVARIABLE);
   if styles and LBS_SORT = LBS_SORT then listbox.Items.Add(TLBS_SORT)else wsout.Add(TLBS_SORT);
   if styles and LBS_STANDARD = LBS_STANDARD then listbox.Items.Add(TLBS_STANDARD)else wsout.Add(TLBS_STANDARD);
   if styles and LBS_USETABSTOPS = LBS_USETABSTOPS then listbox.Items.Add(TLBS_USETABSTOPS)else wsout.Add(TLBS_USETABSTOPS);
   if styles and LBS_WANTKEYBOARDINPUT = LBS_WANTKEYBOARDINPUT then listbox.Items.Add(TLBS_WANTKEYBOARDINPUT)else wsout.Add(TLBS_WANTKEYBOARDINPUT);
 end;
 if (classname='RICHEDIT') or (classname='RICHEDIT_CLASS') then begin
   if styles and  ES_AUTOHSCROLL=ES_AUTOHSCROLL  then listbox.Items.Add(TES_AUTOHSCROLL)else wsout.Add(TES_AUTOHSCROLL);
   if styles and  ES_AUTOVSCROLL=ES_AUTOVSCROLL  then listbox.Items.Add(TES_AUTOVSCROLL)else wsout.Add(TES_AUTOVSCROLL);
   if styles and  ES_CENTER=ES_CENTER  then listbox.Items.Add(TES_CENTER)else wsout.Add(TES_CENTER);
   if styles and  ES_LEFT=ES_LEFT  then listbox.Items.Add(TES_LEFT)else wsout.Add(TES_LEFT);
   if styles and ES_MULTILINE = ES_MULTILINE then listbox.Items.Add(TES_MULTILINE)else wsout.Add(TES_MULTILINE);
   if styles and  ES_NOHIDESEL=ES_NOHIDESEL  then listbox.Items.Add(TES_NOHIDESEL)else wsout.Add(TES_NOHIDESEL);
   if styles and ES_NUMBER =ES_NUMBER  then listbox.Items.Add(TES_NUMBER)else wsout.Add(TES_NUMBER);
   if styles and ES_PASSWORD =ES_PASSWORD  then listbox.Items.Add(TES_PASSWORD)else wsout.Add(TES_PASSWORD);
   if styles and ES_READONLY = ES_READONLY then listbox.Items.Add(TES_READONLY)else wsout.Add(TES_READONLY);
   if styles and ES_RIGHT = ES_RIGHT then listbox.Items.Add(TES_RIGHT)else wsout.Add(TES_RIGHT);
   if styles and ES_WANTRETURN = ES_WANTRETURN then listbox.Items.Add(TES_WANTRETURN)else wsout.Add(TES_WANTRETURN);
   if styles and  ES_DISABLENOSCROLL=ES_DISABLENOSCROLL then listbox.Items.Add(TES_DISABLENOSCROLL)else wsout.Add(TES_DISABLENOSCROLL);
   if styles and ES_NOIME = ES_NOIME then listbox.Items.Add(TES_NOIME)else wsout.Add(TES_NOIME);
   if styles and ES_SELFIME = ES_SELFIME then listbox.Items.Add(TES_SELFIME)else wsout.Add(TES_SELFIME);
   if styles and  ES_SUNKEN=ES_SUNKEN  then listbox.Items.Add(TES_SUNKEN)else wsout.Add(TES_SUNKEN);
   if styles and ES_VERTICAL = ES_VERTICAL then listbox.Items.Add(TES_VERTICAL)else wsout.Add(TES_VERTICAL);
 end;
 if classname='SCROLLBAR' then begin
   if styles and SBS_BOTTOMALIGN = SBS_BOTTOMALIGN then listbox.Items.Add(TSBS_BOTTOMALIGN)else wsout.Add(TSBS_BOTTOMALIGN);
   if styles and SBS_HORZ = SBS_HORZ then listbox.Items.Add(TSBS_HORZ)else wsout.Add(TSBS_HORZ);
   if styles and SBS_LEFTALIGN =SBS_LEFTALIGN  then listbox.Items.Add(TSBS_LEFTALIGN)else wsout.Add(TSBS_LEFTALIGN);
   if styles and SBS_RIGHTALIGN =SBS_RIGHTALIGN then listbox.Items.Add(TSBS_RIGHTALIGN)else wsout.Add(TSBS_RIGHTALIGN);
   if styles and SBS_SIZEBOX =SBS_SIZEBOX  then listbox.Items.Add(TSBS_SIZEBOX)else wsout.Add(TSBS_SIZEBOX);
   if styles and SBS_SIZEBOXBOTTOMRIGHTALIGN= SBS_SIZEBOXBOTTOMRIGHTALIGN then listbox.Items.Add(TSBS_SIZEBOXBOTTOMRIGHTALIGN)else wsout.Add(TSBS_SIZEBOXBOTTOMRIGHTALIGN);
   if styles and SBS_SIZEBOXTOPLEFTALIGN = SBS_SIZEBOXTOPLEFTALIGN then listbox.Items.Add(TSBS_SIZEBOXTOPLEFTALIGN)else wsout.Add(TSBS_SIZEBOXTOPLEFTALIGN);
   if styles and SBS_SIZEGRIP = SBS_SIZEGRIP then listbox.Items.Add(TSBS_SIZEGRIP)else wsout.Add(TSBS_SIZEGRIP);
   if styles and SBS_TOPALIGN = SBS_TOPALIGN then listbox.Items.Add(TSBS_TOPALIGN)else wsout.Add(TSBS_TOPALIGN);
   if styles and SBS_VERT = SBS_VERT then listbox.Items.Add(TSBS_VERT)else wsout.Add(TSBS_VERT);
 end;
 if classname='STATIC' then begin
   if styles and SS_BITMAP = SS_BITMAP then listbox.Items.Add(TSS_BITMAP)else wsout.Add(TSS_BITMAP);
   if styles and SS_BLACKFRAME = SS_BLACKFRAME then listbox.Items.Add(TSS_BLACKFRAME)else wsout.Add(TSS_BLACKFRAME);
   if styles and SS_BLACKRECT = SS_BLACKRECT then listbox.Items.Add(TSS_BLACKRECT)else wsout.Add(TSS_BLACKRECT);
   if styles and SS_CENTER = SS_CENTER then listbox.Items.Add(TSS_CENTER)else wsout.Add(TSS_CENTER);
   if styles and SS_CENTERIMAGE = SS_CENTERIMAGE then listbox.Items.Add(TSS_CENTERIMAGE)else wsout.Add(TSS_CENTERIMAGE);
 {TODO: wieder einfügen
   if styles and SS_ENDELLIPSIS  = SS_ENDELLIPSIS  then listbox.Items.Add(TSS_ENDELLIPSIS )else wsout.Add(TSS_ENDELLIPSIS );
   if styles and SS_ENHMETAFILE = SS_ENHMETAFILE then listbox.Items.Add(TSS_ENHMETAFILE)else wsout.Add(TSS_ENHMETAFILE);
   if styles and SS_ETCHEDFRAME = SS_ETCHEDFRAME then listbox.Items.Add(TSS_ETCHEDFRAME)else wsout.Add(TSS_ETCHEDFRAME);
   if styles and SS_ETCHEDHORZ = SS_ETCHEDHORZ then listbox.Items.Add(TSS_ETCHEDHORZ)else wsout.Add(TSS_ETCHEDHORZ);
   if styles and SS_ETCHEDVERT = SS_ETCHEDVERT then listbox.Items.Add(TSS_ETCHEDVERT)else wsout.Add(TSS_ETCHEDVERT);
   if styles and SS_GRAYFRAME = SS_GRAYFRAME then listbox.Items.Add(TSS_GRAYFRAME)else wsout.Add(TSS_GRAYFRAME);
   if styles and SS_GRAYRECT = SS_GRAYRECT then listbox.Items.Add(TSS_GRAYRECT)else wsout.Add(TSS_GRAYRECT);
   if styles and SS_ICON = SS_ICON then listbox.Items.Add(TSS_ICON)else wsout.Add(TSS_ICON);
   if styles and SS_LEFT = SS_LEFT then listbox.Items.Add(TSS_LEFT)else wsout.Add(TSS_LEFT);
   if styles and SS_LEFTNOWORDWRAP = SS_LEFTNOWORDWRAP then listbox.Items.Add(TSS_LEFTNOWORDWRAP)else wsout.Add(TSS_LEFTNOWORDWRAP);
   if styles and SS_NOPREFIX = SS_NOPREFIX then listbox.Items.Add(TSS_NOPREFIX)else wsout.Add(TSS_NOPREFIX);
   if styles and SS_NOTIFY = SS_NOTIFY then listbox.Items.Add(TSS_NOTIFY)else wsout.Add(TSS_NOTIFY);
   if styles and SS_OWNERDRAW = SS_OWNERDRAW then listbox.Items.Add(TSS_OWNERDRAW)else wsout.Add(TSS_OWNERDRAW);
   if styles and SS_PATHELLIPSIS = SS_PATHELLIPSIS then listbox.Items.Add(TSS_PATHELLIPSIS)else wsout.Add(TSS_PATHELLIPSIS);
//   if styles and SS_REALSIZECONTROL = SS_REALSIZECONTROL then listbox.Items.Add(TSS_REALSIZECONTROL)else wsout.Add(TSS_REALSIZECONTROL);
   if styles and SS_REALSIZEIMAGE = SS_REALSIZEIMAGE then listbox.Items.Add(TSS_REALSIZEIMAGE)else wsout.Add(TSS_REALSIZEIMAGE);
   if styles and SS_RIGHT = SS_RIGHT then listbox.Items.Add(TSS_RIGHT)else wsout.Add(TSS_RIGHT);
   if styles and SS_RIGHTJUST = SS_RIGHTJUST then listbox.Items.Add(TSS_RIGHTJUST)else wsout.Add(TSS_RIGHTJUST);
   if styles and SS_SIMPLE = SS_SIMPLE then listbox.Items.Add(TSS_SIMPLE)else wsout.Add(TSS_SIMPLE);
   if styles and SS_SUNKEN = SS_SUNKEN then listbox.Items.Add(TSS_SUNKEN)else wsout.Add(TSS_SUNKEN);
   if styles and SS_WHITEFRAME = SS_WHITEFRAME then listbox.Items.Add(TSS_WHITEFRAME)else wsout.Add(TSS_WHITEFRAME);
   if styles and SS_WHITERECT = SS_WHITERECT then listbox.Items.Add(TSS_WHITERECT)else wsout.Add(TSS_WHITERECT);
   if styles and SS_WORDELLIPSIS = SS_WORDELLIPSIS then listbox.Items.Add(TSS_WORDELLIPSIS)else wsout.Add(TSS_WORDELLIPSIS);
   }
 end;

 for i:=0 to listbox.Items.Count-1 do
   listbox.Checked[i]:=true;
 listbox.Items.AddStrings(wsout);
 wsout.Free;
end;

procedure changeWindowStyle(window: THandle; name: string; enabled: boolean);
var styles,style:longint;
begin
  name:=UpperCase(name);
  if name=TWS_BORDER then style:=WS_BORDER else
  if name=TWS_CAPTION then style:=WS_CAPTION else
  if name=TWS_CHILD then style:=WS_CHILD else
  if name=TWS_CHILDWINDOW then style:=WS_CHILDWINDOW else
  if name=TWS_CLIPCHILDREN then style:=WS_CLIPCHILDREN else
  if name=TWS_CLIPSIBLINGS then style:=WS_CLIPSIBLINGS else
  if name=TWS_DISABLED then style:=WS_DISABLED else
  if name=TWS_DLGFRAME then style:=WS_DLGFRAME else
  if name=TWS_GROUP then style:=WS_GROUP else
  if name=TWS_HSCROLL then style:=WS_HSCROLL else
  if name=TWS_ICONIC then style:=WS_ICONIC else
  if name=TWS_MAXIMIZE then style:=WS_MAXIMIZE else
  if name=TWS_MAXIMIZEBOX then style:=WS_MAXIMIZEBOX else
  if name=TWS_MINIMIZE then style:=WS_MINIMIZE else
  if name=TWS_MINIMIZEBOX then style:=WS_MINIMIZEBOX else
  if name=TWS_OVERLAPPED then style:=WS_OVERLAPPED else
  if name=TWS_OVERLAPPEDWINDOW then style:=WS_OVERLAPPEDWINDOW else
  if name=TWS_POPUP then style:=WS_POPUP else
  if name=TWS_POPUPWINDOW then style:=WS_POPUPWINDOW else
  if name=TWS_SIZEBOX then style:=WS_SIZEBOX else
  if name=TWS_SYSMENU then style:=WS_SYSMENU else
  if name=TWS_TABSTOP then style:=WS_TABSTOP else
  if name=TWS_THICKFRAME then style:=WS_THICKFRAME else
  if name=TWS_TILED then style:=WS_TILED else
  if name=TWS_TILEDWINDOW then style:=WS_TILEDWINDOW else
  if name=TWS_VISIBLE then style:=WS_VISIBLE else
  if name=TWS_VSCROLL then style:=WS_VSCROLL;

  styles:=GetWindowLong(window,GWL_STYLE);
  if enabled then style:=styles or style
  else style:=styles and not style;
  if styles = style then exit;
  SetWindowLong(window,GWL_STYLE,style);
  RedrawWindow(window,nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);
  if GetParent(window)<>0 then
    RedrawWindow(getparent(window),nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN)
end;

procedure changeWindowExStyle(window: THandle; name: string; enabled: boolean);
var styles,newstyle:longint;
begin
  name:=UpperCase(name);

  if name=TWS_EX_ACCEPTFILES then newstyle:=WS_EX_ACCEPTFILES else
  if name=TWS_EX_APPWINDOW then newstyle:=WS_EX_APPWINDOW else
  if name=TWS_EX_CLIENTEDGE then newstyle:=WS_EX_CLIENTEDGE else
  if name=TWS_EX_COMPOSITED  then newstyle:=WS_EX_COMPOSITED  else
  if name=TWS_EX_CONTEXTHELP then newstyle:=WS_EX_CONTEXTHELP else
  if name=TWS_EX_CONTROLPARENT then newstyle:=WS_EX_CONTROLPARENT else
  if name=TWS_EX_DLGMODALFRAME then newstyle:=WS_EX_DLGMODALFRAME else
  if name=TWS_EX_LAYERED then newstyle:=WS_EX_LAYERED else
  if name=TWS_EX_LAYOUTRTL then newstyle:=WS_EX_LAYOUTRTL else
  if name=TWS_EX_LEFT then newstyle:=WS_EX_LEFT else
  if name=TWS_EX_LEFTSCROLLBAR then newstyle:=WS_EX_LEFTSCROLLBAR else
  if name=TWS_EX_LTRREADING then newstyle:=WS_EX_LTRREADING else
  if name=TWS_EX_MDICHILD then newstyle:=WS_EX_MDICHILD else
  if name=TWS_EX_NOACTIVATE then newstyle:=WS_EX_NOACTIVATE else
  if name=TWS_EX_NOINHERITLAYOUT then newstyle:=WS_EX_NOINHERITLAYOUT else
  if name=TWS_EX_NOPARENTNOTIFY then newstyle:=WS_EX_NOPARENTNOTIFY else
  if name=TWS_EX_OVERLAPPEDWINDOW then newstyle:=WS_EX_OVERLAPPEDWINDOW else
  if name=TWS_EX_PALETTEWINDOW then newstyle:=WS_EX_PALETTEWINDOW else
  if name=TWS_EX_RIGHT then newstyle:=WS_EX_RIGHT else
  if name=TWS_EX_RIGHTSCROLLBAR then newstyle:=WS_EX_RIGHTSCROLLBAR else
  if name=TWS_EX_RTLREADING then newstyle:=WS_EX_RTLREADING else
  if name=TWS_EX_STATICEDGE then newstyle:=WS_EX_STATICEDGE else
  if name=TWS_EX_TOOLWINDOW then newstyle:=WS_EX_TOOLWINDOW else
  if name=TWS_EX_TOPMOST then newstyle:=WS_EX_TOPMOST else
  if name=TWS_EX_TRANSPARENT then newstyle:=WS_EX_TRANSPARENT else
  if name=TWS_EX_WINDOWEDGE then newstyle:=WS_EX_WINDOWEDGE;

  styles:=GetWindowLong(window,GWL_EXSTYLE);
  if enabled then newstyle:=styles or newstyle
  else newstyle:=styles and not newstyle;
  if styles = newstyle then exit;
  SetWindowLong(window,GWL_EXSTYLE,newstyle);
  RedrawWindow(window,nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);
  if GetParent(window)<>0 then
    RedrawWindow(getparent(window),nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN)
end;

procedure changeCustomStyle(window: THandle; name: string; enabled: boolean);
var styles,newstyle:longint;
begin

  styles:=GetWindowLong(window,GWL_STYLE);
  if enabled then newstyle:=styles or newstyle
  else newstyle:=styles and not newstyle;
  if styles = newstyle then exit;
  SetWindowLong(window,GWL_STYLE,newstyle);
  RedrawWindow(window,nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);
  if GetParent(window)<>0 then
    RedrawWindow(getparent(window),nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN)
end;

end.

