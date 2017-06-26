{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 18/06/2017 02:33:13                                  // }
{ //************************************************************// }
{
  Código fornecidor por: Carlos Dias da Silva (Dex)
}

{
   Exemplo de Uso:
   procedure TFrmTestConnectionMain.GerarMensagem(ATexto: String);
            var AModel:IWinNotificationModel;
   begin
     // uses WinNotification.Model.Interf
     AModel := GetModel<IWinNotificationModel>;
     AModel.Send('TestConnection','Falha de comunicação com o banco de dados',ATexto);
   end;
}


Unit WinNotification.Model;

interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,
  WinNotification.Model.Interf,
  MVCBr.Controller, System.Notification;

Type
  TWinNotificationModel = class(TModelFactory, IWinNotificationModel,
    IThisAs<TWinNotificationModel>)
  private
    FSenderName: String;
    FMessageText: String;
    FSubject: string;
    function SenderNotification: boolean;
  protected
    FNotificationCenter: TNotificationCenter;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IWinNotificationModel; overload;
    class function new(const AController: IController)
      : IWinNotificationModel; overload;
    function ThisAs: TWinNotificationModel;
    // implementaçoes
    function Send(const AName: String; const ASubject: String;
      const AMessage: String): boolean;
  end;

Implementation

constructor TWinNotificationModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

function TWinNotificationModel.SenderNotification: boolean;
var
  FNotification: TNotification;
begin

  result := false;

  if not assigned(FNotificationCenter) then
    FNotificationCenter := TNotificationCenter.Create(Application);

  FNotification := FNotificationCenter.CreateNotification;
  try
    FNotification.Name := FSenderName;
    FNotification.Title := FSubject;
    FNotification.AlertBody := FMessageText;
    FNotificationCenter.PresentNotification(FNotification);
  finally
    FNotification.Free;
  end;

  result := true;

end;

function TWinNotificationModel.ThisAs: TWinNotificationModel;
begin
  result := self;
end;

class function TWinNotificationModel.new(): IWinNotificationModel;
begin
  result := new(nil);
end;

destructor TWinNotificationModel.Destroy;
begin
  if assigned(FNotificationCenter) then
    FNotificationCenter.DisposeOf;
  inherited;
end;

class function TWinNotificationModel.new(const AController: IController)
  : IWinNotificationModel;
begin
  result := TWinNotificationModel.Create;
  result.Controller(AController);
end;

function TWinNotificationModel.Send(const AName: String; const ASubject: String;
  const AMessage: String): boolean;
begin
  FSenderName := AName;
  FMessageText := AMessage;
  FSubject := ASubject;
  result := SenderNotification;
end;

Initialization

TMVCRegister.RegisterType<IWinNotificationModel, TWinNotificationModel>
  (TWinNotificationModel.classname, true);

end.
