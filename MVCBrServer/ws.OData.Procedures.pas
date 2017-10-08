unit ws.OData.Procedures;

interface

uses
  System.Classes, System.SysUtils,
  System.JSON,
  MVCFramework, MVCFramework.Commons;

type

  [MVCPath('/OData/OData.proc')]
  TODataProcedures = class(TMVCController)
  private
    function CreateJson(CTX: TWebContext; const AValue: string): TJsonObject;
    procedure RenderA(AJson: TJsonObject);
    procedure EndsJson(var AJson: TJsonObject);
    procedure RenderError(CTX: TWebContext; ATexto: String);
  public
    [MVCPath('/')]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/($proc)')]
    [MVCHTTPMethod([httpGET])]
    procedure Query(CTX: TWebContext);

    [MVCPath('/($proc)/($p1)')]
    [MVCHTTPMethod([httpGET])]
    procedure Query1(CTX: TWebContext);

    [MVCPath('/hellos/($FirstName)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetSpecializedHello(const FirstName: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;
  end;

implementation

uses
  MVCFramework.DataSet.Utils, OData.Engine, System.DateUtils, ws.Common,
  ws.Datamodule,
  MVCFramework.Logger;

procedure TODataProcedures.Index;
begin
  // use Context property to access to the HTTP request and response
  Render('use: /OData/OData.proc/($proc)');
end;

procedure TODataProcedures.Query(CTX: TWebContext);
var
  JSONResponse: TJsonObject;
  FProc: TFDStoredProcAuto;
  arr: TjsonArray;
  prm: string;
  i: integer;
begin
  try
    FProc := TFDStoredProcAuto.create(nil);
    try
      JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
      try
        prm := CTX.Request.params['proc']; // SegmentParam('proc', prm);
        FProc.StoredProcName := prm;
        FProc.prepare;
        for i := 0 to FProc.paramCount - 1 do
        begin
          if CTX.Request.QueryStringParamExists(FProc.params[i].name) then
            FProc.params[i].value := CTX.Request.QueryStringParam
              (FProc.params[i].name);
        end;
        FProc.Open;

        // arr := TjsonArray.create;
        arr := TJsonObject.ParseJSONValue(FProc.AsJSONArray) As TjsonArray;
        // Mapper.DataSetToJSONArray(FProc, arr, False);
        if assigned(arr) then
        begin
          JSONResponse.addPair('value', arr);
        end;
        JSONResponse.addPair('@odata.count', IntToStr(FProc.RowsAffected));

        RenderA(JSONResponse);
      finally
        // FreeAndNil(JSONResponse);
      end;
    finally
      FProc.free;
    end;
  except
    on e: Exception do
    begin
      CTX.Response.StatusCode := 501;
      RenderError(CTX, e.message);
    end;
  end;

end;

procedure TODataProcedures.Query1(CTX: TWebContext);
var
  JSONResponse: TJsonObject;
  FProc: TFDStoredProcAuto;
  arr: TjsonArray;
  prm, p1: string;
  i: integer;
begin
  try
    FProc := TFDStoredProcAuto.create(nil);
    try
      JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
      try
        prm := CTX.Request.params['proc']; // SegmentParam('proc', prm);
        FProc.StoredProcName := prm;
        FProc.prepare;
        p1 := CTX.Request.params['p1']; // SegmentParam('p1', p1);
        FProc.params[0].value := p1;
        for i := 0 to FProc.paramCount - 1 do
        begin
          if CTX.Request.QueryStringParamExists(FProc.params[i].name) then
            FProc.params[i].value := CTX.Request.QueryStringParam
              (FProc.params[i].name);
        end;
        FProc.Open;

        // arr := TjsonArray.create;
        // Mapper.DataSetToJSONArray(FProc, arr, False);
        arr := TJsonObject.ParseJSONValue(FProc.AsJSONArray) as TjsonArray;
        if assigned(arr) then
        begin
          JSONResponse.addPair('value', arr);
        end;
        JSONResponse.addPair('@odata.count', IntToStr(FProc.RowsAffected));

        RenderA(JSONResponse);
      finally
        // FreeAndNil(JSONResponse);
      end;
    finally
      FProc.free;
    end;
  except
    on e: Exception do
    begin
      CTX.Response.StatusCode := 501;
      RenderError(CTX, e.message);
    end;
  end;

end;

procedure TODataProcedures.RenderError(CTX: TWebContext; ATexto: String);
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
      Render(js);
      exit;
    end;
  end;
  js := TJsonObject.ParseJSONValue(TODataError.create(500, ATexto))
    as TJsonObject;
  Render(js);
end;

procedure TODataProcedures.EndsJson(var AJson: TJsonObject);
begin
  AJson.addPair('EndsAt', DateToISO8601(now));
end;

procedure TODataProcedures.RenderA(AJson: TJsonObject);
begin
  EndsJson(AJson);
  Render(AJson);
end;

function TODataProcedures.CreateJson(CTX: TWebContext; const AValue: string)
  : TJsonObject;
begin
  CTX.Response.SetCustomHeader('OData-Version', '4.0');
  CTX.Response.ContentType := 'application/json';
  result := TJsonObject.create as TJsonObject;
  result.addPair('@odata.context', AValue);
  result.addPair('StartsAt', DateToISO8601(now));
end;

procedure TODataProcedures.GetSpecializedHello(const FirstName: String);
begin
  Render('Hello ' + FirstName);
end;

procedure TODataProcedures.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TODataProcedures.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

initialization

RegisterWSController(TODataProcedures);

end.
