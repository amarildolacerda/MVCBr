---
name: MVCBr Framework
description: >
  Guia completo para criar e modificar componentes MVC no framework MVCBr:
  Controllers, Models, Views, ViewModels e ApplicationController.
---

# MVCBr Framework — Skill para Criação de Componentes MVC

## Quando usar

Use esta skill ao criar **Controllers**, **Models**, **Views** ou **ViewModels**
novos, ou ao modificar a estrutura MVC existente.

## Arquitetura

```
ApplicationController (Singleton)
  └── Lista de IController
        ├── 0..1 IView (referência fraca, [weak])
        └── 0..* IModel
              └── IViewModel (tipo mtViewModel)
```

### Regras de dependência

| Componente | Conhece | Via |
|------------|---------|-----|
| Controller | View + Models | `FView`, `FModels: TThreadList<IModel>` |
| View | Controller | `FController` (weak) |
| Model | Controller | `FController` (weak) |
| ViewModel | View + Model | `FView`, `FModel` |

## Como criar um Controller

### 1. Interface do Controller

```pascal
unit MeuApp.Controller.Interfaces;

interface

uses
  MVCBr.Interf;

type
  IMeuController = interface(IController)
    ['{SEU-GUID-AQUI}']
    procedure DoSomething;
  end;

implementation

end.
```

### 2. Implementação do Controller

```pascal
unit MeuApp.Controller;

interface

uses
  MVCBr.Interf,
  MVCBr.Controller;

type
  TMeuController = class(TControllerFactory, IMeuController)
  protected
    procedure AfterInit; override;
  public
    class function New(const AView: IView; const AModel: IModel): IController;
    procedure DoSomething;
  end;

implementation

{ TMeuController }

class function TMeuController.New(const AView: IView; const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TMeuController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      vm.View(AView).Controller(result);
end;

procedure TMeuController.AfterInit;
begin
  inherited;
  // Configuração pós-inicialização
end;

procedure TMeuController.DoSomething;
begin
  // Lógica do controller
end;

initialization
  TMVCBr.RegisterInterfaced<IController>('MeuController',
    TInterfaceHelper.GetGuid(IMeuController), TMeuController, True);

finalization
  TMVCBr.Revoke(TInterfaceHelper.GetGuid(IMeuController));

end.
```

## Como criar um Model

### Interface

```pascal
type
  IMeuModel = interface(IModel)
    ['{SEU-GUID}']
    procedure LoadData;
    function GetData: TJSONObject;
  end;
```

### Implementação

```pascal
type
  TMeuModel = class(TModelFactory, IMeuModel)
  private
    FData: TJSONObject;
  public
    procedure AfterInit; override;
    procedure LoadData;
    function GetData: TJSONObject;
  end;
```

## Como criar uma View

A View é tipicamente um TForm ou TFrame que implementa `IView`.

### Form View

```pascal
type
  TfrmMyView = class(TForm, IView)
  private
    [weak]
    FController: IController;
    FViewModel: IViewModel;
  public
    function Controller(const AController: IController): IView;
    function GetController: IController;
    procedure SetController(const AController: IController);
    // ... demais métodos da interface IView
  end;
```

Use `MVCBr.FormView.pas` (`TCustomFormFactory`, `TFormFactory`) como base.

## Como criar uma ViewModel

A ViewModel faz a ponte entre View e Model.

```pascal
type
  TMyViewModel = class(TViewModelFactory, IMyViewModel)
  private
    [weak]
    FView: IView;
    [weak]
    FModel: IModel;
  public
    function View(const AView: IView): IViewModel;
    function Model(const AModel: IModel): IViewModel;
    function UpdateView(const AView: IView): IViewModel;
    function Update(const AModel: IModel): IViewModel;
  end;
```

## Fluent API

Encadeamento de chamadas no padrão do projeto:

```pascal
result := TMeuController.Create as IController;
result.View(AView).Add(AModel);
```

## IoC Container

```pascal
// Registrar
TMVCBr.RegisterInterfaced<IController>('Nome', IID, AClass, bSingleton);

// Resolver
var LController := TMVCBr.ResolveInterfaced<IController>('Nome');

// Anexar instância
TMVCBr.AttachInstance(AInstance);
```

## Lifecycle de Controller

```
BeforeInit → Init → AfterInit
  ↓
ShowView / Update / DoCommand
  ↓
release (libera Models, remove referências)
```

## Memory management

- `try..finally` na linha seguinte a `.Create` sem Owner
- `[weak]` para referências cruzadas Controller↔View, Model↔Controller
- Interfaces (`TInterfacedObject`) usam ARC automático
- `TThreadList<IModel>` para lista thread-safe de Models

## Verificação

- [ ] Controller registrado no IoC via `initialization`
- [ ] Interface com GUID único
- [ ] View usa `[weak]` para referência do Controller
- [ ] Model usa `[weak]` para referência do Controller
- [ ] ViewModel faz bridge View↔Model
- [ ] Exemplo criado em `Exemplos/`
- [ ] Testes adicionados em `Tests/`
