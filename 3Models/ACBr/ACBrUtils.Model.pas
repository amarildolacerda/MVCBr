Unit ACBrUtils.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  ACBrUtils.Model.Interf, // %Interf,
  MVCBr.Controller;

Type
  TACBrUtilsModel = class(TModelFactory, IACBrUtilsModel,
    IThisAs<TACBrUtilsModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IACBrUtilsModel; overload;
    class function new(const AController: IController)
      : IACBrUtilsModel; overload;
    function ThisAs: TACBrUtilsModel;

    // ACBr
    function EAN13Valido(CodEAN13: String): Boolean;

  end;

Implementation

uses ACBrUtil, ACBrValidador ;

constructor TACBrUtilsModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TACBrUtilsModel.Destroy;
begin
  inherited;
end;

function TACBrUtilsModel.EAN13Valido(CodEAN13: String): Boolean;
begin
  result := ACBrUtil.EAN13Valido(CodEAN13);
end;

function TACBrUtilsModel.ThisAs: TACBrUtilsModel;
begin
  result := self;
end;

class function TACBrUtilsModel.new(): IACBrUtilsModel;
begin
  result := new(nil);
end;

class function TACBrUtilsModel.new(const AController: IController)
  : IACBrUtilsModel;
begin
  result := TACBrUtilsModel.Create;
  result.Controller(AController);
end;

end.
