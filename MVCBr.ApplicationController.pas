unit MVCBr.ApplicationController;

interface

uses Forms, System.Classes,
  System.Generics.Collections,
  System.SysUtils, MVCBr.Model, MVCBr.Interf;

type

  TApplicationController = class(TMVCInterfacedObject, IApplicationController)
  private
    FControllers: TMVCInterfacedList<IController>;
  protected
    FMainView: IView;
  public
    constructor create;
    destructor destroy; override;
    function Count: integer;
    function Add(const AController: IController): integer;
    procedure Delete(const idx: integer);
    procedure Remove(const AController: IController);
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil); overload;
    procedure Run(AController: IController;
      AFunc: TFunc < boolean >= nil); overload;
    class function New: IApplicationController;
    procedure DoLoop( AProc:TProc<IController>);
  end;

function ApplicationController: IApplicationController;
procedure SetApplicationController(AController: IApplicationController);

procedure RegisterInterfacedClass(const ANome:string; const IID:TGUID;  AClass:TInterfacedClass);
procedure UnregisterInterfacedClass(const ANome:string);

implementation

var
  FApplication: IApplicationController;

procedure RegisterInterfacedClass(const ANome:string; const IID:TGUID;  AClass:TInterfacedClass);
begin

end;

procedure UnregisterInterfacedClass(const ANome:string);
begin

end;


function ApplicationController(): IApplicationController;
begin
  if not assigned(FApplication) then
    FApplication := TApplicationController.New;
  result := FApplication;
end;

procedure SetApplicationController(AController: IApplicationController);
begin
  FApplication := nil; // limpa a instancia carregada;
  FApplication := AController;
end;

{ TApplicationController }

function TApplicationController.Add(const AController: IController): integer;
begin
  result := -1;
  if assigned(AController) then
  begin
    FControllers.Add(AController);
    result := FControllers.Count - 1;
  end;
end;

function TApplicationController.Count: integer;
begin
  result := FControllers.Count;
end;

constructor TApplicationController.create;
begin
  inherited create;
  FControllers := TMVCInterfacedList<IController>.create;
end;

procedure TApplicationController.Delete(const idx: integer);
begin
  FControllers.Delete(idx);
end;

destructor TApplicationController.destroy;
begin
  FControllers.Free;
  inherited;
end;

procedure TApplicationController.DoLoop(AProc: TProc<IController>);
var i:integer;
begin
   if Assigned(AProc) then
   for I := 0 to FControllers.Count-1 do
      AProc(FControllers.Items[i] as IController);
end;

class function TApplicationController.New: IApplicationController;
begin
  result := TApplicationController.create;
end;

procedure TApplicationController.Remove(const AController: IController);
begin
  FControllers.Remove(AController);
end;

procedure TApplicationController.Run(AController: IController;
  AFunc: TFunc<boolean>);
begin
  Run(nil, AController, nil, AFunc);
end;

procedure TApplicationController.Run(AClass: TComponentClass;
  AController: IController; AModel: IModel; AFunc: TFunc<boolean>);
var
  rt: boolean;
  reference: TComponent;
  Controller: TObject;
  LContrInterf: IController;
begin
  application.Initialize;

  rt := true;
  if assigned(AFunc) then
    rt := AFunc;

  if rt then
  begin
    if assigned(AController) then
      AController.init;
    if (AClass <> nil) and (Application.MainForm=nil) then
    begin
      application.CreateForm(AClass, reference);
      if not supports(reference, IView) then
        raise Exception.create('Não é uma classe que implementa IView');
      FMainView := reference as IView;
    end;

    if assigned(AModel) then
      if AController.IndexOf(AModel) < 0 then
        AController.Add(AModel);

    if supports(application.MainForm, IView, FMainView) then
    begin
      if assigned(AController) then
        AController.View(FMainView);
      FMainView.ShowView(nil);
    end;

  end;
    if assigned(AController) then
      AController.AfterInit;

end;

initialization

end.
