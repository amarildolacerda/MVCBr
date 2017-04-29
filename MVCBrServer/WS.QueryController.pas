unit WS.QueryController;

interface

uses
  MVCFramework, MVCFramework.Commons;

type

  [MVCPath('/')]
  [MVCDoc('Query Controller implementa a camada de acesso ao banco de dados relacional')]
  TWSQueryController = class(TMVCController)
  private
  public
    [MVCPath('/query/($sql)')]
    [MVCDoc('Implementa serviços de pesquisa ao banco de dados e retorna o conteúdo encontrado.')]
    [MVCHTTPMethod([httpGET])]
   // [MVCProduces('text/javascript')]
    procedure GetQuerySQL(const sql: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;
  end;

implementation

uses
  MVCFramework.Logger,
  /// Adicionado WS.Controller para registrar uma lista de Serviços inicializados pelo Server
  WS.Controller,
  System.JSON;


procedure TWSQueryController.GetQuerySQL(const sql: String);
var js:TJsonObject;
begin
  js := TJSONObject.Create as TJSONObject;
  js.AddPair('Nome','MVCBr');
  Render( js   );
end;

procedure TWSQueryController.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TWSQueryController.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;


initialization
  ///  Registra a classe como um serviço para o Server
  RegisterWSController(TWSQueryController);

end.
