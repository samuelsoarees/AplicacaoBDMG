unit AplicacaoBDMG.Modelo.Estatisticas;

interface

type
  TAplicacaoBDMGModeloEstatisticas = class
  private
    FTotalTarefas: Integer;
    FMediaPrioridadePendentes: Double;
    FConcluidasUltimos7Dias: Integer;
  public
    property TotalTarefas: Integer read FTotalTarefas write FTotalTarefas;
    property MediaPrioridadePendentes: Double read FMediaPrioridadePendentes write FMediaPrioridadePendentes;
    property ConcluidasUltimos7Dias: Integer read FConcluidasUltimos7Dias write FConcluidasUltimos7Dias;
  end;

implementation

end.
