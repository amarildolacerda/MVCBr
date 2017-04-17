unit MVCgzipMiddleware;

interface

uses System.Classes, System.SysUtils, MVCFramework,
  IdZLibCompressorBase, IdCompressorZLib, IDZlib;

type

  TMVCgzipCallBackMiddleware = class(TInterfacedObject, IMVCMiddleware)
  protected
    /// <summary>
    /// Procedure is called before the MVCEngine routes the request to a specific controller/method.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnBeforeRouting(Context: TWebContext; var Handled: Boolean);
    /// <summary>
    /// Procedure is called before the specific controller method is called.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="AControllerQualifiedClassName">Qualified classname of the matching controller.</param>
    /// <param name="AActionNAme">Method name of the matching controller method.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnBeforeControllerAction(Context: TWebContext; const AControllerQualifiedClassName: string; const aActionName: string; var Handled: Boolean);
    /// <summary>
    /// Procedure is called after the specific controller method was called.
    /// It is still possible to cancel or to completly modifiy the request.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="AActionNAme">Method name of the matching controller method.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnAfterControllerAction(Context: TWebContext; const aActionName: string; const Handled: Boolean);
  end;

implementation

uses {$IFDEF LINUX} {$ELSE}VCL.Dialogs, {$ENDIF} System.Generics.collections, IdGlobal, IdHTTPWebBrokerBridge,
  IdCustomHTTPServer, IdZLibHeaders;

type
  TFileCompressed = class(TObject)
  public
    FileName: string;
    stream: TMemoryStream;
    constructor Create(sFile: string);
    destructor Destroy; override;
  end;

  TFilesCompressed = class(TObjectList<TFileCompressed>)
  public
    function GetFile(sName: string): TFileCompressed;
  end;

var
  LLockFile: TObject;

function TFilesCompressed.GetFile(sName: string): TFileCompressed;
var
  I: Integer;
  it: TFileCompressed;
begin
  result := nil;
  try
    TMonitor.Enter(LLockFile);
    for it in self do
      if sametext(it.FileName, sName) then
      begin
        result := it; // items[I];
        result.stream.Seek(0, TSeekOrigin.soBeginning);
        exit;
      end;

    try
      result := TFileCompressed.Create(sName);
      result.stream.Seek(0, TSeekOrigin.soBeginning);
    except
      begin
        FreeAndNil(result);
        result := nil;
        raise;
      end;
    end;

    Add(result);
  finally
    TMonitor.exit(LLockFile);
  end;

end;

constructor TFileCompressed.Create(sFile: string);
var
  lCompressor: TIdCompressorZLib;
  lTmpStream: TFileStream;
begin
  inherited Create;
  FileName := sFile;
  stream := TMemoryStream.Create;
  lCompressor := TIdCompressorZLib.Create;
  try
    lTmpStream := TFileStream.Create(sFile, fmShareDenyNone);
    try
      lTmpStream.Position := 0;
      lCompressor.CompressStream(lTmpStream, stream, 9, GZIP_WINBITS, 9, 0);
    finally
      lTmpStream.free;
    end;
  finally
    lCompressor.free;
  end;
end;

destructor TFileCompressed.Destroy;
begin
  FileName := '';
  stream.free;
  inherited Destroy;
end;

var
  LFilesCompressed: TFilesCompressed;

const
  SERROR_404 = 'Erro(1) 404 página não encontrada "%s"';

{$D+}

procedure CompressHttpResponseStream(Context: TWebContext; sFileName: String);
var
  lFile: TFileCompressed;
  b: Boolean;
begin
  with Context do
    if {$IFDEF WIN32} pos('gzip', Response.RawWebResponse.ContentEncoding) > 0 {$ELSE} Response.RawWebResponse.ContentEncoding.Contains('gzip'){$ENDIF} then
      try
        lFile := LFilesCompressed.GetFile(sFileName);
        if assigned(lFile) then
        begin
          Response.RawWebResponse.Content := '';
          Response.RawWebResponse.ContentLength := 0;
          Response.RawWebResponse.ContentStream := TMemoryStream.Create;
          System.TMonitor.Enter(lFile);
          try
            Response.RawWebResponse.ContentStream.CopyFrom(lFile.stream, lFile.stream.Size);
          finally
            System.TMonitor.exit(lFile);
          end;
          Response.RawWebResponse.ContentLength := Response.RawWebResponse.ContentStream.Size;
          Response.RawWebResponse.ContentEncoding := 'gzip';
        end;
        Response.RawWebResponse.SendResponse;
      except
        Response.RawWebResponse.Content := Format(SERROR_404, [sFileName]);
      end;
end;

type
  TIdHTTPAppRequestHack = class(TIdHTTPAppRequest)
  public
    property RequestInfo: TIdHTTPRequestInfo read FRequestInfo;
  end;

  TIdHTTPAppResponseHack = class(TIdHTTPAppResponse)

  end;
{$D+}

procedure CompressHttpResponse(Context: TWebContext);
var
  lCompressor: TIdCompressorZLib;
  lTmpStream: TMemoryStream;
  sResponse: String;
  bLocal: Boolean;
begin
  exit;
  with Context do
    try
      if (TIdHTTPAppRequestHack(Request.RawWebRequest).RequestInfo.AcceptEncoding.Contains('gzip')) and (Response.ContentType.Contains('json')) then
      begin
        bLocal := true;
        sResponse := Response.RawWebResponse.Content;
        // showmessage(sResponse);
        lCompressor := TIdCompressorZLib.Create;
        try
          lTmpStream := TMemoryStream.Create();
          try

            if assigned(Response.RawWebResponse.ContentStream) then
            begin
              if Context.Response.RawWebResponse.ContentStream.Size < 0004 then
                exit;
              sResponse := ReadStringFromStream(Response.RawWebResponse.ContentStream, -1, IndyTextEncoding_UTF8);
            end
            else
              Response.RawWebResponse.ContentStream := TMemoryStream.Create;

            Response.RawWebResponse.Content := '';
            Response.RawWebResponse.ContentLength := 0;
            WriteStringToStream(lTmpStream, sResponse, IndyTextEncoding_UTF8);
            lTmpStream.Position := 0;
            lCompressor.CompressStream(lTmpStream, Response.RawWebResponse.ContentStream, 9, GZIP_WINBITS, 9, 0);
            // or other suitable byte encoding
            Response.RawWebResponse.ContentLength := Response.RawWebResponse.ContentStream.Size;
            Response.RawWebResponse.ContentEncoding := 'gzip;';
            // TIdHTTPAppResponse(Response).CharSet := 'UTF-8';
            Response.RawWebResponse.SendResponse;
          finally
            lTmpStream.free;
          end;
        finally
          lCompressor.free;
        end;
      end
      else
        Response.RawWebResponse.ContentEncoding := '';
    except
      Response.RawWebResponse.Content := Format(SERROR_404, ['']);
    end;

end;

{ TMVCgzipCallBackMiddleware }

procedure TMVCgzipCallBackMiddleware.OnAfterControllerAction(Context: TWebContext; const aActionName: string; const Handled: Boolean);
begin
  CompressHttpResponse(Context);
end;

procedure TMVCgzipCallBackMiddleware.OnBeforeControllerAction(Context: TWebContext; const AControllerQualifiedClassName, aActionName: string;
  var Handled: Boolean);
begin

end;

procedure TMVCgzipCallBackMiddleware.OnBeforeRouting(Context: TWebContext; var Handled: Boolean);
begin

end;

initialization

LLockFile := TObject.Create;

finalization

LLockFile.free;

end.
