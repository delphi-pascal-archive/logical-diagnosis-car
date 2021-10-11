unit uvalue;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFValue }

  TFValue = class(TForm)
    B_Fermer: TButton;
    B_sendValue: TButton;
    E_Value: TEdit;
    L_Pin: TLabel;
    procedure B_FermerClick(Sender: TObject);
    procedure B_sendValueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Etat : boolean;
    Actif : boolean;
    lg_data : integer;
    Diviseur : real;
    Value : real;
    sens_octet : boolean;
    Cde_Send : string;
    Cde_Exit : string;
    Buffer : string;
    ColGrid,RowGrid : integer;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FValue: TFValue;

implementation

{$R *.dfm}

uses umain,common;


{ TFValue }

procedure TFValue.B_FermerClick(Sender: TObject);
begin
  FValue.Close;
end;

procedure TFValue.B_sendValueClick(Sender: TObject);
var r : real;
    i : integer;
    texte,texte1,texte2 : string;
begin
  try
    r:=strtoreel(FValue.E_Value.Text);
    if FValue.diviseur>0
      then r:=r/Fvalue.diviseur;
    i:=trunc(r);
    texte:=dectohex(i);
    i:=FValue.lg_data div 4;
    texte:=copy(texte,1,i);
    if (sens_octet) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
    texte1:='';
    while length(texte)>0 do
      begin
        texte1:=texte1+copy(texte,1,2)+' ';
        delete(texte,1,2);
      end;
    i:=pos('VALUE',FValue.Cde_Send);
    texte:=FValue.Cde_Send;
    if i>0 then
      begin
        texte2:=copy(texte,1,i-1);
        delete(texte,1,i+5);
        texte:=texte2+texte1+texte;
      end;
    //FMain.Cde2Send(texte);
    //while FMain.Execution=false do application.ProcessMessages;
    //FMain.NoReceive:=True;
    //FMain.Execution:=False;
    //FMain.KWP20001.SendResponse;
    //FMain.Attente_Start;
    if FMain.T_StatusIO.Enabled=False then
      begin
        FMain.T_StatusIO.Enabled:=True;
        FMain.T_StatusIO.Interval:=100;
      end;
    Buffer:=texte;
  except
  end;
end;

procedure TFValue.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Buffer:='';
  if length(FValue.Cde_Exit)>0 then
    begin
      //FMain.Cde2Send(FValue.Cde_Exit);
      //
      //while FMain.Execution=false do application.ProcessMessages;
      //FMain.NoReceive:=True;
      //FMain.Execution:=False;
      //FMain.KWP20001.SendResponse;
      //FMain.Attente_Start;
      if FMain.T_StatusIO.Enabled=False then
        begin
          FMain.T_StatusIO.Enabled:=True;
          FMain.T_StatusIO.Interval:=100;
        end;
      Buffer:=FValue.Cde_Exit;
    end;
  while length(Buffer)>0 do Application.ProcessMessages;
  if FMain.T_StatusIO.Enabled=False then
     begin
       FMain.T_StatusIO.Enabled:=True;
       FMain.T_StatusIO.Interval:=100;
     end;
  Buffer:='#';
  FValue.Actif:=false;
  //FValue.Close;
end;

procedure TFValue.FormCreate(Sender: TObject);
begin
  FValue.Actif:=false;
  FValue.Cde_Send:='';
  FValue.Cde_Exit:='';
  FValue.E_Value.Text:='';
end;

procedure TFValue.Disable_Screen;
begin
  FValue.B_sendValue.Enabled:=False;
  FValue.E_Value.Enabled:=False;
end;

procedure TFValue.Enable_Screen;
begin
  FValue.B_sendValue.Enabled:=true;
  FValue.E_Value.Enabled:=True;
end;


end.

