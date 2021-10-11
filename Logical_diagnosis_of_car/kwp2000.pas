unit kwp2000;

interface

uses
  Classes, SysUtils, ExtCtrls, Forms,DateUtils,
  CPort;


Const CT_Version : string = '2.0.0';

      CT_ModeHM0 : byte =$00;
      CT_MODEHM1 : byte = $40;
      CT_ModeHM2 : Byte = $80;
      CT_ModeHM3 : Byte = $C0;
      
      CT_Interface_Dump =0;
      CT_Interface_ELM327 =1;
      
      ModeConnectStr : array[0..1] of string = ('5 BAUDS','FAST');
      CT_ModeConnect_5Bauds = 0;
      CT_ModeConnect_Fast = 1;
      // Sid

      CT_StartCommunication : byte = $81;
      CT_StopCommunication : byte = $82;
      CT_AccessCommunicationParameter : byte = $83;
      CT_StartDiagnosticSession : byte = $10;
      CT_ECUReset : byte = $11;
      CT_ReadFreezeFrameData : Byte=$12;
      CT_ReadDTCCodes = $13;
      CT_ClearDTC : Byte=$14;
      CT_ReadStatusOfDTC : Byte=$17;
      CT_ReadDTCByStatus : Byte=$18;
      CT_ReadECUId : byte = $1A;
      CT_StopDiagnosticSession : byte = $20;
      CT_ReadDataByLocalId : Byte=$21;
      CT_SecurityAccess : byte = $27;
      CT_IOControlByLocalId : Byte=$30;
      CT_StartRoutineByLocalId : Byte=$31;
      CT_StopRoutineByLocalId : Byte=$32;
      CT_RequestRoutineResultByLocalId : Byte=$33;
      CT_RequestDownload : byte = $34;
      CT_TransfertData : Byte = $36;
      CT_RequestTransfertExit : Byte = $37;
      CT_WriteDataByLocalId : Byte=$3B;
      CT_TesterPresent : Byte = $3E;

      // Code de réponse
      CT_NACK : byte = $7F;
      CT_GeneralReject : byte = $10;
      CT_ServiceNotSupported : byte = $11;
      CT_RequestedSequenceError : byte =$22;
      CT_RoutineNotComplete : byte = $23;
      CT_RequestOutOfRange : byte = $31;
      CT_SecurityAccessDenied : byte = $33;
      CT_InvalidKey : byte = $35;
      CT_IllegalAdressInBlockTransfert : byte = $74;
      CT_ReqCorrectlyRcvd_RspPending : byte = $78;
      CT_FlashAccessFailure : byte = $81;
      
      // Code d'erreur
      Err_Connect  = $01;
      Err_COM      = $02;
      Err_LRC      = $03;
      Err_5Baud    = $04;
      Err_TO       = $05;
      
      // Message normaux
      CT_ReceiveEmit = $06;
      CT_TestNumber = $07;
      CT_SendFrame = $08;
      CT_EndCommunication =$09;
      CT_Start5baud = $0a;
      CT_EndConnection = $0b;
      CT_ConnectCOMOK = $0C;
      CT_SendTesterPresent = $0D;
      CT_TestConnectELM = $0E;

type

TProgress = Procedure(Sender : TObject; Pourcent : integer; Msg : String) of Object;
TDoStep = Procedure(Sender : TObject; Messages : string) of object;
TDoErrorEvent = Procedure(Sender : TObject; Erreur : integer;MsgErreur : string) of object;
TData = Array[0..68] of byte;
TModeKWP = (HM0,HM1,HM2,HM3);
TTypeInterface = (DUMP,ELM327);
TProtocoleELM = (pro_J1850_PWM,pro_J1850_VPW,pro_CAN,pro_ISO14230);
     
{ TKWP2000 }

TKWP2000 = class(TComponent)
Private
  FExitAttente : boolean;
  FVersion : string;
  FRequestDiag : Boolean; // Valeur permettant de savoir si on a engagé une requete de diag ou non
  FDiagRunning : boolean; // Valeur indiquant si on est dans une session de diag
  FFmt : byte; // Octet de format
  FLengthInFmt : Boolean; // Taille dans l'octet de format
  FAddLength : Boolean; // Octet additionnel de taille de trame
  FByteHeader : Boolean; // 1Byte header supported or not
  FTgtSrcHeader : Boolean; // Target and source address supported
  FTimingParameterSet : Boolean; //Normal timing=False or extended timing=True
  FTgt : byte; // adresse du boitier de destinantion
  FSrc : byte; // adresse du boitier emmeteur (nous)
  FSid : byte; // Service demandé
  FSid_Debug : byte; // passage du boitier en debug ou non (debug -> sous sid =$DE sinon $FF)
  FSendModeInfo : Byte; // Mode de transmission seul le mode HM2 est implémenté
  FSendModeInfoIde : TModeKWP;
  FComport : TComport;
  FReceiveTrame : TNotifyEvent;
  FDoError : TDoErrorEvent;
  FDoConnect : TNotifyEvent;
  FDoDisconnect : TNotifyEvent;
  FDoStatus : TDoStep;
  FDoStep : TDoStep;
  FProgress : TProgress;
  FSpeed : longint;
  etat_communication : integer; // permet de connaitre dans quel phase on se trouve
  Timer_TO : TTimer;
  Timer_Ma : TTimer;
  FMax_Tentative : integer;
  FNb_Tentative : integer;
  Fnb_OctetsTransmis : integer;
  FRx : TData;
  FNbRx : integer;
  FTpsMa : integer;
  FNb_Error : integer;
  FError : integer;
  FFichierTXT : TEXT;
  FFichierUpload : TStringList;
  FTimeAd : integer;
  FTime_Ad_Sync : integer;
  FTime_Sync_Key1 : integer;
  FTime_Key1_Key2 : integer;
  FTime_Key2b_Adb : integer;
  FTime_TO : integer;
  FWait_1Req : integer;
  FWait_Response_Request : integer;
  FMessageTXT : TStringList;
  FDelaySending : TDateTime;
  FTypeInterface : integer;
  FProtocoleELM : TProtocoleELM;

  procedure FComPortRxChar(Sender: TObject; Count: Integer);
  procedure SetComPort(const Value: TComPort);
  procedure Timer_TOTimer(Sender: TObject);
  procedure Timer_MATimer(Sender : TObject);
  procedure Error_5Bauds;
  procedure Error_Fast;
  Function DecToHex(nb : integer):string;
  Procedure TransmitTrameTx;
  Procedure FComportTxEmpty(Sender : TObject);
  Procedure attendre(temps : integer);
  Procedure SetModeInfo(Value : TModeKWP);
  function GetModeInfo : TModeKWP;
  Procedure InitMessageTXT;
  function GetTypeInterface : TTypeInterface;
  Procedure SetTypeInterface(Type_Interface : TTypeInterface);
  Function TypeInterfaceToStr(Type_Interface : TTypeInterface):string;
  Function StrToTypeInterface(TypeInterfaceSTR : string): TTypeInterface;
  Procedure ELMRxChar(count : integer);
  Procedure DumpRxChar(count : integer);
  Procedure SendResponseDump;
  Procedure SendResponseELM327;
  Procedure CustomStartELM;
  Procedure CustomStopELM;
  Function ProtocoleELMToString(Protocole : TProtocoleELM) : string;
  Function StringToProtocoleELM(ProtocoleSTR : string) : TProtocoleELM;
Protected
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
Public
  FNb_octetTx : byte; // nombre d'octet dans la trame
  FNb_OctetRx : Byte;
  SidReceive : byte;
  TgtReceive : byte;
  SrcReceive : byte;
  TrameTx : TData;      //FtrameTx
  TrameRx : TData;      //FTrameRx
  ReceiveLength : byte;   //FNb_Data
  SendLength : Byte; // length of message;
  FData : TData;
  CanSend : boolean;
  Download : boolean;
  EndReceive : boolean;
  Time_ELMReset : integer;
  ModeConnection : integer;
  ELM_CANBIT : integer;
  ELM_CANSpeed : integer;
  Msg_TesterPresent : string;
  constructor Create(AOwner : TComponent);override;
  destructor Destroy; override;
  Procedure Connect; // Connecte le port série et attend en esclave
  Procedure Close; // Libére le port série
  Procedure StartDiagnosis(Session_Type : byte);  // Si on est en mode maitre, entame la transaction sinon attend en esclave avant de transmettre
  Procedure StopDiagnosis; // On arrete le diagnostic
  Procedure Startdebug;  // passage du boitier en mode debug
  Procedure CustomStart;
  Procedure CustomStop;
  Procedure SendResponse; // envoi des données contenu dans FData
  function Cancel : integer; // Annule la transaction
  Function LoadConfiguration(FileName : string): boolean;
  Function SaveConfiguration(FileName : string): boolean;
  Function ModeInfoToStr(ModeInf : TModeKWP): string;
  Function StrToModeInfo(StrModeInf : string): TModeKWP;
  function LoadMessageTXT(MessageFile : string):Boolean;
  function SaveMessageTXT(MessageFile : string):Boolean;
Published
  property Comport : TComport read FComport write setComport;
  property Interface_Type : TTypeInterface read GetTypeInterface Write SetTypeInterface;
  Property Mode_Information : TModeKWP read GetModeInfo;// write SetModeInfo;  I don't have the 14230-2 layer completly
  Property Target : byte read FTgt write FTgt;
  property Source : byte read FSrc write FSrc;
  property Sid : byte read FSid write FSid;
  property DiagnosticSpeed : longint read FSpeed write FSpeed;
  property Tentative : integer read FMax_tentative write FMax_tentative;
  property Tps_Maintient : integer read FTpsMa write FTpsMa;
  property Time_Ad : integer read FTimeAd write FTimeAd;
  property Time_Ad_Sync : integer read FTime_Ad_Sync write FTime_Ad_Sync;
  property Time_Sync_Key1 : integer read FTime_Sync_Key1 write FTime_Sync_Key1;
  property Time_Key1_Key2 : integer read FTime_Key1_Key2 write FTime_Key1_Key2;
  property Time_Key2b_Adb : integer read FTime_Key2b_Adb write FTime_Key2b_Adb;
  property Time_TO : integer read FTime_TO write FTime_TO;
  Property Wait_1Req : integer read FWait_1Req write FWait_1Req;
  Property Wait_Response_Request : integer read FWait_Response_Request write FWait_Response_Request;
  property Version : string read FVersion;
  property OnReceiveTrame : TNotifyEvent read FReceiveTrame write FReceiveTrame;
  property OnError : TDoErrorEvent read FDoError write FDoError;
  property OnStep : TDoStep read FDoStep write FDoStep;
  property OnConnect : TNotifyEvent read FDoConnect write FDoConnect;
  property OnDisconnect : TNotifyEvent read FDoDisconnect write FDoDisconnect;
  property OnStatus : TDoStep read FDoStatus write FDoStatus;
end;

implementation



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
     for j:=1 to i do
         begin
              case hex[j] of
              'A' : nb2:=10;
              'B' : nb2:=11;
              'C' : nb2:=12;
              'D' : nb2:=13;
              'E' : nb2:=14;
              'F' : nb2:=15;
              else nb2:=strtoint(hex[j]);
              end;
              if nb3>0 then nb2:=nb2*nb3;
              nb1:=nb1+nb2;
              nb3:=nb3 div 16;
         end;
     Hextodec:=nb1;
end;

{*****************************************************************************}
{                            Fonction dectohex                                }
{ Cette fonction permet de convertir un nombre decimal en hexadecimal         }
{*****************************************************************************}
Function TKWP2000.DecToHex(nb : integer):string;
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
                    else txt:=inttostr(nb2)+txt;
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

//******************************************************************************
procedure TKWP2000.TransmitTrameTx;
var i : integer;
begin
  for i:=0 to FNb_OctetTx-1 do
      begin
        FComport.TransmitChar(chr(TrameTx[i]));
        Attendre(50);
      end;
end;

//******************************************************************************
procedure TKWP2000.FComportTxEmpty(Sender : TObject);
begin
  //FComport.Events:=[evRxChar,evTxEmpty,evRxFlag,evRing,evBreak,evCTS,evDSR,evError,evRLSD];
end;

//******************************************************************************
procedure TKWP2000.attendre(temps: integer);
var date1 : TDateTime;
begin
  FExitAttente:=False;
  date1:=IncMilliSecond(Now,temps);
  while (CompareDateTime(Date1,Now)=1)
        and (FExitAttente=False) do Application.ProcessMessages;
end;

//******************************************************************************
procedure TKWP2000.SetModeInfo(Value: TModeKWP);
begin
  if Value=HM0 then FSendModeInfo:=CT_ModeHM0;
  if Value=HM1 then FSendModeInfo:=CT_ModeHM1;
  if Value=HM2 then FSendModeInfo:=CT_ModeHM2;
  if Value=HM3 then FSendModeInfo:=CT_ModeHM3;
end;

//******************************************************************************
function TKWP2000.GetModeInfo: TModeKWP;
begin
  if FSendModeInfo=CT_ModeHM0 then Result:=HM0;
  if FSendModeInfo=CT_ModeHM1 then Result:=HM1;
  if FSendModeInfo=CT_ModeHM2 then Result:=HM2;
  if FSendModeInfo=CT_ModeHM3 then Result:=HM3;
end;

//******************************************************************************
procedure TKWP2000.InitMessageTXT;
begin
  {
  Err_Connect  = $01;
  Err_COM      = $02;
  Err_LRC      = $03;
  Err_5Baud    = $04;
  Err_TO       = $05;
  }
  FMessageTXT.Add('Pas d''erreur');
  FMessageTXT.Add('Erreur de connection au port COM');
  FMessageTXT.Add('Aucun composant de port COM référencé');
  FMessageTXT.Add('Erreur de CheckSum');
  FMessageTXT.Add('Erreur de code à 5 bauds');
  FMessageTXT.Add('Erreur de Time out');
  FMessageTXT.Add('Reception de la trame émise');
  FMessageTXT.Add('Tentative n°');
  FMessageTXT.Add('Envoi trame SendResponse=');
  FMessageTXT.Add('Fin de communication.');
  FMessageTXT.Add('Début de code à 5 bauds');
  FMessageTXT.Add('Connection terminée.');
  FMessageTXT.Add('Connection au port COM - OK');
  FMessageTXT.Add('Envoi trame de maintient');
  FMessageTXT.Add('Test connection ELM 327');
end;

//******************************************************************************
function TKWP2000.GetTypeInterface: TTypeInterface;
begin
  if FTypeInterface=CT_Interface_Dump then Result:=DUMP;
  if FTypeInterface=CT_Interface_ELM327 then Result:=ELM327;
end;

//******************************************************************************
procedure TKWP2000.SetTypeInterface(Type_Interface: TTypeInterface);
begin
  if Type_Interface=DUMP then FTypeInterface:=CT_Interface_Dump;
  if Type_Interface=ELM327 then FTypeInterface:=CT_Interface_ELM327;
end;

//******************************************************************************
function TKWP2000.TypeInterfaceToStr(Type_Interface: TTypeInterface): string;
begin
  if Type_Interface=DUMP then Result:='DUMP';
  if Type_Interface=ELM327 then Result:='ELM327';
end;

//******************************************************************************
function TKWP2000.StrToTypeInterface(TypeInterfaceSTR: string): TTypeInterface;
begin
  if TypeInterfaceSTR='DUMP' then Result:=Dump;
  if TypeInterfaceSTR='ELM327' then Result:=ELM327;
end;

//******************************************************************************
procedure TKWP2000.ELMRxChar(count: integer);
var i,j : integer;
    texte : string;
begin
  FComport.ReadStr(texte,count);
  if Assigned(FDoStep)
     then FDoStep(Self,'Trame Recu vraie :'+texte);
  case etat_communication of
    1 : begin
      if pos('ELM327',texte)>0 then
        begin
          etat_communication:=2; // we set the header
          // Setting of the ELM
          texte:='AT SH A8'+decTohex(FTgt)+' '+dectohex(FSrc);
          Fcomport.WriteStr(texte);
          if Assigned(FDoStep) then FDoStep(Self,'Send header request : '+texte);
        end else // end of if pos('ELM327',texte)>0 then
        begin    // if pos('ELM327',texte)=0 then
          // we send an error message to the application
          
        end;     // end of if pos('ELM327',texte)<=0 then
    end; // end of cas N°1
    2 : begin
      if copy(texte,1,2)='OK' then
        begin
          etat_communication:=3; // we select the protocol
          texte:='';
          if FProtocoleELM=pro_J1850_PWM then texte:='AT SP 1';
          if FProtocoleELM=pro_J1850_VPW then texte:='AT SP 2';
          if (FProtocoleELM=pro_ISO14230)
             and (ModeConnection=CT_ModeConnect_5bauds) then texte:='AT SP 4';
          if (FProtocoleELM=pro_ISO14230)
             and (ModeConnection=CT_ModeConnect_FAST) then texte:='AT SP 5';
          if (FProtocoleELM=pro_CAN)
             and (ELM_CANBIT=11)
             and (ELM_CANSPEED=500) then texte:='AT SP 6';
          if (FProtocoleELM=pro_CAN)
             and (ELM_CANBIT=29)
             and (ELM_CANSPEED=500) then texte:='AT SP 7';
          if (FProtocoleELM=pro_CAN)
             and (ELM_CANBIT=11)
             and (ELM_CANSPEED=250) then texte:='AT SP 8';
          if (FProtocoleELM=pro_CAN)
             and (ELM_CANBIT=29)
             and (ELM_CANSPEED=250) then texte:='AT SP 9';
          if length(texte)>0 then
            begin
              // we send the value
              Fcomport.WriteStr(texte);
              if Assigned(FDoStep) then FDoStep(Self,'Send Protocole request : '+texte);
            end else
            begin
              // error in header
              if assigned(FDoError) then FDoError(Self,Err_LRC,FMessageTXT.Strings[Err_LRC]);
            end;
        end else
        begin
          // Error the protocol isn't perform
          if assigned(FDoError) then FDoError(Self,Err_LRC,FMessageTXT.Strings[Err_LRC]);
        end;
    end; // end of cas N°2
    3 : begin
      if copy(texte,1,2)='OK' then
        begin
          etat_communication:=4; // passage fonctionnement normal
          CanSend:=True;
          if Assigned(FDoConnect) then FDoConnect(Self);
          if Assigned(FDoStep) then FDoStep(Self,'Connection OK : '+texte);
        end else
        begin
          // erreur de connection
          if assigned(FDoError) then FDoError(Self,Err_LRC,FMessageTXT.Strings[Err_LRC]);
        end;
    end; // end of cas N°3
    4 : begin
      // we delete space char
      Timer_TO.Enabled:=False;
      repeat
        i:=pos(' ',texte);
        if i>0 then delete(texte,i,1);
      until i=0;
      j:=0;
      i:=1;
      texte:=uppercase(texte);
      while (i<length(texte))and (j=0)  do
        begin
          if ((texte[i]>'F') or (texte[i]<'A'))
             and ((texte[i]<'0') or (texte[i]>'9')) then j:=1;
        end;
      if j=0 then
        begin
          SidReceive:=hextodec(copy(texte,1,2));
          delete(texte,1,2);
          ReceiveLength:=0;
          while length(texte)>0 do
            begin
              TrameRx[ReceiveLength]:=hextodec(copy(texte,1,2));
              delete(texte,1,2);
              ReceiveLength:=ReceiveLength+1;
            end;
          CanSend:=True;
          if Assigned(FReceiveTrame) then FReceiveTrame(Self);
        end else
        begin
          if assigned(FDoError) then FDoError(Self,Err_LRC,FMessageTXT.Strings[Err_LRC]);
        end;
    end; // end of cas N°4
  end;  // end of case etat_communication then
end;

//******************************************************************************
procedure TKWP2000.DumpRxChar(count : integer);
const CT_NoAction = 0;
      CT_Connect = 1;
      CT_Receive = 2;
var i : integer;
    octet,octet1: byte;
    texte : string;
    BufferTmp : array[0..100] of byte;
    nb_buffertmp : integer;
    nb_ByteForReceive : integer;
    Debut_Data : integer;
    type_action : integer;
begin
  type_action:=CT_NoAction;
  FComport.Read(Buffertmp,Count);
  nb_BufferTMP:=Count;
  //Timer_TO.Enabled:=False; // On arrête le timer de time Out
  texte:='';
  for i:=0 to nb_BufferTMP-1 do
      texte:=texte+' '+dectohex(buffertmp[i]);
  if Assigned(FDoStep)
     then FDoStep(Self,'Trame Recu vraie :'+texte);
  texte:='';
  for i:=0 to nb_BufferTMP-1 do
      texte:=texte+' '+dectohex(buffertmp[i]);
  if Assigned(FDoStep)
     then FDoStep(Self,'Trame Recu avant traitement :'+texte);
  if Assigned(FDoStep) then
     FDoStep(Self,'Etat communication='+inttostr(etat_communication));
  if etat_communication=5 then
    begin // Etat specifique en fast connect après une demande de connection
        // On a recu les Key1 et Key2
        // On fait une demande de diagnostique
        if Buffertmp[0]<>0 then
          begin
            if (BufferTmp[1]<>FTgt) then
              begin
                CanSend:=True;
                Timer_TO.Interval:=Time_TO;
                Timer_TO.Enabled:=True;
                SendResponse;
                etat_communication:=4;
                exit;
              end;
          end else
          begin
            if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_ReceiveEmit]);
            exit;
          end;
      end;

  if etat_communication=1 then
    begin
      octet:=0;
      for i:=0 to nb_BufferTMP-1 do
        if buffertmp[i]=$55 then octet:=1;
      if octet=0 then exit;
    end;
  if (etat_communication=3)then
    begin
      octet:=0;
      for i:=0 to nb_BufferTMP-1 do
        if buffertmp[i]=not(Ftgt) then octet:=1;
      if octet=0 then exit;
    end;

  case etat_communication of
    1 : begin // On a envoyé le code de l'UCE et on s'attend à ce qu'il réponde  au moins 3 octets
          texte:='';
          for i:=0 to nb_BufferTMP-1 do texte:=texte+' '+dectohex(buffertmp[i]);
          if Assigned(FDoStep) then FDoStep(Self,'Trame Recu etat=1:'+texte);
          Timer_TO.Enabled:=False; // On arrête le timer de time Out
          if nb_BufferTMP=3 then
            begin
              // Vérification des 3 octets
              if (BufferTmp[0]=$55)
                and ((BufferTmp[1]=$D5)
                     or (BufferTmp[1]=$D6)
                     or (BufferTmp[1]=$57)
                     or (BufferTmp[1]=$D9)
                     or (BufferTmp[1]=$DA)
                     or (BufferTmp[1]=$5B)
                     or (BufferTmp[1]=$5D)
                     or (BufferTmp[1]=$5E)
                     or (BufferTmp[1]=$DF)
                     or (BufferTmp[1]=$E5)
                     or (BufferTmp[1]=$E6)
                     or (BufferTmp[1]=$67)
                     or (BufferTmp[1]=$E9)
                     or (BufferTmp[1]=$EA)
                     or (BufferTmp[1]=$6B)
                     or (BufferTmp[1]=$6D)
                     or (BufferTmp[1]=$6E)
                     or (BufferTmp[1]=$EF))
                and (BufferTmp[2]=$8F) then
                begin
                  //FLengthInFmt : Boolean; // Taille dans l'octet de format
                  //FAddLength : Boolean; // Octet additionnel de taille de trame
                  //FByteHeader : Boolean; // 1Byte header supported or not
                  //FTgtSrcHeader : Boolean; // Target and source address supported
                  //FTimingParameterSet : Boolean; //Normal timing=False or extended timing=True
                  if (BufferTmp[1] and $01=$01) then FLengthInFmt:=true else FLengthInFmt:=False; // Taille dans l'octet de format
                  if (BufferTmp[1] and $02=$02) then FAddLength := true else FAddLength:=False; // Octet additionnel de taille de trame
                  if (BufferTmp[1] and $04=$04) then FByteHeader := True else FByteHeader := False; // 1Byte header supported or not
                  if (BufferTmp[1] and $08=$08) then FTgtSrcHeader :=True else FTgtSrcHeader :=False; // Target and source address supported
                  if (BufferTmp[1] and $10=$10) then FTimingParameterSet :=True else FTimingParameterSet :=False; //Normal timing=False or extended timing=True
                  etat_communication:=3;
                  TrameTx[0]:=$70;
                  FNb_OctetsTransmis:=1;
                  FComport.Write(TrameTx,1);
                  Timer_To.Interval:=FTime_Key2b_Adb;
                  Timer_To.Enabled:=True;
                end else Error_5Bauds;
            end else
            begin
              etat_communication:=2;
              FNb_OctetRx:=nb_BufferTMP;
              for i:=0 to nb_BufferTMP-1 do TrameRx[i]:=BufferTmp[i];
            end;
        end;
    2 : begin
          // etat d'attente
          for i:=0 to nb_BufferTMP-1 do TrameRx[i+FNb_OctetRx]:=BufferTMP[i];
          Timer_TO.Enabled:=False; // On arrête le timer de time Out
          FNb_OctetRx:=FNb_OctetRx+nb_BufferTMP;
          texte:='';
          for i:=0 to nb_BufferTMP-1 do texte:=texte+' '+dectohex(BufferTmp[i]);
          if Assigned(FDoStep) then FDoStep(Self,'Trame Recu etat=2:'+texte);
          if FNb_OctetRx>=3 then
            begin
              if (TrameRx[0]=$55)
                and ((TrameRx[1]=$D5)
                     or (TrameRx[1]=$D6)
                     or (TrameRx[1]=$57)
                     or (TrameRx[1]=$D9)
                     or (TrameRx[1]=$DA)
                     or (TrameRx[1]=$5B)
                     or (TrameRx[1]=$5D)
                     or (TrameRx[1]=$5E)
                     or (TrameRx[1]=$DF)
                     or (TrameRx[1]=$E5)
                     or (TrameRx[1]=$E6)
                     or (TrameRx[1]=$67)
                     or (TrameRx[1]=$E9)
                     or (TrameRx[1]=$EA)
                     or (TrameRx[1]=$6B)
                     or (TrameRx[1]=$6D)
                     or (TrameRx[1]=$6E)
                     or (TrameRx[1]=$EF))
                and (TrameRx[2]=$8F) then
                begin
                  if (TrameRx[1] and $01=$01) then FLengthInFmt:=true else FLengthInFmt:=False; // Taille dans l'octet de format
                  if (TrameRx[1] and $02=$02) then FAddLength := true else FAddLength:=False; // Octet additionnel de taille de trame
                  if (TrameRx[1] and $04=$04) then FByteHeader := True else FByteHeader := False; // 1Byte header supported or not
                  if (TrameRx[1] and $08=$08) then FTgtSrcHeader :=True else FTgtSrcHeader :=False; // Target and source address supported
                  if (TrameRx[1] and $10=$10) then FTimingParameterSet :=True else FTimingParameterSet :=False; //Normal timing=False or extended timing=True
                  if Assigned(FDoStep) then FDoStep(Self,'Passage Etat 3');
                  etat_communication:=3;
                  TrameTx[0]:=$70;
                  FNb_OctetsTransmis:=1;
                  FComport.Write(TrameTx,1);
                  Timer_To.Interval:=FTime_Key2b_Adb;
                  Timer_To.Enabled:=True;
                end else Error_5Bauds;
            end else
            begin
              Timer_To.Interval:=1000;
              Timer_To.Enabled:=True;
            end;
        end;
    3 : begin // On a répondu avec $70
          texte:='';
          for i:=0 to nb_BufferTMP-1 do texte:=texte+' '+dectohex(BufferTmp[i]);
          Timer_TO.Enabled:=False; // On arrête le timer de time Out
          if Assigned(FDoStep) then FDoStep(Self,'Trame Recu etat=3:'+texte);
          if Buffertmp[0]=not(Ftgt) then // le boitier a bien répondu par son adresse complémentée
            begin
              // Demande de Communication
              if Assigned(FDoStep) then FDoStep(Self,'Passage Etat 4');
              //Creation_trame_requete; // On envoi la trame de requette d'ouverture de session
              Attendre(FWait_1Req);
              //FNb_OctetsTransmis:=FNb_OctetTx;
              //FComport.Write(TrameTx,FNb_OctetTx); // On envoi la trame de requete
              SendResponse;
              FComport.CustomBaudRate:=FSpeed;
              Timer_To.Interval:=FTime_TO;
              Timer_To.Enabled:=True;
              if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'State 3 TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'state 3 TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
              etat_communication:=4;
              //if Assigned(FDoConnect) then FDoConnect(Self);
              FNb_OctetRx:=0;
            end else Error_5Bauds;
        end;
    4 : begin // Attente réponse Boitier aprés début de communication et suivante
          FDelaySending:=Now;
          Timer_TO.Enabled:=False; // On arrête le timer de time Out
          if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'State 4 TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'State 4 TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
          texte:='';
          for i:=0 to nb_BufferTMP-1 do texte:=texte+' '+dectohex(BufferTmp[i]);
          if Assigned(FDoStep) then FDoStep(Self,'Trame Recu bufferTMP etat=4:'+texte);
          for i:=0 to nb_BufferTMP-1 do FRx[i+FNbRx]:=BufferTmp[i];
          FNbRx:=FNbRx+nb_BufferTMP;
          octet:=FRx[0];
          octet:=octet and $3f;
          Debut_data:=4;
          if octet=0 then
            begin
              octet:=FRx[3]+1;   // Attention HM2 code
              Debut_Data:=5;
            end;
          texte:='';
          for i:=0 to nb_BufferTMP-1 do texte:=texte+' '+dectohex(FRx[i]);
          if Assigned(FDoStep) then FDoStep(Self,'Trame traité FRx etat=4:'+texte+'- octet='+inttostr(octet)+' FNb_OctetRx='+inttostr(FNbRx));
          While FNbRx>=octet+4 Do         // Attention HM2 code
            begin
              texte:='';
              for i:=0 to octet+3 do texte:=texte+' '+dectohex(FRx[i]);
              if Assigned(FDoStep) then FDoStep(Self,'Trame traité FRx avec Nb_Rx>nb_octet+4 sous etat=4:'+texte+'- octet='+inttostr(octet)+' FNb_OctetRx='+inttostr(octet+4));
              octet1:=0;
              for i:=0 to octet+2 do octet1:=octet1+FRx[i]; // calcul du crc
              if FRx[Octet+3]=octet1 then
                begin
                  if Assigned(FDoStep) then FDoStep(Self,'Bon CRC');
                  if Assigned(FReceiveTrame) then
                    begin
                      for i:=0 to octet+3 do TrameRx[i]:=FRx[i];
                      FNb_OctetRx:=octet+4;
                      if (TrameRx[1]=FSrc)
                        and (TrameRx[2]=FTgt) then
                        begin
                          if Assigned(FDoStep) then FDoStep(Self,'Bon boitier');
                          Attendre(20); // attente pour faire souffler le boitier en diag
                          EndReceive:=False;
                          if Assigned(FDoStep) then FDoStep(Self,'On a attendu');
                          // On remplit les infos de réception
                          octet:=FRx[0];
                          octet:=octet and $3f;
                          Debut_data:=4;
                          if octet=0 then
                            begin
                              octet:=FRx[3]+1;   // Attention HM2 code
                              Debut_Data:=5;
                            end;
                          SidReceive:=TrameRx[Debut_Data-1];
                          TgtReceive := TrameRx[1];
                          SrcReceive := TrameRx[2];
                          ReceiveLength:=FNb_OctetRx;
                          for i:=Debut_Data to ReceiveLength-2 do
                            TrameRx[i-Debut_Data]:=TrameRx[i];
                          ReceiveLength:=ReceiveLength-Debut_Data-1;
                          // On lance la procedure de réception
                          Timer_Ma.Interval:=FTpsMa;
                          Timer_Ma.Enabled:=True;
                          Timer_TO.Interval:=Time_TO;
                          Timer_TO.Enabled:=True;
                          if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'State 4-1 TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'State 4-1 TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
                          if SidReceive=CT_StartDiagnosticSession+$40
                            then type_action:=CT_Connect
                            else type_action:=CT_Receive;

                        end else  // end of if (TrameRx[1]=FSrc) and (TrameRx[2]=FTgt) then
                        begin
                          Timer_TO.Interval:=FTime_TO;
                          Timer_TO.Enabled:=True;
                          if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'State 4-2 TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'State 4-2 TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
                          if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_ReceiveEmit]);
                        end;
                    end;  // end of if Assigned(FReceiveTrame) then
                end else  // end of if FRx[Octet+3]=octet1 then
                  if assigned(FDoError) then FDoError(Self,Err_LRC,FMessageTXT.Strings[Err_LRC]+' (CRC='+dectohex(TrameRx[Octet+1])+' CRC octet1='+dectohex(octet1));
                // On efface les anciennes données
                octet:=FRx[0];
                octet:=octet and $3f;
                if octet=0 then
                  begin
                    octet:=FRx[3]+1;   // Attention HM2 code
                  end;
                For i:=octet+4 to FNbRx-1 do
                  FRx[i-(octet+4)]:=FRx[i];
                FNbRx:=FNbRx-(octet+4);
                if FNbRx>=octet+4 then
                  begin
                    octet:=FRx[0];
                    octet:=octet and $3f;
                    if octet=0 then
                      begin
                        octet:=FRx[3]+1;   // Attention HM2 code
                      end;
                  end;
                texte:='';
                for i:=0 to FNbRx-1 do texte:=texte+' '+dectohex(FRx[i]);
                if Assigned(FDoStep) then FDoStep(Self,'Step END : Ap Buffer sous etat=4:'+texte+'- octet='+inttostr(octet)+' FNbRx='+inttostr(FNbRx));
                EndReceive:=True;

                if type_Action=CT_Receive then
                  begin
                    CanSend:=True;
                    if Assigned(FReceiveTrame) then FReceiveTrame(Self);
                  end else
                if type_Action=CT_Connect then
                  begin
                    CanSend:=True;
                    if Assigned(FDoConnect) then FDoConnect(Self);
                  end;
            end;
       end;
    end;
  if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'End RX - TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
end;

//******************************************************************************
procedure TKWP2000.CustomStartELM;
begin
  if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_TestConnectELM]);
  if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_TestConnectELM]);
  FRequestDiag:=True;
  FComport.CustomBaudRate:=9600; // démarage du code à 5 baud
  FComport.Parity.Bits:=prNone;
  FComport.Parity.Check:=False;
  FComport.StopBits:=sbOneStopBit;
  etat_communication :=1;
  TrameTx[0]:=ord('A');
  TrameTx[1]:=ord('T');
  TrameTx[2]:=ord('Z');
  TrameTx[3]:=$13;
  FComport.Write(TrameTx,4); // On envoi le code de l'UCE
  Timer_TO.Interval:=Time_ELMReset; // T1 de 300ms avant pb
  Timer_TO.Enabled:=True;
  if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'Custom startc TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'Custom start TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
  FNb_tentative:=0;
end;

//******************************************************************************
procedure TKWP2000.CustomStopELM;
begin

end;

//******************************************************************************
function TKWP2000.ProtocoleELMToString(Protocole: TProtocoleELM): string;
begin
  result:='ISO14230';
  if Protocole=pro_J1850_PWM then result:='J1850_PWM';
  if Protocole=pro_J1850_VPW then result:='J1850_VPW';
  if Protocole=pro_CAN then result:='DIAGONCAN';
  if Protocole=pro_ISO14230 then result:='ISO14230';
end;

//******************************************************************************
function TKWP2000.StringToProtocoleELM(ProtocoleSTR: string): TProtocoleELM;
var texte:string;
begin
  texte:=uppercase(ProtocoleSTR);
  texte:=trim(texte);
  Result:=FProtocoleELM;
  if texte='J1850_PWM' then Result:=pro_J1850_PWM;
  if texte='J1850_VPW' then Result:=pro_J1850_VPW;
  if texte='DIAGONCAN' then Result:=pro_CAN;
  if texte='ISO14230' then Result:=pro_ISO14230;
end;

//******************************************************************************
constructor TKWP2000.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  // Creation des composants
  Timer_TO:=TTimer.Create(Self);
  Timer_Ma:=TTimer.Create(Self);
  Timer_TO.OnTimer:=Timer_TOTimer;
  Timer_Ma.OnTimer:=Timer_MaTimer;
  if Fcomport<>nil then
     begin
       FComport.OnRxChar:=FComPortRxChar;
     end;
  FFichierUpload:=TStringList.Create;
  FMessageTXT:=TStringList.Create;
  Timer_Ma.Enabled:=False;
  Timer_Ma.Interval:=FTpsMa;
  FReceiveTrame:=nil;
  FRequestDiag:=False;
  Timer_TO.Enabled:=False;
  FReceiveTrame :=nil;
  FDoError :=nil;
  FDoStep :=nil;
  FProgress:=nil;
  FNb_OctetRx:=0;
  FNbRx:=0;
  CanSend:=True;
  EndReceive:=True;
  Download:=false;
  FVersion:=CT_Version;
  FSendModeInfo:=CT_ModeHM2;
  FTimeAd:= 2000;
  FTime_Ad_Sync:=300;
  FTime_Sync_Key1:=20;
  FTime_Key1_Key2:=20;
  FTime_Key2b_Adb:=50;
  FTime_TO :=5000;
  FWait_1Req :=1000;
  FWait_Response_Request :=50;
  FTypeInterface:=CT_Interface_Dump;
  FProtocoleELM:=pro_ISO14230;
  ModeConnection:=CT_ModeConnect_5bauds;
  ELM_CANBIT :=11;
  ELM_CANSpeed :=500;
  Msg_TesterPresent:='3E';
  InitMessageTXT;
end;

//******************************************************************************
destructor TKWP2000.Destroy;
begin
  FFichierUpload.Free;
  FMessageTXT.Free;
  inherited destroy;
end;

//******************************************************************************
Procedure TKWP2000.Connect;
begin
  if FComport<>nil then
     begin
       FComport.CustomBaudRate:=5;
       FComport.StopBits:=sbOneStopBit;
       FComPort.Open; // Ouverture du port COM
       FComport.StopBits:=sbOneStopBit;
       if FComport.Connected=False then
          begin
            if Assigned(FDoError) then FDoError(Self,Err_Connect,FMessageTXT.Strings[Err_Connect]);
          end else
          begin
            if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_ConnectCOMOK]);

          end;
     end else if Assigned(FDoError) then FDoError(Self,Err_COM,FMessageTXT.Strings[Err_COM]);;
end;

//******************************************************************************
Procedure TKWP2000.Close;
begin
  if FComport.Connected then FComport.Close; // fin de la transmission
  if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_EndConnection]);
  if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_EndConnection]);
end;

//******************************************************************************
Procedure TKWP2000.StartDiagnosis(Session_type : byte);
begin
  // Debut du diagnostic
  FSid:=CT_StartDiagnosticSession;
  FData[0]:=Session_type; // $81 => Default Mode/Standart diagnostic mode/OBDII Mode
  SendLength:=1;
  if FSpeed<>10400 then
    begin
      // we are in Fiat diagnosis so
      if FSpeed<19200 then
        begin
          FData[1]:=$01; // 9600 bauds
          FSpeed:=9600;
        end else
      if FSpeed<38400 then
        begin
          FData[1]:=$02; // 19200 bauds
          FSpeed:=19200;
        end else
      if FSpeed<57600 then
        begin
          FData[1]:=$03; // 38400 bauds
          FSpeed:=38400;
        end else
      if FSpeed<115200 then
        begin
          FData[1]:=$04; // 57600 bauds
          FSpeed:=57600;
        end else
      if FSpeed>=115200 then
        begin
          FData[1]:=$05; // 115200 bauds
          FSpeed:=115200;
        end;
      SendLength:=2;
    end;
  Download:=false;
  CustomStart;
end;

//******************************************************************************
Procedure TKWP2000.StopDiagnosis;
begin
  FSid:=CT_StopDiagnosticSession;
  Download:=false;
  FExitAttente:=True;
  CustomStop;
end;

//******************************************************************************
// This Function is made for Actia Calculator Multic,CAMU,GMU,Podium
//******************************************************************************
procedure TKWP2000.Startdebug;
begin
  FSid:=CT_StartDiagnosticSession;
  Download:=false;
  if FComport.Connected then
     begin
       if FTypeInterface=CT_Interface_ELM327 then
         begin
           //CustomStartELM;
           exit;
         end;
       FSid_Debug:=$DE;
       if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_Start5Baud]);
       if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_Start5Baud]);
       FRequestDiag:=True;
       FComport.CustomBaudRate:=5; // démarage du code à 5 baud
       FComport.Parity.Bits:=prNone;
       FComport.Parity.Check:=False;
       FComport.StopBits:=sbOneStopBit;
       etat_communication :=1;
       TrameTx[0]:=FTgt;
       FNb_OctetsTransmis:=1;
       FComport.Write(TrameTx,1); // On envoi le code de l'UCE
       Attendre(2000);
       FComport.CustomBaudRate:=FSpeed; // démarage du code à 5 baud
       FComport.Parity.Bits:=prNone;
       FComport.Parity.Check:=False;
       //Attendre(2000);
       Timer_TO.Interval:=FTime_Ad_Sync; // T1 de 300ms avant pb
       Timer_TO.Enabled:=True;
       FNb_tentative:=0;
     end else
     if Assigned(FDoError) then FDoError(Self,Err_Connect,FMessageTXT.Strings[Err_Connect]);
end;

//******************************************************************************
Procedure TKWP2000.CustomStart;
var i : integer;
    texte : string;
begin
  if FComport.Connected then
     begin
       if FTypeInterface=CT_Interface_ELM327 then
         begin
           CustomStartELM;
           exit;
         end;
       FSid_Debug:=$FF;
       if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_Start5Baud]);
       if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_Start5Baud]);
       FRequestDiag:=True;
       if ModeConnection=CT_ModeConnect_5Bauds then
         begin
           FComport.CustomBaudRate:=5; // démarage du code à 5 baud
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           etat_communication :=1;
           TrameTx[0]:=FTgt;
           FNb_OctetsTransmis:=1;
           FComport.Write(TrameTx,1); // On envoi le code de l'UCE
           Attendre(FTimeAd);
           FComport.CustomBaudRate:=10400; // démarage du code à 5 baud
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           //Attendre(FTimeAd);
           Timer_TO.Interval:=FTime_Ad_Sync; // T1 de 300ms avant pb
           Timer_TO.Enabled:=True;
         end else
       if ModeConnection=CT_ModeConnect_Fast then
         begin
           FComport.CustomBaudRate:=360; // démarage du code WUP
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           etat_communication :=0;
           TrameTx[0]:=0;
           FNb_OctetsTransmis:=1;
           //FComport.Events:=[evBreak,evError,evRLSD];  // On empeche la réception
           FComport.Write(TrameTx,1); // On envoi le code de l'UCE
           Attendre(50);
           //FComport.ClearBuffer(true,true);
           //FComport.Events:=[evRxChar,evRxFlag,evBreak,evError,evRLSD];
           FComport.CustomBaudRate:=10400;
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           etat_communication:=5;
           Timer_TO.Interval:=FTime_Ad_Sync;
           FSendModeInfo:=$80;
           FTgtSrcHeader:=true;
           FLengthInFmt:=true;
           FAddLength:=False;
           //SendResponse;
           TrameTx[0]:=FSendModeInfo or $01; // On envoi 0 octet + 1 Sid
           TrameTx[1]:=FTgt;
           TrameTx[2]:=FSrc;
           TrameTx[3]:=$81;
           TrameTx[4]:=0;
           for i:=0 to 3 do TrameTx[4]:=TrameTx[4]+TrameTx[i];
           FNb_OctetsTransmis:=5;
           FComport.Write(TrameTx,5);
           texte:='';
           for i:=0 to 4 do texte:=texte+dectohex(TrameTx[i])+' ';
           if Assigned(FDoStep) then FDoStep(Self,'Envoi trame SendResponse='+texte);
           if Assigned(FDoStep) then FDoStep(Self,'vitesse port COM ='+inttostr(FComport.CustomBaudRate));
           Timer_TO.Enabled:=True;
           Timer_Ma.Enabled:=False;
           if Assigned(FDoStep) then
           if TImer_TO.Enabled then FDoStep(Self,'Send response TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'Send response TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
           FNb_tentative:=0;
         end;
     end else
     if Assigned(FDoError) then FDoError(Self,Err_Connect,FMessageTXT.Strings[Err_Connect]);
end;

//******************************************************************************
Procedure TKWP2000.CustomStop;
begin
  if FComport.Connected then
     begin
       Timer_Ma.Enabled:=False;
       Timer_TO.Enabled:=False;
       Cansend:=true;
       EndReceive:=True;
       if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_EndConnection]);
       if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_EndConnection]);
       FComport.ClearBuffer(true,true);
       if FError=0 then
         begin
           //FComport.CustomBaudRate:=10400; // démarage du code à 5 baud
           //etat_communication :=1;
           //TrameTx[0]:=FTgt;
           //FNb_OctetsTransmis:=1;
           //FComport.Write(TrameTx,1); // On envoi le code de l'UCE
           //Timer_TO.Interval:=300; // T1 de 300ms avant pb
           //Timer_TO.Enabled:=True;
           //FNb_tentative:=0;
         end;
       //FComport.Close;
     end;
end;

//******************************************************************************
Procedure TKWP2000.SendResponseELM327;
var texte : string;
    i : integer;
begin
  while Cansend=False do Application.ProcessMessages; // On attend de pouvoir émettre
  Cansend:=False;
  texte:=dectohex(FSid)+' ';
  for i:=0 to SendLength do texte:=texte+dectohex(FData[i])+' ';
  FComport.WriteStr(texte);
  Timer_TO.Enabled:=True;
end;

//******************************************************************************
Procedure TKWP2000.SendResponseDump; // envoi des données contenu dans FData
var  i,j : integer;
     texte : string;
begin
  FError:=0;
  while Cansend=False do Application.ProcessMessages; // On attend de pouvoir émettre
  if etat_communication=4 then
    while MilliSecondsBetween(Now,FDelaySending)<FWait_Response_Request do Application.ProcessMessages;
  Cansend:=False;
  //if (BufferTmp[1] and $01=$01) then FLengthInFmt:=true else FLengthInFmt:=False; // Taille dans l'octet de format
  //if (BufferTmp[1] and $02=$02) then FAddLength := true else FAddLength:=False; // Octet additionnel de taille de trame
  //if (BufferTmp[1] and $04=$04) then FByteHeader := True else FByteHeader := False; // 1Byte header supported or not
  //if (BufferTmp[1] and $08=$08) then FTgtSrcHeader :=True else FTgtSrcHeader :=False; // Target and source address supported
  //if (BufferTmp[1] and $10=$10) then FTimingParameterSet :=True else FTimingParameterSet :=False; //Normal timing=False or extended timing=True
  j:=0;
  if (SendLength<64) and (FLengthInFmt) then
    begin
      TrameTx[0]:=FSendModeInfo or (SendLength+1);
      if FTgtSrcHeader then
        begin
          TrameTx[1]:=FTgt;
          TrameTx[2]:=FSrc;
          TrameTx[3]:=FSid;
          for i:=1 to SendLength do TrameTx[3+i]:=FData[i-1];
          Fnb_OctetTx:=3+SendLength; // On pointe le dernier octet de donnée de la trame
        end else
        begin
          // on n'accepte pas les adresses de Target et de source donc on les ommet
          TrameTx[1]:=FSid;
          for i:=1 to SendLength do TrameTx[1+i]:=FData[i-1];
          Fnb_OctetTx:=1+SendLength;
        end;
      j:=Fnb_OctetTx+1;        // On point l'octet de CRC
      TrameTx[j]:=0;
    end;
  if ((SendLength>64) and FAddLength) or (FLengthInFmt=False) then
    begin
      TrameTx[0]:=FSendModeInfo;
      if FTgtSrcHeader then
        begin
          TrameTx[1]:=FTgt;
          TrameTx[2]:=FSrc;
          TrameTx[3]:=SendLength+1;
          TrameTx[4]:=FSid;
          for i:=1 to SendLength do TrameTx[4+i]:=FData[i-1];
          Fnb_OctetTx:=4+SendLength; // On pointe le dernier octet de donnée de la trame
        end else
        begin
          TrameTx[1]:=SendLength+1;
          TrameTx[2]:=FSid;
          for i:=1 to SendLength do TrameTx[2+i]:=FData[i-1];
          Fnb_OctetTx:=2+SendLength;
        end;
      j:=Fnb_OctetTx+1;        // On point l'octet de CRC
      TrameTx[j]:=0;
    end;
  if j=0 then
    begin
      exit;
    end;
  for i:=0 to Fnb_OctetTx do TrameTx[j]:=TrameTx[j]+TrameTx[i];
  FNb_OctetTx:=j+1;
  FNb_OctetsTransmis:=FNb_OctetTx;
  FComport.Events:=[evRxChar,evRxFlag,evTxEmpty,evRing,evBreak,evCTS,evDSR,evError,evRLSD];
  FDoStep(Self,'Nombre octet buffer sortie ='+inttostr(FComport.OutputCount));
  FComport.Write(TrameTx,FNb_OctetTx);
  texte:='';
  for i:=0 to FNb_OctetTx-1 do texte:=texte+dectohex(TrameTx[i])+' ';
  if Assigned(FDoStep) then FDoStep(Self,'Envoi trame SendResponse='+texte);
  FDoStep(Self,'vitesse port COM ='+inttostr(FComport.CustomBaudRate));
  Timer_TO.Enabled:=True;
  Timer_Ma.Enabled:=False;
  if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'Send response TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'Send response TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
end;

//******************************************************************************
Procedure TKWP2000.SendResponse;
begin
  if FTypeInterface=CT_Interface_Dump then
    begin
      SendResponseDump;
      exit;
    end;
  if FTypeInterface=CT_Interface_ELM327 then
    begin
      SendResponseELM327;
      exit;
    end;
end;

//******************************************************************************
// Annule la transaction
function TKWP2000.Cancel : integer;
begin
  {if Assigned(FOnEtape) then FOnEtape(Self,'Annulation de la transaction');
  try
    if Comport1.Connected then
       begin
         BufferRX[0]:=A_EOT;
         FNb_OctetsTransmis:=1;
         FComport.Write(BufferRx,1); // On annule toute transmission
         FComport.Close;
       end;
    Timer_TO.Enabled:=False;
    etat_transmission:=1;
    FTransaction:=0;
    Result:=0;
  except
    Result:=Error_Disconnect;
  end; }
end;

//******************************************************************************
function TKWP2000.LoadConfiguration(FileName: string): boolean;
var TLoad : TStringList;
    i : integer;
    texte : string;
begin
  Result:=False;
  try
    TLoad:=TStringList.Create;
    try
      if FileExists(FileName) then
        begin
          TLoad.LoadFromFile(FileName);
          for i:=0 to TLoad.Count-1 do
            begin
              texte:=TLoad.Strings[i];
              if length(texte)>2 then
                begin
                  if copy(texte,1,2)<>'//' then
                    begin
                      if copy(texte,1,4)='COM=' then
                        begin
                         delete(texte,1,4);
                         FComPort.Port:=texte;
                        end else
                      if copy(texte,1,10)='INTERFACE=' then
                        begin
                         delete(texte,1,10);
                         SetTypeInterface(StrToTypeInterface(texte));
                        end else
                      if copy(texte,1,10)='PROTOCOLE=' then
                        begin
                         delete(texte,1,10);
                         FProtocoleELM:=StringToProtocoleELM(texte);
                        end else
                      if copy(texte,1,17)='ELMTIME_TO_RESET=' then
                        begin
                         delete(texte,1,17);
                         Time_ELMReset:=StrToInt(texte);
                        end else
                      if copy(texte,1,10)='ELMCANBIT=' then
                        begin
                         delete(texte,1,10);
                         ELM_CANBit:=StrToInt(texte);
                        end else
                      if copy(texte,1,12)='ELMCANSPEED=' then
                        begin
                         delete(texte,1,12);
                         ELM_CANSPEED:=StrToInt(texte);
                        end else
                      if copy(texte,1,7)='PARITY=' then
                        begin
                          delete(texte,1,7);
                         // FComPort.Parity.Bits:=StrToParity(texte);
                        end else
                      if copy(texte,1,9)='STOPBITS=' then
                        begin
                          delete(texte,1,9);
                          //FComPort.StopBits:=StrToStopBits(texte);
                        end else
                      if copy(texte,1,8)='DATABIT=' then
                        begin
                          delete(texte,1,8);
                          //FComPort.DataBits:=StrToDataBits(texte);
                        end else
                      if copy(texte,1,4)='VERSUS=' then
                        begin
                        
                        end else
                      if copy(texte,1,10)='DIAGSPEED=' then
                        begin
                          delete(texte,1,10);
                          FSpeed:=StrToint(texte);
                        end else
                      if copy(texte,1,16)='MODEINFORMATION=' then
                        begin
                          delete(texte,1,16);
                        end else
                      // TSave.Add('INIT_MODE='+ModeConnectStr[ModeConnection]);
                      if copy(texte,1,10)='INIT_MODE=' then
                        begin
                          delete(texte,1,10);
                          if texte=ModeConnectStr[CT_ModeConnect_5Bauds] then ModeConnection:=CT_ModeConnect_5Bauds;
                          if texte=ModeConnectStr[CT_ModeConnect_Fast] then ModeConnection:=CT_ModeConnect_Fast;
                        end else
                      if copy(texte,1,10)='TENTATIVE=' then
                        begin
                          delete(texte,1,10);
                          FMax_Tentative:=strtoint(texte);
                        end else
                      if copy(texte,1,8)='TIME_AD=' then
                        begin
                          delete(texte,1,8);
                          FTimeAd:=StrtoInt(texte);
                        end else
                      if copy(texte,1,13)='TIME_AD_SYNC=' then
                        begin
                          delete(texte,1,13);
                          FTime_Ad_Sync:=StrtoInt(texte);
                        end else
                      if copy(texte,1,15)='TIME_SYNC_KEY1=' then
                        begin
                          delete(texte,1,15);
                          FTime_Sync_Key1:=StrtoInt(texte);
                        end else
                      if copy(texte,1,15)='TIME_KEY1_KEY2=' then
                        begin
                          delete(texte,1,15);
                          FTime_Key1_Key2:=StrtoInt(texte);
                        end else
                      if copy(texte,1,15)='TIME_KEY2B_ADB=' then
                        begin
                          delete(texte,1,15);
                          FTime_Key2b_Adb:=StrtoInt(texte);
                        end else
                      if copy(texte,1,8)='TIME_TO=' then
                        begin
                          delete(texte,1,8);
                          FTime_TO:=StrtoInt(texte);
                        end else
                      if copy(texte,1,14)='TPS_MAINTIENT=' then
                        begin
                          delete(texte,1,14);
                          FTpsMa:=StrtoInt(texte);
                          Timer_Ma.Interval:=FTpsMa;
                        end else
                      if copy(texte,1,10)='WAIT_1REQ=' then
                        begin
                          delete(texte,1,10);
                          FWait_1REq:=StrtoInt(texte);
                        end else
                      if copy(texte,1,13)='WAIT_RES_REQ=' then
                        begin
                          delete(texte,1,13);
                          FWait_Response_Request:=StrtoInt(texte);
                        end;
                    end;
                end;
            end;
        end;
      Result:=True;
    except
      Result:=False;
    end;
  Finally
    TLoad.Free;
  end;
  
end;

//******************************************************************************
function TKWP2000.SaveConfiguration(FileName: string): boolean;
var TSave : TStringList;
begin
  try
    Tsave :=TStringlist.Create;
    TSave.Clear;
    TSave.Add('// KWP2000 configuration');
    TSave.Add('// COMPORT configuration');
    TSave.Add('COM='+FComPort.Port);
    TSave.Add('INTERFACE='+TypeInterfaceToStr(GetTypeInterface));
    TSave.Add('// Parameters are ONLY use with ELM327 interface');
    TSave.Add('PROTOCOLE='+ProtocoleELMToString(FProtocoleELM));
    TSave.Add('ELMTIME_TO_RESET='+inttostr(Time_ELMReset));
    TSave.Add('ELMCANBIT='+inttostr(ELM_CANBit));
    TSave.Add('ELMCANSPEED='+inttostr(ELM_CANSpeed));
    //TSave.Add('PARITY='+ParityToStr(FComPort.Parity.Bits));
    //TSave.Add('STOPBITS='+StopBitsToStr(FComport.StopBits));
    //TSave.Add('DATABIT='+DataBitsToStr(FComport.DataBits));
    TSave.Add('');
    TSave.Add('// KWP2000 parameters');
    TSave.Add('VERSUS='+Version);
    TSave.Add('DIAGSPEED='+inttostr(FSpeed));
    TSave.Add('MODEINFORMATION='+ModeInfoToStr(GetModeInfo));
    TSave.Add('INIT_MODE='+ModeConnectStr[ModeConnection]);
    //TSave.Add('SID='+decToHex(FSid));
    //TSave.Add('TARGET='+decToHex(FTgt));
    //TSave.Add('SOURCE='+dectohex(FSrc));
    TSave.Add('TENTATIVE='+inttostr(FMax_Tentative));
    TSave.Add('TIME_AD='+inttostr(FTimeAd));
    TSave.Add('TIME_AD_SYNC='+inttostr(FTime_Ad_Sync));
    TSave.Add('TIME_SYNC_KEY1='+inttostr(FTime_Sync_Key1));
    TSave.Add('TIME_KEY1_KEY2='+inttostr(FTime_Key1_Key2));
    TSave.Add('TIME_KEY2B_ADB='+inttostr(FTime_Key2b_Adb));
    TSave.Add('TIME_TO='+inttostr(FTime_TO));
    TSave.Add('TPS_MAINTIENT='+inttostr(FTpsMa));
    TSave.Add('WAIT_1REQ='+inttostr(FWait_1REQ));
    TSave.Add('WAIT_RES_REQ='+inttostr(FWait_Response_Request));
    TSave.SaveToFile(Filename);
    Result:=True;
    except
      TSave.Free;
      Result:=False;
    end;

    TSave.Free;

end;

//******************************************************************************
function TKWP2000.ModeInfoToStr(ModeInf: TModeKWP): string;
begin
  Result:='';
  if ModeInf=HM0 then Result:='HM0';
  if ModeInf=HM1 then Result:='HM1';
  if ModeInf=HM2 then Result:='HM2';
  if ModeInf=HM3 then Result:='HM3';
end;

//******************************************************************************
function TKWP2000.StrToModeInfo(StrModeInf: string): TModeKWP;
begin
  Result:=HM2;
  if StrModeInf='HM0' then Result:=HM0;
  if StrModeInf='HM1' then Result:=HM1;
  if StrModeInf='HM2' then Result:=HM2;
  if StrModeInf='HM3' then Result:=HM3;
end;

//******************************************************************************
function TKWP2000.LoadMessageTXT(MessageFile : string):Boolean;
begin
  Result:=false;
  if FileExists(MessageFile) then
    begin
      FMessageTXT.LoadFromFile(MessageFile);
      if FMessageTXT.Count>0 then Result:=True else InitMessageTXT;
    end;
end;

//******************************************************************************
function TKWP2000.SaveMessageTXT(MessageFile: string):boolean;
begin
  try
    FMessageTXT.SaveToFile(MessageFile);
    Result:=true;
  except
    Result:=False
  end;
end;

//******************************************************************************
procedure TKWP2000.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FComPort) then
    FComPort := nil;
end;

//******************************************************************************
Procedure TKWP2000.Error_5Bauds;
begin
  if etat_communication>3 then exit;
  Timer_Ma.Enabled:=False;
  FNb_Tentative:=FNb_Tentative+1;
  if FNb_Tentative>FMax_Tentative then
     begin
       if Assigned(FDoError) then FDoError(Self,Err_5Baud,FMessageTXT.Strings[Err_5Baud]);

     end else
     begin
       if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_TestNumber]+inttostr(FNb_Tentative));
       if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_TestNumber]+inttostr(FNb_Tentative));
       if FComport.Connected then
          begin
            FRequestDiag:=True;
            FComport.CustomBaudRate:=5; // démarage du code à 5 baud
            FComport.Parity.Bits:=prEven;
            FComport.Parity.Check:=True;
            etat_communication :=1;
            TrameTx[0]:=FTgt;
            FNb_OctetsTransmis:=1;
            FComport.Write(TrameTx,1); // On envoi le code de l'UCE
            attendre(Time_Ad);
            FComport.CustomBaudRate:=FSpeed; // démarage du code à 5 baud
            FComport.Parity.Bits:=prNone;
            FComport.Parity.Check:=False;
            Attendre(Time_Ad);
            Timer_TO.Interval:=Time_Ad_Sync; // T1 de 300ms avant pb
            Timer_TO.Enabled:=True;
            if Assigned(FDoStep) then if TImer_TO.Enabled then FDoStep(Self,'Err5B TIMER TO Actif ('+inttostr(Timer_TO.interval)+')') else FDoStep(Self,'Err 5B TIMER TO Inactif ('+inttostr(Timer_TO.interval)+')');
          end else
          if Assigned(FDoError) then FDoError(Self,Err_Connect,FMessageTXT.Strings[Err_Connect]);
     end;
end;

//******************************************************************************
Procedure TKWP2000.Error_Fast;
var i : integer;
    texte : string;
begin
  //if etat_communication>3 then exit;
  Timer_Ma.Enabled:=False;
  FNb_Tentative:=FNb_Tentative+1;
  if FNb_Tentative>FMax_Tentative then
     begin
       if Assigned(FDoError) then FDoError(Self,Err_5Baud,FMessageTXT.Strings[Err_5Baud]);

     end else
     begin
       if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_TestNumber]+inttostr(FNb_Tentative));
       if Assigned(FDoStatus) then FDostatus(Self,FMessageTXT.Strings[CT_TestNumber]+inttostr(FNb_Tentative));
       if FComport.Connected then
         begin
           FRequestDiag:=True;
            FComport.CustomBaudRate:=360; // démarage du code WUP
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           etat_communication :=0;
           TrameTx[0]:=0;
           FNb_OctetsTransmis:=1;
           //FComport.Events:=[evBreak,evError,evRLSD];  // On empeche la réception
           FComport.Write(TrameTx,1); // On envoi le code de l'UCE
           Attendre(50);
           //FComport.ClearBuffer(true,true);
           //FComport.Events:=[evRxChar,evRxFlag,evBreak,evError,evRLSD];
           FComport.CustomBaudRate:=10400;
           FComport.Parity.Bits:=prNone;
           FComport.Parity.Check:=False;
           FComport.StopBits:=sbOneStopBit;
           etat_communication:=5;
           Timer_TO.Interval:=FTime_Ad_Sync;
           FSendModeInfo:=$80;
           FTgtSrcHeader:=true;
           FLengthInFmt:=true;
           FAddLength:=False;
           //SendResponse;
           TrameTx[0]:=FSendModeInfo or $01; // On envoi 0 octet + 1 Sid
           TrameTx[1]:=FTgt;
           TrameTx[2]:=FSrc;
           TrameTx[3]:=$81;
           TrameTx[4]:=0;
           for i:=0 to 3 do TrameTx[4]:=TrameTx[4]+TrameTx[i];
           FNb_OctetsTransmis:=5;
           FComport.Write(TrameTx,5);
           texte:='';
           for i:=0 to 4 do texte:=texte+dectohex(TrameTx[i])+' ';
           if Assigned(FDoStep) then FDoStep(Self,'Envoi trame SendResponse='+texte);
           if Assigned(FDoStep) then FDoStep(Self,'vitesse port COM ='+inttostr(FComport.CustomBaudRate));
           Timer_TO.Enabled:=True;
           Timer_Ma.Enabled:=False;
         end else
           if Assigned(FDoError) then FDoError(Self,Err_Connect,FMessageTXT.Strings[Err_Connect]);
     end;
end;
//******************************************************************************
procedure TKWP2000.FComPortRxChar(Sender: TObject; Count: Integer);
const CT_NoAction = 0;
      CT_Connect = 1;
      CT_Receive = 2;

begin
  FExitAttente:=True;

  if FTypeInterface=CT_Interface_Dump then
    begin
      DumpRxChar(Count);
      exit;
    end;
  if FTypeInterface=CT_Interface_ELM327 then
    begin
      ELMRxChar(Count);
      exit;
    end;
end;
//******************************************************************************
procedure TKWP2000.Timer_TOTimer(Sender: TObject);
begin
  if Timer_TO.Enabled=False then exit;
  FExitAttente:=True;
  Timer_TO.Enabled:=False;
  Timer_Ma.Enabled:=False;
  if Assigned(FDoStep) then FDoStep(Self,'Event '+FMessageTXT.Strings[Err_TO]+'('+inttostr(Timer_TO.Interval)+')');
  if etat_communication=1 then
    begin
      Error_5Bauds;
    end else
  if etat_communication=5 then
    begin
      Error_Fast;
    end else
  if etat_communication>1 then
     begin
       //if Assigned(FDoDisconnect)then FDoDisconnect(Self);
       CanSend:=True;
       if assigned(FDoError) then FDoError(Self,Err_TO,FMessageTXT.Strings[Err_TO]);
     end;
end;

//******************************************************************************
procedure TKWP2000.Timer_MATimer(Sender: TObject);
var texte,texte1 : string;
    i : integer;
begin
  Timer_Ma.Enabled:=False;
  FExitAttente:=True;
  SendLength:=0;
  //Sid:=CT_TesterPresent; // Tester present
  texte:=Msg_TesterPresent;
  i:=pos(' ',texte);
  if i>0 then
    begin
      texte1:=copy(texte,1,i-1);
      delete(texte,1,i);
    end else
    begin
      texte1:=texte;
      texte:='';
    end;
  Sid:=hextodec(texte1);
  while length(texte)>0 do
    begin
      i:=pos(' ',texte);
      if i>0 then
        begin
          texte1:=copy(texte,1,i-1);
          delete(texte,1,i);
        end else
        begin
          texte1:=texte;
          texte:='';
        end;
      FData[SendLength]:=hextodec(texte1);
      SendLength:=SendLength+1;
    end;
  SendResponse; // envoi de la trame
  if Assigned(FDoStep) then FDoStep(Self,FMessageTXT.Strings[CT_SendTesterPresent]);
end;


//******************************************************************************
procedure TKWP2000.SetComPort(const Value: TComPort);
begin
  if Value <> FComPort then
  begin
    FComPort := Value;
    if FComPort <> nil then
    begin
      {$IFDEF FPC}
      FComport.OnRxChar:=@FComPortRxChar;
      {$ELSE}
      FComport.OnRxChar:=FComPortRxChar;
      {$ENDIF}
      // réglage par défaut du port série
      FComport.BaudRate:=brCustom;
      FSpeed:=10400;
      FComport.CustomBaudRate:=10400;
      FComport.DataBits:=dbEight;
      FComport.StopBits:=sbOneStopBit;
      FComport.Port:='COM1';
      FComport.Parity.Bits:=prNone;
      FComport.Parity.Check:=False;
    end;
  end;
end;

end.

