{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/08/2017 10:21:37                                  // }
{ //************************************************************// }

Unit ModelValidacao.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  ModelValidacao.Model.Interf, // %Interf,
  MVCBr.Controller;

Type

  TModelValidacaoModel = class(TModelFactory, IModelValidacaoModel,
    IThisAs<TModelValidacaoModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IModelValidacaoModel; overload;
    class function new(const AController: IController)
      : IModelValidacaoModel; overload;
    function ThisAs: TModelValidacaoModel;

    // implementaçoes
    function Validar(cpf: string): boolean;
  end;

Implementation

uses ACBrValidador;

constructor TModelValidacaoModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TModelValidacaoModel.Destroy;
begin
  inherited;
end;

function TModelValidacaoModel.ThisAs: TModelValidacaoModel;
begin
  result := self;
end;

function TModelValidacaoModel.Validar(cpf: string): boolean;
begin
  result := ValidarCNPJouCPF(cpf);
end;

class function TModelValidacaoModel.new(): IModelValidacaoModel;
begin
  result := new(nil);
end;

class function TModelValidacaoModel.new(const AController: IController)
  : IModelValidacaoModel;
begin
  result := TModelValidacaoModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IModelValidacaoModel, TModelValidacaoModel>
  (TModelValidacaoModel.classname, true);

end.
