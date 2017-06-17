unit MVCBr.NavigateModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TNavigateModelFactory = class(TModelFactory, INavigateModel)
  protected
    FController:IController;
  public
    function Controller(const AController: IController): INavigateModel;reintroduce;virtual;

  end;

implementation

{ TPersistentModelFactory }

function TNavigateModelFactory.Controller(const AController: IController)
  : INavigateModel;
begin
   FController := AController;
end;

end.
