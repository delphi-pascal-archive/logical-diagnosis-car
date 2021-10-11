unit Unit_Connection;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, Buttons,CPort,Common;

type

  { TF_Connection }

  TF_Connection = class(TForm)
    B_Quitter: TBitBtn;
    B_Connecter: TBitBtn;
    Combo_Port: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    L_PortCOM: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure B_ConnecterClick(Sender: TObject);
    procedure B_QuitterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Valid : boolean;
    Vehicule_Name : string;
    Procedure Init;
    Function execute : boolean;
  end; 

var
  F_Connection: TF_Connection;

implementation

{$R *.dfm}

{ TF_Connection }

procedure TF_Connection.B_ConnecterClick(Sender: TObject);
begin
  If F_Connection.StringGrid1.Row<1 then
     begin
       Application.MessageBox(PCHAR(MenuProg[CMP_NoECUSelect]),PCHAR(MenuProg[CMP_Error]),0);
       exit;
     end else Vehicule_Name:=F_Connection.StringGrid1.Cells[0,F_Connection.StringGrid1.Row];
  F_Connection.Valid:=True;
  F_Connection.Close;
end;

procedure TF_Connection.B_QuitterClick(Sender: TObject);
begin
  F_Connection.Valid:=False;
  F_Connection.Close;
end;

procedure TF_Connection.Init;
var sFileData : TSearchREC;
begin
  F_Connection.StringGrid1.RowCount:=1;
  if ( FindFirst( Repertoire_courant + 'Vehicule\'+'*.veh', faAnyFile, sFileData) = 0 ) then
    begin
      repeat
        if ( ( sFileData.Name <> '.' ) and ( sFileData.Name <> '..' ) ) then
           begin
             F_Connection.StringGrid1.RowCount:=F_Connection.StringGrid1.RowCount+1;
             F_Connection.StringGrid1.Cells[0,F_Connection.StringGrid1.RowCount-1]:=sFileData.Name;
           end;
      until ( FindNext( sFileData ) <> 0 );
    end;
  FindClose( sFileData );
  if F_Connection.StringGrid1.RowCount>1 then
    begin
      F_Connection.StringGrid1.FixedRows:=1;
    end;
  EnumComports(F_Connection.Combo_Port.Items);
  F_Connection.Combo_Port.ItemIndex:=F_Connection.Combo_Port.Items.IndexOf(Port_Com);
  if (F_Connection.Combo_Port.ItemIndex<0)
     and (F_Connection.Combo_Port.Items.Count>0)
     then F_Connection.Combo_Port.ItemIndex:=0
     else F_Connection.Combo_Port.Text:=MenuProg[CMP_NoComPort];
  F_Connection.Caption:=MenuProg[CMP_Connecter];
  F_Connection.GroupBox1.Caption:=MenuProg[CMP_ECU];
  F_Connection.StringGrid1.Cells[0,0]:=MenuProg[CMP_ECU];
  F_Connection.B_Connecter.Caption:=MenuProg[CMP_Connecter];
  F_Connection.B_Quitter.Caption:=MenuProg[CMP_Quitter];
  F_Connection.GroupBox2.Caption:=MenuProg[CMP_Configuration];
  F_Connection.L_PortCOM.Caption:=MenuProg[CMP_Comport];
end;

function TF_Connection.execute: boolean;
begin
  F_Connection.Init;
  F_Connection.Valid:=False;
  F_Connection.ShowModal;
  Result:=F_Connection.Valid;
end;



end.

