unit MVCBr.HTTPRestClient;

interface

uses System.Classes, System.SysUtils,
  System.Generics.Collections, Data.DB,
  MVCBr.HTTPRestClient.Common,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

type


  THTTPRestClient = class(TMVCBrHttpRestClientAbstract)
  private
    FHTTP: TNetHTTPClient;
    function GetHTTP: TNetHTTPClient;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    Property HttpClient: TNetHTTPClient read GetHTTP;
    function Execute(AProc: TProc): boolean; overload; override;
    function Execute(): boolean; overload; virtual;
  published
    Property URL;
    Property Body;
    Property BaseURL;
    Property Resource;
    Property ResourcePrefix;
    Property Method;
    Property AcceptCharset;
    Property Accept;
    Property AcceptEncoding;
    Property Timeout;
  end;

implementation

Uses
  System.JSON;

{ TIdHTTPRestClient }


constructor THTTPRestClient.Create(AOwner: TComponent);
begin
  inherited;
  FHTTP := TNetHTTPClient.Create(self);
end;


destructor THTTPRestClient.destroy;
begin
  inherited;
end;

function THTTPRestClient.Execute: boolean;
begin
  result := Execute(nil);
end;

function THTTPRestClient.GetHTTP: TNetHTTPClient;
begin
  result := FHTTP;
end;

function THTTPRestClient.Execute(AProc: TProc): boolean;
var
  streamSource: TStringStream;
  i: integer;
  Response: IHTTPResponse;
begin
  result := false;
  streamSource := TStringStream.Create;
  try
    if AcceptCharset = '' then
      AcceptCharset := 'UTF-8';

    FHTTP.AcceptCharset := AcceptCharset;
    FHTTP.AcceptCharset := AcceptCharset;
    FHTTP.AcceptEncoding := AcceptEncoding;
    FHTTP.Accept := Accept;

    FHTTP.ContentType := 'application/json' + '; charset=' + AcceptCharset;

{$IF CompilerVersion>=32}
    FHTTP.ResponseTimeout := Timeout;
    FHTTP.ConnectionTimeout := 60000;
{$ENDIF}
    if assigned(Body) and (Body.Count > 0) then
      for i := 0 to Body.Count - 1 do
        streamSource.WriteString(Body[i]);
    Prepare;
    streamSource.Position := 0;

    case Method of
      rmGET:
        Response := FHTTP.Get(CreateURI);
      rmPUT:
        Response := FHTTP.Put(CreateURI, streamSource);
      rmPOST:
        Response := FHTTP.Post(CreateURI, Body);
      rmPATCH:
        Response := FHTTP.Patch(CreateURI, streamSource);
      rmOPTIONS:
        Response := FHTTP.Options(CreateURI);
      rmDELETE:
        Response := FHTTP.Delete(CreateURI);
    end;
    ResponseCode := Response.StatusCode;
    result := (Response.StatusCode >= 200) and (Response.StatusCode <= 299);
    SetContent ( Response.ContentAsString(TEncoding.UTF8) );
    if assigned(AProc) then
      AProc();
  finally
    freeAndNil(streamSource);
  end;

end;


end.
