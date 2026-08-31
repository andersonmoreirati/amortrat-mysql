/*
  validar-roteiro.js

  Confere se todo seletor "pos" de um roteiro corresponde a um controle real,
  cruzando com o mapa extraido do DFM (mapear-dfm.js). Pega erro de digitacao e
  seletor apontando para lugar vazio ANTES de rodar o sistema.

  Avisa tambem quando o alvo e um controle SEM HANDLE (TLabel, TImage...), que
  o harness nao consegue acionar nem ler.

  uso: node validar-roteiro.js roteiros/10-ciclo-completo.json
*/

const fs = require('fs');
const cp = require('child_process');

const arq = process.argv[2];
if (!arq) { console.log('uso: node validar-roteiro.js <roteiro.json>'); process.exit(1); }

const rot = JSON.parse(fs.readFileSync(arq, 'utf8'));

// classe da janela -> unit do DFM
const DFM = {
  TFProcessos: 'UProcessos', TFClientes: 'Uclientes', TFPecas: 'UPecas',
  TFOs: 'UOS', TFLogin: 'ULogin', TFPrincipal: 'principal',
  TFRelatCQ: 'URelatCQ', TFGerRelat: 'UGerrelat', TFNf: 'UNf',
  TFUsuarios: 'UUsuarios', TFReajuste: 'UReajuste', TFLocalizar: 'ULocalizar'
};

const cache = {};
function mapa(cls) {
  if (!DFM[cls]) return null;
  if (!cache[cls]) {
    const out = cp.execSync(
      `node mapear-dfm.js "C:/Amortrat/mysql/code/${DFM[cls]}.dfm" --json`,
      { encoding: 'utf8' });
    cache[cls] = JSON.parse(out);
  }
  return cache[cls];
}

let janela = null, ok = 0, erro = 0, aviso = 0;

for (const p of rot.passos) {
  if (p._etapa) continue;
  if (p.acao === 'aguardar-janela') { janela = p.classe; continue; }
  if (!p.pos) continue;

  const m = mapa(janela);
  if (!m) {
    console.log(`  ?    ${janela || '(sem janela)'} pos=${p.pos} - unit nao mapeada`);
    aviso++; continue;
  }
  const [x, y] = p.pos.split(',').map(Number);
  const hit = m.find(c => {
    const [cx, cy] = c.pos.split(',').map(Number);
    return Math.abs(cx - x) <= 2 && Math.abs(cy - y) <= 2;
  });

  if (hit) {
    ok++;
    const alerta = hit.temHandle ? '' : '   *** SEM HANDLE - o harness nao alcanca ***';
    console.log(`  OK   ${janela.padEnd(13)} ${p.pos.padEnd(9)} -> ${hit.nome} (${hit.classe})${alerta}`);
    if (!hit.temHandle) aviso++;
  } else {
    erro++;
    console.log(`  ERRO ${janela.padEnd(13)} ${p.pos.padEnd(9)} -> nenhum controle nessa posicao`);
  }
}

// --- variaveis do roteiro -------------------------------------------------
// Um $VAR usado antes de ser guardado seria escrito literalmente no campo,
// sem erro visivel - o cadastro sairia com "$NOVO_PROC" no lugar do codigo.
{
  const def = new Set(['USUARIO', 'SENHA']);
  const usos = [];
  for (const p of rot.passos) {
    if (p.acao === 'guardar' && p.var) def.add(p.var);
    const txt = (p.valor || '') + ' ' + (p.esperado || '');
    const re = /\$([A-Z_][A-Z0-9_]*)/g;
    let m;
    while ((m = re.exec(txt)) !== null) usos.push(m[1]);
  }
  const faltam = [...new Set(usos.filter(u => !def.has(u)))];
  const ociosas = [...def].filter(d => !usos.includes(d));

  console.log('\n  variaveis definidas: ' + [...def].sort().join(', '));
  if (faltam.length)  { console.log('  ERRO usadas sem guardar: ' + faltam.join(', ')); process.exit(1); }
  if (ociosas.length) { console.log('  aviso guardadas sem uso: ' + ociosas.join(', ')); }
  console.log('  variaveis: ok');
}

console.log(`\n  ${ok} seletor(es) confirmado(s), ${erro} sem correspondencia, ${aviso} aviso(s)`);
process.exit(erro > 0 ? 1 : 0);
