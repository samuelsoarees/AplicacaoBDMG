unit AplicacaoBDMG.Middleware.Exception;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils;

procedure AplicacaoBDMGException(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);

function CriarJSONErro(const AMensagem, ACodigo: string): TJSONObject;

implementation

uses
  FireDAC.Stan.Error,
  AplicacaoBDMG.Modelo.Exception;

const
  CODIGO_ERRO_BANCO = 'ERRO_BANCO_DADOS';
  CODIGO_ERRO_INTERNO = 'ERRO_INTERNO';
  CODIGO_NAO_ENCONTRADO = 'NAO_ENCONTRADO';

function CriarJSONErro(const AMensagem, ACodigo: string): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('erro', AMensagem);
  Result.AddPair('codigo', ACodigo);
end;

procedure RegistrarLog(AReq: THorseRequest; E: Exception);
begin
  Writeln(Format('[%s] ERRO %s %s - %s: %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
    AReq.RawWebRequest.Method, AReq.RawWebRequest.PathInfo, E.ClassName, E.Message]));
end;

procedure Responder(ARes: THorseResponse; AStatus: Integer; const AMensagem, ACodigo: string);
begin
  ARes.Send<TJSONObject>(CriarJSONErro(AMensagem, ACodigo)).Status(AStatus);
end;

procedure AplicacaoBDMGException(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
var
  LStatus: Integer;
begin
  try
    ANext();
  except
    on E: EHorseCallbackInterrupted do
      raise;

    on E: EAplicacaoBDMGException do
      Responder(ARes, E.Status, E.Message, E.Codigo);

    on E: EHorseException do
      Responder(ARes, Integer(E.Status), E.Error, CODIGO_REQUISICAO_INVALIDA);

    on E: EFDDBEngineException do
    begin
      RegistrarLog(AReq, E);
      Responder(ARes, HTTP_INTERNAL_ERROR,
        'Não foi possível acessar o banco de dados. Tente novamente mais tarde.', CODIGO_ERRO_BANCO);
    end;

    on E: Exception do
    begin
      LStatus := ARes.Status;
      if LStatus = HTTP_NOT_FOUND then
        Responder(ARes, LStatus, E.Message, CODIGO_NAO_ENCONTRADO)
      else
      if (LStatus >= HTTP_BAD_REQUEST) and (LStatus < HTTP_INTERNAL_ERROR) then
        Responder(ARes, LStatus, E.Message, CODIGO_REQUISICAO_INVALIDA)
      else
      begin
        RegistrarLog(AReq, E);
        Responder(ARes, HTTP_INTERNAL_ERROR, 'Erro interno ao processar a requisição.', CODIGO_ERRO_INTERNO);
      end;
    end;
  end;
end;

end.
