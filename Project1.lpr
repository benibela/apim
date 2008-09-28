program Project1;

uses
  Forms,Interfaces,
  Unit1 in 'Unit1.pas' {Form1},
  wstyles in 'wstyles.pas' {windowstyleform},
  windowfuncs in 'windowfuncs.pas',
  passwort in 'passwort.pas', applicationConfig, winconstwindow,
windowcontrolfuncs, windowPropertySheet, windowList, searchTool, processList,
systemOptions, options;
  
{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

begin
  Application.Title:='API Manager';
  Application.Initialize;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(Twindowstyleform, windowstyleform);
  Application.CreateForm(TwindowConstForm, windowConstForm);
  Application.CreateForm(TWindowListFrm, WindowListFrm);
  Application.CreateForm(TsearchToolFrm, searchToolFrm);
  Application.CreateForm(TprocessListFrm, processListFrm);
  Application.CreateForm(TsystemOptionsFrm, systemOptionsFrm);
  Application.CreateForm(ToptionFrm, optionFrm);
  Application.Run;
end.
