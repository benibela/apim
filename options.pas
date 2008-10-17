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
unit options;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls,LDockCtrl;

type

  { ToptionFrm }

  ToptionFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    autorefreshcheck: TCheckBox;
    checkhex: TCheckBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    maxsubforms_edt: TEdit;
    defaultRefreshedt: TEdit;
    Label1: TLabel;
    Label21: TLabel;
    Label29: TLabel;
    optwinconst_Edt: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    Docker: TLazControlDocker;
    { public declarations }
  end; 

var
  optionFrm: ToptionFrm;

implementation
uses ptranslateutils,applicationConfig;
{$I options.atr}
{ ToptionFrm }



procedure ToptionFrm.FormCreate(Sender: TObject);
begin
  Docker:=TLazControlDocker.Create(Self);
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);

  Button2.Click;
  ComboBox1.text:=curlang;
end;

procedure ToptionFrm.Button2Click(Sender: TObject);
begin
  checkhex.Checked:=hexa;
  optwinconst_Edt.Text:=winConstPath;
  maxsubforms_edt.Text:=IntToStr(maxSubFormPerPage);
  autorefreshcheck.Checked:=defaultRefreshTimeInterval <>0;
  if defaultRefreshTimeInterval<>0 then defaultRefreshedt.text:=IntToStr(defaultRefreshTimeInterval);
  //readConfig;
end;

procedure ToptionFrm.Button1Click(Sender: TObject);
begin
  if checkhex.Checked then globalConfig.SetValue('look/numberKind','0')
  else globalConfig.SetValue('look/numberKind','1');
  globalConfig.SetValue('paths/winconst',optwinconst_Edt.Text);
  globalConfig.SetValue('look/maxSubFormPerPage',maxsubforms_edt.text);
  if autorefreshcheck.Checked then
    globalConfig.SetValue('look/defaultRefreshTime',defaultRefreshedt.text)
  else
    globalConfig.SetValue('look/defaultRefreshTime',0);
  globalConfig.SetValue('look/language',ComboBox1.Text);


  globalConfig.Flush;
  readConfig;
end;

initialization
  {$I options.lrs}

end.

