
# TODO

## Regras (arquivo todo.md)
- Ao montar um planejamento, registrar aqui como controle de fluxo de execução
- Manter estado de cada item (`pendente`, `em_andamento`, `concluido`, `cancelado`)
- Permitir paradas intermediárias e retomada futura
- Ao carregar lembrar e perguntar se quer executar a lista do todo.md
- Manter histórico até que as alterações sejam enviadas para o git
- Após o git push, limpar itens concluídos da lista

# MVCBr Framework — Guia para Agentes

## Branch & versionamento

- Tudo no branch `dev`. Nunca em `master`/`main`.
- Commits pt-BR ou en. Push para `origin/dev`.

## Build (Linux/Wine)

```sh
make tests       # compila suite de testes
wine Tests/MVCBrTests.exe   # executa
make packages    # compila .dpk
make all         # = tests + packages
make clean       # remove .dcu/.exe
```

O Makefile detecta `wine` automaticamente e converte paths para `Z:`.
Flags com `;` passam como `'-A...'` entre aspas (quirk do Wine).
`dcu/` na raiz recebe os .dcu compilados.

O compilador vive em `../delphi_deploy/cmp/dcc32.exe` (via git submodule).
CI (`.github/workflows/build.yml`) roda em `windows-latest` com o mesmo clone.

## Testes (DUnitX)

- Framework: **DUnitX** (`DUnitX.TestFramework`, `DUnitX.Loggers.Console`)
- Atributos: `[TestFixture]`, `[Test]`, `[Setup]`, `[TearDown]`
- Setup/Teardown **obrigatoriamente em `public`** (RTTI).
- Registro: `TDUnitX.RegisterTestFixture(TMyTest)` no `initialization`.
- Asserções: `Assert.*` — `IsTrue`, `IsNotNull`, `AreSame`, `WillRaise`, `AreEqual`
- Mocks: classes `TFake*` ou `TMock*` definidas localmente no arquivo de teste.
- Projeto: `Tests/MVCBrTests.dpr` — adicionar novas units de teste aqui.
- Nomenclatura de testes: `Acao_Condicao_ResultadoEsperado`.
- Nomenclatura de units de teste: `TestMVCBr.{Camada}.{Subcamada}.pas`.
- Anti-patterns: não acoplar a banco real (usar interfaces + fakes); não testar UI; `[Setup]` não pode ficar em `private`.
- Build: `make tests` compila o .exe em `Tests/MVCBrTests.exe`.

**Problemas conhecidos:** `TMVCBrObservable` mistura `TObjectList.Delete` (OwnsObjects) com `TInterfacedObject`, causando "Invalid pointer operation" ao desregistrar observers. Testes de unregister podem falhar.

## Arquitetura MVC

```
ApplicationController (Singleton)
  └── IController list
        ├── 0..1 IView ([weak] ref)
        └── 0..* IModel
              └── IViewModel (mtViewModel)
```

- Controller conhece View e Models. View conhece 1 Controller ([weak]).
- Model conhece 1 Controller ([weak]). ViewModel faz ponte View↔Model.
- IoC: `TMVCBr.RegisterInterfaced<T>('nome', IID, AClass, singleton)`.
- Fluent API: `result.View(AView).Add(AModel)`.
- Controller lifecycle: `BeforeInit → Init → AfterInit`.

### Memória

| Caso | Prática |
|------|---------|
| `TObject.Create` sem Owner | `try..finally Free` na linha seguinte |
| Componentes VCL/FMX | `TComp.Create(Self)` — Owner assume |
| `TInterfacedObject` | ARC automático ao sair do escopo |
| Referências circulares | `[weak]` attribute |

## Convenções de código

- Classe: `T` / Interface: `I` / Exceção: `E` / Campo: `F` / Parâmetro: `A` / Local: `L`
- Units: `MVCBr.{Camada}.{Subcamada}.pas`
- Métodos bool: prefixo `Is`, `Has`, `Can`
- Evitar: God units, `with`, variáveis globais, magic numbers, concat SQL
- Métodos > 30 linhas → extrair

## Skills do projeto

Há skills disponíveis em `.opencode/skills/` (`mvcbr-framework`, `mvcbr-odata`, `mvcbr-tests`) — carregá-las antes de tarefas específicas.

## Padrões implementados

Em `MVCBr.Patterns.*`: Builder, Facade, Factory, Singleton, Mediator, Memento, Observer, Adapter, Decorator, Composite, Strategy, States, Prototype, Lazy Loading.

Usar os existentes em vez de criar novos.

## OData

- Engine: `oData/MVC.oData.Base.pas`
- Dialetos: `oData/Dialect.*.pas`
- SQL FireDAC: `oData/SQL.FireDAC.pas`
- Cliente builder: `oData/Client.Builder.pas`
- Componentes VCL: `TODataDatasetAdapter`, `TODataFDMemTable`
- Servidor: `MVCBrServer/ODataBrServer.dpr`

## Cobertura de testes

| Camada | Status |
|--------|--------|
| Controller | ✅ `TestMVCBr.Controller.pas` (incompleto — ~15 TODOs) |
| Model | ✅ `TestMVCBrModel.pas` (incompleto) |
| View | ✅ `TestMVCBr.View.pas` (básico) |
| ViewModel | ✅ `TestMVCBr.ViewModel.pas` (13 tests, 2025) |
| Observable | ✅ `TestMVCBr.Observable.pas` (14 tests, 2025) |
| Patterns (Lazy, Prototype, Mediator, Singleton, Memento, Factory, Facade) | ✅ existentes |
| ApplicationController | ⚠️ via Controller tests |
| FormView / FrameView / PageView | ❌ |
| Observable (TMVCBrObservable) | ⚠️ limitado — "Invalid pointer operation" |
| Patterns (Decorator, States, Strategy, Adapter, Builder) | ❌ |
| FireDAC / Database models | ❌ |
| OData engine / dialetos | ❌ |
