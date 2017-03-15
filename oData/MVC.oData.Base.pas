{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit MVC.oData.Base;

interface

uses System.Classes, System.SysUtils,
  MVCFramework, MVCFramework.Commons,
  Data.Db, oData.Interf, oData.Dialect,
  System.JSON;

type

  [MVCPath('/OData')]
  [MVCDoc('Implements OData protocol')]
  TODataController = class(TMVCController)
  public
    function CreateJson(CTX: TWebContext; const AValue: string): TJsonObject;
    // [MVCDoc('Finalize JSON response')]
    procedure EndsJson(var AJson: TJsonObject);
    // [MVCDoc('Overload Render')]
    procedure RenderA(AJson: TJsonObject);
    procedure RenderError(CTX: TWebContext; ATexto: String);
  private
    // [MVCDoc('General parse OData URI')]
    procedure GetQueryBase(CTX: TWebContext);
  public

    [MVCHTTPMethod([httpGET])]
    [MVCPath('')]
    [MVCDoc('Get Resources list')]
    procedure ResourceList(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/$metadata')]
    [MVCDoc('Get config metadata file')]
    procedure MetadataCollection(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/reset')]
    [MVCDoc('Reset/reload metadata file')]
    procedure ResetCollection(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to query OData')]
    procedure QueryCollection1(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($collection1)/($collection2)')]
    procedure QueryCollection2(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($collection1)/($collection2)/($collection3)')]
    procedure QueryCollection3(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/OData.svc/($collection1)/($collection2)/($collection3)/($collection4)')
      ]
    procedure QueryCollection4(CTX: TWebContext);

    [MVCHTTPMethod([httpDELETE])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to DELETE OData')]
    procedure DeleteCollection1(CTX: TWebContext);

    [MVCHTTPMethod([httpPOST])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to INSERT OData')]
    procedure POSTCollection1(CTX: TWebContext);

    [MVCHTTPMethod([httpPATCH])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to PATCH OData')]
    procedure PATCHCollection1(CTX: TWebContext);

    [MVCHTTPMethod([httpPUT])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to PATCH OData')]
    procedure PUTCollection1(CTX: TWebContext);

    [MVCHTTPMethod([httpOPTIONS])]
    [MVCPath('/OData.svc/($collection)')]
    [MVCDoc('Default method to OPTIONS OData')]
    procedure OPTIONSCollection1(CTX: TWebContext);

    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;

  end;

  TODataControllerClass = class of TODataController;

implementation

uses ObjectsMappers, WS.Controller, oData.ProxyBase, oData.SQL,
  oData.ServiceModel, oData.Engine,
  System.DateUtils;

{ TODataController }

function TODataController.CreateJson(CTX: TWebContext; const AValue: string)
  : TJsonObject;
begin
  CTX.Response.SetCustomHeader('OData-Version', '4.0');
  CTX.Response.ContentType := 'application/json;odata.metadata=minimal';
  result := TJsonObject.create as TJsonObject;
  result.addPair('@odata.context', AValue);
  result.addPair('StartsAt', DateToISO8601(now));
end;

procedure TODataController.DeleteCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: TJsonObject;
  arr: TJsonArray;
  n: integer;
  erro: TJsonObject;
begin
  try
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    n := FOData.ExecuteDELETE(CTX.Request.Body, JSONResponse);
    JSONResponse.addPair('@odata.count', n.ToString);

    if n > 0 then
      CTX.Response.StatusCode := 200
    else
      CTX.Response.StatusCode := 304;

    RenderA(JSONResponse);

  except
    on e: Exception do
      RenderError(CTX, e.message);
  end;

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
  CTX.Response.StatusCode := 201;
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

procedure TODataController.OPTIONSCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  JSONResponse: TJsonObject;
  LAllow: string;
begin
  try
    CTX.Response.StatusCode := 200;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    FOData.ExecuteOPTIONS(JSONResponse);
    if JSONResponse.TryGetValue<string>('allow', LAllow) then
    begin
      CTX.Response.CustomHeaders.Add('Allow=' + LAllow);
    end;
    RenderA(JSONResponse);
  except
    on e: Exception do
      RenderError(CTX, e.message);

  end;
end;

procedure TODataController.PATCHCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJsonObject;
begin
  try
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    n := FOData.ExecutePATCH(CTX.Request.Body, JSONResponse);

    JSONResponse.addPair('@odata.count', n.ToString);

    if n > 0 then
      CTX.Response.StatusCode := 201
    else
      CTX.Response.StatusCode := 304;

    RenderA(JSONResponse);

  except
    on e: Exception do
      RenderError(CTX, e.message);
  end;

end;

procedure TODataController.POSTCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJsonObject;
begin
  try
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    n := FOData.ExecutePOST(CTX.Request.Body, JSONResponse);

    JSONResponse.addPair('@odata.count', n.ToString);

    if n > 0 then
      CTX.Response.StatusCode := 201
    else
      CTX.Response.StatusCode := 304;

    RenderA(JSONResponse);

  except
    on e: Exception do
      RenderError(CTX, e.message);
  end;

end;

procedure TODataController.PUTCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJsonObject;
begin
  try
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    n := FOData.ExecutePATCH(CTX.Request.Body, JSONResponse);

    JSONResponse.addPair('@odata.count', n.ToString);

    if n > 0 then
      CTX.Response.StatusCode := 201
    else
      CTX.Response.StatusCode := 304;

    RenderA(JSONResponse);

  except
    on e: Exception do
      RenderError(CTX, e.message);
  end;

end;

procedure TODataController.QueryCollection1(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.GetQueryBase(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: TJsonObject;
  arr: TJsonArray;
  n: integer;
  erro: TJsonObject;
  // jo: TJsonValue;
begin
  try
    // jo := nil;
    try
      (* try
        if CTX.Request.Body <> '' then
        jo := TJsonObject.ParseJSONValue(CTX.Request.Body);
        except
        end;
        //if not assigned(jo) then
        //  jo := TJsonObject.create;
      *)
      FOData := ODataBase.create();
      FOData.DecodeODataURL(CTX);
      JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);

      // for n := 0 to ctx.Request.QueryStringParams.Count-1 do
      // jo. AddPair(ctx.Request.QueryStringParams.Names[n],CTX.Request.QueryStringParams.ValueFromIndex[n]);

      FDataset := TDataset(FOData.ExecuteGET(nil, JSONResponse));
      FDataset.first;
      arr := TJsonArray.create;
      Mapper.DataSetToJSONArray(FDataset, arr, False);
      if assigned(arr) then
      begin
        JSONResponse.addPair('value', arr);
        // JSON.addPair('__collection', FOData.Collection);
      end;
      if FOData.inLineRecordCount < 0 then
        FOData.inLineRecordCount := FDataset.RecordCount;
      JSONResponse.addPair('@odata.count', FOData.inLineRecordCount.ToString);
      if FOData.GetParse.oData.Top > 0 then
        JSONResponse.addPair('@odata.top', FOData.GetParse.oData.Top.ToString);
      if FOData.GetParse.oData.Skip > 0 then
        JSONResponse.addPair('@odata.skip',
          FOData.GetParse.oData.Skip.ToString);

      RenderA(JSONResponse);
    finally
      // freeAndNil(jo);
    end;
  except
    on e: Exception do
    begin
      freeAndNil(FDataset);
      freeAndNil(JSONResponse);
      CTX.Response.StatusCode := 501;
      RenderError(CTX, e.message);
    end;
  end;
end;

procedure TODataController.QueryCollection2(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.QueryCollection3(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.QueryCollection4(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.RenderA(AJson: TJsonObject);
begin
  EndsJson(AJson);
  render(AJson);
end;

procedure TODataController.RenderError(CTX: TWebContext; ATexto: String);
var
  n: integer;
  js: TJsonObject;
begin
  if ATexto.StartsWith('{') then
  begin
    js := TJsonObject.ParseJSONValue(ATexto) as TJsonObject;
    if assigned(js) then
    begin
      try
        js.GetValue('error').TryGetValue<integer>('code', n);
        if n > 0 then
          CTX.Response.StatusCode := n;
      except
      end;
      render(js);
      exit;
    end;
  end;
  js := TJsonObject.ParseJSONValue(TODataError.create(500, ATexto))
    as TJsonObject;
  render(js);
end;

initialization

RegisterWSController(TODataController);

finalization

end.
