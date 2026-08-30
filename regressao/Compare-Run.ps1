<#
  Compare-Run.ps1

  Compara os snapshots de duas execucoes do MESMO roteiro (Paradox x MySQL) e
  gera um relatorio HTML.

  Exemplo:
    .\Compare-Run.ps1 -Roteiro cadastro-cliente -A paradox -B mysql

  COMO O RESULTADO E CLASSIFICADO

  A migracao trocou alguns componentes de propósito (TRxLookupEdit virou
  TComboBox, por exemplo), entao as duas telas NAO sao identicas em estrutura.
  Misturar isso com diferenca de dado esconderia o que interessa. Por isso a
  saida separa:

    VALOR       o mesmo controle existe nos dois lados e o TEXTO difere
                -> e aqui que mora bug de migracao
    ESTADO      mesmo controle, mesmo texto, mas Enabled/Visible difere
                -> foi assim que o bug do "OS ja finalizada" apareceria
    ESTRUTURA   controle so existe de um lado, ou mudou de classe/posicao
                -> normalmente esperado; conferir uma vez e anotar

  NORMALIZACAO

  Antes de comparar texto, aplica-se normalizacao para nao acusar diferenca
  onde o dado e o mesmo:
    - espacos nas pontas e espacos repetidos
    - 1.234,50 / 1234,5 / 1234.50  -> mesmo numero
    - 01/02/2026 e 1/2/2026        -> mesma data
    - caixa alta/baixa e acentuacao sao PRESERVADAS (diferenca ali importa)
#>

param(
  [Parameter(Mandatory)][string]$Roteiro,
  [string]$A = "paradox",
  [string]$B = "mysql",
  [string]$SaidaRaiz = "$PSScriptRoot\resultados",
  [switch]$IgnorarEstrutura
)

$ErrorActionPreference = "Stop"

$dirA = Join-Path $SaidaRaiz "$Roteiro\$A"
$dirB = Join-Path $SaidaRaiz "$Roteiro\$B"
foreach ($d in @($dirA, $dirB)) { if (-not (Test-Path $d)) { throw "execucao nao encontrada: $d" } }

# ---------------------------------------------------------------------------
# Normalizacao
# ---------------------------------------------------------------------------

function Normalizar([string]$t) {
  if ($null -eq $t) { return "" }
  $s = $t -replace "`r", "" -replace "`n", " "
  $s = ($s -replace '\s+', ' ').Trim()
  if ($s -eq '') { return '' }

  # numero: aceita 1.234,50 | 1234,5 | 1234.50 | R$ 1.234,50
  $n = $s -replace '^R\$\s*', ''
  if ($n -match '^-?[\d\.,]+$' -and $n -match '\d') {
    $limpo = $n
    if ($limpo -match ',\d{1,4}$') { $limpo = ($limpo -replace '\.', '') -replace ',', '.' }
    else                            { $limpo = $limpo -replace ',', '' }
    # InvariantCulture obrigatorio: sob pt-BR o TryParse leria o ponto de
    # '1234.50' como separador de milhar e devolveria 123450.
    $d = 0.0
    $inv = [Globalization.CultureInfo]::InvariantCulture
    if ([double]::TryParse($limpo, [Globalization.NumberStyles]::Float, $inv, [ref]$d)) {
      return ('#NUM:' + $d.ToString('0.####', $inv))
    }
  }

  # data dd/mm/aaaa (com ou sem zero a esquerda)
  if ($s -match '^(\d{1,2})/(\d{1,2})/(\d{2,4})$') {
    return ('#DATA:{0:0000}-{1:00}-{2:00}' -f [int]$Matches[3], [int]$Matches[2], [int]$Matches[1])
  }
  return $s
}

# ---------------------------------------------------------------------------
# Comparacao de um par de snapshots
# ---------------------------------------------------------------------------

function Compare-SnapshotPar($fA, $fB, $nome) {
  $sa = Get-Content $fA -Raw -Encoding UTF8 | ConvertFrom-Json
  $sb = Get-Content $fB -Raw -Encoding UTF8 | ConvertFrom-Json

  $ia = @{}; foreach ($c in $sa.Controles) { $ia[$c.Key] = $c }
  $ib = @{}; foreach ($c in $sb.Controles) { $ib[$c.Key] = $c }

  $achados = New-Object System.Collections.ArrayList

  foreach ($k in $ia.Keys) {
    if (-not $ib.ContainsKey($k)) {
      [void]$achados.Add([pscustomobject]@{ Passo=$nome; Tipo='ESTRUTURA'; Chave=$k
        Detalhe="existe so em $A"; ValorA=$ia[$k].Text; ValorB='' })
      continue
    }
    $ca = $ia[$k]; $cb = $ib[$k]
    $na = Normalizar $ca.Text
    $nb = Normalizar $cb.Text
    if ($na -ne $nb) {
      [void]$achados.Add([pscustomobject]@{ Passo=$nome; Tipo='VALOR'; Chave=$k
        Detalhe="texto diferente"; ValorA=$ca.Text; ValorB=$cb.Text })
    }
    elseif ($ca.Enabled -ne $cb.Enabled -or $ca.Visible -ne $cb.Visible) {
      [void]$achados.Add([pscustomobject]@{ Passo=$nome; Tipo='ESTADO'; Chave=$k
        Detalhe=("enabled {0}/{1}  visible {2}/{3}" -f $ca.Enabled,$cb.Enabled,$ca.Visible,$cb.Visible)
        ValorA=$ca.Text; ValorB=$cb.Text })
    }
  }
  foreach ($k in $ib.Keys) {
    if (-not $ia.ContainsKey($k)) {
      [void]$achados.Add([pscustomobject]@{ Passo=$nome; Tipo='ESTRUTURA'; Chave=$k
        Detalhe="existe so em $B"; ValorA=''; ValorB=$ib[$k].Text })
    }
  }
  return $achados
}

# ---------------------------------------------------------------------------

$todos = New-Object System.Collections.ArrayList
$snapsA = Get-ChildItem $dirA -Filter *.json | Sort-Object Name

foreach ($fa in $snapsA) {
  $fb = Join-Path $dirB $fa.Name
  if (-not (Test-Path $fb)) {
    [void]$todos.Add([pscustomobject]@{ Passo=$fa.BaseName; Tipo='ESTRUTURA'; Chave='(snapshot)'
      Detalhe="passo nao existe em $B"; ValorA=''; ValorB='' })
    continue
  }
  foreach ($d in (Compare-SnapshotPar $fa.FullName $fb $fa.BaseName)) { [void]$todos.Add($d) }
}

if ($IgnorarEstrutura) { $todos = @($todos | Where-Object { $_.Tipo -ne 'ESTRUTURA' }) }

$nVal = @($todos | Where-Object Tipo -eq 'VALOR').Count
$nEst = @($todos | Where-Object Tipo -eq 'ESTADO').Count
$nStr = @($todos | Where-Object Tipo -eq 'ESTRUTURA').Count

Write-Output ""
Write-Output "=== $Roteiro : $A x $B ==="
Write-Output ("  VALOR     {0,4}   <- diferenca de dado; investigar" -f $nVal)
Write-Output ("  ESTADO    {0,4}   <- enabled/visible diferente" -f $nEst)
Write-Output ("  ESTRUTURA {0,4}   <- controle so de um lado; normalmente esperado" -f $nStr)
Write-Output ""

foreach ($d in ($todos | Where-Object { $_.Tipo -in @('VALOR','ESTADO') } | Select-Object -First 40)) {
  Write-Output ("  [{0}] {1} :: {2}" -f $d.Tipo, $d.Passo, $d.Chave)
  Write-Output ("        {0,-8} '{1}'" -f $A, $d.ValorA)
  Write-Output ("        {0,-8} '{1}'" -f $B, $d.ValorB)
  if ($d.Detalhe -ne 'texto diferente') { Write-Output ("        {0}" -f $d.Detalhe) }
}

# ---------------------------------------------------------------------------
# Relatorio HTML com as telas lado a lado
# ---------------------------------------------------------------------------

$css = @"
body{font:13px/1.5 Segoe UI,system-ui,sans-serif;margin:24px;color:#1F2937;background:#FAFBFC}
h1{font-size:20px;margin:0 0 4px} h2{font-size:15px;margin:28px 0 8px;color:#374151}
.resumo{display:flex;gap:12px;margin:16px 0}
.card{border:1px solid #E5E7EB;border-radius:8px;padding:10px 16px;background:#fff}
.card b{display:block;font-size:22px}
.VALOR{border-left:4px solid #DC2626} .ESTADO{border-left:4px solid #D97706}
.ESTRUTURA{border-left:4px solid #9CA3AF}
table{border-collapse:collapse;width:100%;background:#fff;margin-bottom:10px}
th,td{border:1px solid #E5E7EB;padding:6px 9px;text-align:left;vertical-align:top;font-size:12px}
th{background:#F3F4F6;font-weight:600}
code{font-family:Consolas,monospace;background:#F3F4F6;padding:1px 4px;border-radius:3px}
.telas{display:flex;gap:14px;flex-wrap:wrap}
.tela{border:1px solid #E5E7EB;border-radius:6px;padding:8px;background:#fff}
.tela img{max-width:520px;display:block;border:1px solid #E5E7EB}
.tela span{font-size:11px;color:#6B7280}
"@

$html = New-Object System.Text.StringBuilder
[void]$html.Append("<!doctype html><html lang='pt-BR'><meta charset='utf-8'><title>Regressao $Roteiro</title><style>$css</style>")
[void]$html.Append("<h1>Regress&atilde;o: $Roteiro</h1><div>$A &times; $B &mdash; $(Get-Date -Format 'dd/MM/yyyy HH:mm')</div>")
[void]$html.Append("<div class='resumo'>")
[void]$html.Append("<div class='card VALOR'><b>$nVal</b>valor</div>")
[void]$html.Append("<div class='card ESTADO'><b>$nEst</b>estado</div>")
[void]$html.Append("<div class='card ESTRUTURA'><b>$nStr</b>estrutura</div></div>")

foreach ($tipo in @('VALOR','ESTADO','ESTRUTURA')) {
  $itens = @($todos | Where-Object Tipo -eq $tipo)
  if ($itens.Count -eq 0) { continue }
  [void]$html.Append("<h2>$tipo ($($itens.Count))</h2><table><tr><th>Passo</th><th>Controle</th><th>$A</th><th>$B</th><th>Obs</th></tr>")
  foreach ($d in $itens) {
    [void]$html.Append("<tr class='$tipo'><td>$($d.Passo)</td><td><code>$($d.Chave)</code></td>")
    [void]$html.Append("<td>$([System.Net.WebUtility]::HtmlEncode("$($d.ValorA)"))</td>")
    [void]$html.Append("<td>$([System.Net.WebUtility]::HtmlEncode("$($d.ValorB)"))</td>")
    [void]$html.Append("<td>$([System.Net.WebUtility]::HtmlEncode("$($d.Detalhe)"))</td></tr>")
  }
  [void]$html.Append("</table>")
}

[void]$html.Append("<h2>Telas capturadas</h2>")
foreach ($fa in $snapsA) {
  $pngA = Join-Path $dirA ($fa.BaseName + ".png")
  $pngB = Join-Path $dirB ($fa.BaseName + ".png")
  if (-not (Test-Path $pngA)) { continue }
  [void]$html.Append("<h3 style='font-size:13px;margin:18px 0 6px'>$($fa.BaseName)</h3><div class='telas'>")
  [void]$html.Append("<div class='tela'><span>$A</span><img src='$([Uri]::EscapeUriString($pngA))'></div>")
  if (Test-Path $pngB) { [void]$html.Append("<div class='tela'><span>$B</span><img src='$([Uri]::EscapeUriString($pngB))'></div>") }
  [void]$html.Append("</div>")
}
[void]$html.Append("</html>")

$saidaHtml = Join-Path $SaidaRaiz "$Roteiro\relatorio-$A-x-$B.html"
$html.ToString() | Set-Content $saidaHtml -Encoding UTF8
$todos | Export-Csv (Join-Path $SaidaRaiz "$Roteiro\diferencas.csv") -NoTypeInformation -Encoding UTF8

Write-Output ""
Write-Output "relatorio: $saidaHtml"
