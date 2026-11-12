unit AplicacaoBDMG.Modelo.Estatisticas;

interface

uses
  GBSwagger.Model.Attributes;

type
  TAPIAplicacaoBDMGModeloEstatisticas = class
  private
    FtotalTarefas: Integer;
    FmediaPrioridadePendentes: Double;
    FconcluidasUltimos7Dias: Integer;
  public
    [SwagProp('totalTarefas', 'Número total de tarefas', False)]
    property totalTarefas: Integer read FtotalTarefas write FtotalTarefas;
    [SwagProp('mediaPrioridadePendentes', 'Média de prioridade das tarefas com status Pendente (0 quando não há pendentes)', False)]
    property mediaPrioridadePendentes: Double read FmediaPrioridadePendentes write FmediaPrioridadePendentes;
    [SwagProp('concluidasUltimos7Dias', 'Quantidade de tarefas concluídas nos últimos 7 dias', False)]
    property concluidasUltimos7Dias: Integer read FconcluidasUltimos7Dias write FconcluidasUltimos7Dias;
  end;

implementation

end.
