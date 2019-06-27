// ---------------------------AFYON KOCATEPE UNÝVERSÝTESÝ---------------------------
// Adý ve Soyadý   :    Yusuf Semih  AKILLI
// Fakülte         :    Teknoloji Fakültesi
// Sýnýf           :    Elektrik-Elektronik Mühendisliði(N.Ö)/3
// Proje           :    Bilgisayar Programlama Uygulamalarý Dersi Final Projesi
//----------------------------------------------------------------------------------
// Amaç            :   Isýya göre Fan hýzý ayarlanýyor ve RGB ledler ýsý doðrultusunda
//                     renk deðiþtiriyor.
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, iComponent, iVCLComponent,
  iCustomComponent, iLed, iLedRound, nrclasses, nrcomm, nrdataproc, nrcommbox,
  iPositionComponent, iScaleComponent, iThermometer, iAnalogDisplay;

type
  TForm1 = class(TForm)
    CPort1: TnrComm;
    nrDataProcessor1: TnrDataProcessor;
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    SicaklikDisplay: TLabel;
    FanRPM: TLabel;
    Sicaklik: TLabel;
    SicaklikDurumuLabel: TLabel;
    PortList1: TnrDeviceBox;
    ClosePortButton: TBitBtn;
    PortLed: TiLedRound;
    OpenPortButton: TBitBtn;
    Termometre: TiThermometer;
    SicaklikDegerEkrani: TiAnalogDisplay;
    FanHiziDegerEkrani: TiAnalogDisplay;
    BitBtn1: TBitBtn;
    procedure OpenPortButtonClick(Sender: TObject);
    procedure ClosePortButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure nrDataProcessor1DataPacket(Sender: TObject;
      Packet: TnrDataPacket);
    procedure TermometrePositionChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  giden             : string = '!0000000000*';
  PortD             : Byte = 0;
  PortB,M1isi       : Byte;
  M1Hiz             : word;
  Mesafe            : integer;
  RB                : Boolean;


implementation
     uses Unit2;
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
        Form2.Show;
end;

procedure TForm1.ClosePortButtonClick(Sender: TObject);
begin
          if CPort1.Active then
          begin
           CPort1.Active := False;


          end;
           PortLed.Active := CPort1.Active;
           Timer1.Enabled := False;



end;

procedure TForm1.nrDataProcessor1DataPacket(Sender: TObject;
  Packet: TnrDataPacket);
  var
  s : string;
  I: Integer;
begin


                s := Packet.Data;
                for I := 2 to 11 do
                if not (s[i] in ['0'..'9','A'..'F']) then exit;

                PortB := StrToInt('$'+S[2]+s[3]);
                M1isi  := StrToInt('$'+s[6]+s[7]);
                SicaklikDegerEkrani.Value := M1isi*2;
                Termometre.Position := M1isi*2;
                Form2.SicaklikU2.Position := M1isi*2;



end;

procedure TForm1.OpenPortButtonClick(Sender: TObject);
begin

        if not CPort1.Active then
         begin
          CPort1.Active := True;


         end;
           PortLed.Active := CPort1.Active;
           Timer1.Enabled := True;




end;

procedure TForm1.TermometrePositionChange(Sender: TObject);
begin

          M1Hiz := Trunc(Termometre.Position*25);
          FanHiziDegerEkrani.Value := (M1isi*5)-1;
          Form2.RPMU2.Position := M1isi*10;
          PortD := PortD or $01;

          if (SicaklikDegerEkrani.Value < 25) then
              begin
                 PortD := PortD and $0F;
                 PortD := PortD or $0E;
                 PortLed.ActiveColor := clWhite;
                 SicaklikDurumuLabel.Caption := 'Çok Düþük';
              end
         else if(SicaklikDegerEkrani.Value > 25) and (SicaklikDegerEkrani.Value < 35) then
              begin
                  PortD := PortD and $09;
                  PortD := PortD or $08;
                  PortLed.ActiveColor := clBlue;
                  SicaklikDurumuLabel.Caption := 'Düþük';
         end
          else if(SicaklikDegerEkrani.Value > 35) and (SicaklikDegerEkrani.Value < 50) then
              begin
                  PortD := PortD and $05;
                  PortD := PortD or $04;
                  PortLed.ActiveColor := clGreen;
                  SicaklikDurumuLabel.Caption := 'Sýnýr';
              end
          else if(SicaklikDegerEkrani.Value > 50) and (SicaklikDegerEkrani.Value < 60) then
              begin
                  PortD := PortD and $07;
                  PortD := PortD or $06;
                  PortLed.ActiveColor := clYellow;
                  SicaklikDurumuLabel.Caption := 'Yüksek';
              end
          else if SicaklikDegerEkrani.Value > 60 then
               begin
                 PortD := PortD and $01;
                 PortD := PortD or $02;
                 PortLed.ActiveColor := clRed;
                 SicaklikDurumuLabel.Caption :='Çok Yüksek';
               end;


end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

     giden := '!' + IntToHex(PortD,2) + IntToHex(M1Hiz,4) +'0000'+'*';
               if CPort1.Active then
                  CPort1.SendString(giden);




end;

end.
