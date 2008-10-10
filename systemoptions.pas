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
  StdCtrls, ComCtrls,LDockCtrl, ExtCtrls;

type

  { TsystemOptionsFrm }

  TsystemOptionsFrm = class(TForm)
    callAPI: TButton;
    callAPIDLL: TEdit;
    callAPIParameter: TEdit;
    callAPIProc: TEdit;
    callAPIResult_lbl: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    systemProperties: TListView;
    Timer1: TTimer;
    procedure callAPIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Docker: TLazControlDocker;
    //System/Sonstiges
    procedure displaySysProperties();
  end;

var
  systemOptionsFrm: TsystemOptionsFrm;

implementation
uses bbutils,windowcontrolfuncs,applicationConfig,ptranslateutils;

{$I systemoptions.atr}

{ TsystemOptionsFrm }

procedure TsystemOptionsFrm.FormShow(Sender: TObject);
begin
  threadedCall(@calculateSysProperties,nil);   //#TODO -1: find a way to update everything?
  Timer1Timer(nil);                                      //todo: kategorien
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
begin
  systemProperties.BeginUpdate;
  systemProperties.items.Clear;
  for i:=0 to high(systemPropertiesArray) do
    with systemProperties.Items.add,
         systemPropertiesArray[i] do begin
      Caption:=name;
      subitems.Add(value);
    end;
  systemProperties.EndUpdate;
end;

procedure TsystemOptionsFrm.callAPIClick(Sender: TObject);
begin
  callAPIResult_lbl.Caption:=Cardinal2Str(genericCall(callAPIDLL.Text,callAPIProc.Text,createMemoryBlocks(callAPIParameter.Text)));
end;

procedure TsystemOptionsFrm.FormCreate(Sender: TObject);
begin
  Docker:=TLazControlDocker.Create(Self);
  initUnitTranslation('systemoptions.pas',tr);
  tr.translate(self);
end;

initialization
  {$I systemoptions.lrs}

end.

