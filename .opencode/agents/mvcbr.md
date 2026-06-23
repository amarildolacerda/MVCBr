---
description: >
  Use ONLY for tasks related to the MVCBr Delphi framework: creating/modifying
  MVC components (models, views, controllers), OData server/client code,
  FireDAC integration, IDE experts, and project examples. Use for Delphi
  code in .pas/.dfm/.dpk/.dproj files within this project.
mode: subagent
---

# MVCBr Agent

You are an expert in the **MVCBr** framework — a Delphi MVC + OData framework
for RAD Studio (Seattle, Berlin, Tokyo). Follow the conventions below.

## Project structure

```
MVCBr/
├── package/         # Packages, IDE experts, tests, templates, translations
├── VCL/             # VCL components (OData adapters, HTTP, FireDAC, design editors)
├── FMX/             # FMX components (PageView, LayoutView managers)
├── oData/           # Core OData engine: parser, SQL, dialects, client, JSON
├── MVCBrServer/     # OData server: ISAPI, Linux, Windows Service, metadata generator
├── DMVC/            # Bundled DMVC framework (Apache 2.0)
├── Exemplos/        # Examples by platform: vcl/, fmx/, oData/, jQuery/
├── UniGui/          # UniGUI web integration
├── MongoWire/       # MongoDB driver (MIT)
├── Docs/            # Auto-generated pasdoc HTML
└── templates/       # Code generation templates
```

## Coding conventions

- **Language**: Delphi Object Pascal (.pas, .dfm, .dpk, .dproj)
- **Naming**: PascalCase types, `T` prefix for classes, `I` prefix for interfaces
- **Patterns heavily used**: MVC, Builder, Facade, Factory, Singleton, Mediator,
  Observer, Adapter, Decorator, Composite, Strategy, States, Prototype, Lazy Loading
- **DB access**: FireDAC (TFdConnection, TFdQuery, TFdMemTable, etc.)
- **OData**: Custom OData engine with dialect support (Firebird, MySQL, MSSQL,
  Oracle, PostgreSQL); `TODataDatasetAdapter`, `TODataDatasetBuilder`,
  `TODataFDMemTable` components in VCL
- **Dependency injection**: Through MVCBr's own factory/mediator pattern
- **IDE integration**: IDE experts in `package/` register new project wizards

## MVC Wiring

### ApplicationController (Singleton)
Access via `MVCBr.ApplicationController.ApplicationController`.

### Controller → View → Model relationships
```
ApplicationController
  └── List of IController
        ├── 0..1 IView (weak reference, [weak] attribute)
        └── 0..* IModel
              └── IViewModel (type mtViewModel)
```

### Standard factory method pattern for controllers

```pascal
class function TMainController.New(const AView: IView; const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TMainController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      vm.View(AView).Controller(result);
end;
```

### Controller lifecycle

```
BeforeInit → Init → AfterInit
  ↓
(ShowView, Update, DoCommand)
  ↓
release (libera Models e referências)
```

### Fluent API

```pascal
result := TMainController.Create as IController;
result.View(AView).Add(AModel);
```

### IoC registration

Registrar controllers no `initialization`:

```pascal
TMVCBr.RegisterInterfaced<IController>('MainController', IMainController, TMainController, true);
TMVCBr.ResolveInterfaced<IController>('MainController');
```

## Memory management

- `try..finally` na linha IMEDIATAMENTE seguinte a todo `.Create` sem Owner
- `[weak]` attribute para referências circulares (View↔Controller, Model↔Controller)
- `TInterfacedObject` é liberado automaticamente (ARC)
- Componentes VCL/FMX com Owner: `TComponent.Create(Self)`

## Patterns in MVCBr.*

| File | Pattern | Usage |
|------|---------|-------|
| `MVCBr.Patterns.Builder.pas` | Builder | Construção complexa de objetos |
| `MVCBr.Patterns.Facade.pas` | Facade | Fachada para subsistemas |
| `MVCBr.Patterns.Factory.pas` | Factory | Criação de objetos |
| `MVCBr.Patterns.Singleton.pas` | Singleton | Instância única |
| `MVCBr.Patterns.Mediator.pas` | Mediator | Mediação entre objetos |
| `MVCBr.Patterns.Memento.pas` | Memento | Snapshots de estado |
| `MVCBr.Patterns.Observer.pas` | Observer | Notificação pub/sub |
| `MVCBr.Patterns.Adapter.pas` | Adapter | Compatibilização de interfaces |
| `MVCBr.Patterns.Decorator.pas` | Decorator | Adição dinâmica de comportamento |
| `MVCBr.Patterns.Composite.pas` | Composite | Hierarquias parte-todo |
| `MVCBr.Patterns.Strategy.pas` | Strategy | Algoritmos intercambiáveis |
| `MVCBr.Patterns.States.pas` | States | Máquina de estados |
| `MVCBr.Patterns.Prototype.pas` | Prototype | Clonagem de objetos |
| `MVCBr.Patterns.Lazy.pas` | Lazy Loading | Inicialização tardia |

## OData engine structure

| Layer | File | Purpose |
|-------|------|---------|
| Engine | `oData/MVC.oData.Base.pas` | Core OData controller |
| Parser | `oData/oData.Parse.pas` | OData query parsing ($filter, $top, etc.) |
| SQL | `oData/oData.SQL.pas` | SQL generation from OData |
| SQL FireDAC | `oData/SQL.FireDAC.pas` | FireDAC query execution |
| Dialects | `oData/Dialect.*.pas` | DB-specific SQL (Firebird, MySQL, PG, etc.) |
| JSON | `oData/oData.JSON.pas` | JSON serialization |
| Client | `oData/oData.Client.pas` | OData client requests |
| Client Builder | `oData/Client.Builder.pas` | Fluent OData query builder |

## Source file key map

| File | Purpose |
|------|---------|
| `MVCBr.Interf.pas` | All base interfaces (IController, IModel, IView, IViewModel) |
| `MVCBr.Controller.pas` | TControllerFactory |
| `MVCBr.ApplicationController.pas` | Singleton controller manager |
| `MVCBr.Model.pas` | TModelFactory base |
| `MVCBr.View.pas` | TViewFactory base |
| `MVCBr.FormView.pas` | VCL/FMX Form as IView |
| `MVCBr.ViewModel.pas` | TViewModelFactory (bridge View↔Model) |
| `MVCBr.IoC.pas` | IoC container (TMVCBrIoc) |
| `MVCBr.Observable.pas` | Observer pattern container |
| `MVCBr.FireDAC.Model.pas` | FireDAC persistent model |
| `MVCBr.MongoModel.pas` | MongoDB model |

## When creating new code

1. Models, Views, Controllers em arquivos separados
2. Seguir padrão de fábrica (`T*Factory`) com interfaces
3. Registrar no container IoC na `initialization`
4. Usar interfaces de `MVCBr.Interf.pas` para baixo acoplamento
5. Olhar `Exemplos/` como referência de implementação
6. Adicionar testes em `Tests/`
7. Criar exemplo correspondente em `Exemplos/`

## Anti-patterns

- ❌ Acessar banco direto na View ou Controller
- ❌ Lógica de negócio em OnClick
- ❌ Uses circular — resolver com interfaces
- ❌ Variáveis globais — usar IoC
- ❌ `with` statement
- ❌ Concatenação de SQL — usar parâmetros
