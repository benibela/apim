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
unit winconstwindow;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,LCLType;

type

  { TwindowConstForm }

  TwindowConstForm = class(TForm)
    Edit1: TEdit;
    ListBox1: TListBox;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { private declarations }
    winConsts: TStringList;
  public
    { public declarations }
    currentConst: string;
  end;

var
  windowConstForm: TwindowConstForm;

implementation
uses applicationConfig,FileUtil,ptranslateutils;
{$I winconstwindow.atr}

{ TwindowConstForm }

procedure TwindowConstForm.FormCreate(Sender: TObject);
begin
  initUnitTranslation(CurrentUnitName,tr);
end;

procedure TwindowConstForm.FormDestroy(Sender: TObject);
begin
  winConsts.Free;
end;

procedure TwindowConstForm.FormShow(Sender: TObject);
var i:longint;
    path,s:string;
    searchRec:TSearchRec;
    tempSL:TStringList;
begin
  if left+width>Screen.width then
    left:=screen.width-width;
  if top+height>Screen.height then
    top:=screen.height-height;
  if winConsts=nil then begin
    winConsts:=TStringList.Create;

    try
      path:=winConstPath;
      if not FilenameIsAbsolute(winConstPath) then path:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+path;
      path:=IncludeTrailingPathDelimiter(path);
      if DirectoryExistsUTF8(ExcludeTrailingPathDelimiter(path)) then begin
        tempSL:=TStringList.Create;
        FindFirst(path+'*.*',faAnyFile,searchRec);
        repeat
          if searchRec.Name='' then continue;
          if searchRec.Name[1]='.' then continue;

          tempSL.LoadFromFile(path+searchRec.Name);
          for i:=0 to tempSL.count-1 do begin
            s:=trim(tempSL[i]);
            if s='' then continue; //skip empty
            if ((s[1]='{') and (s[length(s)]='}')) or
               ((s[1]='/') and (s[2] = '/')) then continue; //skip comment only
            winConsts.Add(s);
          end;
        until FindNext(searchRec)<>0;
        FindClose(searchRec);
        tempSL.Free;
      end;
    except
    end;
  end;
  if winConsts.Count=0 then begin
    winConsts.free;
    winConsts:=nil;
    ListBox1.items.text:=tr['Keine Windowskonstanten gefunden'#13#10'Überprüfen Sie den Pfad: ']+winConstPath;
  end else ListBox1.Items.Text:=tr['Suche in der FreePascal Windows Unit'];
  Edit1.text:=currentConst;
  edit1.SetFocus;
  edit1.SelStart:=length(edit1.text);
end;

procedure TwindowConstForm.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex<0 then exit;
  Edit1.Text:=ListBox1.items[ListBox1.ItemIndex];
end;

procedure TwindowConstForm.Edit1Change(Sender: TObject);
var s:string; i:longint;
begin
  if winConsts=nil then exit;
  s:=LowerCase(Edit1.Text);
  if s='' then exit;
  ListBox1.Clear;
  ListBox1.Items.BeginUpdate;
  for i:=0 to winConsts.Count-1 do
    if pos(s,LowerCase(winConsts[i]))>0 then
      ListBox1.Items.Add(winConsts[i]);
  ListBox1.Items.EndUpdate;
  ListBox1.ItemIndex:=0;
end;

procedure TwindowConstForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_up then begin
    if ListBox1.ItemIndex>0 then
      ListBox1.ItemIndex:=ListBox1.ItemIndex-1;
    key:=0;
  end else if key=VK_DOWN then begin
    ListBox1.ItemIndex:=ListBox1.ItemIndex+1;
    key:=0;
  end else if key=VK_PRIOR then begin
    if ListBox1.ItemIndex>=10 then ListBox1.ItemIndex:=ListBox1.ItemIndex-10
    else ListBox1.ItemIndex:=0;
  end else if key=VK_NEXT then begin
    if ListBox1.ItemIndex<=ListBox1.Items.Count-11 then ListBox1.ItemIndex:=ListBox1.ItemIndex+10
    else ListBox1.ItemIndex:=ListBox1.Items.Count-1;
  end
//     Application.ControlKeyDown(ListBox1,Key,shift);
//      ListBox1.ControlKeyDown(key,shift);
end;

procedure TwindowConstForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin
    ModalResult:=mrOK;
    if ListBox1.ItemIndex>=0 then
      if shift = [ssCtrl] then currentConst+=ListBox1.items[ListBox1.ItemIndex]
      else currentConst:=ListBox1.items[ListBox1.ItemIndex];
    key:=0;
    close
  end else if key=VK_ESCAPE then begin
    ModalResult:=mrCancel;
    currentConst:='';
    close
  end ;
end;

initialization
  {$I winconstwindow.lrs}

end.

