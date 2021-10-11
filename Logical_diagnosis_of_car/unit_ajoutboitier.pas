unit Unit_AjoutBoitier;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TF_AjoutBoitier }

  TF_AjoutBoitier = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    E_NomBoitier: TEdit;
    E_Adresse: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  F_AjoutBoitier: TF_AjoutBoitier;

implementation

{$R *.dfm}



end.

