unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, iComponent, iVCLComponent, iCustomComponent, iPositionComponent,
  iScaleComponent, iThermometer, StdCtrls, iGaugeComponent, iAngularGauge;

type
  TForm2 = class(TForm)
    SicaklikU2: TiAngularGauge;
    RPMU2: TiAngularGauge;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
