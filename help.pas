unit help;

interface
{$mode delphi}{$h+}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Thelpform = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  helpform: Thelpform;

implementation

procedure Thelpform.Button1Click(Sender: TObject);
begin
Close;
end;

end.
