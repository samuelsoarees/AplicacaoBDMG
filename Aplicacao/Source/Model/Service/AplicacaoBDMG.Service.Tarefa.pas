unit AplicacaoBDMG.Service.Tarefa;

interface

uses
  System.Generics.Collections,
  AplicacaoBDMG.Modelo.Types,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Modelo.Estatisticas,
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGServiceTarefa = class(TInterfacedObject, IAplicacaoBDMGServiceTarefa)
  private
    FRequest: IAplicacaoBDMGServiceRequest;
  public
    constructor Create(const ARequest: IAplicacaoBDMGServiceRequest);
    class function New(const ARequest: IAplicacaoBDMGServiceRequest): IAplicacaoBDMGServiceTarefa;

    function Listar: TObjectList<TAplicacaoBDMGModeloTarefa>;
    function Inserir(const ATitulo, ADescricao: string; APrioridade: Integer): TAplicacaoBDMGModeloTarefa;
    function AtualizarStatus(AId: Integer; AStatus: TAplicacaoBDMGStatus): TAplicacaoBDMGModeloTarefa;
    procedure Remover(AId: Integer);
    function Estatisticas: TAplicacaoBDMGModeloEstatisticas;
  end;

implementation

uses
  System.JSON,
  System.SysUtils,
  AplicacaoBDMG.Utils.JSON;

const
  RESOURCE_TAREFAS = 'tarefas';
  RESOURCE_TAREFA = 'tarefas/%d';
  RESOURCE_TAREFA_STATUS = 'tarefas/%d/status';
  RESOURCE_ESTATISTICAS = 'tarefas/estatisticas';

function TAplicacaoBDMGServiceTarefa.AtualizarStatus(AId: Integer;
  AStatus: TAplicacaoBDMGStatus): TAplicacaoBDMGModeloTarefa;
var
  LBody: TJSONObject;
  LResposta: TJSONValue;
begin
  LBody := TJSONObject.Create;
  LBody.AddPair('status', AStatus.ToString);

  LResposta := FRequest.Patch(Format(RESOURCE_TAREFA_STATUS, [AId]), LBody);
  try
    Result := TAplicacaoBDMGUtilsJSON.ToTarefa(LResposta);
  finally
    LResposta.Free;
  end;
end;

constructor TAplicacaoBDMGServiceTarefa.Create(const ARequest: IAplicacaoBDMGServiceRequest);
begin
  FRequest := ARequest;
end;

function TAplicacaoBDMGServiceTarefa.Estatisticas: TAplicacaoBDMGModeloEstatisticas;
var
  LResposta: TJSONValue;
begin
  LResposta := FRequest.Get(RESOURCE_ESTATISTICAS);
  try
    Result := TAplicacaoBDMGUtilsJSON.ToEstatisticas(LResposta);
  finally
    LResposta.Free;
  end;
end;

function TAplicacaoBDMGServiceTarefa.Inserir(const ATitulo, ADescricao: string;
  APrioridade: Integer): TAplicacaoBDMGModeloTarefa;
var
  LBody: TJSONObject;
  LResposta: TJSONValue;
begin
  LBody := TJSONObject.Create;
  LBody.AddPair('titulo', ATitulo);
  LBody.AddPair('descricao', ADescricao);
  LBody.AddPair('prioridade', TJSONNumber.Create(APrioridade));

  LResposta := FRequest.Post(RESOURCE_TAREFAS, LBody);
  try
    Result := TAplicacaoBDMGUtilsJSON.ToTarefa(LResposta);
  finally
    LResposta.Free;
  end;
end;

function TAplicacaoBDMGServiceTarefa.Listar: TObjectList<TAplicacaoBDMGModeloTarefa>;
var
  LResposta: TJSONValue;
begin
  LResposta := FRequest.Get(RESOURCE_TAREFAS);
  try
    Result := TAplicacaoBDMGUtilsJSON.ToTarefas(LResposta);
  finally
    LResposta.Free;
  end;
end;

class function TAplicacaoBDMGServiceTarefa.New(
  const ARequest: IAplicacaoBDMGServiceRequest): IAplicacaoBDMGServiceTarefa;
begin
  Result := Self.Create(ARequest);
end;

procedure TAplicacaoBDMGServiceTarefa.Remover(AId: Integer);
begin
  FRequest.Delete(Format(RESOURCE_TAREFA, [AId]));
end;

end.
