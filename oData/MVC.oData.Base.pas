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
  MVCFramework.JWT, Data.Db, oData.Interf, oData.Dialect,
  oData.Packet.Encode, System.JSON;

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
    procedure RenderError(CTX: TWebContext; ATexto: String); overload;
  private
    // [MVCDoc('General parse OData URI')]
    procedure GetQueryBase(CTX: TWebContext);
    function GetODataResourceAuth(AContext: TWebContext;
      AResource, ARoles: string; var AHandled: boolean;
      AClaimsToCheck: TJWTCheckableClaims = [TJWTCheckableClaim.ExpirationTime,
      TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt]): boolean;
    procedure InternalRender(AJSONValue: TJSONValue;
      AContentType, AContentEncoding: string; AContext: TWebContext;
      AInstanceOwner: boolean); overload;
    procedure RenderError(const AErrorCode: UInt16; const AErrorMessage: string;
      const AContext: TWebContext; const AErrorClassName: string); overload;
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
      var Handled: boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;

  end;

  TODataControllerClass = class of TODataController;

implementation

uses
  MVCServerAutentication,
  System.NetEncoding, MVCFramework.DataSet.Utils, WS.Common, oData.ProxyBase,
  oData.SQL,
  oData.ServiceModel, oData.Engine, oData.GenScript,
{$IFDEF LOGEVENTS}
  System.LogEvents.progress, System.LogEvents,
{$ENDIF}
  System.DateUtils;

procedure TODataController.RenderError(const AErrorCode: UInt16;
  const AErrorMessage: string; const AContext: TWebContext;
  const AErrorClassName: string);
var
  Jo: TJSONObject;
  Status: string;
begin
  AContext.Response.StatusCode := AErrorCode;
  AContext.Response.ReasonString := AErrorMessage;

  Status := 'error';
  if (AErrorCode div 100) = 2 then
    Status := 'ok';

  Jo := TJSONObject.Create;
  Jo.AddPair('status', Status);

  if AErrorClassName = '' then
    Jo.AddPair('classname', TJSONNull.Create)
  else
    Jo.AddPair('classname', AErrorClassName);

  Jo.AddPair('message', AErrorMessage);

  InternalRender(Jo, TMVCConstants.DEFAULT_CONTENT_TYPE,
    TMVCConstants.DEFAULT_CONTENT_CHARSET, AContext, false);
end;

procedure TODataController.InternalRender(AJSONValue: TJSONValue;
  AContentType, AContentEncoding: string; AContext: TWebContext;
  AInstanceOwner: boolean);
var
  Encoding: TEncoding;
  ContentType, JValue: string;
begin
  JValue := AJSONValue.ToJSON;

  AContext.Response.RawWebResponse.ContentType := AContentType + '; charset=' +
    AContentEncoding;
  ContentType := AContentType + '; charset=' + AContentEncoding;

  Encoding := TEncoding.GetEncoding(AContentEncoding);
  try
    AContext.Response.SetContentStream
      (TBytesStream.Create(TEncoding.Convert(TEncoding.Default, Encoding,
      TEncoding.Default.GetBytes(JValue))), ContentType);
  finally
    Encoding.Free;
  end;

  if AInstanceOwner then
    FreeAndNil(AJSONValue)
end;

function TODataController.GetODataResourceAuth(AContext: TWebContext;
  AResource: string; ARoles: string; var AHandled: boolean;
  AClaimsToCheck: TJWTCheckableClaims = [TJWTCheckableClaim.ExpirationTime,
  TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt]): boolean;
var
  JWTValue: TJWT;
  IsAuthorized: boolean;
  AuthHeader: string;
  AuthToken: string;
  ErrorMsg: string;
  FLeewaySeconds: integer;

begin
  AHandled := false;

  if assigned(MVCAutenticationProc) then
  begin
    MVCAutenticationProc(AContext, AHandled);
    if AHandled then
      exit;
  end;

  if EnableAutentication = false then
    exit;
  // Checking token in subsequent requests
  // ***************************************************
  FLeewaySeconds := 300;
  JWTValue := TJWT.Create(AutenticatiorServerSecrets, FLeewaySeconds);
  try
    JWTValue.RegClaimsToChecks := AClaimsToCheck;
    AuthHeader := AContext.Request.Headers['Authentication'];
    if AuthHeader.IsEmpty then
    begin
      RenderError(HTTP_STATUS.Unauthorized, 'Authentication Required',
        AContext, '');
      AHandled := true;
      exit;
    end;

    // retrieve the token from the "authentication bearer" header
    AuthToken := '';
    if AuthHeader.StartsWith('bearer', true) then
    begin
      AuthToken := AuthHeader.Remove(0, 'bearer'.Length).Trim;
{$IFDEF VER300}
      AuthToken := Trim(TNetEncoding.URL.Decode(AuthToken));
{$ELSE}
      AuthToken := Trim(TNetEncoding.URL.URLDecode(AuthToken));
{$ENDIF}
    end;

    // check the jwt
    // if not JWTValue.IsValidToken(AuthToken, ErrorMsg) then
    // begin
    // RenderError(HTTP_STATUS.Unauthorized, ErrorMsg, AContext);
    // AHandled := True;
    // end
    // else

    if not JWTValue.LoadToken(AuthToken, ErrorMsg) then
    begin
      RenderError(HTTP_STATUS.Unauthorized, ErrorMsg, AContext, '');
      AHandled := true;
      exit;
    end;

    if JWTValue.CustomClaims['username'].IsEmpty then
    begin
      RenderError(HTTP_STATUS.Unauthorized,
        'Invalid Token, Authentication Required', AContext, '');
      AHandled := true;
    end
    else
    begin
      IsAuthorized := false;

      AContext.LoggedUser.UserName := JWTValue.CustomClaims['username'];
      AContext.LoggedUser.Roles.AddRange(JWTValue.CustomClaims['roles']
        .Split([',']));
      AContext.LoggedUser.LoggedSince := JWTValue.Claims.IssuedAt;
      AContext.LoggedUser.CustomData := JWTValue.CustomClaims.AsCustomData;

      // FAuthenticationHandler.OnAuthorization(AContext.LoggedUser.Roles,
      // AControllerQualifiedClassName, AActionName, IsAuthorized);

      if IsAuthorized then
      begin
        if JWTValue.LiveValidityWindowInSeconds > 0 then
        begin
          JWTValue.Claims.ExpirationTime :=
            Now + JWTValue.LiveValidityWindowInSeconds * OneSecond;
          AContext.Response.SetCustomHeader('Authentication',
            'bearer ' + JWTValue.GetToken);
        end;
        AHandled := false
      end
      else
      begin
        RenderError(HTTP_STATUS.Forbidden, 'Authorization Forbidden',
          AContext, '');
        AHandled := true;
      end;
    end;
  finally
    JWTValue.Free;
  end;
end;

{ TODataController }

function TODataController.CreateJson(CTX: TWebContext; const AValue: string)
  : IODataJsonPacket;
begin
  CTX.Response.SetCustomHeader('OData-Version', '4.0');
  // CTX.Response.ContentType := 'application/json;odata.metadata=minimal';  // AL - DMVC3, nao consegue buscar conector se houver mais 1 item na lista
  CTX.Response.ContentType := 'application/json';
  result := TODataJsonPacket.Create(AValue);
end;

procedure TODataController.DeleteCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  FDataset: TDataset;
  JSONResponse: IODataJsonPacket;
  Jo: TJSONObject;
  arr: TJsonArray;
  n: integer;
  erro: TJSONObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := GetODataBase.Create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    Jo := JSONResponse.asJsonObject;
    n := FOData.ExecuteDELETE(CTX.Request.Body, Jo);

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
  js: TJSONObject;
begin
  try
    js := TJSONObject.ParseJSONValue(ODataServices.LockJson.ToJSON)
      as TJSONObject;
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
  js: TJSONObject;
  rsp: TJsonArray;
  it: TJSONValue;
begin
  render(ODataServices.ResourceList, true);
end;

procedure TODataController.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  inherited;

end;

procedure TODataController.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: boolean);
begin
  inherited;

end;

procedure TODataController.OPTIONSCollection1(CTX: TWebContext);
var
  FOData: IODataBase;
  JSONResponse: IODataJsonPacket;
  LAllow: string;
  Jo: TJSONObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 200;
    FOData := GetODataBase.Create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    Jo := JSONResponse.asJsonObject;
    FOData.ExecuteOPTIONS(Jo);
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
  Jo: TJSONObject;
  arr: TJsonArray;
  n: integer;
  r, LAllow: string;
  erro: TJSONObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := GetODataBase.Create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    try
      r := CTX.Request.Body;
      Jo := JSONResponse.asJsonObject;
      n := FOData.ExecutePATCH(r, Jo);
      JSONResponse.Counts(n);

      if JSONResponse.TryGetValue<string>('allow', LAllow) then
      begin
        CTX.Response.CustomHeaders.Add('Allow=' + LAllow);
      end;

      if n > 0 then
        CTX.Response.StatusCode := 200
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
  Jo: TJSONObject;
  arr: TJsonArray;
  n: integer;
  r: string;
  erro: TJSONObject;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := GetODataBase.Create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    Jo := JSONResponse.asJsonObject;
    n := FOData.ExecutePOST(CTX.Request.Body, Jo);

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
  JSONResponse: IODataJsonPacket;
  Jo: TJSONObject;
  n: integer;
  Body: string;
begin
  try
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
    CTX.Response.StatusCode := 500;
    FOData := GetODataBase.Create();
    FOData.DecodeODataURL(CTX);
    JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
    Jo := JSONResponse.asJsonObject;
    Body := CTX.Request.Body;
    n := FOData.ExecutePATCH(Body, Jo);

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

var
  lockQueryBase : TObject;
procedure TODataController.GetQueryBase(CTX: TWebContext);
var
  FOData: TODataBase;
  FDataset: TDataset;
  JSONResponse: IODataJsonPacket;
  //Jo: TJSONObject;
  arr: TJsonArray;
  n: integer;
  erro: TJSONObject;
  AHandled: boolean;
  obj : TJSONObject;
  objDataset : TObject;
begin
{$IFDEF LOGEVENTS}
    LogEvents.DoMsg(nil, 0, CTX.Request.PathInfo);
{$ENDIF}
   TMOnitor.Enter(lockQueryBase);
    try
      FOData := GetODataBase.Create();
      FOData.DecodeODataURL(CTX);

      self.GetODataResourceAuth(CTX, FOData.Collection, '', AHandled);
      if AHandled then
        exit;

      //CTX.Response.SetCustomHeader('OData-Version', '4.0');
      //CTX.Response.ContentType := 'application/json';
      //JSONResponse := TODataJsonPacket.Create(CTX.Request.PathInfo);
      JSONResponse := CreateJson(CTX, CTX.Request.PathInfo);
      try

        obj := TJSONObject( JSONResponse.asJsonObject.Clone );
        objDataset := FOData.ExecuteGET(nil,obj);
        if assigned(objDataset) then
        begin
          FDataset := TDataset(objDataset);
          FDataset.first;
          arr := TJSONObject.ParseJSONValue(FDataset.AsJSONArray) as TJsonArray;
          if assigned(arr) then
            JSONResponse.values(arr,True)
          else
            arr.Free;
          if FOData.inLineRecordCount < 0 then
            FOData.inLineRecordCount := FDataset.RecordCount;
        end;
        JSONResponse.Counts(FOData.inLineRecordCount);
        JSONResponse.Tops(FOData.GetParse.oData.Top);
        JSONResponse.skips(FOData.GetParse.oData.Skip);

        RenderA(JSONResponse);
  except
    on e: Exception do
    begin
     if(Assigned(CTX)) then
     begin
      CTX.Response.StatusCode := 501;
      RenderError(CTX, e.message);
     end;
    end;
   end;
   finally
       FreeAndNil(FOData);
       TMOnitor.Exit(lockQueryBase);
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
    render( TJSONObject(AJson.asJsonObject.Clone), True);
end;

procedure TODataController.RenderError(CTX: TWebContext; ATexto: String);
var
  n: integer;
  js: TJSONObject;
begin
  if ATexto.StartsWith('{') then
  begin
    js := TJSONObject.ParseJSONValue(ATexto) as TJSONObject;
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
  js := TJSONObject.ParseJSONValue(TODataError.Create(500, ATexto))
    as TJSONObject;
  render(js);
end;

initialization
lockQueryBase := TObject.Create;
RegisterWSController(TODataController);

finalization
 lockQueryBase.Free;
end.
