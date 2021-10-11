unit U_save;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, EditBtn, FileCtrl,Windows;

type

  { TFSave }

  TFSave = class(TForm)
    B_Annuler: TButton;
    B_OK: TButton;
    ComboDrive: TComboBox;
    Edit1: TEdit;
    FileListBox1: TFileListBox;
    FileListBox2: TFileListBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    Splitter1: TSplitter;
    procedure B_AnnulerClick(Sender: TObject);
    procedure B_OKClick(Sender: TObject);
    procedure ComboDriveSelect(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure FileListBox2DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    resultat : boolean;
    Procedure enum_drive;
  public
    { public declarations }
    FileName : string;
    function execute : boolean;
  end; 

var
  FSave: TFSave;

implementation

uses common;

{ TFSave }

procedure TFSave.FileListBox1DblClick(Sender: TObject);
var texte : string;
begin
  {
  ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftDirectory,
               ftArchive, ftNormal
  }
  if (FSave.FileListBox1.FileType<>[ftDirectory])
     and (FSave.FileListBox1.FileType<>[ftSystem])
     and (FSave.FileListBox1.FileType<>[ftVolumeID])
     and (FileExists(FSave.FileListBox1.FileName)) then
     begin
       FSave.Edit1.Text:=FSave.FileListBox1.FileName;
       FSave.FileName:=FSave.Edit1.Text;
       Resultat:=True;
       FSave.Close;
     end;
end;

procedure TFSave.FileListBox2DblClick(Sender: TObject);
var texte,texte1,texte2 : string;
    i : integer;
begin
  texte:=FSave.FileListBox2.FileName;
  i:=length(texte);
  while (i>1) and (texte[i]<>'/')and(texte[i]<>'\') do i:=i-1;
  texte2:=copy(texte,1,i);// texte2 contient le répertoire de base
  texte1:=texte;
  delete(texte1,1,i); // texte1 contient le nom du répertoire
  if (texte1='[.]')
     or (texte1='[..]') then
     begin
       FSave.Edit1.Text:=texte2;
       i:=length(texte2);
       if (copy(texte2,length(texte2),1)='\')
          or (copy(texte2,length(texte2),1)='/')
          then texte2:=copy(texte2,1,length(texte2)-1);
        while (i>1) and (texte2[i]<>'/')and(texte2[i]<>'\') do i:=i-1;
        if i=0 then exit;
        FSave.FileListBox2.Directory:=copy(texte2,1,i-1);

     end else
     begin
       i:=pos('[',texte1);
       delete(texte1,i,1);
       i:=pos(']',texte1);
       delete(texte1,i,1);
       FSave.FileListBox2.Directory:=texte2+texte1;
     end;
  FSave.FileListBox1.Directory:=FSave.FileListBox2.Directory;
end;

procedure TFSave.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var texte : string;
    i,j : integer;
begin
  if Resultat=True then
     begin
       //récupération du nom de fichier
       texte:=FSave.Edit1.Text;
       i:=length(texte);
       while (i>1) and (texte[i]<>'\') and (texte[i]<>'/')do i:=i-1;
       if i>1 then delete(texte,1,i);
       texte:=FSave.FileListBox2.Directory+'\'+texte;
       i:=length(texte);
       j:=0;
       while (i>1) and (texte[i]<>'.') and (j=0)do
         begin
           if (texte[i]='/') or(texte[i]='\') then j:=1;
           i:=i-1;
         end;
       if (j=0) and (i>1) then
          begin
            texte:=copy(texte,1,i-1);
          end;
       case FSave.RadioGroup1.ItemIndex of
         0 : texte:=texte+'.xml';
         1 : texte:=texte+'.csv';
       end;
       FSave.Edit1.Text:=texte;
       FSave.FileName:=texte;
     end;
end;

//******************************************************************************
procedure TFSave.FormCreate(Sender: TObject);
begin
  FSave.enum_drive;
end;

//******************************************************************************
procedure TFSave.enum_drive;
var num : integer;
    Bits : set of 0..25;
begin
  FSave.ComboDrive.Clear;
  integer(Bits):=GetLogicalDrives;
  For num:=0 to 25 do
    begin
      if num in bits then FSave.ComboDrive.Items.Add(chr(num+ord('A'))+':\');
    end;
end;

//******************************************************************************
procedure TFSave.B_OKClick(Sender: TObject);
begin
  Resultat:=True;
  FSave.Close;
end;

//******************************************************************************
procedure TFSave.ComboDriveSelect(Sender: TObject);
begin
  FSave.FileListBox2.Directory:=FSave.ComboDrive.Text;
  FSave.FileListBox1.Directory:=FSave.FileListBox2.Directory;
end;

//******************************************************************************
procedure TFSave.FileListBox1Click(Sender: TObject);
begin
  FSave.Edit1.Text:=FSave.FileListBox1.FileName;
  FSave.FileName:=FSave.Edit1.Text;
end;

//******************************************************************************
procedure TFSave.B_AnnulerClick(Sender: TObject);
begin
  Resultat:=False;
  FSave.Close;
end;

//******************************************************************************
function TFSave.execute: boolean;
var texte : string;
    i : integer;
begin
  resultat:=false;
  FSave.enum_drive;
  //FSave.FileListBox1.FileName:=Application.ExeName;
  texte:=FSave.FileListBox1.Directory;
  FSave.FileListBox2.Directory:=texte;
  i:=1;
  while (i<=length(texte)) and (texte[i]<>'/') and (texte[i]<>'\') do i:=i+1;
  FSave.ComboDrive.Text:=copy(texte,1,i);
  FSave.Edit1.Text:='';
  //
  FSave.Caption:=MenuProg[CMP_SaveFile];
  FSave.GroupBox2.Caption:=MenuProg[CMP_Lecteur];
  FSave.GroupBox1.Caption:=MenuProg[CMP_FileList];
  FSave.Label1.Caption:=MenuProg[CMP_FileName];
  FSave.RadioGroup1.Caption:=MenuProg[CMP_FileType];
  FSave.B_Annuler.Caption:=MenuProg[CMP_Cancel];
  FSave.B_OK.Caption:=MenuProg[CMP_Save];
  //
  FSave.ShowModal;
  Result:=Resultat;
  //FSave.Close;
end;

initialization
  {$I u_save.lrs}

end.

