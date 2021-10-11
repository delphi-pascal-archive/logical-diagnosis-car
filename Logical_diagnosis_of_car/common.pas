unit Common; 

interface

uses
  Classes, SysUtils; 
  
const MAX_CMP = 64;
      CMP_Connecter=0;
      CMP_Deconnecter=1;
      CMP_Status=2;
      CMP_Configuration=3;
      CMP_Quitter=4;
      CMP_TestConnect=5;
      CMP_ConnectOK=6;
      CMP_5BdError=7;
      CMP_ToECU=8;
      CMP_SidError=9;
      CMP_MsgConfirm = 10;
      CMP_MsgOK = 11;
      CMP_Command =12;
      CMP_Send = 13;
      CMP_Receive = 14;
      CMP_NumberNotHex = 15;
      CMP_ValueNotHex=16;
      CMP_Error=17;
      CMP_ParamOutRange=18;
      CMP_ERRORNUMBERTABLE=19;
      CMP_ERRORLIGNETABLE=20;
      CMP_TableUnknow = 21;
      CMP_NoComPort = 22;
      CMP_Unknow = 23;
      CMP_Language = 24;
      CMP_SetCom =25;
      CMP_DefautLang=26;
      CMP_Save=27;
      CMP_Parametre=28;
      CMP_Value=29;
      CMP_Versus=30;
      CMP_DiagSpeed=31;
      CMP_ModeInformation=32;
      CMP_Tentative=33;
      CMP_Time_Ad=34;
      CMP_Time_Ad_Sync=35;
      CMP_Time_Sync_Key1=36;
      CMP_Time_Key1_Key2=37;
      CMP_Time_Key2b_Adb=38;
      CMP_Time_TO=39;
      CMP_TesterPresent=40;
      CMP_NoECUSelect = 41;
      CMP_ECU=42;
      CMP_Comport=43;
      CMP_SaveFile=44;
      CMP_Lecteur=45;
      CMP_FileList=46;
      CMP_FileName=47;
      CMP_FileType=48;
      CMP_Cancel=49;
      CMP_Close=50;
      CMP_OpenFile=51;
      CMP_HexaAdress=52;
      CMP_Name=53;
      CMP_PhysicalAdress=54;
      CMP_Length=55;
      CMP_Position=56;
      CMP_Fault=57;
      CMP_Min=58;
      CMP_Max=59;
      CMP_DecimalValue=60;
      CMP_WrongFile=61;
      CMP_Wait_1Req =62;
      CMP_Wait_Res_Req = 63;
      CMP_Open = 64;
      
      CT_AFFNONE =-1;
      CT_AFFGRID =0;
      CT_AFFCONFIRM =1;
      CT_AFFONEVALUE = 2;
      CT_AFFMULTIVALUE = 3;
      CT_AFFONEPARAMETER = 4;

var MenuI,Sous_menuI : integer;
    fichier_txt : TEXT;
    Repertoire_courant : string;
    Ad_Tools : byte;
    Nb_IOU : integer;
    Port_Com : string;
    MenuProg : Array[0..MAX_CMP] of string;
  
Function DecToHex(nb : integer):string;
Function HexToDec(hex : string):integer;
Procedure MenuTextInit;
Function StrToReel(str : string) : real;
Function ReelToStr(r : real) : string;
Function ReelToStrEx(r : real;nb_decimale : integer) : string;
Function StrReelStr(str : string) : String; // cette fonction transforme un nombre en décimale à virgule avec un point
Procedure ReadLanguage(langue : string);
Procedure WriteLanguage(langue : string);

implementation

uses uMain,Unit_Configuration;

var virgule : char;

Procedure detectvirgule;
var rrr : string;
begin
     rrr:=FloatToStr(1.1);
     virgule:=rrr[2];
end;

{*****************************************************************************}
{                            Fonction HexToDec                                }
{ Cette fonction permet de convertir un nombre decimal en hexadecimal         }
{*****************************************************************************}
Function HexToDec(hex : string):integer;
var i,j,nb1,nb2,nb3 : integer;
begin
     i:=length(hex);
     nb3:=1;
     for j:=1 to i-1 do nb3:=nb3*16;
     nb1:=0;
     try
     for j:=1 to i do
       begin
         case hex[j] of
           'A','a' : nb2:=10;
           'B','b' : nb2:=11;
           'C','c' : nb2:=12;
           'D','d' : nb2:=13;
           'E','e' : nb2:=14;
           'F','f' : nb2:=15;
           else nb2:=ord(hex[j])-ord('0'); //strtoint(hex[j]);
         end;
         if nb3>0 then nb2:=nb2*nb3;
         nb1:=nb1+nb2;
         nb3:=nb3 div 16;
       end;
     except
       nb1:=0;
     end;
     Hextodec:=nb1;
end;

{*****************************************************************************}
{                            Fonction dectohex                                }
{ Cette fonction permet de convertir un nombre decimal en hexadecimal         }
{*****************************************************************************}
Function DecToHex(nb : integer):string;
var nb1,nb2 : integer;
    txt,txt1:string;
begin
     nb1:=nb;
     txt:='';
     repeat
       if nb1>=16 then
        begin
          nb2:=nb1 mod 16;
          nb1:=nb1 div 16;
          case nb2 of
            10 : txt:='A'+txt;
            11 : txt:='B'+txt;
            12 : txt:='C'+txt;
            13 : txt:='D'+txt;
            14 : txt:='E'+txt;
            15 : txt:='F'+txt;
            else txt:=chr(nb2+ord('0'))+txt;
          end;
        end;
     until nb1<16;
     case nb1 of
       10 : txt1:='A';
       11 : txt1:='B';
       12 : txt1:='C';
       13 : txt1:='D';
       14 : txt1:='E';
       15 : txt1:='F';
       else txt1:=inttostr(nb1);
     end;
     txt:=txt1+txt;
     if (length(txt) mod 2)<>0 then txt:='0'+txt;
     DecToHex:=txt;
end;

//*******************************************************************
Procedure MenuTextInit;
begin
  MenuProg[CMP_Connecter]:='Connecter';
  MenuProg[CMP_Deconnecter]:='Deconnecter';
  MenuProg[CMP_Status]:='Status';
  MenuProg[CMP_Configuration]:='Configuration';
  MenuProg[CMP_Quitter]:='Quitter';
  MenuProg[CMP_TestConnect]:='Tentative de connection.';
  MenuProg[CMP_ConnectOK]:='Connection diagnostique OK';
  MenuProg[CMP_5BdError]:='Erreur de code à 5 bauds';
  MenuProg[CMP_ToECU]:='Time out du boitier.';
  MenuProg[CMP_SidError]:='Fonction Receive erreur de SID';
  MenuProg[CMP_MsgConfirm]:='La commande s''est bien passe';
  MenuProg[CMP_MsgOK]:='Confirmation';
  MenuProg[CMP_Command]:='Commande KWP';
  MenuProg[CMP_Send]:='Envoi a l''ECU';
  MenuProg[CMP_Receive]:='Recu de l''ECU';
  MenuProg[CMP_NumberNotHex]:='Votre numéro de paramétre n''est pas un nombre héxadécimal';
  MenuProg[CMP_ValueNotHex]:='Votre valeur de paramétre n''est pas un nombre décimal';
  MenuProg[CMP_Error]:='Erreur !';
  MenuProg[CMP_ParamOutRange]:='Votre numéro de paramétre n''est pas possible';
  MenuProg[CMP_ERRORNUMBERTABLE]:='Le numero de la table dans le fichier est mauvais';
  MenuProg[CMP_ERRORLIGNETABLE]:='Le numero de la ligne de la table dans le fichier est mauvais';
  MenuProg[CMP_TableUnknow]:='La table demandee n''hexiste pas';
  MenuProg[CMP_NoComPort]:='Vous n''avez pas de port serie RS232';
  MenuProg[CMP_Unknow]:='Indéfini';
  MenuProg[CMP_Language]:='Langues';
  MenuProg[CMP_SetCom]:='Configuration Communication';
  MenuProg[CMP_DefautLang]:='Langue par défaut';
  MenuProg[CMP_Save]:='Enregistrer';
  MenuProg[CMP_Parametre]:='Parametre';
  MenuProg[CMP_Value]:='Valeur';
  MenuProg[CMP_Versus]:='Version';
  MenuProg[CMP_DiagSpeed]:='Vitesse de diagnostique';
  MenuProg[CMP_ModeInformation]:='Mode de transmission';
  MenuProg[CMP_Tentative]:='Nombre de tentatives';
  MenuProg[CMP_Time_Ad]:='Duree de l''adresse';
  MenuProg[CMP_Time_Ad_Sync]:='Temps maxi entre l''adresse et la synchronisation';
  MenuProg[CMP_Time_Sync_Key1]:='Temps max entre la synchro et la clef 1';
  MenuProg[CMP_Time_Key1_Key2]:='Temps max entre la clef 1 et la clef 2';
  MenuProg[CMP_Time_Key2b_Adb]:='Temps max entre la clef2\ et l''adresse\';
  MenuProg[CMP_Time_TO]:='Temps max de Perte de communication';
  MenuProg[CMP_TesterPresent]:='Duree de maintient de communication';
  MenuProg[CMP_NoECUSelect]:='Vous devez selectionner un boitier';
  MenuProg[CMP_ECU]:='Boitiers';
  MenuProg[CMP_Comport]:='Port COM';
  MenuProg[CMP_SaveFile]:='Sauvegarde de fichier';
  MenuProg[CMP_Lecteur]:='Lecteur';
  MenuProg[CMP_FileList]:='Liste des fichiers';
  MenuProg[CMP_FileName]:='Nom du fichier';
  MenuProg[CMP_FileType]:='Type de fichier';
  MenuProg[CMP_Cancel]:='Annuler';
  MenuProg[CMP_Close]:='Fermer';
  MenuProg[CMP_OpenFile]:='Ouverture de fichier';
  MenuProg[CMP_HexaAdress]:='Adresse (hex.)';
  MenuProg[CMP_Name]:='Nom';
  MenuProg[CMP_PhysicalAdress]:='Adresse physique';
  MenuProg[CMP_Length]:='Taille';
  MenuProg[CMP_Position]:='Position';
  MenuProg[CMP_Fault]:='Défault';
  MenuProg[CMP_Min]:='MIN';
  menuProg[CMP_Max]:='MAX';
  MenuProg[CMP_DecimalValue]:='Valeur (déc.)';
  MenuProg[CMP_WrongFile]:='Le fichier n''est pas conforme.';
  MenuProg[CMP_Wait_1Req]:='Delai entre l''adresse\ et la première requete';
  MenuProg[CMP_Wait_Res_Req]:='Delai entre une reponse et une question';
  MenuProg[CMP_Open]:='Ouvrir';
end;

//*******************************************************************
Function StrToReel(str : string) : real;
var ist : integer;
    str1 : string;
begin
     try
        ist:=pos('.',str);
        if ist=0 then ist:=pos(',',str);
        str1:=str;
        if length(str)=0 then str1:='0';
        if ist>0 then str1[ist]:=virgule;
        StrToReel:=StrToFloat(str1);
     Except
        On E : Exception do StrToReel:=0;
     end;
end;

//*******************************************************************
Function ReelToStr(r : real) : string;
var txt : string;
    ist : integer;
begin
     try
        txt:=FloatToStr(r);
        ist:=pos(virgule,txt);
        if ist>0 then
           begin
                txt[ist]:=',';
                //if (ist+2<length(txt)) then txt:=copy(txt,1,ist+2);
                //while (ist+2>length(txt)) do txt:=txt+'0';
           end else
           begin
                //txt:=txt+',00';
           end;
        ReelToStr:=txt;
     except
       On E : Exception do ReelToStr:='';
     end;
end;

//*******************************************************************
Function ReelToStrEx(r : real;nb_decimale : integer) : string;
var txt : string;
    ist : integer;
begin
     try
        txt:=FloatToStr(r);
        ist:=pos(virgule,txt);
        if ist>0 then
           begin
                txt[ist]:=',';
                if (ist+nb_decimale<length(txt))
                   then txt:=copy(txt,1,ist+nb_decimale);
           end else
           begin
                txt:=txt+',00';
           end;
        ReelToStrEx:=txt;
     except
       On E : Exception do ReelToStrEx:='';
     end;
end;

//*******************************************************************
Function StrReelStr(str : string) : String;
var txt : string;
    ist : integer;
begin
     txt:=str;
     ist:=pos(virgule,txt);
     if ist>0 then txt[ist]:='.' else txt:=txt+'.0';
     StrReelStr:=txt;
end;

//*******************************************************************
Procedure ReadLanguage(langue : string);
var i : integer;
begin
  if FileExists(langue) then
    begin
      assignFile(Fichier_TXT,langue);
      reset(Fichier_TXT);
      i:=0;
      while (eof(fichier_txt)=false) and (i<=MAX_CMP) do
        begin
          readln(fichier_txt,MenuProg[i]);
          i:=i+1;
        end;
      CloseFile(Fichier_Txt);
    end;
end;

//*******************************************************************
Procedure WriteLanguage(langue : string);
var i : integer;
begin
  try
    assignFile(Fichier_TXT,langue);
    rewrite(Fichier_TXT);
    for i:=0 to MAX_CMP do writeln(fichier_txt,MenuProg[i]);
    CloseFile(Fichier_Txt);
  except
  end;
end;

//*******************************************************************
begin
     detectvirgule;
end.

