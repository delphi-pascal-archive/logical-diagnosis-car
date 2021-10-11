unit uonoff;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls;

type

  { TFOnOff }

  TFOnOff = class(TForm)
    B_Fermer: TButton;
    B_Off: TButton;
    B_On: TButton;
    L_Pin: TLabel;
    procedure B_FermerClick(Sender: TObject);
    procedure B_OffClick(Sender: TObject);
    procedure B_OnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Etat : boolean;
    Actif : boolean;
    N_Sortie : byte;
    Boitier  : byte; // 0-> master; 1-> iou ...
    Cde_ON : string;
    Cde_Off : String;
    Cde_Exit : string;
    Buffer : string;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FOnOff: TFOnOff;

implementation

{$R *.dfm}

uses umain,common;

{ TFOnOff }

procedure TFOnOff.B_FermerClick(Sender: TObject);
begin
  if length(FOnOff.Cde_Exit)>0 then
    begin
      Buffer:=FOnOff.Cde_Exit;
      if FMain.T_StatusIO.Enabled=False then
        begin
          FMain.T_StatusIO.Enabled:=True;
          FMain.T_StatusIO.Interval:=100;
        end;
    end;
  FOnOff.Actif:=false;
  FOnOff.Close;
end;

procedure TFOnOff.B_OffClick(Sender: TObject);
begin
  FOnOff.Disable_Screen;
  FOnOff.B_off.Font.Size:=16;
  FOnOff.B_off.Font.Style:=[fsBold];
  FOnOff.B_On.Font.Size:=10;
  FOnOff.B_On.Font.Style:=[];
  //
  if length(FOnOff.Cde_Off)=0 then exit;
  //FMain.Cde2Send(FOnOff.Cde_Off);
  //FMain.NoReceive:=True;
  //FMain.Execution:=False;
  //FMain.KWP20001.SendResponse;
  //FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=FOnOff.Cde_Off;
end;

procedure TFOnOff.B_OnClick(Sender: TObject);
begin
  FOnOff.Disable_Screen;
  FOnOff.B_On.Font.Size:=16;
  FOnOff.B_On.Font.Style:=[fsBold];
  FOnOff.B_Off.Font.Size:=10;
  FOnOff.B_Off.Font.Style:=[];
  //
  if length(FOnOff.Cde_On)=0 then exit;
  //FMain.Cde2Send(FOnOff.Cde_On);
  //FMain.Execution:=False;
  //FMain.NoReceive:=True;
  //FMain.KWP20001.SendResponse;
  //FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=FOnOff.Cde_On;
end;

procedure TFOnOff.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FOnOff.Etat:=False;
  FOnOff.Actif:=false;
  FOnOff.Enable_Screen;
end;

procedure TFOnOff.FormCreate(Sender: TObject);
begin
  FOnOff.Etat:=False;
  FOnOff.Actif:=false;
end;

procedure TFOnOff.Disable_Screen;
begin
  FOnOff.B_Off.Enabled:=False;
  FOnOff.B_ON.Enabled:=False;
end;

procedure TFOnOff.Enable_Screen;
begin
  FOnOff.B_Off.Enabled:=True;
  FOnOff.B_ON.Enabled:=True;
end;

end.

