# Regressão comparativa — Paradox × MySQL

Harness para rodar o **mesmo roteiro** contra os dois executáveis do AMORTRAT e
comparar o que aparece na tela, campo a campo.

```
regressao/
  AmortratUI.psm1     camada de automação (Win32 API)
  Run-Roteiro.ps1     executa um roteiro contra UM .exe
  Compare-Run.ps1     compara duas execuções e gera relatório HTML
  roteiros/*.json     os roteiros
  resultados/         snapshots e relatórios (fora do git)
```

## Como usar

```powershell
cd C:\Amortrat\mysql\code\regressao

# 1) roda contra a versão Paradox
.\Run-Roteiro.ps1 -Roteiro roteiros\00-abertura.json `
                  -Exe "C:\Amortrat\code\amortrat.exe" `
                  -Rotulo paradox -Usuario SEU_USER -Senha SUA_SENHA

# 2) roda contra a versão MySQL
.\Run-Roteiro.ps1 -Roteiro roteiros\00-abertura.json `
                  -Exe "C:\Amortrat\mysql\code\amortrat.exe" `
                  -Rotulo mysql -Usuario SEU_USER -Senha SUA_SENHA

# 3) compara
.\Compare-Run.ps1 -Roteiro 00-abertura
```

O relatório sai em `resultados\00-abertura\relatorio-paradox-x-mysql.html`, com
as telas lado a lado.

## Como o resultado é classificado

| Tipo | O que é | O que fazer |
|---|---|---|
| **VALOR** | mesmo controle, **texto diferente** | investigar — é aqui que mora bug de migração |
| **ESTADO** | mesmo texto, mas `Enabled`/`Visible` diferente | investigar — foi assim que o bug do *"OS já finalizada"* se manifestou |
| **ESTRUTURA** | controle existe só de um lado | normalmente esperado (ver abaixo); conferir uma vez |

A separação existe porque a migração trocou componentes de propósito
(`TRxLookupEdit` → `TComboBox`). Se isso entrasse no mesmo balde das diferenças
de dado, esconderia o que importa.

**Divergências estruturais já conhecidas** (contagem de controles com handle):

| Form | Paradox | MySQL | Motivo |
|---|---:|---:|---|
| `Uclientes` | 32 | 33 | lookup → combo |
| `UPecas` | 26 | 29 | idem |
| `UOS` | 57 | 65 | 7 lookups → combos |
| `ULogin` | 4 | 5 | |
| `UGerrelat` | 15 | 16 | |
| `principal` | — | +5 | semáforo de status (shapes e labels) |

## Normalização aplicada antes de comparar

Para não acusar diferença onde o dado é o mesmo:

- espaços nas pontas e repetidos
- `1.234,50` = `1234,5` = `1234.50`
- `01/02/2026` = `1/2/2026`

**Caixa e acentuação são preservadas** — diferença ali é bug (foi assim que
`PEÇA` → `PEA` apareceria).

## Limitações — leia antes de confiar no resultado

1. **`TLabel`, `TImage`, `TShape` e `TSpeedButton` não são lidos.** São
   `TGraphicControl`: não têm janela e são invisíveis para a API do Windows. Só
   o **PNG** do snapshot mostra o conteúdo deles. Só no `UOS` são 40 labels.
2. **Preview de relatório** (`TRLReport`) é custom-drawn — só imagem.
3. **Grids** (`TAdvSpreadGrid` do UNf) não expõem células por API.
4. As telas **vão diferir visualmente** de propósito: o fundo e a splash foram
   restilizados. Compare a região dos dados, não a imagem inteira.
5. O roteiro depende do layout. Se um form mudar de posição, o seletor por
   classe+índice pode pegar outro controle — por isso todo passo grava
   snapshot: dá para conferir o que foi tocado.

## Pré-requisitos dos dados

Os dois sistemas precisam partir de bases **equivalentes**. O Paradox aponta
para `C:\Amortrat\BD\Copy` e o MySQL para `amortrat_dev`. Se um tiver cliente
que o outro não tem, a diferença aparece como falso positivo.

## Escrevendo um roteiro

```json
{
  "nome": "cadastro-cliente",
  "passos": [
    { "acao": "aguardar-janela", "classe": "TFClientes", "timeout": 40 },
    { "acao": "escrever", "classe": "TEdit", "indice": 2, "valor": "TESTE LTDA" },
    { "acao": "clicar",   "classe": "TIAeverButton", "texto": "*Gravar*" },
    { "acao": "snapshot", "nome": "03-gravado" }
  ]
}
```

| Ação | Parâmetros |
|---|---|
| `aguardar-janela` | `classe` ou `titulo`, `timeout` |
| `snapshot` | `nome` |
| `escrever` | seletor + `valor` (`$USUARIO` e `$SENHA` são substituídos) |
| `clicar` | seletor |
| `combo` | seletor + `valor` (texto do item) |
| `aguardar-ocioso` | `timeout` |
| `esperar` | `ms` (use o mínimo possível) |

## Descobrindo as classes e seletores de uma tela

Rode o `00-abertura`, abra o JSON do snapshot e veja as chaves reais:

```powershell
(Get-Content resultados\00-abertura\mysql\03-menu-principal.json -Raw |
  ConvertFrom-Json).Controles |
  Select-Object Key, Class, Text, Enabled | Format-Table -AutoSize
```

## Seletores — qual usar

| Forma | Exemplo | Quando |
|---|---|---|
| `chave` | `"TEdit@17,88"` | classe **e** posição batem nos dois |
| `pos` | `"18,51"` | **a classe mudou** entre as versões |
| `classe`+`indice` | `"TEdit"`, `2` | n-ésima ocorrência |
| `texto` | `"*Entrar*"` | por legenda (aceita curinga) |

O `pos` existe por um caso real encontrado logo no primeiro roteiro: o campo de
usuário do login é `TRxLookupEdit` no Paradox e `TComboBox` no MySQL — **mesma
posição, classe diferente**. Um seletor por classe exigiria roteiros distintos
para cada versão, o que anularia a proposta de rodar o mesmo roteiro nos dois.

Tolerância de ±2 px absorve diferença de borda entre componentes.

## Tela de login — seletores confirmados

Do snapshot real (`TFLogin`, "Login de Usuário"):

| Campo | Paradox | MySQL | Seletor |
|---|---|---|---|
| Usuário | `TRxLookupEdit@18,51` | `TComboBox@18,51` | `"pos": "18,51"` |
| Senha | `TEdit@17,88` | idem | `"pos": "17,88"` |
| Entrar | `TIAeverButton@30,143` | idem | `"texto": "*Entrar*"` |
| Sair | `TIAeverButton@110,143` | idem | |
