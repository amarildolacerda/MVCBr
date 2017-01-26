unit MVCBr.NavigatorModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TNavigatorModelFactory = class(TModelFactory, INavigatorModel)
  protected
    FController:IController;
  public
    function Controller(const AController: IController): INavigatorModel;

  end;

implementation

{ TPersistentModelFactory }

function TNavigatorModelFactory.Controller(const AController: IController)
  : INavigatorModel;
begin
   FController := AController;
end;

end.
