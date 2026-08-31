<#
  Run-Roteiro.ps1

  Executa um roteiro de regressao contra UM executavel do AMORTRAT e grava os
  snapshots. A ideia e rodar o MESMO roteiro contra a versao Paradox e contra a
  MySQL e depois comparar os resultados com Compare-Run.ps1.

  Exemplo:
    .\Run-Roteiro.ps1 -Roteiro roteiros\01-cliente.json `
                      -Exe "C:\Amortrat\code\amortrat.exe" `
                      -Rotulo paradox

    .\Run-Roteiro.ps1 -Roteiro roteiros\01-cliente.json `
                      -Exe "C:\Amortrat\mysql\code\amortrat.exe" `
                      -Rotulo mysql

  FORMATO DO ROTEIRO (JSON)

  {
    "nome": "cadastro-cliente",
    "passos": [
      { "acao":"aguardar-janela", "classe":"TFLogin", "timeout":40 },
      { "acao":"escrever",  "classe":"TEdit", "indice":0, "valor":"$USUARIO" },
      { "acao":"clicar",    "classe":"TIAeverButton", "texto":"*OK*" },
      { "acao":"snapshot",  "nome":"02-menu" },
      { "acao":"esperar",   "ms":500 }
    ]
  }

  Acoes disponiveis:
    aguardar-janela  classe|titulo, timeout   -> passa a ser a janela corrente
    snapshot         nome                     -> grava JSON + PNG
    escrever         seletor + valor
    clicar           seletor
    combo            seletor + valor          -> seleciona item pelo texto
    esperar          ms                       -> pausa explicita (use pouco)
    aguardar-ocioso  timeout                  -> espera a janela responder

  Seletor, em ordem de preferencia:
    "chave": "TEdit@17,88"    exato (classe + posicao)
    "pos":   "17,88"          SO a posicao - use quando a classe mudou entre
                              as versoes (TRxLookupEdit -> TComboBox)
    "classe" + "indice"       n-esima ocorrencia da classe
    "texto":  "*Entrar*"      por legenda (aceita curinga)
#>

param(
  [Parameter(Mandatory)][string]$Roteiro,
  [Parameter(Mandatory)][string]$Exe,
  [Parameter(Mandatory)][string]$Rotulo,
  [string]$Usuario = "",
  [string]$Senha   = "",
  [string]$SaidaRaiz,
  [switch]$ManterAberto
)

$ErrorActionPreference = "Stop"

# $PSScriptRoot nem sempre esta disponivel na avaliacao do valor padrao de um
# parametro (depende de como o script foi invocado). Resolver aqui, com
# fallback, evita caminho quebrado quando chamado pelo wrapper .cmd.
$raizScript = $PSScriptRoot
if (-not $raizScript) { $raizScript = Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $SaidaRaiz)  { $SaidaRaiz  = Join-Path $raizScript "resultados" }

Import-Module (Join-Path $raizScript "AmortratUI.psm1") -Force

if (-not (Test-Path $Exe))     { throw "executavel nao encontrado: $Exe" }
if (-not (Test-Path $Roteiro)) { throw "roteiro nao encontrado: $Roteiro" }

$rot  = Get-Content $Roteiro -Raw -Encoding UTF8 | ConvertFrom-Json
$dirS = Join-Path $SaidaRaiz ("{0}\{1}" -f $rot.nome, $Rotulo)
if (Test-Path $dirS) { Remove-Item $dirS -Recurse -Force }
New-Item -ItemType Directory -Force -Path $dirS | Out-Null

$log = New-Object System.Collections.ArrayList
function Log($txt) {
  $linha = ("[{0:HH:mm:ss}] {1}" -f (Get-Date), $txt)
  [void]$log.Add($linha); Write-Output $linha
}

Log "roteiro : $($rot.nome)"
Log "exe     : $Exe"
Log "rotulo  : $Rotulo"
Log "saida   : $dirS"

# O sistema resolve caminhos relativos ao diretorio do .exe (amortrat.ini,
# libmysql.dll, certificado). Sem isso a versao MySQL nem conecta.
$proc = Start-Process -FilePath $Exe -WorkingDirectory (Split-Path $Exe -Parent) -PassThru
Log "processo iniciado: PID $($proc.Id)"

$janela = $null
$erros  = 0

function Resolve-ControlePasso($tree, $passo) {
  $tem = { param($n) $passo.PSObject.Properties.Name -contains $n }

  if ((& $tem 'chave') -and $passo.chave) { return (Find-Control -Tree $tree -Key $passo.chave) }

  $cls = if (& $tem 'classe') { $passo.classe } else { $null }

  # 'pos' e o seletor preferido quando o componente mudou de classe entre as
  # duas versoes mas ficou no mesmo lugar (ver Find-Control).
  if ((& $tem 'pos') -and $passo.pos) { return (Find-Control -Tree $tree -Pos $passo.pos -Class $cls) }

  $idx = if (& $tem 'indice') { [int]$passo.indice } else { 0 }
  $txt = if (& $tem 'texto')  { $passo.texto }  else { $null }
  return (Find-Control -Tree $tree -Class $cls -Index $idx -TextLike $txt)
}

try {
  foreach ($passo in $rot.passos) {

    switch ($passo.acao) {

      'aguardar-janela' {
        $cls = if ($passo.PSObject.Properties.Name -contains 'classe') { $passo.classe } else { $null }
        $tit = if ($passo.PSObject.Properties.Name -contains 'titulo') { $passo.titulo } else { $null }
        $to  = if ($passo.PSObject.Properties.Name -contains 'timeout') { [int]$passo.timeout } else { 40 }
        $janela = Wait-AmortratWindow -ProcessId $proc.Id -ClassName $cls -TitleLike $tit -TimeoutSeg $to
        if (-not $janela) { Log "ERRO: janela nao apareceu (classe=$cls titulo=$tit) em ${to}s"; $erros++; break }
        Log "janela: [$($janela.Class)] '$($janela.Title)'"
      }

      'aguardar-ocioso' {
        $to = if ($passo.PSObject.Properties.Name -contains 'timeout') { [int]$passo.timeout } else { 60 }
        [void](Wait-AmortratIdle -Handle ([IntPtr]$janela.Handle) -TimeoutSeg $to)
      }

      'snapshot' {
        if (-not $janela) { Log "ERRO: snapshot sem janela corrente"; $erros++; continue }
        # rele a janela: ela pode ter sido recriada entre passos
        $j = Wait-AmortratWindow -ProcessId $proc.Id -ClassName $janela.Class -TimeoutSeg 5
        if ($j) { $janela = $j }
        $s = New-Snapshot -Handle ([IntPtr]$janela.Handle) -Dir $dirS -Nome $passo.nome
        Log "snapshot '$($passo.nome)': $($s.Controles.Count) controles"
      }

      'escrever' {
        $tree = @(Get-ControlTree -Root ([IntPtr]$janela.Handle))
        $c = Resolve-ControlePasso $tree $passo
        if (-not $c) { Log "ERRO: controle nao encontrado para 'escrever' ($($passo | ConvertTo-Json -Compress))"; $erros++; continue }
        $v = $passo.valor
        if ($v -eq '$USUARIO') { $v = $Usuario }
        if ($v -eq '$SENHA')   { $v = $Senha }
        Set-ControlText -Handle ([IntPtr]$c.Handle) -Text $v
        $mostra = if ($passo.valor -eq '$SENHA') { '***' } else { $v }
        Log "escrever [$($c.Class)@$($c.Left),$($c.Top)] = '$mostra'"
      }

      'clicar' {
        $tree = @(Get-ControlTree -Root ([IntPtr]$janela.Handle))
        $c = Resolve-ControlePasso $tree $passo
        if (-not $c) { Log "ERRO: controle nao encontrado para 'clicar' ($($passo | ConvertTo-Json -Compress))"; $erros++; continue }
        Invoke-ControlClick -Handle ([IntPtr]$c.Handle)
        Log "clicar [$($c.Class)@$($c.Left),$($c.Top)] '$($c.Text)'"
        [void](Wait-AmortratIdle -Handle ([IntPtr]$janela.Handle) -TimeoutSeg 30)
      }

      'combo' {
        $tree = @(Get-ControlTree -Root ([IntPtr]$janela.Handle))
        $c = Resolve-ControlePasso $tree $passo
        if (-not $c) { Log "ERRO: combo nao encontrado"; $erros++; continue }
        if (Select-ComboItem -Handle ([IntPtr]$c.Handle) -Item $passo.valor) {
          Log "combo [$($c.Class)@$($c.Left),$($c.Top)] = '$($passo.valor)'"
        } else {
          Log "ERRO: item '$($passo.valor)' nao existe no combo"; $erros++
        }
      }

      'teclas' {
        # Unico jeito de acionar o menu principal: ele e TBcBarMainMenu e, como
        # todo menu do VCL, nao tem handle. Os itens tem acelerador no Caption
        # ('&Cadastro' -> Alt+C), entao vai por teclado.
        if (-not $janela) { Log "ERRO: 'teclas' sem janela corrente"; $erros++; continue }
        $ms = if ($passo.PSObject.Properties.Name -contains 'pausaMs') { [int]$passo.pausaMs } else { 300 }
        Send-Teclas -Handle ([IntPtr]$janela.Handle) -Teclas $passo.valor -PausaMs $ms
        Log "teclas '$($passo.valor)'"
      }

      'focar' {
        if (-not $janela) { Log "ERRO: 'focar' sem janela corrente"; $erros++; continue }
        $ok = Set-JanelaFoco -Handle ([IntPtr]$janela.Handle)
        Log ("focar [{0}]: {1}" -f $janela.Class, $(if ($ok) { 'ok' } else { 'NAO obteve foco' }))
      }

      'esperar' { Start-Sleep -Milliseconds ([int]$passo.ms) }

      default { Log "ERRO: acao desconhecida '$($passo.acao)'"; $erros++ }
    }
  }
}
finally {
  $log | Set-Content (Join-Path $dirS "_execucao.log") -Encoding UTF8
  if (-not $ManterAberto) {
    try { $proc | Stop-Process -Force -ErrorAction SilentlyContinue } catch {}
    Log "processo encerrado"
  }
}

Write-Output ""
if ($erros -eq 0) { Write-Output "OK - roteiro concluido sem erros. Snapshots em: $dirS" }
else              { Write-Output "ATENCAO - $erros erro(s). Veja $dirS\_execucao.log" }
