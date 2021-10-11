unit ubridge;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ComCtrls, ExtCtrls;

type

  { TFBridge }

  TFBridge = class(TForm)
    B_Fermer: TButton;
    B_Left: TButton;
    B_Right: TButton;
    B_Moins: TButton;
    B_Plus: TButton;
    B_Stop: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    L_pin: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure B_FermerClick(Sender: TObject);
    procedure B_RightClick(Sender: TObject);
    procedure B_LeftClick(Sender: TObject);
    procedure B_MoinsClick(Sender: TObject);
    procedure B_PlusClick(Sender: TObject);
    procedure B_StopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    Actif : boolean;
    N_Sortie : byte;
    Label_unite : string;
    boitier : byte;
    Posit : real;
    sens : byte;
    sens_octet : boolean;
    Cde_EXIT : string;
    Cde_Stop,Cde_sens1,Cde_Sens2 : string;
    Cde_PWM : string;
    n_cde : integer;
    Pas : real;
    diviseur : real;
    Mini_Posi,Maxi_Posi : real;
    lg_data : integer;
    Buffer : string;
    procedure maj;
    procedure Calcul_Mini_Maxi;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FBridge: TFBridge;

implementation

{$R *.dfm}

uses umain,common,math;

{ TFBridge }

//******************************************************************************
procedure TFBridge.B_StopClick(Sender: TObject);
begin
  FBridge.sens:=0;
  FBridge.Posit:=0;
  FBridge.B_Stop.Font.Size:=16;
  FBridge.B_Stop.Font.Style:=[fsbold];
  FBridge.B_Right.Font.Size:=10;
  FBridge.B_Right.Font.Style:=[];
  FBridge.B_Left.Font.Size:=10;
  FBridge.B_Left.Font.Style:=[];

  FBridge.maj;
end;

//******************************************************************************
procedure TFBridge.FormCreate(Sender: TObject);
begin
  FBridge.Actif:=false;
end;

//******************************************************************************
procedure TFBridge.B_LeftClick(Sender: TObject);
begin
  FBridge.sens:=1;
  FBridge.Posit:=0;
  FBridge.B_Stop.Font.Size:=10;
  FBridge.B_Stop.Font.Style:=[];
  FBridge.B_Right.Font.Size:=10;
  FBridge.B_Right.Font.Style:=[];
  FBridge.B_Left.Font.Size:=16;
  FBridge.B_Left.Font.Style:=[fsBold];

  FBridge.maj;
end;

//******************************************************************************
procedure TFBridge.B_MoinsClick(Sender: TObject);
begin
  if (FBridge.Posit>=Fbridge.Mini_Posi+FBridge.Pas) then
     begin
       FBridge.Posit:=FBridge.Posit-FBridge.Pas;
       FBridge.maj;
     end;
end;

//******************************************************************************
procedure TFBridge.B_PlusClick(Sender: TObject);
begin
  if (FBridge.Posit+FBridge.Pas<=FBridge.Maxi_Posi) then
     begin
       FBridge.Posit:=FBridge.Posit+FBridge.Pas;
       FBridge.maj;
     end;
end;

//******************************************************************************
procedure TFBridge.B_RightClick(Sender: TObject);
begin
  FBridge.sens:=2;
  FBridge.Posit:=0;
  FBridge.B_Right.Font.Size:=16;
  FBridge.B_Right.Font.Style:=[fsBold];
  FBridge.B_Left.Font.Size:=10;
  FBridge.B_Left.Font.Style:=[];
  FBridge.B_Stop.Font.Size:=10;
  FBridge.B_Stop.Font.Style:=[];

  FBridge.maj;
end;

//******************************************************************************
procedure TFBridge.B_FermerClick(Sender: TObject);
begin
  if length(FBridge.Cde_Exit)>0 then
    begin
      //FMain.Cde2Send(FBridge.Cde_Exit);
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
  FBridge.Actif:=False;
  FBridge.Close;
end;

//******************************************************************************
procedure TFBridge.maj;
var r : real;
    i : integer;
    texte,texte1,texte2 : string;
    txt_sens : string;
begin
  FBridge.Label1.Caption:=reeltostr(FBridge.Posit)+FBridge.Label_unite;
  if FBridge.diviseur>0
    then r:=FBridge.Posit/FBridge.diviseur
    else r:=FBridge.Posit;
  i:=trunc(r);
  texte:=dectohex(i);
  i:=FBridge.lg_data div 4;
  texte:=copy(texte,1,i);
  if (sens_octet) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
  texte1:='';
  while length(texte)>0 do
    begin
      texte1:=copy(texte,1,2)+' ';
      delete(texte,1,2);
    end;
  case sens of
    0 : txt_sens:=FBridge.Cde_Stop;
    1 : txt_sens:=FBridge.Cde_Sens1;
    2 : txt_sens:=FBridge.Cde_Sens2;
  end;
  i:=pos('VALUE',FBridge.Cde_PWM);
  if i>0 then
    begin
      texte:=FBridge.Cde_PWM;
      texte2:=copy(texte,1,i-1);
      delete(texte,1,i+5);
      texte:=texte2+texte1+texte;
    end;
  i:=pos('SENS',texte);
  if i>0 then
    begin
      texte2:=copy(texte,1,i-1);
      delete(texte,1,i+3);
      texte:=texte2+txt_sens+texte;
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
procedure TFBridge.Calcul_Mini_Maxi;
var r : real;
begin
  FBridge.Mini_Posi:=0;
  r:=Power(2,lg_Data);
  FBridge.Maxi_Posi:=r*FBridge.diviseur;
end;

procedure TFBridge.Disable_Screen;
begin
  FBridge.B_Left.Enabled:=False;
  FBridge.B_Moins.Enabled:=False;
  FBridge.B_Plus.Enabled:=False;
  FBridge.B_Right.Enabled:=False;
  FBridge.B_Stop.Enabled:=False;
  FBridge.B_Left.Enabled:=False;
end;

procedure TFBridge.Enable_Screen;
begin
  FBridge.B_Left.Enabled:=True;
  FBridge.B_Moins.Enabled:=True;
  FBridge.B_Plus.Enabled:=True;
  FBridge.B_Right.Enabled:=True;
  FBridge.B_Stop.Enabled:=True;
  FBridge.B_Left.Enabled:=True;
end;

//******************************************************************************
initialization


end.

