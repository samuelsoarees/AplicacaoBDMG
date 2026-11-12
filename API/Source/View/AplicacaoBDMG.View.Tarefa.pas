unit AplicacaoBDMG.View.Tarefa;

interface

uses
  Horse.GBSwagger,
  GBSwagger.Path.Attributes,
  AplicacaoBDMG.View.Base,
  AplicacaoBDMG.Modelo.Classes;

type
  [SwagPath('tarefas', 'Tarefas')]
  TAPIAplicacaoBDMGViewTarefa = class(TAPIAplicacaoBDMGViewBase<TAPIAplicacaoBDMGModeloTarefa>)
  private
    function IdTarefa: Integer;
  public
    [SwagGET('Listar todas as tarefas')]
    [SwagResponse(200, TAPIAplicacaoBDMGModeloTarefa, True)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure List;

    [SwagGET('estatisticas', 'Estatísticas das tarefas (desafio SQL)')]
    [SwagResponse(200, TAPIAplicacaoBDMGModeloEstatisticas)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure Estatisticas;

    [SwagPOST('Adicionar uma nova tarefa')]
    [SwagParamBody('tarefa', TAPIAplicacaoBDMGModeloTarefaNova)]
    [SwagResponse(201, TAPIAplicacaoBDMGModeloTarefa)]
    [SwagResponse(400, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure Gravar;

    [SwagPATCH('{id}/status', 'Atualizar o status de uma tarefa')]
    [SwagParamPath('id', 'Id da tarefa', True)]
    [SwagParamBody('status', TAPIAplicacaoBDMGModeloTarefaStatus)]
    [SwagResponse(200, TAPIAplicacaoBDMGModeloTarefa)]
    [SwagResponse(400, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(404, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure AtualizarStatus;

    [SwagDELETE('{id}', 'Remover uma tarefa')]
    [SwagParamPath('id', 'Id da tarefa', True)]
    [SwagResponse(204)]
    [SwagResponse(400, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(404, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure Deletar;

    class procedure Registry; reintroduce;
  end;

implementation

uses
  System.SysUtils;

const
  HTTP_CREATED = 201;
  HTTP_NO_CONTENT = 204;
  CODIGO_TAREFA_NAO_ENCONTRADA = 'TAREFA_NAO_ENCONTRADA';
  MSG_TAREFA_NAO_ENCONTRADA = 'Tarefa %d não encontrada.';

procedure TAPIAplicacaoBDMGViewTarefa.AtualizarStatus;
var
  LStatus: TAPIAplicacaoBDMGModeloTarefaStatus;
begin
  LStatus := FromBody<TAPIAplicacaoBDMGModeloTarefaStatus>(False);
  try
    FModel := Controller
                .DAO
                  .Tarefa
                    .IdTarefa(IdTarefa)
                    .Status(LStatus.status)
                  .AtualizarStatus;
  finally
    LStatus.Free;
  end;

  if not Assigned(FModel) then
    raise EAplicacaoBDMGException.NaoEncontrado(CODIGO_TAREFA_NAO_ENCONTRADA,
      MSG_TAREFA_NAO_ENCONTRADA, [IdTarefa]);

  Response(FModel);
end;

procedure TAPIAplicacaoBDMGViewTarefa.Deletar;
begin
  if not Controller.DAO.Tarefa.IdTarefa(IdTarefa).Deletar then
    raise EAplicacaoBDMGException.NaoEncontrado(CODIGO_TAREFA_NAO_ENCONTRADA,
      MSG_TAREFA_NAO_ENCONTRADA, [IdTarefa]);

  Response.Status(HTTP_NO_CONTENT);
end;

procedure TAPIAplicacaoBDMGViewTarefa.Estatisticas;
begin
  ResponseOf<TAPIAplicacaoBDMGModeloEstatisticas>(Controller.DAO.Tarefa.Estatisticas);
end;

procedure TAPIAplicacaoBDMGViewTarefa.Gravar;
var
  LTarefaNova: TAPIAplicacaoBDMGModeloTarefaNova;
begin
  LTarefaNova := FromBody<TAPIAplicacaoBDMGModeloTarefaNova>(False);
  try
    LTarefaNova.titulo := LTarefaNova.titulo.Trim;
    LTarefaNova.descricao := LTarefaNova.descricao.Trim;
    ValidateModel(LTarefaNova);

    FModel := Controller
                .DAO
                  .Tarefa
                    .Tarefa(LTarefaNova)
                  .Inserir;
  finally
    LTarefaNova.Free;
  end;

  Response(FModel).Status(HTTP_CREATED);
end;

function TAPIAplicacaoBDMGViewTarefa.IdTarefa: Integer;
begin
  Result := StrToIntDef(Request.Params.Items['id'], 0);
  if Result <= 0 then
    raise EAplicacaoBDMGException.Validacao('ID_INVALIDO',
      'O id da tarefa deve ser um número inteiro positivo.');
end;

procedure TAPIAplicacaoBDMGViewTarefa.List;
begin
  FList := Controller.DAO.Tarefa.Listar;
  Response(FList);
end;

class procedure TAPIAplicacaoBDMGViewTarefa.Registry;
begin
  THorseGBSwaggerRegister.RegisterPath(Self);
end;

end.
