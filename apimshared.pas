unit apimshared;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,windows;
const  messageWindowClass ='APIMmessageWINDOWclass';
       propertyMainWindow ='mainWindow';
       propertyHookId ='hookId';
       propertyAction ='action';
       propertyAim ='aim';
       propertyMsg ='msg';
       propertyParam1 ='param1';
       propertyParam2 ='param2';

       action_gettext = 1;
       action_setwindowlong = 2;
       action_setclasslong = 3;
       action_sendmessage = 4;

var actionNeededMessage: dword;

implementation
initialization
  actionNeededMessage:= RegisterWindowMessage('BENIBELAapimACTIONNEEDEDmessage');
end.

