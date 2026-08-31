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

Use os wrappers `.cmd` — eles **não dependem da Execution Policy**:

```
cd C:\Amortrat\mysql\code\regressao

rodar.cmd paradox ADMIN 4044
rodar.cmd mysql   ADMIN 4044
comparar.cmd
```

Com outro roteiro:

```
rodar.cmd paradox ADMIN 4044 roteiros\02-cliente.json
rodar.cmd mysql   ADMIN 4044 roteiros\02-cliente.json
comparar.cmd 02-cliente
```

O relatório sai em `resultados\00-abertura\relatorio-paradox-x-mysql.html`, com
as telas lado a lado — o `comparar.cmd` já o abre no navegador.

### Se preferir chamar os `.ps1` direto

O PowerShell vem com policy `Restricted` no Windows e recusa rodar `.ps1`.
Libere por sessão:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

ou de forma permanente para o seu usuário (não exige admin):

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

`RemoteSigned` permite scripts locais e exige assinatura só nos baixados da
internet — é o que a Microsoft recomenda para máquina de desenvolvimento.

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

## Nota técnica: por que `WM_GETTEXT` e não `GetWindowText`

A primeira versão lia os controles com `GetWindowText` e os campos vinham
**vazios** — enquanto o título da janela e a legenda dos botões vinham certos.

A documentação da Microsoft explica: para janela de **outro processo**,
`GetWindowText` devolve apenas o texto guardado no lado do sistema. Isso existe
para o título de um form e para a legenda de um `BUTTON`, mas **não** para um
`EDIT`, cujo conteúdo vive no processo dono.

`WM_GETTEXT` resolve porque é mensagem de sistema: o Windows faz o marshalling
do buffer entre os processos. Usado com timeout, para não travar o harness se o
sistema estiver ocupado numa query.

Se um dia os campos voltarem a aparecer vazios, é aqui que se olha.

## Ferramentas de apoio

### `mapear-dfm.js` — seletores sem precisar rodar o sistema

Lê um `.dfm` e devolve a posição de cada controle **na tela**, no mesmo formato
de chave que o harness usa:

```
node mapear-dfm.js "C:/Amortrat/mysql/code/UOS.dfm" --so-visiveis
```

A fórmula é `Σ(Left/Top dos ancestrais) + (8, 31)` — os 8 e 31 são a borda
lateral e a barra de título de um form em 96 DPI. Calibrada e conferida contra
um snapshot real do `ULogin`: as 5 posições bateram exatamente.

Colunas: `NOME` (o do Delphi), `CLASSE`, `CHAVE/pos`, `H` (tem handle?) e o
container onde está.

### `validar-roteiro.js` — confere o roteiro antes de executar

```
node validar-roteiro.js roteiros\10-ciclo-completo.json
```

Cruza cada `"pos"` do roteiro com o mapa do DFM da tela corrente. Acusa
seletor apontando para lugar vazio e avisa quando o alvo é `TGraphicControl`
(sem handle — o harness não alcança). Sai com código 1 se houver erro, então
serve em script de CI.

## Roteiro `10-ciclo-completo`

Cobre o ciclo inteiro — **processo → cliente → peça → OS → consulta →
finalização** — em 24 snapshots.

```
rodar.cmd paradox ADMIN 4044 roteiros\10-ciclo-completo.json
rodar.cmd mysql   ADMIN 4044 roteiros\10-ciclo-completo.json
comparar.cmd 10-ciclo-completo
```

### Referência × cadastro novo

| | Como o roteiro trata |
|---|---|
| **Referência** (processo `002`, cliente `0001`) | já existem na base. São **consultados** e seus valores ficam em variáveis (`guardar`) |
| **Cadastro novo** | o código vem do **sistema** (`ObterProximoCodigo` / `ProximoCodigoPeca`). O roteiro **captura** o que apareceu na tela e usa depois |

Nenhum código novo é fixado no JSON. Isso importa: os dois bancos estão em
pontos diferentes da sequência, então o Paradox pode gerar `018` e o MySQL
`042` para o mesmo cadastro.

Detalhe do fluxo: o código novo é gerado no **`FormShow`**. Depois de consultar
a referência o form fica posicionado nela, então o roteiro **sai e reabre** para
voltar ao modo "novo". Na peça é diferente — o código vem do `EClienteChange`,
ou seja, aparece assim que o cliente é digitado.

### Ao comparar, ignore os códigos gerados

Eles **vão** divergir e isso não é defeito:

```powershell
.\Compare-Run.ps1 -Roteiro 10-ciclo-completo -IgnorarChaves `
  "TEdit@31,75","TEdit@31,68","TEdit@391,70","TMaskEdit@24,61"
```

Essas quatro chaves são os campos de código de processo, cliente, peça e OS.
Elas passam a aparecer como **ESPERADO** (verde) em vez de VALOR (vermelho).

### Ações novas usadas por este roteiro

| Ação | Para quê |
|---|---|
| `guardar` | lê um campo e salva em `$VAR` — replica a referência e captura o código gerado |
| `conferir` | falha o roteiro se o campo não contiver o esperado, em vez de seguir preenchendo tela errada |
| `teclas` | aciona o menu, que não tem handle (`Alt+C`, `P`/`C`/`E`; `Alt+O`) |

### Os snapshots que mais importam

- **`19-os-consultada-antes-de-finalizar`** — com `FINALIZADA=0`, o
  `BTFinalizar` tem de estar **habilitado** e o `BTDesfinalizar` **desabilitado**.
  É exatamente onde o bug que você encontrou se manifestava. Divergência ali sai
  como **ESTADO**.
- **`23-os-consultada-apos-finalizar`** — o inverso.
- **`14-peca-reconsultada`** — confirma que a peça ficou vinculada ao cliente e
  ao processo criados.
