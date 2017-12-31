{ //************************************************************// }
{ //         Projeto ODataBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit MVC.oData.Base;

interface

uses System.Classes, System.SysUtils,
  MVCFramework, MVCFramework.Commons,
  Data.Db, oData.Interf, oData.Dialect,
  oData.Packet, System.JSON;

type

  [MVCPath('/OData')]
  [MVCDoc('ODataBr - Implements OData protocol - tireideletra.com.br')]
  TODataController = class(TMVCController)
  public
    function CreateJson(CTX: TWebContext; const AValue: string)
      : IODataJsonPacket;
    // [MVCDoc('Finalize JSON response')]
    // [MVCDoc('Overload Render')]
    procedure RenderA(AJson: TODataJsonPacket);
    procedure RenderError(CTX: TWebContext; ATexto: String);
  private
    // [MVCDoc('General parse OData URI')]
    procedure GetQueryBase(CTX: TWebContext);
  public

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

    [MVCHTTPMethod([httpGET])]
    [MVCPath('')]
    [MVCPath('/')]
    [MVCDoc('Get Resources list')]
    procedure ResourceList(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/hello/($engine)')]
    [MVCDoc('Get script code')]
    procedure GenScriptEngine(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/$metadata')]
    [MVCDoc('Get config metadata file')]
    procedure MetadataCollection(CTX: TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/reset')]
    [MVCDoc('Reset/reload metadata file')]
    procedure ResetCollection(CTX: TWebContext);

    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;

  end;

  TODataControllerClass = class of TODataController;

implementation

uses
  MVCFramework.DataSet.Utils, WS.Common, oData.ProxyBase, oData.SQL,
  oData.ServiceModel, oData.Engine, oData.GenScript,
{$IFDEF LOGEVENTS}
  System.LogEvents.progress, System.LogEvents,
{$ENDIF}
  System.DateUtils;

{ TODataController }

function TODataController.CreateJson(CTX: TWebContext; const AValue: string)
  : IODataJsonPacket;
begin
  CTX.Response.SetCustomHeader('OData-Version', '4.0');
  // CTX.Response.ContentType := 'application/json;odata.metadata=minimal';  // AL - DMVC3, nao consegue buscar conector se houver mais 1 item na lista
  CTX.Response.ContentType := 'application/json';
  result :=  TODataJsonPacket.create(AValue,false);
end;

procedure TODataController.DeleteCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: IODataJsonPacket;
  jo: TJsonObject;
  arr: TJsonArray;
  n: integer;
  erro: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    jo := JSONResponse.asJsonObject;
    n := FOData.ExecuteDELETE(CTX.Request.Body, jo);

    JSONResponse.Counts(n);

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
  JSONResponse: IODataJsonPacket;
  LAllow: string;
  jo: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 200;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    jo := JSONResponse.asJsonObject;
    FOData.ExecuteOPTIONS(jo);
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
  JSONResponse: IODataJsonPacket;
  jo: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r, LAllow: string;
  erro: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    try
      r := CTX.Request.Body;
      jo := JSONResponse.asJsonObject;
      n := FOData.ExecutePATCH(r, jo);
      JSONResponse.Counts(n);

      if JSONResponse.TryGetValue<string>('allow', LAllow) then
      begin
        CTX.Response.CustomHeaders.Add('Allow=' + LAllow);
      end;

      if n > 0 then
        CTX.Response.StatusCode := 201
      else
        CTX.Response.StatusCode := 304;

      RenderA(JSONResponse);
    finally
    end;
  except
    on e: Exception do
      RenderError(CTX, e.message);
  end;

end;

procedure TODataController.POSTCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: IODataJsonPacket;
  jo: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    jo := JSONResponse.asJsonObject;
    n := FOData.ExecutePOST(CTX.Request.Body, jo);

    JSONResponse.Counts(n);

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
  JSONResponse: IODataJsonPacket;
  jo: TJsonObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := ODataBase.create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    jo := JSONResponse.asJsonObject;
    n := FOData.ExecutePATCH(CTX.Request.Body, jo);

    JSONResponse.Counts(n);

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

procedure TODataController.QueryCollection1(CTX: TWebContext);
begin
  GetQueryBase(CTX);
end;

procedure TODataController.GenScriptEngine(CTX: TWebContext);
var
  eng: string;
begin
  CTX.Request.SegmentParam('engine', eng);
  CTX.Response.Content := TODataGenScript.GetScript(eng);
  CTX.Response.ContentType := 'text/plan';
end;

procedure TODataController.GetQueryBase(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: IODataJsonPacket;
  jo: TJsonObject;
  arr: TJsonArray;
  n: integer;
  erro: TJsonObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    try
      FOData := ODataBase.create();
      FOData.DecodeODataURL(CTX);
      JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
      jo := JSONResponse.asJsonObject;
      FDataset := TDataset(FOData.ExecuteGET(nil, jo));
      FDataset.first;
      arr := TJsonObject.ParseJSONValue(FDataset.AsJSONArray) as TJsonArray;
      if assigned(arr) then
      begin
        JSONResponse.values(arr);
      end;
      if FOData.inLineRecordCount < 0 then
        FOData.inLineRecordCount := FDataset.RecordCount;
      JSONResponse.Counts(FOData.inLineRecordCount);
      JSONResponse.Tops(FOData.GetParse.oData.Top);
      JSONResponse.skips(FOData.GetParse.oData.Skip);

      RenderA(JSONResponse);
    finally
      FOData.release;
      FOData := nil;
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

procedure TODataController.RenderA(AJson: TODataJsonPacket);
begin
  AJson.Ends;
  render(AJson.asJsonObject);
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
