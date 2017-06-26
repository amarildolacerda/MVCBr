{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.ProxyBase;

interface

uses System.Classes, System.SysUtils, Data.DB, MVCFramework,
  System.JSON,
  oData.Interf, oData.engine, oData.Parse, oData.Dialect;

type

  TODataBase = class(TInterfacedObject, IODataBase)
  private
    FAdapterAPI: IODataDialect;
    procedure SetAdapterAPI(const Value: IODataDialect);
    function getInLineCount: integer;
  protected
    FCTX: TWebContext;
    [unsafe]
    FODataParse: IODataParse;
    FInLineRecordCount: integer;
    function This: TObject;
    procedure Release;

    function ExecuteGET(AJsonBody: TJsonValue; var JSONResponse: TJSONObject)
      : TObject; virtual;
    function ExecuteDELETE(ABody: string; var JSONResponse: TJSONObject)
      : integer; virtual;
    function ExecutePOST(ABody: string; var JSON: TJSONObject)
      : integer; virtual;
    function ExecutePATCH(ABody: string; var JSON: TJSONObject)
      : integer; virtual;
    function ExecuteOPTIONS(var JSON: TJSONObject): integer; virtual;

    procedure CreateExpandCollections(AQuery: TObject); virtual;

    function Collection: string; virtual;
    function GetInLineRecordCount: integer;
    procedure SetInLineRecordCount(const Value: integer);
  public
    function GetParse: IODataParse; virtual;
    property AdapterAPI: IODataDialect read FAdapterAPI write SetAdapterAPI;
    property InLineRecordCount: integer read GetInLineRecordCount
      Write SetInLineRecordCount;
    function DialectClass: TODataDialectClass; virtual;

    constructor Create(); virtual;
    destructor Destroy; override;
    procedure DecodeODataURL(CTX: TObject); virtual;
    function GetCollection(AName: string): string;
  end;

  TODataBaseClass = class of TODataBase;

var
  ODataBase: TODataBaseClass;

implementation

{ TODataBase }
uses oData.ServiceModel;

function TODataBase.Collection: string;
begin

end;

constructor TODataBase.Create();
begin
  inherited Create;
  FAdapterAPI := DialectClass.Create;
  FODataParse := TODataParse.Create;

end;

procedure TODataBase.CreateExpandCollections(AQuery: TObject);
begin

end;

procedure TODataBase.DecodeODataURL(CTX: TObject);
begin
  FCTX := CTX as TWebContext;
end;

destructor TODataBase.Destroy;
begin
  FODataParse := nil;
  FAdapterAPI := nil;
  inherited;
end;

function TODataBase.DialectClass: TODataDialectClass;
begin
  result := TODataDialect;
end;

function TODataBase.ExecuteDELETE(ABody: string;
  var JSONResponse: TJSONObject): integer;
begin
  result := 0;
end;

function TODataBase.ExecutePATCH(ABody: string; var JSON: TJSONObject): integer;
begin
  result := 0;
end;

function TODataBase.ExecutePOST(ABody: string; var JSON: TJSONObject): integer;
begin
  result := 0;
end;

function TODataBase.GetCollection(AName: string): string;
begin
  result := ODataServices.resource(AName).Collection;
end;

function TODataBase.ExecuteGET(AJsonBody: TJsonValue;
  var JSONResponse: TJSONObject): TObject;
begin
  result := nil;
end;

function TODataBase.ExecuteOPTIONS(var JSON: TJSONObject): integer;
var
  s: string;
  LResource: IJsonODataServiceResource;
begin
  AdapterAPI.createGETQuery(FODataParse.oData, '', false);
  LResource := AdapterAPI.GetResource as IJsonODataServiceResource;
  s := LResource.method;
  if s = '' then
    s := 'GET';
  JSON.AddPair('allow', s);
end;

function TODataBase.getInLineCount: integer;
begin
  result := 0;
end;

function TODataBase.GetInLineRecordCount: integer;
begin
  result := FInLineRecordCount;
end;

function TODataBase.GetParse: IODataParse;
begin
  result := FODataParse;
end;

procedure TODataBase.Release;
begin
  FAdapterAPI.release;
  FODataParse.release;
end;

procedure TODataBase.SetAdapterAPI(const Value: IODataDialect);
begin
  FAdapterAPI := Value;
end;

procedure TODataBase.SetInLineRecordCount(const Value: integer);
begin
  FInLineRecordCount := Value;
end;

function TODataBase.This: TObject;
begin
  result := self;
end;

initialization

ODataBase := TODataBase;

end.
