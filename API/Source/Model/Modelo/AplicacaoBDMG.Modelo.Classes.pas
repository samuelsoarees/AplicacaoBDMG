unit AplicacaoBDMG.Modelo.Classes;

interface

uses
  AplicacaoBDMG.Modelo.Error,
  AplicacaoBDMG.Modelo.Session,
  AplicacaoBDMG.Modelo.Types,
  AplicacaoBDMG.Modelo.Exception,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Modelo.TarefaNova,
  AplicacaoBDMG.Modelo.TarefaStatus,
  AplicacaoBDMG.Modelo.Estatisticas,
  AplicacaoBDMG.Modelo.Credential,
  AplicacaoBDMG.Modelo.Usuario,
  AplicacaoBDMG.Modelo.UsuarioToken;

type
  TAPIAplicacaoBDMGModeloError = AplicacaoBDMG.Modelo.Error.TAPIAplicacaoBDMGModeloError;
  TAPIAplicacaoBDMGModeloSession = AplicacaoBDMG.Modelo.Session.TAPIAplicacaoBDMGModeloSession;
  TAPIAplicacaoBDMGModeloTarefa = AplicacaoBDMG.Modelo.Tarefa.TAPIAplicacaoBDMGModeloTarefa;
  TAPIAplicacaoBDMGModeloTarefaNova = AplicacaoBDMG.Modelo.TarefaNova.TAPIAplicacaoBDMGModeloTarefaNova;
  TAPIAplicacaoBDMGModeloTarefaStatus = AplicacaoBDMG.Modelo.TarefaStatus.TAPIAplicacaoBDMGModeloTarefaStatus;
  TAPIAplicacaoBDMGModeloEstatisticas = AplicacaoBDMG.Modelo.Estatisticas.TAPIAplicacaoBDMGModeloEstatisticas;
  TAPIAplicacaoBDMGModeloCredential = AplicacaoBDMG.Modelo.Credential.TAPIAplicacaoBDMGModeloCredential;
  TAPIAplicacaoBDMGModeloUsuario = AplicacaoBDMG.Modelo.Usuario.TAPIAplicacaoBDMGModeloUsuario;
  TAPIAplicacaoBDMGModeloUsuarioToken = AplicacaoBDMG.Modelo.UsuarioToken.TAPIAplicacaoBDMGModeloUsuarioToken;

  TAPIAplicacaoBDMGStatus = AplicacaoBDMG.Modelo.Types.TAPIAplicacaoBDMGStatus;
  EAplicacaoBDMGException = AplicacaoBDMG.Modelo.Exception.EAplicacaoBDMGException;

implementation

end.
