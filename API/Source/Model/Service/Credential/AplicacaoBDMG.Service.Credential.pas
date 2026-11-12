unit AplicacaoBDMG.Service.Credential;

interface

uses
  AplicacaoBDMG.Service.Interfaces,
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Modelo.Classes;

type
  TAPIAplicacaoBDMGServiceCredential = class(TInterfacedObject, IAPIAplicacaoBDMGServiceCredential)
  private
    FDAO: IAPIAplicacaoBDMGDAOFactory;
    FCredential: TAPIAplicacaoBDMGModeloCredential;

    function GerarToken(AUsuario: TAPIAplicacaoBDMGModeloUsuario): string;
  protected
    function DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceCredential;
    function Credential(AValue: TAPIAplicacaoBDMGModeloCredential): IAPIAplicacaoBDMGServiceCredential;
    function Execute: TAPIAplicacaoBDMGModeloUsuarioToken;
  public
    class function New: IAPIAplicacaoBDMGServiceCredential;
  end;

implementation

uses
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  System.DateUtils,
  System.SysUtils,
  AplicacaoBDMG.Modelo.Session,
  AplicacaoBDMG.Resources;

function TAPIAplicacaoBDMGServiceCredential.Credential(
  AValue: TAPIAplicacaoBDMGModeloCredential): IAPIAplicacaoBDMGServiceCredential;
begin
  Result := Self;
  FCredential := AValue;
end;

function TAPIAplicacaoBDMGServiceCredential.DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceCredential;
begin
  Result := Self;
  FDAO := AValue;
end;

function TAPIAplicacaoBDMGServiceCredential.Execute: TAPIAplicacaoBDMGModeloUsuarioToken;
var
  LUsuario: TAPIAplicacaoBDMGModeloUsuario;
begin
  if not Assigned(FCredential) then
    raise EArgumentNilException.Create('Credenciais não informadas.');

  LUsuario := FDAO.Usuario.Login(FCredential.login.Trim).Buscar;
  try
    if (not Assigned(LUsuario)) or (not LUsuario.ativo) or
      (not LUsuario.SenhaConfere(FCredential.senha)) then
      raise EAplicacaoBDMGException.NaoAutorizado('CREDENCIAIS_INVALIDAS', 'Login ou senha inválidos.');

    Result := TAPIAplicacaoBDMGModeloUsuarioToken.Create;
    try
      Result.token := GerarToken(LUsuario);
      Result.expiraEm := APPRESOURCES.API_TOKEN_EXPIRACAO;
    except
      Result.Free;
      raise;
    end;
  finally
    LUsuario.Free;
  end;
end;

function TAPIAplicacaoBDMGServiceCredential.GerarToken(AUsuario: TAPIAplicacaoBDMGModeloUsuario): string;
var
  LToken: TJWT;
  LAgora: TDateTime;
begin
  LAgora := Now;
  LToken := TJWT.Create;
  try
    LToken.Claims.Subject := AUsuario.login;
    LToken.Claims.IssuedAt := LAgora;
    LToken.Claims.Expiration := IncSecond(LAgora, APPRESOURCES.API_TOKEN_EXPIRACAO);
    LToken.Claims.SetClaimOfType<Integer>(CLAIM_ID_USUARIO, AUsuario.id);
    Result := TJOSE.SHA256CompactToken(APPRESOURCES.API_SECRETKEY, LToken);
  finally
    LToken.Free;
  end;
end;

class function TAPIAplicacaoBDMGServiceCredential.New: IAPIAplicacaoBDMGServiceCredential;
begin
  Result := Self.Create;
end;

end.
