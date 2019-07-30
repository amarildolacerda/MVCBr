unit MVCBr.HTTPRestClient.Common;

interface

uses System.Classes, System.SysUtils;

Type

  THTTPRestMethod = (rmGET, rmPUT, rmPOST, rmPATCH, rmOPTIONS, rmDELETE);

  TMVCBrHttpRestClientAbstract = class(TComponent)
  private
    FMethod: THTTPRestMethod;
    FResourcePrefix: string;
    FBody: TStrings;
    FAcceptCharset: string;
    FResource: string;
    FBaseURL: string;
    FTimeout: integer;
    FAcceptEncoding: string;
    FAccept: String;
    FContentType: string;
    FCustomHeaders: TStrings;
    FResponseCode: integer;
    FContent: String;
    procedure SetContentType(const Value: string);
  protected
    procedure SetAccept(const Value: String); virtual;
    procedure SetAcceptCharset(const Value: string); virtual;
    procedure SetAcceptEncoding(const Value: string); virtual;
    procedure SetBaseURL(const Value: string); virtual;
    procedure SetBody(const Value: TStrings); virtual;
    procedure SetMethod(const Value: THTTPRestMethod); virtual;
    procedure SetResource(const Value: string); virtual;
    procedure SetResourcePrefix(const Value: string); virtual;
    procedure SetTimeout(const Value: integer); virtual;
    procedure SetCustomHeaders(const Value: TStrings); virtual;
    procedure SetResponseCode(const Value: integer); virtual;
    procedure SetContent(const Value: String); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CreateURI: string; virtual;
    function Execute(AProc: TProc): boolean; overload; virtual;
    function Execute(): boolean; overload; virtual;
    procedure Prepare; virtual;
    Property Content: String read FContent;
    property ResponseCode: integer read FResponseCode write SetResponseCode;
    property CustomHeaders: TStrings read FCustomHeaders write SetCustomHeaders;

    Property URL: string read CreateURI;
    Property Body: TStrings read FBody write SetBody;
    Property ContentType: string read FContentType write SetContentType;
    Property BaseURL: string read FBaseURL write SetBaseURL;
    Property Resource: string read FResource write SetResource;
    Property ResourcePrefix: string read FResourcePrefix
      write SetResourcePrefix;
    Property Method: THTTPRestMethod read FMethod write SetMethod default rmGET;
    Property AcceptCharset: string read FAcceptCharset write SetAcceptCharset;
    Property Accept: String read FAccept write SetAccept;
    Property AcceptEncoding: string read FAcceptEncoding
      write SetAcceptEncoding;
    Property Timeout: integer read FTimeout write SetTimeout default 30000;
  end;

implementation

{ TMVCBrHttpRestClientAbstract }

constructor TMVCBrHttpRestClientAbstract.Create(AOwner: TComponent);
begin
  inherited;
  FMethod := rmGET;
  FContentType := 'application/json';
  FCustomHeaders := TStringList.Create;
  /// workaroud   403 - Forbidden
  // FIdHTTP.Request.UserAgent :=
  // 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv: 12.0)Gecko / 20100101 Firefox / 12.0 ';
  FBody := TStringList.Create;
  if (csDesigning in ComponentState) and (FAccept = '') then
  begin
    FAcceptCharset := 'UTF-8';
    FAccept := 'application/json';
    // ; odata.metadata=minimal'; // , text/plain, text/html';
    FAcceptEncoding := 'gzip';
    FTimeout := 360000;
  end;

end;

function TMVCBrHttpRestClientAbstract.CreateURI: string;
begin
  result := FBaseURL + FResourcePrefix + FResource;
end;

destructor TMVCBrHttpRestClientAbstract.Destroy;
begin
  FBody.Free;
  FCustomHeaders.Free;
  inherited;
end;

function TMVCBrHttpRestClientAbstract.Execute: boolean;
begin
  result := Execute(nil);
end;

procedure TMVCBrHttpRestClientAbstract.Prepare;
begin

end;

function TMVCBrHttpRestClientAbstract.Execute(AProc: TProc): boolean;
begin
  /// abstract    use inherited
end;

procedure TMVCBrHttpRestClientAbstract.SetAccept(const Value: String);
begin
  FAccept := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetAcceptCharset(const Value: string);
begin
  FAcceptCharset := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetAcceptEncoding(const Value: string);
begin
  FAcceptEncoding := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetBody(const Value: TStrings);
begin
  FBody := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetContent(const Value: String);
begin
  FContent := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetContentType(const Value: string);
begin
  FContentType := Value;
  if (not Value.Contains('application')) and (not Value.Contains('text')) then
    FAcceptCharset := '';
end;

procedure TMVCBrHttpRestClientAbstract.SetCustomHeaders(const Value: TStrings);
begin
  FCustomHeaders := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetMethod(const Value: THTTPRestMethod);
begin
  FMethod := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetResource(const Value: string);
begin
  FResource := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetResourcePrefix(const Value: string);
begin
  FResourcePrefix := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetResponseCode(const Value: integer);
begin
  FResponseCode := Value;
end;

procedure TMVCBrHttpRestClientAbstract.SetTimeout(const Value: integer);
begin
  FTimeout := Value;
end;

end.
