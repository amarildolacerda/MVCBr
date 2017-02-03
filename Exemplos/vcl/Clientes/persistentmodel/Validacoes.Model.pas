Unit Validacoes.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  Validacoes.Model.Interf, // %Interf,
  MVCBr.Controller;

Type
  TValidacoesModel = class(TModelFactory, IValidacoesModel,
    IThisAs<TValidacoesModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IValidacoesModel; overload;
    class function new(const AController: IController)
      : IValidacoesModel; overload;
    function ThisAs: TValidacoesModel;

    // implmentacao
    function ValidarCEP(aCEP: string): Boolean;

  end;

Implementation

uses Dialogs;

constructor TValidacoesModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TValidacoesModel.Destroy;
begin
  inherited;
end;

function TValidacoesModel.ThisAs: TValidacoesModel;
begin
  result := self;
end;

function TValidacoesModel.ValidarCEP(aCEP: string): Boolean;
begin
  showmessage('CEP: ' + aCEP);
end;

class function TValidacoesModel.new(): IValidacoesModel;
begin
  result := new(nil);
end;

class function TValidacoesModel.new(const AController: IController)
  : IValidacoesModel;
begin
  result := TValidacoesModel.Create;
  result.Controller(AController);
end;

end.
