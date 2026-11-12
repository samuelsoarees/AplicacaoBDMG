program AplicacaoBDMG_api;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  AplicacaoBDMG.Resources in 'Resources\AplicacaoBDMG.Resources.pas',
  AplicacaoBDMG.Swagger.Init in 'Swagger\AplicacaoBDMG.Swagger.Init.pas',
  AplicacaoBDMG.Utils.JSON in 'Source\Utils\AplicacaoBDMG.Utils.JSON.pas',
  AplicacaoBDMG.Middleware.Exception in 'Source\Middleware\AplicacaoBDMG.Middleware.Exception.pas',
  AplicacaoBDMG.Controller.Interfaces in 'Source\Controller\AplicacaoBDMG.Controller.Interfaces.pas',
  AplicacaoBDMG.Controller in 'Source\Controller\AplicacaoBDMG.Controller.pas',
  AplicacaoBDMG.Modelo.Classes in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Classes.pas',
  AplicacaoBDMG.Modelo.Types in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Types.pas',
  AplicacaoBDMG.Modelo.Exception in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Exception.pas',
  AplicacaoBDMG.Modelo.Error in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Error.pas',
  AplicacaoBDMG.Modelo.Session in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Session.pas',
  AplicacaoBDMG.Modelo.Tarefa in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Tarefa.pas',
  AplicacaoBDMG.Modelo.TarefaNova in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.TarefaNova.pas',
  AplicacaoBDMG.Modelo.TarefaStatus in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.TarefaStatus.pas',
  AplicacaoBDMG.Modelo.Estatisticas in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Estatisticas.pas',
  AplicacaoBDMG.Modelo.Credential in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Credential.pas',
  AplicacaoBDMG.Modelo.Usuario in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.Usuario.pas',
  AplicacaoBDMG.Modelo.UsuarioToken in 'Source\Model\Modelo\AplicacaoBDMG.Modelo.UsuarioToken.pas',
  AplicacaoBDMG.DAO.Interfaces in 'Source\Model\DAO\AplicacaoBDMG.DAO.Interfaces.pas',
  AplicacaoBDMG.DAO.Factory in 'Source\Model\DAO\AplicacaoBDMG.DAO.Factory.pas',
  AplicacaoBDMG.DAO.Base in 'Source\Model\DAO\AplicacaoBDMG.DAO.Base.pas',
  AplicacaoBDMG.DAO.SQL in 'Source\Model\DAO\AplicacaoBDMG.DAO.SQL.pas',
  AplicacaoBDMG.DAO.Connection.Factory in 'Source\Model\DAO\AplicacaoBDMG.DAO.Connection.Factory.pas',
  AplicacaoBDMG.DAO.Connection.SQLServer in 'Source\Model\DAO\AplicacaoBDMG.DAO.Connection.SQLServer.pas',
  AplicacaoBDMG.DAO.Tarefa in 'Source\Model\DAO\AplicacaoBDMG.DAO.Tarefa.pas',
  AplicacaoBDMG.DAO.Usuario in 'Source\Model\DAO\AplicacaoBDMG.DAO.Usuario.pas',
  AplicacaoBDMG.Service.Interfaces in 'Source\Model\Service\AplicacaoBDMG.Service.Interfaces.pas',
  AplicacaoBDMG.Service.Factory in 'Source\Model\Service\AplicacaoBDMG.Service.Factory.pas',
  AplicacaoBDMG.Service.Credential in 'Source\Model\Service\Credential\AplicacaoBDMG.Service.Credential.pas',
  AplicacaoBDMG.View.Base in 'Source\View\AplicacaoBDMG.View.Base.pas',
  AplicacaoBDMG.View.API in 'Source\View\AplicacaoBDMG.View.API.pas',
  AplicacaoBDMG.View.Ping in 'Source\View\AplicacaoBDMG.View.Ping.pas',
  AplicacaoBDMG.View.Auth in 'Source\View\AplicacaoBDMG.View.Auth.pas',
  AplicacaoBDMG.View.Tarefa in 'Source\View\AplicacaoBDMG.View.Tarefa.pas';

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  try
    CreateServer;
    StartServer;
  except
    on E: Exception do
    begin
      Writeln(Format('Falha ao iniciar a API: %s - %s', [E.ClassName, E.Message]));
      ExitCode := 1;
    end;
  end;
end.
