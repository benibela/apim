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
unit systemOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls,LDockCtrl, ExtCtrls,TreeListView,LCLType;

type

  { TsystemOptionsFrm }

  TsystemOptionsFrm = class(TForm)
    callAPI: TButton;
    callAPIDLL: TEdit;
    callAPIParameter: TEdit;
    callAPIProc: TComboBox;
    callAPIResult_lbl: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    systemProperties: TPanel;
    Timer1: TTimer;
    procedure callAPIClick(Sender: TObject);
    procedure callAPIDLLChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    systemTLV: TTreeListView;
    { public declarations }
    Docker: TLazControlDocker;
    //System/Sonstiges
    procedure displaySysProperties();
  end;

var
  systemOptionsFrm: TsystemOptionsFrm;

implementation
uses bbutils,windowcontrolfuncs,applicationConfig,ptranslateutils,PEStuff;

{$I systemoptions.atr}

{ TsystemOptionsFrm }

procedure TsystemOptionsFrm.FormShow(Sender: TObject);
begin
  threadedCall(@calculateSysProperties,nil);   //#TODO -1: find a way to update everything?
  Timer1Timer(nil);
  //#todo -1: autostart
end;

procedure TsystemOptionsFrm.Timer1Timer(Sender: TObject);
begin
  //the information is get by another thread, check if it is finished
  //(direct calling is difficult, because this form can be closed while it
  //is calculating)
  if not systemPropertiesFinished then exit;
  displaySysProperties();
  Timer1.Enabled:=false;
end;

procedure TsystemOptionsFrm.Timer2Timer(Sender: TObject);
begin

end;

procedure TsystemOptionsFrm.displaySysProperties();
var i:longint;
    curCat: TTreeListItem;
begin
  systemTLV.BeginUpdate;
  systemTLV.items.Clear;
  for i:=0 to high(systemPropertiesArray) do
    if systemPropertiesArray[i].value='[cat]' then
      curCat:=systemTLV.Items.add(systemPropertiesArray[i].name)
     else if curCat<>nil then
       curCat.SubItems.Add(systemPropertiesArray[i].name).RecordItemsText[1]:=systemPropertiesArray[i].value;
  systemTLV.EndUpdate;
end;

procedure TsystemOptionsFrm.callAPIClick(Sender: TObject);
begin
  //#todo -1: gui parameter edit
  callAPIResult_lbl.Caption:=Cardinal2Str(genericCall(callAPIDLL.Text,callAPIProc.Text,createMemoryBlocks(callAPIParameter.Text)));
end;

procedure TsystemOptionsFrm.callAPIDLLChange(Sender: TObject);
begin
  listExportNames(callAPIDLL.Text,callAPIProc.Items);
  callAPIProc.Sorted:=true;
end;

procedure TsystemOptionsFrm.FormCreate(Sender: TObject);
begin
  Docker:=TLazControlDocker.Create(Self);
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);
  systemTLV:=TTreeListView.Create(self);
  systemTLV.Parent:=systemProperties;
  systemTLV.Align:=alClient;
  systemTLV.Columns.Clear;
  with systemTLV.Columns.Add do begin
    text:=tr['Eigenschaft'];
    Width:=200;
  end;
  with systemTLV.Columns.add do begin
    text:=tr['Wert'];
    Width:=200;
  end;
end;

procedure TsystemOptionsFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (shift = [ssCtrl]) and (key=VK_SPACE) then begin
    openWindowsConst(true);
    key:=0;
  end;
end;

initialization
  {$I systemoptions.lrs}

end.

