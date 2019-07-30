{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit WS.WebModule;

interface

uses System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework, FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys;

type
  TWSWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWSWebModule;

implementation

{$R *.dfm}

uses WS.Datamodule, WS.HelloController, MVCFramework.Commons,
  Data.DB, WS.Common, oData.Dialect.MySql, oData.Dialect.MSSQL,
  oData.Dialect.PostgreSQL, oData.Dialect.Oracle,
  oData.ProxyBase, oData.SQL.FireDAC, oData.Dialect, oData.Dialect.Firebird,
  oData.Dialect.Mongo,
  WS.Controller;

type
  /// config init classes of adapters
  TODataFiredacQueryRS = class(TODataFiredacQuery)
  public
    function QueryClass: TDatasetClass; override;
    function DialectClass: TODataDialectClass; override;
  end;

function TODataFiredacQueryRS.DialectClass: TODataDialectClass;
var
  drv: string;
begin
  drv := WSConnectionString.ToUpper;
  /// todo: checar uma forma melhor de testar o tipo de driver carregado
  if drv.Contains('=FB;') then
    result := TODataDialectFirebird
  else if drv.Contains('=MYSQL;') then
    result := TODataDialectMySQL
  else if drv.Contains('=MSSQL;') then
    result := TODataDialectMSSQL
  else if drv.Contains('=ORA') then
    result := TODataDialectOracle
  else if drv.Contains('=PG;') then
    result := TODataDialectPostgreSQL
    /// por Elis�ngela
  else if drv.Contains('=MONGO') then
    result := TODataDialectMongo
    /// por Elis�ngela
  else
    result := TODataDialectFirebird;
  /// nao achou nenhum.
end;

function TODataFiredacQueryRS.QueryClass: TDatasetClass;
begin
  result := TFDQueryAuto;
  // maybe some class inherited from TFDQuery that known manager connections by default
end;

procedure TWSWebModule.WebModuleCreate(Sender: TObject);
var
  r: TClass;
begin
  // ..... /// some place need init "ODataBase" type
  r := GetODataBase();
  if not assigned(r) then
    SetODataBase(TODataFiredacQueryRS);
  // declared in unit oData.ProxyBase;

  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      // enable static files
      Config[TMVCConfigKey.DocumentRoot] :=
        ExtractFilePath(GetModuleName(HInstance)) + '\www';
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      // default content-type
      Config[TMVCConfigKey.DefaultContentType] :=
        TMVCConstants.DEFAULT_CONTENT_TYPE;
      // default content charset
      Config[TMVCConfigKey.DefaultContentCharset] :=
        TMVCConstants.DEFAULT_CONTENT_CHARSET;
      // unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      // default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      // view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      // Enable STOMP messaging controller
      // Config[TMVCConfigKey.Messaging] := 'false';
      // Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Define a default URL for requests that don't map to a route or a file (useful for client side web app)
      Config[TMVCConfigKey.FallbackResource] := 'index.html';
    end);
  LoadWSControllers(FMVC);
end;

procedure TWSWebModule.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
