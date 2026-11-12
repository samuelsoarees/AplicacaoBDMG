unit AplicacaoBDMG.Modelo.Exception;

interface

uses
  System.SysUtils;

type
  EAplicacaoBDMGException = class(Exception)
  private
    FStatus: Integer;
    FCodigo: string;
  public
    constructor Create(const AMensagem: string; AStatus: Integer = 0; const ACodigo: string = '');

    property Status: Integer read FStatus;
    property Codigo: string read FCodigo;
  end;

  EAplicacaoBDMGNaoAutorizado = class(EAplicacaoBDMGException);

  EAplicacaoBDMGConexao = class(EAplicacaoBDMGException);

implementation

constructor EAplicacaoBDMGException.Create(const AMensagem: string; AStatus: Integer; const ACodigo: string);
begin
  inherited Create(AMensagem);
  FStatus := AStatus;
  FCodigo := ACodigo;
end;

end.
