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
unit welcome;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TWelcomeFrm }

  TWelcomeFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    onNewWindow: TNotifyEvent;
  end; 

var
  WelcomeFrm: TWelcomeFrm;

implementation

uses ptranslateutils;
{$I welcome.atr}
{ TWelcomeFrm }

procedure TWelcomeFrm.Button1Click(Sender: TObject);
begin
  if not assigned(onNewWindow) then exit;
  onNewWindow(sender);
end;

procedure TWelcomeFrm.FormCreate(Sender: TObject);
begin
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);
end;

initialization
  {$I welcome.lrs}

end.

