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
unit windowList;
//#TODO -1: nur visible/enable filter
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, TreeListView,StdCtrls,LDockCtrl,windowcontrolfuncs, Menus;

type

  { TWindowListFrm }

  TWindowListFrm = class(TForm)
    Label12: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    windowListFilterParentUp: TButton;
    windowListFilterParent_edt: TEdit;
    windowListFilterProgram_edt: TEdit;
    windowsListfilterDirectChilds: TCheckBox;
    windowListFilterThread: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure windowListDblClick(Sender: TObject);
    procedure windowListFilterParentUpClick(Sender: TObject);
    procedure windowListFilterParent_edtChange(Sender: TObject);
    procedure windowListFilterParent_edtDblClick(Sender: TObject);
    procedure windowListFilterParent_edtKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure windowListFilterProgram_edtDblClick(Sender: TObject);
    procedure windowListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure windowListSelectItem(sender: TObject; item: TTreeListItem);
    procedure windowsListfilterDirectChildsChange(Sender: TObject);
    procedure windowTreeListExpandItem(sender: TObject; item: TTreeListItem);
  private
    { private declarations }
    //WindowListFrm
    windowTreeList: TTreeListView;
    procedure displayWindows(itemExtend:TTreeListItem=nil);
    procedure showHandle(sender:tobject; wnd: THandle;func:longint);
  public
    { public declarations }
    Docker: TLazControlDocker;
    callback:TCallbackComponent;
  end;

var
  WindowListFrm: TWindowListFrm;

implementation
uses applicationConfig,windows,bbutils,windowfuncs,ptranslateutils;
const WL_PROGRAM_COLUMN=5;
{$i windowList.atr}


{ TWindowListFrm }

procedure TWindowListFrm.FormCreate(Sender: TObject);
begin
  initUnitTranslation('windowlist',tr);
  tr.translate(self);
  Docker:=TLazControlDocker.Create(Self);
  callback:=TCallbackComponent.create(self);
  callback.onShowHandle:=@showHandle;
  //=========WindowListFrm===========
  windowTreeList:= TTreeListView.create(self);
  windowTreeList.Visible:=true;
  windowTreeList.Align:=alClient;
  windowTreeList.OnItemExpanded:=@windowTreeListExpandItem;
  windowTreeList.OnKeyUp:=@windowListKeyUp;
  windowTreeList.OnSelect:=@windowListSelectItem;
  windowTreeList.OnDblClick:=@windowListDblClick;
  windowTreeList.Options:=windowTreeList.Options+[tlvoSorted,tlvoColumnsDragable];
  windowTreeList.Columns.Clear;
  with windowTreeList.Columns.add do begin
    Text:=tr['Handle'];
    Width:=140;
  end;
  with windowTreeList.Columns.Add do begin
    text:=tr['Titel'];
    Width:=140;
  end;
  with windowTreeList.Columns.Add do begin
    text:=tr['Klasse'];
    Width:=100;
  end;
  with windowTreeList.Columns.Add do begin
    text:=tr['Status'];
    Width:=100;
  end;
  with windowTreeList.Columns.Add do begin
    text:=tr['Größe'];
    Width:=130;
  end;
  with windowTreeList.Columns.Add do begin
    text:=tr['Programm'];
    Width:=150;
  end;
  windowTreeList.PopupMenu:=PopupMenu1;
  windowTreeList.CreateSearchBar();
  windowTreeList.Parent:=self;
end;

procedure TWindowListFrm.FormDestroy(Sender: TObject);
begin
  windowTreeList.Free();
end;

procedure TWindowListFrm.FormShow(Sender: TObject);
begin
  displayWindows();
end;

procedure TWindowListFrm.MenuItem1Click(Sender: TObject);
begin
  if windowTreeList.focused=nil then exit;
  windowListFilterParent_edt.Text:=windowTreeList.focused.Text;
  displayWindows();
end;

procedure TWindowListFrm.MenuItem2Click(Sender: TObject);
begin
  if windowTreeList.focused=nil then exit;
  windowListFilterProgram_edt.Text:=windowTreeList.focused.RecordItemsText[WL_PROGRAM_COLUMN];
  displayWindows();
end;

procedure TWindowListFrm.windowListDblClick(Sender: TObject);
begin
  if windowTreeList.focused=nil then exit;
  callback.showHandle(Str2Cardinal(windowTreeList.focused.Text),PROPERTYSHEETFRM_ID);
end;

procedure TWindowListFrm.windowListFilterParentUpClick(Sender: TObject);
var curHandle,parentHandle: string;
    handleItem: TTreeListItem;
begin
  parentHandle:=windowListFilterParent_edt.text;
  if windowTreeList.focused = nil then curHandle:=parentHandle
  else curHandle:=windowTreeList.focused.Text;
  windowListFilterParent_edt.text:=Cardinal2Str(getRealParent(Str2Cardinal(windowListFilterParent_edt.text)));
  displayWindows;
  if curHandle <>'' then begin
    handleItem:=windowTreeList.items.FindItemWithText(curHandle);
    if handleItem=nil then begin
      handleItem:=windowTreeList.items.FindItemWithText(parentHandle);
      if (handleItem<>nil) and (not handleItem.Parent.Expanded) then begin
        handleItem.Parent.Expand;
        handleItem:=windowTreeList.items.FindItemWithText(curHandle);
      end;
    end;
    if handleItem<>nil then windowTreeList.Selected:=handleItem.Parent;
  end;
end;

procedure TWindowListFrm.windowListFilterParent_edtChange(Sender: TObject);
begin
  windowsListfilterDirectChilds.Enabled:=StrToIntDef(windowListFilterParent_edt.Text,0)<>0;
end;

procedure TWindowListFrm.windowListFilterParent_edtDblClick(Sender: TObject);
begin
  callback.showHandle(Str2Cardinal(windowListFilterParent_edt.Text),PROPERTYSHEETFRM_ID)
end;

procedure TWindowListFrm.windowListFilterParent_edtKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key=VK_RETURN then displayWindows;
end;

procedure TWindowListFrm.windowListFilterProgram_edtDblClick(Sender: TObject);
  function extractHandle(s: string):thandle;
  begin
    if isStrCardinal(s) then exit(Str2Cardinal(s));
    if (pos('(',s)>0) and (pos(')',s)>pos('(',s)) then
      exit(Str2CardinalDef(strcopy2(s,pos('(',s)+1,pos(')',s)-1),0));
    if windowTreeList.Items.Count=0 then exit;
    s:=lowercase(s);
    if pos(s,lowercase(windowTreeList.Items[0].RecordItemsText[WL_PROGRAM_COLUMN]))=0 then
      displayWindows();
    if pos(s,lowercase(windowTreeList.Items[0].RecordItemsText[WL_PROGRAM_COLUMN]))=0 then
      exit(0);
    s:=windowTreeList.Items[0].RecordItemsText[WL_PROGRAM_COLUMN];
    if (pos('(',s)>0) and (pos(')',s)>pos('(',s)) then
      exit(Str2CardinalDef(strcopy2(s,pos('(',s)+1,pos(')',s)-1),0));
   end;
var temp:thandle;
begin
  temp:=extractHandle(windowListFilterProgram_edt.Text) ;
  if temp<>0 then
    callback.showHandle(temp,PROCESSLISTFRM_ID);
end;

procedure TWindowListFrm.windowListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_F5 then displayWindows;
end;

procedure TWindowListFrm.windowListSelectItem(sender: TObject;
  item: TTreeListItem);
begin

end;

procedure TWindowListFrm.windowsListfilterDirectChildsChange(Sender: TObject);
begin
  displayWindows;
end;

procedure TWindowListFrm.windowTreeListExpandItem(sender: TObject;
  item: TTreeListItem);
begin
  if item.SubItems.count=0 then exit;
  if item.SubItems[0].Text='Dummy' then begin
    displayWindows(item);
  end;
end;

procedure TWindowListFrm.displayWindows(itemExtend: TTreeListItem);
var i,j:longint;
    wnd,parentWnd:hwnd;
    parentItem: TTreeListItem;
    list:TIntArray;
    s,programS:string;
    filterParentWnd: thandle;
    filterProgram: string;
begin
  //#TODO -1: show icons
  //#todo -1: preserve focus and enable auto refresh
  filterProgram:=lowercase(windowListFilterProgram_edt.Text);
  if itemExtend <> nil then filterParentWnd:=Str2Cardinal(itemExtend.Text)
  else if windowListFilterParent_edt.text<>'' then filterParentWnd:=Str2Cardinal(windowListFilterParent_edt.text)
  else filterParentWnd:=0;
  list:=EnumWindowsToIntList(filterParentWnd,not windowsListfilterDirectChilds.Checked);
  windowTreeList.BeginUpdate;
  if itemExtend=nil then windowTreeList.Items.Clear
  else itemExtend.SubItems.Clear;
  for i:=0 to high(list) do begin
    wnd:=list[i];
    programS:=GetFileNameFromHandleToDisplay(wnd);
    if (filterProgram<>'') and (pos(filterProgram,LowerCase(programS))<=0) then continue;
    parentWnd:=getRealParent(wnd);
    parentItem:=nil;
    if (parentWnd<>0) and (filterParentWnd <> 0) then
      parentItem:=windowTreeList.Items.FindItemWithText(Cardinal2Str(parentWnd));
    with windowTreeList.Items.Add(parentItem) do begin
      if (filterParentWnd = 0) then
        if GetWindow(wnd,GW_CHILD)<>0 then begin
          SubItems.Add('Dummy'); //will be expanded later
          Expanded:=false;
        end;

      Text:=Cardinal2Str(wnd);
{      if filterParentWnd <> 0 then begin
        nextParent:=getparent(wnd);
        while nextParent<>filterParentWnd do begin
          nextParent:=getparent(nextParent);
          Caption:='  '+Caption;
        end;
      end;}

      RecordItems.Add(getwindowtexts(wnd));
      RecordItems.Add(getWindowClassNameToDisplay(wnd));
      s:='';
      if IsWindowVisible(wnd) then s:=s+'visible';//'Visible: true | ' else s:=s+'Visible: false | ';
      if IsWindowEnabled(wnd) then begin
        if s<>'' then s:=s+', ';//Enable: true' else s:=s+'Enable: false';
        s+='enabled';
      end;
      RecordItems.Add(s);
      RecordItems.Add(GetWindowPosStr(wnd));
      RecordItemsText[WL_PROGRAM_COLUMN]:=programS;
    end;
  end;
  windowTreeList.EndUpdate;
end;

procedure TWindowListFrm.showHandle(sender: tobject; wnd: THandle;func:longint);
var proc: THANDLE;
begin
  case func of
    1: begin
      windowListFilterProgram_edt.Text:=Cardinal2Str(wnd);
      GetWindowThreadProcessId(Str2CardinalDef(windowListFilterParent_edt.Text,0),proc);
      if proc<>wnd then windowListFilterParent_edt.Text:='';
      windowListFilterThread.Text:='';
      displayWindows();
    end;
    else begin
      GetWindowThreadProcessId(wnd,proc);
      if proc<>Str2CardinalDef(windowListFilterProgram_edt.Text,0) then windowListFilterProgram_edt.Text:='';
      windowListFilterThread.Text:='';
      windowListFilterParent_edt.Text:=Cardinal2Str(wnd);
      displayWindows();
    end;
  end;
end;

initialization
  {$I windowList.lrs}

end.

