unit AplicacaoBDMG.Service.Auth;

interface

uses
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGServiceAuth = class(TInterfacedObject, IAplicacaoBDMGServiceAuth)
  private
    FRequest: IAplicacaoBDMGServiceRequest;
    FSession: IAplicacaoBDMGSession;
  public
    constructor Create(const ARequest: IAplicacaoBDMGServiceRequest; const ASession: IAplicacaoBDMGSession);
    class function New(const ARequest: IAplicacaoBDMGServiceRequest;
      const ASession: IAplicacaoBDMGSession): IAplicacaoBDMGServiceAuth;

    procedure Login(const ALogin, ASenha: string);
  end;

implementation

uses
  System.JSON,
  System.SysUtils,
  AplicacaoBDMG.Modelo.Exception;

const
  RESOURCE_LOGIN = 'auth/login';

constructor TAplicacaoBDMGServiceAuth.Create(const ARequest: IAplicacaoBDMGServiceRequest;
  const ASession: IAplicacaoBDMGSession);
begin
  FRequest := ARequest;
  FSession := ASession;
end;

procedure TAplicacaoBDMGServiceAuth.Login(const ALogin, ASenha: string);
var
  LBody: TJSONObject;
  LResposta: TJSONValue;
  LToken: string;
begin
  FSession.Encerrar;

  LBody := TJSONObject.Create;
  LBody.AddPair('login', ALogin);
  LBody.AddPair('senha', ASenha);

  LResposta := FRequest.Post(RESOURCE_LOGIN, LBody);
  try
    LToken := EmptyStr;
    if LResposta is TJSONObject then
      LToken := LResposta.GetValue<string>('token', EmptyStr);

    if LToken.IsEmpty then
      raise EAplicacaoBDMGException.Create('O serviço não devolveu o token de acesso.');

    FSession.Iniciar(ALogin, LToken);
  finally
    LResposta.Free;
  end;
end;

class function TAplicacaoBDMGServiceAuth.New(const ARequest: IAplicacaoBDMGServiceRequest;
  const ASession: IAplicacaoBDMGSession): IAplicacaoBDMGServiceAuth;
begin
  Result := Self.Create(ARequest, ASession);
end;

end.
