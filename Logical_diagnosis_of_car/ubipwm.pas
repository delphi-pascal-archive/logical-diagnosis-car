unit ubipwm;

interface

uses
  Classes, SysUtils,  Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFBiPWM }

  TFBiPWM = class(TForm)
    B_Fermer: TButton;
    B_Moins: TButton;
    B_MoinsFreq: TButton;
    B_Plus: TButton;
    B_PlusFreq: TButton;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    L_Pin: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure B_FermerClick(Sender: TObject);
    procedure B_MoinsClick(Sender: TObject);
    procedure B_MoinsFreqClick(Sender: TObject);
    procedure B_PlusClick(Sender: TObject);
    procedure B_PlusFreqClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Actif : boolean;
    N_Sortie : byte;
    lg_data_1,lg_data_2 : integer;
    Posit_1,Posit_2 : real;
    sens_octet1,sens_octet2 : boolean;
    diviseur_1,Diviseur_2 : real;
    Pas_1,Pas_2 : real;
    Cde_BiPWM : string;
    Cde_Exit : string;
    Maxi_Posi_1,Mini_Posi_1,Maxi_Posi_2,Mini_Posi_2 : real;
    Label_Unit1,Label_Unit2 : string;
    Buffer : string;
    Procedure maj;
    Procedure Calcul_Min_Max;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FBiPWM: TFBiPWM;

implementation

{$R *.dfm}

{ TFBiPWM }

uses umain,common,math;

procedure TFBiPWM.B_MoinsFreqClick(Sender: TObject);
begin
  if (FBiPwm.Posit_1>=FBiPWM.Mini_Posi_1+FBiPwm.Pas_1) then
     begin
       FBiPwm.Posit_1:=FBiPwm.Posit_1-FBiPwm.Pas_1;
       FBiPwm.maj;
     end;
end;

procedure TFBiPWM.B_PlusClick(Sender: TObject);
begin
  if (FBiPwm.Posit_2+FBiPWM.Pas_2<=FBiPWM.Maxi_Posi_2) then
     begin
       FBiPwm.Posit_2:=FBiPwm.Posit_2+FBiPWM.Pas_2;
       FBiPwm.maj;
     end;
end;

procedure TFBiPWM.B_MoinsClick(Sender: TObject);
begin
  if (FBiPwm.Posit_2>=FBiPWM.Mini_Posi_2+FBiPwm.Pas_2) then
     begin
       FBiPwm.Posit_2:=FBiPwm.Posit_2-FBiPwm.Pas_2;
       FBiPwm.maj;
     end;
end;

procedure TFBiPWM.B_FermerClick(Sender: TObject);
begin
  if length(FBiPWM.Cde_Exit)>0 then
    begin
      //FMain.Cde2Send(FBiPWM.Cde_Exit);
      //
      //FMain.NoReceive:=True;
      //FMain.Execution:=False;
      //FMain.KWP20001.SendResponse;
      FMain.Attente_Start;
      if FMain.T_StatusIO.Enabled=False then
        begin
          FMain.T_StatusIO.Enabled:=True;
          FMain.T_StatusIO.Interval:=100;
        end;
      Buffer:=Cde_Exit;
    end;
  FBiPwm.Close;
end;

procedure TFBiPWM.B_PlusFreqClick(Sender: TObject);
begin
  if (FBiPwm.Posit_1+FBiPWM.Pas_1<=FBiPWM.Maxi_Posi_1) then
     begin
       FBiPwm.Posit_1:=FBiPwm.Posit_1+FBiPWM.Pas_1;
       FBiPwm.maj;
     end;
end;

procedure TFBiPWM.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Actif :=false;
end;

procedure TFBiPWM.FormCreate(Sender: TObject);
begin
  Actif :=false;
end;

procedure TFBiPWM.maj;
var r : real;
    i : integer;
    texte,texte1,texte2 : string;
begin
  FBiPwm.Label2.Caption:=reeltostr(FBiPWM.Posit_1)+FBiPwm.Label_unit1;
  FBiPwm.Label1.Caption:=reeltostr(FBiPWM.Posit_2)+FBiPwm.Label_unit2;
  if FBiPWM.diviseur_1>0
    then r:=FBiPWM.Posit_1/FBiPWM.diviseur_1
    else r:=FBiPWM.Posit_1;
  i:=trunc(r);
  texte:=dectohex(i);
  i:=FBiPwm.lg_data_1 div 4;
  texte:=copy(texte,1,i);
  if (sens_octet1) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
  texte1:='';
  while length(texte)>0 do
    begin
      texte1:=copy(texte,1,2)+' ';
      delete(texte,1,2);
    end;
  i:=pos('VAL1',FBiPWM.Cde_BiPWM);
  texte:=FBiPWM.Cde_BiPWM;
  if i>0 then
    begin
      texte2:=copy(texte,1,i-1);
      delete(texte,1,i+5);
      texte:=texte2+texte1+texte;
    end;
  if FBiPWM.diviseur_2>0
    then r:=FBiPWM.Posit_2/FBiPWM.diviseur_2
    else r:=FBiPWM.Posit_2;
  i:=trunc(r);
  texte:=dectohex(i);
  i:=FBiPwm.lg_data_2 div 4;
  texte:=copy(texte,1,i);
  if (sens_octet2) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
  texte1:='';
  while length(texte)>0 do
    begin
      texte1:=copy(texte,1,2)+' ';
      delete(texte,1,2);
    end;
  i:=pos('VAL2',FBiPWM.Cde_BiPWM);
  texte:=FBiPWM.Cde_BiPWM;
  if i>0 then
    begin
      texte2:=copy(texte,1,i-1);
      delete(texte,1,i+5);
      texte:=texte2+texte1+texte;
    end;
  //FMain.Cde2Send(texte);
  //FMain.NoReceive:=True;
  //FMain.Execution:=False;
  //FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=texte;
end;

procedure TFBiPWM.Calcul_Min_Max;
var r : real;
begin
  FBiPWM.Mini_Posi_1:=0;
  r:=Power(2,lg_Data_1);
  FBiPWM.Maxi_Posi_1:=r*FBiPWM.diviseur_1;
  FBiPWM.Mini_Posi_2:=0;
  r:=Power(2,lg_Data_2);
  FBiPWM.Maxi_Posi_2:=r*FBiPWM.diviseur_2;
end;

procedure TFBiPWM.Disable_Screen;
begin
  FBiPWM.B_Moins.Enabled:=False;
  FBiPWM.B_Plus.Enabled:=False;
  FBiPWM.B_MoinsFreq.Enabled:=False;
  FBiPWM.B_PlusFreq.Enabled:=False;
end;

procedure TFBiPWM.Enable_Screen;
begin
  FBiPWM.B_Moins.Enabled:=True;
  FBiPWM.B_Plus.Enabled:=True;
  FBiPWM.B_MoinsFreq.Enabled:=True;
  FBiPWM.B_PlusFreq.Enabled:=True;
end;

initialization
  

end.

