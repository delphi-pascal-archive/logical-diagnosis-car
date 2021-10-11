unit ulist;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, StdCtrls;

// CLK=,1/LIST/EXIT=/CASE=1,2-9/NAME=Ecriture de la date et de l'heure/
// TITLE=Date et heure/COR=0.25|0:1|0:1|0:1|0:0.25|0:1|0:1|0:1|0/
// TYPE=8:8:8:8:8:8:8/CDE=2E F9 0B VALUE;
type

  { TFList }

  TFList = class(TForm)
    BitBtn1: TBitBtn;
    B_Fermer: TButton;
    B_sendValue: TButton;
    E_Value: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    L_Pin: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    procedure B_FermerClick(Sender: TObject);
    procedure B_sendValueClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    Etat : boolean;
    Actif : boolean;
    correction : string;
    type_value : string;
    Cde_Send : string;
    Cde_Exit : string;
    Buffer : string;
    ListColMin,ListColMax,ListRowMin,ListRowMax : integer;
    ActualCol,ActualRow : integer;
    procedure CaseToInteger(ListCase : string;VAR CTIColMin,CtiColMax,CTIRowMin,CTIRowMax : integer);
    procedure Correction2int(correct : string;number : integer;VAR offset,pente : real);
    procedure Type2(valuetype : string;number : integer; var lg_data : integer;sens_octet : boolean);
    procedure Disable_Screen;
    procedure Enable_Screen;
  end; 

var
  FList: TFList;

implementation

{$R *.dfm}

uses umain,common;

{ TFList }

//******************************************************************************
procedure TFList.B_FermerClick(Sender: TObject);
begin
  FList.Close;
end;

//******************************************************************************
procedure TFList.B_sendValueClick(Sender: TObject);
var r : real;
    a,b : real; // y=a*x+b
    i : integer;
    aCol,aRow : integer;
    cde,texte,texte2 : string;
    s_octet : boolean;
    lg : integer;
begin
  try
    cde:='';
    for aCol:=FList.ListColMin to FList.ListColMax do
      begin
        for aRow:=1 to FList.StringGrid1.RowCount-1 do
          begin
            texte:=FList.StringGrid1.Cells[aCol,aRow];
            r:=strtoreel(texte);
            FList.Correction2Int(FList.correction,aRow-1,b,a);
            r:=(r-b)/a;
            i:=trunc(r);
            texte:=dectohex(i);
            FList.Type2(FList.type_value,aRow-1,lg,s_octet);
            i:=lg div 4;
            texte:=copy(texte,1,i);
            if (s_octet) and (length(texte)=4) then texte:=copy(texte,3,2)+copy(texte,1,2);
            while length(texte)>0 do
              begin
                cde:=cde+copy(texte,1,2)+' ';
                delete(texte,1,2);
              end;
          end; // end of for aRow:=FList.ListRowMin to FList.ListRowMax do
      end; // end of for aCol:=FList.ListColMin to FList.ListColMax do
    i:=pos('VALUE',FList.Cde_Send);
    texte:=FList.Cde_Send;
    if i>0 then
      begin
        texte2:=copy(texte,1,i-1);
        delete(texte,1,i+5);
        texte:=texte2+cde+texte;
      end;
    if FMain.T_StatusIO.Enabled=False then
      begin
        FMain.T_StatusIO.Enabled:=True;
        FMain.T_StatusIO.Interval:=100;
      end;
    Buffer:=texte;
  except
  end;
end;

//******************************************************************************
procedure TFList.BitBtn1Click(Sender: TObject);
begin
  if (ActualRow=-1)
     or (ActualCol=-1) then exit;
  FList.StringGrid1.Cells[ActualCol,ActualRow]:=FList.E_Value.Text;
end;

//******************************************************************************
procedure TFList.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Buffer:='';
  if length(FList.Cde_Exit)>0 then
    begin
      //FMain.Cde2Send(FList.Cde_Exit);
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
      Buffer:=FList.Cde_Exit;
    end;
  while length(Buffer)>0 do Application.ProcessMessages;
  if FMain.T_StatusIO.Enabled=False then
     begin
       FMain.T_StatusIO.Enabled:=True;
       FMain.T_StatusIO.Interval:=100;
     end;
  Buffer:='#';
  FList.Actif:=false;
end;

//******************************************************************************
procedure TFList.FormCreate(Sender: TObject);
begin
  FList.Actif:=false;
  FList.Cde_Send:='';
  FList.Cde_Exit:='';
  FList.E_Value.Text:='';
  ListColMin:=-1;
  ListColMax:=-1;
  ListRowMin:=-1;
  ListRowMax:=-1;
  ActualCol:=-1;
  ActualRow:=-1;
end;

//******************************************************************************
procedure TFList.StringGrid1Click(Sender: TObject);
var aRow,aCol : integer;
    texte : string;
begin
  aCol:=FList.StringGrid1.Col;
  aRow:=FList.StringGrid1.Row;
  texte:='';
  if (FList.ListColMin=-1) then
    begin
      texte:='';
      ActualCol:=-1;
      ActualRow:=-1;
    end else
  if (FList.ListColMin=FList.ListColMax) then
    begin
      texte:=FList.StringGrid1.Cells[FList.ListColMin,aRow];
      ActualCol:=FList.ListColMin;
      ActualRow:=aRow;
    end else
  if (FList.ListRowMin=FList.ListRowMax) then
    begin
      texte:=FList.StringGrid1.Cells[aCol,FList.ListRowMin];
      ActualCol:=aCol;
      ActualRow:=FList.ListRowMin;
    end else
    begin
      texte:=FList.StringGrid1.Cells[aCol,aRow];
      ActualCol:=aCol;
      ActualRow:=aRow;
    end;
  FList.E_Value.Text:=texte;
end;

//******************************************************************************
procedure TFList.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aRow>0 then
    begin
      FList.StringGrid1.Canvas.Brush.Color:=clWhite;
    end else FList.StringGrid1.Canvas.Brush.Color:=clSkyBlue;
  FList.StringGrid1.Canvas.FillRect(aRect);
end;

//******************************************************************************
procedure TFList.CaseToInteger(ListCase: string; VAR CTIColMin, CtiColMax,
  CTIRowMin, CTIRowMax: integer);
var i : integer;
    texte,texte1 : string;
begin
  // CASE=1,2-9
  CTIColMin:=-1;
  CtiColMax:=-1;
  CTIRowMin:=-1;
  CTIRowMax:=-1;
  texte:=ListCase;
  i:=pos(',',texte);
  if i<0 then exit;
  texte1:=copy(texte,1,i-1);
  delete(texte,1,i);
  i:=pos('-',texte1);
  if i>0 then
    begin
      try
        CTIColMin:=strtoint(copy(texte1,1,i-1));
        delete(texte1,1,i);
        CTIColMax:=strtoint(texte1);
      except
        CTIColMin:=-1;
        CtiColMax:=-1;
        CTIRowMin:=-1;
        CTIRowMax:=-1;
        exit;
      end;
    end else
    begin
      try
        CTIColMin:=strtoint(texte1);
        CTIColMax:=CTIColMin;
      except
        CTIColMin:=-1;
        CtiColMax:=-1;
        CTIRowMin:=-1;
        CTIRowMax:=-1;
        exit;
      end;
    end;
  i:=pos('-',texte);
  if i>0 then
    begin
      try
        CTIRowMin:=strtoint(copy(texte,1,i-1));
        delete(texte,1,i);
        CTIRowMax:=strtoint(texte);
      except
        CTIColMin:=-1;
        CtiColMax:=-1;
        CTIRowMin:=-1;
        CtiRowMax:=-1;
      end;
    end else
    begin
      try
        CTIRowMin:=strtoint(texte);
        CTIRowMax:=CTIRowMin;
      except
        CTIColMin:=-1;
        CtiColMax:=-1;
        CTIRowMin:=-1;
        CtiRowMax:=-1;
      end;
    end;
end;

//******************************************************************************
procedure TFList.Correction2Int(correct: string; number: integer; var offset,
  pente: real);
var i,j : integer;
    texte,texte1 : string;
begin
  // correct=0.25|0:1|0:1|0:1|0:0.25|0:1|0:1|0:1|0
  // number=    0    1   2   3     4    5   6   7
  texte:=correct;
  texte:=trim(texte);
  if length(texte)=0 then exit;
  if texte[length(texte)]<>':' then texte:=texte+':';
  i:=-1;
  offset:=0;
  pente:=1;
  while (i<>number) and (length(texte)>0) do
    begin
      j:=pos(':',texte);
      texte1:=copy(texte,1,j-1);
      delete(texte,1,j);
      i:=i+1;
      if (i=number) and (length(texte1)>0) then
        begin
          j:=pos('|',texte1);
          try
            pente:=strtoreel(copy(texte1,1,j-1));
          except
            pente:=1;
          end;
          delete(texte1,1,j);
          try
            offset:=strtoreel(texte1);
          except
            offset:=0;
          end;
        end;
    end;
end;

//******************************************************************************
procedure TFList.Type2(valuetype: string; number: integer;
  var lg_data: integer; sens_octet: boolean);
var i,j : integer;
    texte,texte1 : string;
begin
  texte:=valuetype;
  texte:=trim(texte);
  if length(texte)=0 then exit;
  if texte[length(texte)]<>':' then texte:=texte+':';
  i:=-1;
  lg_data:=0;
  sens_octet:=false;
  while (i<>number) and (length(texte)>0) do
    begin
      j:=pos(':',texte);
      texte1:=copy(texte,1,j-1);
      delete(texte,1,j);
      i:=i+1;
      if (i=number) and (length(texte1)>0) then
        begin
          j:=pos('L',texte1);
          if j>0 then sens_octet:=true;
          if j>0 then delete(texte1,j,1);
          j:=pos('H',texte1);
          if j>0 then sens_octet:=False;
          if j>0 then delete(texte1,j,1);
          texte1:=trim(texte1);
          try
            lg_data:=strtoint(texte1);
          except
            lg_data:=0;
          end;
        end;
    end;
end;

//******************************************************************************
procedure TFList.Disable_Screen;
begin
  FList.B_sendValue.Enabled:=False;
  FList.E_Value.Enabled:=False;
  FList.BitBtn1.Enabled:=False;
  //FList.B_Fermer.Enabled:=False;
  FList.StringGrid1.Enabled:=False;
end;

//******************************************************************************
procedure TFList.Enable_Screen;
begin
  FList.B_sendValue.Enabled:=true;
  FList.E_Value.Enabled:=True;
  FList.BitBtn1.Enabled:=True;
  //FList.B_Fermer.Enabled:=True;
  FList.StringGrid1.Enabled:=True;
end;

//******************************************************************************
initialization
  

end.

