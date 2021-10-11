program DiagKWP;

uses
  Forms,
  umain in 'umain.pas' {FMain},
  common in 'common.pas',
  CPort in 'CPort.pas',
  CPortCtl in 'CPortCtl.pas',
  CPortEsc in 'CPortEsc.pas',
  kwp2000 in 'kwp2000.pas',
  ubipwm in 'ubipwm.pas' {FBiPWM},
  uwiper in 'uwiper.pas' {FWiper},
  ubridge in 'ubridge.pas' {FBridge},
  ulist in 'ulist.pas' {FList},
  unit_ajoutboitier in 'unit_ajoutboitier.pas' {F_AjoutBoitier},
  unit_configuration in 'unit_configuration.pas' {F_Configuration},
  unit_connection in 'unit_connection.pas' {F_Connection},
  uonoff in 'uonoff.pas' {FOnOff},
  upwm in 'upwm.pas' {FPwm},
  uvalue in 'uvalue.pas' {FValue};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFBiPWM, FBiPWM);
  Application.CreateForm(TFWiper, FWiper);
  Application.CreateForm(TFBridge, FBridge);
  Application.CreateForm(TFList, FList);
  Application.CreateForm(TF_AjoutBoitier, F_AjoutBoitier);
  Application.CreateForm(TF_Configuration, F_Configuration);
  Application.CreateForm(TF_Connection, F_Connection);
  Application.CreateForm(TFOnOff, FOnOff);
  Application.CreateForm(TFPwm, FPwm);
  Application.CreateForm(TFValue, FValue);
  Application.Run;
end.
