{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 01/05/2017 11:09:29                                  // }
{ //************************************************************// }
Unit WooCommerce.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface


uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  IWooCommerce = interface
    ['{4C40785E-CA96-48F9-95CD-0D4BBA5DF808}']
    function This: TObject;
  end;

  IWooCommerceOrders = interface(IWooCommerce)
    ['{C37E42EF-3120-4F2D-8009-CAB6C5C1D7C2}']
    function Get(AId: string): string;
    function List: string;
  end;

  IWooCommerceProducts = interface(IWooCommerce)
    ['{A4877F7A-1496-471B-9400-F22133C0092F}']
    function Count: Integer;
    function Get(AId: string): string;
    function Put(AId: string; AJson: string): string;
    function List: string;
  end;

  IWooCommerceModel = interface(IModel)
    ['{FF8618B5-283C-4114-B552-CAA74521D3B5}']
    procedure SetConsumerKey(const Value: string);
    procedure SetCOnsumerSecret(const Value: string);
    function GetConsumerKey: string;
    function GetCOnsumerSecret: string;
    function GetProducts: IWooCommerceProducts;
    function GetOrders: IWooCommerceOrders;
    procedure SetContent(const Value: string);
    function GetContent: string;
    property Content: string read GetContent write SetContent;
    procedure SetBaseURL(const Value: string);
    function GetBaseURL: string;
    property BaseURL: string read GetBaseURL write SetBaseURL;
    procedure SetResourcePrefix(const Value: string);
    function GetResourcePrefix: string;
    property ResourcePrefix: string read GetResourcePrefix
      write SetResourcePrefix;
    /// login
    ///
    procedure SetConfig(AConsumerKey, AConsumerSecret: string);
    property ConsumerKey: string read GetConsumerKey write SetConsumerKey;
    property COnsumerSecret: string read GetCOnsumerSecret
      write SetConsumerSecret;
    //function GetAuth1String: string;
    /// Http
    function &GET(AResource: String): string;
    function &PUT(AResource,ADados: String): string;

    /// WooCommerce resources
    property Products: IWooCommerceProducts read GetProducts;
    property Orders: IWooCommerceOrders read GetOrders;

  end;

Implementation

end.
