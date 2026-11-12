unit AplicacaoBDMG.Utils.JSON;

interface

uses
  System.JSON,
  System.Generics.Collections,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Modelo.Estatisticas;

type
  TAplicacaoBDMGUtilsJSON = class
  private
    class function ComoObjeto(AJSON: TJSONValue): TJSONObject;
    class function LerData(AJSON: TJSONObject; const ANome: string): TDateTime;
  public
    class function ToTarefa(AJSON: TJSONValue): TAplicacaoBDMGModeloTarefa;
    class function ToTarefas(AJSON: TJSONValue): TObjectList<TAplicacaoBDMGModeloTarefa>;
    class function ToEstatisticas(AJSON: TJSONValue): TAplicacaoBDMGModeloEstatisticas;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  AplicacaoBDMG.Modelo.Types,
  AplicacaoBDMG.Modelo.Exception;

const
  MSG_RESPOSTA_INESPERADA = 'O serviço devolveu uma resposta em formato inesperado.';

class function TAplicacaoBDMGUtilsJSON.ComoObjeto(AJSON: TJSONValue): TJSONObject;
begin
  if not (AJSON is TJSONObject) then
    raise EAplicacaoBDMGException.Create(MSG_RESPOSTA_INESPERADA);
  Result := TJSONObject(AJSON);
end;

class function TAplicacaoBDMGUtilsJSON.LerData(AJSON: TJSONObject; const ANome: string): TDateTime;
var
  LValor: TJSONValue;
begin
  Result := 0;

  LValor := AJSON.GetValue(ANome);
  if (not Assigned(LValor)) or (LValor is TJSONNull) then
    Exit;

  if not TryISO8601ToDate(LValor.Value, Result, False) then
    raise EAplicacaoBDMGException.Create(MSG_RESPOSTA_INESPERADA);
end;

class function TAplicacaoBDMGUtilsJSON.ToEstatisticas(AJSON: TJSONValue): TAplicacaoBDMGModeloEstatisticas;
var
  LObjeto: TJSONObject;
begin
  LObjeto := ComoObjeto(AJSON);

  Result := TAplicacaoBDMGModeloEstatisticas.Create;
  try
    Result.TotalTarefas := LObjeto.GetValue<Integer>('totalTarefas');
    Result.MediaPrioridadePendentes := LObjeto.GetValue<Double>('mediaPrioridadePendentes');
    Result.ConcluidasUltimos7Dias := LObjeto.GetValue<Integer>('concluidasUltimos7Dias');
  except
    on E: Exception do
    begin
      Result.Free;
      raise EAplicacaoBDMGException.Create(MSG_RESPOSTA_INESPERADA);
    end;
  end;
end;

class function TAplicacaoBDMGUtilsJSON.ToTarefa(AJSON: TJSONValue): TAplicacaoBDMGModeloTarefa;
var
  LObjeto: TJSONObject;
begin
  LObjeto := ComoObjeto(AJSON);

  Result := TAplicacaoBDMGModeloTarefa.Create;
  try
    Result.Id := LObjeto.GetValue<Integer>('id');
    Result.Titulo := LObjeto.GetValue<string>('titulo');
    Result.Descricao := LObjeto.GetValue<string>('descricao', EmptyStr);
    Result.Status := TAplicacaoBDMGStatus.FromString(LObjeto.GetValue<string>('status'));
    Result.Prioridade := LObjeto.GetValue<Integer>('prioridade');
    Result.DataCriacao := LerData(LObjeto, 'dataCriacao');
    Result.DataConclusao := LerData(LObjeto, 'dataConclusao');
  except
    on E: Exception do
    begin
      Result.Free;
      raise EAplicacaoBDMGException.Create(MSG_RESPOSTA_INESPERADA);
    end;
  end;
end;

class function TAplicacaoBDMGUtilsJSON.ToTarefas(AJSON: TJSONValue): TObjectList<TAplicacaoBDMGModeloTarefa>;
var
  LItem: TJSONValue;
begin
  if not (AJSON is TJSONArray) then
    raise EAplicacaoBDMGException.Create(MSG_RESPOSTA_INESPERADA);

  Result := TObjectList<TAplicacaoBDMGModeloTarefa>.Create(True);
  try
    for LItem in TJSONArray(AJSON) do
      Result.Add(ToTarefa(LItem));
  except
    Result.Free;
    raise;
  end;
end;

end.
