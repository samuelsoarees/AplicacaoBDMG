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
    constructor Create(AStatus: Integer; const ACodigo, AMensagem: string); reintroduce;

    class function Validacao(const ACodigo, AMensagem: string): EAplicacaoBDMGException; overload;
    class function Validacao(const ACodigo, AMensagem: string; const AArgs: array of const): EAplicacaoBDMGException; overload;
    class function NaoEncontrado(const ACodigo, AMensagem: string): EAplicacaoBDMGException; overload;
    class function NaoEncontrado(const ACodigo, AMensagem: string; const AArgs: array of const): EAplicacaoBDMGException; overload;
    class function NaoAutorizado(const ACodigo, AMensagem: string): EAplicacaoBDMGException;

    property Status: Integer read FStatus;
    property Codigo: string read FCodigo;
  end;

const
  HTTP_BAD_REQUEST = 400;
  HTTP_UNAUTHORIZED = 401;
  HTTP_NOT_FOUND = 404;
  HTTP_INTERNAL_ERROR = 500;

  CODIGO_REQUISICAO_INVALIDA = 'REQUISICAO_INVALIDA';

implementation

constructor EAplicacaoBDMGException.Create(AStatus: Integer; const ACodigo, AMensagem: string);
begin
  inherited Create(AMensagem);
  FStatus := AStatus;
  FCodigo := ACodigo;
end;

class function EAplicacaoBDMGException.NaoAutorizado(const ACodigo, AMensagem: string): EAplicacaoBDMGException;
begin
  Result := EAplicacaoBDMGException.Create(HTTP_UNAUTHORIZED, ACodigo, AMensagem);
end;

class function EAplicacaoBDMGException.NaoEncontrado(const ACodigo, AMensagem: string;
  const AArgs: array of const): EAplicacaoBDMGException;
begin
  Result := EAplicacaoBDMGException.Create(HTTP_NOT_FOUND, ACodigo, Format(AMensagem, AArgs));
end;

class function EAplicacaoBDMGException.NaoEncontrado(const ACodigo, AMensagem: string): EAplicacaoBDMGException;
begin
  Result := EAplicacaoBDMGException.Create(HTTP_NOT_FOUND, ACodigo, AMensagem);
end;

class function EAplicacaoBDMGException.Validacao(const ACodigo, AMensagem: string;
  const AArgs: array of const): EAplicacaoBDMGException;
begin
  Result := EAplicacaoBDMGException.Create(HTTP_BAD_REQUEST, ACodigo, Format(AMensagem, AArgs));
end;

class function EAplicacaoBDMGException.Validacao(const ACodigo, AMensagem: string): EAplicacaoBDMGException;
begin
  Result := EAplicacaoBDMGException.Create(HTTP_BAD_REQUEST, ACodigo, AMensagem);
end;

end.
