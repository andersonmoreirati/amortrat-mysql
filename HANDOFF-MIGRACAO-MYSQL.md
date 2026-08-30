# HANDOFF — Migração AMORTRAT: BDE/Paradox → ZeosLib/MySQL

> Documento de continuidade. Escrito para que outra máquina/sessão retome o
> trabalho sem repetir análise nem repetir erros.
> Última atualização: **2026-08-30**

---

## 1. Contexto

Sistema **AMORTRAT** (Delphi 2010, Win32) — controle de Ordens de Serviço de
tratamento térmico de metais. Está sendo migrado de **BDE/Paradox** para
**ZeosLib/MySQL**, um formulário por vez.

**Regra de ouro:** cada form migrado fica **100% MySQL**. Não existe
"metade BDE, metade MySQL" dentro de um mesmo form — isso quebraria quando o
Paradox for desativado.

### Regras invioláveis

| Regra | Motivo |
|---|---|
| `D:\AMORTRAT\code - Copy - Copy\code` **nunca** é modificado | é o código de produção Paradox |
| `D:\AMORTRAT\BD\Copy` é **somente leitura** | apesar do nome, é o diretório de dados Paradox de PRODUÇÃO (é o alias BDE) |
| Ao trocar um componente, preservar **todas** as propriedades | Left, Top, Width, Height, TabOrder, MaxLength, CharCase e **todos** os eventos |
| ~~`UModulo` continua BDE~~ | **cumprida em 2026-08-30**: perdeu o BDE após `principal` e `UNf` |

---

## 2. Ambiente

```
Projeto ............ C:\Amortrat\mysql\code   ← era D:\ na máquina anterior
Projeto compilado .. amortrat_mysql.dproj  (o .dpr é amortrat.dpr)
Delphi ............. RAD Studio 7.0 (Delphi 2010) — C:\Program Files (x86)\Embarcadero\RAD Studio\7.0
ZeosLib ............ 8.0.0-stable — C:\Programacao\Delphi\zeosdbo-8.0.0-stable
                     design-time package instalado: ZComponentDesign140.bpl
FortesReport ....... CE 4.0 (VCL) — packages RLibWinD6vcl / RLibWinD7vcl
Paradox (produção).. D:\AMORTRAT\BD\Copy   (alias BDE 'amortrat')
Git / GitHub ....... github.com/andersonmoreirati/amortrat-mysql (SSH)
                     chave: C:\Users\User\.ssh\id_ed25519
                     git em: C:\Program Files\Git  (adicionar ao PATH a cada shell nova)
```

**Banco MySQL** — credenciais em `amortrat.ini`, que fica no diretório do
projeto e **está no `.gitignore`** (modelo em `amortrat.ini.example`):

```ini
[BD]
Host=amortrat.com.br
Porta=3306
Banco=amortrat_dev
Usuario=amortrat_dev
Senha=<ver amortrat.ini local>
```

Servidor: **MySQL 8.0.37**.

Consulta pela linha de comando (usada o tempo todo para validar SQL):

```bash
mysql -h amortrat.com.br -u amortrat_dev -p'<senha>' --skip-ssl amortrat_dev -e "SELECT ..."
```

⚠️ **`--skip-ssl` é obrigatório**: o servidor usa certificado auto-assinado e o
cliente recusa a conexão sem isso (`ERROR 2026: Certificate verification
failure`). A aplicação já faz o mesmo — ver `UModulo.DataModuleCreate`:
`usessl=false` e `MYSQL_OPT_SSL_VERIFY_SERVER_CERT=FALSE`.

Nesta máquina não há cliente MySQL instalado (o instalador oficial exige
elevação). Usei o cliente **MariaDB portátil** (zip, sem instalação):
`https://archive.mariadb.org/mariadb-11.4.4/winx64-packages/mariadb-11.4.4-winx64.zip`
→ `bin/mariadb.exe`, compatível com o protocolo do MySQL 8.

### Compilação

**Só pelo IDE (F9).** O build por linha de comando **não funciona** neste
projeto: as bibliotecas exigiam flags conflitantes — `$T+` quebrava o
`FixBDE4GbBug`, `$T-` quebra o Indy. O IDE resolve com DCUs pré-compilados.

Exceção: dá para compilar um `.dpr` **console isolado** para testar unidades sem
dependências visuais (foi como validei o bcrypt e o comportamento do TMaskEdit):

```bash
dcc32.exe teste.dpr -U"$(BDS)\lib;D:\AMORTRAT\mysql\code" -I"$(BDS)\lib" -\$Q+ -\$R+
```

⚠️ **Passe as flags do projeto** (`-$Q+ -$R+`) — ver armadilha #12.

---

## 3. Estado atual — ✅ MIGRAÇÃO DE CÓDIGO COMPLETA (2026-08-30)

**Todas as 19 units do `amortrat.dpr` estão 100% MySQL. O BDE saiu do projeto.**

| Unit | Linhas | Status | Observação |
|---|---:|---|---|
| `ULogin` | 290 | ✅ | bcrypt + upgrade transparente de senha |
| `UProcessos` | 673 | ✅ | |
| `Uclientes` | 1.358 | ✅ | fix máscara CNPJ/telefone, `tb_email` |
| `UPecas` | 1.385 | ✅ | fix `tb_equipamentos*` |
| `ULocalizar` | 388 | ✅ | SQL parametrizado |
| `UOS` | 2.563 | ✅ | transações, 7 combos |
| `URelatOS` | 260 | ✅ | report repontado (27 bindings) |
| `URelatCQ` | 795 | ✅ | fecha o fluxo da OS |
| `UReajuste` | 358 | ✅ | UPDATE em lote parametrizado |
| `UUsuarios` | 227 | ✅ | bcrypt na gravação |
| `UGerrelat` | 890 | ✅ | 10 queries + 82 bindings de report |
| `URelatorios` | 398 | ✅ | report do UGerrelat |
| `UBCrypt` | 560 | ✅ | **nova** — validada por 17 vetores oficiais |
| `USplash`, `ufrmStatus` | 28 | — | sem banco |
| **`principal`** | **772** | ✅ **2026-08-30** | 11 TZQuery; ver §3.1 |
| **`UNf`** | **3.516** | ✅ **2026-08-30** | o maior; 14 TZQuery; ver §3.2 |
| **`UModulo`** | **198** | ✅ **2026-08-30** | era 531; perdeu todo o BDE; ver §3.3 |

> `UUsuarios` aparece como "híbrido" em varreduras automáticas por causa dos 5
> `TDBCheckBox` — mas eles são **genéricos** sobre `TDataSource` (não BDE).

### 3.1 `principal` — o que mudou

- `QResumo`/`QOs`/`QRank` (TRxQuery) → `TZQuery`; **+8 TZQuery locais**
  (`QConfig`, `QVendasGerais`, `QOrdensNaoFinalizadas`, `QPesoTotal`,
  `QOrdensDoAno`, `QOrdensFinalizadasDoAno`, `QExpClientes`, `QExpPecas`)
  substituindo os datasets BDE do UModulo usados nas exportações Excel/PowerBI.
- **TFields persistentes removidos.** `QOsCODIGO` tinha `Size = 8` e
  `tb_os.CODIGO` é `varchar(9)`: o número da OS sairia truncado
  (`098800/26` → `098800/2`) na mensagem enviada por WhatsApp (armadilha #15).
- `QOsCODIGO_1`/`QOsCODIGO_2` eliminados reescrevendo o SELECT sem as colunas
  duplicadas de JOIN (armadilha #7).
- `order by 12` / `order by 3` (posicionais) → `order by LEADTIME` / `VALOR_G`.
- `(:pNow - A.DATA)` → `DATEDIFF(:pNow, A.DATA)`.
- `TBConfig.FindKey` → `LerConfig(n)` sobre `tb_config`.
- `FormActivate` remonta o Caption a partir de `FCaptionBase` — antes acumulava
  ` <<< AMBIENTE DE HOMOLOGAÇAO >>>` a cada ativação.

### 3.2 `UNf` — o que mudou

- 8 TRxQuery → TZQuery; **+6 TZQuery locais**: `QNf` (leitura), `QNfCmd`,
  `QNfItensCmd`, `QNfRefCmd` (comandos), `QCli`, `QCfg`.
- `EFantasia` (TRxLookupEdit sobre `Modulo.DSClientes`) → `TComboBox` +
  `TStringList` (§4.3). `OnCloseUp` + `OnKeyUp` viraram um `OnChange`.
- **53 TFields persistentes removidos** — vários truncariam dado real:

  | TField | Size | Coluna MySQL | Efeito |
  |---|---:|---|---|
  | `QOsCODIGO`, `QOS_FinCODIGO` | 7 | `varchar(9)` | corta a chave da OS |
  | `QNF_ItensCOD_OS` | 8 | `varchar(9)` | confirmado no banco: `098721/26` |
  | `QNF_ItensCODIGO` | 10 | `varchar(20)` | corta o código do item |
  | `QNF_ItensDESCRICAO` | 200 | `varchar(300)` | corta descrição fiscal |
  | `QOsFINALIZADA` | TBooleanField | `tinyint(1)` | `EDatabaseError` (#6) |

- **Pré-reserva de código** (§4.4) com tratamento de colisão 1062, guarda no
  DELETE (`COD_CLI IS NULL AND NATUREZA IS NULL AND VALOR IS NULL`).
- **INSERTs explícitos nos laços.** O original chamava `Append` sem `Post` (o
  `Post` estava até comentado) e funcionava por efeito colateral: o `TDataSet`
  do BDE faz post implícito do registro pendente quando o `Append` seguinte é
  chamado. Com SQL isso não existe.
- NF + itens + referências gravam em **uma transação**; o envio da NF-e fica
  **fora** dela (é chamada a webservice, não pode segurar transação aberta).

### 3.3 `UModulo` — perdeu o BDE

- 531 → **198 linhas**; DFM 1920 → **149** (resta só o `TImageList`).
- Removidos 18 `TTable`, 16 `TDataSource`, 5 `TRxQuery`, ~190 `TField`, os
  `AddPassword('99866')` e os `Active := True` que abriam todos os cursores na
  abertura do sistema.
- Removidos os 5 handlers `AfterPost` (`FlushBuffers` + `DBISaveChanges`):
  forçavam o BDE a gravar o buffer no `.DB`. **Não** eram o sync
  Paradox→MySQL, que é processo externo (colunas `sync_hash`/`sync_at`/
  `sync_origin`).
- `uses`: saem `DBTables`, `BDE`, `RxQuery`, `DBClient`, `FixBDE4GbBug`.
- `FixBDE4GbBug` removido do `.dpr` **e** do `.dproj` (era patch do bug de 4Gb
  do BDE — sem BDE, não tem função).

**Superfície do `Modulo` usada pelos forms** (nenhuma BDE):
`ZConexao` (198×), `RetZero` (68×), `NovaLeitura` (24×), `Number` (5×),
`UsuarioLogado` (2×).

> `UApontamento`/`UApontamento2` ainda referenciam `Modulo.TB*`, mas estão
> **fora do `.dpr`** (forms órfãos, §7.4) — não compilam com o projeto. Se um
> dia forem reativados, precisarão ser migrados antes.

### Próximo passo: teste geral

O código está migrado, mas **só o login foi validado em uso real**. Ver §7.2.

---

## 4. Padrões estabelecidos — reutilize estes

### 4.1 `GarantirConexao` (todo form migrado tem)

Os `TZQuery` vivem no DFM, mas `Modulo.ZConexao` é criado em **runtime**
(`DataModuleCreate`) e não existe em design time — não dá para ligar pelo Object
Inspector.

```pascal
function TFxxx.GarantirConexao: Boolean;
begin
  Result := False;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  if not Modulo.ZConexao.Connected then
    try Modulo.ZConexao.Connect;
    except on E: Exception do
      begin
        Application.MessageBox(pchar('Erro de conexao: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;
  QAlgumaCoisa.Connection := Modulo.ZConexao;   // ligar todos os datasets
  Result := True;
end;
```

### 4.2 Inicialização no `OnShow`, **nunca** no `OnActivate`

Todos os forms abrem por `ShowModal`. Então:

- `OnShow` dispara **a cada entrada** → o form nunca reabre sujo
- `OnShow` **não** dispara ao voltar de um modal filho (FPecas, FLocalizar, preview
  do relatório) → não apaga o que o usuário acabou de digitar

O `OnActivate` dispara nos dois casos, e por isso foi abandonado. Ver armadilha #5.

### 4.3 `TRxLookupEdit` → `TComboBox` + `TStringList`

`TRxLookupEdit` faz casts internos para estruturas BDE e dá **Access Violation**
com dataset ZeosLib. Substituição:

```pascal
// DFM
object EFantasia: TComboBox
  Left = ...   Top = ...   Width = ...   Height = ...
  Style = csDropDown
  AutoDropDown = True
  ItemHeight = 13
  TabOrder = ...            { preservar o original }
  OnChange = EFantasiaChange
  OnEnter = EFantasiaEnter
  OnExit = EFantasiaExit
end
```

- `OnCloseUp` + `OnKeyUp` (que liam o cursor BDE) viram **um** `OnChange`
- Uma `TStringList` paralela mapeia `ItemIndex` → `CODIGO`
- **Uma lista por FONTE de dados**, não por controle: no UOS, `EFantasiaF` e
  `RxLookupEdit1` eram duas visões do MESMO cursor `Modulo.DSFornec`
- ⚠️ **Não** copiar `OEMConvert` — ver armadilha #4

### 4.4 Pré-reserva de código (requisito de negócio!)

O `Append`+`Post` no botão OK **não era sujeira** — era controle de concorrência,
para dois operadores não emitirem OS com o mesmo número.

```
BTOK (registro novo) -> ReservarCodigo: INSERT só com a PK
   colisão (MySQL 1062 Duplicate entry) -> pega o próximo número, tenta de novo
                                           e AVISA o usuário que o número mudou
BTGravar             -> SEMPRE UPDATE (o registro já existe nos dois caminhos)
FormClose/abandono   -> LiberarCodigoReservado: DELETE do stub
```

O `DELETE` tem guarda para nunca apagar registro preenchido:

```sql
DELETE FROM tb_os WHERE CODIGO = :p
  AND FINALIZADA = 0 AND CLIENTE IS NULL AND PECA IS NULL
```

Guarda por tabela: `tb_clientes`→`RAZAO IS NULL`; `tb_proc`→`PROCESSO IS NULL`;
`tb_pecas`→`DESCRICAO IS NULL`.

Em todas as tabelas do projeto **só a PK é NOT NULL**, então o stub passa.

### 4.5 Transações (ZeosLib)

```pascal
Modulo.ZConexao.AutoCommit := False;   // abre a transação implícita
try
  ...ExecSQL...
  Modulo.ZConexao.Commit;
except
  try Modulo.ZConexao.Rollback; except end;
end;
// SEMPRE no finally:
Modulo.ZConexao.AutoCommit := True;
```

⚠️ **Não** usar `StartTransaction` junto com `AutoCommit := False` — cria
savepoint aninhado e o comportamento varia entre versões.

Aplicado em `BTFecharClick` e `BTDesfinalizarClick` do UOS (as duas unidades de
trabalho multi-tabela).

### 4.6 `Modulo.NovaLeitura` — snapshot atualizado

**Chamar antes de qualquer consulta/relatório.** Ver armadilha #1 (é o bug mais
sutil que apareceu). Já está aplicado em 9 forms.

### 4.7 Repontar report FortesReport: preservar os NOMES dos DataSource

O binding do FortesReport é `DataSource` + `DataField` (string) resolvido **por
nome de componente** no streaming do DFM. Consequência prática:

> Se o `TDataSource` mantiver o mesmo nome e só o DataSet por baixo mudar
> (`TQuery`→`TZQuery`), o DFM do report **não precisa ser editado**.

- **UOS/URelatOS**: dos 27 bindings, 19 apontavam para `FOs.DataSource1/2` (zero
  edição); só os 8 que iam para `Modulo.DS*` foram repontados para datasets
  locais do form — porque o UModulo tem de continuar BDE.
- **UGerrelat/URelatorios**: os 82 bindings apontam para `FGerRelat.DS*`, que
  ficam no próprio form → **nenhuma** edição no report.

⚠️ Mas confira o **código** do report também — ver armadilha #8.

### 4.8 Componentes data-aware que **não** são BDE

Antes de trocar um componente, verifique se ele realmente depende do BDE:

```bash
grep -nE "\bDBTables\b|TBDEDataSet|as TTable|as TQuery" <lib>.pas
```

- `TRxDBGrid` (`RxDBCtrl.pas`): única menção a `DBTables` está sob `{$IFNDEF RX_D3}` — em D2010 nem compila. **Mantido.**
- `TRLDBText` (FortesReport): `FDataSource: TDataSource` genérico. **Mantido.**
- `TDBCheckBox`: genérico. **Mantido** (só ajustar `ValueChecked`, ver armadilha #6).

Isso poupou muito trabalho no ULocalizar, UUsuarios e nos dois reports.

---

## 4.9 Git — fluxo de commit adotado (2026-08-25)

Repositório GitHub: `git@github.com:andersonmoreirati/amortrat-mysql.git`

Commitar a cada alteração relevante:

```powershell
$env:PATH += ";C:\Program Files\Git\bin"   # necessário a cada shell nova
cd C:\Amortrat\mysql\code
git add .
git commit -m "tipo: descrição curta"
git push
```

**Regras do `.gitignore`:** nunca commitar `.dcu`, `.exe`, `.dll`, `.map`,
`amortrat.ini` (senha do banco), `commit.bat`/`rec.bat` (tinham token hardcoded).
O token PAT antigo (`ghp_a4Pj...`) foi **revogado** em 2026-08-25.

---

## 5. ⚠️ ARMADILHAS — erros já cometidos, não repetir

### #1 — Snapshot REPEATABLE READ (o bug mais sutil)

**Sintoma:** emitir relatório → cadastrar cliente → reemitir → o novo cliente
**não aparece**. Só depois de reiniciar o sistema.

**Não é cache de query** (o query cache nem existe no MySQL 8.0.37). É o
isolamento **REPEATABLE READ** do InnoDB: o snapshot nasce na primeira leitura da
transação e não muda até haver commit. Comprovado no servidor:

```
transação abre e lê ......... 404
(outra conexão insere 1)
relê na MESMA transação ..... 404   <-- preso
COMMIT e lê ................. 405   <-- só aqui aparece
```

Aparece primeiro em forms que deixam **datasets abertos** (gerenciador de
relatórios), porque a transação de leitura fica viva.

**Correção:** `TModulo.NovaLeitura` (encerra a transação) chamado antes de
consultar. No UGerrelat há ainda `PrepararNovaConsulta`, que também fecha todos
os `TZQuery` e faz `Unprepare` (as queries usam `Prepare`).

**Nunca** chamar `NovaLeitura` dentro de um bloco transacional — desfaria a
unidade de trabalho.

### #2 — Nomes de tabela: quase tudo tem prefixo `tb_`, mas confira

Errei **duas vezes** assumindo o nome:

| Escrevi | Correto |
|---|---|
| `email` | `tb_email` |
| `equipamentos`, `equipamentos_peca` | `tb_equipamentos`, `tb_equipamentos_peca` |

Pior: os `except end` silenciosos **engolem** o erro e a grid só volta vazia.
**Sempre** confirme com `SHOW TABLES` antes de escrever a query.

### #3 — `E2169 Field definition not allowed after methods`

Em Delphi, dentro de uma seção (`private`), **campos vêm ANTES dos métodos**.

```pascal
private
  FEmEdicao: Boolean;        // campos primeiro
  FClientesCod: TStringList;
  procedure Desabilitar;     // métodos depois
```

### #4 — `OEMConvert` não existe em `TComboBox`

É propriedade de `TCustomEdit` — o `TRxLookupEdit` a tinha porque **era** um
`TCustomEdit`. Ao converter, **não copie**. Erro: *"Property OEMConvert does not
exist"* ao abrir o form.

Propriedades válidas em `TComboBox` (confirmadas em `StdCtrls.pas`):
`Style`, `AutoDropDown`, `ItemHeight`, `Color`, `TabOrder`, `Text`
(+ `Left/Top/Width/Height` de `TControl`).

### #5 — `TComboBox` **não** é `TCustomEdit`

Laços como este deixam de alcançar os combos, **sem erro de compilação**:

```pascal
if (Components[i] is TCustomEdit) then (Components[i] as TCustomEdit).Clear;
```

`Limpar`/`Desabilitar`/`Habilitar` param de funcionar para eles — falha
silenciosa. Trate explicitamente:

```pascal
if Components[i] is TComboBox then
begin
  (Components[i] as TComboBox).Enabled := ...;
  (Components[i] as TComboBox).Color   := ...;   // Color é published em TComboBox
end;
```

(`TCustomEdit(C).Brush.Color` funciona nos laços; `TCustomEdit(C).Color` **não** —
`Color` é protected em `TControl`; use `TEdit(C).Color` / `TMemo(C).Color`.)

### #6 — `tinyint(1)`: `.AsInteger`, nunca `.AsBoolean`

Boolean do Paradox virou `tinyint(1)`, que o ZeosLib mapeia como
`TShortIntField` — `.AsBoolean` lança `EDatabaseError`.

```pascal
if Q.FieldByName('INATIVO').AsInteger <> 0 then ...   // certo
```

Vale para: `tb_os.FINALIZADA`, `tb_os_finalizados.RETRABALHO`/`.DEVOLUCAO`,
`tb_pecas.ITEM_SEG`/`.ANALISE_DET`, `tb_clientes.INATIVO`, `tb_usuario.*`.

**Em `TDBCheckBox`** isso também muda o DFM: o campo devolve `'1'`/`'0'` em texto,
então `ValueChecked = '1'` e `ValueUnchecked = '0'` (era `'True'`/`'False'`).

**No SQL:** `INATIVO = false` → `INATIVO = 0`.

### #7 — Colunas duplicadas em JOIN: o BDE renomeava, o MySQL não

Queries como `select A.*, B.CODIGO, C.CODIGO from ...` faziam o BDE criar
`CODIGO`, `CODIGO_1`, `CODIGO_2`. O MySQL **não** faz isso.

**Antes de remover TFields persistentes**, verifique quais campos o report
realmente usa. No UGerrelat nenhum dos `_1`/`_2` era usado, então reescrevi os
SELECTs **sem** as colunas duplicadas — resolve na raiz.

⚠️ Se houver `order by <número>` (posicional), ele quebra ao mudar o SELECT.
Troque por `order by <alias>`.

**`principal` tem `QOsCODIGO_1` e `QOsCODIGO_2` — o mesmo caso está esperando lá.**

### #8 — Report: conferir o **código**, não só o DFM

Verifiquei que o DFM do `URelatorios` usa `DataField` (string, imune) e concluí
que era seguro remover os TFields do UGerrelat. **Errado**: o `.pas` do report
acessava `FGerRelat.QVendasFVALOR`, `FGerRelat.QOsURGENCIA`, `FGerRelat.QOsLEADTIME`
como **objetos**.

Corrigido com `FieldByName` + guarda (o `BeforePrint` pode disparar com a query
fechada):

```pascal
if FGerRelat.QOs.Active and (not FGerRelat.QOs.IsEmpty) and
   (FGerRelat.QOs.FieldByName('LEADTIME').AsFloat >= 10) then
```

Busca para encontrar esses casos:

```bash
grep -rnoE "\b(FGerRelat|FOs|FRelatCQ)\.Q[A-Za-z_]+[A-Z_]{2,}\b" *.pas
```

### #9 — Identificadores em Delphi são **case-insensitive**; seus greps não

Dois erros por isso:
- `TrxLookupEdit` (r minúsculo) escapou do replace de `TRxLookupEdit`
- variável `R` colidiu com o contador `r` de um `for` → `E2081`

**Sempre** varra com `grep -i` / `re.I` ao procurar resíduos.

### #10 — Editar DFM com regex quebra a estrutura

DFM é **aninhado** (`object` → `object` → `end` → `end`). Regex non-greedy não
conta profundidade e **come um `end`**, gerando:

```
E2161 RLINK32: Unsupported 16bit resource in file "X.dfm"
```

Use **parser linha-a-linha com contagem de profundidade** e **valide antes de
gravar**:

```python
depth = 0
for l in linhas:
    t = l.strip()
    if re.match(r'^object \w+: T', t) or t == 'item': depth += 1
    elif t in ('end','end>'): depth -= 1
if depth != 0: abortar()      # não grava
```

### #11 — Escrita de arquivo: valide o encoding ANTES de abrir para escrita

`io.open(p,'w')` **trunca na abertura**. Se o `write` falhar depois (ex.: um `—`
que não existe em latin-1), o fonte vai a **0 bytes**. Aconteceu com o
`UGerrelat.pas`.

Padrão seguro (usar sempre):

```python
try:
    data = s.encode('latin-1')
except UnicodeEncodeError as e:
    sys.exit('ABORTADO: %r' % s[e.start:e.start+20])   # arquivo NÃO é tocado
tmp = p + '.tmp'
io.open(tmp,'wb').write(data)
os.remove(p); os.rename(tmp, p)
```

E **faça backup** do arquivo antes de qualquer script.

### #12 — Teste isolado não usa as flags do projeto

`amortrat.cfg` liga **`-$Q+`** (overflow check). Compilar um `.dpr` de teste só
com `-U`/`-I` usa os **defaults**, mais permissivos → o teste passa e o IDE
quebra.

Foi assim com o bcrypt: `EIntOverflow` no login. O Blowfish depende de soma
**módulo 2³²** (o estouro é parte do algoritmo). Solução — diretiva **local**:

```pascal
unit UBCrypt;
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}
```

**Ao validar com `.dpr` isolado, repasse `-$Q+ -$R+`.**

### #13 — `ExecSQL` sobre `SELECT` funciona no BDE e quebra no ZeosLib

Padrão encontrado no UOS: `Q.SQL.Text := 'SELECT...'; Q.ExecSQL; Q.Active := True;`
Trocar por `Open`.

### #14 — SQL: sintaxe Paradox → MySQL

| Paradox | MySQL |
|---|---|
| `like "%texto%"` (aspas duplas) | `like ` + `QuotedStr('%'+texto+'%')` ou parâmetro |
| `= false` / `= true` | `= 0` / `= 1` |
| `(:pNow - A.DATA)` | `DATEDIFF(:pNow, A.DATA)` |
| `order by 12` | `order by <alias>` |

Todo SQL concatenado com entrada de usuário deve virar **parâmetro** ou
`QuotedStr`.

### #15 — `Size` de TField persistente **trunca** dado do MySQL

Os `Size` vinham do Paradox. Se a coluna MySQL é maior, trunca em silêncio:

| Campo | Size no DFM | Coluna real | Efeito |
|---|---|---|---|
| `QPecasCODIGO` (ULocalizar) | 2 | `varchar(3)` | `060`→`06`, devolvia peça errada |
| `QProcLINHA1..7` (UOS) | 40 | `varchar(100)` | cortava instruções impressas |
| `QPecasFIGURA` | 100 | `varchar(200)` | path truncado → imagem não carrega |

**Mais robusto:** remover os TFields persistentes e usar `FieldByName`. Isso
também evita *type mismatch* (`TBooleanField` sobre `tinyint`, `TCurrencyField`
sobre `decimal`).

### #16 — `EditMask`: o 3º parâmetro decide o formato de `.Text`

```
'99.999.999/9999-99;0;_'  -> MaskSave=FALSE -> .Text tem SÓ os dígitos
'99999-999;1;_'           -> MaskSave=TRUE  -> .Text tem os literais
```

Os dados migrados vêm em formatos **mistos** na mesma tabela: em `tb_clientes` o
CNPJ está formatado (`01.150.252/0001-60`) e os telefones em dígitos puros.
Atribuir valor formatado num campo `;0;` faz o controle consumir cada `.` e `/`
como dígito → `01..15.0.2/52/0-00`.

Normalize na leitura e reformate na gravação (o banco tem `sync_hash`; gravar em
formato diferente divergiria o hash). Truque: o metacaractere `9` aceita **dígito
OU espaço** — telefone de 10 dígitos em máscara de 11 alinha com um espaço no 3º
slot: `(11) 4343-7703`.

### #17 — FK criada com `FOREIGN_KEY_CHECKS=0` é bomba armada

`FK_OS_FORNEC` apontava `tb_os.FORNECEDOR` → `tb_fornecedores`, mas os valores em
uso eram **códigos de cliente** (no Paradox `TBFornec` e `TBClientes` leem o mesmo
`CLIENTES.DB` — fornecedor **é** cliente). 12 linhas violavam a FK; qualquer
`UPDATE` incluindo a coluna falharia com **errno 1452**.

**Resolvido em 2026-08-22** (sem alterar dados):

```sql
ALTER TABLE tb_os DROP FOREIGN KEY FK_OS_FORNEC;
ALTER TABLE tb_os ADD CONSTRAINT FK_OS_FORNEC FOREIGN KEY (FORNECEDOR)
  REFERENCES tb_clientes(CODIGO) ON DELETE SET NULL ON UPDATE CASCADE;
```

**Antes de migrar form que grava, confira as FKs da tabela.**

**Corolário — as regras `ON DELETE` mudam a lógica:** `FK_OSFIN_OS` é `CASCADE`
(apagar a OS já apaga a finalização — **não** deletar manualmente);
`FK_NFITENS_OS` é `SET NULL`.

### #18 — Antes de "simplificar", pergunte que problema aquilo resolvia

O `Append`/`Post` cedo era **concorrência** (#4.4). O `TabEnter1` "nunca
referenciado" **age sozinho** (faz Enter navegar como Tab) — removê-lo mudaria o
teclado. `Filtered=True` sem `Filter` é inerte.

### #19 — Resíduos de QuickReport no `uses` → `MSXML_TLB.dcu` não encontrado (2026-08-25)

**Sintoma (máquina nova):** `[DCC Fatal Error] URelatCQ.pas(16): F1026 File not found: 'MSXML_TLB.dcu'`

**Causa:** `URelatCQ` tinha `QRCtrls, QuickRpt` no `uses` — resíduo da versão
Paradox. O QuickReport instalado só existe em subpastas (`lib\QR504\`) fora do
Library Path padrão. O form já usa FortesReport exclusivamente.

**Correção:** remover `QRCtrls, QuickRpt` do `uses` de `URelatCQ.pas`. Nenhum
componente ou símbolo desses units era usado no código nem no DFM.

**Busca preventiva:** `grep -ri "QRCtrls\|QuickRpt" *.pas` — já verificado, só
estava em `URelatCQ`.

### #20 — `ZConexao.Commit` com `AutoCommit=True` lança exceção no ZeosLib 8.x (2026-08-25)

**Sintoma:** `EZDatabaseError: 'Invalid operation in AutoCommit mode'` ao gerar
qualquer relatório no `UGerrelat`. No IDE aparece como "Debugger Exception
Notification" antes do `except` tratar.

**Causa:** `TModulo.NovaLeitura` chamava `ZConexao.Commit` quando `AutoCommit=True`
para encerrar o snapshot REPEATABLE READ. Em versões anteriores do ZeosLib o driver
tolerava; no 8.x `CheckNonAutoCommitMode` lança a exceção de forma garantida
(linha 1129 de `ZAbstractConnection.pas`).

**Correção aplicada em `UModulo.NovaLeitura`:**

```pascal
// Antes (lançava exceção no ZeosLib 8.x):
ZConexao.Commit;

// Depois (correto):
ZConexao.StartTransaction;   // emite BEGIN → ajusta contadores internos
ZConexao.Commit;             // emite COMMIT → reseta snapshot, restaura AutoCommit=True
```

`StartTransaction` com `AutoCommit=True` é a forma suportada pelo ZeosLib 8.x
para forçar um ciclo BEGIN/COMMIT sem conflito com os contadores internos.

### #21 — O projeto compila com `-$B+`: **não** há curto-circuito booleano (2026-08-30)

`amortrat.cfg` liga `-$B+` (BOOLEVAL ON). Os dois lados de um `and`/`or` são
**sempre** avaliados. Padrões como este continuam tocando o dataset em EOF:

```pascal
until (Q.Eof) or (Q.FieldByName('LEADTIME').AsFloat <= 10);
```

Ao migrar um laço assim, leia o campo numa variável antes:

```pascal
if Q.Eof then Lead := 0 else Lead := Q.FieldByName('LEADTIME').AsFloat;
until (Q.Eof) or (Lead <= 10);
```

Flags completas do `.cfg`: `-$B+ -$C+ -$D+ -$G+ -$H+ -$I+ -$J+ -$L+ -$N+ -$O+
-$P+ -$Q+ -$R- -$T+ -$V+ -$X+`.

### #22 — `Append` sem `Post` no BDE funciona por post implícito (2026-08-30)

Encontrado no `UNf.BTGravarClick`: um laço fazia `TBNf_Itens.Append` a cada
linha da grid e **o `Post` estava comentado**. Só o último registro era postado
explicitamente, no `try` do final.

Não era bug: o `TDataSet` da VCL faz `CheckBrowseMode` ao entrar em `Append`,
que **posta implicitamente** o registro pendente. O laço gravava tudo por efeito
colateral.

Com SQL isso não existe — cada iteração precisa de um `INSERT` explícito. Se
traduzir o laço "ao pé da letra", **só a última linha da NF é gravada**.

### #23 — Ao substituir bloco de DFM por número de linha, confira o que há no meio

Substituí o intervalo das queries do `UNf.dfm` assumindo que só havia
`TRxQuery` ali. No meio estavam `TabEnter1`, `ACBrNFe1`, `ACBrNFeDANFeRL1` e
`ACBrMail1` — **apagados sem erro de sintaxe**, porque o DFM continuou
balanceado. O `.pas` referenciava os quatro.

Detectado comparando componentes antes/depois:

```bash
grep -oE "^ +object [A-Za-z_0-9]+: T[A-Za-z_0-9]+" original.dfm | sort > /tmp/a
grep -oE "^ +object [A-Za-z_0-9]+: T[A-Za-z_0-9]+" novo.dfm     | sort > /tmp/b
comm -23 /tmp/a /tmp/b     # removidos: só deveriam ser TField/TRxQuery
```

**Rode essa comparação sempre.** O check de balanceamento (#10) não pega isto.

### #24 — Formatação numérica: escolha o `As*` pelo tipo REAL da coluna (2026-08-30)

Ao remover TFields persistentes de dados fiscais, o acesso por `FieldByName`
precisa casar com o tipo do banco, senão muda arredondamento e texto:

| Coluna MySQL | Era | Use |
|---|---|---|
| `decimal(15,4)` (VALOR, PRECO_TOTAL, ICMS_BASE) | `TCurrencyField` | `.AsCurrency` — `Currency` tem exatamente 4 casas |
| `double` (PESO, QUANTIDADE, PRECO_UNITARIO) | `TFloatField` | `.AsFloat` |
| `date` (DATAE, DATA_FIM) | `TDateField` | `.AsDateTime` / param `.AsDate` |

E troque as conversões que passavam por string:

```pascal
StrToFloat(campo.AsString)  ->  campo.AsFloat
StrToCurr(campo.AsString)   ->  campo.AsCurrency
```

Mesmo valor, sem depender de como o ZeosLib formata `.Text` para o tipo que
inferir. Onde o código **exibia** `campo.AsString` de um `TCurrencyField`, use
`FloatToStr(campo.AsFloat)`: é literalmente o que `TFloatField.GetAsString`
fazia, então o texto sai idêntico.

---

## 6. Detalhes específicos que custaram análise

### 6.1 Chave da OS: `NNNNNN/AA`

`tb_os.CODIGO` é `varchar(9)`, formato **sequencial de 6 dígitos + `/` + ano**
(`098800/26`). **Não** serve `MAX(CAST(CODIGO AS UNSIGNED))` — o CAST para no `/`
e mistura exercícios:

```sql
SELECT MAX(CAST(SUBSTRING(CODIGO,1,6) AS UNSIGNED)) FROM tb_os
WHERE SUBSTRING(CODIGO,8,2) = :pAno
```

Existem resíduos antigos, inclusive um malformado (`0 9319/92`, com espaço).

### 6.2 Volume — não dá para "navegar" a tabela

`tb_os` **94.554** linhas · `tb_os_finalizados` 94.018 · `tb_nf_itens` 143.641.
Todo `FindKey`/`Last` do BDE virou `SELECT ... WHERE` com índice.

### 6.3 Divergências de nome Paradox → MySQL

| Paradox | MySQL |
|---|---|
| `apontamento2.DB`: `COD_APONTAMENTO`, `COD_EQUIPAMENTO`, `COD_FUNCIONARIO`, `OS`, `DATA_INICIO`, `DATA_FIM` | `tb_apontamentos`: `ID`, `EQUIPAMENTO`, `COLABORADOR`, `OS_CODIGO`, `DT_INICIO`, `DT_FIM` |
| `os_terceirizadas.DB` | **não existe** no MySQL |
| `colaboradores.DB` | `tb_colaboradores` (ganhou `ATIVO`) |

### 6.4 bcrypt (`UBCrypt.pas`)

Implementada no projeto porque **não existe bcrypt no ambiente** e o OpenSSL não
o oferece (o `bcrypt.dll` do Windows é a CNG — algoritmo diferente). Necessária
porque **o portal web grava bcrypt** na mesma coluna `tb_usuario.SENHA`.

**`TestBCrypt.dpr` roda os 17 vetores oficiais OpenBSD/jBCrypt.**
**Não altere a unit sem rodá-lo — e com `-$Q+`** (armadilha #12).

Dois defeitos que só o teste revelou:
1. `$2b$`/`$2y$` eram rejeitados (eu remontava sempre como `$2a$` e comparava a
   string inteira). **Node/PHP geram `$2b$` por padrão** → login do portal
   falharia. Fix: comparar a partir do cost.
2. `R` vs `r` (armadilha #9).

**Login com upgrade transparente:** hash bcrypt → valida por bcrypt; texto puro
legado → compara direto e **regrava como bcrypt**. Assim o texto puro some
sozinho. Custo: cost=10 ≈ 200 ms por login (proposital).

`Modulo.UsuarioLogado` guarda o login autenticado — substituiu a leitura de
`TBUsuarioLOGIN.Value` (cursor BDE) que o UGerrelat usava para restringir
relatórios ao usuário `PRODUCAO`.

### 6.5 Nomes enganosos preservados

- `UOS.BTLimparClick` → **imprime** a OS (não limpa)
- `UUsuarios.BTLocalizarClick` → **inclui** usuário (não localiza)
- `UOS.BTCancelarClick` → não chama `Cancel`

Comportamento mantido, apenas documentado no código.

---

## 7. Pendências conhecidas

### 7.1 🔴 Encoding `Ç` → `Ã` (740 registros) — POSTERGADO

**Decisão do usuário:** corrigir só depois de toda a migração, desligando o sync
com o Paradox e rodando um script único de UPDATE.

**Diagnóstico (já feito, não repetir):** a importação decodificou bytes cp1252
como UTF-8. `0xC7` (Ç) seguido de **ASCII** virou `Ã`; seguido de **byte alto**
sobreviveu como `Ç` (por isso `FIXAÇÃO` está certo e `PEÇA` não).

**Escopo:** 740 registros — `tb_pecas` (DESCRICAO 468, MATERIAL 27, OBS 50),
`tb_clientes` (RAZAO 46, FANTASIA 10, ENDERECO 38, CIDADE 97), `tb_proc` (4).

⚠️ **O furo do plano "script único de UPDATE":** a corrupção é *lossy* e ambígua.

```
Paradox:  PRESS c3 O  = PRESSÃO (Ã legítimo)   ->  MySQL: PRESS C383 O
Paradox:      A c7 O  = AÇO     (Ç corrompido) ->  MySQL:     A C383 O
```

Ficam **idênticos** no MySQL. Dos 468 casos em DESCRICAO: **109** (`ÃA`) são
corrigíveis por regra (não existe "ãa" em português); **315** (`ÃO`) são
**indecidíveis** sem a origem.

**Consequência:** o Paradox precisa continuar acessível quando o script rodar.
Preservar `D:\AMORTRAT\BD\Copy` até o fix estar validado. O Paradox está íntegro
(23/23 `ABRAÇADEIRA` e 31/31 `PEÇA` com `0xC7`).

### 7.2 Testes funcionais pendentes

**Esta é a prioridade agora que o código está migrado.** Só o **login** e a
geração de relatório do `UGerrelat` foram exercitados em uso real.

O SQL de `principal`, `UNf` e `UModulo` foi validado contra o banco (execução e
`PREPARE`), mas **nenhum fluxo de gravação foi testado pela interface**.

Roteiro sugerido, do menos ao mais arriscado:

1. **Abrir o sistema** — o `DataModuleCreate` mudou bastante; confirmar que
   conecta e que o menu abre sem erro.
2. **`principal`**: Resumo Diário e Ranking (mandam WhatsApp — conferir se os
   números batem com o Paradox); Controle Produção e PowerBI (geram `.xlsx`).
3. **`UUsuarios` / `UReajuste`** — cadastros simples.
4. **`FOs`**: criar OS (código `NNNNNN/AA` + pré-reserva), gravar+imprimir,
   finalizar, desfinalizar, terceirizar — em especial numa das **12 OS com
   `FORNECEDOR` `0027`/`0292`**, que era o caso que quebrava por FK.
5. **`URelatCQ`**: CQ, PDF e envio por e-mail (`\\PRODUCAO\Amortrat\CQ` é rede).
6. **`UGerrelat`**: os 12 tipos de relatório.
7. **`UNf` — deixar por último, é o de maior risco.** Testar **em homologação**
   (`tb_config` cod 4 = `2`) antes de qualquer nota real:
   - abrir NF nova → confirmar que o número vem com 6 dígitos (`027661`, não
     `27661`) e que o stub aparece em `tb_nf`;
   - **sair sem gravar** → o stub tem de sumir (`LiberarCodigoReservado`);
   - adicionar **3+ itens** e gravar → conferir se **todos** foram para
     `tb_nf_itens`. Este é o ponto que a armadilha #22 quebraria: no BDE o laço
     gravava por post implícito;
   - reabrir a NF → grid tem de voltar com os mesmos valores, casas decimais
     inclusive;
   - conferir `PRECO_TOTAL`, `VALOR`, `TOTAL_NOTA` e `ICMS_BASE` no banco contra
     a tela (armadilha #24);
   - só então: enviar NF-e, imprimir DANFE, e-mail, cancelamento, carta de
     correção, recuperação.
8. **Comparar PDFs** (DANFE e CQ) da mesma OS/NF antes e depois da migração.

### 7.3 Observações de dados (não são bugs de código)

- `tb_os_finalizados.FORNO` está **NULL em todos** → o relatório de produção por
  forno sai com uma linha só
- `tb_email` tem **duplicatas** de sync (resolvido com `DISTINCT` nas queries)
- `tb_pecas.FIGURA` é NULL em boa parte → `LoadFromFile` precisa de guarda
- **72 CNPJs de lixo** em `tb_clientes` (56 com 2 dígitos, 10 com 1, 6 vazios)
- `tb_fornecedores` ficou **órfã** (2 registros) após repontar a FK

### 7.4 Dívidas menores

- `RetZero` duplicado no UOS (`TFOs.RetZero` + `Modulo.RetZero`) — idênticos,
  mantidos para não arriscar
- `Application.CreateForm` a cada abertura em `FUsuarios`/`FReajuste`/`FGerRelat`
  sem `Free` — vazamento **pré-existente**, não introduzido
- Forms órfãos (16) fora do `.dpr`: `UApontamento`, `UApontamento2`, `UAltPecas`,
  `UFinalizar`, `UFechamento`, `UGraficos`, `UOrcamento`, `URelat`, `URelarNF`,
  `URelatOS2`, `Uexport`, `MySqlTestConn`, `TesteConn`, `Unit1`, `teste`,
  `principal_sem_nf`. **Não precisam migração.** Confirmar se
  `UApontamento`/`UApontamento2` deveriam estar ativos — `tb_apontamentos` tem
  1.318 registros.

### 7.5 DLLs x86/x64 — `zlib1.dll` trocada (RESOLVIDO em 2026-08-30)

**Sintoma:** `EACBrXmlException: 'Não foi possível carregar a biblioteca
LibXml2.'` na abertura do sistema.

**Causa:** o `amortrat.exe` é Win32. A `libxml2.dll` do diretório **é x86 e
está correta**, mas ela importa `iconv.dll` e **`zlib1.dll`** — e a `zlib1.dll`
presente era **x64**. O Windows falha ao resolver a dependência e reporta erro
193 na própria `libxml2.dll`, o que despista o diagnóstico.

Dependências reais (via `tdump -em libxml2.dll`):

```
KERNEL32.dll  WSOCK32.dll  msvcrt.dll  iconv.dll  zlib1.dll
```

**Correção aplicada:** `zlib1.dll` substituída pela x86 de
`C:\Amortrat\novas DLL` (107.520 bytes). A x64 original ficou em
`C:\Amortrat\_dlls_backup_20260830_170227\zlib1.dll.x64-original`.

Comprovado com `LoadLibraryEx` num processo 32-bit:

| DLL | antes | depois |
|---|---|---|
| `zlib1.dll` | erro 193 | **OK** |
| `libxml2.dll` | erro 193 | **OK** |
| `libxmlsec.dll` | erro 193 | **OK** |

#### Por que funcionava antes e quebrou na máquina nova?

**Não é o Windows 11.** As DLLs x64 estão no diretório desde antes: o backup
`_dlls_backup_20260823_010706/substituidas/` guarda arquivos **idênticos** aos
que estavam em uso (mesmo tamanho e data), ou seja, a tentativa de troca de
23/08 foi revertida.

A hipótese mais provável é que a máquina Windows 10 tivesse uma `zlib1.dll`
**x86** acessível pelo PATH global (instalada por outro software) — o Windows a
encontrava antes de chegar na do diretório. Esta máquina não tem nenhuma
`zlib1.dll` em `SysWOW64`/`System32`. Não dá para confirmar sem acesso à
máquina antiga.

#### As outras DLLs x64 do diretório são inertes

Continuam x64 (`libeay32`, `ssleay32`, `libcrypto-*-x64`, `libssl-*-x64`,
`libxmlsec1*`, `libiconv*`, `libcharset-1`, `libltdl-7`), **mas não são
carregadas neste projeto**:

- **OpenSSL** — o Synapse do ACBr aceita vários nomes, entre eles
  `libcrypto-1_1.dll` e `libssl-1_1.dll`, que existem em **x86** no
  `C:\Windows\SysWOW64`.
- **`libxmlsec*`** — só serve para `SSLXmlSignLib = xsXmlSec`. O projeto usa
  **`xsLibXml2`** (`ACBrDFeXsLibXml2.pas`), que assina com libxml2 + OpenSSL.

⚠️ **Ainda não testado na prática.** Se a emissão de NF-e falhar por OpenSSL,
o caminho é remover/renomear `libeay32.dll` e `ssleay32.dll` (x64) do
diretório, para o ACBr cair nas `libcrypto-1_1.dll`/`libssl-1_1.dll` x86 do
sistema.

**Como conferir a arquitetura de uma DLL:**

```bash
off=$(od -An -tu4 -j60 -N4 X.dll | tr -d ' ')
od -An -tx2 -j$((off+4)) -N2 X.dll    # 014c = x86 · 8664 = x64
```

> O monitor de status (`UStatusMonitor`) não define `SSLXmlSignLib`: a consulta
> de status não assina XML, só faz TLS mútuo. Por isso ele não depende da
> libxml2 nem carregava — era só a configuração indevida que eu havia copiado
> do UNf.

---

## 8. Checklist para migrar o próximo form

1. **Levantar** — datasets no DFM, `DataSource`/`DataField`, `TRxLookupEdit`,
   `TDB*`, e no `.pas`: `FindKey`/`GotoKey`/`Locate`/`Append`/`Post`,
   `Modulo.TB*`, `Modulo.DS*`
2. **Conferir o schema real** — `SHOW TABLES`, `DESCRIBE`, e as **FKs**
   (armadilha #17)
3. **Quem mais usa** — outro form referencia os TFields deste? (armadilha #8)
4. **DFM** — `TRxQuery`→`TZQuery` com **parser**, não regex (armadilha #10);
   `TRxLookupEdit`→`TComboBox` sem `OEMConvert` (#4); `OnActivate`→`OnShow` (#4.2)
5. **PAS** — `uses` (tirar `DBTables`/`RxQuery`/`RxLookup`, pôr `ZDataset`);
   `GarantirConexao`; `NovaLeitura` nos pontos de leitura (#1);
   `FindKey`→`SELECT ... WHERE`; booleanos `.AsInteger` (#6);
   pré-reserva de código se for cadastro (#4.4)
6. **Validar o SQL no banco** antes de compilar — sempre pegou erro cedo
7. **Verificar** — declaração×implementação, handlers do DFM×`.pas`,
   balanceamento `begin`/`end` por método, resíduo BDE com `grep -i` (#9)
8. **F9 no IDE** e testar o fluxo de ponta a ponta

---

## 9. Onde estão as coisas

```
D:\AMORTRAT\mysql\code\
  HANDOFF-MIGRACAO-MYSQL.md   <- este arquivo
  UBCrypt.pas                 <- bcrypt (não alterar sem TestBCrypt)
  TestBCrypt.dpr              <- 17 vetores oficiais; rodar com -$Q+
  amortrat.ini                <- credenciais MySQL
  amortrat.dpr / amortrat_mysql.dproj
```

`UBCrypt` está registrada no `.dpr` **e** no `.dproj` — se criar unit nova,
registre nos dois.

Backups dos fontes pré-migração ficaram em diretório temporário desta máquina
(**não** vão junto). Se precisar do original, use o Paradox de produção como
referência ou o histórico do repositório.
