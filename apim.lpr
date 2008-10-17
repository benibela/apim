program apim;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this },applicationConfig , mainunit, windowPropertySheet,
  winconstwindow, searchTool, systemOptions, processList, options, wstyles,
  windowList, proc9, welcome, windowcontrolfuncs, petools, apimshared;

{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

begin                                           //#todo 9: check encoding
  if Applicationconfig.initAll then begin
    Application.Initialize;
    Application.CreateForm(TmainForm, mainForm);
    Application.CreateForm(TwindowConstForm, windowConstForm);
    Application.Run;
    Applicationconfig.finitAll;
  end;
end.

