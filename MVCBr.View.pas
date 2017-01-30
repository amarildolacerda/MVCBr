unit MVCBr.View;

interface

uses Forms, system.Classes, system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf;

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
    class Function New(AClass: TViewFactoryClass;
      const AController: IController): IView;
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    function Update: IView; virtual;
  end;


  TFormFactory = class(TForm, IMVCBase)
  private
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
  protected
  public
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
  end;

implementation

{ TViewFactory }
function TViewFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

class function TViewFactory.New(AClass: TViewFactoryClass;
  const AController: IController): IView;
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

{ TViewFormFacotry }
function TFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self,AMethod,args);
end;

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(Self,ANome,Value);
end;

end.
