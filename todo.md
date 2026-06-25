# Todo - Testes a Complementar / Criar

## Legenda
- ✅ Teste existe
- ⚠️ Teste existe mas incompleto (muitos `// TODO: Validate method results`)
- ❌ Sem teste

## Core MVC - Testes Incompletos (melhorar)

| Arquivo | Teste | Status |
|---------|-------|--------|
| `MVCBr.Controller.pas` | `TestMVCBr.Controller.pas` | ✅ TODOs resolvidos — 30 testes, todas com asserções reais |
| `MVCBr.Model.pas` | `TestMVCBrModel.pas` | ✅ TODOs resolvidos — 16 testes, todas com asserções reais |
| `MVCBr.View.pas` | `TestMVCBr.View.pas` | ✅ Sem TODOs — 23 testes, cobertura básica completa |
| `MVCBr.ApplicationController.pas` | (via Controller) | ⚠️ Sem teste direto, apenas via controller |

## Core MVC - Sem Teste (criar)

| Prioridade | Arquivo | Linhas | Descrição |
|------------|---------|--------|-----------|
| ~~🔴 Alta~~ | ~~`MVCBr.FormView.pas`~~ | ~~962~~ | ~~Factory de Form View (VCL/FMX)~~ ✅ `TestMVCBr.FormView.pas` — 27 testes, todos passando |
| ~~🔴 Alta~~ | ~~`MVCBr.FrameView.pas`~~ | ~~249~~ | ~~Factory de Frame View~~ ✅ `TestMVCBr.FrameView.pas` — 15 testes, todos passando |
| ~~🔴 Alta~~ | ~~`MVCBr.PageView.pas`~~ | ~~707~~ | ~~Gerenciador de PageView/IPageView~~ ✅ `TestMVCBr.PageView.pas` — 18 testes (2 fixtures), todos passando |
| ~~🔴 Alta~~ | ~~`MVCBr.ViewModel.pas`~~ | ~~144~~ | ✅ `TestMVCBr.ViewModel.pas` — 13 testes, todos passando |
| ~~🔴 Alta~~ | ~~`MVCBr.Observable.pas`~~ | ~~692~~ | ✅ `TestMVCBr.Observable.pas` — 14 testes (2 fixtures), 91/91 passando |
| ~~🟡 Média~~ | ~~`MVCBr.Component.pas`~~ | ~~206~~ | ~~TComponent implementing IModel~~ ✅ `TestMVCBr.Component.pas` — 8 testes, todos passando |
| ~~🟡 Média~~ | ~~`MVCBr.InterfaceHelper.pas`~~ | ~~311~~ | ~~RTTI helper para interfaces~~ ✅ `TestMVCBr.InterfaceHelper.pas` — 8 testes, todos passando |
| 🟡 Média | `MVCBr.BuilderModel.pas` | 164 | Builder pattern como Model |
| 🟡 Média | `MVCBr.DatabaseModel.pas` | 275 | Model genérico de banco |
| 🟡 Média | `MVCBr.MiddlewareFactory.pas` | 198 | Middleware via Mediator |
| 🟡 Média | `MVCBr.NavigateModel.pas` | 53 | Navegação entre controllers |
| 🟢 Baixa | `MVCBr.Observer.pas` | 55 | Observer base class |
| 🟢 Baixa | `MVCBr.PersistentModel.pas` | 53 | Persistence model |
| 🟢 Baixa | `MVCBr.ContainedModel.pas` | 69 | Lista thread-safe de models |
| 🟢 Baixa | `MVCBr.ValidateModel.pas` | 53 | Validation model |
| 🟢 Baixa | `MVCBr.ObjectConfigList.pas` | - | Config list |

## Camada de Dados - Sem Teste

| Prioridade | Arquivo | Descrição |
|------------|---------|-----------|
| 🔴 Alta | `MVCBr.FireDACModel.pas` | Model FireDAC (TFireDACModelFactory) |
| 🔴 Alta | `MVCBr.FireDAC.Model.pas` | Outro model FireDAC (ver diferença) |
| 🟡 Média | `MVCBr.FireDACModel.Interf.pas` | Interfaces do FireDAC |
| 🟡 Média | `MVCBr.DatabaseModel.Interf.pas` | Interfaces de banco |
| 🟢 Baixa | `MVCBr.OrmModel.pas` | ORM model |

## Design Patterns - Sem Teste

| Prioridade | Arquivo | Linhas | Descrição |
|------------|---------|--------|-----------|
| ~~🔴 Alta~~ | ~~`MVCBr.Patterns.States.pas`~~ | ~~543~~ | ~~State Machine (complexo)~~ ✅ `TestMVCBr.Patterns.States.pas` — 27 testes (2 fixtures), todos passando (mais 13 no TestMVCBr.Patterns.pas) |
| ~~🔴 Alta~~ | ~~`MVCBr.Patterns.Strategy.pas`~~ | ~~102~~ | ~~Strategy pattern com generics~~ ✅ `TestMVCBr.Patterns.Strategy.pas` — 3 testes, todos passando |
| ~~🟡 Média~~ | ~~`MVCBr.Patterns.Decorator.pas`~~ | ~~107~~ | ~~Decorator pattern~~ ✅ `TestMVCBr.Patterns.Decorator.pas` — 4 testes, todos passando |
| ~~🟡 Média~~ | ~~`MVCBr.Patterns.Adapter.pas`~~ | ~~220~~ | ~~Adapter pattern~~ ✅ `TestMVCBr.Patterns.Adapter.pas` — 3 testes, todos passando |
| ~~🟡 Média~~ | ~~`MVCBr.Patterns.Builder.pas`~~ | ~~751~~ | ~~Builder pattern (base)~~ ✅ `TestMVCBr.Patterns.Builder.pas` — 7 testes (3 fixtures), todos passando |
| 🟢 Baixa | `MVCBr.Patterns.Composite.pas` | 16 | Apenas TThreadList wrapper |

## OData - Sem Teste

| Prioridade | Arquivo | Descrição |
|------------|---------|-----------|
| 🔴 Alta | `oData/MVC.oData.Base.pas` | Engine OData principal |
| 🟡 Média | Dialetos em `oData/Dialect.*.pas` | Dialetos SQL por banco |
| 🟡 Média | `oData/SQL.FireDAC.pas` | Geração SQL FireDAC |
| 🟡 Média | `oData/Client.Builder.pas` | Builder cliente OData |
| 🟢 Baixa | Componentes VCL OData | TODataDatasetAdapter, etc. |

## VCL / FMX - Sem Teste

| Prioridade | Arquivo | Descrição |
|------------|---------|-----------|
| 🟡 Média | `VCL/MVCBr.VCL.PageView.pas` | PageView VCL |
| 🟡 Média | `VCL/MVCBr.HTTPRestClient.pas` | HTTP Client |
| 🟡 Média | `VCL/MVCBr.DataControl.pas` | Data controls |
| 🟢 Baixa | `VCL/MVCBr.HTTPFiredacAdapter.pas` | Bridge HTTP-FireDAC |

## Ordem Sugerida de Implementação

1. **ViewModel** (`MVCBr.ViewModel.pas`) — base para outros testes
2. **Observable** (`MVCBr.Observable.pas`) — padrão critical para comunicação MVC
3. **FormView** (`MVCBr.FormView.pas`) — view principal do framework
4. **FrameView** (`MVCBr.FrameView.pas`) — view secundária
5. **PageView** (`MVCBr.PageView.pas`) — navegação entre views
6. **States** (`MVCBr.Patterns.States.pas`) — máquina de estados
7. **Component** (`MVCBr.Component.pas`) — model via TComponent
8. **InterfaceHelper** (`MVCBr.InterfaceHelper.pas`) — utilitário RTTI
9. **Database / FireDAC Models** — models de dados
10. **Patterns restantes** — Strategy, Decorator, Adapter, Builder
11. **Melhorias nos testes existentes** — preencher TODOs
