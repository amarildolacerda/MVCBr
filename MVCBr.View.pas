unit MVCBr.View;

interface

uses system.Classes, system.SysUtils, MVCBr.Model, MVCBr.Interf;

type

  TViewFactoryClass = class of TViewFactory;

  TViewFactory = class(TMVCInterfacedObject, IView)
  private
    FView: IView;
    FController: IController;
  protected
    function Controller(const AController: IController): IView; virtual;
    function This: TObject; virtual;
  public
    class Function New(AClass: TViewFactoryClass;const AController:IController): IView;
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    function Update: IView; virtual;
  end;

implementation

{ TViewFactory }
function TViewFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

class function TViewFactory.New(AClass: TViewFactoryClass;const AController:IController): IView;
begin
   result := AClass.Create;
   result.Controller(AController);
end;

function TViewFactory.ShowView(const AProc: TProc<IView>): Integer;
begin

  // implements on overrided code

  if assigned(AProc) then
    AProc(self);
end;

function TViewFactory.This: TObject;
begin
  result := self;
end;

function TViewFactory.Update: IView;
begin
  result := self;
end;

end.
