unit u_open;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, EditBtn, FileCtrl,Windows;

type

  { TFOpen }

  TFOpen = class(TForm)
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
  FOpen: TFOpen;

implementation

uses common;

{ TFOpen }

procedure TFOpen.FileListBox1DblClick(Sender: TObject);
var texte : string;
begin
  {
  ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftDirectory,
               ftArchive, ftNormal
  }
  if (FOpen.FileListBox1.FileType<>[ftDirectory])
     and (FOpen.FileListBox1.FileType<>[ftSystem])
     and (FOpen.FileListBox1.FileType<>[ftVolumeID])
     and (FileExists(FOpen.FileListBox1.FileName)) then
     begin
       FOpen.Edit1.Text:=FOpen.FileListBox1.FileName;
       FOpen.FileName:=FOpen.Edit1.Text;
       Resultat:=True;
       FOpen.Close;
     end;
end;

procedure TFOpen.FileListBox2DblClick(Sender: TObject);
var texte,texte1,texte2 : string;
    i : integer;
begin
  texte:=FOpen.FileListBox2.FileName;
  i:=length(texte);
  while (i>1) and (texte[i]<>'/')and(texte[i]<>'\') do i:=i-1;
  texte2:=copy(texte,1,i);// texte2 contient le répertoire de base
  texte1:=texte;
  delete(texte1,1,i); // texte1 contient le nom du répertoire
  if (texte1='[.]')
     or (texte1='[..]') then
     begin
       FOpen.Edit1.Text:=texte2;
       i:=length(texte2);
       if (copy(texte2,length(texte2),1)='\')
          or (copy(texte2,length(texte2),1)='/')
          then texte2:=copy(texte2,1,length(texte2)-1);
        while (i>1) and (texte2[i]<>'/')and(texte2[i]<>'\') do i:=i-1;
        if i=0 then exit;
        FOpen.FileListBox2.Directory:=copy(texte2,1,i-1);

     end else
     begin
       i:=pos('[',texte1);
       delete(texte1,i,1);
       i:=pos(']',texte1);
       delete(texte1,i,1);
       FOpen.FileListBox2.Directory:=texte2+texte1;
     end;
  FOpen.FileListBox1.Directory:=FOpen.FileListBox2.Directory;
end;

procedure TFOpen.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

//******************************************************************************
procedure TFOpen.FormCreate(Sender: TObject);
begin
  FOpen.enum_drive;
end;

//******************************************************************************
procedure TFOpen.enum_drive;
var num : integer;
    Bits : set of 0..25;
begin
  FOpen.ComboDrive.Clear;
  integer(Bits):=GetLogicalDrives;
  For num:=0 to 25 do
    begin
      if num in bits then FOpen.ComboDrive.Items.Add(chr(num+ord('A'))+':\');
    end;
end;

//******************************************************************************
procedure TFOpen.B_OKClick(Sender: TObject);
begin
  Resultat:=True;
  FOpen.Close;
end;

//******************************************************************************
procedure TFOpen.ComboDriveSelect(Sender: TObject);
begin
  FOpen.FileListBox2.Directory:=FOpen.ComboDrive.Text;
  FOpen.FileListBox1.Directory:=FOpen.FileListBox2.Directory;
end;

//******************************************************************************
procedure TFOpen.FileListBox1Click(Sender: TObject);
begin
  FOpen.Edit1.Text:=FOpen.FileListBox1.FileName;
  FOpen.FileName:=FOpen.Edit1.Text;
end;

//******************************************************************************
procedure TFOpen.B_AnnulerClick(Sender: TObject);
begin
  Resultat:=False;
  FOpen.Close;
end;

//******************************************************************************
function TFOpen.execute: boolean;
var texte : string;
    i : integer;
begin
  resultat:=false;
  FOpen.enum_drive;
  //FOpen.FileListBox1.FileName:=Application.ExeName;
  texte:=FOpen.FileListBox1.Directory;
  FOpen.FileListBox2.Directory:=texte;
  i:=1;
  while (i<=length(texte)) and (texte[i]<>'/') and (texte[i]<>'\') do i:=i+1;
  FOpen.ComboDrive.Text:=copy(texte,1,i);
  FOpen.Edit1.Text:='';
  //
  FOpen.Caption:=MenuProg[CMP_OpenFile];
  FOpen.GroupBox2.Caption:=MenuProg[CMP_Lecteur];
  Fopen.GroupBox1.Caption:=MenuProg[CMP_FileList];
  FOpen.Label1.Caption:=MenuProg[CMP_FileName];
  FOpen.B_Annuler.Caption:=MenuProg[CMP_Cancel];
  FOpen.B_OK.Caption:=MenuProg[CMP_Save];
  //
  Fopen.ShowModal;
  Result:=Resultat;
  //FOpen.Close;
end;

initialization
  {$I u_open.lrs}

end.

