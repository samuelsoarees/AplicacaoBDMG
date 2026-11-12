unit AplicacaoBDMG.Modelo.TarefaNova;

interface

uses
  GBSwagger.Model.Attributes;

const
  PRIORIDADE_MINIMA = 1;
  PRIORIDADE_MAXIMA = 5;
  TITULO_TAMANHO_MAXIMO = 150;
  DESCRICAO_TAMANHO_MAXIMO = 500;

type
  TAPIAplicacaoBDMGModeloTarefaNova = class
  private
    Ftitulo: string;
    Fdescricao: string;
    Fprioridade: Integer;
  public
    [SwagRequired]
    [SwagString(TITULO_TAMANHO_MAXIMO, 1)]
    [SwagProp('titulo', 'Título da tarefa', True)]
    property titulo: string read Ftitulo write Ftitulo;

    [SwagString(DESCRICAO_TAMANHO_MAXIMO)]
    [SwagProp('descricao', 'Descrição detalhada', False)]
    property descricao: string read Fdescricao write Fdescricao;

    [SwagRequired]
    [SwagNumber(PRIORIDADE_MINIMA, PRIORIDADE_MAXIMA)]
    [SwagProp('prioridade', 'Prioridade de 1 (menor) a 5 (maior)', True)]
    property prioridade: Integer read Fprioridade write Fprioridade;
  end;

implementation

end.
