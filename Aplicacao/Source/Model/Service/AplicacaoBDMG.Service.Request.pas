unit AplicacaoBDMG.Service.Request;

interface

{$SCOPEDENUMS ON}

uses
  System.JSON,
  RESTRequest4D,
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGServiceRequest = class(TInterfacedObject, IAplicacaoBDMGServiceRequest)
  private
    type
      TMetodo = (Get, Post, Patch, Delete);
  private
    FBaseURL: string;
    FTimeout: Integer;
    FSession: IAplicacaoBDMGSession;

    function Executar(AMetodo: TMetodo; const AResource: string; ABody: TJSONObject): TJSONValue;
    function TratarResposta(const AResponse: IResponse): TJSONValue;
    function MensagemPadrao(AStatus: Integer): string;
    procedure LevantarErro(AStatus: Integer; AJSON: TJSONValue);
  public
    constructor Create(const ABaseURL: string; ATimeout: Integer; const ASession: IAplicacaoBDMGSession);
    class function New(const ABaseURL: string; ATimeout: Integer;
      const ASession: IAplicacaoBDMGSession): IAplicacaoBDMGServiceRequest;

    function Get(const AResource: string): TJSONValue;
    function Post(const AResource: string; ABody: TJSONObject): TJSONValue;
    function Patch(const AResource: string; ABody: TJSONObject): TJSONValue;
    procedure Delete(const AResource: string);
  end;

implementation

uses
  System.SysUtils,
  AplicacaoBDMG.Modelo.Exception;

const
  HTTP_OK = 200;
  HTTP_MULTIPLE_CHOICES = 300;
  HTTP_BAD_REQUEST = 400;
  HTTP_UNAUTHORIZED = 401;
  HTTP_NOT_FOUND = 404;
  HTTP_INTERNAL_ERROR = 500;

  CODIGO_CREDENCIAIS_INVALIDAS = 'CREDENCIAIS_INVALIDAS';

  MSG_SERVICO_INDISPONIVEL =
    'Não foi possível conectar ao serviço em %s.' + sLineBreak +
    'Verifique se a API está em execução e tente novamente.';
  MSG_SESSAO_EXPIRADA = 'Sua sessão expirou. Informe suas credenciais novamente.';

constructor TAplicacaoBDMGServiceRequest.Create(const ABaseURL: string; ATimeout: Integer;
  const ASession: IAplicacaoBDMGSession);
begin
  FBaseURL := ABaseURL;
  FTimeout := ATimeout;
  FSession := ASession;
end;

procedure TAplicacaoBDMGServiceRequest.Delete(const AResource: string);
begin
  Executar(TMetodo.Delete, AResource, nil).Free;
end;

function TAplicacaoBDMGServiceRequest.Executar(AMetodo: TMetodo; const AResource: string;
  ABody: TJSONObject): TJSONValue;
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.New;

  if Assigned(ABody) then
    LRequest.AddBody(ABody);

  LRequest
    .BaseURL(FBaseURL)
    .Resource(AResource)
    .Accept('application/json')
    .Timeout(FTimeout);

  if FSession.Autenticado then
    LRequest.TokenBearer(FSession.Token);

  try
    case AMetodo of
      TMetodo.Post:
        LResponse := LRequest.Post;
      TMetodo.Patch:
        LResponse := LRequest.Patch;
      TMetodo.Delete:
        LResponse := LRequest.Delete;
    else
      LResponse := LRequest.Get;
    end;
  except
    on E: Exception do
      raise EAplicacaoBDMGConexao.CreateFmt(MSG_SERVICO_INDISPONIVEL, [FBaseURL]);
  end;

  Result := TratarResposta(LResponse);
end;

function TAplicacaoBDMGServiceRequest.Get(const AResource: string): TJSONValue;
begin
  Result := Executar(TMetodo.Get, AResource, nil);
end;

procedure TAplicacaoBDMGServiceRequest.LevantarErro(AStatus: Integer; AJSON: TJSONValue);
var
  LMensagem: string;
  LCodigo: string;
begin
  LMensagem := EmptyStr;
  LCodigo := EmptyStr;

  if AJSON is TJSONObject then
  begin
    LMensagem := AJSON.GetValue<string>('erro', EmptyStr);
    LCodigo := AJSON.GetValue<string>('codigo', EmptyStr);
  end;

  if (AStatus = HTTP_UNAUTHORIZED) and (LCodigo <> CODIGO_CREDENCIAIS_INVALIDAS) then
    raise EAplicacaoBDMGNaoAutorizado.Create(MSG_SESSAO_EXPIRADA, AStatus, LCodigo);

  if LMensagem.IsEmpty then
    LMensagem := MensagemPadrao(AStatus);

  raise EAplicacaoBDMGException.Create(LMensagem, AStatus, LCodigo);
end;

function TAplicacaoBDMGServiceRequest.MensagemPadrao(AStatus: Integer): string;
begin
  case AStatus of
    HTTP_BAD_REQUEST:
      Result := 'O serviço recusou os dados enviados. Revise as informações e tente novamente.';
    HTTP_UNAUTHORIZED:
      Result := 'Usuário ou senha inválidos.';
    HTTP_NOT_FOUND:
      Result := 'O registro solicitado não foi encontrado no serviço.';
  else
    if AStatus >= HTTP_INTERNAL_ERROR then
      Result := 'O serviço encontrou um erro ao processar a solicitação. Tente novamente mais tarde.'
    else
      Result := Format('O serviço respondeu com um status inesperado (%d).', [AStatus]);
  end;
end;

class function TAplicacaoBDMGServiceRequest.New(const ABaseURL: string; ATimeout: Integer;
  const ASession: IAplicacaoBDMGSession): IAplicacaoBDMGServiceRequest;
begin
  Result := Self.Create(ABaseURL, ATimeout, ASession);
end;

function TAplicacaoBDMGServiceRequest.Patch(const AResource: string; ABody: TJSONObject): TJSONValue;
begin
  Result := Executar(TMetodo.Patch, AResource, ABody);
end;

function TAplicacaoBDMGServiceRequest.Post(const AResource: string; ABody: TJSONObject): TJSONValue;
begin
  Result := Executar(TMetodo.Post, AResource, ABody);
end;

function TAplicacaoBDMGServiceRequest.TratarResposta(const AResponse: IResponse): TJSONValue;
var
  LJSON: TJSONValue;
begin
  Result := nil;

  LJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetString(AResponse.RawBytes));

  if (AResponse.StatusCode >= HTTP_OK) and (AResponse.StatusCode < HTTP_MULTIPLE_CHOICES) then
    Exit(LJSON);

  try
    LevantarErro(AResponse.StatusCode, LJSON);
  finally
    LJSON.Free;
  end;
end;

end.
