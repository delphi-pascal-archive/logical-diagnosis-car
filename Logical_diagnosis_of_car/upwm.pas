unit upwm;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls,Buttons;

type

  { TFPwm }

  TFPwm = class(TForm)
    B_Moins: TButton;
    B_Plus: TButton;
    B_Fermer: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    L_Pin: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure B_FermerClick(Sender: TObject);
    procedure B_MoinsClick(Sender: TObject);
    procedure B_PlusClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Actif : boolean;
    N_Sortie : byte;
    //Freq_PWM : boolean;
    lg_data : integer;
    boitier : byte;
    Posit : real;
    sens_octet : boolean;
    diviseur : real;
    Pas : real;
    Cde_PWM : string;
    Cde_PWM_Exit : string;
    unite : string;
    Maxi_Posi,Mini_Posi : real;
    Buffer : string;
    Procedure maj;
    Procedure Calcul_Min_Max;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FPwm: TFPwm;

implementation

{$R *.dfm}

uses umain,common,math;

{ TFPwm }

//******************************************************************************
procedure TFPwm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Actif :=false;
end;

//******************************************************************************
procedure TFPwm.B_FermerClick(Sender: TObject);
begin
  if length(FPWM.Cde_PWM_Exit)>0 then
    begin
      //FMain.Cde2Send(FPWM.Cde_PWM_Exit);
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
      Buffer:=Cde_PWM_Exit;
    end;
  FPwm.Close;
end;

//******************************************************************************
procedure TFPwm.B_MoinsClick(Sender: TObject);
begin
  if (FPwm.Posit>=FPWM.Mini_Posi+FPwm.Pas) then
     begin
       FPwm.Posit:=FPwm.Posit-FPwm.Pas;
       FPwm.maj;
     end;
end;

//******************************************************************************
procedure TFPwm.B_PlusClick(Sender: TObject);
begin
  if (FPwm.Posit+FPWM.Pas<=FPWM.Maxi_Posi) then
     begin
       FPwm.Posit:=FPwm.Posit+FPWM.Pas;
       FPwm.maj;
     end;
end;

//******************************************************************************
procedure TFPwm.FormCreate(Sender: TObject);
begin
  Actif :=false;
end;

//******************************************************************************
procedure TFPwm.maj;
var r : real;
    i : integer;
    texte,texte1,texte2 : string;
begin
  FPwm.Label1.Caption:=reeltostr(FPWM.Posit)+FPwm.unite;
  if FPWM.diviseur>0
    then r:=FPWM.Posit/FPWM.diviseur
    else r:=FPWM.Posit;
  i:=trunc(r);
  texte:=dectohex(i);
  i:=FPwm.lg_data div 4;
  texte:=copy(texte,1,i);
  if (sens_octet) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
  texte1:='';
  while length(texte)>0 do
    begin
      texte1:=copy(texte,1,2)+' ';
      delete(texte,1,2);
    end;
  i:=pos('VALUE',FPWM.Cde_PWM);
  texte:=FPWM.Cde_PWM;
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

//******************************************************************************
procedure TFPwm.Calcul_Min_Max;
var r : real;
begin
  FPWM.Mini_Posi:=0;
  r:=Power(2,lg_Data);
  FPWM.Maxi_Posi:=r*FPWM.diviseur;
end;

procedure TFPwm.Disable_Screen;
begin
  FPWM.B_Moins.Enabled:=False;
  FPWM.B_Plus.Enabled:=False;
end;

procedure TFPwm.Enable_Screen;
begin
  FPWM.B_Moins.Enabled:=True;
  FPWM.B_Plus.Enabled:=True;
end;

end.

