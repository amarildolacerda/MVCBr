unit MVC.oData.Base;

interface

uses System.Classes, System.SysUtils, MVCFramework, MVCFramework.Commons,
  Data.Db, oData.Interf, oData.Dialect,
  System.JSON;

type

  [MVCPath('/OData')]
  TODataController = class(TMVCController)
  public
    function CreateJson(CTX: TWebContext; const AValue: string): TJsonObject;
    procedure EndsJson(var AJson: TJsonObject);
    procedure RenderA(AJson: TJsonObject);
  private
    procedure GetQueryBase(CTX: TWebContext);
  public

    [MVCHTTPMethod([httpGET])]
    [MVCPath('')]
    procedure ResourceList(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/$metadata')]
    procedure MetadataCollection(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/reset')]
    procedure ResetCollection(CTX: TWebContext);


    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($collection)')]
    procedure QueryCollection(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($master)/($detail')]
    procedure QueryMasterDetailCollection(CTX: TWebContext);

    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;

  end;

  TODataControllerClass = class of TODataController;

implementation

uses ObjectsMappers, WS.Controller, oData.ProxyBase, oData.SQL, oData.Model,
  System.DateUtils;

{ TODataController }

function TODataController.CreateJson(CTX: TWebContext; const AValue: string)
  : TJsonObject;
begin
  CTX.Response.SetCustomHeader('OData-Version', '4.0');
  result := TJsonObject.create as TJsonObject;
  result.addPair('@odata.context', AValue);
  result.addPair('StartsAt', DateToISO8601(now));
end;

procedure TODataController.EndsJson(var AJson: TJsonObject);
begin
  AJson.addPair('EndsAt', DateToISO8601(now));
end;

procedure TODataController.MetadataCollection(CTX: TWebContext);
var
  js: TJsonObject;
begin
  try
    js := TJsonObject.ParseJSONValue(ODataServices.LockJson.ToJSON)
      as TJsonObject;
  finally
    ODataServices.UnlockJson;
  end;

  render(js, true);

end;

procedure TODataController.ResetCollection(CTX: TWebContext);
begin
    ODataServices.reload;
    render('ok');
end;

procedure TODataController.ResourceList(CTX: TWebContext);
var
  js: TJsonObject;
  rsp: TJsonArray;
  it: TJsonValue;
begin
  render(ODataServices.ResourceList, true);
end;

procedure TODataController.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  inherited;

end;

procedure TODataController.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  inherited;

end;

procedure TODataController.QueryCollection(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.GetQueryBase(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSON: TJsonObject;
  arr: TJsonArray;
  n: integer;
begin
  FOData := ODataBase.create();
  FOData.DecodeODataURL(CTX);
  JSON := CreateJson(CTX, CTX.Request.PathInfo);
  FDataset := TDataset(FOData.getDataSet);
  try
    FDataset.first;
    arr := TJsonArray.create;
    Mapper.DataSetToJSONArray(FDataset, arr, False);
    if assigned(arr) then
    begin
      JSON.addPair('results', arr);
      JSON.addPair('__collection', FOData.Collection);
    end;
    if FOData.inLineRecordCount < 0 then
      FOData.inLineRecordCount := FDataset.RecordCount;
    JSON.addPair('__count', FOData.inLineRecordCount.ToString);
    if FOData.GetParse.oData.Top > 0 then
      JSON.addPair('__top', FOData.GetParse.oData.Top.ToString);
    if FOData.GetParse.oData.Skip > 0 then
      JSON.addPair('__skip', FOData.GetParse.oData.Skip.ToString);

    RenderA(JSON);
  finally
  end;
end;

procedure TODataController.QueryMasterDetailCollection(CTX: TWebContext);
begin
   GetQueryBase(CTX);
end;

procedure TODataController.RenderA(AJson: TJsonObject);
begin
  EndsJson(AJson);
  render(AJson);
end;

initialization

RegisterWSController(TODataController);

finalization

end.
