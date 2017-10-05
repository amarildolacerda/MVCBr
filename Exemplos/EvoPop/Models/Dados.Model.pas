{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/09/2017 21:58:41                                  // }
{ //************************************************************// }

Unit Dados.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  Dados.Model.Interf, // %Interf,
  Data.DB,
  MVCBr.Controller;

Type

  TDadosModel = class(TModelFactory, IDadosModel, IThisAs<TDadosModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IDadosModel; overload;
    class function new(const AController: IController): IDadosModel; overload;
    function ThisAs: TDadosModel;

    // implementaçoes
    procedure CarregarDataset(arquivo: string; ADataset: TDataset);
  end;

Implementation

uses Data.DB.Helper, System.JSON, System.JSON.Helper;

procedure TDadosModel.CarregarDataset(arquivo: string; ADataset: TDataset);
begin

  with TInterfacedJSON.new do
  begin
    /// carrega o arquivo do disco
    LoadFromFile(arquivo);

    /// preenche o dataset
    ADataset.FromJsonObject(JSONObject, true);

  end;

end;

constructor TDadosModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TDadosModel.Destroy;
begin
  inherited;
end;

function TDadosModel.ThisAs: TDadosModel;
begin
  result := self;
end;

class function TDadosModel.new(): IDadosModel;
begin
  result := new(nil);
end;

class function TDadosModel.new(const AController: IController): IDadosModel;
begin
  result := TDadosModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IDadosModel, TDadosModel>
  (TDadosModel.classname, true);

end.
