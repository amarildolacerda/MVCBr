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

  IWooCommerceProducts = interface
    ['{A4877F7A-1496-471B-9400-F22133C0092F}']
    function This: TObject;
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
    function GetAuth1String: string;
    /// Http
    function &GET(AResource: String): string;
    function &PUT(AResource,ADados: String): string;

    /// WooCommerce resources
    property Products: IWooCommerceProducts read GetProducts;
  end;

Implementation

end.
