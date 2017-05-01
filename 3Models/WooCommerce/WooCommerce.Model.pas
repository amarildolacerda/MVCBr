{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 01/05/2017 11:09:29                                  // }
{ //************************************************************// }
Unit WooCommerce.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$define INDY }

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  WooCommerce.Model.Interf, // %Interf,
  MVCBr.Controller,
  MVCBr.Component;

Type

  TWooCommerceProduct = class(TMVCFactoryAbstract, IWooCommerceProducts)
  protected
    FModel: IWooCommerceModel;

  const
    base: string = '/products';
  public
    class function New(AModel: IWooCommerceModel): IWooCommerceProducts;
    function This: TObject;
    function Count: Integer;
    function Get(AId: string): string;
    function Put(AId: string; AJson: string): string;
    function List: string;
  end;

  TWooCommerceModel = class(TComponentFactory, IWooCommerceModel,
    IThisAs<TWooCommerceModel>)
  private
    FConsumerSecret: string;
    FConsumerKey: string;
    FProducts: IWooCommerceProducts;
    FContent: string;
    FBaseURL: string;
    FCodeResponse: Integer;
    FResourcePrefix: string;
    procedure SetConsumerKey(const Value: string);
    procedure SetConsumerSecret(const Value: string);
    function GetConsumerKey: string;
    function GetCOnsumerSecret: string;
    function GetProducts: IWooCommerceProducts;
    procedure SetContent(const Value: string);
    function GetContent: string;
    procedure SetBaseURL(const Value: string);
    function GetBaseURL: string;
    procedure SetCodeResponse(const Value: Integer);
    function GetCodeResponse: Integer;
    procedure SetResourcePrefix(const Value: string);
    function GetResourcePrefix: string;
  protected
    function &GET(AResource: String): string; virtual;
    function &PUT(AResource, ADados: String): string; virtual;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    class function New(): IWooCommerceModel; overload;
    class function New(const AController: IController)
      : IWooCommerceModel; overload;
    function ThisAs: TWooCommerceModel;
    // implementaçoes

    /// login
    ///
    procedure SetConfig(AConsumerKey, AConsumerSecret: string);
    property ConsumerKey: string read GetConsumerKey write SetConsumerKey;
    property COnsumerSecret: string read GetCOnsumerSecret
      write SetConsumerSecret;
    function GetAuth1String: string;
    property Content: string read GetContent write SetContent;
    property CodeResponse: Integer read GetCodeResponse write SetCodeResponse;
    property BaseURL: string read GetBaseURL write SetBaseURL;
    property ResourcePrefix: string read GetResourcePrefix
      write SetResourcePrefix;
    /// WooCommerce methods
    property Products: IWooCommerceProducts read GetProducts;
  end;

Implementation

uses
{$IFDEF INDY}
  IdHttp, Rest.OAuth,
{$ELSE}
  Rest.Utils,
  Rest.Types,
  Rest.Client,
  Rest.Response.Adapter,
  Rest.Authenticator.Simple,
  Rest.Authenticator.Basic,
  Rest.Authenticator.OAuth,
  IPPeerClient,
{$ENDIF}
  System.Json.Helper;

constructor TWooCommerceModel.Create(AOwner: TComponent);
begin
  inherited;
  FProducts := TWooCommerceProduct.New(self);
end;

destructor TWooCommerceModel.Destroy;
begin
  inherited;
end;

{$IFDEF INDY}

function TWooCommerceModel.Get(AResource: String): string;
var
  LURL: string;
  OAuth: TOAuthConsumer;
  http: TIdHttp;
  HMAC: TOAuthSignatureMethod_HMAC_SHA1;
begin
  FCodeResponse := 0;
  FContent := '';
  LURL := FBaseURL + FResourcePrefix + AResource;
  HMAC := TOAuthSignatureMethod_HMAC_SHA1.Create;
  try
    OAuth := TOAuthConsumer.Create(FConsumerKey, FConsumerSecret);
    try
      // auth1
      with TOAuthRequest.Create(LURL) do
        try
          FromConsumerAndToken(OAuth, nil, LURL);
          Sign_Request(HMAC, OAuth, nil);
          LURL := LURL + '?' + GetString;
        finally
          free;
        end;
    finally
      OAuth.free;
    end;
  finally
    HMAC.free;
  end;

  http := TIdHttp.Create(nil);
  try
    try
      try
        http.Request.ContentType := 'application/json; charset= UTF-8';
        FContent := http.Get(LURL);
      finally
        FCodeResponse := http.ResponseCode;
      end;
    except
      on e: exception do
        self.FContent := e.message;
    end;
  finally
    http.free;
  end;
  result := FContent;
end;
{$ELSE}

function TWooCommerceModel.Get(AResource: String): string;
var
  s: String;
  RESTRequest: TRestRequest;
  RESTClient: TRestClient;
  RESTResponse: TRESTResponse;
  OAuth1_FitBit: TOAuth1Authenticator;
begin
  RESTRequest := TRestRequest.Create(self);
  RESTClient := TRestClient.Create(self);
  RESTResponse := TRESTResponse.Create(self);
  OAuth1_FitBit := TOAuth1Authenticator.Create(self);
  try
    RESTClient.Authenticator := nil;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Client := RESTClient;

    RESTRequest.ResetToDefaults;
    RESTClient.ResetToDefaults;
    RESTResponse.ResetToDefaults;
    OAuth1_FitBit.ResetToDefaults;

    OAuth1_FitBit.ConsumerKey := FConsumerKey;
    OAuth1_FitBit.COnsumerSecret := FConsumerSecret;

    RESTClient.BaseURL := FBaseURL + FResourcePrefix;

    RESTRequest.Resource := AResource;

    RESTRequest.AddParameter('oauth_consumer_key', FConsumerKey);
    RESTRequest.AddParameter('oauth_signature_method', 'HMAC-SHA1');
    RESTRequest.AddParameter('oauth_nonce', OAuth1_FitBit.nonce);
    RESTRequest.AddParameter('oauth_timestamp',
      OAuth1_FitBit.timeStamp.DeQuotedString);
    RESTRequest.AddParameter('oauth_version', '1.0');
    s := OAuth1_FitBit.SigningClass.BuildSignature(RESTRequest, OAuth1_FitBit);
    RESTRequest.AddParameter('oauth_signature', s);

    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    FContent := RESTResponse.Content;
    result := FContent;

    FCodeResponse := RESTResponse.StatusCode;

  finally
    RESTRequest.free;
    RESTClient.free;
    RESTResponse.free;
    OAuth1_FitBit.free;
  end;
end;
{$ENDIF}

function TWooCommerceModel.GetAuth1String: string;
begin

end;

function TWooCommerceModel.GetBaseURL: string;
begin
  result := FBaseURL;
end;

function TWooCommerceModel.GetCodeResponse: Integer;
begin
  result := FCodeResponse;
end;

function TWooCommerceModel.GetConsumerKey: string;
begin
  result := FConsumerKey;
end;

function TWooCommerceModel.GetCOnsumerSecret: string;
begin
  result := FConsumerSecret;
end;

function TWooCommerceModel.GetContent: string;
begin
  result := FContent;
end;

function TWooCommerceModel.GetProducts: IWooCommerceProducts;
begin
  result := FProducts;
end;

function TWooCommerceModel.GetResourcePrefix: string;
begin
  result := FResourcePrefix;
end;

function TWooCommerceModel.ThisAs: TWooCommerceModel;
begin
  result := self;
end;

class function TWooCommerceModel.New(): IWooCommerceModel;
begin
  result := New(nil);
end;

class function TWooCommerceModel.New(const AController: IController)
  : IWooCommerceModel;
begin
  result := TWooCommerceModel.Create(nil);
  result.Controller(AController);
end;

{$IFDEF INDY}

function TWooCommerceModel.Put(AResource, ADados: String): string;
begin

end;
{$ELSE}

function TWooCommerceModel.Put(AResource, ADados: String): string;
var
  s: String;
  RESTRequest: TRestRequest;
  RESTClient: TRestClient;
  RESTResponse: TRESTResponse;
  OAuth1_FitBit: TOAuth1Authenticator;
begin
  RESTRequest := TRestRequest.Create(self);
  RESTClient := TRestClient.Create(self);
  RESTResponse := TRESTResponse.Create(self);
  OAuth1_FitBit := TOAuth1Authenticator.Create(self);
  try
    RESTClient.Authenticator := OAuth1_FitBit;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Client := RESTClient;

    RESTRequest.ResetToDefaults;
    RESTClient.ResetToDefaults;
    RESTResponse.ResetToDefaults;
    OAuth1_FitBit.ResetToDefaults;

    OAuth1_FitBit.ConsumerKey := FConsumerKey;
    OAuth1_FitBit.COnsumerSecret := FConsumerSecret;

    RESTClient.BaseURL := FBaseURL + FResourcePrefix;

    RESTRequest.Resource := AResource + '?' + 'oauth_consumer_key=' +
      FConsumerKey + '&oauth_signature_method=HMAC-SHA1' + '&oauth_nonce=' +
      OAuth1_FitBit.nonce + '&oauth_timestamp=' +
      OAuth1_FitBit.timeStamp.DeQuotedString + '&oauth_version=1.0';
    s := OAuth1_FitBit.SigningClass.BuildSignature(RESTRequest, OAuth1_FitBit);
    RESTRequest.Resource := RESTRequest.Resource + '&oauth_signature=' + s;

    RESTRequest.Method := TRESTRequestMethod.rmPUT;
    RESTRequest.Body.Add(ADados, ctAPPLICATION_JSON);
    RESTRequest.Execute;

    FContent := RESTResponse.Content;
    result := FContent;

    FCodeResponse := RESTResponse.StatusCode;

  finally
    RESTRequest.free;
    RESTClient.free;
    RESTResponse.free;
    OAuth1_FitBit.free;
  end;
end;

{$ENDIF}

procedure TWooCommerceModel.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TWooCommerceModel.SetCodeResponse(const Value: Integer);
begin
  FCodeResponse := Value;
end;

procedure TWooCommerceModel.SetConfig(AConsumerKey, AConsumerSecret: string);
begin
  ConsumerKey := AConsumerKey;
  COnsumerSecret := AConsumerSecret;
end;

procedure TWooCommerceModel.SetConsumerKey(const Value: string);
begin
  FConsumerKey := Value;
end;

procedure TWooCommerceModel.SetConsumerSecret(const Value: string);
begin
  FConsumerSecret := Value;
end;

procedure TWooCommerceModel.SetContent(const Value: string);
begin
  FContent := Value;
end;

procedure TWooCommerceModel.SetResourcePrefix(const Value: string);
begin
  FResourcePrefix := Value;
end;

{ TWooCommerceProduct }

function TWooCommerceProduct.Count: Integer;
var
  j: IJsonObject;
begin
  FModel.Content := FModel.&GET(base + '/count');
  j := TInterfacedJSON.New(FModel.Content);
  if not j.IsNull then
    result := j.JSONObject.I('count');
end;

function TWooCommerceProduct.Get(AId: string): string;
begin
  result := FModel.Get(base + '/' + AId);
end;

function TWooCommerceProduct.List: string;
begin
  result := FModel.Get(base);
end;

class function TWooCommerceProduct.New(AModel: IWooCommerceModel)
  : IWooCommerceProducts;
var
  o: TWooCommerceProduct;
begin
  o := TWooCommerceProduct.Create;
  o.FModel := AModel;
  result := o;
end;

function TWooCommerceProduct.Put(AId, AJson: string): string;
begin
  result := FModel.Put(base + '/' + AId, AJson);
end;

function TWooCommerceProduct.This: TObject;
begin
  result := self;
end;

Initialization

TMVCRegister.RegisterType<IWooCommerceModel, TWooCommerceModel>
  (TWooCommerceModel.classname, true);

end.
