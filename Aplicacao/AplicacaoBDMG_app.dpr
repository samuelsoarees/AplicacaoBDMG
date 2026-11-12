program AplicacaoBDMG_app;

uses
  System.SysUtils,
  Vcl.Forms,
  AplicacaoBDMG.Resources in 'Resources\AplicacaoBDMG.Resources.pas',
  AplicacaoBDMG.Modelo.Exception in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Exception.pas',
  AplicacaoBDMG.Modelo.Types in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Types.pas',
  AplicacaoBDMG.Modelo.Tarefa in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Tarefa.pas',
  AplicacaoBDMG.Modelo.Estatisticas in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Estatisticas.pas',
  AplicacaoBDMG.Service.Interfaces in 'Source\Model\Service\AplicacaoBDMG.Service.Interfaces.pas',
  AplicacaoBDMG.Service.Session in 'Source\Model\Service\AplicacaoBDMG.Service.Session.pas',
  AplicacaoBDMG.Service.Request in 'Source\Model\Service\AplicacaoBDMG.Service.Request.pas',
  AplicacaoBDMG.Service.Auth in 'Source\Model\Service\AplicacaoBDMG.Service.Auth.pas',
  AplicacaoBDMG.Service.Tarefa in 'Source\Model\Service\AplicacaoBDMG.Service.Tarefa.pas',
  AplicacaoBDMG.Service.Factory in 'Source\Model\Service\AplicacaoBDMG.Service.Factory.pas',
  AplicacaoBDMG.Utils.JSON in 'Source\Utils\AplicacaoBDMG.Utils.JSON.pas',
  AplicacaoBDMG.Utils.Async in 'Source\Utils\AplicacaoBDMG.Utils.Async.pas',
  AplicacaoBDMG.View.Login in 'Source\View\AplicacaoBDMG.View.Login.pas' {AplicacaoBDMGViewLogin},
  AplicacaoBDMG.View.TarefaNova in 'Source\View\AplicacaoBDMG.View.TarefaNova.pas' {AplicacaoBDMGViewTarefaNova},
  AplicacaoBDMG.View.Principal in 'Source\View\AplicacaoBDMG.View.Principal.pas' {AplicacaoBDMGViewPrincipal};

{$R *.res}

var
  LFactory: IAplicacaoBDMGServiceFactory;

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Gerenciador de Tarefas';

  try
    LFactory := TAplicacaoBDMGServiceFactory.New(APPRESOURCES.API_URL, APPRESOURCES.API_TIMEOUT);

    if not TAplicacaoBDMGViewLogin.Autenticar(LFactory) then
      Exit;

    Application.CreateForm(TAplicacaoBDMGViewPrincipal, AplicacaoBDMGViewPrincipal);
    AplicacaoBDMGViewPrincipal.Iniciar(LFactory);
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Exit;
    end;
  end;

  Application.Run;
end.
