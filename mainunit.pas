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
  menus,sysutils, StdCtrls,LDockCtrl, LDockTree, ExtCtrls,windowcontrolfuncs;

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
    MenuItem18: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    procedure destroyDockedForm(Sender: TObject);
    procedure dockitemclick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure insertToNewPageClick(Sender: TObject);
    procedure insertIntoPageClick(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure closeCurrentTabClose(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure pagesCloseTabClicked(Sender: TObject);
    procedure subFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure subFormResize(Sender: TObject);
    procedure undockDockedForm(Sender: TObject);
  private
    { Private-Deklarationen}
    pages: TLazDockPages;

    function addSubForm(id:longint; insertTo:Tform; createpage:boolean):tform;
    procedure addSubForm(newform:Tform; insertTo:Tform; createpage:boolean); //(insertTo <>nil) and createpage => not defined
    procedure addExistingSubForm(newform:Tform; insertTo:Tform; createpage:boolean); //(insertTo <>nil) and createpage => not defined
    //procedure showNewSibling(sender:tform; newform: tform);
    procedure showHandle(sender:tobject; newFormID: longint; var callback: TCallbackComponent);

  public
    { Public-Deklarationen}
    //ControlDocker1: TLazControlDocker;
    DockingManager: TLazDockingManager;

  end;

var
  mainForm: TmainForm;

implementation

uses applicationConfig, searchTool,windowList,processList,systemOptions,options,windowPropertySheet,welcome,ptranslateutils;

{$I mainunit.atr}

{
TODO: procedure TmainForm.openWindowsConst;
var p:tpoint;
    current: twincontrol;
begin
  current:=TWinControl(GetProp(GetFocus,'WinControl'));//FindControl(GetFocus);
  if current=nil then current:=FindOwnerControl(GetFocus);
  if current=nil then exit;
  if not ((current is tedit) or (current is TComboBox)) then exit;
  p.x:=0;
  p.y:=0;//current.Height;
  p:=current.ClientToScreen(p);
  windowConstForm.Left:=p.x;
  windowConstForm.top:=p.y;
    if current is tedit then windowConstForm.currentConst:=TEdit(current).Text
    else if current is TComboBox then windowConstForm.currentConst:=TComboBox(current).Text;
  windowConstForm.currentConst:=trim(windowConstForm.currentConst);
  windowConstForm.ShowModal;
  if windowConstForm.currentConst<>'' then
    if current is tedit then begin
      TEdit(current).Text:=windowConstForm.currentConst;
      TEdit(current).SelStart:=length(TEdit(current).Text);
    end else if current is TComboBox then begin
      TComboBox(current).Text:=windowConstForm.currentConst;
      TComboBox(current).SelStart:=length(TComboBox(current).Text);
    end;
end;

  if (shift = [ssCtrl]) and (key=VK_SPACE) then begin
    openWindowsConst;
    key:=0;
  end;
           }

{ TmainForm }

procedure TmainForm.FormCreate(Sender: TObject);
var tempPanel: tpanel;
    infoForm: TWelcomeFrm;
    i:longint;
begin
  initUnitTranslation('mainunit',tr);
  tr.translate(self);
  DockingManager:=TLazDockingManager.Create(Self);
  DockingManager.Manager.TitleHeight:=0; //disable title, because we have our own buttons
  DockingManager.Manager.TitleWidth:=0;

  tempPanel:=TPanel.create(self);
  tempPanel.parent:=self;
  infoForm:=twelcomefrm.Create(self);
  infoForm.Visible:=true;
  infoForm.onNewWindow:=@insertToNewPageClick;

  //Make page control with two pages
  DockingManager.Manager.InsertControl(infoForm,alClient,tempPanel);
  DockingManager.Manager.RemoveControl(tempPanel); //make on page

  for i:=0 to ControlCount-1 do
    if controls[i] is TLazDockPages then  begin
      pages:=TLazDockPages(controls[i]);
      break;
    end;

  if pages=nil then raise Exception.Create(tr['Docking-System konnte nicht initalisiert werden']);
  pages.Align:=alClient;
  //pages.Options:=[nboShowCloseButtons];
  //pages.OnCloseTabClicked:=@pagesCloseTabClicked;

  SetBounds(globalConfig.GetValue('mainForm/left',left),
            globalConfig.GetValue('mainForm/top',top),
            globalConfig.GetValue('mainForm/width',width),
            globalConfig.GetValue('mainForm/height',height));
end;

procedure TmainForm.destroyDockedForm(Sender: TObject);
var handleToClose:hwnd;
begin
  if not (sender is tbutton) then exit;
  if not (tbutton(sender).parent is tform) then exit;
  handleToClose:=tbutton(sender).parent.Handle;
  if (tbutton(sender).parent.parent<>nil)
     and not (tbutton(sender).parent.parent is TLazDockForm) then //#todo -2: check if this is needed in lazarus > 0.9.28
    DockingManager.Manager.RemoveControl(tcontrol(sender).parent); //docked
  PostMessage(tbutton(sender).parent.Handle,wm_close,0,0); //tbutton(sender).parent.free; //undocked

 // Application.ProcessMessages;
  Refresh;
end;

procedure TmainForm.dockitemclick(Sender: TObject);
begin
  if not (sender is tmenuitem) then exit;
  addExistingSubForm(tmenuitem(sender).Owner.Owner as tform,nil,tbutton(sender).tag=2);
end;

procedure TmainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  globalConfig.SetValue('mainForm/left',left);
  globalConfig.SetValue('mainForm/top',top);
  globalConfig.SetValue('mainForm/width',width);
  globalConfig.SetValue('mainForm/height',height);
end;

procedure TmainForm.FormDestroy(Sender: TObject);
begin
  DockingManager.Free();
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

procedure TmainForm.closeCurrentTabClose(Sender: TObject);
begin

end;

procedure TmainForm.MenuItem7Click(Sender: TObject);
begin

end;

procedure TmainForm.pagesCloseTabClicked(Sender: TObject);
begin

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

procedure TmainForm.undockDockedForm(Sender: TObject);
var i:longint;
    pos: tpoint;
    size: tpoint;
    subForm:Tform;
    pmenu: TPopupMenu;
begin
  if not (sender is tbutton) then exit;
  if not (tbutton(sender).parent is tform) then exit;
  subform:=Tform(tbutton(sender).parent);
  if subForm.parent=nil then begin //not docked
    pmenu:=subForm.FindComponent('dockpopupmenu') as TPopupMenu;
    pos:=tbutton(sender).ClientToScreen(point(0,tbutton(sender).height+2));
    pmenu.PopUp(pos.x,pos.y);
    //TODO -1: insert direct from shared form to mainform (all subforms there?), move to drag/drop?

  end else begin
    pos:=subForm.parent.ClientToScreen(subform.BoundsRect.TopLeft);
    size:=point(subForm.Width,subForm.Height);
    DockingManager.Manager.UndockControl(tbutton(sender).parent,true);
  //  tbutton(sender).Enabled:=false;
    subForm.BorderStyle:=bsSizeToolWin;
    subForm.Left:=Pos.x;
    subForm.top:=Pos.y;
  end;
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
    else raise exception.create('invalid form id');
  end;
  addSubForm(result,insertTo,createpage);
  if result.FindComponent('callbackcomponent')=nil then
    TCallbackComponent.Create(result);
  TCallbackComponent(result.FindComponent('callbackcomponent')).onShowForm:=@showHandle;
  TCallbackComponent(result.FindComponent('callbackcomponent')).id:=id;
end;

procedure TmainForm.addSubForm(newform: Tform; insertTo:Tform; createpage: boolean);
var temp:tcontrol;
    aSubForm: tform;
    i:longint;
    tempPanel:tpanel;
    dockButton: tbutton;
    pmenu: TPopupMenu;
    item: TMenuItem;
begin
  addExistingSubForm(newform,insertTo,createpage);

  newForm.AddHandlerClose(@subFormClose);
  newForm.AutoScroll:=false;
  newForm.VertScrollBar.Visible:=true;
  newForm.visible:=true;

  Application.ProcessMessages;

  dockButton:=TButton.Create(newform);
  dockButton.Caption:='2';
  dockButton.font.Name:='Marlett';
  dockButton.parent:=newForm;
  dockButton.SetBounds(newform.clientwidth-50,5,20,20);
  dockbutton.Anchors:=[aktop,akRight];
  dockbutton.AnchorSide[akright].Side:=asrBottom;
  dockbutton.OnClick:=@undockDockedForm;

  dockButton:=TButton.Create(newform);
  dockButton.Caption:='r';
  dockButton.font.Name:='Marlett';
  dockButton.parent:=newForm;
  dockButton.SetBounds(newform.clientwidth-25,5,20,20);
  dockbutton.Anchors:=[aktop,akRight];
  dockbutton.AnchorSide[akright].Side:=asrBottom;
  dockbutton.onclick:=@destroyDockedForm;

  pmenu:=TPopupMenu.Create(newform);
  pmenu.Parent:=newform;
  pmenu.name:='dockpopupmenu';
  item:=TMenuItem.Create(pmenu);
  item.Caption:=tr['ins Hauptfenster einfügen'];
  item.OnClick:=@dockitemclick;
  item.tag:=1;
  pmenu.Items.Add(item);
  item:=TMenuItem.Create(pmenu);
  item.Caption:=tr['ins Hauptfenster in neuer Seite einfügen'];
  item.OnClick:=@dockitemclick;
  item.tag:=2;
  pmenu.Items.Add(item);


  newForm.OnResize:=@subFormResize;
  subFormResize(newform);//update vert scrollbar
  newform.horzScrollBar.Visible:=false;

end;

procedure TmainForm.addExistingSubForm(newform: Tform; insertTo: Tform;
  createpage: boolean);
begin
  if insertTo <>nil then
      DockingManager.Manager.InsertControl(newform,alBottom,insertTo)
  else begin
    createpage:=createpage or (pages.PageIndex=0);
    if not createpage then
      createpage:=2*maxSubFormPerPage-1<=pages.ActivePageComponent.ControlCount;//splitter+form
    if createpage then begin
      DockingManager.Manager.InsertControl(newform,alClient,pages.ActivePageComponent.controls[0]);
      pages.PageIndex:=pages.PageIndex+1;
    end else
      DockingManager.Manager.InsertControl(newform,alBottom,pages.ActivePageComponent.controls[pages.ActivePageComponent.ControlCount-1]); //last control because the new one is shown after this (due to albottom)
  end;
end;

                        {
procedure TmainForm.showNewSibling(sender: tform; newform: tform);
begin
  addSubForm(newform,sender,false);
end;
                         }
procedure TmainForm.showHandle(sender: tobject; newFormID: longint;
  var callback: TCallbackComponent);
begin
  callback:=addSubForm(newFormID,sender as tform,false).FindComponent('callbackcomponent') as TCallbackComponent;
end;


initialization

  {$I mainunit.lrs}

end.







