program tbcrypt;
{$APPTYPE CONSOLE}
{ Valida a unit UBCrypt contra os vetores de teste oficiais do OpenBSD/jBCrypt.
  Se algum vetor falhar, a implementacao esta errada e NAO deve ser usada. }
uses SysUtils, UBCrypt;

function MarcaOk(b: Boolean): string;
begin
  if b then Result := '[OK]' else Result := '[XX]';
end;


type
  TVetor = record
    senha: string;
    hash:  string;
  end;

const
  // Vetores canonicos do jBCrypt / OpenBSD (senha, hash esperado)
  VETORES: array[0..16] of TVetor = (
    (senha: '';                           hash: '$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s.'),
    (senha: '';                           hash: '$2a$08$HqWuK6/Ng6sg9gQzbLrgb.Tl.ZHfXLhvt/SgVyWhQqgqcZ7ZuUtye'),
    (senha: '';                           hash: '$2a$10$k1wbIrmNyFAPwPVPSVa/zecw2BCEnBwVS2GbrmgzxFUOqW9dk4TCW'),
    (senha: 'a';                          hash: '$2a$06$m0CrhHm10qJ3lXRY.5zDGO3rS2KdeeWLuGmsfGlMfOxih58VYVfxe'),
    (senha: 'a';                          hash: '$2a$08$cfcvVd2aQ8CMvoMpP2EBfeodLEkkFJ9umNEfPD18.hUF62qqlC/V.'),
    (senha: 'a';                          hash: '$2a$10$k87L/MF28Q673VKh8/cPi.SUl7MU/rWuSiIDDFayrKk/1tBsSQu4u'),
    (senha: 'abc';                        hash: '$2a$06$If6bvum7DFjUnE9p2uDeDu0YHzrHM6tf.iqN8.yx.jNN1ILEf7h0i'),
    (senha: 'abc';                        hash: '$2a$08$Ro0CUfOqk6cXEKf3dyaM7OhSCvnwM9s4wIX9JeLapehKK5YdLxKcm'),
    (senha: 'abc';                        hash: '$2a$10$WvvTPHKwdBJ3uk0Z37EMR.hLA2W6N9AEBhEgrAOljy2Ae5MtaSIUi'),
    (senha: 'abcdefghijklmnopqrstuvwxyz'; hash: '$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC'),
    (senha: 'abcdefghijklmnopqrstuvwxyz'; hash: '$2a$08$aTsUwsyowQuzRrDqFflhgekJ8d9/7Z3GV3UcgvzQW3J5zMyrTvlz.'),
    (senha: 'abcdefghijklmnopqrstuvwxyz'; hash: '$2a$10$fVH8e28OQRj9tqiDXs1e1uxpsjN0c7II7YPKXua2NAKYvM6iQk7dq'),
    (senha: '~!@#$%^&*()      ~!@#$%^&*()PNBFRD'; hash: '$2a$06$fPIsBO8qRqkjj273rfaOI.HtSV9jLDpTbZn782DC6/t7qT67P6FfO'),
    (senha: '~!@#$%^&*()      ~!@#$%^&*()PNBFRD'; hash: '$2a$08$Eq2r4G/76Wv39MzSX262huzPz612MZiYHVUJe/OcOql2jo4.9UxTW'),
    (senha: '~!@#$%^&*()      ~!@#$%^&*()PNBFRD'; hash: '$2a$10$LgfYWkbzEvQ4JakH7rOvHe0y8pHKF9OaFgwUZ2q7W2FFZmZzJYlfS'),
    // cost 12 (mais lento, confirma que o loop 2^cost esta certo)
    (senha: '';                           hash: '$2a$12$k42ZFHFWqBp3vWli.nIn8uYyIkbvYRvodzbfbK18SSsY.CsIQPlxO'),
    (senha: 'a';                          hash: '$2a$12$8NJH3LsPrANStV6XtBakCez0cKHXVxmvxIlcz785vxAIZrihHZpeS')
  );

var
  i, ok, falhou: Integer;
  r: Boolean;
  novo: string;
begin
  ok := 0; falhou := 0;
  WriteLn('=== VETORES OFICIAIS OpenBSD/jBCrypt (verificacao) ===');
  WriteLn('');
  for i := Low(VETORES) to High(VETORES) do
  begin
    r := BCryptCheckPassword(VETORES[i].senha, VETORES[i].hash);
    if r then Inc(ok) else Inc(falhou);
    WriteLn(Format('%-3s cost=%s senha=%-36s %s',
      [ MarcaOk(r),
        Copy(VETORES[i].hash,5,2),
        '"'+VETORES[i].senha+'"',
        Copy(VETORES[i].hash,1,32)+'...' ]));
  end;
  WriteLn('');
  WriteLn(Format('RESULTADO: %d passaram, %d falharam', [ok, falhou]));
  WriteLn('');

  WriteLn('=== senha ERRADA deve ser rejeitada ===');
  WriteLn('check("xyz", hash_de_abc) = ',
    BoolToStr(BCryptCheckPassword('xyz', '$2a$06$If6bvum7DFjUnE9p2uDeDu0YHzrHM6tf.iqN8.yx.jNN1ILEf7h0i'), True));
  WriteLn('');

  WriteLn('=== round-trip: gerar e validar ===');
  novo := BCryptHashPassword('SenhaDoAmortrat123', 10);
  WriteLn('hash gerado : ', novo);
  WriteLn('tamanho     : ', Length(novo), ' (deve ser 60)');
  WriteLn('valida certo: ', BoolToStr(BCryptCheckPassword('SenhaDoAmortrat123', novo), True));
  WriteLn('rejeita erro: ', BoolToStr(BCryptCheckPassword('SenhaErrada', novo), True));
  WriteLn('');
  WriteLn('=== salt aleatorio: dois hashes da MESMA senha diferem ===');
  WriteLn('h1 = ', BCryptHashPassword('igual', 6));
  WriteLn('h2 = ', BCryptHashPassword('igual', 6));

  if falhou > 0 then
  begin
    WriteLn('');
    WriteLn('*** IMPLEMENTACAO REPROVADA — NAO USAR ***');
    ExitCode := 1;
  end;
end.
