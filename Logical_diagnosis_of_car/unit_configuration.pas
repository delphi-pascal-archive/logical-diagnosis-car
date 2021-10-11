unit Unit_Configuration;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Grids,Common;

type

  { TF_Configuration }

  TF_Configuration = class(TForm)
    B_Save: TBitBtn;
    B_Exit: TBitBtn;
    CB_Langue: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Panel1: TPanel;
    Grid_Boitier: TStringGrid;
    procedure B_QuitterClick(Sender: TObject);
    procedure B_SaveClick(Sender: TObject);
    procedure CB_LangueChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Grid_BoitierClick(Sender: TObject);
    procedure Grid_BoitierEditingDone(Sender: TObject);
    procedure Grid_BoitierSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
    oldValue : string;
  public
    { public declarations }
    Langue : string;
    sortie : boolean;
    Procedure Init_Langue;

    function execute: boolean;
    Procedure Lecture_ini;
    Procedure Sauve_Ini;
  end; 

var
  F_Configuration: TF_Configuration;

implementation

{$R *.dfm}

uses uMain;

{ TF_Configuration }

procedure TF_Configuration.B_QuitterClick(Sender: TObject);
begin
  F_Configuration.Close;
end;

procedure TF_Configuration.B_SaveClick(Sender: TObject);
begin
  sortie:=True;
end;

procedure TF_Configuration.CB_LangueChange(Sender: TObject);
var texte : string;
begin
  texte:=F_Configuration.CB_Langue.Text;
  if FileExists(Repertoire_courant+'Languages\'+texte+'.dia') then
    begin
      ReadLanguage(Repertoire_courant+'Languages\'+texte+'.dia');
      F_Configuration.Init_Langue;
    end;
end;


procedure TF_Configuration.FormCreate(Sender: TObject);
var s : TSearchRec;
    texte : string;
begin
  F_Configuration.CB_Langue.Clear;
  if FindFirst(Repertoire_courant+'Languages\*.dia',faAnyFile,s)=0 then
    begin
      repeat
        texte:=s.Name;
        texte:=copy(texte,1,length(texte)-4);
        F_Configuration.CB_Langue.Items.Add(texte);
      until (FindNext(s)<>0) or (Nb_Langue>255);
    end;
  FindClose(s);
  F_Configuration.CB_Langue.Text:='francais';
  //if FileExists(Repertoire_Courant+'DiagKWP.ini') then Lecture_Ini else Sauve_Ini;
end;

procedure TF_Configuration.Grid_BoitierClick(Sender: TObject);
begin
  OldValue:=Grid_Boitier.Cells[Grid_Boitier.Col,Grid_Boitier.Row];
end;

procedure TF_Configuration.Grid_BoitierEditingDone(Sender: TObject);
var ACol,ARow : integer;
    i : integer;
    texte : string;
begin
  aCol:=Grid_Boitier.Col;
  aRow:=Grid_Boitier.Row;
  try
    case aRow of
      1 : begin // comport
        texte:=Grid_Boitier.Cells[aCol,aRow];
        delete(texte,1,3); // we delete the "COM"
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Comport.Port:=Grid_Boitier.Cells[aCol,aRow];
      end;
      2 : begin // versus
        F_Configuration.Grid_Boitier.Cells[aCol,aRow]:=OldValue;
      end;
      3 : begin // diagnostic speed
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.DiagnosticSpeed:=i;
      end;
      4 : begin // Mode information
        F_Configuration.Grid_Boitier.Cells[aCol,aRow]:=OldValue;
      end;
      5 : begin // Number of Tentative
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Tentative:=i;
      end;
      6 : begin // Duration of adress byte
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_Ad:=i;
      end;
      7 : begin // time between adress and Sync byte
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_Ad_Sync:=i;
      end;
      8 : begin // time between Sync and Key1 byte
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_Sync_Key1:=i;
      end;
      9 : begin // time between Key1 and Key2 byte
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_Key1_Key2:=i;
      end;
      10 : begin // time between Key2b and Adb byte
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_Key2b_Adb:=i;
      end;
      11 : begin // Time out
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Time_TO:=i;
      end;
      12 : begin // Time_tester present
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Tps_Maintient:=i;
      end;
      13 : begin // Wait 1 req
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Wait_1Req:=i;
      end;
      14 : begin // Wait response request
        texte:=Grid_Boitier.Cells[aCol,aRow];
        texte:=trim(texte);
        i:=strtoint(texte);
        FMain.KWP20001.Wait_Response_Request:=i;
      end;
    end;
  except
    F_Configuration.Grid_Boitier.Cells[aCol,aRow]:=OldValue;
  end;
end;

procedure TF_Configuration.Grid_BoitierSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  OldValue:=Grid_Boitier.Cells[aCol,aRow];
end;

procedure TF_Configuration.Init_Langue;
var i : integer;
begin
  F_Configuration.Caption:=MenuProg[CMP_Configuration];
  F_Configuration.GroupBox1.Caption:=MenuProg[CMP_DefautLang];
  F_Configuration.Label2.Caption:=MenuProg[CMP_DefautLang];
  F_Configuration.B_Save.Caption:=MenuProg[CMP_Save];
  F_Configuration.B_Exit.Caption:=MenuProg[CMP_Quitter];
  F_Configuration.GroupBox2.Caption:=MenuProg[CMP_SetCom];
  F_Configuration.Grid_Boitier.RowCount:=15;
  F_Configuration.Grid_Boitier.Cells[0,0]:=MenuProg[CMP_Parametre];
  F_Configuration.Grid_Boitier.Cells[1,0]:=MenuProg[CMP_Value];
  F_Configuration.Grid_Boitier.Cells[0,1]:='COM';
  F_Configuration.Grid_Boitier.Cells[0,2]:=menuProg[CMP_Versus];
  F_Configuration.Grid_Boitier.Cells[0,3]:=MenuProg[CMP_DiagSpeed];
  F_Configuration.Grid_Boitier.Cells[0,4]:=MenuProg[CMP_ModeInformation];
  F_Configuration.Grid_Boitier.Cells[0,5]:=MenuProg[CMP_Tentative];
  F_Configuration.Grid_Boitier.Cells[0,6]:=MenuProg[CMP_Time_Ad];
  F_Configuration.Grid_Boitier.Cells[0,7]:=MenuProg[CMP_Time_Ad_Sync];
  F_Configuration.Grid_Boitier.Cells[0,8]:=MenuProg[CMP_Time_Sync_Key1];
  F_Configuration.Grid_Boitier.Cells[0,9]:=MenuProg[CMP_Time_Key1_Key2];
  F_Configuration.Grid_Boitier.Cells[0,10]:=MenuProg[CMP_Time_Key2b_Adb];
  F_Configuration.Grid_Boitier.Cells[0,11]:=MenuProg[CMP_Time_TO];
  F_Configuration.Grid_Boitier.Cells[0,12]:=MenuProg[CMP_testerPresent];
  F_Configuration.Grid_Boitier.Cells[0,13]:=MenuProg[CMP_Wait_1REq];
  F_Configuration.Grid_Boitier.Cells[0,14]:=MenuProg[CMP_Wait_Res_Req];
  for I := 0 to 14 do
    if F_Configuration.Grid_Boitier.ColWidths[0]<F_Configuration.Grid_Boitier.Canvas.TextWidth(F_Configuration.Grid_Boitier.Cells[0,i])+10
       then F_Configuration.Grid_Boitier.ColWidths[0]:=F_Configuration.Grid_Boitier.Canvas.TextWidth(F_Configuration.Grid_Boitier.Cells[0,i])+10;
end;

Function TF_Configuration.execute : boolean;
var i : integer;

begin
  sortie:=False;
  langue:=F_Configuration.CB_Langue.Text;
  if FileExists(Repertoire_Courant+'DiagKWP.ini') then Lecture_Ini else Sauve_Ini;
  F_Configuration.Init_Langue;
  F_Configuration.Grid_Boitier.Cells[1,1]:=FMain.KWP20001.Comport.Port;
  F_Configuration.Grid_Boitier.Cells[1,2]:=FMain.KWP20001.Version;
  F_Configuration.Grid_Boitier.Cells[1,3]:=inttostr(FMain.KWP20001.DiagnosticSpeed);
  F_Configuration.Grid_Boitier.Cells[1,4]:=FMain.KWP20001.ModeInfoToStr(FMain.KWP20001.Mode_Information);
  F_Configuration.Grid_Boitier.Cells[1,5]:=inttostr(FMain.KWP20001.Tentative);
  F_Configuration.Grid_Boitier.Cells[1,6]:=inttostr(FMain.KWP20001.Time_Ad);
  F_Configuration.Grid_Boitier.Cells[1,7]:=inttostr(FMain.KWP20001.Time_Ad_Sync);
  F_Configuration.Grid_Boitier.Cells[1,8]:=inttostr(FMain.KWP20001.Time_Sync_Key1);
  F_Configuration.Grid_Boitier.Cells[1,9]:=inttostr(FMain.KWP20001.Time_Key1_Key2);
  F_Configuration.Grid_Boitier.Cells[1,10]:=inttostr(FMain.KWP20001.Time_Key2b_Adb);
  F_Configuration.Grid_Boitier.Cells[1,11]:=inttostr(FMain.KWP20001.Time_TO);
  F_Configuration.Grid_Boitier.Cells[1,12]:=inttostr(FMain.KWP20001.Tps_Maintient);
  F_Configuration.Grid_Boitier.Cells[1,13]:=inttostr(FMain.KWP20001.Wait_1Req);
  F_Configuration.Grid_Boitier.Cells[1,14]:=inttostr(FMain.KWP20001.Wait_Response_Request);
  F_Configuration.ShowModal;
  if sortie then
    begin
      FMain.KWP20001.LoadMessageTXT(Repertoire_courant+'Languages\'+F_Configuration.CB_Langue.Text+'.KWP');
      FMain.Init_Message;
      FMain.KWP20001.SaveConfiguration(Repertoire_courant+'KWP.ini');
      F_Configuration.Sauve_Ini;
    end else
    begin
      F_Configuration.CB_Langue.Text:=langue;
      ReadLanguage(Repertoire_courant+'Languages\'+langue+'.dia');
      FMain.KWP20001.LoadConfiguration(Repertoire_courant+'KWP.ini');
    end;
  Result:=Sortie;
end;

procedure TF_Configuration.Lecture_ini;
var Fichier : TStringList;
    i : integer;
    texte : string;
begin
  try
    Fichier:=TStringList.Create;
    Fichier.LoadFromFile(Repertoire_Courant+'DiagKWP.ini');
    for i:=0 to Fichier.Count-1 do
      begin
        texte:=fichier.Strings[i];
        if (length(texte)>0) and (copy(texte,1,2)<>'//')
          then begin
            if copy(texte,1,5)='LANG=' then
              begin
                delete(texte,1,5);
                texte:=trim(texte);
                F_Configuration.CB_Langue.Text:=texte;
              end else
            if copy(texte,1,6)='DEBUG=' then
              begin
                delete(texte,1,6);
                texte:=trim(texte);
                try
                  FMain.Debug:=StrtoInt(texte);
                except
                  FMain.Debug:=0;
                end;
              end;
          end;
      end;
  finally
    fichier.Free;
  end;
end;

procedure TF_Configuration.Sauve_Ini;
var Fichier : TStringList;
begin
  try
    Fichier:=TStringList.Create;
    Fichier.Add('// DiagKWP configuration file');
    Fichier.Add('');
    Fichier.Add('LANG='+F_Configuration.CB_Langue.Text);
    Fichier.Add('DEBUG='+inttostr(FMain.Debug));
    Fichier.SaveToFile(Repertoire_Courant+'DiagKWP.ini');
  finally
    fichier.Free;
  end;
end;

end.

