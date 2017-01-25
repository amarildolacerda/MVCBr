unit MVCBr.ApplicationController;

interface

uses {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes,
  System.Generics.Collections,
  System.SysUtils, MVCBr.Model, MVCBr.Interf;

type

  TApplicationController = class(TMVCInterfacedObject, IApplicationController)
  private
    FMainView: IView;
    FControllers: TList<IController>;
    function Count: integer;
    function Add(AController: IController): integer;
    procedure Delete(const idx: integer);

  public
    constructor create;
    destructor destroy; override;
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil);
    class function New: IApplicationController;
  end;

function ApplicationController: IApplicationController;
procedure SetApplicationController(AController: IApplicationController);

implementation

var
  FApplication: IApplicationController;

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

function TApplicationController.Add(AController: IController): integer;
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
  FControllers := TList<IController>.create;
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

class function TApplicationController.New: IApplicationController;
begin
  result := TApplicationController.create;
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
    application.CreateForm(AClass, reference);
    if not supports(reference, IView) then
      raise Exception.create('Não é uma classe que implementa IView');
    FMainView := reference as IView;
    if assigned(AController) then
      AController.View(FMainView);
    if assigned(AModel) then
      AController.Add(AModel);

    application.Run;
  end;

end;

initialization


end.
