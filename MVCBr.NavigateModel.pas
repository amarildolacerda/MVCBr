unit MVCBr.NavigateModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TNavigateModelFactory = class(TModelFactory, INavigatorModel)
  protected
    FController:IController;
  public
    function Controller(const AController: IController): INavigatorModel;reintroduce;virtual;

  end;

implementation

{ TPersistentModelFactory }

function TNavigateModelFactory.Controller(const AController: IController)
  : INavigatorModel;
begin
   FController := AController;
end;

end.
