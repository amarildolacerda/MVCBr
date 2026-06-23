---
name: MVCBr Tests (DUnit)
description: >
  Guia para escrever testes unitários no framework MVCBr usando DUnit.
  Cobre padrões de teste, mocks/fakes, e anti-patterns.
---

# MVCBr Tests — Skill para Testes com DUnit

## Quando usar

Use esta skill ao criar **testes unitários** para Controllers, Models,
ViewModels, Factories e Patterns do MVCBr.

## Stack de testes

- **Framework:** DUnit (`TestFramework`, `TestExtensions`)
- **Runner:** `DUnitTestRunner.RunRegisteredTests`
- **Classe base:** `TTestCase`
- **Projeto:** `Tests/MVCBrTests.dpr`
- **Flag condicional:** `CONSOLE_TESTRUNNER` para modo console

## Estrutura de diretórios

```
Tests/
├── MVCBrTests.dpr           # Projeto de testes
├── dunit.ini                # Config DUnit
├── makefile.mak             # Build via make
├── run.bat                  # Script de execução
├── TestMVCBr.*.pas          # Testes do core
├── TestMVCBrModel.pas
├── TestMVCBr.View.pas
├── TestMVCBrInterf.pas
├── TestMVCBr.Controller.pas
├── TestMVCBr.TestForm.pas
├── TestsMVCBr.Patterns.*.pas  # Testes de padrões
├── testODataServer.pas
├── Controllers/               # Testes de controllers
├── Models/                    # Testes de models
├── ViewModels/                # Testes de viewmodels
├── TestView/                  # Test views
└── TestSecond/                # Test helpers
```

## Template de teste

```pascal
unit TestMVCBr.Something;

interface

uses
  TestFramework,
  MVCBr.Interf;

type
  TestTSomething = class(TTestCase)
  strict private
    FSut: IInterface; // System Under Test
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure DoSomething_WithValidParams_ReturnsExpectedResult;
    procedure DoSomething_WithInvalidParams_RaisesException;
  end;

implementation

{ TestTSomething }

procedure TestTSomething.SetUp;
begin
  FSut := TMyClass.Create as IMyInterface;
end;

procedure TestTSomething.TearDown;
begin
  FSut := nil; // Interface ARC libera automaticamente
end;

procedure TestTSomething.DoSomething_WithValidParams_ReturnsExpectedResult;
begin
  CheckNotNull(FSut);
  CheckTrue(FSut.DoSomething);
end;

procedure TestTSomething.DoSomething_WithInvalidParams_RaisesException;
begin
  // Usar WillRaise com anonymous method
end;

initialization
  RegisterTest(TestTSomething.Suite);
end.
```

## Padrões de asserção

| Método | Uso |
|--------|-----|
| `CheckTrue(ACondition)` | Condição verdadeira |
| `CheckFalse(ACondition)` | Condição falsa |
| `CheckEquals(A, B)` | Igualdade |
| `CheckSame(A, B)` | Mesma instância (ponteiros) |
| `CheckNotNull(AObj)` | Não é nil |
| `CheckNull(AObj)` | É nil |
| `CheckNotEquals(A, B)` | Diferença |
| `WillRaise(AMethod, EExceptionClass)` | Exceção esperada |

## Mocks e Fakes

Classes mock/fake devem ser definidas localmente no arquivo de teste:

```pascal
type
  TFakeModel = class(TInterfacedObject, IModel)
  private
    FID: string;
  public
    function This: TObject;
    function GetID: string;
    function ID(const AID: String): IModel;
    function Update: IModel;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
  end;

{ TFakeModel }

function TFakeModel.This: TObject;
begin
  result := self;
end;
```

## Testando Controllers

```pascal
type
  TFakeView = class(TInterfacedObject, IView)
    // Implementação fake dos métodos da IView
  end;

procedure TestTController.TestAttachModel;
var
  LModel: IModel;
begin
  LModel := TFakeModel.Create;
  FSut.Add(LModel);
  CheckTrue(FSut.Count > 0);
end;
```

## Testando Patterns

```pascal
procedure TestTBuilder.TestBuild;
var
  LProduct: IProduct;
begin
  LProduct := FSut.Build;
  CheckNotNull(LProduct);
  CheckTrue(LProduct.IsValid);
end;
```

## Nomenclatura de testes

Usar o padrão: `Ação_Condição_ResultadoEsperado`

| Exemplo | Descrição |
|---------|-----------|
| `TestCreate_ValidParams_ReturnsInstance` | Criação com params válidos |
| `TestAdd_NullModel_ReturnsMinusOne` | Add com modelo nulo |
| `TestUpdate_EmptyData_DoesNotRaise` | Update com dados vazios |
| `TestResolve_UnknownGuid_ReturnsNil` | Resolução de GUID inválido |

## Anti-patterns em testes

- ❌ **Acoplar teste ao banco real** — usar TFake* ou TMock* com interfaces
- ❌ **Testar UI** — testar apenas Domain e Application layer
- ❌ **`try..except` genérico em métodos testados** — quebra `WillRaise`
- ❌ **Testes que dependem de ordem** — cada teste deve ser independente
- ❌ **Setup complexo** — extrair em métodos auxiliares
- ❌ **Variáveis globais entre testes** — usar campos da classe de teste

## Verificação

- [ ] Teste segue o padrão `SetUp` / `TearDown`
- [ ] Nome do teste segue `Ação_Condição_Resultado`
- [ ] Usa Fakes/Mocks para isolar dependências
- [ ] Não acopla a banco real ou UI
- [ ] Registrado via `RegisterTest` no `initialization`
- [ ] Compila sem warnings
- [ ] Pode executar com `run.bat` da pasta `Tests/`
