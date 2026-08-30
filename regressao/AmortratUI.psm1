# AmortratUI.psm1
#
# Camada de automacao para dirigir o amortrat.exe (VCL/Delphi 2010, Win32) e
# capturar o estado da tela, de forma identica nas duas versoes (Paradox e
# MySQL), para comparacao posterior.
#
# COMO ISSO FUNCIONA
#
# O VCL registra as window classes com o nome do componente: um TEdit vira uma
# janela de classe "TEdit", um TIAeverButton vira "TIAeverButton" (ele herda de
# TButton, entao tem handle). Isso permite localizar controles sem depender de
# ferramenta comercial.
#
# LIMITE IMPORTANTE: TLabel, TImage, TShape e TSpeedButton descendem de
# TGraphicControl e NAO possuem handle - sao desenhados no canvas do pai e sao
# invisiveis para a API do Windows. O texto deles so pode ser comparado por
# imagem (por isso todo snapshot tambem grava um PNG).
#
# IDENTIFICACAO DOS CONTROLES
#
# A API nao expoe o Name do componente Delphi. A chave usada e
# "<classe>@<left>,<top>" relativa ao form, que e estavel entre as duas versoes
# desde que o DFM nao tenha mudado de layout. Onde mudou (TRxLookupEdit ->
# TComboBox, por exemplo) o comparador reporta como diferenca ESTRUTURAL, em
# separado das diferencas de VALOR.

Set-StrictMode -Version Latest

Add-Type -TypeDefinition @"
using System;
using System.Text;
using System.Drawing;
using System.Runtime.InteropServices;

public class AUI {
  public delegate bool EnumProc(IntPtr h, IntPtr l);

  [DllImport("user32")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32")] public static extern bool EnumChildWindows(IntPtr p, EnumProc cb, IntPtr l);
  [DllImport("user32", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32", CharSet=CharSet.Unicode)] public static extern int GetWindowTextW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32")] public static extern bool GetClientRect(IntPtr h, out RECT r);
  [DllImport("user32")] public static extern bool ScreenToClient(IntPtr h, ref POINT p);
  [DllImport("user32", CharSet=CharSet.Unicode)] public static extern IntPtr SendMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  // Mesma API, sobrecarga com string no lParam (WM_SETTEXT, CB_FINDSTRINGEXACT).
  // EntryPoint e obrigatorio: 'SendMessageStr' nao existe em user32.
  [DllImport("user32", EntryPoint="SendMessageW", CharSet=CharSet.Unicode)]
  public static extern IntPtr SendMessageStr(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32")] public static extern IntPtr PostMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32")] public static extern IntPtr SetFocus(IntPtr h);
  [DllImport("user32")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
  [DllImport("user32")] public static extern IntPtr GetDC(IntPtr h);
  [DllImport("user32")] public static extern int ReleaseDC(IntPtr h, IntPtr dc);
  [DllImport("user32")] public static extern bool AttachThreadInput(uint from, uint to, bool attach);
  [DllImport("kernel32")] public static extern uint GetCurrentThreadId();
  [DllImport("user32")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32")] public static extern bool IsHungAppWindow(IntPtr h);
  [DllImport("user32")] public static extern IntPtr SendMessageTimeoutW(IntPtr h, uint m, IntPtr w, IntPtr l, uint flags, uint ms, out IntPtr res);

  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
  [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }

  public static string Cls(IntPtr h){ var s=new StringBuilder(256); GetClassName(h,s,256); return s.ToString(); }
  public static string Txt(IntPtr h){
    // WM_GETTEXT com timeout: se a janela estiver ocupada nao trava o harness
    IntPtr len;
    if (SendMessageTimeoutW(h, 0x000E /*WM_GETTEXTLENGTH*/, IntPtr.Zero, IntPtr.Zero, 0x2 /*ABORTIFHUNG*/, 1000, out len) == IntPtr.Zero)
      return null;
    int n = len.ToInt32();
    if (n <= 0) return "";
    var sb = new StringBuilder(n + 2);
    GetWindowTextW(h, sb, n + 2);
    return sb.ToString();
  }
}
"@ -ReferencedAssemblies System.Drawing -ErrorAction SilentlyContinue

# ---------------------------------------------------------------------------
# Descoberta de janelas
# ---------------------------------------------------------------------------

function Get-AmortratWindows {
  <#  Lista as janelas de topo visiveis de um processo.

      NOTA: o scriptblock passado como delegate roda em outro escopo e nao
      enxerga variaveis locais desta funcao - por isso o PID e a lista de saida
      passam por $script:.  #>
  param([Parameter(Mandatory)][int]$ProcessId)

  $script:_pidAlvo = $ProcessId
  $script:_janelas = New-Object System.Collections.ArrayList

  $cb = [AUI+EnumProc]{
    param($h, $l)
    $owner = 0
    [void][AUI]::GetWindowThreadProcessId($h, [ref]$owner)
    if ($owner -eq $script:_pidAlvo -and [AUI]::IsWindowVisible($h)) {
      $r = New-Object AUI+RECT
      [void][AUI]::GetWindowRect($h, [ref]$r)
      [void]$script:_janelas.Add([pscustomobject]@{
        Handle = $h
        Class  = [AUI]::Cls($h)
        Title  = [AUI]::Txt($h)
        Left   = $r.Left;  Top    = $r.Top
        Width  = $r.Right - $r.Left
        Height = $r.Bottom - $r.Top
      })
    }
    return $true
  }
  [void][AUI]::EnumWindows($cb, [IntPtr]::Zero)
  return $script:_janelas.ToArray()
}

function Wait-AmortratWindow {
  <#  Espera uma janela existir E responder.

      Nao usa sleep fixo: verifica a condicao em intervalos curtos ate o
      timeout. Tambem confirma que a janela nao esta "hung" (o Delphi costuma
      exibir o form antes de terminar a carga dos dados).  #>
  param(
    [Parameter(Mandatory)][int]$ProcessId,
    [string]$TitleLike,
    [string]$ClassName,
    [int]$TimeoutSeg = 30
  )
  $fim = (Get-Date).AddSeconds($TimeoutSeg)
  while ((Get-Date) -lt $fim) {
    foreach ($w in Get-AmortratWindows -ProcessId $ProcessId) {
      $okT = (-not $TitleLike) -or ($w.Title -like $TitleLike)
      $okC = (-not $ClassName) -or ($w.Class -eq $ClassName)
      if ($okT -and $okC -and -not [AUI]::IsHungAppWindow($w.Handle)) { return $w }
    }
    Start-Sleep -Milliseconds 200
  }
  return $null
}

function Wait-AmortratIdle {
  <#  Espera a janela voltar a responder (fim de uma query, por exemplo).  #>
  param([Parameter(Mandatory)][IntPtr]$Handle, [int]$TimeoutSeg = 60)
  $fim = (Get-Date).AddSeconds($TimeoutSeg)
  while ((Get-Date) -lt $fim) {
    $r = [IntPtr]::Zero
    $ok = [AUI]::SendMessageTimeoutW($Handle, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero, 0x2, 500, [ref]$r)
    if ($ok -ne [IntPtr]::Zero -and -not [AUI]::IsHungAppWindow($Handle)) { return $true }
    Start-Sleep -Milliseconds 150
  }
  return $false
}

# ---------------------------------------------------------------------------
# Inventario de controles
# ---------------------------------------------------------------------------

function Get-ControlTree {
  <#  Enumera recursivamente os controles COM HANDLE de uma janela.

      Devolve, para cada um: classe, texto, posicao relativa ao form, tamanho,
      enabled, visible e a profundidade na hierarquia. TLabel/TImage/TShape nao
      aparecem aqui (sao TGraphicControl, sem janela) - por isso o snapshot
      tambem grava PNG.  #>
  param([Parameter(Mandatory)][IntPtr]$Root)

  $rr = New-Object AUI+RECT
  [void][AUI]::GetWindowRect($Root, [ref]$rr)
  $script:_rootL = $rr.Left
  $script:_rootT = $rr.Top
  $script:_arvore = New-Object System.Collections.ArrayList

  # Enumera em UMA passada (EnumChildWindows ja e recursivo) e reconstroi o
  # nivel subindo por GetParent. Evita recursao com delegate, que em PowerShell
  # embaralha escopo.
  $script:_handles = New-Object System.Collections.ArrayList
  $cb = [AUI+EnumProc]{ param($h,$l); [void]$script:_handles.Add($h); return $true }
  [void][AUI]::EnumChildWindows($Root, $cb, [IntPtr]::Zero)

  foreach ($h in $script:_handles) {
    $r = New-Object AUI+RECT
    [void][AUI]::GetWindowRect($h, [ref]$r)

    $nivel = 0
    $p = [AUI]::GetParent($h)
    while ($p -ne [IntPtr]::Zero -and $p -ne $Root -and $nivel -lt 32) {
      $nivel++
      $p = [AUI]::GetParent($p)
    }

    [void]$script:_arvore.Add([pscustomobject]@{
      Handle  = $h
      Nivel   = $nivel
      Class   = [AUI]::Cls($h)
      Text    = [AUI]::Txt($h)
      Left    = $r.Left - $script:_rootL
      Top     = $r.Top  - $script:_rootT
      Width   = $r.Right - $r.Left
      Height  = $r.Bottom - $r.Top
      Enabled = [AUI]::IsWindowEnabled($h)
      Visible = [AUI]::IsWindowVisible($h)
      CtrlId  = [AUI]::GetDlgCtrlID($h)
    })
  }
  return $script:_arvore.ToArray()
}

function Get-ControlKey {
  <#  Chave estavel de um controle: classe + posicao no form.  #>
  param([Parameter(Mandatory)]$Control)
  return ("{0}@{1},{2}" -f $Control.Class, $Control.Left, $Control.Top)
}

function Find-Control {
  <#  Localiza um controle por chave, por POSICAO, ou por classe + indice.

      A busca por posicao ("18,51") existe para os casos em que a migracao
      trocou o componente mas manteve o lugar na tela: o ELogin, por exemplo, e
      TRxLookupEdit no Paradox e TComboBox no MySQL, ambos em 18,51. Um seletor
      por classe teria de ser diferente para cada versao, o que quebraria a
      premissa de rodar o MESMO roteiro nos dois.

      Tolerancia de +-2 px absorve diferenca de borda entre os componentes.  #>
  param(
    [Parameter(Mandatory)]$Tree,
    [string]$Key,
    [string]$Pos,
    [string]$Class,
    [int]$Index = 0,
    [string]$TextLike
  )
  if ($Key) {
    foreach ($c in $Tree) { if ((Get-ControlKey $c) -eq $Key) { return $c } }
    return $null
  }
  if ($Pos) {
    $p = $Pos -split ','
    $L = [int]$p[0]; $T = [int]$p[1]
    $cand = @($Tree | Where-Object {
      [Math]::Abs($_.Left - $L) -le 2 -and [Math]::Abs($_.Top - $T) -le 2 -and
      (-not $Class -or $_.Class -eq $Class)
    })
    if ($cand.Count -gt 0) { return $cand[0] }
    return $null
  }
  $cand = @($Tree | Where-Object { (-not $Class -or $_.Class -eq $Class) -and
                                  (-not $TextLike -or $_.Text -like $TextLike) })
  if ($cand.Count -gt $Index) { return $cand[$Index] }
  return $null
}

# ---------------------------------------------------------------------------
# Acoes
# ---------------------------------------------------------------------------

$script:WM_SETTEXT   = 0x000C
$script:WM_CHAR      = 0x0102
$script:BM_CLICK     = 0x00F5
$script:CB_SETCURSEL = 0x014E
$script:CB_FINDSTRINGEXACT = 0x0158
$script:CB_GETCOUNT  = 0x0146

function Set-ControlText {
  <#  Escreve num TEdit/TMaskEdit/TMemo.

      Usa WM_SETTEXT (direto) e depois um WM_CHAR neutro para disparar o
      OnChange do VCL - varios campos do sistema so recalculam no OnChange
      (ECliente -> EFantasia, por exemplo).  #>
  param([Parameter(Mandatory)][IntPtr]$Handle, [Parameter(Mandatory)][AllowEmptyString()][string]$Text)
  [void][AUI]::SendMessageStr($Handle, $script:WM_SETTEXT, [IntPtr]::Zero, $Text)
  [void][AUI]::SendMessageW($Handle, 0x0007, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_SETFOCUS
  Start-Sleep -Milliseconds 60
}

function Invoke-ControlClick {
  param([Parameter(Mandatory)][IntPtr]$Handle)
  [void][AUI]::SendMessageW($Handle, $script:BM_CLICK, [IntPtr]::Zero, [IntPtr]::Zero)
}

function Select-ComboItem {
  param([Parameter(Mandatory)][IntPtr]$Handle, [Parameter(Mandatory)][string]$Item)
  $idx = [AUI]::SendMessageStr($Handle, $script:CB_FINDSTRINGEXACT, [IntPtr](-1), $Item)
  if ($idx.ToInt32() -ge 0) {
    [void][AUI]::SendMessageW($Handle, $script:CB_SETCURSEL, [IntPtr]$idx.ToInt32(), [IntPtr]::Zero)
    return $true
  }
  return $false
}

# ---------------------------------------------------------------------------
# Captura
# ---------------------------------------------------------------------------

function Save-WindowImage {
  <#  PNG da janela. PrintWindow captura mesmo com a janela parcialmente
      encoberta, o que evita depender de trazer para frente.  #>
  param([Parameter(Mandatory)][IntPtr]$Handle, [Parameter(Mandatory)][string]$Path)

  $r = New-Object AUI+RECT
  [void][AUI]::GetWindowRect($Handle, [ref]$r)
  $w = $r.Right - $r.Left; $h = $r.Bottom - $r.Top
  if ($w -le 0 -or $h -le 0) { return $false }

  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $hdc = $g.GetHdc()
  $ok  = [AUI]::PrintWindow($Handle, $hdc, 2)   # 2 = PW_RENDERFULLCONTENT
  $g.ReleaseHdc($hdc); $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  return $ok
}

function New-Snapshot {
  <#  Grava o estado da janela: JSON com a arvore de controles + PNG.  #>
  param(
    [Parameter(Mandatory)][IntPtr]$Handle,
    [Parameter(Mandatory)][string]$Dir,
    [Parameter(Mandatory)][string]$Nome
  )
  if (-not (Test-Path $Dir)) { New-Item -ItemType Directory -Force -Path $Dir | Out-Null }

  $tree = Get-ControlTree -Root $Handle
  $dados = [pscustomobject]@{
    Nome      = $Nome
    Quando    = (Get-Date).ToString("s")
    Janela    = [pscustomobject]@{ Class = [AUI]::Cls($Handle); Title = [AUI]::Txt($Handle) }
    Controles = @($tree | ForEach-Object {
      [pscustomobject]@{
        Key     = Get-ControlKey $_
        Class   = $_.Class
        Text    = $_.Text
        Left    = $_.Left;  Top = $_.Top
        Width   = $_.Width; Height = $_.Height
        Enabled = $_.Enabled
        Visible = $_.Visible
        Nivel   = $_.Nivel
      }
    })
  }
  $dados | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $Dir "$Nome.json") -Encoding UTF8
  [void](Save-WindowImage -Handle $Handle -Path (Join-Path $Dir "$Nome.png"))
  return $dados
}

Export-ModuleMember -Function Get-AmortratWindows, Wait-AmortratWindow, Wait-AmortratIdle,
  Get-ControlTree, Get-ControlKey, Find-Control, Set-ControlText, Invoke-ControlClick,
  Select-ComboItem, Save-WindowImage, New-Snapshot
