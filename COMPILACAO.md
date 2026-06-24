# Guia de Compilação - MVCBr Framework

Este documento descreve como compilar o framework MVCBr usando o `delphi_deploy`.

## Visão Geral

O MVCBr pode ser compilado de três formas:
1. **Via Makefile** (recomendado)
2. **Direto com dcc32.exe** (controle manual)
3. **Via IDE Delphi** (se tiver instalado)

O projeto inclui `delphi_deploy`, um compilador standalone que funciona **multiplataforma** (Windows, Linux via Wine, macOS).

---

## Pré-requisitos

### Opção 1: Compilar com Makefile (Linux/macOS)
- `make` instalado
- `wine` instalado (apenas para Linux)
- `delphi_deploy/cmp/dcc32.exe` (incluído no repositório)

### Opção 2: Compilar no Windows
- Delphi Seattle (10), Berlin (10.1) ou Tokyo (10.2) instalado
- OU usar o compilador em `delphi_deploy/cmp/dcc32.exe`

### Opção 3: Compilar via IDE
- Delphi Seattle (10), Berlin (10.1) ou Tokyo (10.2)

---

## Estrutura do delphi_deploy

```
delphi_deploy/
├── cmp/
│   ├── DCC32.EXE              # Compilador de linha de comando
│   ├── dcc32.cfg              # Configuração do compilador
│   ├── dcu/                   # Units compiladas (DUnit, etc.)
│   ├── bpl/                   # Runtime packages (.bpl)
│   ├── inc/                   # Headers/includes
│   └── lib/                   # Bibliotecas
└── msbuild/                   # Configurações MSBuild (opcional)
```

### Arquivo dcc32.cfg

Este arquivo contém as configurações globais do compilador:
- Paths de library (`-U`)
- Paths de includes (`-I`)
- Namespaces (`-NS`)
- Diretório de saída DCU (`-NO`, `-LE`, `-LN`)

---

## Método 1: Compilar via Makefile (Recomendado)

### Linux/macOS

```bash
# Compilar suite de testes
make tests

# Compilar servidor OData
make server

# Compilar pacotes
make packages

# Compilar tudo
make all

# Limpar artefatos compilados
make clean
```

**Resultado esperado:**
```
18275 lines, 1.27 seconds, 3257340 bytes code, 47676 bytes data.
```

### Windows

Se não tiver `make` instalado:
1. Instale [GNU Make para Windows](https://gnuwin32.sourceforge.io/packages/make.htm)
2. Ou use o Makefile direto (já está configurado para detectar SO)

**O Makefile detecta automaticamente:**
- Sistema operacional (Linux, macOS, Windows)
- Presença do Wine (para Linux)
- Caminhos do compilador

---

## Método 2: Compilar Direto com dcc32.exe

### Linux (via Wine)

```bash
wine delphi_deploy/cmp/DCC32.EXE Tests/MVCBrTests.dpr \
  -DVCL \
  -DCONSOLE_TESTRUNNER \
  -U"delphi_deploy/cmp/dcu;MVCBr;MVCBr/helpers" \
  -I"MVCBr;MVCBr/helpers" \
  -NOdcu -LEdcu -LNdcu
```

### Windows

```cmd
delphi_deploy\cmp\DCC32.EXE Tests\MVCBrTests.dpr ^
  -DVCL ^
  -DCONSOLE_TESTRUNNER ^
  -U"delphi_deploy\cmp\dcu;MVCBr;MVCBr\helpers" ^
  -I"MVCBr;MVCBr\helpers" ^
  -NOdcu -LEdcu -LNdcu
```

### Flags Importantes

| Flag | Significado |
|------|------------|
| `-DVCL` | Define VCL como framework |
| `-DCONSOLE_TESTRUNNER` | Modo console (sem interface gráfica) |
| `-B` | Recompilação completa (force rebuild) |
| `-U"path"` | Unit search path (separation: `;` em Windows, `:` em Unix) |
| `-I"path"` | Include path |
| `-NO`, `-LE`, `-LN` | Diretório de saída para DCU |
| `-E"exe"` | Executável de saída |

---

## Método 3: Compilar via IDE Delphi

### Passo 1: Abrir o projeto

Na pasta `package/`, abra o arquivo correspondente à sua versão:
- **Seattle (10):** `MVCBrPackageSeattle.groupproj`
- **Berlin (10.1):** `MVCBrPackageBerlin.groupproj`
- **Tokyo (10.2):** `MVCBrPackageTokyo.groupproj`

### Passo 2: Compilar

Menu → **Project → Compile** (ou `Ctrl+F9`)

### Passo 3: Instalar

Menu → **Component → Install Packages**

Após compilar, o framework estará disponível em:
**New → Other → MVCBr → MVCBr Project**

---

## Compilar Diferentes Componentes

### Apenas Testes

```bash
make tests
```

Compila: `Tests/MVCBrTests.dpr`  
Saída: `Tests/MVCBrTests.exe`

### Apenas Servidor OData

```bash
make server
```

Compila: `MVCBrServer/ODataBrServer.dpr`  
Saída: `MVCBrServer/ODataBrServer.exe`

### Apenas Pacotes (VCL, FMX, etc.)

```bash
make packages
```

Compila todos os `.dpk` em `package/`

### Projeto Personalizado

```bash
delphi_deploy/cmp/DCC32.EXE seu_projeto.dpr \
  -DVCL \
  -U"delphi_deploy/cmp/dcu;MVCBr" \
  -I"MVCBr"
```

---

## Configuração do Library Path

Para que o Delphi encontre as units do MVCBr:

### No Delphi (IDE)

Menu → **Tools → Options → Environment → Delphi Options → Library - Win32**

Adicione à lista:
```
C:\seu_caminho\MVCBr
C:\seu_caminho\MVCBr\helpers
C:\seu_caminho\MVCBr\VCL
C:\seu_caminho\MVCBr\FMX
C:\seu_caminho\MVCBr\UniGui
```

### No arquivo dcc32.cfg

```cfg
-U"Z:\caminho\MVCBr;Z:\caminho\MVCBr\helpers;..."
-I"Z:\caminho\MVCBr;..."
```

---

## Executar Testes Compilados

### Linux/macOS (via Wine)

```bash
wine Tests/MVCBrTests.exe
```

### Windows

```cmd
Tests\MVCBrTests.exe
```

### Saída esperada

```
MESA-INTEL: warning: Ivy Bridge Vulkan support is incomplete
Embarcadero Delphi for Win32 compiler version 32.0
...
18275 lines, 1.27 seconds, 3257340 bytes code, 47676 bytes data.
```

---

## Troubleshooting

### Erro: "Never-build package 'vcl' must be recompiled"

**Causa:** Dependências de packages Delphi não estão compiladas.  
**Solução (temporária):** Compile apenas os testes:

```bash
make tests      # Funciona ✓
make packages   # Requer setup adicional de pacotes Delphi
```

**Solução completa:** Via IDE Delphi
1. Abra `package/MVCBrPackageTokyo.groupproj` (ou sua versão)
2. Menu → **Build → Build All**
3. Isso recompila todas as dependências corretamente

### Erro: "File not found: dcc32.exe"

**Solução:** Verifique se `delphi_deploy/cmp/DCC32.EXE` existe.

```bash
ls -la delphi_deploy/cmp/DCC32.EXE
```

Se não existir, clone o repositório completo:
```bash
git clone https://github.com/amarildolacerda/MVCBr.git
```

### Erro: "wine: command not found" (Linux)

**Solução:** Instale Wine.

```bash
# Ubuntu/Debian
sudo apt-get install wine wine32 wine64

# Fedora
sudo dnf install wine

# macOS
brew install wine
```

### Erro: "Unit not found: MVCBr.Interf"

**Solução:** Verifique os paths no `-U` e `-I` flags.

```bash
# Verificar se arquivo existe
ls MVCBr/MVCBr.Interf.pas
```

Se não existir, reconfigure o library path.

### Aviso: "Unsupported language feature: 'custom attribute'"

**Causa:** Versão antiga do compilador.  
**Solução:** É apenas um aviso; a compilação continua.

### Erro: "Cannot find file 'Vcl.pas'"

**Solução:** Adicione o path das units do Delphi ao `dcc32.cfg`:

```cfg
-NS"Vcl;Vcl.Imaging;System;Data;Xml;Datasnap;Web;Soap;Winapi;"
```

---

## Variáveis de Ambiente

### DELPHI_DEPLOY

Define o caminho do compilador (padrão: `./delphi_deploy`):

```bash
export DELPHI_DEPLOY=/caminho/para/delphi_deploy
make tests
```

### CONSOLE_TESTRUNNER

Define se os testes rodam em modo console:

```bash
# Habilitar modo console (padrão em Linux via Wine)
export CONSOLE_TESTRUNNER=1
make tests

# Desabilitar
unset CONSOLE_TESTRUNNER
```

---

## Makefile - Regras Disponíveis

```makefile
make tests      # Testes (Tests/MVCBrTests.dpr)
make server     # Servidor OData (MVCBrServer/ODataBrServer.dpr)
make packages   # Pacotes (package/*.dpk)
make all        # Todos os acima
make clean      # Remove .dcu, .exe, etc.
make help       # Mostra ajuda
```

---

## Exemplo Prático: Compilação Completa

### Linux

```bash
# 1. Navegar ao projeto
cd /home/usuario/MVCBr

# 2. Limpar compilações anteriores
make clean

# 3. Compilar tudo
make all

# 4. Executar testes
wine Tests/MVCBrTests.exe

# 5. Verificar saída
echo "Compilação concluída!"
```

### Windows (PowerShell)

```powershell
# 1. Navegar ao projeto
cd C:\Users\usuario\MVCBr

# 2. Compilar tudo
make all

# 3. Executar testes
.\Tests\MVCBrTests.exe

# 4. Sucesso!
Write-Host "Compilação concluída!"
```

---

## CI/CD (GitHub Actions)

O repositório inclui um workflow em `.github/workflows/build.yml` que automatiza:

1. Build dos testes (`Tests/MVCBrTests.dpr`)
2. Build do servidor OData (`MVCBrServer/ODataBrServer.dpr`)
3. Execução em push para `dev`/`master` e PRs para `master`

**Verificar status:**
```bash
git log --oneline | head -5
```

Se o último commit tem ✓, a build passou.

---

## Referências

- [delphi_deploy Repository](https://github.com/amarildolacerda/delphi_deploy)
- [Embarcadero Delphi Docs](https://docwiki.embarcadero.com/)
- [MVCBr GitHub](https://github.com/amarildolacerda/MVCBr)

---

**Última atualização:** 2026-06-24  
**Autor:** Amarildo Lacerda

