unit AplicacaoBDMG.DAO.Tarefa;

interface

uses
  Data.DB,
  System.Generics.Collections,
  AplicacaoBDMG.DAO.Base,
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Modelo.Classes;

type
  TAPIAplicacaoBDMGDAOTarefa = class(TAPIAplicacaoBDMGDAOBase, IAPIAplicacaoBDMGDAOTarefa)
  private
    FIdTarefa: Integer;
    FTarefa: TAPIAplicacaoBDMGModeloTarefaNova;
    FStatus: TAPIAplicacaoBDMGStatus;

    function DataSetToList(ADataSet: TDataSet): TObjectList<TAPIAplicacaoBDMGModeloTarefa>;
    function DataSetToModelo(ADataSet: TDataSet): TAPIAplicacaoBDMGModeloTarefa; overload;
    procedure DataSetToModelo(ADataSet: TDataSet; AModelo: TAPIAplicacaoBDMGModeloTarefa); overload;
  protected
    function IdTarefa(AValue: Integer): IAPIAplicacaoBDMGDAOTarefa;
    function Tarefa(AValue: TAPIAplicacaoBDMGModeloTarefaNova): IAPIAplicacaoBDMGDAOTarefa;
    function Status(AValue: TAPIAplicacaoBDMGStatus): IAPIAplicacaoBDMGDAOTarefa;

    function Listar: TObjectList<TAPIAplicacaoBDMGModeloTarefa>;
    function Inserir: TAPIAplicacaoBDMGModeloTarefa;
    function AtualizarStatus: TAPIAplicacaoBDMGModeloTarefa;
    function Deletar: Boolean;
    function Estatisticas: TAPIAplicacaoBDMGModeloEstatisticas;
  public
    class function New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOTarefa;
  end;

implementation

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.Math,
  System.SysUtils,
  AplicacaoBDMG.DAO.SQL,
  AplicacaoBDMG.Modelo.Types;

function TAPIAplicacaoBDMGDAOTarefa.AtualizarStatus: TAPIAplicacaoBDMGModeloTarefa;
var
  LQuery: TFDQuery;
begin
  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlAtualizarStatusTarefa);
  try
    LQuery.ParamByName('id').AsInteger := FIdTarefa;
    LQuery.ParamByName('status').AsString := FStatus.ToString;
    LQuery.ParamByName('statusConcluida').AsString := TAPIAplicacaoBDMGStatus.Concluida.ToString;
    LQuery.Open;
    Result := DataSetToModelo(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TAPIAplicacaoBDMGDAOTarefa.DataSetToList(ADataSet: TDataSet): TObjectList<TAPIAplicacaoBDMGModeloTarefa>;
begin
  Result := TObjectList<TAPIAplicacaoBDMGModeloTarefa>.Create;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      Result.Add(DataSetToModelo(ADataSet));
      ADataSet.Next;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TAPIAplicacaoBDMGDAOTarefa.DataSetToModelo(ADataSet: TDataSet): TAPIAplicacaoBDMGModeloTarefa;
begin
  Result := nil;
  if not ADataSet.IsEmpty then
  begin
    Result := TAPIAplicacaoBDMGModeloTarefa.Create;
    try
      DataSetToModelo(ADataSet, Result);
    except
      Result.Free;
      raise;
    end;
  end;
end;

procedure TAPIAplicacaoBDMGDAOTarefa.DataSetToModelo(ADataSet: TDataSet; AModelo: TAPIAplicacaoBDMGModeloTarefa);
begin
  AModelo.id := ADataSet.FieldByName('Id').AsInteger;
  AModelo.titulo := ADataSet.FieldByName('Titulo').AsString;
  AModelo.descricao := ADataSet.FieldByName('Descricao').AsString;
  AModelo.status := TAPIAplicacaoBDMGStatus.FromString(ADataSet.FieldByName('Status').AsString);
  AModelo.prioridade := ADataSet.FieldByName('Prioridade').AsInteger;
  AModelo.dataCriacao := ADataSet.FieldByName('DataCriacao').AsDateTime;
  AModelo.dataConclusao := ADataSet.FieldByName('DataConclusao').AsDateTime;
end;

function TAPIAplicacaoBDMGDAOTarefa.Deletar: Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlDeletarTarefa);
  try
    LQuery.ParamByName('id').AsInteger := FIdTarefa;
    LQuery.ExecSQL;
    Result := LQuery.RowsAffected > 0;
  finally
    LQuery.Free;
  end;
end;

function TAPIAplicacaoBDMGDAOTarefa.Estatisticas: TAPIAplicacaoBDMGModeloEstatisticas;
var
  LQuery: TFDQuery;
begin
  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlEstatisticasTarefas);
  try
    LQuery.ParamByName('statusPendente').AsString := TAPIAplicacaoBDMGStatus.Pendente.ToString;
    LQuery.ParamByName('statusConcluida').AsString := TAPIAplicacaoBDMGStatus.Concluida.ToString;
    LQuery.Open;

    Result := TAPIAplicacaoBDMGModeloEstatisticas.Create;
    try
      Result.totalTarefas := LQuery.FieldByName('TotalTarefas').AsInteger;
      Result.mediaPrioridadePendentes :=
        RoundTo(LQuery.FieldByName('MediaPrioridadePendentes').AsFloat, -2);
      Result.concluidasUltimos7Dias := LQuery.FieldByName('ConcluidasUltimos7Dias').AsInteger;
    except
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAPIAplicacaoBDMGDAOTarefa.IdTarefa(AValue: Integer): IAPIAplicacaoBDMGDAOTarefa;
begin
  Result := Self;
  FIdTarefa := AValue;
end;

function TAPIAplicacaoBDMGDAOTarefa.Inserir: TAPIAplicacaoBDMGModeloTarefa;
var
  LQuery: TFDQuery;
begin
  if not Assigned(FTarefa) then
    raise EArgumentNilException.Create('Tarefa não informada para inclusão.');

  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlInserirTarefa);
  try
    LQuery.ParamByName('titulo').AsWideString := FTarefa.titulo;
    LQuery.ParamByName('descricao').DataType := ftWideString;
    if FTarefa.descricao.IsEmpty then
      LQuery.ParamByName('descricao').Clear
    else
      LQuery.ParamByName('descricao').AsWideString := FTarefa.descricao;
    LQuery.ParamByName('prioridade').AsInteger := FTarefa.prioridade;
    LQuery.Open;
    Result := DataSetToModelo(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TAPIAplicacaoBDMGDAOTarefa.Listar: TObjectList<TAPIAplicacaoBDMGModeloTarefa>;
var
  LQuery: TFDQuery;
begin
  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlListarTarefas);
  try
    LQuery.Open;
    Result := DataSetToList(LQuery);
  finally
    LQuery.Free;
  end;
end;

class function TAPIAplicacaoBDMGDAOTarefa.New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOTarefa;
begin
  Result := Self.Create(AConnection);
end;

function TAPIAplicacaoBDMGDAOTarefa.Status(AValue: TAPIAplicacaoBDMGStatus): IAPIAplicacaoBDMGDAOTarefa;
begin
  Result := Self;
  FStatus := AValue;
end;

function TAPIAplicacaoBDMGDAOTarefa.Tarefa(AValue: TAPIAplicacaoBDMGModeloTarefaNova): IAPIAplicacaoBDMGDAOTarefa;
begin
  Result := Self;
  FTarefa := AValue;
end;

end.
