unit AplicacaoBDMG.Modelo.TarefaStatus;

interface

uses
  GBSwagger.Model.Attributes,
  AplicacaoBDMG.Modelo.Types;

type
  TAPIAplicacaoBDMGModeloTarefaStatus = class
  private
    Fstatus: TAPIAplicacaoBDMGStatus;
  public
    [SwagProp('status', 'Novo status da tarefa', True)]
    property status: TAPIAplicacaoBDMGStatus read Fstatus write Fstatus;
  end;

implementation

end.
