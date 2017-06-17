unit MVCBr.OrmModel;

interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Model,
  MVCBr.Controller;

Type

  TOrmModelFactory = class(TModelFactory, IModel)
  protected
    FController: IController;
  public
    function Controller(const AController: IController): IModel;
      reintroduce; virtual;
  end;

implementation

{ TPersistentModelFactory }

function TOrmModelFactory.Controller(const AController: IController): IModel;
begin
  FController := AController;
  ModelTypes := [mtOrmModel];
end;

end.
