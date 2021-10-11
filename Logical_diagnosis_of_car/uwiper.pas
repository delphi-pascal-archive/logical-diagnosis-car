unit uwiper;

interface

uses
  Classes, SysUtils,  Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFWiper }

  TFWiper = class(TForm)
    B_Fermer: TButton;
    B_Stop: TButton;
    B_Slow: TButton;
    B_Fast: TButton;
    GroupBox1: TGroupBox;
    L_Pin: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure B_FastClick(Sender: TObject);
    procedure B_FermerClick(Sender: TObject);
    procedure B_SlowClick(Sender: TObject);
    procedure B_StopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Actif : boolean;
    Boitier : byte;
    Cde_Wiper_Stop,Cde_Wiper_Slow,Cde_Wiper_Fast,Cde_Wiper_Exit : string;
    Buffer : string;
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FWiper: TFWiper;

implementation

{$R *.dfm}

uses umain,common;

{ TFWiper }

procedure TFWiper.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Actif :=false;
end;

procedure TFWiper.B_FermerClick(Sender: TObject);
begin
  if length(FWiper.Cde_Wiper_Exit)>0 then
    begin
      //FMain.Cde2Send(FWiper.Cde_Wiper_Fast);
      //while FMain.Execution=false do application.ProcessMessages;
      //FMain.NoReceive:=True;
      //FMain.Execution:=False;
      //FMain.KWP20001.SendResponse;
      FMain.Attente_Start;
      if FMain.T_StatusIO.Enabled=False then
        begin
          FMain.T_StatusIO.Enabled:=True;
          FMain.T_StatusIO.Interval:=100;
        end;
      Buffer:=FWiper.Cde_Wiper_Exit;
    end;
  FWiper.Close;
end;

procedure TFWiper.B_FastClick(Sender: TObject);
begin

  FWiper.B_Slow.Font.Size:=10;
  FWiper.B_Slow.Font.Style:=[];
  FWiper.B_Stop.Font.Size:=10;
  FWiper.B_Stop.Font.Style:=[];
  FWiper.B_Fast.Font.Size:=16;
  FWiper.B_Fast.Font.Style:=[fsBold];
  //
  if length(FWiper.Cde_Wiper_Fast)=0 then exit;
  //FMain.Cde2Send(FWiper.Cde_Wiper_Fast);
  //while FMain.Execution=false do application.ProcessMessages;
  //FMain.NoReceive:=True;
  //FMain.Execution:=False;
  //FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=FWiper.Cde_Wiper_Fast;
end;

procedure TFWiper.B_SlowClick(Sender: TObject);
begin
  FWiper.B_Slow.Font.Size:=16;
  FWiper.B_Slow.Font.Style:=[fsBold];
  FWiper.B_Stop.Font.Size:=10;
  FWiper.B_Stop.Font.Style:=[];
  FWiper.B_Fast.Font.Size:=10;
  FWiper.B_Fast.Font.Style:=[];
  if length(FWiper.Cde_Wiper_Slow)=0 then exit;
  //FMain.Cde2Send(FWiper.Cde_Wiper_Slow);
  //while FMain.Execution=false do application.ProcessMessages;
  //FMain.NoReceive:=True;
  //FMain.Execution:=False;
  //FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=FWiper.Cde_Wiper_Slow;
end;

procedure TFWiper.B_StopClick(Sender: TObject);
begin
  FWiper.B_Slow.Font.Size:=10;
  FWiper.B_Slow.Font.Style:=[];
  FWiper.B_Stop.Font.Size:=16;
  FWiper.B_Stop.Font.Style:=[fsBold];
  FWiper.B_Fast.Font.Size:=10;
  FWiper.B_Fast.Font.Style:=[];
  if length(FWiper.Cde_Wiper_Stop)=0 then exit;
  //FMain.Cde2Send(FWiper.Cde_Wiper_Stop);
  //while FMain.Execution=false do application.ProcessMessages;
  //FMain.NoReceive:=True;
  //FMain.Execution:=False;
  //FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
  if FMain.T_StatusIO.Enabled=False then
    begin
      FMain.T_StatusIO.Enabled:=True;
      FMain.T_StatusIO.Interval:=100;
    end;
  Buffer:=FWiper.Cde_Wiper_Stop;
end;

procedure TFWiper.FormCreate(Sender: TObject);
begin
  Actif :=false;
end;

procedure TFWiper.Disable_Screen;
begin
  FWiper.B_Stop.Enabled:=False;
  FWiper.B_Slow.Enabled:=False;
  FWiper.B_Fast.Enabled:=False;
end;

procedure TFWiper.Enable_Screen;
begin
  FWiper.B_Stop.Enabled:=True;
  FWiper.B_Slow.Enabled:=True;
  FWiper.B_Fast.Enabled:=True;
end;

end.

