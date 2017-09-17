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

{History:
  - 2008:
    Weiterentwicklung, Wechsel von Delphi -> Lazarus
    Umbenennung von APIV (API Verwalter??) in API Manager
    (wegen Namenskonflikt einem anderen APIV von 2000)
  - Ende 2002:
    Fertigstellung der Version 2
  - 2001:
    Erste Veröffentlichung von APIV (entweder Version 1 oder 2)
}

unit mainunit;

interface
{$mode objfpc}{$h+}
uses
  LResources, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  menus,sysutils, StdCtrls, LDockTree, ExtCtrls,windowcontrolfuncs,
  ButtonPanel;

type

  { TmainForm }

  TmainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure insertToNewPageClick(Sender: TObject);
    procedure insertIntoPageClick(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure subFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure subFormResize(Sender: TObject);
  private
    { Private-Deklarationen}
    function addSubForm(id:longint; insertTo:Tform; createpage:boolean):tform;
    procedure addSubForm(newform:Tform; insertTo:Tform; createpage:boolean); //(insertTo <>nil) and createpage => not defined
    procedure addExistingSubForm(newform:Tform; insertTo:Tform; createpage:boolean); //(insertTo <>nil) and createpage => not defined
    //procedure showNewSibling(sender:tform; newform: tform);
    procedure showHandle(sender:tobject; newFormID: longint; var callback: TCallbackComponent);

  public
    { Public-Deklarationen}

  end;

var
  mainForm: TmainForm;

implementation

uses applicationConfig, searchTool,windowList,processList,systemOptions,bbutils, options,windowPropertySheet,welcome,ptranslateutils,apimshared,wstyles,AnchorDocking,AnchorDockStorage;

{$I mainunit.atr}

{ TmainForm }

procedure TmainForm.FormCreate(Sender: TObject);
var
    i:longint;
    boundLeft, boundTop, boundWidth, boundHeight: Integer;
begin
  initUnitTranslation(CurrentUnitName,tr);
  tr.translate(self);
  Caption := 'API Manager ' + currentVersionStr;
  DockMaster.MakeDockSite(Self,[akBottom],admrpNone,false);;

  boundLeft := globalConfig.GetValue('mainForm/left',left);
  boundTop := globalConfig.GetValue('mainForm/top',top);
  boundWidth := globalConfig.GetValue('mainForm/width',width);
  boundHeight := globalConfig.GetValue('mainForm/height',height);
  if boundWidth > screen.Width then boundWidth := screen.Width;
  if boundHeight > screen.Height then boundHeight := screen.Height;
  if boundLeft + boundWidth > screen.Width then boundLeft := (screen.Width - boundWidth) div 2;
  if boundTop + boundHeight > screen.Height then boundTop := (screen.Height - boundHeight) div 2;

  SetBounds(boundLeft, boundTop, boundWidth, boundHeight);

  SetPropA(messageWindow,propertyMainWindow,handle);
end;

procedure TmainForm.FormShow(Sender: TObject);
var
  infoForm: TWelcomeFrm;
begin
  infoForm:=twelcomefrm.Create(self);
  infoForm.onNewWindow:=@insertToNewPageClick;

  DockMaster.MakeDockable(infoForm,true,false,false);
  DockMaster.GetAnchorSite(infoForm).Header.HeaderPosition := adlhpTop;
  DockMaster.ManualDock(DockMaster.GetAnchorSite(infoForm), self, alClient, nil);

  OnShow := nil;
end;

procedure TmainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  globalConfig.SetValue('mainForm/left',left);
  globalConfig.SetValue('mainForm/top',top);
  globalConfig.SetValue('mainForm/width',width);
  globalConfig.SetValue('mainForm/height',height);
end;

procedure TmainForm.insertToNewPageClick(Sender: TObject);
begin
  addSubForm(tcomponent(sender).Tag,nil,true);
end;

procedure TmainForm.insertIntoPageClick(Sender: TObject);
begin
  addSubForm(tcomponent(sender).Tag,nil,false);
end;

procedure TmainForm.MenuItem17Click(Sender: TObject);
begin
  close;
end;


procedure TmainForm.subFormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caFree;
end;

procedure TmainForm.subFormResize(Sender: TObject);
begin
  if not (sender is tform) then exit;
  tform(sender).VertScrollBar.visible:=tform(sender).ClientHeight<tform(sender).VertScrollBar.range;
end;


//needed for user input
function TmainForm.addSubForm(id: longint; insertTo:Tform; createpage: boolean):tform;
begin
  case id of
    SEARCHTOOLFRM_ID: result:=TsearchToolFrm.Create(self);
    WINDOWLISTFRM_ID: result:=TWindowListFrm.Create(self);
    PROCESSLISTFRM_ID: result:=TprocessListFrm.Create(self);
    SYSTEMOPTIONSFRM_ID: result:=TsystemOptionsFrm.Create(self);
    OPTIONSFRM_ID: result:=ToptionFrm.Create(self);
    PROPERTYSHEETFRM_ID: result:=TWindowPropertySheetFrm.Create(self);
    WINDOWSTYLELISTFRM_ID: result:=Twindowstyleform.Create(self)
    else raise exception.create('invalid form id');
  end;
  if result.FindComponent('callbackcomponent')=nil then
    TCallbackComponent.Create(result);
  TCallbackComponent(result.FindComponent('callbackcomponent')).onShowForm:=@showHandle;
  TCallbackComponent(result.FindComponent('callbackcomponent')).id:=id;
  addSubForm(result,insertTo,createpage);
end;

procedure TmainForm.addSubForm(newform: Tform; insertTo:Tform; createpage: boolean);
begin

  addExistingSubForm(newform,insertTo,createpage);

  newform.OnClose := @subFormClose;
  newForm.VertScrollBar.Visible:=true;
end;

procedure TmainForm.addExistingSubForm(newform: Tform; insertTo: Tform; createpage: boolean);
var
  site: TAnchorDockHostSite;
begin
  DockMaster.MakeDockable(newform,false);
  DockMaster.GetAnchorSite(newform).Header.HeaderPosition := adlhpTop;
  if insertTo <> nil then
    DockMaster.ManualDock(DockMaster.GetAnchorSite(newform), DockMaster.GetAnchorSite(insertTo), alBottom, insertTo)
  else begin
    if not createpage then begin
      createpage := true;
      site := (DockManager as TAnchorDockManager).GetChildSite;
      if site.Pages <> nil then begin
        DockMaster.ManualDock(DockMaster.GetAnchorSite(newform), site.Pages.GetActiveSite, alBottom, nil);
        createpage := false;
      end;
    end;
    if createpage then
      DockMaster.ManualDock(DockMaster.GetAnchorSite(newform), self, alClient, nil)
  end;
  DockMaster.MakeDockable(newform,true,true);
  Invalidate;
end;


procedure TmainForm.showHandle(sender: tobject; newFormID: longint;
  var callback: TCallbackComponent);
begin
  callback:=addSubForm(newFormID,sender as tform,false).FindComponent('callbackcomponent') as TCallbackComponent;
end;


initialization

  {$I mainunit.lrs}

end.







