{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 01/05/2017 11:08:32                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit WooCommerceSampleView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls,
  WooCommerce.Model.Interf, VCL.ExtCtrls;

type
  /// Interface para a VIEW
  IWooCommerceSampleView = interface(IView)
    ['{49CBF0C6-8996-4AAD-B61C-569840FFE159}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TWooCommerceSampleView = class(TFormFactory { TFORM } , IView,
    IThisAs<TWooCommerceSampleView>, IWooCommerceSampleView,
    IViewAs<IWooCommerceSampleView>)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    Memo1: TMemo;
    LabeledEdit3: TLabeledEdit;
    Button2: TButton;
    LabeledEdit4: TLabeledEdit;
    Button3: TButton;
    LabeledEdit5: TLabeledEdit;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FInited: Boolean;
    function GetWooCommerceModel: IWooCommerceModel;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TWooCommerceSampleView;
    function ViewAs: IWooCommerceSampleView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.DFM}
uses System.Json.Helper;


function TWooCommerceSampleView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TWooCommerceSampleView.ViewAs: IWooCommerceSampleView;
begin
  result := self;
end;

class function TWooCommerceSampleView.New(aController: IController): IView;
begin
  result := TWooCommerceSampleView.create(nil);
  result.Controller(aController);
end;

function TWooCommerceSampleView.GetWooCommerceModel: IWooCommerceModel;
begin
  result := getModel<IWooCommerceModel>;
  result.BaseURL := LabeledEdit3.text;
  result.ResourcePrefix := '/wc-api/v3';
  result.SetConfig(LabeledEdit1.text, LabeledEdit2.text);
end;

procedure TWooCommerceSampleView.Button1Click(Sender: TObject);
var
  woo: IWooCommerceModel;
begin
  woo := GetWooCommerceModel;
  woo.Products.Count;
  Memo1.lines.add('Response: ' + woo.Content);
end;

procedure TWooCommerceSampleView.Button2Click(Sender: TObject);
begin
   with GetWooCommerceModel do
   begin
     memo1.lines.add( Products.List );
   end;
end;

procedure TWooCommerceSampleView.Button3Click(Sender: TObject);
var json:IJsonObject;
begin
   with GetWooCommerceModel do
   begin
     memo1.lines.add(  Products.Get( LabeledEdit4.text  ) );

     with TInterfacedJSON.new(Content) do
     try
       LabeledEdit5.text := JSONObject.O('product').S('price');
     finally
     end;

   end;
end;

procedure TWooCommerceSampleView.Button4Click(Sender: TObject);
var j:IJsonObject;
begin
   if LabeledEdit5.text <>'' then
     with GetWooCommerceModel do
     begin
        j := TInterfacedJSON.new();
        j.addChild('product', '{"regular_price":"'+labeledEdit5.text+'"}');
        Products.Put(LabeledEdit4.text, j.ToJson );
        memo1.lines.clear;
        memo1.lines.add(Content);
     end;
end;

function TWooCommerceSampleView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TWooCommerceSampleView.Init;
begin
  // incluir incializações aqui
end;

function TWooCommerceSampleView.This: TObject;
begin
  result := inherited This;
end;

function TWooCommerceSampleView.ThisAs: TWooCommerceSampleView;
begin
  result := self;
end;

function TWooCommerceSampleView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
