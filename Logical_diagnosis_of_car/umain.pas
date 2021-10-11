unit umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus,Grids, ComCtrls, unit_connection, CPort,
  common, Buttons, kwp2000, unit_Configuration,
  DateUtils, ImgList, ExtCtrls, StdCtrls, XPMan;
{
uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, Grids, ComCtrls, unit_connection, CPort,
  common, Buttons, kwp2000, unit_Configuration, EditBtn,u_open,u_save,
  DateUtils,LCLType;
}

//******************************************************************************
// Notes :
// version 2.0.0 : Passage de lazarus vers delphi car lazarus plante le thread
//                 du Comport lorqu'il ouvre une fenêtre TOpenDialog
//
// version 1.2.1 : - Modification de l'affichage des répertoires des fenetres
//                   Open et Save
//                 - Correction du bug d'affichage des nom d'entrées/ soties
//                   récupérée dans le calculateur.
// version 1.2.0 : - Ajout de la fenetre click List
//                 - Ajout de l'initialisation FAST CONNECT dans KWP2000
//
// version 1.0.2 : - Correction du bug de connection Multic sur véhicule
//                   (configuration du stop bit)
//
// Version 1.0.0 : - Première version
//                 Objectif : Avoir toutes les fonctionalitées de superdiag
//******************************************************************************
const slash = '\';

      Etat_Debut_Connection = 1;
      Etat_Connecte=2;
      Etat_Attente_Reponse =3;

      CT_SensHL = False;
      CT_SensLH = True;
	  
      
                    
type

  { TFMain }

  TFMain = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Group_Debug: TGroupBox;
    Image1: TImage;
    ImageList1: TImageList;
    ImageList2: TImageList;
    I_Attente: TImage;
    MainMenu1: TMainMenu;
    Menu_Langues: TMenuItem;
    Menu_Quitter: TMenuItem;
    Menu_Setting: TMenuItem;
    M_Debug: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    Menu_Connection: TMenuItem;
    T_Attente: TTimer;
    T_StatusIO: TTimer;
    TreeView1: TTreeView;
    IList_Rose: TImageList;
    IListConnect: TImageList;
    IList_Led: TImageList;
    Panel_Status: TPanel;
    L_Titre: TLabel;
    M_Status: TMemo;
    Panel_Command: TPanel;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    E_Sid: TEdit;
    E_Data: TEdit;
    B_Send: TBitBtn;
    M_Hist: TMemo;
    Panel_Grille: TPanel;
    StringGrid1: TStringGrid;
    Panel_Grid_Cde: TPanel;
    B_Mode_Maitre: TBitBtn;
    B_SaveGrid: TBitBtn;
    Panel_Liste_Para: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    E_Fichier_Para: TEdit;
    B_Rech_Fichier_Para: TButton;
    B_Lecture_Liste: TButton;
    B_Sauve_Liste: TButton;
    GroupBox3: TGroupBox;
    StringGrid2: TStringGrid;
    B_Export: TButton;
    Panel_Parametre: TPanel;
    L_Parametre: TLabel;
    L_Numero: TLabel;
    L_Para_Valeur: TLabel;
    B_Para_Lecture: TButton;
    B_Para_Ecriture: TButton;
    E_Para_Numero: TEdit;
    M_Parametre: TMemo;
    E_Para: TEdit;
    RadioAffVal: TRadioGroup;
    Panel_Value: TPanel;
    L_Valeur: TLabel;
    RadioAffVal1: TRadioGroup;
    E_Valeur: TEdit;
    M_Valeur: TMemo;
    B_Valeur_Ecriture: TButton;
    B_Valeur_Lecture: TButton;
    XPManifest1: TXPManifest;
    T_Command: TTimer;
//    procedure B_DownMouseDown(Sender: TOBject; Button: TMouseButton;
//      Shift: TShiftState; X, Y: Integer);
    procedure B_ExportClick(Sender: TObject);
    procedure B_Lecture_ListeClick(Sender: TObject);
    procedure B_Mode_MaitreClick(Sender: TObject);
    procedure B_Para_EcritureClick(Sender: TObject);
    procedure B_Para_LectureClick(Sender: TObject);
    procedure B_Rech_Fichier_ParaClick(Sender: TObject);
    procedure B_Sauve_ListeClick(Sender: TObject);
    procedure B_SaveGridClick(Sender: TObject);
    procedure B_SendClick(Sender: TObject);
//    procedure B_UpMouseDown(Sender: TOBject; Button: TMouseButton;
//      Shift: TShiftState; X, Y: Integer);
    procedure B_Valeur_EcritureClick(Sender: TObject);
    procedure B_Valeur_LectureClick(Sender: TObject);
    procedure E_ParaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure Menu_ConnectionClick(Sender: TObject);
    procedure Menu_QuitterClick(Sender: TObject);
    procedure Menu_SettingClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RadioAffVal1ChangeBounds(Sender: TObject);
    procedure RadioAffValChangeBounds(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1Resize(Sender: TObject);
    procedure T_AttenteTimer(Sender: TObject);
    procedure T_StatusIOTimer(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure Menu_langueAddClick(Sender: TObject);
    procedure T_CommandTimer(Sender: TObject);
  private
    { private declarations }
    num_image : integer;
    diag_actif : boolean;
    ledverteOn,ledVerteOFF,ledRougeOn,ledamberon,ledamberOff,ledRougeOff : TBitmap;
    cpt_erreur : integer;
    Grille_Up,nb_Row_visible : integer; // Permet de connaitre la plage d'entrée sortie visible

    procedure KWP20001Connect(Sender: TObject);
    procedure KWP20001Disconnect(Sender: TObject);
    procedure KWP20001Error(Sender: TObject; Erreur: integer; MsgErreur: string
      );
    procedure KWP20001ReceiveTrame(Sender: TObject);
    procedure KWP20001Status(Sender: TObject; Messages: string);
    procedure KWP20001Step(Sender: TObject; Messages: string);
  public
    { public declarations }
    MainExit : boolean;
    BeginExit : Boolean;
    Variable : array[0..9] of integer;
    Table : array[0..9] of TStringList;
    Type_Connection: integer;
    Debug : integer;
    State : integer;
    TypeAff : integer; // It's the type of screen to be visible : 0->StringGrid
    Vehicule : TStringList;
    MenuList : TStringList;
    ActualMenu : TStringList;
    ExtendedMenu : TStringList;
    ClickList : TStringList;
    ligneMenu : integer;
    ActualKWP : TStringList;
    ColorList : TStringList;
    Execution : boolean;
    TimeRepeat : integer;
    MenuName : string;
    TitleMenu : string;
    Fichier : TStringlist;
    nom_fichier : string;
    CdeReadParam,CdeWriteParam : string;
    CdeValueLength : string;
    CdeValueAction : integer;
    ClickTree : boolean; // when you click on the treeview, you doesn't do any things
    TypeCdeActif : integer;
    LigneGrid2 : integer;
    ClickActif : Boolean;
    ClickGlobal : string; // commande à envoyer si on doit activer le mode de diagnostique actif
    ClickExit : string; // commande à envoyer si on doit arrêter le mode de diagnostique actif
    NoReceive : boolean;
    InIOTimer : boolean;
    ComPort1: TComPort;
    KWP20001: TKWP2000;
    procedure GlobalReset;
    procedure Search_Item(ItemSearch : string;ListSearch : TStringList;var searchList: TStringList);
    Procedure Attente_Start;
    Procedure Attente_Stop;
    Function Cde2Send(CDE: string): integer;
    Procedure Create_Menu_Langue;
    Procedure Init_Message;
    Procedure Ajust_StringList(Count : integer; VAR Liste : TSTringList);
  end;

var
  FMain: TFMain;
  M : Array[0..255] of TMenuItem;
  Nb_Langue : integer;


implementation

{$R *.dfm}
{ TFMain }

uses upwm,ubridge,uwiper,uonoff,ubipwm,uvalue,ulist;

//******************************************************************************
procedure TFMain.Menu_ConnectionClick(Sender: TObject);
var i : integer;
    texte : string;
    noeud : TTreeNode;
    ListConnection : TStringList;
    type_diagnosticsession : byte;
begin
  FMain.cpt_erreur:=0;
  F_Connection.Valid:=False;

  try
    ListConnection :=TStringList.Create;
    ListConnection.Clear;
    If FMain.Menu_Connection.Caption='&'+MenuProg[CMP_Connecter] then
     begin
       if F_Connection.execute then
          begin
            type_diagnosticsession:=$81;
            FMain.Vehicule.LoadFromFile(Repertoire_courant+'Vehicule\'+F_Connection.Vehicule_Name);
	    FMain.Search_Item('CONNECTION',FMain.Vehicule,ListConnection);
	    Type_Connection:=0;
            FMain.TreeView1.Enabled:=False;
	    for i:=0 to ListConnection.Count-1 do
	      begin
	        texte:=ListConnection.Strings[i];
		if uppercase(copy(texte,1,5))='INIT=' then
		  begin
		    delete(texte,1,5);
		    if uppercase(texte)='FAST' then
                      begin
                        Type_Connection:=1;
                        FMain.KWP20001.ModeConnection:=1;
                      end;
		  end else
		if uppercase(copy(texte,1,7))='ECU_ID=' then
		  begin
		    delete(texte,1,7);
		    FMain.KWP20001.Target:=hextodec(texte);
	          end else
		if uppercase(copy(texte,1,8))='TOOL_ID=' then
		  begin
		    delete(texte,1,8);
		    FMain.KWP20001.Source:=hextodec(texte);
		  end else
		if uppercase(copy(texte,1,6))='SPEED=' then
		  begin
		    delete(texte,1,6);
		    try
		      FMain.KWP20001.DiagnosticSpeed:=Strtoint(texte);
		    except
		      FMain.KWP20001.DiagnosticSpeed:=10400;
		    end;
		  end else
                if uppercase(copy(texte,1,8))='SESSION=' then
		  begin
		    delete(texte,1,8);
		    type_diagnosticsession:=hextodec(texte);
	          end else
                if uppercase(copy(texte,1,14))='TESTERPRESENT=' then
		  begin
		    delete(texte,1,14);
		    FMain.KWP20001.Msg_TesterPresent:=texte;
	          end;
	      end;
	    // Research Menu ITEM
	    MenuList.Clear;
            FMain.ExtendedMenu.Clear;
	    FMain.Treeview1.Items.Clear;
	    Noeud:=FMain.TreeView1.Items.Add(nil,(MenuProg[CMP_Status]));
            Noeud.ImageIndex:=5;
            Noeud:=FMain.TreeView1.Items.Add(nil,(MenuProg[CMP_Command]));
            Noeud.ImageIndex:=1;

            FMain.Panel_grille.Visible:=False;
            FMain.Panel_Parametre.Visible:=False;
            FMain.Panel_Status.Visible:=True;
            MenuI:=1;
            Sous_MenuI:=0;
            FMain.ComPort1.Port:=F_Connection.Combo_Port.Text;
            FMain.M_Status.Clear;
            DateTimeToString(texte,'h-nn-ss-zzz',Now);
            FMain.M_Status.Lines.Add(texte+(MenuProg[CMP_TestConnect]));
            state:=1; // tentative de connection port série
            FMain.Attente_Start;
            FMain.KWP20001.Connect;
            FMain.Attente_Stop;
            if State<>0 then
               begin
                 // Connection au port série OK
                 State:=2;
                 FMain.Attente_Start;
                 FMain.M_Debug.Lines.Add('Lancement StartDiagnosis');
                 FMain.KWP20001.StartDiagnosis(type_diagnosticsession);
               end;
          end;
     end else
     begin
       FMain.GlobalReset;
     end;
  finally
	ListConnection.Free;
  end;
end;

//******************************************************************************
procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  MainExit:=True;
  FMain.Execution:=True;
  FMain.T_StatusIO.Enabled:=False;
  //if FMain.ComPort1.Connected then FMain.ComPort1.Close;
end;

//******************************************************************************
procedure TFMain.B_Para_LectureClick(Sender: TObject);
var n_para : integer;
    texte : string;
begin
  try
    n_para:=hextodec(uppercase(FMain.E_Para_Numero.Text));
  except
    Application.MessageBox(PCHAR(MenuProg[CMP_NumberNotHex]),PCHAR(MenuProg[CMP_Error]),0);
    exit;
  end;
  if n_para<=255 then
     begin
       texte:=FMain.CdeReadParam;
       delete(texte,1,1);
       if length(texte)=0 then exit;
       FMain.Cde2Send(texte);
       FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=n_para;
       FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
       // System configuration
       FMain.CdeValueAction:=1;
       FMain.KWP20001.SendResponse;
       FMain.Attente_Start;
     end else Application.MessageBox(PCHAR(MenuProg[CMP_ParamOutRange]),PCHAR(MenuProg[CMP_Error]),0);
end;

//******************************************************************************
procedure TFMain.B_Rech_Fichier_ParaClick(Sender: TObject);
var texte : string;
    i : integer;
    erreur : integer;
begin
  erreur:=1;
  //if FOpen.Execute then
  FMain.OpenDialog1.Filter:='Fichier XML|*.xml';
  if FMain.OpenDialog1.Execute then
     begin
       //FMain.E_Fichier_Para.Text:=FOpen.FileName;
       FMain.E_Fichier_Para.Text:=FMain.OpenDialog1.FileName;
       AssignFile(fichier_txt,FMain.E_Fichier_Para.Text);
       reset(fichier_txt);
       FMain.StringGrid2.RowCount:=1;
       FMain.StringGrid2.Cells[0,0]:=MenuProg[CMP_HexaAdress];
       FMain.StringGrid2.Cells[1,0]:=MenuProg[CMP_Name];
       FMAin.StringGrid2.Cells[2,0]:=MenuProg[CMP_PhysicalAdress];
       FMain.StringGrid2.Cells[3,0]:=MenuProg[CMP_Length];
       FMain.StringGrid2.Cells[4,0]:=MenuProg[CMP_Position];
       FMain.StringGrid2.Cells[5,0]:=MenuProg[CMP_Fault];
       FMain.StringGrid2.Cells[6,0]:=MenuProg[CMP_Min];
       FMain.StringGrid2.Cells[7,0]:=menuProg[CMP_Max];
       FMain.StringGrid2.Cells[8,0]:=MenuProg[CMP_DecimalValue];
       For i:=0 to 8 do
         FMain.StringGrid2.ColWidths[i]:=FMain.StringGrid2.Canvas.TextWidth(FMain.StringGrid2.Cells[i,0])+10;
       while eof(fichier_txt)=false do
         begin
           readln(fichier_txt,texte);
           i:=pos('PARM ID',texte);
           if i>0 then
              begin
                erreur:=0;
                delete(texte,1,i+9);
                i:=pos(']',texte);
                FMain.StringGrid2.RowCount:=FMain.StringGrid2.RowCount+1;
                FMain.StringGrid2.Cells[0,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[1,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('ADDRESS=',texte);
                delete(texte,1,i+8);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[2,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('SIZE=',texte);
                delete(texte,1,i+5);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[3,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('POSITION=',texte);
                delete(texte,1,i+9);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[4,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('DEFAULT=',texte);
                delete(texte,1,i+8);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[5,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('MIN=',texte);
                delete(texte,1,i+4);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[6,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('MAX=',texte);
                delete(texte,1,i+4);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[7,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
                i:=pos('VALUE=',texte);
                delete(texte,1,i+6);
                i:=pos('"',texte);
                FMain.StringGrid2.Cells[8,FMain.StringGrid2.RowCount-1]:=copy(texte,1,i-1);
                delete(texte,1,i);
              end;
           For i:=0 to 8 do
             begin
               if (FMain.StringGrid2.ColWidths[i]<FMain.StringGrid2.Canvas.TextWidth(FMain.StringGrid2.Cells[i,FMain.StringGrid2.RowCount-1])+10)
                  then FMain.StringGrid2.ColWidths[i]:=FMain.StringGrid2.Canvas.TextWidth(FMain.StringGrid2.Cells[i,FMain.StringGrid2.RowCount-1])+10;
             end;
         end;
       if FMain.StringGrid2.RowCount>1 then FMain.StringGrid2.FixedRows:=1;
       CloseFile(fichier_txt);
       if erreur=1 then
          begin
            Application.MessageBox(PCHAR(MenuProg[CMP_WrongFile]),PCHAR(MenuProg[CMP_Error]),0);
            exit;
          end;
     end;
end;

//******************************************************************************
procedure TFMain.B_Sauve_ListeClick(Sender: TObject);
var n_para,val_para : integer;
    texte : string;
    k : integer;
    l,lg : integer; // used to know the sens of octet
begin
  if FMain.StringGrid2.RowCount<2 then exit;
  FMain.TypeCdeActif:=2;
  try
    n_para:=hextodec(uppercase(FMain.StringGrid2.Cells[0,1]));
  except
    Application.MessageBox(PCHAR(MenuProg[CMP_NumberNotHex]),PCHAR(MenuProg[CMP_Error]),0);
    exit;
  end;
  try
    val_para:=strtoint(FMain.StringGrid2.Cells[8,1]);
  except
    Application.MessageBox(PCHAR(MenuProg[CMP_ValueNotHex]),PCHAR(MenuProg[CMP_Error]),0);
    exit;
  end;
  if n_para<=255 then
     begin
       texte:=FMain.CdeWriteParam;
       if texte[1]='L' then l:=0 else l:=1;
       delete(texte,1,1);
       FMain.Cde2Send(texte);
       FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=n_para;
       FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
       // ecriture valeur dans le Buffer
       try
         texte:=dectohex(val_para);
       except
         texte:='00';
       end;
       if (FMain.StringGrid2.Cells[3,1]='16')
          and (length(texte)=2)
          then texte:='00'+texte;
       if (l=0) and (length(texte)>2) then
         begin
           texte:=copy(texte,3,2)+copy(texte,1,2);
         end;
       lg:=(length(texte) div 2);
       for k:=0 to lg-1 do
         begin
           FMain.KWP20001.FData[k+FMain.KWP20001.SendLength]:=hextodec(copy(texte,1,2));
           delete(texte,1,2);
         end;

       FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+lg;
       // System configuration
       //FMain.Timer_Maintient.Enabled:=False;
       FMain.LigneGrid2:=1;
       FMain.KWP20001.SendResponse;
       FMain.Attente_Start;
     end else Application.MessageBox(PCHAR(MenuProg[CMP_ParamOutRange]),PCHAR(MenuProg[CMP_Error]),0);
end;

//******************************************************************************
procedure TFMain.B_SaveGridClick(Sender: TObject);
var i,j : integer;
    texte : string;
begin
  //FSave.RadioGroup1.Visible:=false;
  //FSave.RadioGroup1.ItemIndex:=1;
  FMain.OpenDialog1.Filter:='Fichier Excel (CSV)|*.csv';
  if FMain.OpenDialog1.execute then
    begin
      FMain.nom_fichier:='';
      Fichier.Clear;
      for i:=0 to FMain.StringGrid1.RowCount-1 do
        begin
          texte:='';
          for j:=0 to FMain.StringGrid1.ColCount-1 do
            texte:=texte+FMain.StringGrid1.Cells[j,i]+';';
          Fichier.Add(texte);
        end;
      texte:=lowercase(FMain.OpenDialog1.FileName);
      i:=pos('.csv',texte);
      if i=0 then texte:=texte+'.csv';
      Fichier.SaveToFile(texte);
    end;
  //FSave.RadioGroup1.Visible:=True;
end;

//******************************************************************************
procedure TFMain.B_SendClick(Sender: TObject);
var datetxt : string;
    texte : string;
    i : integer;
    
begin
  DateTimeToString(datetxt,'h : nn m ss sec zzz ms - ',Now);
  FMain.E_Sid.Text:=uppercase(FMain.E_Sid.Text);
  FMain.E_Data.Text:=uppercase(FMain.E_Data.Text);
  try
    FMain.KWP20001.Sid:=hextodec(trim(FMain.E_Sid.Text));
  except
    FMain.M_Hist.Lines.Add(datetxt+MenuProg[CMP_SidError]);
    exit;
  end;
  texte:=FMain.E_Data.Text;
  texte:=trim(texte);
  i:=0;
  while length(texte)>0 do
    begin
      FMain.KWP20001.FData[i]:=hextodec(copy(texte,1,2));
      i:=i+1;
      delete(texte,1,3);
    end;
  FMain.KWP20001.SendLength:=i;
  FMain.Execution:=False;
  texte:=dectohex(FMain.KWP20001.Sid)+' ';
  for i:=0 to FMain.KWP20001.SendLength-1 do texte:=texte+dectohex(FMain.KWP20001.FData[i])+' ';
  FMain.M_Hist.Lines.Add(datetxt+MenuProg[CMP_Send]+' - '+texte);
  FMain.Attente_Start;
  FMain.KWP20001.SendResponse;
  While (Execution=False) and (MainExit=False) do Application.ProcessMessages;
  if MainExit then Exit;
  texte:=dectohex(FMain.KWP20001.SidReceive)+' ';
  for i:=0 to FMain.KWP20001.ReceiveLength-1 do texte:=texte+dectohex(FMain.KWP20001.TrameRx[i])+' ';
  FMain.M_Hist.Lines.Add(datetxt+MenuProg[CMP_Receive]+' - '+texte);
end;

//******************************************************************************
{procedure TFMain.B_UpMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMain.Grille_Up>0 then
     begin
       FMain.Grille_Up:=FMain.Grille_Up-1;
       FMain.rafraichir_diag;
     end;
end;
}
//******************************************************************************
procedure TFMain.B_Valeur_EcritureClick(Sender: TObject);
var val_para : integer;
    texte,texte1 : string;
    i,j : integer;
    d : array[0..20] of byte;
    nd : integer;
    sens_octet : integer;
    Nb_BitValue : integer;
begin
  if FMain.RadioAffVal.ItemIndex=0 then
     begin
       try
         val_para:=strtoint(FMain.E_Valeur.Text);
       except
         Application.MessageBox(PCHAR(MenuProg[CMP_ValueNotHex]),PCHAR(MenuProg[CMP_Error]),0);
         exit;
       end;
     end else
     begin
       try
         val_para:=hextodec(uppercase(FMain.E_Valeur.Text));
       except
         Application.MessageBox(PCHAR(MenuProg[CMP_ValueNotHex]),PCHAR(MenuProg[CMP_Error]),0);
         exit;
       end;
     end;
  texte:=FMain.CdeWriteParam;
  if texte[1]='L' then sens_octet:=0 else sens_octet:=1;
  delete(texte,1,1);
  if length(texte)=0 then exit;
  Fmain.Cde2Send(texte);
  j:=FMain.KWP20001.SendLength;
  texte:=dectohex(val_para);
  if Length(CdeValueLength)>0 then
    begin
      try
        Nb_BitValue:=strtoint(CdeValueLength);
        while length(texte)<(Nb_BitValue div 4) do texte:='00'+texte;
      except
      end;
    end;
  nd:=0;
  while length(texte)>0 do
    begin
      texte1:=copy(texte,1,2);
      d[nd]:=hextodec(texte1);
      nd:=nd+1;
      delete(texte,1,2);
    end;
  FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+nd;
  //j:=2;
  if sens_octet=0 then
    begin
      for i:=nd-1 downto 0 do
        begin
          FMain.KWP20001.FData[j]:=d[i];
          j:=j+1;
        end;
    end else
    begin
      for i:=0 to nd-1 do
        begin
          FMain.KWP20001.FData[j]:=d[i];
          j:=j+1;
        end;
    end;
  // System configuration
  //FMain.Timer_Maintient.Enabled:=False;
  FMain.CdeValueAction:=2;
  FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
end;

//******************************************************************************
procedure TFMain.B_Valeur_LectureClick(Sender: TObject);
var texte : string;
begin
  texte:=FMain.CdeReadParam;
  delete(texte,1,1);
  if length(texte)=0 then exit;
  FMain.CdeValueAction:=1;
  FMain.Cde2Send(texte);
  // System configuration
  FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
end;

//******************************************************************************
procedure TFMain.E_ParaChange(Sender: TObject);
begin

end;

//******************************************************************************
procedure TFMain.B_Para_EcritureClick(Sender: TObject);
var n_para,val_para : integer;
    texte,texte1 : string;
    i,j : integer;
    d : array[0..20] of byte;
    nd : integer;
    sens_octet : integer;
begin
  try
    n_para:=hextodec(uppercase(FMain.E_Para_Numero.Text));
  except
    Application.MessageBox(PCHAR(MenuProg[CMP_NumberNotHex]),PCHAR(MenuProg[CMP_Error]),0);
    exit;
  end;
  if FMain.RadioAffVal.ItemIndex=0 then
     begin
       try
         val_para:=strtoint(FMain.E_Para.Text);
       except
         Application.MessageBox(PCHAR(MenuProg[CMP_ValueNotHex]),PCHAR(MenuProg[CMP_Error]),0);
         exit;
       end;
     end else
     begin
       try
         val_para:=hextodec(uppercase(FMain.E_Para.Text));
       except
         Application.MessageBox(PCHAR(MenuProg[CMP_ValueNotHex]),PCHAR(MenuProg[CMP_Error]),0);
         exit;
       end;
     end;

  if n_para<=255 then
     begin
       texte:=FMain.CdeWriteParam;
       if texte[1]='L' then sens_octet:=0 else sens_octet:=1;
       delete(texte,1,1);
       if length(texte)=0 then exit;
       Fmain.Cde2Send(texte);
       FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=n_para;
       FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
       j:=FMain.KWP20001.SendLength;
       texte:=dectohex(val_para);
       nd:=0;
       while length(texte)>0 do
         begin
           texte1:=copy(texte,1,2);
           d[nd]:=hextodec(texte1);
           nd:=nd+1;
           delete(texte,1,2);
         end;
       FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+nd;
       //j:=2;
       if sens_octet=0 then
         begin
           for i:=nd-1 downto 0 do
             begin
               FMain.KWP20001.FData[j]:=d[i];
               j:=j+1;
             end;
         end else
         begin
           for i:=0 to nd-1 do
             begin
               FMain.KWP20001.FData[j]:=d[i];
               j:=j+1;
             end;
         end;
       // System configuration
       //FMain.Timer_Maintient.Enabled:=False;
       FMain.CdeValueAction:=2;
       FMain.KWP20001.SendResponse;
       FMain.Attente_Start;
     end else Application.MessageBox(PCHAR(MenuProg[CMP_ParamOutRange]),PCHAR(MenuProg[CMP_Error]),0);
end;

//******************************************************************************
procedure TFMain.B_ExportClick(Sender: TObject);
var i,j:integer;
    texte : string;
begin
  //If FSave.Execute then
  FMain.SaveDialog1.Filter:='Fichier XML|*.xml|Fichier Excel (CSV)|*.csv';
  FMain.SaveDialog1.FilterIndex:=0;
  if FMain.SaveDialog1.Execute then
     begin
       if FMain.SaveDialog1.FilterIndex<1 then FMain.SaveDialog1.FilterIndex:=0;
       texte:=FMain.SaveDialog1.FileName;
       case FMain.SaveDialog1.FilterIndex of
         1 : begin
           i:=pos('.xml',lowercase(texte));
           if i<1 then FMain.SaveDialog1.FileName:=FMain.SaveDialog1.FileName+'.xml';
         end;
         2 : begin
           i:=pos('.csv',lowercase(texte));
           if i<1 then FMain.SaveDialog1.FileName:=FMain.SaveDialog1.FileName+'.csv';
         end;
       end;
       if pos('.xml',lowercase(FMain.SaveDialog1.FileName))<1 then
          begin
            AssignFile(fichier_txt,FMain.SaveDialog1.FileName);
            Rewrite(fichier_txt);
            Writeln(fichier_txt,'Tableau de paramétres du'+dateTimeToStr(Now));
            Writeln(fichier_txt,'');
            for i:=0 to FMain.StringGrid2.RowCount-1 do
              begin
                texte:='';
                for j:=0 to FMain.StringGrid2.ColCount-1 do
                    begin
                      texte:=texte+FMain.StringGrid2.Cells[j,i]+';';
                    end;
                writeln(fichier_txt,texte);
              end;
            Closefile(fichier_txt);
          end else
          begin // sauve xml
            AssignFile(fichier_txt,FMain.SaveDialog1.FileName);
            Rewrite(fichier_txt);
            Writeln(fichier_txt,'<?xml:lang="fr" version="1.0" standalone="no"?>');
            Writeln(fichier_txt,'<!DOCTYPE ParamEEPROMDescr SYSTEM "ParamDesc.dtd">');
            Writeln(fichier_txt,'');
            Writeln(fichier_txt,'<ParamEEPROMDescr>');
            Writeln(fichier_txt,'');
            Writeln(fichier_txt,'   <ParamEEPROM-List>');
            Writeln(fichier_txt,'');
            for i:=1 to FMain.StringGrid2.RowCount-1 do
              begin
                texte:='      <ParamEEPROM-PARM ID="['
                      +FMain.StringGrid2.Cells[0,i]
                      +'] '
                      +FMain.StringGrid2.Cells[1,i]
                      +'" ADDRESS="'
                      +FMain.StringGrid2.Cells[2,i]
                      +'" SIZE="'
                      +FMain.StringGrid2.Cells[3,i]
                      +'" POSITION="'
                      +FMain.StringGrid2.Cells[4,i]
                      +'" DEFAULT="'
                      +FMain.StringGrid2.Cells[5,i]
                      +'" MIN="'
                      +FMain.StringGrid2.Cells[6,i]
                      +'" MAX="'
                      +FMain.StringGrid2.Cells[7,i]
                      +'" VALUE="'
                      +FMain.StringGrid2.Cells[8,i]
                      +'" />'
                      ;

                writeln(fichier_txt,texte);
              end;
            Writeln(fichier_txt,'');
            Writeln(fichier_txt,'   </ParamEEPROM-List>');
            Writeln(fichier_txt,'');
            Writeln(fichier_txt,'</ParamEEPROMDescr>');
            Writeln(fichier_txt,'');
            Closefile(fichier_txt);
          end;
     end;
end;


{
procedure TFMain.B_DownMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMain.Grille_Up+FMain.nb_Row_visible<FMain.StringGrid3.RowCount then
     begin
       FMain.Grille_Up:=FMain.Grille_Up+1;
       FMain.rafraichir_diag;
     end;
end;
}
//******************************************************************************
procedure TFMain.B_Lecture_ListeClick(Sender: TObject);
var n_para : integer;
    texte : string;
begin
  if FMain.StringGrid2.RowCount<2 then exit;
      try
        n_para:=hextodec(uppercase(FMain.StringGrid2.Cells[0,1]));
      except
        Application.MessageBox(PCHAR(MenuProg[CMP_NumberNotHex]),PCHAR(MenuProg[CMP_Error]),0);
        exit;
      end;
      if n_para<=255 then
         begin
           texte:=FMain.CdeReadParam;
           delete(texte,1,1);
           FMain.Cde2Send(texte);
           FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=n_para;
           FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
           
           // System configuration
           //FMain.Timer_Maintient.Enabled:=False;
           FMain.LigneGrid2:=1;
           FMain.TypeCdeActif:=1;
           FMain.KWP20001.SendResponse;
           FMain.Attente_Start;
         end;
end;

//******************************************************************************
procedure TFMain.B_Mode_MaitreClick(Sender: TObject);
begin
  while (FMain.KWP20001.EndReceive=false)
    and (MainExit=False) do application.ProcessMessages;
  if MainExit=True then Exit;

  FMain.Cde2Send(FMain.ClickExit);
  FMain.Execution:=False;
  FMain.NoReceive:=True;
  FMain.KWP20001.SendResponse;
  FMain.Attente_Start;
  FMain.B_Mode_Maitre.Visible:=False;
  FMain.ClickActif:=False;
  if FBiPWM.Actif then FBiPwm.Close;
  if FPwm.Actif then FPWM.Close;
  if FBridge.Actif then FBridge.Close;
  if FOnOff.Actif then FOnOff.Close;
  if FValue.Actif then FValue.Close;
  if FWiper.Actif then FWiper.Close;
end;

//******************************************************************************
procedure TFMain.FormCreate(Sender: TObject);
var i,j : integer;
    texte : string;
begin
  MainExit:=False;
  ledverteOn:=Tbitmap.Create;
  ledVerteOFF:=Tbitmap.Create;
  ledRougeOn:=Tbitmap.Create;
  ledRougeOff:=Tbitmap.Create;
  FMain.IList_Led.GetBitmap(0,FMain.ledVerteOFF);
  FMain.IList_Led.GetBitmap(3,FMain.ledVerteON);
  FMain.IList_Led.GetBitmap(1,FMain.ledRougeON);
  FMain.IList_Led.GetBitmap(2,FMain.ledRougeOFF);
  ledamberOn:=Tbitmap.Create;
  ledamberOff:=Tbitmap.Create;
  //ledamberOn.LoadFromLazarusResource('LEDpurpleon');
  //ledamberOff.LoadFromLazarusResource('LEDpurpleoff');
  FMain.ComPort1:=TComPort.Create(Self);
  FMain.KWP20001:=TKWP2000.Create(Self);
  FMain.KWP20001.Comport:=FMain.ComPort1;
  FMain.KWP20001.OnReceiveTrame:=FMain.KWP20001ReceiveTrame;
  FMain.KWP20001.OnError:=FMain.KWP20001Error;
  FMain.KWP20001.OnStep:=FMain.KWP20001Step;
  FMain.KWP20001.OnConnect:=FMain.KWP20001Connect;
  FMain.KWP20001.OnDisconnect:=FMain.KWP20001Disconnect;
  FMain.KWP20001.OnStatus:=FMain.KWP20001Status;
  // récupération du répertoire courant
  texte:=Application.ExeName;
  i:=length(texte);
  while (i>1)and (texte[i]<>'\') and (texte[i]<>'/') do i:=i-1;
  Repertoire_courant:=copy(texte,1,i); // copie du repertoire courant avec le slash de fin
  if FileExists(Repertoire_courant+'KWP.ini')
    then FMain.KWP20001.LoadConfiguration(Repertoire_courant+'KWP.ini')
    else FMain.KWP20001.SaveConfiguration(Repertoire_courant+'KWP.ini');
  if not FileExists(Repertoire_courant+'languages\francais.KWP')
    then FMain.KWP20001.SaveMessageTXT(Repertoire_courant+'languages\francais.KWP');
  Fichier := TStringlist.Create;
  Vehicule:=TStringList.Create;
  MenuList:=TStringList.Create;
  ActualMenu := TStringList.Create;
  ActualKWP := TStringList.Create;
  FMain.ExtendedMenu:=TStringList.Create;
  FMain.ClickList:=TStringList.Create;
  FMain.ColorList := TStringList.Create;
  MenuTextInit;
  if not FileExists(Repertoire_courant+'languages\francais.dia')
    then Writelanguage(Repertoire_courant+'languages\francais.dia');
  FMain.Create_Menu_Langue;
  //
  if FileExists(Repertoire_courant+'DiagKWP.ini') then
    begin
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
      j:=-1;
      i:=0;
      while (j=-1) and (i<Nb_Langue) do
        if uppercase(M[i].Caption)=uppercase(texte) then j:=i else i:=i+1;
      if j>-1 then
        begin
          ReadLanguage(Repertoire_courant+'Languages\'+texte+'.dia');
          FMain.KWP20001.LoadMessageTXT(Repertoire_courant+'Languages\'+texte+'.KWP');
          M[j].Checked:=True;
        end;
    end else
    begin
      Fichier.Clear;
      Fichier.Add('// DiagKWP configuration file');
      Fichier.Add('');
      Fichier.Add('LANG=francais');
      Fichier.Add('DEBUG=0');
      Fichier.SaveToFile(Repertoire_Courant+'DiagKWP.ini');
      j:=-1;
      i:=0;
      while (j=-1) and (i<Nb_Langue) do
        if uppercase(M[i].Caption)='FRANCAIS' then j:=i else i:=i+1;
      if j>-1 then
        begin
          M[j].Checked:=True;
        end;
    end;
  //
  Fmain.Init_Message;
  //FMain.StringGrid3.RowCount:=0;
  FMain.StringGrid1.RowCount:=0;
  if FMain.Debug=0
    then FMain.Group_Debug.Visible:=False
    else FMain.Group_Debug.Visible:=True;
  FMain.GlobalReset;
end;

//******************************************************************************
procedure TFMain.FormDestroy(Sender: TObject);
var i : integer;
begin
  FMain.Vehicule.Free;
  FMain.MenuList.Free;
  Fichier.Free;
  ActualMenu.Free;
  ActualKWP.Free;
  FMain.ExtendedMenu.Free;
  FMain.ClickList.Free;
  FMain.ColorList.Free;
  ledverteOn.Free;
  ledVerteOFF.Free;
  ledRougeOn.free;
  ledRougeOff.free;
  ledAmberOn.free;
  ledAmberOff.free;
  FMain.ComPort1.Free;
  FMain.KWP20001.Free;
  //master.Free;
  for i:=0 to 9 do if Table[i]<>nil then Table[i].Free;
end;

//******************************************************************************
procedure TFMain.KWP20001Connect(Sender: TObject);
var texte,texte1 : string;
    liste_connection : TStringList;
    ListCommand : TStringList;
    cond : string; // condition to repeat a command
    cde : string; // command to send
    i,j,k,l,m,n : integer;
    outdoor : boolean;
    byteRule: string;
    DebutByte,FinByte,DebutBit,FinBit : integer;
    valeur,val_cond : integer;
    f_Byte,f_Bit : string;
    mask : byte;
    noeud : TTreeNode;
    n_ligne,max_val,min_val : integer;
begin
  DateTimeToString(texte,'h:nn.ss.zzz',Now);
  FMain.M_Status.Lines.Add(texte+MenuProg[CMP_ConnectOK]);
  FMain.M_Debug.Lines.Add(texte+MenuProg[CMP_ConnectOK]);
  FMain.Image1.Picture.Bitmap:=nil;
  FMain.IListConnect.GetBitmap(1,FMain.Image1.Picture.Bitmap);
  //FMain.Timer_Maintient.Enabled:=True;
  State:=Etat_Connecte;
  FMain.Menu_Connection.Caption:=MenuProg[CMP_Deconnecter];
  FMain.Panel_Parametre.Visible:=False;
  FMain.Panel_grille.Visible:=False;
  FMain.Panel_Status.Visible:=True;
  FMain.Panel_Liste_Para.Visible:=False;
  F_Configuration.GroupBox2.Enabled:=False;
  // Recherche de toutes les commandes à executer juste après la connection
 { try
    liste_Connection:=TStringlist.Create;
    ListCommand:=TStringList.Create;
    FMain.Search_Item('CONNECTION',FMain.Vehicule,Liste_Connection);
    //Liste_Connection.SaveToFile('c:\Connection.txt');
    i:=0;
    FMain.TypeAff:=-1;
    while i<Liste_Connection.Count do
      begin
        Application.ProcessMessages;
        if MainExit then exit;
        texte:=Liste_Connection.Strings[i];
	      if uppercase(copy(texte,1,9))='<COMMAND>' then
	        begin
            ListCommand.Clear;
            while (texte<>'</COMMAND>') and (i<Liste_Connection.Count)do
              begin
                texte:=Liste_Connection.Strings[i];
                texte:=trim(texte);
                ListCommand.Add(texte);
                if texte<>'</COMMAND>' then i:=i+1;
              end;
            //ListCommand.SaveToFile('c:\Command'+inttostr(i)+'.txt');
            // on a récupéré tout le champ COMMAND
            // on va donc executer la commande
            j:=0;
            while j<ListCommand.Count do
              begin
                Application.ProcessMessages;
                if MainExit then exit;
                texte:=trim(ListCommand.Strings[j]);
                if copy(texte,1,5)='COND=' then
                  begin
                    delete(texte,1,5);
                    cond:=texte;
                  end else
                if copy(texte,1,5)='<KWP>' then
                  begin
                    FMain.ActualKWP.Clear;
                    cde:='';
                    while j<ListCommand.Count do
                      begin
                        texte:=trim(ListCommand.Strings[j]);
                        if copy(texte,1,2)<>'</' then FMain.ActualKWP.Add(texte);
                        if copy(texte,1,4)='CDE=' then cde:=texte;
                        if copy(texte,1,2)='</' then j:=ListCommand.Count;
                        j:=j+1;
                      end;
                  end;
                j:=j+1;
              end; // end of while j<ListCommand.Count do
          end;  // end of if uppercase(copy(texte,1,9))='<COMMAND>' then
        if length(cde)>0 then
          begin
            delete(cde,1,4);
            FMain.KWP20001.Sid:=hextodec(copy(cde,1,2));
            delete(cde,1,3);
            j:=0;
            while length(cde)>0 do
              begin
                Application.ProcessMessages;
                if MainExit then Exit;
                FMain.KWP20001.FData[j]:=hextodec(copy(cde,1,2));
                delete(cde,1,3);
                j:=j+1;
              end;
            FMain.KWP20001.SendLength:=j;
            if length(cond)>0 then
              begin
                outdoor:=false;
                // calcul du filtre sur les données
                j:=pos('/',cond);
                    ByteRule:=copy(cond,1,j-1);
                    delete(cond,1,j);
                    // on supprime les crochets du filtre
                    j:=pos('[',ByteRule);
                    if j>0 then delete(ByteRule,1,j);
                    j:=pos(']',ByteRule);
                    if j>0 then delete(ByteRule,j,1);
                    j:=pos('|',ByteRule);
                    // On sépare les filtres des octets et les filtres en fonction des bits
                    if j>0 then
                     begin
                       f_Byte:=copy(ByteRule,1,j-1);
                       delete(ByteRule,1,j);
                       f_bit:=ByteRule;
                     end else
                     begin
                       f_Byte:=ByteRule;
                       f_bit:='';
                     end;
                    j:=pos('-',f_Byte);
                    if j>0 then
                      begin
                        texte1:=copy(f_Byte,1,j-1);
                        try
                          DebutByte:=Strtoint(texte1);
                        except
                          DebutByte:=0;
                        end;
                        delete(f_byte,1,j);
                        try
                          FinByte:=Strtoint(f_Byte);
                        except
                          FinByte:=0;
                        end;
                      end else
                      begin
                        try
                          DebutByte:=Strtoint(f_Byte);
                        except
                          DebutByte:=0;
                        end;
                        FinByte:=DebutByte;
                      end;
                    // récupération de la plage de bit demandée
                    if length(f_bit)>0 then  // on a un filtre sur les bits
                     begin
                       j:=pos('-',f_Bit);
                       if j>0 then  // on a une plage
                         begin
                           texte1:=copy(f_Bit,1,j-1);
                           try
                             DebutBit:=Strtoint(texte1);
                           except
                             DebutBit:=0;
                           end;
                           delete(f_bit,1,j);
                           try
                             FinBit:=Strtoint(f_Bit);
                           except
                             FinBit:=0;
                           end;
                         end else
                         begin   //Il n'y a pas de plage
                           try
                             DebutBit:=Strtoint(f_Bit);
                           except
                             DebutBit:=0;
                           end;
                           FinBit:=DebutBit;
                         end;
                       // creation du masque de récupération
                       mask:=0;
                       for j:=DebutBit to FinBit do
                         mask:=mask or (1 shl j);
                     end else mask:=$FF;
                    texte:=cond;
                    delete(texte,1,1);
                    try
                      val_cond:=strtoint(texte);
                    except
                      outdoor:=true;
                    end;
                    // execution à répétition
                    sleep(500);
                    beginExit:=false;
                    While (outdoor=False) and (BeginExit=False) do
                  begin
                    FMain.M_Debug.Lines.Add('KWPConnect');
                    Application.ProcessMessages;
                    if MainExit then Exit;
                    FMain.KWP20001.SendResponse;
                    FMain.Attente_Start;
                    Execution:=False;
                    While (Execution=False)
                      and (MainExit=False) do Application.ProcessMessages;
                    if MainExit then Exit;
                    // détermination du filtre sur les octets
                    valeur:=0;
                    for j:=DebutByte to FinByte do
                      begin
                        valeur:=valeur*256+(FMain.KWP20001.TrameRx[j] and mask);
                      end;
                    if copy(cond,1,1)='=' then
                      begin
                        if valeur=val_cond then outdoor:=true;
                      end else
                    if copy(cond,1,1)='>' then
                      begin
                        if valeur>val_cond then outdoor:=True;
                      end else
                    if copy(cond,1,1)='<' then
                      begin
                        if valeur<val_cond then outdoor:=True;
                      end else outdoor:=True; // there is an error in the cond statement
                      
                  end;
              end else
              begin
                sleep(500);
                FMain.KWP20001.SendResponse;
                FMain.Attente_Start;
                Execution:=False;
                While (Execution=False)
                  and (MainExit=False)do Application.ProcessMessages;
                if MainExit then Exit;
              end;
          end;
        i:=i+1;
      end; // end of  while i<ListConnection.Count do
  finally
    liste_Connection.Free;
    ListCommand.Free;
  end;

  // Traitement des menus
  i:=0;
  while i<Vehicule.Count do
    begin
      Application.ProcessMessages;
      if MainExit then Exit;
      texte:=Vehicule.Strings[i];
      trim(texte);
      if uppercase(copy(texte,1,4))='ICO=' then
        begin
          //noeud:=FMain.TreeView1.Items.GetFirstNode;
          if noeud<>nil then
            begin
              delete(texte,1,4);
              j:=pos(';',texte);
              try
                j:=strtoint(copy(texte,1,j-1));
              except
                j:=-1;
              end;
              noeud.ImageIndex:=j;
            end;
        end else
      if uppercase(copy(texte,1,8))='<EXMENU=' then
        begin
          DebutByte:=i;
          FMain.ExtendedMenu.Clear;
          delete(texte,2,2);
          FMain.ExtendedMenu.Add(texte);
          // on récupére le menu étendu à répéter
          outdoor:=False;
          i:=i+1;
          while outdoor=False do
            begin
              Application.ProcessMessages;
              if MainExit then Exit;
              if i<Vehicule.Count then texte:=Vehicule.Strings[i];
              trim(texte);
              if (i>=Vehicule.Count)
                or (uppercase(copy(texte,1,8))='<EXMENU=')
                or (uppercase(copy(texte,1,8))='</EXMENU')
                or (uppercase(copy(texte,1,6))='<MENU=') then outdoor:=True;
              if not outdoor then
                begin
                  if (length(texte)>0)
                    and (copy(texte,1,2)<>'//') then
                    begin
                      k:=pos(';',texte);
                      if k=0 then FMain.ExtendedMenu.Add(texte) else FMain.ExtendedMenu.Add(copy(texte,1,k));
                    end;
                  i:=i+1;
                end else FinByte:=i;
            end;
          //FMain.ExtendedMenu.SaveToFile('c:\ExtendedMenu.txt');
          // Traitement de l'extended menu
          // on efface l'extended menu du fichier vehicule
          for j:=DebutByte to FinByte do
            begin
              FMain.Vehicule.Delete(DebutByte);
            end;
          // on doit récupérer la condition de répétition val_cond
          j:=0;
          while j<FMain.ExtendedMenu.Count do
            begin
              Application.ProcessMessages;
              if MainExit then Exit;
              texte:=FMain.ExtendedMenu.Strings[j];
              if copy(texte,1,9)='EXREPEAT=' then
                begin
                  delete(texte,1,9);
                  k:=pos(';',texte);
                  if k>0 then texte:=copy(texte,1,k-1);
                  texte:=trim(texte);
                  try
                    val_cond:=strtoint(texte);   // n° de la variable de répétition
                  except
                    val_cond:=-1;
                  end;
                  FMain.ExtendedMenu.Delete(j); // On efface cette consigne
                  j:=FMain.ExtendedMenu.Count;
                end;
              j:=j+1;
            end;
          if copy(FMain.ExtendedMenu.Strings[FMain.ExtendedMenu.Count-1],1,7)<>'</MENU>'
             then FMain.ExtendedMenu.Add('</MENU>');
          // On commence l'intégration des menus dans le fichier vehicule en mémoire
          if (val_cond>-1) and (FMain.Variable[Val_cond]>0) then
            begin
              l:=0;
              n_ligne:=0;
              max_val:=0;
              min_val:=10000;
              m:=-1;
              for j:=1 to FMain.Variable[Val_cond] do
                begin
                  for k:=0 to FMain.ExtendedMenu.Count-1 do
                    begin
                      Application.ProcessMessages;
                      if MainExit then Exit;
                      texte:=FMain.ExtendedMenu.Strings[k];
                      if copy(texte,1,4)='<MEN' then
                        begin
                          debutBit:=pos('>',texte);
                          if debutBit>0 then texte:=copy(texte,1,debutbit-1);
                          texte:=texte+' '+inttostr(j)+'>';
                        end else
                      if copy(texte,1,4)='CLK=' then
                        begin
                          m:=pos('EXV',texte);
                          texte1:=dectohex(j);
                          while m>0 do
                            begin
                              texte:=copy(texte,1,m-1)+texte1+copy(texte,m+3,length(texte)-3);
                              m:=pos('EXV',texte);
                            end;
                        end else
                      if copy(texte,1,4)='CDE=' then
                        begin
                          debutBit:=pos(';',texte);
                          if debutBit>0 then texte:=copy(texte,1,debutbit-1);
                          texte:=texte+' '+dectohex(j)+';';
                        end else
                      if copy(texte,1,3)='LG=' then
                        begin
                          debutbit:=pos('TAB[',texte);
                          if debutbit>0 then
                            begin
                              cond:=copy(texte,1,debutbit+3);
                              delete(texte,1,debutbit+3);
                              debutbit:=pos(',',texte);
                              cond:=cond+copy(texte,1,debutbit);
                              delete(texte,1,debutbit);
                              debutbit:=pos(']',texte);
                              valeur:=strtoint(copy(texte,1,debutbit-1));
                              delete(texte,1,debutbit-1);
                              if max_val<valeur then max_val:=valeur;
                              if min_val>valeur then min_val:=valeur;
                              valeur:=valeur+n_ligne;
                              texte:=cond+inttostr(valeur)+texte;
                            end;
                        end else
                      if copy(texte,1,3)='TR=' then
                        begin
                          debutbit:=pos('TAB[',texte);
                          if debutbit>0 then
                            begin
                              cond:=copy(texte,1,debutbit+3);
                              delete(texte,1,debutbit+3);
                              debutbit:=pos(',',texte);
                              cond:=cond+copy(texte,1,debutbit);
                              delete(texte,1,debutbit);
                              debutbit:=pos(']',texte);
                              valeur:=strtoint(copy(texte,1,debutbit-1));
                              delete(texte,1,debutbit-1);
                              if max_val<valeur then max_val:=valeur;
                              if min_val>valeur then min_val:=valeur;
                              valeur:=valeur+n_ligne;
                              texte:=cond+inttostr(valeur)+texte;
                            end;
                        end;
                      FMain.Vehicule.Insert(DebutByte+k+((j-1)*FMain.ExtendedMenu.Count),texte);
                    end;
                  // calcul de l
                  // n_ligne => 1e texte du tableau
                  // valeur => dernière valeur lu
                  n_ligne:=n_ligne+(max_val-min_val)+1;
                end;
            end;
          // ON a fini l'intégration, on remet le curseur i au début de cette zone ajoutée
          i:=DebutByte-1;
	end else
      if uppercase(copy(texte,1,6))='<MENU=' then
        begin
	  delete(texte,1,6);
	  j:=pos('>',texte);
	  if j>0 then
	    begin
	      MenuList.Add(copy(texte,1,j-1)+'/'+inttostr(i)+'/');
	      noeud:=FMain.TreeView1.Items.Add(nil,copy(texte,1,j-1));
	    end;
	end else
      if uppercase(copy(texte,1,6))='</MENU' then
        begin
	  delete(texte,1,6);
	  if MenuList.Count>0 then MenuList.Strings[MenuList.Count-1]:=MenuList.Strings[MenuList.Count-1]+inttostr(i)+'/';
	end ;
    i:=i+1;
  end;
  //FMain.TreeView1.Enabled:=True;
  FMain.Vehicule.SaveToFile('C:\vehicule.txt');
  }
  FMain.T_Command.Enabled:=True;
end;

//******************************************************************************
procedure TFMain.KWP20001Disconnect(Sender: TObject);
begin
  //FMain.Timer_Maintient.Enabled:=False;
  F_Configuration.GroupBox2.Enabled:=True;
  FMain.TreeView1.Enabled:=False;
  FMain.TreeView1.Items.Clear;
  FMain.Menu_Connection.Caption:=MenuProg[CMP_Connecter];
  FMain.Image1.Picture.Bitmap:=nil;
  FMain.IListConnect.GetBitmap(0,FMain.Image1.Picture.Bitmap);
  F_Configuration.GroupBox2.Enabled:=True;
  State:=0;
  FMain.ComPort1.Close;
  FMain.Attente_Stop;
end;

//******************************************************************************
procedure TFMain.KWP20001Error(Sender: TObject; Erreur: integer;
  MsgErreur: string);
var texte : string;
begin
  DateTimeToString(texte,'h:nn.ss.zzz',Now);
  execution:=True;
  FMain.M_Status.Lines.Add(texte+' - '+MsgErreur);
  FMain.M_Debug.Lines.Add(texte+' - MainError: '+MsgErreur);
  FMain.Attente_Stop;
  if erreur=Err_5Baud  then
     begin
       {FMain.Attente_Stop;

       FMain.cpt_erreur:=FMain.cpt_erreur+1;
       if FMain.cpt_erreur<=3
          then  FMain.KWP20001.StartDiagnosis
          else FMain.GlobalReset;
          }
     end;
  if Erreur=Err_TO then
     begin
       if FMain.State=Etat_Connecte then
          begin
            //FMain.cpt_erreur:=FMain.cpt_erreur+1;
            //if FMain.cpt_erreur<=3
            //   then  FMain.KWP20001.SendResponse
            //   else FMain.Menu_ConnectionClick(nil);
          end;
       F_Configuration.GroupBox2.Enabled:=True;
       FMain.GlobalReset;
     end;

  //FMain.diag_actif:=False;
  //FMain.Attente_Start;
  //FMain.Timer_Maintient.Enabled:=True;
  //FMain.Execution:=True;
end;


//******************************************************************************
procedure TFMain.KWP20001ReceiveTrame(Sender: TObject);


      
var i,j,k,l,m,n,k1 : integer;
    texte,datetxt : string;
    octet,octet1 : byte;
    noeud : TTreeNode;
    ByteRule : string;
    RepeatRule : string;
    f_Byte,f_bit : string;
    DebutByte,FinByte : integer;
    DebutBit,FinBit : integer;
    Mask : Byte;
    texte1,texte2,texte3 : string;
    value : real;
    Val_Int : integer;
    nb_byteValue : array[0..100] of integer;
    nb_GroupValue : integer;
    ByteValue : array[0..100,0..255] of byte;
    ax,bx : real; // This value traduce Value=ax*X+bx
    couleur : string;
    IRow,AffRow : integer;
    sens_byte : Boolean;
    etat_timerIO : boolean;

begin
  FMain.cpt_erreur:=0;
  IRow:=-1;
  //FMain.Timer_Maintient.Enabled:=True;
  FMain.Attente_Stop;
  texte:='';
  For i:=0 to FMain.KWP20001.ReceiveLength-1 do
     texte:=texte+' '+dectohex(FMain.KWP20001.TrameRx[i]);
  DateTimeToString(datetxt,'h:nn.ss.zzz',Now);
  FMain.M_Debug.Lines.Add(Datetxt+' -Fonction Receive- '+texte);
  FMain.M_Debug.Lines.Add('');
  if (FMain.ClickTree) or (FMain.KWP20001.SidReceive=$7E) then
    begin
      Execution:=TRue;
      exit;
    end;
  if FMain.NoReceive then
    begin
      if FOnOff.Actif=True then FOnOff.Enable_Screen;
      if FBiPWM.Actif then FBiPwm.Enable_Screen;
      if FPwm.Actif then FPWM.Enable_Screen;
      if FBridge.Actif then FBridge.Enable_Screen;
      if FValue.Actif then FValue.Enable_Screen;
      if FWiper.Actif then FWiper.Enable_Screen;
      FMain.NoReceive:=False;
      Execution:=TRue;
      Exit;
    end;
  if State>0 then
     begin
       //if (FMain.KWP20001.Sid=$12) and (FMain.KWP20001.TrameRx[0]=$01) then
       //  begin
       //    Couleur:='zz';
       //  end;
       octet:=FMain.KWP20001.Sid+$40;
       if octet<>FMain.KWP20001.SidReceive then
          begin
            FMain.M_Debug.Lines.Add(Datetxt+' - octet='+dectohex(octet)+'-Sid='+dectohex(FMain.KWP20001.Sid));
            //FMain.Timer_Maintient.Enabled:=False;
            FMain.M_Debug.Lines.Add(Datetxt+MenuProg[CMP_SidError]);
            FMain.M_Status.Lines.Add(Datetxt+MenuProg[CMP_SidError]);
            //FMain.KWP20001.SendResponse;
            //FMain.Attente_Start;
            Execution:=True;
            if FMain.TypeAff=CT_AFFONEVALUE then
              begin
                texte:='';
                for k:=0 to FMain.KWP20001.ReceiveLength-1 do
                  begin
                    texte:=texte+dectohex(FMain.KWP20001.TrameRx[k])+' ';
                  end;
                texte:=dectohex(FMain.KWP20001.SidReceive)+' '+texte+' / '+MenuProg[CMP_SidError];
                FMain.M_Valeur.Lines.Add(Datetxt+' - '+texte);
                FMain.E_Valeur.Text:='';
              end else
            if FMain.TypeAff=CT_AFFONEPARAMETER then
              begin
                texte:='';
                for k:=0 to FMain.KWP20001.ReceiveLength-1 do
                  begin
                    texte:=texte+dectohex(FMain.KWP20001.TrameRx[k])+' ';
                  end;
                texte:=dectohex(FMain.KWP20001.SidReceive)+' '+texte+' / '+MenuProg[CMP_SidError];
                FMain.M_Parametre.Lines.Add(Datetxt+' - '+texte);
                FMain.E_Para.Text:='';
              end;
            exit;
          end;
       //FMain.Timer_Maintient.Enabled:=True;
       etat_TimerIO:=FMain.T_StatusIO.Enabled;
       FMain.T_StatusIO.Enabled:=False;
       Couleur:='';
       // We traduce the Byte for seeing
       for i:=0 to ActualKWP.Count-1 do
         begin
           texte:=ActualKWP.Strings[i];
           if uppercase(copy(texte,1,3))='TR=' then
             begin
               sens_byte:=CT_SensHL;
               delete(texte,1,3);
               // we extract the rule to traduce the value
               j:=pos('/',texte);
               ByteRule:=copy(texte,1,j-1);
               delete(texte,1,j);
               //delete(ByteRule,1,1);
               //ByteRule:=copy(ByteRule,1,length(ByteRule)-1);
               nb_GroupValue:=1;
               if length(ByteRule)>0 then
                 begin
                   // we have a rule to search
                   if uppercase(ByteRule[1])='R' then
                     begin
                       j:=pos('[',ByteRule);
                       RepeatRule:=copy(ByteRule,2,j-2); // je récupére le debut de la loi de répétition
                       delete(ByteRule,1,j-1);
                     end else
                     begin
                       // we don't repeat the rule
                       RepeatRule:='';
                     end;
                   if uppercase(copy(ByteRule,length(ByteRule),1))='L' then
                     begin
                       delete(byteRule,length(byteRule),1);
                       sens_Byte:=CT_SensLH;
                     end;
                   // on supprime les crochets du filtre
                   j:=pos('[',ByteRule);
                   if j>0 then delete(byteRule,1,j);
                   j:=pos(']',ByteRule);
                   if j>0 then ByteRule:=copy(ByteRule,1,j-1);
                   j:=pos('|',ByteRule);
                   // On sépare les filtres des octets et les filtres en fonction des bits
                   if j>0 then
                     begin
                       f_Byte:=copy(ByteRule,1,j-1);
                       delete(ByteRule,1,j);
                       f_bit:=ByteRule;
                     end else
                     begin
                       f_Byte:=ByteRule;
                       f_bit:='';
                     end;
                   j:=pos('-',f_Byte);
                   if j>0 then
                     begin
                       texte1:=copy(f_Byte,1,j-1);
                       try
                         DebutByte:=Strtoint(texte1);
                       except
                         DebutByte:=0;
                       end;
                       delete(f_byte,1,j);
                       try
                         FinByte:=Strtoint(f_Byte);
                       except
                         FinByte:=0;
                       end;
                     end else
                     begin
                       try
                         DebutByte:=Strtoint(f_Byte);
                       except
                         DebutByte:=0;
                       end;
                       FinByte:=DebutByte;
                     end;
                   if DebutByte>FinByte then
                     begin
                       j:=DebutByte;
                       DebutByte:=FinByte;
                       FinByte:=j;
                     end;
                   if FinByte>FMain.KWP20001.ReceiveLength then FinByte:=FMain.KWP20001.ReceiveLength-1;
                   if DebutByte>FMain.KWP20001.ReceiveLength then DebutByte:=FMain.KWP20001.ReceiveLength;
                   // récupération de la plage de bit demandée
                   if length(f_bit)>0 then  // on a un filtre sur les bits
                     begin
                       j:=pos('-',f_Bit);
                       if j>0 then  // on a une plage
                         begin
                           texte1:=copy(f_Bit,1,j-1);
                           try
                             DebutBit:=Strtoint(texte1);
                           except
                             DebutBit:=0;
                           end;
                           delete(f_bit,1,j);
                           try
                             FinBit:=Strtoint(f_Bit);
                           except
                             FinBit:=0;
                           end;
                         end else
                         begin   //Il n'y a pas de plage
                           try
                             DebutBit:=Strtoint(f_Bit);
                           except
                             DebutBit:=0;
                           end;
                           FinBit:=DebutBit;
                         end;
                       // creation du masque de récupération
                       mask:=0;
                       for j:=DebutBit to FinBit do
                         mask:=mask or (1 shl j);
                     end else
                     begin
                       mask:=$FF;
                       DebutBit:=0;
                       FinBit:=0;
                     end;
                   if DebutBit>FinBit then
                     begin
                       j:=DebutBit;
                       DebutBit:=FinBit;
                       FinBit:=j;
                     end;
                   // on remplit les valeurs dans le tampon de valeurs
                   if length(RepeatRule)>0 then
                     begin
                       try
                         j:=strtoint(RepeatRule);
                       except
                         j:=0;
                       end;
                       nb_GroupValue:=0;
                       repeat
                         if (j+DebutByte<FMain.KWP20001.ReceiveLength)then
                           begin
                             l:=0;
                             for k:=j+DebutByte to j+FinByte do
                               begin
                                 if Sens_Byte=CT_SensHL
                                   then ByteValue[nb_GroupValue,l]:=(FMain.KWP20001.TrameRx[k] and mask) shr DebutBit
                                   else ByteValue[nb_GroupValue,l]:=(FMain.KWP20001.TrameRx[k] and mask) shr debutBit;
                                 l:=l+1;
                               end;
                             nb_ByteValue[nb_GroupValue]:=FinByte-DebutByte+1;
                             nb_GroupValue:=nb_GroupValue+1;
                           end;
                         j:=j+FinByte+1;
                       until j>FMain.KWP20001.ReceiveLength-1;
                     end else  // end of if length(RepeatRule)>0 then
                     begin
                       if Sens_Byte=CT_SensHL then l:=0 else l:=FinByte-DebutByte;
                       for j:=DebutByte to FinByte do
                         begin
                           if Sens_Byte=CT_SensHL then
                             begin
                               ByteValue[0,l]:=(FMain.KWP20001.TrameRx[j] and mask) shr DebutBit;
                               l:=l+1;
                             end else
                             begin
                               ByteValue[0,l]:=(FMain.KWP20001.TrameRx[j] and mask) shr DebutBit;
                               l:=l-1;
                             end;
                         end;
                       nb_ByteValue[0]:=FinByte-DebutByte+1;
                       nb_GroupValue:=1;
                     end;     // end of ELSE of if length(RepeatRule)>0 then
                 end else  // end of if length(ByteRule)>0 then
                 begin
                   nb_ByteValue[0]:=FMain.KWP20001.ReceiveLength;
                   nb_GroupValue:=1;
                   if Sens_Byte=CT_SensHL then l:=0 else l:=FinByte-DebutByte;
                   for j:=0 to nb_byteValue[0]-1 do
                     begin
                       if Sens_Byte=CT_SensHL then
                         begin
                           ByteValue[0,l]:=(FMain.KWP20001.TrameRx[j]) shr DebutBit;
                           l:=l+1;
                         end else
                         begin
                           ByteValue[0,l]:=(FMain.KWP20001.TrameRx[j]) shr DebutBit;
                           l:=l-1;
                         end;
                     end;
                 end;     // end of ELSE  if length(ByteRule)>0 then
               // we search if there is a ajustment of value
               ax:=1;
               bx:=0;
               if length(texte)>0 then
                 if uppercase(copy(texte,1,2))='V=' then
                   begin
                     j:=pos('/',texte);
                     texte1:=copy(texte,1,j-1);
                     delete(texte,1,j);
                     delete(texte1,1,2);
                     j:=pos('|',texte1);
                     if j>0 then
                       begin
                         ax:=strtoReel(copy(texte1,1,j-1));
                         delete(texte1,1,j);
                         bx:=strtoReel(texte1);
                       end else
                       begin
                         ax:=strtoReel(texte1);
                         bx:=0;
                       end;
                   end;
                 if uppercase(copy(texte,1,4))='VAR=' then
                   begin
                     delete(texte,1,4);
                     j:=pos('/',texte);
                     if j=0 then j:=pos(';',texte);
                     if j>0 then texte2:=copy(texte,1,j-1) else texte2:=texte;
                     delete(texte,1,length(texte2)+1);
                     try
                       j:=strtoint(texte2);
                     except
                       j:=0;
                     end;
                     FMain.Variable[j]:=0;
                     for k:=0 to nb_ByteValue[0]-1 do
                       begin
                         FMain.Variable[j]:=FMain.Variable[j]*256+ByteValue[0,k];
                       end;
                   end;
                 if uppercase(copy(texte,1,6))='TABLE=' then
                   begin
                     delete(texte,1,6);
                     j:=pos('/',texte);
                     if j=0 then j:=pos(';',texte);
                     if j>0 then texte2:=copy(texte,1,j-1) else texte2:=texte;
                     delete(texte,1,length(texte2)+1);
                     try
                       j:=strtoint(texte2);
                     except
                       j:=0;
                     end;
                     texte2:='';
                     for k:=0 to nb_ByteValue[0]-1 do
                       begin
                         //texte2:=texte2+dectohex(ByteValue[0,k])+' ';
                         if ByteValue[0,k]>=32
                           then texte2:=texte2+chr(ByteValue[0,k]);
                       end;
                     if FMain.Table[j]= nil then FMain.Table[j]:=TStringList.create;
                     FMain.Table[j].Add(texte2);
                     //FMain.Table[j].SaveToFile('c:\table_'+inttostr(j)+'.txt');
                   end;
               if uppercase(copy(texte,1,4))='ROW=' then
                 begin
                   delete(texte,1,4);
                   j:=pos('/',texte);
                   texte2:=copy(texte,1,j-1);
                   delete(texte,1,j);
                   IRow:=strtoint(texte2);
                 end;
               // we write the value on the screen
               
               for j:=0 to nb_GroupValue-1 do
                 begin
                   texte1:=texte;
                   if FMain.TypeAff=CT_AFFMULTIVALUE then
                     begin
                       texte2:='';
                       val_int:=0;
                       for k:=0 to nb_ByteValue[j]-1 do
                         begin
                           val_int:=val_int*256+ByteValue[j,k];
                         end;
                       if FMain.TypeCdeActif=1 then FMain.StringGrid2.Cells[FMain.StringGrid2.ColCount-1,FMain.ligneGrid2]:=inttostr(val_int);
                       if FMain.ligneGrid2<FMain.StringGrid2.RowCount-1 then
                         begin
                           FMain.ligneGrid2:=FMain.ligneGrid2+1;
                           try
                             k:=hextodec(uppercase(FMain.StringGrid2.Cells[0,FMain.ligneGrid2]));
                           except
                             Application.MessageBox(PCHAR(MenuProg[CMP_NumberNotHex]),PCHAR(MenuProg[CMP_Error]),0);
                             exit;
                           end;
                           if k<=255 then
                             begin
                               if FMain.TypeCdeActif=1
                                 then texte:=FMain.CdeReadParam
                                 else texte:=FMain.CdeWriteParam;
                               if texte[1]='L' then l:=0 else l:=1;
                               delete(texte,1,1);
                               FMain.KWP20001.Sid:=hextodec(copy(texte,1,2));
                               delete(texte,1,3);
                               FMain.KWP20001.SendLength:=0;
                               while length(texte)>0 do
                                 begin
                                   FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=hextodec(copy(texte,1,2));
                                   FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
                                   delete(texte,1,3);
                                 end;
                               FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=k;
                               FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
                               if FMain.TypeCdeActif=2 then
                                 begin
                                   texte:=FMain.StringGrid2.Cells[FMain.StringGrid2.ColCount-1,FMain.ligneGrid2];
                                   try
                                     texte:=dectohex(strtoint(texte));
                                   except
                                     texte:='00';
                                   end;
                                   if (FMain.StringGrid2.Cells[3,FMain.ligneGrid2]='16')
                                     and (length(texte)=2)
                                       then texte:='00'+texte;
                                   if (l=0) and (length(texte)>2) then
                                     begin
                                       texte:=copy(texte,3,2)+copy(texte,1,2);
                                     end;
                                   l:=(length(texte) div 2);
                                   for k:=0 to l-1 do
                                     begin
                                       FMain.KWP20001.FData[k+FMain.KWP20001.SendLength]:=hextodec(copy(texte,1,2));
                                       delete(texte,1,2);
                                     end;
                                   FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+l;
                                 end; // end of if FMain.TypeCdeActif=2 then
                               // System configuration
                               FMain.KWP20001.SendResponse;
                               FMain.Attente_Start;
                               exit;
                           end;
                         end;   // end of   if FMain.ligneMenu<FMain.StringGrid2.RowCount then
                       exit;
                     end else
                   if FMain.TypeAff=CT_AFFONEVALUE then
                     begin
                       texte2:='';
                       val_int:=0;
                       for k:=0 to nb_ByteValue[j]-1 do
                         begin
                           texte2:=texte2+dectohex(ByteValue[j,k])+' ';
                           val_int:=val_int*256+ByteValue[j,k];
                         end;
                       texte2:=dectohex(FMain.KWP20001.SidReceive)+' '+texte2;
                       FMain.M_Valeur.Lines.Add(Datetxt+' - '+texte2);
                       if FMain.CdeValueAction=1 then
                         begin
                           if FMain.RadioAffVal1.ItemIndex=0
                             then FMain.E_VAleur.Text:=inttostr(val_int)
                             else FMain.E_Valeur.Text:=dectohex(val_int);
                         end;
                     end else
                   if FMain.TypeAff=CT_AFFONEPARAMETER then
                     begin
                       texte2:='';
                       val_int:=0;
                       for k:=0 to nb_ByteValue[j]-1 do
                         begin
                           texte2:=texte2+dectohex(ByteValue[j,k])+' ';
                           val_int:=val_int*256+ByteValue[j,k];
                         end;
                       texte2:=dectohex(FMain.KWP20001.SidReceive)+' '+texte2;
                       FMain.M_Parametre.Lines.Add(Datetxt+' - '+texte2);
                       if FMain.CdeValueAction=1 then
                         begin
                           if FMain.RadioAffVal.ItemIndex=0
                             then FMain.E_Para.Text:=inttostr(val_int)
                             else FMain.E_Para.Text:=dectohex(val_int);
                         end;
                     end else  //end of if Fmain.TypeAff=CT_AFFONEPARAMETER then
                   if Fmain.TypeAff=CT_AFFCONFIRM then
                     begin
                       Application.MessageBox(PCHAR(MenuProg[CMP_MsgConfirm]),PCHAR(MenuProg[CMP_MsgOK]),0);
                       exit;
                     end else // end of if Fmain.TypeAff=CT_AFFCONFIRM then
                   if FMain.TypeAff=CT_AFFGRID then
                     begin
                       if IRow=-1 then
                         begin
                           //FMain.StringGrid3.RowCount:=FMain.StringGrid3.RowCount+1;
                           //for k:=0 to FMain.StringGrid3.ColCount-1 do
                           //   FMain.StringGrid3.Cells[k,FMain.StringGrid3.RowCount-1];
                           //AffRow:=FMain.StringGrid3.RowCount-1;
                           FMain.StringGrid1.RowCount:=FMain.StringGrid1.RowCount+1;
                           FMain.Ajust_StringList(FMain.ColorList.Count+1,FMain.ColorList);
                           for k:=0 to FMain.StringGrid1.ColCount-1 do
                              FMain.StringGrid1.Cells[k,FMain.StringGrid1.RowCount-1]:='';
                           AffRow:=FMain.StringGrid1.RowCount-1;
                         end else
                         begin
                           //if IRow>=FMain.StringGrid3.RowCount then
                           //  begin
                           //    FMain.StringGrid3.RowCount:=IRow+1;
                           //    for k:=0 to FMain.StringGrid3.ColCount-1 do
                           //      FMain.StringGrid3.Cells[k,IRow]:='';
                           //  end;
                           if IRow>=FMain.StringGrid1.RowCount then
                             begin
                               FMain.StringGrid1.RowCount:=IRow+1;
                               FMain.Ajust_StringList(IRow+1,FMain.ColorList);
                               for k:=0 to FMain.StringGrid1.ColCount-1 do
                                 FMain.StringGrid1.Cells[k,IRow]:='';
                             end;
                           AffRow:=IRow;
                         end;
                       repeat
                         Application.ProcessMessages;
                         if MainExit then Exit;
                         k1:=pos('/',texte1);
                         if k1>0 then texte2:=copy(texte1,1,k1-1) else texte2:=texte1;
                         if uppercase(copy(texte2,1,3))='CL=' then
                           begin
                             delete(texte2,1,3);
                             FMain.ColorList.Strings[AffRow]:=texte2;
                             //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-2,AffRow]:=texte2;

                             texte2:='';
                           end else // end of if uppercase(copy(texte2,1,3))='CL=' then
                         if uppercase(copy(texte2,1,2))='GR' then
                           begin
                             delete(texte2,1,2);
                             k:=pos('=',texte2);
                             try
                               l:=strtoint(copy(texte2,1,k-1));
                             except
                               l:=0;
                             end;
                             delete(texte2,1,k);
                             if l<FMain.StringGrid1.ColCount then
                               begin
                                 if uppercase(copy(texte2,1,1))='[' then
                                   begin   // we have a list of value
                                     Val_int:=0;
                                     for k:=0 to nb_ByteValue[j]-1 do
                                       begin
                                         Val_int:=Val_int*256+ByteValue[j,k];
                                       end;
                                     // we search the label
                                     delete(texte2,1,1);
                                     delete(texte2,length(texte2),1);
                                     k:=0;
                                     texte3:='';
                                     while (length(texte2)>0) do
                                       begin
                                         m:=pos(',',texte2);
                                         if m>0 then
                                           begin
                                             if k=Val_int then
                                               begin
                                                 texte3:=copy(texte2,1,m-1);
                                                 texte2:='';
                                               end else k:=k+1;
                                             delete(texte2,1,m);
                                           end else
                                           begin
                                             if length(texte2)>0 then
                                               if k=Val_int then texte3:=texte2;
                                             texte2:='';
                                           end;
                                       end;
                                     if length(texte3)=0 then texte3:=MenuProg[CMP_Unknow];
                                     //FMain.StringGrid3.Cells[l,AffRow]:=texte3;
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte3;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte3)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte3)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'T'+Texte3+'|';
                                   end else
                                 if uppercase(copy(texte2,1,7))='VAL_TXT' then
                                   begin
                                     texte2:='';
                                     for k:=0 to nb_ByteValue[j]-1 do
                                       begin
                                         if ByteValue[j,k]>31
                                           then texte2:=texte2+chr(ByteValue[j,k]);
                                       end;
                                     //FMain.StringGrid3.Cells[l,AffRow]:=texte2;
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'T'+Texte2+'|';
                                   end else
                                 if uppercase(copy(texte2,1,5))='VALUE' then
                                   begin
                                     Value:=0;
                                     for k:=0 to nb_ByteValue[j]-1 do
                                       begin
                                         Value:=Value*256+ByteValue[j,k];
                                       end;
                                     Value:=Value*ax+bx;
                                     texte2:=reeltostr(Value);
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'V'+Texte2+'|';
                                   end else
                                 if uppercase(copy(texte2,1,7))='VAL_HEX' then
                                   begin
                                     texte2:='';
                                     for k:=0 to nb_ByteValue[j]-1 do
                                       begin
                                         texte2:=texte2+dectohex(ByteValue[j,k])+' ';
                                       end;
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'H'+Texte2+'|';
                                   end else
                                 if uppercase(copy(texte2,1,4))='IMG_' then
                                   begin
                                     //FMain.StringGrid3.Cells[l,AffRow]:=texte2;
                                     Val_Int:=0;
                                     for k:=0 to nb_ByteValue[j]-1 do
                                       begin
                                         Val_Int:=Val_Int*256+ByteValue[j,k];
                                       end;
                                     if Val_int=0 then texte2:=texte2+'0' else texte2:=texte2+'1';

                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=inttostr(Val_Int);
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'V'+texte2[length(texte2)]+'|';
                                   end else
                                 if uppercase(copy(texte2,1,5))='FILE(' then
                                   begin
                                     delete(texte2,1,5);
                                     k:=pos(')',texte2);
                                     if k>0 then
                                       begin
                                         texte2:=copy(texte2,1,k-1);
                                         texte2:=uppercase(trim(texte2));
                                         if uppercase(FMain.nom_fichier)<>texte2 then
                                           if FileExists(Repertoire_courant+'Vehicule\'+texte2) then
                                             begin
                                               FMain.nom_fichier:=texte2;
                                               FMain.Fichier.LoadFromFile(Repertoire_courant+'Vehicule\'+texte2);
                                             end;
                                         Val_Int:=0;
                                         for k:=0 to nb_ByteValue[j]-1 do
                                           begin
                                             Val_Int:=Val_Int*256+ByteValue[j,k];
                                           end;
                                         texte2:=dectohex(Val_Int);
                                         k:=0;
                                         while k<FMain.Fichier.Count do
                                           begin
                                             m:=pos(';',Fichier.Strings[k]);
                                             if copy(Fichier.Strings[k],1,m-1)=texte2 then
                                               begin
                                                 texte2:=Fichier.Strings[k];
                                                 delete(texte2,1,m);
                                                 k:=FMain.Fichier.Count;
                                               end;
                                             k:=k+1;
                                           end;
                                         FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                         if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                           then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                         //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'T'+texte2+'|';
                                       end;
                                   end else
                                 if uppercase(copy(texte2,1,4))='TAB[' then
                                   begin
                                     delete(texte2,1,4);
                                     k:=pos(',',texte2);
                                     if k>0 then
                                       begin
                                         try
                                           m:=strtoint(copy(texte2,1,k-1));
                                         except
                                           m:=-1;
                                         end;
                                         delete(texte2,1,k);
                                         k:=pos(']',texte2);
                                         try
                                           n:=strtoint(copy(texte2,1,k-1));
                                         except
                                           n:=-1;
                                         end;
                                         if (m>-1) and (m<10) then
                                           begin
                                             if FMain.Table[m]<>nil then
                                               begin
                                                 if (n>-1) and (n<FMain.Table[m].Count)then
                                                   begin
                                                     texte2:=FMain.Table[m].Strings[n];
                                                   end else texte2:=MenuProg[CMP_ERRORLIGNETABLE];
                                               end else texte2:=MenuProg[CMP_TableUnknow];
                                           end else texte2:=MenuProg[CMP_ERRORNUMBERTABLE];
                                       end;
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'T'+texte2+'|';
                                   end else
                                   begin
                                     FMain.StringGrid1.Cells[l,AffRow]:=texte2;
                                     if FMain.StringGrid1.ColWidths[l]<FMain.StringGrid1.Canvas.TextWidth(texte2)+32
                                       then FMain.StringGrid1.ColWidths[l]:=FMain.StringGrid1.Canvas.TextWidth(texte2)+32;
                                     //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]:=FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-1,AffRow]+'V'+texte2+'|';
                                   end;
                               end;
                           end;
                         if k1>0 then delete(texte1,1,k1) else texte1:='';
                       until length(texte1)<1;
                       if FMain.StringGrid1.RowCount>1 then FMain.StringGrid1.FixedRows:=1;
                     end;
                 end;  // end of for j:=0 to nb_GroupValue-1 do
               //FMain.rafraichir_diag;
             end;
         end; // end of for i:=0 to ActualKWP.Count-1 do
       FMain.Execution:=True;
       if InIOTimer then Exit;
       FMain.M_Debug.Lines.Add('Temps de repetition : '+inttostr(FMain.TimeRepeat)+' ms');
       if (FMain.TypeAff<>CT_AFFCONFIRM)
          and (FMain.TypeAff<>CT_AFFONEPARAMETER)
          and (FMain.ligneMenu<FMain.ActualMenu.Count) then
          begin
            FMain.T_StatusIO.Interval:=100;
            FMain.T_StatusIO.Enabled:=True;
          end else
          begin
            If (FMain.TimeRepeat>0) and (FMain.TypeAff<>CT_AFFCONFIRM) then
              begin
                FMain.ligneMenu:=0;
                FMain.T_StatusIO.Interval:=FMain.TimeRepeat;
                FMain.T_StatusIO.Enabled:=True;
              end;
          end;
     end;
end;

//******************************************************************************
procedure TFMain.KWP20001Status(Sender: TObject; Messages: string);
var texte : string;
begin
  DateTimeToString(texte,'h:nn.ss.zzz',Now);
  FMain.M_Status.Lines.Add(texte+' - '+Messages);
end;

//******************************************************************************
procedure TFMain.KWP20001Step(Sender: TObject; Messages: string);
var texte : string;
begin
  DateTimeToString(texte,'h:nn.ss.zzz',Now);
  FMain.M_Debug.Lines.Add(texte+' - '+Messages);
  FMain.num_image:=FMain.num_image+1;
  if FMain.num_image>14 then FMain.num_image:=1;
  FMain.I_Attente.Picture.Bitmap:=nil;
  FMain.IList_Rose.GetBitmap(FMain.num_image,FMain.I_Attente.Picture.Bitmap);
end;

//******************************************************************************
procedure TFMain.Menu_QuitterClick(Sender: TObject);
begin
  FMain.Execution:=True;
  FMain.T_StatusIO.Enabled:=False;
  FMain.Close;
end;

//******************************************************************************
procedure TFMain.Menu_SettingClick(Sender: TObject);
begin
  F_Configuration.execute;
end;

//******************************************************************************
procedure TFMain.Panel1Click(Sender: TObject);
begin
  FMain.SaveDialog1.FileName:=repertoire_courant+'Debug.txt';
  FMain.SaveDialog1.Filter:='*.txt';
  if FMain.SaveDialog1.Execute then
     begin
       FMain.M_Debug.Lines.SaveToFile(FMain.SaveDialog1.FileName);
     end;
end;

//******************************************************************************
procedure TFMain.RadioAffVal1ChangeBounds(Sender: TObject);
var texte : string;
    value : integer;
begin
  texte:=FMain.E_Valeur.Text;
  texte:=trim(texte);
  try
    if FMain.RadioAffVal.ItemIndex=0 then
      begin
        value:=hextodec(texte);
        texte:=inttostr(value);
      end else
      begin
        value:=strtoint(texte);
        texte:=dectohex(value);
      end;
    FMain.E_Valeur.Text:=texte;
  except
  end;
end;

//******************************************************************************
procedure TFMain.RadioAffValChangeBounds(Sender: TObject);
var texte : string;
    value : integer;
begin
  texte:=FMain.E_Para.Text;
  texte:=trim(texte);
  try
    if FMain.RadioAffVal.ItemIndex=0 then
      begin
        value:=hextodec(texte);
        texte:=inttostr(value);
      end else
      begin
        value:=strtoint(texte);
        texte:=dectohex(value);
      end;
    FMain.E_Para.Text:=texte;
  except
  end;
end;

//******************************************************************************
procedure TFMain.StringGrid1Click(Sender: TObject);
var aRow,aCol,ligne : integer;
    texte,texte1 : string;
    i,j,k : integer;
    x,y : integer;
    tx,ty : string;
begin
  // Le click permet le mode maitre

  aRow:=FMain.StringGrid1.Row;
  aCol:=FMain.StringGrid1.Col;
  if aRow=0 then exit;
  //ligne:=aRow+FMain.Grille_Up; // traduction de la ligne
  ligne:=aRow;
  if (FMain.ClickActif=False) and (length(FMain.ClickGlobal)>0) then
    begin
      While (FMain.KWP20001.EndReceive=False)
        and (MainExit=False) do Application.ProcessMessages;
      if MainExit then Exit;
      FMain.Cde2Send(FMain.ClickGlobal);
      FMain.Attente_Start;
      FMain.Execution:=False;
      FMain.KWP20001.SendResponse;
      While (not FMain.Execution)
        and (MainExit=False) do application.ProcessMessages;
      if MainExit then Exit;
      FMain.ClickActif:=True;
      FMain.B_Mode_Maitre.Visible:=True;
    end;
  i:=0;
  while i<ClickList.Count do
    begin
      texte:=ClickList.Strings[i];
      if uppercase(copy(texte,1,4))='CLK=' then
        begin
         delete(texte,1,4);
         j:=pos('/',texte);
         if j>0 then
           begin
             texte1:=copy(texte,1,j-1);
             delete(texte,1,j);
             j:=pos(',',texte1);
             if j>0 then
               begin
                 tx:=copy(texte1,1,j-1);
                 delete(texte1,1,j);
                 ty:=texte1;
                 try
                   if length(tx)>0 then x:=strtoint(tx) else x:=-1;
                 except
                   x:=-1;
                 end;
                 try
                   y:=strtoint(ty);
                 except
                   y:=-1;
                 end;
                 if ((y>=0) and (x>=0) and (x=aCol) and (y=ligne))
                   or ((x<0) and (y>=0) and (y=ligne))
                   or ((x>=0) and (y<0) and (x=aCol))
                   or ((x<0) and (y<0)) then
                   begin
                     // on respecte la condition, on execute la traduction de la ligne
                     while length(texte)>0 do
                       begin
                         j:=pos('/',texte);
                         if j>0 then
                           begin
                             texte1:=copy(texte,1,j-1);
                             delete(texte,1,j);
                           end else
                           begin
                             texte1:=texte;
                             texte:='';
                           end;
                         if uppercase(texte1)='ONOFF' then
                           begin
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FOnOff.Cde_Exit:=''
                                       else FOnOff.Cde_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,3)='ON=' then
                                   begin
                                     delete(texte1,1,3);
                                     FOnOff.Cde_ON:=texte1;
                                   end else
                                 if copy(texte1,1,4)='OFF=' then
                                   begin
                                     delete(texte1,1,4);
                                     FOnOff.Cde_OFF:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FOnOff.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FOnOff.L_Pin.Caption:=texte1;
                                   end;
                               end; // end of while length(texte)>0 do
                             // we have configure the window
                             FOnOff.Enable_Screen;
                             FOnOff.Actif:=True;
                             FOnOff.Show;
                           end else // end of if uppercase(texte1)='ONOFF' then
                         if uppercase(texte1)='PWM' then
                           begin
                             //CLK=,41/PWM/EXIT=GLOBAL/NAME=Commande dynamique en frequence/TITLE=OUT 4 - CN 5.24/MODE=FREQ/TYPE=16L/CDE=30 04 00 VALUE 00;
                             FPWM.diviseur:=1;
                             FPWM.Pas:=1;
                             FPWM.sens_octet:=CT_SensHL;
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FPWM.Cde_PWM_Exit:=''
                                       else FPWM.Cde_PWM_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,5)='TYPE=' then
                                   begin
                                     delete(texte1,1,5);
                                     if pos('L',texte1)>0 then
                                       begin
                                         FPWM.sens_octet:=CT_SensLH;
                                         delete(texte1,pos('L',texte1),1);
                                       end else
                                     if pos('H',texte1)>0 then
                                       begin
                                         delete(texte1,pos('H',texte1),1);
                                       end;
                                     try
                                       FPWM.lg_data:=strtoint(texte1);
                                     except
                                       FPWM.lg_data:=8;
                                     end;
                                   end else
                                 if copy(texte1,1,4)='CDE=' then
                                   begin
                                     delete(texte1,1,4);
                                     FPWM.Cde_PWM:=texte1;
                                   end else
                                 if copy(texte1,1,4)='DIV=' then
                                   begin
                                     delete(texte1,1,4);
                                     FPWM.diviseur:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,4)='PAS=' then
                                   begin
                                     delete(texte1,1,4);
                                     FPWM.Pas:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,5)='UNIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     FPWM.Unite:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FPWM.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FPWM.L_Pin.Caption:=texte1;
                                   end;
                               end;
                             FPWM.Calcul_Min_Max;
                             FPWM.Actif:=True;
                             FPWM.Enable_Screen;
                             FPWM.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FPWM.Show;
                           end else  // end of if uppercase(texte1)='PWM' then
                         if uppercase(texte1)='BRIDGE' then
                           begin
                             // CLK=,76/BRIDGE/EXIT=GLOBAL/NAME=Commande du Bridge n°3/TITLE=OUT 13 & 14/STOP=00/SENS1=01/SENS2=02/DIV=50/TYPE=8/UNIT=Hz/PAS=50/CDE=30 11 EXV SENS VALUE;
                             FBridge.diviseur:=1;
                             FBridge.Pas:=1;
                             FBridge.sens_octet:=CT_SensHL;
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FBridge.Cde_Exit:=''
                                       else FBridge.Cde_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,5)='TYPE=' then
                                   begin
                                     delete(texte1,1,5);
                                     if pos('L',texte1)>0 then
                                       begin
                                         FBridge.sens_octet:=CT_SensLH;
                                         delete(texte1,pos('L',texte1),1);
                                       end else
                                     if pos('H',texte1)>0 then
                                       begin
                                         delete(texte1,pos('H',texte1),1);
                                       end;
                                     try
                                       FBridge.lg_data:=strtoint(texte1);
                                     except
                                       FBridge.lg_data:=8;
                                     end;
                                   end else
                                 if copy(texte1,1,4)='CDE=' then
                                   begin
                                     delete(texte1,1,4);
                                     FBridge.Cde_PWM:=texte1;
                                   end else
                                 if copy(texte1,1,5)='STOP=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBridge.Cde_Stop:=texte1;
                                   end else
                                 if copy(texte1,1,6)='SENS1=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBridge.Cde_Sens1:=texte1;
                                   end else
                                 if copy(texte1,1,6)='SENS2=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBridge.Cde_Sens2:=texte1;
                                   end else
                                 if copy(texte1,1,4)='DIV=' then
                                   begin
                                     delete(texte1,1,4);
                                     FBridge.diviseur:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,4)='PAS=' then
                                   begin
                                     delete(texte1,1,4);
                                     FBridge.Pas:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,5)='UNIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBridge.Label_Unite:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBridge.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBridge.L_Pin.Caption:=texte1;
                                   end;
                               end;
                             FBridge.Calcul_Mini_Maxi;
                             FBridge.Actif:=True;
                             FBridge.Enable_Screen;
                             FBridge.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FBridge.Show;
                           end else  // end of if uppercase(texte1)='BRIDGE' then
                         if uppercase(texte1)='WIPER' then
                           begin
                              while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FWiper.Cde_Wiper_Exit:=''
                                       else FWiper.Cde_Wiper_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,3)='STOP=' then
                                   begin
                                     delete(texte1,1,3);
                                     FWiper.Cde_Wiper_Stop:=texte1;
                                   end else
                                 if copy(texte1,1,4)='SLOW=' then
                                   begin
                                     delete(texte1,1,4);
                                     FWiper.Cde_Wiper_Slow:=texte1;
                                   end else
                                 if copy(texte1,1,4)='FAST=' then
                                   begin
                                     delete(texte1,1,4);
                                     FWiper.Cde_Wiper_Fast:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FWiper.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FWiper.L_Pin.Caption:=texte1;
                                   end;
                               end;
                             FWiper.Actif:=True;
                             FWiper.Enable_Screen;
                             FWiper.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FWiper.Show;
                           end else  // end of if uppercase(texte1)='WIPER' then
                         if uppercase(texte1)='BIPWM' then
                           begin
                             FBiPWM.diviseur_1:=1;
                             FBiPWM.Pas_1:=1;
                             FBiPWM.diviseur_2:=1;
                             FBiPWM.Pas_2:=1;
                             FBiPWM.sens_octet1:=CT_SensHL;
                             FBiPWM.sens_octet2:=CT_SensHL;
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FBiPWM.Cde_Exit:=''
                                       else FBiPWM.Cde_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TYPE1=' then
                                   begin
                                     delete(texte1,1,6);
                                     if pos('L',texte1)>0 then
                                       begin
                                         FBiPWM.sens_octet1:=CT_SensLH;
                                         delete(texte1,pos('L',texte1),1);
                                       end else
                                     if pos('H',texte1)>0 then
                                       begin
                                         delete(texte1,pos('H',texte1),1);
                                       end;
                                     try
                                       FBiPWM.lg_data_1:=strtoint(texte1);
                                     except
                                       FBiPWM.lg_data_1:=8;
                                     end;
                                   end else
                                 if copy(texte1,1,6)='TYPE2=' then
                                   begin
                                     delete(texte1,1,6);
                                     if pos('L',texte1)>0 then
                                       begin
                                         FBiPWM.sens_octet2:=CT_SensLH;
                                         delete(texte1,pos('L',texte1),1);
                                       end else
                                     if pos('H',texte1)>0 then
                                       begin
                                         delete(texte1,pos('H',texte1),1);
                                       end;
                                     try
                                       FBiPWM.lg_data_2:=strtoint(texte1);
                                     except
                                       FBiPWM.lg_data_2:=8;
                                     end;
                                   end else
                                 if copy(texte1,1,4)='CDE=' then
                                   begin
                                     delete(texte1,1,4);
                                     FBiPWM.Cde_BiPWM:=texte1;
                                   end else
                                 if copy(texte1,1,5)='DIV1=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBiPWM.diviseur_1:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,5)='DIV2=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBiPWM.diviseur_2:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,5)='PAS1=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBiPWM.Pas_1:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,6)='UNIT1=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBiPWM.Label_Unit1:=texte1;
                                   end else
                                 if copy(texte1,1,5)='PAS2=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBiPWM.Pas_2:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,6)='UNIT2=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBiPWM.Label_Unit2:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FBiPWM.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FBiPWM.L_Pin.Caption:=texte1;
                                   end;
                               end;
                             FBiPWM.Calcul_Min_Max;
                             FBiPWM.Actif:=True;
                             FBiPWM.Enable_Screen;
                             FBiPWM.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FBiPWM.Show;
                           end else // end of if uppercase(texte1)='BIPWM' then
                         if uppercase(texte1)='VALUE' then
                           begin
                             FValue.Cde_Exit:='';
                             FValue.Cde_Send:='';
                             FValue.E_Value.Text:='';
                             FValue.diviseur:=1;
                             FValue.sens_octet:=CT_SensHL;
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 // VALUE/EXIT=GLOBAL/TYPE=8/NAME=Valeur/TITLE=xxx/DIV=1/CDE=21 40 VAL 00
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FValue.Cde_Exit:=''
                                       else FValue.Cde_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,5)='TYPE=' then
                                   begin
                                     delete(texte1,1,5);
                                     if pos('L',texte1)>0 then
                                       begin
                                         FValue.sens_octet:=CT_SensLH;
                                         delete(texte1,pos('L',texte1),1);
                                       end else
                                     if pos('H',texte1)>0 then
                                       begin
                                         delete(texte1,pos('H',texte1),1);
                                       end;
                                     try
                                       FValue.lg_data:=strtoint(texte1);
                                     except
                                       FValue.lg_data:=8;
                                     end;
                                   end else
                                 if copy(texte1,1,4)='CDE=' then
                                   begin
                                     delete(texte1,1,4);
                                     FValue.Cde_Send:=texte1;
                                   end else
                                 if copy(texte1,1,4)='DIV=' then
                                   begin
                                     delete(texte1,1,4);
                                     FValue.diviseur:=strtoreel(texte1);
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FValue.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FValue.L_Pin.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,5)='CASE=' then
                                   begin
                                     delete(texte1,1,5);
                                     j:=pos(',',texte1);
                                     try
                                       FValue.ColGrid:=strtoint(copy(texte1,1,j-1));
                                     except
                                       FValue.ColGrid:=-1;
                                     end;
                                     delete(texte1,1,j);
                                     try
                                       FValue.RowGrid:=strtoint(texte1);
                                     except
                                       FValue.RowGrid:=-1;
                                     end;
                                     if (FValue.ColGrid>-1)and (FValue.RowGrid>-1) then
                                       begin
                                         FValue.E_Value.Text:=FMain.StringGrid1.Cells[FValue.ColGrid,FValue.RowGrid];
                                       end;
                                     FValue.L_Pin.Caption:=texte1;
                                   end;
                               end;

                             FValue.Actif:=True;
                             FValue.Enable_Screen;
                             FValue.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FValue.Show;
                           end else; // end of if uppercase(texte1)='VALUE' then
                         if uppercase(texte1)='LIST' then
                           begin
                             FLIST.Cde_Exit:='';
                             FList.Cde_Send:='';
                             FList.E_Value.Text:='';
                             while length(texte)>0 do
                               begin
                                 j:=pos('/',texte);
                                 if j>0 then
                                   begin
                                     texte1:=copy(texte,1,j-1);
                                     delete(texte,1,j);
                                   end else
                                   begin
                                     texte1:=texte;
                                     texte:='';
                                   end;
                                 // CLK=,1/LIST/EXIT=/CASE=1,2-9/NAME=Ecriture de la date et de l'heure/
                                 // TITLE=Date et heure/COR=0.25|0:1|0:1|0:1|0:0.25|0:1|0:1|0:1|0/
                                 // TYPE=8:8:8:8:8:8:8/CDE=2E F9 0B VALUE;
                                 if copy(texte1,1,5)='EXIT=' then
                                   begin
                                     delete(texte1,1,5);
                                     if uppercase(texte1)='GLOBAL'
                                       then FList.Cde_Exit:=''
                                       else FList.Cde_Exit:=texte1;
                                   end else
                                 if copy(texte1,1,5)='TYPE=' then
                                   begin
                                     delete(texte1,1,5);
                                     FList.type_value:=texte1;
                                   end else
                                 if copy(texte1,1,4)='CDE=' then
                                   begin
                                     delete(texte1,1,4);
                                     FList.Cde_Send:=texte1;
                                   end else
                                 if copy(texte1,1,4)='COR=' then
                                   begin
                                     delete(texte1,1,4);
                                     FList.correction:=texte1;
                                   end else
                                 if copy(texte1,1,5)='NAME=' then
                                   begin
                                     delete(texte1,1,5);
                                     FList.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,6)='TITLE=' then
                                   begin
                                     delete(texte1,1,6);
                                     FList.L_Pin.Caption:=texte1;
                                   end else
                                 if copy(texte1,1,5)='CASE=' then
                                   begin
                                     delete(texte1,1,5);
                                     FList.CaseToInteger(texte1,FList.ListColMin,FList.ListColMax,Flist.ListRowMin,FList.ListRowMax);
                                     FList.StringGrid1.ColCount:=FMain.StringGrid1.ColCount;
                                     j:=FList.ListRowMax-FList.ListRowMin+2;
                                     FList.StringGrid1.RowCount:=j;
                                     for j:=0 to FList.StringGrid1.ColCount-1 do
                                       FList.StringGrid1.Cells[j,0]:=FMain.StringGrid1.Cells[j,0];
                                     for j:=0 to FList.StringGrid1.ColCount-1 do
                                       for k:=FList.ListRowMin to FList.ListRowMax do
                                         begin
                                           FList.StringGrid1.Cells[j,k-FList.ListRowMin+1]:=FMain.StringGrid1.Cells[j,k];
                                         end;
                                   end;
                               end;

                             FList.Actif:=True;
                             FList.Enable_Screen;
                             FList.B_Fermer.Caption:=MenuProg[CMP_Close];
                             FList.Show;
                           end; // end of if uppercase(texte1)='LIST' then
                       end; // end of while length(texte)>0 do

                   end; // end of if ((y>=0) and (x>=0) and (x=aCol) and (y=ligne))
               end; // end of  if j>0 then
           end;  // end of if j>0 then
        end; // end of if uppercase(copy(texte,1,4))='CLK=' then
      i:=i+1;
    end; // end of while i<ClickList.Count do
end;

//******************************************************************************
procedure TFMain.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var d : integer;
    couleur : TColor;
    bRect : TRect;
    texte : string;
begin
  if FMain.ClickTree then exit;
  if aRow>0 then
    begin
      try
        if length(FMain.ColorList.Strings[aRow])>0
           then couleur:=hextodec(FMain.ColorList.Strings[aRow])
           else couleur:=clWhite;
      except
        couleur:=clWhite;
      end;
    end else couleur:=clSkyBlue;
  FMain.StringGrid1.Canvas.Brush.Color:=couleur;
  FMain.StringGrid1.Canvas.FillRect(aRect);
  if aRow=0 then
    begin
      FMain.StringGrid1.Canvas.Font.Color:=clBlack;
      FMain.StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,FMain.StringGrid1.Cells[aCol,aRow]);
      exit; // on sort si l'affichage concerne les cases de titre
    end;
  d:=(FMain.StringGrid1.RowHeights[aRow]-13) div 2;
  bRect.Top:=aRect.Top+d;
  bRect.Bottom:=bRect.Top+13;
  d:=(FMain.StringGrid1.ColWidths[aCol]-13)div 2;
  bRect.Left:=aRect.Left+d;
  bRect.Right:=bRect.Left+13;
  texte:=FMain.StringGrid1.Cells[aCol,aRow];
  if copy(texte,1,4)='IMG_' then
    begin
      delete(texte,1,4);
      if copy(texte,1,3)='RED' then
        begin
          if copy(texte,4,1)='1' then
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledrougeon);
            end else
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledrougeoff);
            end;
        end else
      if copy(texte,1,3)='AMB' then
        begin
          if copy(texte,6,1)='1' then
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledamberon);
            end else
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledamberoff);
            end;
        end else
      if copy(texte,1,3)='GRE' then
        begin
          if copy(texte,6,1)='1' then
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledverteon);
              //FMain.StringGrid1.Canvas.Brush.Color:=couleur;
              //FMain.StringGrid1.Canvas.FillRect(aRect);
            end else
            begin
              FMain.StringGrid1.Canvas.Draw(bRect.Left,bRect.Top,ledverteoff);
              //FMain.StringGrid1.Canvas.Brush.Color:=clGreen;
              //FMain.StringGrid1.Canvas.FillRect(aRect);
            end;
        end;
    end else
    begin
      FMain.StringGrid1.Canvas.Font.Color:=clBlack;
      FMain.StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,FMain.StringGrid1.Cells[aCol,aRow]);
    end;

end;

//******************************************************************************
procedure TFMain.StringGrid1Resize(Sender: TObject);
begin
  //FMain.rafraichir_diag;
end;

//******************************************************************************
procedure TFMain.T_AttenteTimer(Sender: TObject);
begin
  FMain.num_image:=FMain.num_image+1;
  if FMain.num_image>14 then FMain.num_image:=1;
  FMain.I_Attente.Picture.Bitmap:=nil;
  FMain.IList_Rose.GetBitmap(FMain.num_image,FMain.I_Attente.Picture.Bitmap);
end;

procedure TFMain.T_CommandTimer(Sender: TObject);
var texte,texte1 : string;
    liste_connection : TStringList;
    ListCommand : TStringList;
    cond : string; // condition to repeat a command
    cde : string; // command to send
    i,j,k,l,m,n : integer;
    outdoor : boolean;
    byteRule: string;
    DebutByte,FinByte,DebutBit,FinBit : integer;
    valeur,val_cond : integer;
    f_Byte,f_Bit : string;
    mask : byte;
    n_ligne,max_val,min_val : integer;
    Noeud : TTreeNode;
begin
  // Recherche de toutes les commandes à executer juste après la connection
  FMain.T_Command.Enabled:=False;
  try
    liste_Connection:=TStringlist.Create;
    ListCommand:=TStringList.Create;
    FMain.Search_Item('CONNECTION',FMain.Vehicule,Liste_Connection);
    //Liste_Connection.SaveToFile('c:\Connection.txt');
    i:=0;
    FMain.TypeAff:=-1;
    while i<Liste_Connection.Count do
      begin
        Application.ProcessMessages;
        if MainExit then exit;
        texte:=Liste_Connection.Strings[i];
	      if uppercase(copy(texte,1,9))='<COMMAND>' then
	        begin
            ListCommand.Clear;
            while (texte<>'</COMMAND>') and (i<Liste_Connection.Count)do
              begin
                texte:=Liste_Connection.Strings[i];
                texte:=trim(texte);
                ListCommand.Add(texte);
                if texte<>'</COMMAND>' then i:=i+1;
              end;
            //ListCommand.SaveToFile('c:\Command'+inttostr(i)+'.txt');
            // on a récupéré tout le champ COMMAND
            // on va donc executer la commande
            j:=0;
            while j<ListCommand.Count do
              begin
                Application.ProcessMessages;
                if MainExit then exit;
                texte:=trim(ListCommand.Strings[j]);
                if copy(texte,1,5)='COND=' then
                  begin
                    delete(texte,1,5);
                    cond:=texte;
                  end else
                if copy(texte,1,5)='<KWP>' then
                  begin
                    FMain.ActualKWP.Clear;
                    cde:='';
                    while j<ListCommand.Count do
                      begin
                        texte:=trim(ListCommand.Strings[j]);
                        if copy(texte,1,2)<>'</' then FMain.ActualKWP.Add(texte);
                        if copy(texte,1,4)='CDE=' then cde:=texte;
                        if copy(texte,1,2)='</' then j:=ListCommand.Count;
                        j:=j+1;
                      end;
                  end;
                j:=j+1;
              end; // end of while j<ListCommand.Count do
          end;  // end of if uppercase(copy(texte,1,9))='<COMMAND>' then
        if length(cde)>0 then
          begin
            delete(cde,1,4);
            FMain.KWP20001.Sid:=hextodec(copy(cde,1,2));
            delete(cde,1,3);
            j:=0;
            while length(cde)>0 do
              begin
                Application.ProcessMessages;
                if MainExit then Exit;
                FMain.KWP20001.FData[j]:=hextodec(copy(cde,1,2));
                delete(cde,1,3);
                j:=j+1;
              end;
            FMain.KWP20001.SendLength:=j;
            if length(cond)>0 then
              begin
                outdoor:=false;
                // calcul du filtre sur les données
                j:=pos('/',cond);
                    ByteRule:=copy(cond,1,j-1);
                    delete(cond,1,j);
                    // on supprime les crochets du filtre
                    j:=pos('[',ByteRule);
                    if j>0 then delete(ByteRule,1,j);
                    j:=pos(']',ByteRule);
                    if j>0 then delete(ByteRule,j,1);
                    j:=pos('|',ByteRule);
                    // On sépare les filtres des octets et les filtres en fonction des bits
                    if j>0 then
                     begin
                       f_Byte:=copy(ByteRule,1,j-1);
                       delete(ByteRule,1,j);
                       f_bit:=ByteRule;
                     end else
                     begin
                       f_Byte:=ByteRule;
                       f_bit:='';
                     end;
                    j:=pos('-',f_Byte);
                    if j>0 then
                      begin
                        texte1:=copy(f_Byte,1,j-1);
                        try
                          DebutByte:=Strtoint(texte1);
                        except
                          DebutByte:=0;
                        end;
                        delete(f_byte,1,j);
                        try
                          FinByte:=Strtoint(f_Byte);
                        except
                          FinByte:=0;
                        end;
                      end else
                      begin
                        try
                          DebutByte:=Strtoint(f_Byte);
                        except
                          DebutByte:=0;
                        end;
                        FinByte:=DebutByte;
                      end;
                    // récupération de la plage de bit demandée
                    if length(f_bit)>0 then  // on a un filtre sur les bits
                     begin
                       j:=pos('-',f_Bit);
                       if j>0 then  // on a une plage
                         begin
                           texte1:=copy(f_Bit,1,j-1);
                           try
                             DebutBit:=Strtoint(texte1);
                           except
                             DebutBit:=0;
                           end;
                           delete(f_bit,1,j);
                           try
                             FinBit:=Strtoint(f_Bit);
                           except
                             FinBit:=0;
                           end;
                         end else
                         begin   //Il n'y a pas de plage
                           try
                             DebutBit:=Strtoint(f_Bit);
                           except
                             DebutBit:=0;
                           end;
                           FinBit:=DebutBit;
                         end;
                       // creation du masque de récupération
                       mask:=0;
                       for j:=DebutBit to FinBit do
                         mask:=mask or (1 shl j);
                     end else mask:=$FF;
                    texte:=cond;
                    delete(texte,1,1);
                    try
                      val_cond:=strtoint(texte);
                    except
                      outdoor:=true;
                    end;
                    // execution à répétition
                    beginExit:=false;
                    While (outdoor=False) and (BeginExit=False) do
                  begin
                    Application.ProcessMessages;
                    if MainExit then Exit;
                    FMain.KWP20001.SendResponse;
                    FMain.Attente_Start;
                    Execution:=False;
                    While (Execution=False)
                      and (MainExit=False) do Application.ProcessMessages;
                    if MainExit then Exit;
                    // détermination du filtre sur les octets
                    valeur:=0;
                    for j:=DebutByte to FinByte do
                      begin
                        valeur:=valeur*256+(FMain.KWP20001.TrameRx[j] and mask);
                      end;
                    if copy(cond,1,1)='=' then
                      begin
                        if valeur=val_cond then outdoor:=true;
                      end else
                    if copy(cond,1,1)='>' then
                      begin
                        if valeur>val_cond then outdoor:=True;
                      end else
                    if copy(cond,1,1)='<' then
                      begin
                        if valeur<val_cond then outdoor:=True;
                      end else outdoor:=True; // there is an error in the cond statement
                      
                  end;
              end else
              begin
                FMain.KWP20001.SendResponse;
                FMain.Attente_Start;
                Execution:=False;
                While (Execution=False)
                  and (MainExit=False)do Application.ProcessMessages;
                if MainExit then Exit;
              end;
          end;
        i:=i+1;
      end; // end of  while i<ListConnection.Count do
  finally
    liste_Connection.Free;
    ListCommand.Free;
  end;
  // Traitement des menus
  i:=0;
  while i<Vehicule.Count do
    begin
      Application.ProcessMessages;
      if MainExit then Exit;
      texte:=Vehicule.Strings[i];
      trim(texte);
      if uppercase(copy(texte,1,4))='ICO=' then
        begin
          //noeud:=FMain.TreeView1.Items.GetFirstNode;
          if noeud<>nil then
            begin
              delete(texte,1,4);
              j:=pos(';',texte);
              try
                j:=strtoint(copy(texte,1,j-1));
              except
                j:=-1;
              end;
              noeud.ImageIndex:=j;
            end;
        end else
      if uppercase(copy(texte,1,8))='<EXMENU=' then
        begin
          DebutByte:=i;
          FMain.ExtendedMenu.Clear;
          delete(texte,2,2);
          FMain.ExtendedMenu.Add(texte);
          // on récupére le menu étendu à répéter
          outdoor:=False;
          i:=i+1;
          while outdoor=False do
            begin
              Application.ProcessMessages;
              if MainExit then Exit;
              if i<Vehicule.Count then texte:=Vehicule.Strings[i];
              trim(texte);
              if (i>=Vehicule.Count)
                or (uppercase(copy(texte,1,8))='<EXMENU=')
                or (uppercase(copy(texte,1,8))='</EXMENU')
                or (uppercase(copy(texte,1,6))='<MENU=') then outdoor:=True;
              if not outdoor then
                begin
                  if (length(texte)>0)
                    and (copy(texte,1,2)<>'//') then
                    begin
                      k:=pos(';',texte);
                      if k=0 then FMain.ExtendedMenu.Add(texte) else FMain.ExtendedMenu.Add(copy(texte,1,k));
                    end;
                  i:=i+1;
                end else FinByte:=i;
            end;
          //FMain.ExtendedMenu.SaveToFile('c:\ExtendedMenu.txt');
          // Traitement de l'extended menu
          // on efface l'extended menu du fichier vehicule
          for j:=DebutByte to FinByte do
            begin
              FMain.Vehicule.Delete(DebutByte);
            end;
          // on doit récupérer la condition de répétition val_cond
          j:=0;
          while j<FMain.ExtendedMenu.Count do
            begin
              Application.ProcessMessages;
              if MainExit then Exit;
              texte:=FMain.ExtendedMenu.Strings[j];
              if copy(texte,1,9)='EXREPEAT=' then
                begin
                  delete(texte,1,9);
                  k:=pos(';',texte);
                  if k>0 then texte:=copy(texte,1,k-1);
                  texte:=trim(texte);
                  try
                    val_cond:=strtoint(texte);   // n° de la variable de répétition
                  except
                    val_cond:=-1;
                  end;
                  FMain.ExtendedMenu.Delete(j); // On efface cette consigne
                  j:=FMain.ExtendedMenu.Count;
                end;
              j:=j+1;
            end;
          if copy(FMain.ExtendedMenu.Strings[FMain.ExtendedMenu.Count-1],1,7)<>'</MENU>'
             then FMain.ExtendedMenu.Add('</MENU>');
          // On commence l'intégration des menus dans le fichier vehicule en mémoire
          if (val_cond>-1) and (FMain.Variable[Val_cond]>0) then
            begin
              l:=0;
              n_ligne:=0;
              max_val:=0;
              min_val:=10000;
              m:=-1;
              for j:=1 to FMain.Variable[Val_cond] do
                begin
                  for k:=0 to FMain.ExtendedMenu.Count-1 do
                    begin
                      Application.ProcessMessages;
                      if MainExit then Exit;
                      texte:=FMain.ExtendedMenu.Strings[k];
                      if copy(texte,1,4)='<MEN' then
                        begin
                          debutBit:=pos('>',texte);
                          if debutBit>0 then texte:=copy(texte,1,debutbit-1);
                          texte:=texte+' '+inttostr(j)+'>';
                        end else
                      if copy(texte,1,4)='CLK=' then
                        begin
                          m:=pos('EXV',texte);
                          texte1:=dectohex(j);
                          while m>0 do
                            begin
                              texte:=copy(texte,1,m-1)+texte1+copy(texte,m+3,length(texte)-3);
                              m:=pos('EXV',texte);
                            end;
                        end else
                      if copy(texte,1,4)='CDE=' then
                        begin
                          debutBit:=pos(';',texte);
                          if debutBit>0 then texte:=copy(texte,1,debutbit-1);
                          texte:=texte+' '+dectohex(j)+';';
                        end else
                      if copy(texte,1,3)='LG=' then
                        begin
                          debutbit:=pos('TAB[',texte);
                          if debutbit>0 then
                            begin
                              cond:=copy(texte,1,debutbit+3);
                              delete(texte,1,debutbit+3);
                              debutbit:=pos(',',texte);
                              cond:=cond+copy(texte,1,debutbit);
                              delete(texte,1,debutbit);
                              debutbit:=pos(']',texte);
                              valeur:=strtoint(copy(texte,1,debutbit-1));
                              delete(texte,1,debutbit-1);
                              if max_val<valeur then max_val:=valeur;
                              if min_val>valeur then min_val:=valeur;
                              valeur:=valeur+n_ligne;
                              texte:=cond+inttostr(valeur)+texte;
                            end;
                        end else
                      if copy(texte,1,3)='TR=' then
                        begin
                          debutbit:=pos('TAB[',texte);
                          if debutbit>0 then
                            begin
                              cond:=copy(texte,1,debutbit+3);
                              delete(texte,1,debutbit+3);
                              debutbit:=pos(',',texte);
                              cond:=cond+copy(texte,1,debutbit);
                              delete(texte,1,debutbit);
                              debutbit:=pos(']',texte);
                              valeur:=strtoint(copy(texte,1,debutbit-1));
                              delete(texte,1,debutbit-1);
                              if max_val<valeur then max_val:=valeur;
                              if min_val>valeur then min_val:=valeur;
                              valeur:=valeur+n_ligne;
                              texte:=cond+inttostr(valeur)+texte;
                            end;
                        end;
                      FMain.Vehicule.Insert(DebutByte+k+((j-1)*FMain.ExtendedMenu.Count),texte);
                    end;
                  // calcul de l
                  // n_ligne => 1e texte du tableau
                  // valeur => dernière valeur lu
                  n_ligne:=n_ligne+(max_val-min_val)+1;
                end;
            end;
          // ON a fini l'intégration, on remet le curseur i au début de cette zone ajoutée
          i:=DebutByte-1;
	end else
      if uppercase(copy(texte,1,6))='<MENU=' then
        begin
	  delete(texte,1,6);
	  j:=pos('>',texte);
	  if j>0 then
	    begin
	      MenuList.Add(copy(texte,1,j-1)+'/'+inttostr(i)+'/');
	      noeud:=FMain.TreeView1.Items.Add(nil,copy(texte,1,j-1));
	    end;
	end else
      if uppercase(copy(texte,1,6))='</MENU' then
        begin
	  delete(texte,1,6);
	  if MenuList.Count>0 then MenuList.Strings[MenuList.Count-1]:=MenuList.Strings[MenuList.Count-1]+inttostr(i)+'/';
	end ;
    i:=i+1;
  end;
  //FMain.TreeView1.Enabled:=True;
  FMain.Vehicule.SaveToFile('C:\vehicule.txt');
  FMain.TreeView1.Enabled:=True;
end;

//******************************************************************************
// This timer is used to execute all KWP2000 Cde of the actual menu if there is a
// repeat condition, this timer is execute other time
//******************************************************************************
procedure TFMain.T_StatusIOTimer(Sender: TObject);
var i,j : integer;
    texte : string;
    outdoor : boolean;
begin
  InIOTimer:=True;
  FMain.T_StatusIO.Enabled:=False;
  i:=FMain.ligneMenu;
  texte:='';
  if length(FOnOff.Buffer)>0 then
    begin
      texte:=FOnOff.Buffer;
      FOnOff.Buffer:='';
    end else
  if length(FbiPWM.Buffer)>0 then
    begin
      texte:=FBiPWM.Buffer;
      FBiPWM.Buffer:='';
    end else
  if length(FPwm.Buffer)>0 then
    begin
      texte:=FPWM.Buffer;
      FPWM.Buffer:='';
    end else
  if length(FBridge.Buffer)>0 then
    begin
      texte:=FBridge.Buffer;
      FBridge.Buffer:='';
    end else
  if length(Fvalue.Buffer)>0 then
    begin
      texte:=FValue.Buffer;
      FValue.Buffer:='';
      if texte='#' then
        begin
          // On relance une demande de lecture
          FMain.TreeView1Click(nil);
          exit;
        end;
    end else
  if length(FList.Buffer)>0 then
    begin
      texte:=FList.Buffer;
      FList.Buffer:='';
      if texte='#' then
        begin
          // On relance une demande de lecture
          FMain.TreeView1Click(nil);
          exit;
        end;
    end else
  if length(Fwiper.Buffer)>0 then
    begin
      texte:=FWiper.Buffer;
      FWiper.Buffer:='';
    end;
  // if user had click on a button
  if length(texte)>0 then
    begin
      While (FMain.KWP20001.EndReceive=False) and (MainExit=False) do Application.ProcessMessages;
      if MainExit then Exit;
      FMain.Cde2Send(texte);
      FMain.Attente_Start;
      FMain.Execution:=False;
      //while FMain.Execution= false do Application.ProcessMessages;
      FMain.NoReceive:=True;
      FMain.KWP20001.SendResponse;
      FOnOff.Buffer:='';
      if (i<FMain.ActualMenu.Count) or
         ((FMain.TimeRepeat>0) and (FMain.TypeAff<>CT_AFFCONFIRM)) then
        begin
          FMain.T_StatusIO.Interval:=100;
          FMain.T_StatusIO.Enabled:=True;
        end;
      InIoTimer:=False;
      exit;
    end;
  // we extract the current KWP2000 command
  outdoor:=False;
  FMain.ActualKWP.Clear;
  if (i<FMain.ActualMenu.Count) then
    begin

      // On extrait une commande KWP
      While (i<FMain.ActualMenu.Count) and (OutDoor=False) do
        begin
          Application.ProcessMessages;
          if MainExit then Exit;
          texte:=trim(FMain.ActualMenu.Strings[i]);
          if uppercase(copy(texte,1,5))='<KWP>' then
            begin
              i:=i+1;
              while (i<FMain.ActualMenu.Count) and (outdoor=False) do
                begin
                  texte:=trim(FMain.ActualMenu.Strings[i]);
                  if uppercase(texte)<>'</KWP>' then
                    begin
                      ActualKWP.Add(texte);
                      i:=i+1;
                    end else outdoor:=TRUE;
                end;
            end;
          i:=i+1;
        end;
      if outdoor=False then
        begin
          If (FMain.TimeRepeat>0) and (FMain.TypeAff<>CT_AFFCONFIRM) then
            begin
              FMain.ligneMenu:=0;
              //i:=0;
              FMain.T_StatusIO.Interval:=FMain.TimeRepeat;
              FMain.T_StatusIO.Enabled:=True;
              {
              While (i<FMain.ActualMenu.Count) and (OutDoor=False) do
                begin
                  Application.ProcessMessages;
                  texte:=trim(FMain.ActualMenu.Strings[i]);
                  if uppercase(copy(texte,1,5))='<KWP>' then
                    begin
                      i:=i+1;
                      while (i<FMain.ActualMenu.Count) and (outdoor=False) do
                        begin
                          texte:=trim(FMain.ActualMenu.Strings[i]);
                          if uppercase(texte)<>'</KWP>' then
                            begin
                              ActualKWP.Add(texte);
                              i:=i+1;
                            end else outdoor:=TRUE;
                        end;
                    end;
                  i:=i+1;
              end;
              }
            end;
          InIOTimer:=False;
          exit;
        end;
      //FMain.ActualKWP.SaveToFile('c:\ActualKWP'+inttostr(i)+'.txt');
      // On a remplit les traduction KWP
      // On recherche la commande à envoyer
      outdoor:=False;
      j:=0;
      while (j<FMain.ActualKWP.Count) and (outdoor=False) do
        begin
          texte:=FMain.ActualKWP.Strings[j];
          if uppercase(copy(texte,1,4))='CDE=' then
            begin
              outdoor:=True;
            end;
          j:=j+1;
        end;
      // On execute la commande
      delete(texte,1,4);
      texte:=trim(texte);
      while (FMain.Execution= false) and (MainExit=False) do Application.ProcessMessages;
      if MainExit then Exit;
      FMain.KWP20001.SendLength:=0;
      if FMain.TypeAff=CT_AFFCONFIRM then
        begin
          if MessageDlg(FMain.TitleMenu,mtConfirmation, [mbYes, mbNo],0)= mrYes then
            begin
              if length(texte)>0 then
                begin
                  FMain.Cde2Send(texte);
                end;
              FMain.Attente_Start;
              FMain.Execution:=False;
              //while FMain.Execution= false do Application.ProcessMessages;
              FMain.KWP20001.SendResponse;
            end;
          InIOTimer:=False;
          exit;
        end else
      if FMain.TypeAff=CT_AFFONEPARAMETER then
        begin
          InIOTimer:=False;
          exit;
        end;
      if length(texte)>0 then
        begin
          FMain.Cde2Send(texte);
          FMain.Attente_Start;
          FMain.Execution:=False;
          //while FMain.Execution= false do Application.ProcessMessages;
          FMain.KWP20001.SendResponse;
        end;
      FMain.ligneMenu:=i;

      //FMain.T_StatusIO.Enabled:=True;
    end else
    begin
      If (FMain.TimeRepeat>0) and (FMain.TypeAff<>CT_AFFCONFIRM) then
        begin
          FMain.ligneMenu:=0;
          FMain.T_StatusIO.Interval:=FMain.TimeRepeat;
          FMain.T_StatusIO.Enabled:=True;
        end;
    end;
  InIOTimer:=False;
end;

//******************************************************************************
procedure TFMain.TreeView1Click(Sender: TObject);
var texte,texte1 : string;
    i,j,k,l,m,n : integer;
    ligne : integer;
begin
  if FMain.TreeView1.Selected=nil then exit;
  //if FMain.Menu_Connection.Caption<>menuprog[CMP_Deconnecter] then exit;
  FMain.T_StatusIO.Enabled:=False; // stop the engine of KWP command
  texte:=FMain.TreeView1.Selected.Text;
  MenuName:=texte;
  MenuI:=FMain.TreeView1.Selected.AbsoluteIndex;
  FMain.ClickTree:=True;
  FMain.Panel_Parametre.Visible:=False;
  FMain.Panel_grille.Visible:=False;
  FMain.Panel_Status.Visible:=False;
  FMain.Panel_Liste_Para.Visible:=False;
  FMain.Panel_Command.Visible:=False;
  FMain.Panel_Value.Visible:=False;
  FMain.Grille_Up:=0;
  if MenuI=0 then
    begin
      // We are in the Status Menu
      FMain.Panel_Parametre.Visible:=False;
      FMain.Panel_grille.Visible:=False;
      FMain.Panel_Status.Visible:=True;
      FMain.Panel_Liste_Para.Visible:=False;
      FMain.Panel_Command.Visible:=False;
      FMain.ClickTree:=False;
    end else // end if MenuI=0
  if MENUI=1 then
    begin
      // we are in the KWP general command
      FMain.Panel_Parametre.Visible:=False;
      FMain.Panel_grille.Visible:=False;
      FMain.Panel_Status.Visible:=False;
      FMain.Panel_Liste_Para.Visible:=False;
      FMain.Panel_Command.Visible:=True;
      FMain.TypeAff:=CT_AFFNONE;
      FMain.E_Sid.Text:='';
      FMain.E_Data.Text:='';
      FMain.M_Hist.Clear;
      FMain.ClickTree:=False;
    end else
    begin
      // we are in the diagnostic menu
      ActualMenu.Clear;
      FMain.Search_Item('MENU='+MenuName,Vehicule,ActualMenu);
      ClickList.Clear;
      FMain.Search_Item('CLICK',ActualMenu,ClickList); // On recupére les événements click sur la grille
      // Traitement des événements click
      i:=0;
      FMain.ClickGlobal:='';
      FMain.ClickExit:='';
      FMain.B_Mode_Maitre.Visible:=False;
      While i<ClickList.Count do
        begin
          texte:=trim(ClickList.Strings[i]);
          if uppercase(copy(texte,1,5))='EXIT=' then
            begin
              delete(texte,1,5);
              FMain.ClickExit:=texte;
              FMain.B_Mode_Maitre.Visible:=True;
            end else

          if uppercase(copy(texte,1,6))='ACTIF=' then
            begin
              delete(texte,1,6);
              FMain.ClickGlobal:=texte;
            end;
          i:=i+1;
        end;
      // We search the type of Panel
      i:=0;
      //ActualMenu.SaveToFile('C:\ActualMenu_'+MenuName+'.txt');
      while (i<ActualMenu.Count) do
        begin
          Application.ProcessMessages;
          if MainExit then Exit;
          texte:=trim(ActualMenu.Strings[i]);
          if uppercase(copy(texte,1,5))='TYPE=' then
            begin
              delete(texte,1,5);
              if uppercase(copy(texte,1,4))='GRID' then
                begin

                  FMain.TypeAff:=CT_AFFGRID;
                  delete(texte,1,5);
                  texte:=trim(texte);
                  //FMain.StringGrid1.Clean;
                  //FMain.StringGrid3.Clean;
                  try
                    j:=strtoint(texte);
                  except
                    j:=1;
                  end;
                  FMain.StringGrid1.ColCount:=j;
                  //j:=FMain.StringGrid1.ColCount;
                  //FMain.StringGrid3.ColCount:=j+2;
                  //j:=FMain.StringGrid3.ColCount;
                  FMain.Panel_grille.Visible:=True;
                  FMain.StringGrid1.RowCount:=1;
                  //FMain.StringGrid3.RowCount:=1;
                  FMain.Ajust_StringList(1,FMain.ColorList);
                  // On cherche les lignes commencant par LG=
                  while (i<ActualMenu.Count) do
                    begin
                      //Application.ProcessMessages;
                      texte:=trim(ActualMenu.Strings[i]);
                      if uppercase(copy(texte,1,3))='LG=' then
                        begin
                          // We write some fixed data if the buffer
                          delete(texte,1,3); // we delete LG=
                          delete(texte,1,4); // we delete the ROW=
                          j:=pos('/',texte);
                          try
                            ligne:=strtoint(copy(texte,1,j-1));
                          except
                            ligne:=1;
                          end;
                          if ligne>=FMain.StringGrid1.RowCount then
                            begin
                              k:=FMain.StringGrid1.RowCount;
                              FMain.StringGrid1.RowCount:=ligne+1;
                              for l := k to FMain.StringGrid1.RowCount - 1 do
                                for m := 0 to FMain.StringGrid1.ColCount-1 do
                                   FMain.StringGrid1.Cells[m,l]:='';
                              FMain.Ajust_StringList(Ligne+1,FMain.ColorList);
                            end;
                          delete(texte,1,j);
                          while length(texte)>0 do
                            begin
                              j:=pos('/',texte);
                              if j=0 then j:=pos(';',texte);
                              if j>0 then
                                begin
                                  texte1:=copy(texte,1,j-1);
                                  delete(texte,1,j);
                                end else
                                begin
                                  texte1:=texte;
                                  texte:='';
                                end;
                              if copy(texte1,1,3)='CL=' then
                                begin
                                  delete(texte1,1,3);
                                  //FMain.StringGrid3.Cells[FMain.StringGrid3.ColCount-2,ligne]:=texte1;
                                  FMain.ColorList.Strings[ligne]:=texte1;
                                end else // fin if copy(texte1,1,3)='CL=' then
                              if copy(texte1,1,2)='GR' then
                                begin
                                  delete(texte1,1,2);
                                  k:=pos('=',texte1);
                                  try
                                    l:=strtoint(copy(texte1,1,k-1));
                                  except
                                    l:=0;
                                  end;
                                  delete(texte1,1,k);
                                  if l<FMain.StringGrid1.ColCount then
                                    begin
                                      if uppercase(copy(texte1,1,4))='TAB[' then
                                        begin
                                          delete(texte1,1,4);
                                          k:=pos(',',texte1);
                                          if k>0 then
                                            begin
                                              try
                                                m:=strtoint(copy(texte1,1,k-1));
                                              except
                                                m:=-1;
                                              end;
                                              delete(texte1,1,k);
                                              k:=pos(']',texte1);
                                              try
                                                n:=strtoint(copy(texte1,1,k-1));
                                              except
                                                n:=-1;
                                              end;
                                              delete(texte1,1,k);
                                              if (m>-1) and (m<10) then
                                                begin
                                                  if FMain.Table[m]<>nil then
                                                    begin
                                                      if (n>-1) and (n<FMain.Table[m].Count)then
                                                        begin
                                                          texte1:=FMain.Table[m].Strings[n];
                                                        end else texte1:=MenuProg[CMP_ERRORLIGNETABLE];
                                                    end else texte1:=MenuProg[CMP_TableUnknow];
                                                end else texte1:=MenuProg[CMP_ERRORNUMBERTABLE];
                                            end;
                                          FMain.StringGrid1.Cells[l,ligne]:=texte1;
                                        end else
                                        begin
                                          FMain.StringGrid1.Cells[l,ligne]:=texte1;
                                        end;
                                    end;
                                end;
                            end;
                        end; // end of if uppercase(copy(texte,1,3))='LG=' then

                      i:=i+1;
                    end; // end of  while (i<ActualMenu.Count) do
                  if FMain.StringGrid1.RowCount>1 then FMain.StringGrid1.FixedRows:=1;
                end else
              if uppercase(copy(texte,1,7))='CONFIRM' then
                begin
                  FMain.Panel_Parametre.Visible:=False;
                  FMain.Panel_grille.Visible:=False;
                  FMain.Panel_Status.Visible:=True;
                  FMain.Panel_Liste_Para.Visible:=False;
                  FMain.Panel_Command.Visible:=False;
                  FMain.Panel_Value.Visible:=False;
                  FMain.TypeAff:=CT_AFFCONFIRM;
                end else
              if uppercase(copy(texte,1,12))='ONEPARAMETER' then
                begin
                  FMain.Panel_Parametre.Visible:=False;
                  FMain.Panel_grille.Visible:=False;
                  FMain.Panel_Status.Visible:=False;
                  FMain.Panel_Liste_Para.Visible:=False;
                  FMain.Panel_Command.Visible:=False;
                  FMain.Panel_Value.Visible:=True;
                  FMain.TypeAff:=CT_AFFONEPARAMETER;
                  FMain.E_Para.Text:='';
                  FMain.E_Para_Numero.Text:='';
                  Fmain.M_Parametre.Clear;
                  FMain.B_Para_Lecture.Caption:='';
                  FMain.B_Para_Ecriture.Caption:='';
                  FMain.CdeReadParam:='';
                  FMain.CdeWriteParam:='';
                  FMain.CdeValueLength:='';
                  while (i<ActualMenu.Count) do
                    begin
                      Application.ProcessMessages;
                      if MainExit then Exit;
                      // we search CDE_READ,CDE_WRITE,LABEL_READ,LABEL_WRITE
                      texte:=trim(ActualMenu.Strings[i]);
                      if uppercase(copy(texte,1,11))='LABEL_READ=' then
                        begin
                          delete(texte,1,11);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Para_Lecture.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,12))='LABEL_WRITE=' then
                        begin
                          delete(texte,1,12);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Para_Ecriture.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,9))='CDE_READ=' then
                        begin
                          delete(texte,1,9);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeReadParam:=texte;
                        end else
                      if uppercase(copy(texte,1,10))='CDE_WRITE=' then
                        begin
                          delete(texte,1,10);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeWriteParam:=texte;
                        end else
                      if uppercase(copy(texte,1,7))='LENGTH=' then
                        begin
                          delete(texte,1,7);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          CdeValueLength:=texte;
                        end;
                      i:=i+1;
                    end;
                  if length(FMain.CdeReadParam)=0
                    then FMain.B_Para_Lecture.Visible:=False
                    else FMain.B_Para_Lecture.Visible:=true;
                  if length(FMain.CdeWriteParam)=0
                    then FMain.B_Para_ecriture.Visible:=False
                    else FMain.B_Para_ecriture.Visible:=true;
                end else
              if uppercase(copy(texte,1,8))='ONEVALUE' then
                begin
                  FMain.Panel_Parametre.Visible:=True;
                  FMain.Panel_grille.Visible:=False;
                  FMain.Panel_Status.Visible:=False;
                  FMain.Panel_Liste_Para.Visible:=False;
                  FMain.Panel_Command.Visible:=False;
                  FMain.Panel_Value.Visible:=False;
                  FMain.TypeAff:=CT_AFFONEPARAMETER;
                  FMain.E_Para.Text:='';
                  FMain.E_Para_Numero.Text:='';
                  Fmain.M_Parametre.Clear;
                  FMain.B_Para_Lecture.Caption:='';
                  FMain.B_Para_Ecriture.Caption:='';
                  FMain.CdeReadParam:='';
                  FMain.CdeWriteParam:='';
                  FMain.CdeValueLength:='';
                  while (i<ActualMenu.Count) do
                    begin
                      Application.ProcessMessages;
                      if MainExit then Exit;
                      // we search CDE_READ,CDE_WRITE,LABEL_READ,LABEL_WRITE
                      texte:=trim(ActualMenu.Strings[i]);
                      if uppercase(copy(texte,1,11))='LABEL_READ=' then
                        begin
                          delete(texte,1,11);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Para_Lecture.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,12))='LABEL_WRITE=' then
                        begin
                          delete(texte,1,12);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Para_Ecriture.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,9))='CDE_READ=' then
                        begin
                          delete(texte,1,9);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeReadParam:=texte;
                        end else
                      if uppercase(copy(texte,1,10))='CDE_WRITE=' then
                        begin
                          delete(texte,1,10);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeWriteParam:=texte;
                        end else
                      if uppercase(copy(texte,1,7))='LENGTH=' then
                        begin
                          delete(texte,1,7);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          CdeValueLength:=texte;
                        end;
                      i:=i+1;
                    end;
                  if length(FMain.CdeReadParam)=0
                    then FMain.B_Valeur_Lecture.Visible:=False
                    else FMain.B_Valeur_Lecture.Visible:=true;
                  if length(FMain.CdeWriteParam)=0
                    then FMain.B_Valeur_ecriture.Visible:=False
                    else FMain.B_Valeur_ecriture.Visible:=true;
                end else
              if uppercase(copy(texte,1,10))='MULTIVALUE' then
                begin
                  FMain.Panel_Parametre.Visible:=False;
                  FMain.Panel_grille.Visible:=False;
                  FMain.Panel_Status.Visible:=False;
                  FMain.Panel_Liste_Para.Visible:=True;
                  FMain.Panel_Command.Visible:=False;
                  FMain.TypeAff:=CT_AFFMultiVALUE;
                  while (i<ActualMenu.Count) do
                    begin
                      Application.ProcessMessages;
                      if MainExit then Exit;
                      // we search CDE_READ,CDE_WRITE,LABEL_READ,LABEL_WRITE
                      texte:=trim(ActualMenu.Strings[i]);
                      if uppercase(copy(texte,1,11))='LABEL_READ=' then
                        begin
                          delete(texte,1,11);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Lecture_Liste.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,12))='LABEL_WRITE=' then
                        begin
                          delete(texte,1,12);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.B_Sauve_Liste.Caption:=texte;
                        end else
                      if uppercase(copy(texte,1,9))='CDE_READ=' then
                        begin
                          delete(texte,1,9);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeReadParam:=texte;
                        end else
                      if uppercase(copy(texte,1,10))='CDE_WRITE=' then
                        begin
                          delete(texte,1,10);
                          j:=pos(';',texte);
                          if j>0 then texte:=copy(texte,1,j-1);
                          FMain.CdeWriteParam:=texte;
                        end;
                      i:=i+1;
                    end;
                end;
              i:=ActualMenu.Count;
            end;
          i:=i+1;
        end;

      // We search the title
      i:=0;
      while (i<ActualMenu.Count) do
        begin
          Application.ProcessMessages;
          if MainExit then Exit;
          texte:=trim(ActualMenu.Strings[i]);
          if uppercase(copy(texte,1,6))='TITLE=' then
            begin
              delete(texte,1,6);
              texte:=trim(texte);
              FMain.TitleMenu:=texte;
              if FMain.TypeAff=CT_AFFGRID then
                begin
                  For k:=0 to FMain.StringGrid1.ColCount-1 do FMain.StringGrid1.ColWidths[k]:=16;
                  if length(texte)>0 then
                    if texte[length(texte)]<>'/' then texte:=texte+'/';
                  j:=0;
                  while length(texte)>0 do
                    begin
                      k:=pos('/',texte);
                      if k>0 then
                        begin
                          if j<FMain.StringGrid1.ColCount then
                            begin
                              //FMain.StringGrid3.Cells[j,0]:=copy(texte,1,k-1);
                              FMain.StringGrid1.Cells[j,0]:=copy(texte,1,k-1);
                              if FMain.StringGrid1.ColWidths[j]<FMain.StringGrid1.Canvas.TextWidth(copy(texte,1,k-1))+32
                                then FMain.StringGrid1.ColWidths[j]:=FMain.StringGrid1.Canvas.TextWidth(copy(texte,1,k-1))+32;
                            end;
                          j:=j+1;
                          delete(texte,1,k);
                        end else texte:='';
                    end;
                end else
              if FMain.TypeAff=CT_AFFCONFIRM then
                begin
                end else
              if FMain.TypeAff=CT_AFFONEPARAMETER then
                begin
                end else
              if FMain.TypeAff=CT_AFFMULTIVALUE then
                begin
                end else
              if FMain.TypeAff=CT_AFFONEVALUE then
                begin
                end;
              i:=ActualMenu.Count;
            end;
          i:=i+1;
        end;
      FMain.GroupBox2.Caption:=FMain.MenuName;
      // We search the Repeat time
      FMain.TimeRepeat:=0;
      i:=0;
      while (i<ActualMenu.Count) do
        begin
          texte:=trim(ActualMenu.Strings[i]);
          if uppercase(copy(texte,1,7))='REPEAT=' then
            begin
              delete(texte,1,7);
              texte:=trim(texte);
              try
                FMain.TimeRepeat:=StrToInt(texte);
              except
                FMain.TimeRepeat:=0;
              end;
              i:=ActualMenu.Count;
            end;
          i:=i+1;
          Application.ProcessMessages;
          if MainExit then Exit;
        end;

      // We use the command of KWP
      FMain.ClickTree:=False;
      FMain.T_StatusIO.Interval:=200;
      FMain.ligneMenu:=0;
      FMain.T_StatusIO.Enabled:=True;
    end; // end if MenuI<>0
end;

//******************************************************************************
{
procedure TFMain.rafraichir_diag;
var i,j : integer;
    texte : string;
begin
  if FMain.TypeAff=CT_AFFGRID then
    begin
      if FMain.ClickTree then exit;
      FMain.nb_Row_visible:=FMain.StringGrid1.Height div FMain.StringGrid1.DefaultRowHeight;
      if FMain.nb_Row_visible>FMain.StringGrid3.RowCount
         then FMain.nb_Row_visible:=FMain.StringGrid3.RowCount;
      if FMain.Grille_Up+FMain.nb_Row_visible>FMain.StringGrid3.RowCount
         then FMain.Grille_Up:=FMain.StringGrid3.RowCount-FMain.nb_Row_visible-1;
      if FMain.StringGrid3.RowCount>FMain.nb_Row_visible
         then FMain.StringGrid1.RowCount:=FMain.nb_Row_visible
         else
      //FMain.StringGrid1.RowCount:=FMain.StringGrid3.RowCount;
      // transfert des données de StringGrid3 vers StringGrid1
      for i:=0 to FMain.StringGrid1.ColCount-1 do
        begin
          for j:=Grille_up+1 to Grille_up+FMain.StringGrid1.RowCount-1 do
            begin
              texte:=FMain.StringGrid3.Cells[i,j];
              texte:=copy(texte,1,length(texte)-1);
              if (texte<>'IMG_AMBER')
                 and (texte<>'IMG_RED')
                 and (texte<>'IMG_BLUE')
                 and (texte<>'IMG_GREEN')
                 then texte:=FMain.StringGrid3.Cells[i,j]
                 else texte:='';
              FMain.StringGrid1.Cells[i,j-Grille_Up]:=texte;
              if FMain.StringGrid1.ColWidths[i]<FMain.StringGrid1.Canvas.TextWidth(texte)+8
                 then FMain.StringGrid1.ColWidths[i]:=FMain.StringGrid1.Canvas.TextWidth(texte)+8;
            end;
        end;
      FMain.StringGrid1.Refresh;
    end;
    
end;}

//******************************************************************************
procedure TFMain.GlobalReset;
var i : integer;
    //noeud : TTreeNode;
begin
  FMain.nom_fichier:='';
  BeginExit:=True;
  //FMain.KWP20001.Tps_Maintient:=2000;
  FMain.Grille_Up:=0;
  FMain.nb_Row_visible:=FMain.StringGrid1.Height div FMain.StringGrid1.DefaultRowHeight;
  //FMain.StringGrid3.RowCount:=0;
  FMain.ColorList.Clear;
  Fichier.Clear;
  Vehicule.Clear;
  MenuList.Clear;
  ActualMenu.Clear;
  ActualKWP.Clear;
  FMain.ExtendedMenu.Clear;
  FMain.Panel_Liste_Para.Visible:=False;
  FMain.Panel_Parametre.Visible:=False;
  FMain.Panel_grille.Visible:=False;
  FMain.Panel_Command.Visible:=False;
  FMain.Panel_Status.Visible:=True;
  FMain.Panel_Value.Visible:=False;
  // nettoyage des panels
  FMain.M_Hist.Clear;
  FMain.M_Parametre.Clear;
  FMain.M_Valeur.Clear;
  FMain.E_Data.Clear;
  FMain.E_Fichier_Para.Clear;
  FMain.E_Para.Clear;
  FMain.E_Para_Numero.Clear;
  FMain.E_Sid.Clear;
  FMain.E_Valeur.Clear;
  //
  State:=0;
  FMain.Attente_Stop;
  FMain.KWP20001.StopDiagnosis;
  FMain.Menu_Connection.Caption:=MenuProg[CMP_Connecter];
  FMain.Image1.Picture.Bitmap:=nil;
  FMain.IListConnect.GetBitmap(0,FMain.Image1.Picture.Bitmap);
  for i:=0 to 9 do if FMain.Table[i]<>nil then FMain.Table[i].Clear;
  FMain.Treeview1.Items.Clear;
  //Noeud:=FMain.TreeView1.Items.Add(nil,MenuProg[CMP_Status]);
  //Noeud.ImageIndex:=5;
  //Noeud:=FMain.TreeView1.Items.Add(nil,MenuProg[CMP_Command]);
  //Noeud.ImageIndex:=1;
  FMain.TreeView1.Enabled:=False;
  FMain.diag_actif:=False;
  FMain.ClickActif:=False;
  FMain.ClickGlobal:='';
  FMain.ClickExit:='';
  FMain.B_Mode_Maitre.Visible:=false;
  FMain.NoReceive:=False;
  Application.CleanupInstance;

  try
  if (FBiPWM<>nil) and (FBiPWM.Actif) then FBiPwm.Close;
  if (FPWM<>nil) and (FPwm.Actif) then FPWM.Close;
  if (FBridge<>nil) and (FBridge.Actif) then FBridge.Close;
  if (FOnOff<>nil) and (FOnOff.Actif) then FOnOff.Close;
  if (FValue<>nil) and (FValue.Actif) then FValue.Close;
  if (FWiper<>nil) and (FWiper.Actif) then FWiper.Close;
  //F_Configuration.GroupBox2.Enabled:=True;
  except
  end;
end;

//******************************************************************************
// This Procedure search a special item in the StringList ListSearch and return
// all parameters include between the two balise.
//******************************************************************************
procedure TFMain.Search_Item(ItemSearch : string;ListSearch : TStringList;var searchList: TStringList);
var texte : string;
    i,j : integer;
begin
  searchList.Clear;
  i:=0;
  while i<ListSearch.Count do
    begin
      texte:=ListSearch.Strings[i];
      texte:=trim(texte);
      if length(texte)>0 then
        if copy(texte,1,2)<>'//' then
          if uppercase(copy(texte,1,length(ItemSearch)+1))=uppercase('<'+ItemSearch) then
            begin
              //i:=i+1;
              if i<ListSearch.Count then texte:=ListSearch.Strings[i] else texte:='';
              while (i<ListSearch.Count) and (copy(texte,1,length(ItemSearch)+2)<>uppercase('</'+ItemSearch))
                   and (uppercase(copy(texte,1,7))<>'</MENU>')do
                begin
                  texte:=ListSearch.Strings[i];
                  texte:=trim(texte);
                  j:=pos(';',texte);
                  if (copy(texte,1,2)<>'//') and (length(texte)>0) then
                    begin
                      if j>0
                        then SearchList.Add(copy(texte,1,j-1))
                        else SearchList.Add(texte);
                    end;
                  i:=i+1;
                end;
              i:=ListSearch.Count;
            end;
      i:=i+1;
    end;
end;

//******************************************************************************
procedure TFMain.Ajust_StringList(Count: integer; var Liste: TSTringList);
var i : integer;
begin
  if Count>Liste.Count then For i:=1 to Count-Liste.Count do Liste.Add('')
    else
  if Count<Liste.Count then For i:=1 to Liste.Count-Count do Liste.Delete(Liste.Count-1);
end;

procedure TFMain.Attente_Start;
begin
  FMain.T_Attente.Enabled:=True;
end;

//******************************************************************************
procedure TFMain.Attente_Stop;
begin
  FMain.T_Attente.Enabled:=False;
end;

//******************************************************************************
Function TFMain.Cde2Send(CDE: string): integer;
var texte : string;
    erreur: integer;
begin
  while (FMain.Execution=false) and (MainExit=False) do application.ProcessMessages;
  if MainExit then Exit;
  erreur:=0;
  FMain.KWP20001.SendLength:=0;
  texte:=CDE;
  try
    FMain.KWP20001.Sid:=hextodec(copy(texte,1,2));
  except
    FMain.KWP20001.Sid:=0;
    erreur:=1;
    Result:=Erreur;
    exit;
  end;
  delete(texte,1,3);
  while length(texte)>0 do
    begin
      FMain.KWP20001.FData[FMain.KWP20001.SendLength]:=hextodec(copy(texte,1,2));
      FMain.KWP20001.SendLength:=FMain.KWP20001.SendLength+1;
      delete(texte,1,3);
    end;
  Result:=erreur;
end;

//******************************************************************************
procedure TFMain.Create_Menu_Langue;
var s : TSearchRec;
    texte : string;
begin
  Nb_Langue:=0;
  if FindFirst(Repertoire_courant+'Languages\*.dia',faAnyFile,s)=0 then
    begin
      repeat
        M[Nb_Langue]:=TMenuItem.Create(Self);
        m[Nb_Langue].OnClick:=Menu_langueAddClick;
        m[Nb_Langue].Visible:=True;
        m[Nb_Langue].Enabled:=True;
        m[Nb_Langue].Tag:=Nb_Langue;
        texte:=s.Name;
        texte:=copy(texte,1,length(texte)-4);
        m[Nb_Langue].Caption:=texte;
        FMain.Menu_Langues.Add(m[Nb_Langue]);
        Nb_Langue:=Nb_Langue+1;
      until (FindNext(s)<>0) or (Nb_Langue>255);
    end;
  FindClose(s);
end;

//******************************************************************************
procedure TFMain.Init_Message;
begin
  FMain.Menu_Connection.Caption:=MenuProg[CMP_Connecter];
  FMain.Menu_Setting.Caption:=MenuProg[CMP_Configuration];
  FMain.Menu_Quitter.Caption:=MenuProg[CMP_Quitter];
  FMain.Menu_Langues.Caption:=MenuProg[CMP_Language];
end;

//******************************************************************************
procedure TFMain.Menu_langueAddClick(Sender: TObject);
var texte : string;
    i:integer;
begin
  texte:=TMenuItem(Sender).Caption;
  ReadLanguage(Repertoire_courant+'Languages\'+texte+'.dia');
  FMain.KWP20001.LoadMessageTXT(Repertoire_courant+'Languages\'+texte+'.KWP');
  FMain.Init_Message;
  for i:=0 to Nb_Langue-1 do M[i].Checked:=False;
  i:=TMenuItem(Sender).Tag;
  M[i].Checked:=True;
  F_Configuration.CB_Langue.Text:=texte;
end;

end.

