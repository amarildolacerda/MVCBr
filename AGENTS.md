# Regras do Projeto

## Controle de versão

- **Alterações só podem ser feitas no branch `dev`**.
- Nunca commitar diretamente no branch `master` ou `main`.
- Commits devem ser em português ou inglês, com mensagens claras e concisas.
- Sempre fazer push para `origin/dev`.

## Código

- Seguir as convenções e padrões existentes no projeto (Delphi Pascal, MVC, OData).
- Não adicionar dependências externas sem necessidade.
- Testar alterações nos exemplos correspondentes antes de commitar.
- Manter especializações em arquivos separados.

## Linguagem e stack

- **Linguagem:** Object Pascal (Delphi)
- **Frameworks:** VCL, FMX, FireDAC, UniGUI
- **ORM:** FireDAC (Firebird, MySQL, MSSQL, Oracle, PostgreSQL)
- **Banco NoSQL:** MongoDB (via MongoWire)
- **Servidor:** ODataBr — modos aplicação, Windows Service, ISAPI DLL, Linux
- **IDE:** Delphi Seattle (10), Berlin (10.1) ou Tokyo (10.2)
- **Extensão de arquivos:** `.pas` (units), `.dfm`/`.fmx` (forms), `.dpr` (project),
  `.dpk` (package), `.dproj` (project config)

## Convenções de nomenclatura

### Prefixos obrigatórios

| Tipo | Prefixo | Exemplo |
|------|---------|---------|
| Classe | `T` | `TControllerFactory` |
| Interface | `I` | `IController` |
| Exceção | `E` | `EControllerNotFound` |
| Campo privado | `F` | `FController` |
| Parâmetro | `A` | `AController` |
| Variável local | `L` | `LController` |
| Tipos enumerados | `T` | `TModelType` |
| Itens de enum | Prefixo curto | `mtCommon`, `mtViewModel` |

### Nomenclatura de units

```
MVCBr.{Camada}.{Subcamada}.pas
```

Exemplos:
- `MVCBr.Interf.pas` — interfaces base
- `MVCBr.Controller.pas` — fábrica de controllers
- `MVCBr.FormView.pas` — view base para forms
- `MVCBr.FireDAC.Model.pas` — model FireDAC

### Nomenclatura de métodos

- Métodos de ação: verbos — `Execute`, `CreateOrder`, `ShowView`
- Getters: prefixo `Get` — `GetController`, `GetModel`
- Setters: prefixo `Set` — `SetController`, `SetView`
- Métodos booleanos: prefixo `Is`, `Has`, `Can` — `IsMainForm`,
  `IsSame`, `IsService`

### Nomenclatura de componentes em forms

| Componente | Prefixo | Exemplo |
|------------|---------|---------|
| TButton | `btn` | `btnSave` |
| TEdit | `edt` | `edtName` |
| TLabel | `lbl` | `lblTitle` |
| TComboBox | `cmb` | `cmbStatus` |
| TDBGrid | `dbg` | `dbgCustomers` |
| TPanel | `pnl` | `pnlTop` |
| TPageControl | `pgc` | `pgcMain` |
| TTabSheet | `tab` | `tabSearch` |
| TDataSource | `ds` | `dsCustomers` |
| TFDQuery | `qry` | `qryCustomers` |
| TFDConnection | `con` | `conMain` |

## Gerenciamento de memória (crítico)

- **Blocos vigiados:** Toda chamada a `.Create` de um `TObject` sem *Owner*
  DEVE ter a linha IMEDIATAMENTE seguinte como `try`:
  ```pascal
  var LList := TStringList.Create;
  try
    // uso
  finally
    LList.Free;
  end;
  ```
- **Objetos com Owner** (componentes VCL/FMX):
  `TMyComponent.Create(Self)` — o Owner assume o release
- **ARC via interfaces:** Objetos `TInterfacedObject` são liberados
  automaticamente ao sair do escopo
- **Weak references:** Usar atributo `[weak]` para referências circulares
  (ex: View → Controller, Model → Controller)

## Arquitetura MVC

### Camadas

```
ApplicationController (Singleton)
  └── Lista de IController
        ├── 0..1 IView (referência fraca)
        └── 0..* IModel
              └── IViewModel (tipo mtViewModel)
```

### Regras de dependência

- Controller conhece View e Models
- View conhece seu Controller (somente 1)
- Model conhece seu Controller (somente 1)
- View acessa Model via Controller (`GetModel`, `GetViewModel`)
- ViewModel faz ponte entre View e Model
- ApplicationController gerencia todos os Controllers

### Injeção de dependência

Usar o container IoC do MVCBr:
```pascal
TMVCBr.RegisterInterfaced<IController>('Nome', IID, AClass, bSingleton);
TMVCBr.ResolveInterfaced<IController>('Nome');
```

### Fluent API (padrão do projeto)

```pascal
result := TMainController.Create as IController;
result.View(AView).Add(AModel);
```

## SOLID no MVCBr

- **S** — Cada classe tem uma responsabilidade. `TControllerFactory` não acessa banco.
- **O** — Extensão via interfaces. `IController` permite novas implementações.
- **L** — `TControllerAbstract` é substituível por qualquer `TControllerFactory`.
- **I** — Interfaces coesas: `IControllerBase`, `IController`, `IModelBase`, `IModel`.
- **D** — Dependa de abstrações. Controller depende de `IView`, não de `TForm`.

## Padrões de projeto implementados

O framework já inclui implementações em `MVCBr.Patterns.*`:
- Builder, Facade, Factory, Singleton
- Mediator, Memento, Observer, Adapter
- Decorator, Composite, Strategy, States
- Prototype, Lazy Loading

Usar as implementações existentes em vez de criar novas.

## OData

### Servidor

- Engine em `oData/MVC.oData.Base.pas`
- Dialetos em `oData/Dialect.*.pas`
- SQL FireDAC em `oData/SQL.FireDAC.pas`
- ServiceModel em `MVCBrServer/oData.ServiceModel.json`

### Cliente

- Builder em `oData/Client.Builder.pas`
- Componentes VCL: `TODataDatasetAdapter`, `TODataFDMemTable`

## Configuração de banco (FireDAC)

### Firebird
```pascal
FConnection.DriverName := 'FB';
FConnection.Params.Values['CharacterSet'] := 'UTF8';
FConnection.Params.Values['SQLDialect'] := '3';
FConnection.Params.Values['PageSize'] := '16384';
FConnection.TxOptions.Isolation := xiReadCommitted;
```

### PostgreSQL
```pascal
FConnection.DriverName := 'PG';
FConnection.Params.Values['CharacterSet'] := 'UTF8';
```

### MySQL
```pascal
FConnection.DriverName := 'MySQL';
FConnection.Params.Values['CharacterSet'] := 'utf8mb4';
```

## Testes (DUnit)

- Framework: **DUnit** (`TestFramework`, `TestExtensions`)
- Runner: `DUnitTestRunner.RunRegisteredTests`
- Classe base: `TTestCase`
- Setup/Teardown: `SetUp` / `TearDown` override
- Asserções: `CheckNotNull`, `CheckTrue`, `CheckSame`, `CheckEquals`
- Registro: `RegisterTest(TSuite)` em `initialization`
- Mock classes: `TFake*` ou `TMock*` prefixo, definidas localmente no arquivo de teste
- Nomenclatura: `Action_Condition_ExpectedResult`

### Anti-patterns em testes

- ❌ Acoplar teste ao banco real — use interfaces com `TFake*` ou `TMock*`
- ❌ Testar UI — teste apenas Domain/Application layer
- ❌ `try..except` genérico em métodos testados — quebra `Assert.WillRaise`

## Anti-patterns a evitar

- ❌ **God class / God unit** — units com milhares de linhas
- ❌ **Lógica de negócio em OnClick** — delegar a Services/Controllers
- ❌ **Uses circular** — resolver com separação em camadas
- ❌ **Variáveis globais** — usar injeção de dependência
- ❌ **Strings hardcoded** — usar `resourcestring` ou constantes
- ❌ **`with` statement** — reduz legibilidade
- ❌ **Magic numbers** — declarar constantes
- ❌ **Métodos > 30 linhas** — extrair em métodos menores
- ❌ **Concatenação de SQL** — usar parâmetros

## Estrutura de diretórios

```
MVCBr/
├── package/         # Pacotes, IDE experts, testes, templates
├── VCL/             # Componentes VCL (OData adapters, HTTP, FireDAC)
├── FMX/             # Componentes FMX (PageView, LayoutView)
├── oData/           # Engine OData: parser, SQL, dialetos, cliente
├── MVCBrServer/     # Servidor OData (Windows, Service, ISAPI, Linux)
├── DMVC/            # DMVC Framework (bundled)
├── Exemplos/        # Exemplos por plataforma
│   ├── vcl/
│   ├── fmx/
│   ├── oData/
│   └── jQuery/
├── UniGui/          # Integração UniGUI
├── delphi_deploy/   # Compilador e dependências (cross-platform)
├── Docs/            # Documentação HTML (pasdoc)
├── Templates/       # Templates de geração de código
└── Tests/           # Testes DUnit
    ├── Controllers/
    ├── Models/
    └── ViewModels/
```

## Organização de units

```pascal
unit MVCBr.Nome;

interface

uses
  { RTL },
  { Projeto };

type
  { Enums e records }
  { Interfaces }
  { Classes }

implementation

uses
  { Units adicionais só da implementação };

{ Implementações agrupadas por classe }

end.
```

## Documentação

- Usar **XMLDoc** para métodos públicos e interfaces
- Comentários em **português** para o projeto brasileiro
- Não comentar código auto-explicativo — deixar o nome do método explicar

## Fluxo de vida de um Controller

```
BeforeInit → Init → AfterInit
  ↓
(uso: ShowView, Update, DoCommand)
  ↓
release (libera Models e referências)
```

## Build e CI/CD

### Compilação por linha de comando

Usar `dcc32.exe` (compilador de linha de comando do Delphi) com o `Makefile` na raiz:

```
make tests       - Compilar suite de testes
make server      - Compilar servidor OData
make packages    - Compilar pacotes .dpk
make all         - Compilar tudo
make clean       - Remover artefatos compilados
```

### CI/CD (GitHub Actions)

O workflow em `.github/workflows/build.yml` automatiza:
- Build dos testes (`Tests/MVCBrTests.dpr`)
- Build do servidor OData (`MVCBrServer/ODataBrServer.dpr`)
- Executado em push para `dev`/`master` e PRs para `master`

### Configuração do compilador

O arquivo `dcc32.cfg` na raiz contém as configurações globais do compilador
(namespaces, paths de saída). Ajustar paths de units conforme ambiente local.

#### delphi_deploy (cross-platform)

O compilador e as units de terceiros estão em `delphi_deploy/cmp/`:
- `dcc32.exe` — compilador de linha de comando do Delphi
- `dcu/` — units compiladas (.dcu) de dependências (DUnit, etc.)
- `bpl/` — runtime packages
- `dcc32.cfg` — config do compilador com os paths de library

Para compilar em Linux (via Wine):
1. O `Makefile` detecta `wine` automaticamente e usa `Z:` paths
2. Flags com ponto-e-vírgula devem ser passadas individualmente entre aspas
   (ex: `'-AWinTypes=Wintypes;Wintprocs;' '-A...'`)
3. `CONSOLE_TESTRUNNER` define no DPR ativa modo console para executar
   testes sem interface gráfica
4. Compilar: `make tests` → executar: `wine Tests/MVCBrTests.exe`

Exemplo de flags no Makefile para Wine:
```makefile
DCC := wine $(DELPHI_DEPLOY)/dcc32.exe
DCC_FLAGS := '-U$(DELPHI_DCU);$(PROJECT_DCU)' '-I$(DELPHI_INC);$(PROJECT_INC)'
```

Referência: https://github.com/amarildolacerda/delphi_deploy

## Novos arquivos

Ao criar novo código:
1. Models, Views, Controllers em arquivos separados
2. Seguir padrão de fábrica (`T*Factory`) com interfaces
3. Registrar no container IoC na `initialization`
4. Criar exemplo correspondente em `Exemplos/`
5. Adicionar testes em `Tests/`
