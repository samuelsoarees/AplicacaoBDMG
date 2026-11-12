unit AplicacaoBDMG.Modelo.Error;

interface

uses
  GBSwagger.Model.Attributes;

type
  TAPIAplicacaoBDMGModeloError = class
  private
    Ferro: string;
    Fcodigo: string;
  public
    [SwagProp('erro', 'Mensagem descritiva do erro', False)]
    property erro: string read Ferro write Ferro;
    [SwagProp('codigo', 'Código estável do erro, ex.: TAREFA_NAO_ENCONTRADA', False)]
    property codigo: string read Fcodigo write Fcodigo;
  end;

implementation

end.
