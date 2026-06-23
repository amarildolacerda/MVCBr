# Especificação: [Nome da Feature]

## Contexto

<!-- Descreva o problema ou necessidade que esta feature resolve -->

## Requisitos Funcionais

### User Stories

1. **Como** [tipo de usuário], **quero** [ação], **para** [benefício].
2. **Como** [tipo de usuário], **quero** [ação], **para** [benefício].

### Critérios de Aceitação

1. **QUANDO** [evento/condição] **O SISTEMA DEVE** [comportamento esperado].
2. **QUANDO** [evento/condição] **O SISTEMA DEVE** [comportamento esperado].
3. **QUANDO** [evento/condição] **O SISTEMA DEVE** [comportamento esperado].

## Requisitos Não-Funcionais

- **Performance:** [ex: resposta em < 500ms]
- **Compatibilidade:** [ex: Delphi 10+, Windows 10+]
- **Banco:** [ex: Firebird via FireDAC]

## Regras de Negócio

1. [Regra 1]
2. [Regra 2]

## Modelo de Dados

### Interfaces

```pascal
type
  I[NomeDaFeature] = interface
    ['{GUID}']
    // métodos
  end;
```

### Classes

```pascal
type
  T[NomeDaFeature] = class(TInterfacedObject, I[NomeDaFeature])
  private
    // campos
  public
    // métodos
  end;
```

## Arquivos envolvidos

- [ ] `MVCBr.Nome.da.Feature.pas` — nova unit
- [ ] `Exemplos/vcl/ExemploFeature/` — exemplo

## Fora do Escopo

- [O que NÃO será feito nesta spec]
