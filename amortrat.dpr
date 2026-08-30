{$OPTIMIZATION ON}
program amortrat;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Messages,
  UModulo in 'UModulo.pas' {Modulo: TDataModule},
  principal in 'principal.pas' {FPrincipal},
  Uclientes in 'Uclientes.pas' {FClientes},
  UProcessos in 'UProcessos.pas' {FProcessos},
  UPecas in 'UPecas.pas' {FPecas},
  ULocalizar in 'ULocalizar.pas' {FLocalizar},
  UOS in 'UOS.pas' {FOs},
  URelatOS in 'URelatOS.pas' {FRelatOS},
  USplash in 'USplash.pas' {FSplash},
  UNf in 'UNf.pas' {FNf},
  UGerrelat in 'UGerrelat.pas' {FGerRelat},
  URelatCQ in 'URelatCQ.pas' {FRelatCQ},
  URelatorios in 'URelatorios.pas' {FRelatorios},
  UReajuste in 'UReajuste.pas' {FReajuste},
  UUsuarios in 'UUsuarios.pas' {FUsuarios},
  ULogin in 'ULogin.pas' {FLogin},
  ufrmStatus in 'ufrmStatus.pas' {frmStatus},
  UBCrypt in 'UBCrypt.pas',
  UStatusMonitor in 'UStatusMonitor.pas',
  Windows,
  SysUtils,
  Variants,
  Classes;

{$R *.res}

begin
 // Application.Initialize;

//    Try
//       Application.CreateForm(TFNf, FNf);
//   Except
//    on E : Exception do
//     begin
//           Application.MessageBox(pchar('Exception' + E.ClassName),'teste',0) ;
//           Application.MessageBox(pchar('Exception' + E.Message),'teste',0)    ;
//     end;
//
//   end;


  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.CreateForm(TFSplash, FSplash);
  Application.CreateForm(TFLogin, FLogin);
  Application.CreateForm(TfrmStatus, frmStatus);
  //  Application.CreateForm(TFApontamento, FApontamento);
  FSplash.Show;
  FSplash.UpDate;
//  FSplash.LStatus.Caption := 'Verificando unidade de rede...';
//  FSplash.UpDate;
 // If Modulo.Getcomputer = 'ESCRITORIO' then
 // if Modulo.MapeamentosDisponiveis = 'erro' then
  //  begin
  //    Modulo.ConectarRede;
  //  end;
  // If Modulo.Getcomputer = 'Administracao' then
  //if Modulo.MapeamentosDisponiveis = 'erro' then
  //  begin
  //    Modulo.ConectarRede;
  //  end;
  FSplash.LStatus.Caption := 'Preparando banco de dados...';
  FSplash.UpDate;
  Application.CreateForm(TModulo, Modulo);
  //FSplash.LStatus.Caption := 'Criando formulário de Usuários...';
  //FSplash.UpDate;
  //Application.CreateForm(TFUsuarios, FUsuarios);
  //FSplash.LStatus.Caption := 'Criando formulário de Reajuste de Preços...';
  //FSplash.UpDate;
  //Application.CreateForm(TFReajuste, FReajuste);
  FSplash.LStatus.Caption := 'Criando formulário de clientes...';
  FSplash.UpDate;
  Application.CreateForm(TFClientes, FClientes);
  //FSplash.LStatus.Caption := 'Criando formulário de processos...';
  //FSplash.UpDate;
  //Application.CreateForm(TFProcessos, FProcessos);
  FSplash.LStatus.Caption := 'Criando formulário de peças...';
  FSplash.UpDate;
  Application.CreateForm(TFPecas, FPecas);
  FSplash.LStatus.Caption := 'Criando formulário de busca...';
  FSplash.UpDate;
  Application.CreateForm(TFLocalizar, FLocalizar);
  FSplash.LStatus.Caption := 'Criando formulário de OS...';
  FSplash.UpDate;
  Application.CreateForm(TFOs, FOs);
  Application.CreateForm(TFRelatOS, FRelatOS);
  FSplash.LStatus.Caption := 'Criando relatórios de CQ...';
  Application.CreateForm(TFRelatCQ, FRelatCQ);
  FSplash.UpDate;
  FSplash.LStatus.Caption := 'Criando formulário de NF...';
  FSplash.UpDate;
  Application.CreateForm(TFNf, FNf);
  FSplash.LStatus.Caption := 'Inicializando...';
  FSplash.UpDate;
  FSplash.hide;
  FSplash.free;
  FLogin.ShowModal;
  Application.Run;
end.
