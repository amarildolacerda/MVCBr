{
  Amarildo Lacerda
}

unit GoogleApis.Persister;

interface

uses
  System.Classes, System.SysUtils, IdHTTP, IdURI,
  MVCBr.HTTPRestClient.Common, MVCBr.HTTPRestClient, System.Json,
  GoogleApis;

type

  TOAuth2 = class(TComponent)
  public
    AuthURL: string;
    TokenURL: string;
    RedirectURL: string;
    ClientID: string;
    ClientSecret: string;
    Scope: string;
    procedure Close;
    function GetAuthorization(): string;
    function RefreshAuthorization(): string;
  end;

  TGoogleOAuthCredential = class(TCredential)
  strict private
    FScope: string;
    FClientID: string;
    FClientSecret: string;
    FOAuth: TOAuth2;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAuthorization: string; override;
    function RefreshAuthorization: string; override;
    procedure RevokeAuthorization; override;
    procedure Abort; override;

    property ClientID: string read FClientID write FClientID;
    property ClientSecret: string read FClientSecret write FClientSecret;
    property Scope: string read FScope write FScope;
  end;

  TGoogleApisHttpClient = class(THttpClient)
  strict private
    FHttp: THTTPRestClient;

    procedure CreateRequest(AParameters: THttpRequestParameterList);
    function GetRequestUri(const AUri: string;
      AParameters: THttpRequestParameterList): string;
    procedure CheckResponse(const AJsonResponse: string);
  strict protected
    function GetStatusCode: Integer; override;
  public
    constructor Create(AInitializer: TServiceInitializer);
    destructor Destroy; override;

    function Get(const AUri: string; AParameters: THttpRequestParameterList)
      : string; override;
    function Post(const AUri: string; AParameters: THttpRequestParameterList;
      const AJsonRequest: string): string; override;
    function Put(const AUri: string; AParameters: THttpRequestParameterList;
      const AJsonRequest: string): string; override;
    function Patch(const AUri: string; AParameters: THttpRequestParameterList;
      AJsonRequest: string): string; override;
    function Delete(const AUri: string): string; override;
    procedure Abort; override;
  end;

  TGoogleApisJsonSerializer = class(TJsonSerializer)
  strict private
    FSerializer: TJsonValue;
  public
    constructor Create;
    destructor Destroy; override;

    function JsonToException(const AJson: string)
      : EGoogleApisException; override;
    function ExceptionToJson(E: EGoogleApisException): string; override;

    function JsonToObject(AType: TClass; const AJson: string): TObject;
      override;
    function ObjectToJson(AObject: TObject): string; override;
  end;

  TGoogleApisServiceInitializer = class(TServiceInitializer)
  strict private
    FHttpClient: THttpClient;
    FJsonSerializer: TJsonSerializer;
  strict protected
    function GetHttpClient: THttpClient; override;
    function GetJsonSerializer: TJsonSerializer; override;
  public
    constructor Create(ACredential: TCredential; const ApplicationName: string);
    destructor Destroy; override;
  end;

implementation

uses System.Json.Helper, System.Classes.Helper;

{ TGoogleOAuthCredential }

procedure TGoogleOAuthCredential.Abort;
begin
  FOAuth.Close();
end;

constructor TGoogleOAuthCredential.Create;
begin
  inherited Create();
  FOAuth := TOAuth2.Create(nil);
end;

destructor TGoogleOAuthCredential.Destroy;
begin
  FOAuth.Free();
  inherited Destroy();
end;

function TGoogleOAuthCredential.GetAuthorization: string;
begin
  FOAuth.AuthURL := 'https://accounts.google.com/o/oauth2/auth';
  FOAuth.TokenURL := 'https://accounts.google.com/o/oauth2/token';
  FOAuth.RedirectURL := 'http://localhost';
  FOAuth.ClientID := ClientID;
  FOAuth.ClientSecret := ClientSecret;
  FOAuth.Scope := Scope;

  Result := FOAuth.GetAuthorization();
end;

function TGoogleOAuthCredential.RefreshAuthorization: string;
begin
  Result := FOAuth.RefreshAuthorization();
end;

procedure TGoogleOAuthCredential.RevokeAuthorization;
begin
  FOAuth.Close();
end;

{ TGoogleApisHttpClient }

procedure TGoogleApisHttpClient.Abort;
begin
end;

procedure TGoogleApisHttpClient.CheckResponse(const AJsonResponse: string);
begin
  if (FHttp.ResponseCode >= 300) then
  begin
    if true { (FHttp.Response.ToLower().IndexOf('json') > -1) } then
    begin
      raise Initializer.JsonSerializer.JsonToException(AJsonResponse);
    end
    else
    begin
      raise exception.Create('Code: ' + FHttp.ResponseCode.ToString +
        ' Message: ' + AJsonResponse);
    end;
  end;
end;

constructor TGoogleApisHttpClient.Create(AInitializer: TServiceInitializer);
begin
  inherited Create(AInitializer);

  FHttp := THTTPRestClient.Create(nil);
  FHttp.HttpClient.UserAgent := Initializer.ApplicationName;
  // FHttp.SilentHTTP := True;
end;

procedure TGoogleApisHttpClient.CreateRequest(AParameters
  : THttpRequestParameterList);
var
  i: Integer;
begin
  try
    FHttp.AcceptCharset := 'UTF-8';
    FHttp.CustomHeaders.clear;
    for i := 0 to AParameters.Count - 1 do
    begin
      FHttp.CustomHeaders.AddPair(AParameters[i].Name, AParameters[i].Value);
    end;
  except
    raise;
  end;
end;

function TGoogleApisHttpClient.Delete(const AUri: string): string;
var
  resp: TStringStream;
begin
  resp := TStringStream.Create('', TEncoding.UTF8, False);
  try

    // FHttp.Request.Authentication.Authentication := Initializer.Credential.GetAuthorization();
    FHttp.Method := rmDELETE;
    FHttp.Resource := AUri;
    FHttp.Execute();

    CheckResponse(FHttp.Content);

    Result := resp.DataString;
  finally
    resp.Free();
  end;
end;

destructor TGoogleApisHttpClient.Destroy;
begin
  FHttp.Free();
  inherited Destroy();
end;

function TGoogleApisHttpClient.Get(const AUri: string;
  AParameters: THttpRequestParameterList): string;
var
  i: Integer;
begin
  try
    // FHttp.Request.Authentication
    // FHttp.Authorization := Initializer.Credential.GetAuthorization();
    FHttp.Method := rmGET;
    FHttp.Resource := AUri;
    CreateRequest(AParameters);
    FHttp.Execute();
    Result := FHttp.Content;
    CheckResponse(Result);
  finally
  end;
end;

function TGoogleApisHttpClient.GetRequestUri(const AUri: string;
  AParameters: THttpRequestParameterList): string;
begin
  try
    Result := Trim(FHttp.URL);
    if (Result <> '') then
    begin
      Result := '?' + Result;
    end;
    // Result := TclUrlParser.EncodeUrl(AUri, 'UTF-8') + Result;
    Result := TIdURI.URLEncode(AUri) + Result;
  finally
  end;
end;

function TGoogleApisHttpClient.GetStatusCode: Integer;
begin
  Result := FHttp.ResponseCode;
end;

function TGoogleApisHttpClient.Patch(const AUri: string;
  AParameters: THttpRequestParameterList; AJsonRequest: string): string;
var
  req: TStringStream;
  resp: TStringStream;
begin
  req := nil;
  // resp := nil;
  try
    req := TStringStream.Create(AJsonRequest, TEncoding.UTF8);
    resp := TStringStream.Create('', TEncoding.UTF8, False);


    // resp := TStringStream.Create('', TEncoding.UTF8, False);

    // FHttp.Authorization := Initializer.Credential.GetAuthorization();

    // FHttp.SendRequest('PATCH', GetRequestUri(AUri, AParameters), req, resp);

    FHttp.Method := rmPATCH;
    FHttp.Execute();

    FHttp.Patch(AUri, req, resp);

    CheckResponse(resp.DataString);

    Result := resp.DataString;
  finally
    resp.Free();
    req.Free();
  end;
end;

function TGoogleApisHttpClient.Post(const AUri: string;
  AParameters: THttpRequestParameterList; const AJsonRequest: string): string;
var
  req: TStringStream;
  resp: TStringStream;
begin
  req := nil;
  resp := nil;
  try
    req := TStringStream.Create(AJsonRequest, TEncoding.UTF8);

    resp := TStringStream.Create('', TEncoding.UTF8, False);

    // FHttp.Authorization := Initializer.Credential.GetAuthorization();

    FHttp.Post(GetRequestUri(AUri, AParameters), req, resp);

    CheckResponse(resp.DataString);

    Result := resp.DataString;
  finally
    resp.Free();
    req.Free();
  end;
end;

function TGoogleApisHttpClient.Put(const AUri: string;
  AParameters: THttpRequestParameterList; const AJsonRequest: string): string;
var
  req, resp: TStringStream;
begin
  req := nil;
  resp := nil;
  try
    req := TStringStream.Create(AJsonRequest, TEncoding.UTF8, False);
    resp := TStringStream.Create('', TEncoding.UTF8, False);

    // FHttp.Authorization := Initializer.Credential.GetAuthorization();
    FHttp.Request.ContentType := 'application/json';

    FHttp.Put(GetRequestUri(AUri, AParameters), req, resp);

    CheckResponse(resp.DataString);

    Result := resp.DataString;
  finally
    resp.Free();
    req.Free();
  end;
end;

{ TGoogleApisServiceInitializer }

constructor TGoogleApisServiceInitializer.Create(ACredential: TCredential;
  const ApplicationName: string);
begin
  inherited Create(ACredential, ApplicationName);

  FHttpClient := nil;
  FJsonSerializer := nil;
end;

destructor TGoogleApisServiceInitializer.Destroy;
begin
  FHttpClient.Free();
  FJsonSerializer.Free();

  inherited Destroy();
end;

function TGoogleApisServiceInitializer.GetHttpClient: THttpClient;
begin
  if (FHttpClient = nil) then
  begin
    FHttpClient := TGoogleApisHttpClient.Create(Self);
  end;
  Result := FHttpClient;
end;

function TGoogleApisServiceInitializer.GetJsonSerializer: TJsonSerializer;
begin
  if (FJsonSerializer = nil) then
  begin
    FJsonSerializer := TGoogleApisJsonSerializer.Create();
  end;
  Result := FJsonSerializer;
end;

{ TGoogleApisJsonSerializer }

constructor TGoogleApisJsonSerializer.Create;
begin
  inherited Create();
  FSerializer := TJsonObject.Create;
end;

destructor TGoogleApisJsonSerializer.Destroy;
begin
  FSerializer.Free();
  inherited Destroy();
end;

function TGoogleApisJsonSerializer.ExceptionToJson
  (E: EGoogleApisException): string;
begin
  Result := E.ToJson; // 'FSerializer.ObjectToJson(E);';
end;

function TGoogleApisJsonSerializer.JsonToException(const AJson: string)
  : EGoogleApisException;
begin
  Result := EGoogleApisException.Create();
  try
    Result := EGoogleApisException.Create(AJson);
    // 'FSerializer.JsonToObject(Result, AJson) as EGoogleApisException;';
  except
    Result.Free();
    raise;
  end;
end;

function TGoogleApisJsonSerializer.JsonToObject(AType: TClass;
  const AJson: string): TObject;
begin
  Result := TClass.Create; // FSerializer.  JsonToObject(AType, AJson);
  Result.FromJson(AJson);
end;

function TGoogleApisJsonSerializer.ObjectToJson(AObject: TObject): string;
begin
  Result := AObject.ToJson; // FSerializer.ObjectToJson(AObject);
end;

{ TclOAuth }

procedure TOAuth2.Close;
begin

end;

function TOAuth2.GetAuthorization: string;
begin

end;

function TOAuth2.RefreshAuthorization: string;
begin

end;

end.
