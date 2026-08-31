/*
  mapear-dfm.js

  Le um .dfm do Delphi e produz o mapa de controles com a POSICAO NA TELA,
  no mesmo formato de chave que o harness usa ("TEdit@17,88").

  Serve para escrever roteiro sem precisar rodar o sistema antes: o DFM ja tem
  tudo, basta somar os offsets.

  FORMULA (calibrada contra um snapshot real do ULogin)

      posicao na tela = soma dos Left/Top de todos os ancestrais + (8, 31)

    Os 8 e 31 sao a borda lateral e a barra de titulo de um form bsSizeable /
    bsSingle em 96 DPI. Conferido em tres controles:

      ELogin    DFM(10,20)                 -> 18,51   (snapshot: 18,51)
      ESenha    DFM(9,57)                  -> 17,88   (snapshot: 17,88)
      BTEntrar  DFM(14,20)+GroupBox(8,92)  -> 30,143  (snapshot: 30,143)

  USO
      node mapear-dfm.js <arquivo.dfm> [--json]
      node mapear-dfm.js C:/Amortrat/code/UOS.dfm
      node mapear-dfm.js C:/Amortrat/code/UOS.dfm --so-visiveis
*/

const fs = require('fs');

// Componentes que NAO ocupam lugar na tela: tem Left/Top no DFM (posicao do
// icone no designer) mas nenhum pixel em runtime. Precisam ficar de fora ou
// bagunçam o calculo dos filhos.
const NAO_VISUAIS = new Set([
  'TZQuery','TZTable','TZConnection','TRxQuery','TQuery','TTable','TDataSource',
  'TTimer','TImageList','TOpenDialog','TSaveDialog','TPrintDialog','TPopupMenu',
  'TMainMenu','TBcBarMainMenu','TMenuItem','TActionList','TAction','TTabEnter',
  'TIdHTTP','TIdSMTP','TIdMessage','TIdSSLIOHandlerSocketOpenSSL','TXBaloon',
  'TACBrNFe','TACBrMail','TACBrNFeDANFeRL','TRLReport','TscExcelExport',
  'TAdvTaskDialog','TRLPDFFilter','TRLHTMLFilter','TRLXLSFilter','TRLRichFilter',
  'TIdServerIOHandler','TVrClock'
]);

// Controles SEM handle de janela (TGraphicControl): existem na tela mas sao
// invisiveis para a API do Windows - o harness nao consegue le-los.
const SEM_HANDLE = new Set([
  'TLabel','TImage','TShape','TSpeedButton','TBevel','TPaintBox','TVrLabel',
  'TRLLabel','TRLDraw','TRLMemo','TRLImage','TDBText'
]);

function mapear(caminho) {
  const linhas = fs.readFileSync(caminho, 'latin1').split(/\r?\n/);
  const pilha = [];          // ancestrais: {nome, classe, left, top, visual}
  const saida = [];
  let atual = null;

  for (const linha of linhas) {
    const t = linha.trim();

    const mObj = t.match(/^object\s+([A-Za-z_0-9]+):\s*([A-Za-z_0-9]+)\s*$/);
    if (mObj) {
      atual = { nome: mObj[1], classe: mObj[2], left: 0, top: 0,
                temLeft: false, temTop: false };
      pilha.push(atual);
      continue;
    }

    if (t === 'end' || t === 'end>') {
      const fim = pilha.pop();
      if (fim) registrar(fim, pilha, saida);
      atual = pilha.length ? pilha[pilha.length - 1] : null;
      continue;
    }

    if (!atual) continue;
    const mL = t.match(/^Left\s*=\s*(-?\d+)\s*$/);
    if (mL && !atual.temLeft) { atual.left = parseInt(mL[1], 10); atual.temLeft = true; continue; }
    const mT = t.match(/^Top\s*=\s*(-?\d+)\s*$/);
    if (mT && !atual.temTop)  { atual.top  = parseInt(mT[1], 10); atual.temTop  = true; }
  }
  // o form (raiz) sobra na pilha
  while (pilha.length) registrar(pilha.pop(), pilha, saida);
  return saida;
}

function registrar(comp, ancestrais, saida) {
  if (NAO_VISUAIS.has(comp.classe)) return;
  if (ancestrais.length === 0) return;          // o proprio form

  // soma os offsets dos ancestrais VISUAIS (pula o form, indice 0)
  let ax = 0, ay = 0;
  for (let i = 1; i < ancestrais.length; i++) {
    const a = ancestrais[i];
    if (NAO_VISUAIS.has(a.classe)) return;      // filho de nao-visual: ignorar
    ax += a.left; ay += a.top;
  }

  const x = comp.left + ax + 8;                 // borda lateral
  const y = comp.top  + ay + 31;                // barra de titulo

  saida.push({
    nome: comp.nome,
    classe: comp.classe,
    chave: `${comp.classe}@${x},${y}`,
    pos: `${x},${y}`,
    temHandle: !SEM_HANDLE.has(comp.classe),
    caminho: ancestrais.slice(1).map(a => a.nome).join(' > ')
  });
}

// ---------------------------------------------------------------------------

const arq = process.argv[2];
if (!arq) { console.log('uso: node mapear-dfm.js <arquivo.dfm> [--json] [--so-visiveis]'); process.exit(1); }

let r = mapear(arq);
if (process.argv.includes('--so-visiveis')) r = r.filter(c => c.temHandle);
r.sort((a, b) => a.nome.localeCompare(b.nome));

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(r, null, 2));
} else {
  const comH = r.filter(c => c.temHandle).length;
  console.log(`${arq}`);
  console.log(`${r.length} controles visuais - ${comH} com handle (legiveis pelo harness)\n`);
  console.log('  NOME                      CLASSE                 CHAVE / pos          H  DENTRO DE');
  console.log('  ' + '-'.repeat(96));
  for (const c of r) {
    console.log('  ' +
      c.nome.padEnd(26).slice(0, 26) +
      c.classe.padEnd(23).slice(0, 23) +
      c.pos.padEnd(21) +
      (c.temHandle ? 'S  ' : '-  ') +
      c.caminho);
  }
}
