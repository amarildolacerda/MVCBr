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

{$DEFINE INDY}

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes,
  MVCBr.Interf, MVCBr.Model,
  WooCommerce.Model.Interf, // %Interf,
  MVCBr.Controller,
  MVCBr.Component;

Type

  TWooCommerceAbstract = class(TMVCFactoryAbstract, IWooCommerce)
  protected
    FBase: string;
    FModel: IWooCommerceModel;
  public
    function This: TObject; virtual;
    function List: string; virtual;
    function Get(AId: string): string; virtual;
    function Count: Integer; virtual;
    function Put(AId: string; AJson: string): string; virtual;
  end;

  // pedidos
  TWooCommerceOrders = class(TWooCommerceAbstract, IWooCommerceOrders)
  public
    class function New(const AModel: IWooCommerceModel): IWooCommerceOrders;
  end;

  // estrutura de produtos
  TWooCommerceProducts = class(TWooCommerceAbstract, IWooCommerceProducts)
  protected
  public
    class function New(AModel: IWooCommerceModel): IWooCommerceProducts;
  end;

  TWooCommerceModel = class(TComponentFactory, IWooCommerceModel,
    IThisAs<TWooCommerceModel>)
  private
    FConsumerSecret: string;
    FConsumerKey: string;
    FProducts: IWooCommerceProducts;
    FOrders: IWooCommerceOrders;
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
    function GetOrders: IWooCommerceOrders;
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
    function GetAuth1String(RESTRequest: TObject): string;
    property Content: string read GetContent write SetContent;
    property CodeResponse: Integer read GetCodeResponse write SetCodeResponse;
    property BaseURL: string read GetBaseURL write SetBaseURL;
    property ResourcePrefix: string read GetResourcePrefix
      write SetResourcePrefix;
    /// WooCommerce methods
    property Products: IWooCommerceProducts read GetProducts;
    property Orders: IWooCommerceOrders read GetOrders;

  end;

Implementation

uses
{$IFDEF INDY}
  MVCBr.HTTPRestClient, Rest.OAuth,
{$ELSE}
  Dialogs,
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
  FProducts := TWooCommerceProducts.New(self);
  FOrders := TWooCommerceOrders.New(self);
end;

destructor TWooCommerceModel.Destroy;
begin
  inherited;
end;

{$IFDEF INDY}

function TWooCommerceModel.Get(AResource: String): string;
var
  LURL: string;
  http: THTTPRestClient;
  sAuth: string;
begin
  FCodeResponse := 0;
  FContent := '';
  LURL := FBaseURL + FResourcePrefix + AResource;
  http := THTTPRestClient.Create(nil);
  try
    http.BaseURL := FBaseURL;
    http.ResourcePrefix := FResourcePrefix;
    http.Resource := AResource;
    try
      try
        sAuth := GetAuth1String(http);
        http.Resource := AResource + '?' + sAuth;
        http.Execute();
        FContent := http.Content;
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

function TWooCommerceModel.GetAuth1String(RESTRequest: TObject): string;
var
  http: THTTPRestClient;
  OAuth: TOAuthConsumer;
  HMAC: TOAuthSignatureMethod_HMAC_SHA1;
  LURL: string;
begin
  http := THTTPRestClient(RESTRequest);
  // workaround to 403 - forbidden
  // http.IdHTTP.Request.UserAgent :=
  // 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv: 12.0)Gecko / 20100101 Firefox / 12.0 ';

  LURL := http.URL;

  HMAC := TOAuthSignatureMethod_HMAC_SHA1.Create;
  try
    OAuth := TOAuthConsumer.Create(FConsumerKey, FConsumerSecret);
    try
      // auth1
      with TOAuthRequest.Create(LURL) do
        try
          FromConsumerAndToken(OAuth, nil, LURL);
          Sign_Request(HMAC, OAuth, nil);
          result := GetString;
        finally
          free;
        end;
    finally
      OAuth.free;
    end;
  finally
    HMAC.free;
  end;
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

    RESTRequest.Method := TRESTRequestMethod.rmGET;

    GetAuth1String(RESTRequest);
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

function TWooCommerceModel.GetAuth1String(RESTRequest: TObject): string;
var
  s: string;
  OAuth1_FitBit: TOAuth1Authenticator;
  Rest: TRestRequest;
begin
  Rest := TRestRequest(RESTRequest);
  OAuth1_FitBit := TOAuth1Authenticator.Create(self);
  try
    OAuth1_FitBit.ResetToDefaults;
    OAuth1_FitBit.ConsumerKey := FConsumerKey;
    OAuth1_FitBit.COnsumerSecret := FConsumerSecret;

    if Rest.Method = TRESTRequestMethod.rmGET then
    begin
      // OK Funcionou
      Rest.AddParameter('oauth_consumer_key', FConsumerKey);
      Rest.AddParameter('oauth_signature_method', 'HMAC-SHA1');
      Rest.AddParameter('oauth_nonce', OAuth1_FitBit.nonce);
      Rest.AddParameter('oauth_timestamp',
        OAuth1_FitBit.timeStamp.DeQuotedString);
      Rest.AddParameter('oauth_version', '1.0');
      s := OAuth1_FitBit.SigningClass.BuildSignature(Rest, OAuth1_FitBit);
      Rest.AddParameter('oauth_signature', s);
      result := '';
    end
    else
    begin // OK funcionou
      result := 'oauth_consumer_key=' + FConsumerKey +
        '&oauth_signature_method=HMAC-SHA1' + '&oauth_nonce=' +
        OAuth1_FitBit.nonce + '&oauth_timestamp=' +
        OAuth1_FitBit.timeStamp.DeQuotedString + '&oauth_version=1.0';
      s := OAuth1_FitBit.SigningClass.BuildSignature(Rest, OAuth1_FitBit);
      result := result + '&oauth_signature=' + s;

      Rest.Resource := Rest.Resource + '?' + result;

    end;
  finally
    OAuth1_FitBit.free;
  end;

end;
{$ENDIF}

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

function TWooCommerceModel.GetOrders: IWooCommerceOrders;
begin
  result := FOrders;
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

/// nao esta funcionado... alguma coisa com autenticacao, talves
function TWooCommerceModel.Put(AResource, ADados: String): string;
var
  LURL: string;
  http: THTTPRestClient;
  sAuth: string;
begin
  FCodeResponse := 0;
  FContent := '';
  LURL := FBaseURL + FResourcePrefix + AResource;
  http := THTTPRestClient.Create(nil);
  try
    http.BaseURL := FBaseURL;
    http.ResourcePrefix := FResourcePrefix;
    http.Resource := AResource;
    http.Method := THTTPRestMethod.rmPUT;
    http.Body.text := ADados;
    try
      try
        sAuth := GetAuth1String(http);
        http.Resource := AResource + '?' + sAuth;
        http.Execute();
        FContent := http.Content;
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
    RESTClient.Authenticator := nil; // OAuth1_FitBit;
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

    RESTRequest.Method := TRESTRequestMethod.rmPUT;
    RESTRequest.Body.Add(ADados, ctAPPLICATION_JSON);

    GetAuth1String(RESTRequest);

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

function TWooCommerceAbstract.Count: Integer;
var
  j: IJsonObject;
begin
  FModel.&GET(FBase + '/count');
  j := TInterfacedJSON.New(FModel.Content);
  if not j.IsNull then
    result := j.JSONObject.I('count');
end;

class function TWooCommerceProducts.New(AModel: IWooCommerceModel)
  : IWooCommerceProducts;
var
  o: TWooCommerceProducts;
begin
  o := TWooCommerceProducts.Create;
  o.FModel := AModel;
  o.FBase := '/products';
  result := o;
end;

function TWooCommerceAbstract.Put(AId, AJson: string): string;
begin
  result := FModel.Put(FBase + '/' + AId, AJson);
end;

{ TWooCommerceOrders }

function TWooCommerceAbstract.Get(AId: string): string;
begin
  result := FModel.Get(FBase + '/' + AId);
end;

function TWooCommerceAbstract.List: string;
begin
  result := FModel.Get(FBase);
end;

class function TWooCommerceOrders.New(const AModel: IWooCommerceModel)
  : IWooCommerceOrders;
var
  o: TWooCommerceOrders;
begin
  o := TWooCommerceOrders.Create();
  o.FModel := AModel;
  o.FBase := '/orders';
  result := o;
end;

{ TWooCommerceAbstract }

function TWooCommerceAbstract.This: TObject;
begin
  result := self;
end;

Initialization

TMVCRegister.RegisterType<IWooCommerceModel, TWooCommerceModel>
  (TWooCommerceModel.classname, true);

end.
