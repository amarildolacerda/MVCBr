unit MVCBr.IdHTTPRestClient;

interface

uses System.Classes, System.SysUtils,
  System.Generics.Collections, Data.DB,
  IdHTTP;

type

  TIdHTTPRestMethod = (rmGET, rmPUT, rmPOST, rmPATCH, rmOPTIONS, rmDELETE);

  TIdHTTPRestClient = class(TComponent)
  private
    FIdHTTP: TIdCustomHTTP;
    FContent: string;
    FBaseURL: string;
    FResource: string;
    FMethod: TIdHTTPRestMethod;
    FAcceptCharset: string;
    FAccept: String;
    FAcceptEncoding: string;
    FResourcePreffix: string;
    FTimeout: integer;
    FBody: TStrings;
    procedure SetBaseURL(const Value: string);
    procedure SetResource(const Value: string);
    procedure SetMethod(const Value: TIdHTTPRestMethod);
    procedure SetAcceptCharset(const Value: string);
    procedure SetAccept(const Value: String);
    procedure SetAcceptEncoding(const Value: string);
    procedure SetResourcePreffix(const Value: string);
    procedure SetTimeout(const Value: integer);
    procedure SetBody(const Value: TStrings);
  protected
    function CreateURI: string;
    procedure Loaded; override;
  public
    function Execute(AProc: TProc): boolean; overload; virtual;
    function Execute(): boolean; overload; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    Property Content: String read FContent;
    Property IdHTTP: TIdCustomHTTP read FIdHTTP;
  published
    Property Body: TStrings read FBody write SetBody;
    Property BaseURL: string read FBaseURL write SetBaseURL;
    Property Resource: string read FResource write SetResource;
    Property ResourcePreffix: string read FResourcePreffix
      write SetResourcePreffix;
    Property Method: TIdHTTPRestMethod read FMethod write SetMethod
      default rmGET;
    Property AcceptCharset: string read FAcceptCharset write SetAcceptCharset;
    Property Accept: String read FAccept write SetAccept;
    Property AcceptEncoding: string read FAcceptEncoding
      write SetAcceptEncoding;
    Property Timeout: integer read FTimeout write SetTimeout default 30000;
  end;

implementation

Uses
  System.JSON;

{ TIdHTTPRestClient }

procedure TIdHTTPRestClient.Loaded;
begin
  inherited;

end;

constructor TIdHTTPRestClient.Create(AOwner: TComponent);
begin
  inherited;
  FIdHTTP := TIdCustomHTTP.Create(self);
  FBody := TStringList.Create;
  if (csDesigning in ComponentState) and (FAccept = '') then
  begin
    FAcceptCharset := 'UTF-8';
    FAccept := 'application/json, text/plain, text/html';
    FAcceptEncoding := 'gzip';
    FTimeout := 30000;
  end;
end;

function TIdHTTPRestClient.CreateURI: string;
begin
  result := FBaseURL + FResourcePreffix + FResource;
end;

destructor TIdHTTPRestClient.destroy;
begin
  FBody.DisposeOf;
  inherited;
end;

function TIdHTTPRestClient.Execute: boolean;
begin
  result := Execute(nil);
end;

function TIdHTTPRestClient.Execute(AProc: TProc): boolean;
var
  streamSource: TMemoryStream;
  streamResponse: TMemoryStream;
begin
  result := false;
  streamSource := TMemoryStream.Create;
  streamResponse := TMemoryStream.Create;
  try
    FIdHttp.Request.AcceptCharSet := FAcceptCharset;
    FIdHttp.Request.AcceptEncoding := FAcceptEncoding;
    FIdHTTP.Request.Accept := FAccept;
    if assigned(FBody) and (FBody.Count > 0) then
      FBody.SaveToStream(streamSource);
    streamSource.Position := 0;
    case FMethod of
      rmGET:
        FContent := FIdHTTP.Get(CreateURI);
      rmPUT:
        FContent := FIdHTTP.Put(CreateURI, streamSource);
      rmPOST:
        FContent := FIdHTTP.Post(CreateURI, streamSource);
      rmPATCH:
        FContent := FIdHTTP.Patch(CreateURI, streamSource);
      rmOPTIONS:
        FContent := FIdHTTP.Options(CreateURI);
      rmDELETE:
        FContent := FIdHTTP.Delete(CreateURI);
    end;
    result := (FIdHTTP.Response.ResponseCode >= 200) and
      (FIdHTTP.Response.ResponseCode <= 299);
    if assigned(AProc) then
      AProc();
  finally
    streamSource.DisposeOf;
    streamResponse.DisposeOf;
  end;

end;

procedure TIdHTTPRestClient.SetAccept(const Value: String);
begin
  FAccept := Value;
end;

procedure TIdHTTPRestClient.SetAcceptCharset(const Value: string);
begin
  FAcceptCharset := Value;
end;

procedure TIdHTTPRestClient.SetAcceptEncoding(const Value: string);
begin
  FAcceptEncoding := Value;
end;

procedure TIdHTTPRestClient.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TIdHTTPRestClient.SetBody(const Value: TStrings);
begin
  FBody := Value;
end;

procedure TIdHTTPRestClient.SetMethod(const Value: TIdHTTPRestMethod);
begin
  FMethod := Value;
end;

procedure TIdHTTPRestClient.SetResource(const Value: string);
begin
  FResource := Value;
end;

procedure TIdHTTPRestClient.SetResourcePreffix(const Value: string);
begin
  FResourcePreffix := Value;
end;

procedure TIdHTTPRestClient.SetTimeout(const Value: integer);
begin
  FTimeout := Value;
end;

end.
