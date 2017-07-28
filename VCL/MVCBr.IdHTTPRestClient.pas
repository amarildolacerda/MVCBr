unit MVCBr.IdHTTPRestClient;

interface

uses System.Classes, System.SysUtils,
  System.Generics.Collections, Data.DB,
  MVCBr.HTTPRestClient.Common,
  IdGlobal, IdHTTP;

type


  TIdHTTPRestClient = class(TMVCBrHttpRestClientAbstract)
  private
    FIdHTTP: TIdCustomHTTP;
    function GetIdHTTP: TIdCustomHTTP;virtual;
  protected
  public
    function Execute(AProc: TProc): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    Property IdHTTP: TIdCustomHTTP read GetIdHTTP;
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


constructor TIdHTTPRestClient.Create(AOwner: TComponent);
begin
  inherited;
  FIdHTTP := TIdCustomHTTP.Create(self);
  /// workaroud   403 - Forbidden
  FIdHTTP.Request.UserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv: 12.0)Gecko / 20100101 Firefox / 12.0 ';

  if (csDesigning in ComponentState) and (Accept = '') then
  begin
    AcceptCharset := 'UTF-8';
    Accept := 'application/json';//; odata.metadata=minimal'; // , text/plain, text/html';
    AcceptEncoding := 'gzip';
    Timeout := 360000;
  end;
end;

destructor TIdHTTPRestClient.destroy;
begin
  inherited;
end;

function TIdHTTPRestClient.GetIdHTTP: TIdCustomHTTP;
begin
  result := FIdHTTP;
end;

function TIdHTTPRestClient.Execute(AProc: TProc): boolean;
var
  streamSource: TStringStream;
  i:integer;
begin
  result := false;
  streamSource := TStringStream.Create;
  try
    if AcceptCharset='' then
       AcceptCharset := 'UTF-8';
    IdHTTP.Request.AcceptCharset := AcceptCharset;
    IdHTTP.Request.Charset := AcceptCharset;
    IdHTTP.Request.AcceptEncoding := AcceptEncoding;
    IdHTTP.Request.Accept := Accept ;
    IdHTTP.Request.ContentType := 'application/json'+'; charset='+AcceptCharset;
    IdHTTP.ReadTimeout := Timeout;
    IdHTTP.ConnectTimeout := 60000;
    if assigned(Body) and (Body.Count > 0) then
     for I := 0 to Body.count-1 do
      streamSource.WriteString(Body[i]);
    streamSource.Position := 0;
    case Method of
      rmGET:
        SetContent( IdHTTP.Get(CreateURI) );
      rmPUT:
        SetContent( IdHTTP.Put(CreateURI, streamSource) );
      rmPOST:
        SetContent( IdHTTP.Post(CreateURI, Body) );
      rmPATCH:
        SetContent( IdHTTP.Patch(CreateURI, streamSource));
      rmOPTIONS:
        SetContent( IdHTTP.Options(CreateURI));
      rmDELETE:
        SetContent( IdHTTP.Delete(CreateURI));
    end;
    result := (IdHTTP.Response.ResponseCode >= 200) and
      (IdHTTP.Response.ResponseCode <= 299);
    if assigned(AProc) then
      AProc();
  finally
    freeAndNil(streamSource);
  end;

end;

end.

