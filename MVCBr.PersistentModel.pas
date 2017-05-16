unit MVCBr.PersistentModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TPersistentModelFactory = class(TModelFactory, IPersistentModel)
  protected
    FController:IController;
  public
    function Controller(const AController: IController): IPersistentModel;reintroduce;virtual;

  end;

implementation

{ TPersistentModelFactory }

function TPersistentModelFactory.Controller(const AController: IController)
  : IPersistentModel;
begin
   FController := AController;
end;

end.
