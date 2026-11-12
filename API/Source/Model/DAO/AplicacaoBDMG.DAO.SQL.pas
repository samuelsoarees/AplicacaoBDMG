unit AplicacaoBDMG.DAO.SQL;

interface

type
  TAPIAplicacaoBDMGDAOSQL = class
  public
    class function GetSqlListarTarefas: string;
    class function GetSqlInserirTarefa: string;
    class function GetSqlAtualizarStatusTarefa: string;
    class function GetSqlDeletarTarefa: string;
    class function GetSqlEstatisticasTarefas: string;
    class function GetSqlBuscarUsuario: string;
  end;

implementation

const
  COLUNAS_TAREFA = 'Id, Titulo, Descricao, Status, Prioridade, DataCriacao, DataConclusao';

class function TAPIAplicacaoBDMGDAOSQL.GetSqlAtualizarStatusTarefa: string;
begin
  Result :=
    'UPDATE dbo.Tarefa ' +
    '   SET Status = :status, ' +
    '       DataConclusao = CASE WHEN :status = :statusConcluida ' +
    '                            THEN ISNULL(DataConclusao, SYSDATETIME()) ' +
    '                            ELSE NULL END ' +
    'OUTPUT INSERTED.Id, INSERTED.Titulo, INSERTED.Descricao, INSERTED.Status, ' +
    '       INSERTED.Prioridade, INSERTED.DataCriacao, INSERTED.DataConclusao ' +
    ' WHERE Id = :id';
end;

class function TAPIAplicacaoBDMGDAOSQL.GetSqlBuscarUsuario: string;
begin
  Result :=
    'SELECT Id, Login, SenhaHash, Salt, Ativo ' +
    '  FROM dbo.Usuario ' +
    ' WHERE Login = :login';
end;

class function TAPIAplicacaoBDMGDAOSQL.GetSqlDeletarTarefa: string;
begin
  Result := 'DELETE FROM dbo.Tarefa WHERE Id = :id';
end;

class function TAPIAplicacaoBDMGDAOSQL.GetSqlEstatisticasTarefas: string;
begin
  Result :=
    'SELECT (SELECT COUNT(*) ' +
    '          FROM dbo.Tarefa) AS TotalTarefas, ' +
    '       (SELECT ISNULL(AVG(CAST(Prioridade AS DECIMAL(5, 2))), 0) ' +
    '          FROM dbo.Tarefa ' +
    '         WHERE Status = :statusPendente) AS MediaPrioridadePendentes, ' +
    '       (SELECT COUNT(*) ' +
    '          FROM dbo.Tarefa ' +
    '         WHERE Status = :statusConcluida ' +
    '           AND DataConclusao >= DATEADD(DAY, -7, SYSDATETIME())) AS ConcluidasUltimos7Dias';
end;

class function TAPIAplicacaoBDMGDAOSQL.GetSqlInserirTarefa: string;
begin
  Result :=
    'INSERT INTO dbo.Tarefa (Titulo, Descricao, Prioridade) ' +
    'OUTPUT INSERTED.Id, INSERTED.Titulo, INSERTED.Descricao, INSERTED.Status, ' +
    '       INSERTED.Prioridade, INSERTED.DataCriacao, INSERTED.DataConclusao ' +
    'VALUES (:titulo, :descricao, :prioridade)';
end;

class function TAPIAplicacaoBDMGDAOSQL.GetSqlListarTarefas: string;
begin
  Result :=
    'SELECT ' + COLUNAS_TAREFA +
    '  FROM dbo.Tarefa ' +
    ' ORDER BY Id';
end;

end.
