Unit Grupos.DataModel;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{$I+ ..\inc\mvcbr.inc}

uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.FireDACModel,
  MVCBr.FireDACModel.Interf,

  Grupos.DataModel.Interf, // %Interf,
  MVCBr.Controller;

Type
  TGruposDataModel = class(TFireDACModel, IGruposDataModel,
    IThisAs<TGruposDataModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IGruposDataModel; overload;
    class function new(const AController: IController)
      : IGruposDataModel; overload;
    function ThisAs: TGruposDataModel;
  end;

Implementation

constructor TGruposDataModel.Create;
begin
  inherited;
  ModelTypes := [mtPersistent];



end;

destructor TGruposDataModel.Destroy;
begin
  inherited;
end;

function TGruposDataModel.ThisAs: TGruposDataModel;
begin
  result := self;
end;

class function TGruposDataModel.new(): IGruposDataModel;
begin
  result := new(nil);
end;

class function TGruposDataModel.new(const AController: IController)
  : IGruposDataModel;
begin
  result := TGruposDataModel.Create;
  result.Controller(AController);
end;

end.
