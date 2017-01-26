unit MVCBr.ValidateModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TValidateModelFactory = class(TModelFactory, IValidateModel)
  protected
    FController:IController;
  public
    function Controller(const AController: IController): IValidateModel;

  end;

implementation

{ TPersistentModelFactory }

function TValidateModelFactory.Controller(const AController: IController)
  : IValidateModel;
begin
   FController := AController;
end;

end.
