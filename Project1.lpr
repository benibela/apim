program Project1;

uses
  Forms,Interfaces,
  Unit1 in 'Unit1.pas' {Form1},
//  turbo in '..\delphikomp\turbo.pas',
  wstyles in 'wstyles.pas' {windowstyleform},
  help in 'help.pas' {helpform},
  windowfuncs in 'windowfuncs.pas',
 // temp in 'temp.pas' {BenMessages},
  passwort in 'passwort.pas', applicationConfig, winconstwindow,
windowcontrolfuncs;
  
begin
  Application.Initialize;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(Twindowstyleform, windowstyleform);
  Application.CreateForm(Thelpform, helpform);
  Application.CreateForm(TwindowConstForm, windowConstForm);
  Application.Run;
end.
