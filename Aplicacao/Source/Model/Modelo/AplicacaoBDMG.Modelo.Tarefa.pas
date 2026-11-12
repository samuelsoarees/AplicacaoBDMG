unit AplicacaoBDMG.Modelo.Tarefa;

interface

uses
  AplicacaoBDMG.Modelo.Types;

const
  PRIORIDADE_MINIMA = 1;
  PRIORIDADE_MAXIMA = 5;
  PRIORIDADE_PADRAO = 3;
  TITULO_TAMANHO_MAXIMO = 150;
  DESCRICAO_TAMANHO_MAXIMO = 500;

type
  TAplicacaoBDMGModeloTarefa = class
  private
    FId: Integer;
    FTitulo: string;
    FDescricao: string;
    FStatus: TAplicacaoBDMGStatus;
    FPrioridade: Integer;
    FDataCriacao: TDateTime;
    FDataConclusao: TDateTime;
  public
    class function DescricaoPrioridade(APrioridade: Integer): string; static;

    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property Status: TAplicacaoBDMGStatus read FStatus write FStatus;
    property Prioridade: Integer read FPrioridade write FPrioridade;
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
  end;

implementation

uses
  System.SysUtils;

const
  NOMES_PRIORIDADE: array[PRIORIDADE_MINIMA..PRIORIDADE_MAXIMA] of string =
    ('Muito baixa', 'Baixa', 'Média', 'Alta', 'Muito alta');

class function TAplicacaoBDMGModeloTarefa.DescricaoPrioridade(APrioridade: Integer): string;
begin
  if (APrioridade < PRIORIDADE_MINIMA) or (APrioridade > PRIORIDADE_MAXIMA) then
    Exit(APrioridade.ToString);
  Result := Format('%d - %s', [APrioridade, NOMES_PRIORIDADE[APrioridade]]);
end;

end.
