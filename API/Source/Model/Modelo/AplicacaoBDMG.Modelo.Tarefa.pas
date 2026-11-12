unit AplicacaoBDMG.Modelo.Tarefa;

interface

uses
  GBSwagger.Model.Attributes,
  AplicacaoBDMG.Modelo.Types;

type
  TAPIAplicacaoBDMGModeloTarefa = class
  private
    Fid: Integer;
    Ftitulo: string;
    Fdescricao: string;
    Fstatus: TAPIAplicacaoBDMGStatus;
    Fprioridade: Integer;
    FdataCriacao: TDateTime;
    FdataConclusao: TDateTime;
  public
    [SwagProp('id', 'Identificador da tarefa', False)]
    property id: Integer read Fid write Fid;
    [SwagProp('titulo', 'Título da tarefa', False)]
    property titulo: string read Ftitulo write Ftitulo;
    [SwagProp('descricao', 'Descrição detalhada', False)]
    property descricao: string read Fdescricao write Fdescricao;
    [SwagProp('status', 'Status atual', False)]
    property status: TAPIAplicacaoBDMGStatus read Fstatus write Fstatus;
    [SwagProp('prioridade', 'Prioridade de 1 (menor) a 5 (maior)', False)]
    property prioridade: Integer read Fprioridade write Fprioridade;
    [SwagProp('dataCriacao', 'Data/hora de criação', False)]
    property dataCriacao: TDateTime read FdataCriacao write FdataCriacao;
    [SwagProp('dataConclusao', 'Data/hora de conclusão (null enquanto não concluída)', False)]
    property dataConclusao: TDateTime read FdataConclusao write FdataConclusao;
  end;

implementation

end.
