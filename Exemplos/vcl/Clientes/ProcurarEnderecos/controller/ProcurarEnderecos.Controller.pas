unit ProcurarEnderecos.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI,
  ProcurarEnderecos.ViewModel, ProcurarEnderecos.ViewModel.Interf,
  ProcurarEnderecosView;

type
  IProcurarEnderecosController = interface(IController)
    ['{B3F512F9-A6BA-41B0-A83E-58277D7BE0C0}']
    // incluir especializações aqui
  end;

  TProcurarEnderecosController = class(TControllerFactory,
    IProcurarEnderecosController, IThisAs<TProcurarEnderecosController>,
    IModelAs<IProcurarEnderecosViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TProcurarEnderecosController;
    procedure init; override;
    function ModelAs: IProcurarEnderecosViewModel;
  end;

implementation

Constructor TProcurarEnderecosController.Create;
begin
  inherited;
  add(TProcurarEnderecosViewModel.New(self)
    .ID('{ProcurarEnderecos.ViewModel}'));
  CreateModules; // < criar os modulos persolnizados
end;

Destructor TProcurarEnderecosController.Destroy;
begin
  inherited;
end;

class function TProcurarEnderecosController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TProcurarEnderecosController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TProcurarEnderecosController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TProcurarEnderecosController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

function TProcurarEnderecosController.ThisAs: TProcurarEnderecosController;
begin
  result := self;
end;

function TProcurarEnderecosController.ModelAs: IProcurarEnderecosViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IProcurarEnderecosViewModel, result);
end;

Procedure TProcurarEnderecosController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TProcurarEnderecosController.init;
var
  ref: TObject; // TMainView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TProcurarEnderecosView, ref);
    supports(ref, IView, FView);
  end;
  afterinit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TProcurarEnderecosController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TProcurarEnderecosController.New(TProcurarEnderecosView.New,TProcurarEnderecosViewModel.New)).init();
//RegisterClass(TProcurarEnderecosController);

  RegisterInterfacedClass(TProcurarEnderecosController.ClassName,IProcurarEnderecosController,TProcurarEnderecosController );

finalization

//UnRegisterClass(TProcurarEnderecosController);

end.
