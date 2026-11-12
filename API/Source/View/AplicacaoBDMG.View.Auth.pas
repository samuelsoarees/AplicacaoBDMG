unit AplicacaoBDMG.View.Auth;

interface

uses
  Horse.GBSwagger,
  GBSwagger.Path.Attributes,
  AplicacaoBDMG.View.Base,
  AplicacaoBDMG.Modelo.Classes;

type
  [SwagPath('auth', 'Autenticação')]
  TAPIAplicacaoBDMGViewAuth = class(TAPIAplicacaoBDMGViewBase<TAPIAplicacaoBDMGModeloCredential>)
  public
    [SwagPOST('login', 'Autenticar e obter o token JWT', True)]
    [SwagParamBody('credenciais', TAPIAplicacaoBDMGModeloCredential)]
    [SwagResponse(200, TAPIAplicacaoBDMGModeloUsuarioToken)]
    [SwagResponse(400, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(401, TAPIAplicacaoBDMGModeloError)]
    [SwagResponse(500, TAPIAplicacaoBDMGModeloError)]
    procedure Login;

    class procedure Registry; reintroduce;
  end;

implementation

procedure TAPIAplicacaoBDMGViewAuth.Login;
var
  LToken: TAPIAplicacaoBDMGModeloUsuarioToken;
begin
  FModel := FromBody<TAPIAplicacaoBDMGModeloCredential>;

  LToken := Controller
              .Service
                .Credential
                  .Credential(FModel)
                .Execute;

  ResponseOf<TAPIAplicacaoBDMGModeloUsuarioToken>(LToken);
end;

class procedure TAPIAplicacaoBDMGViewAuth.Registry;
begin
  THorseGBSwaggerRegister.RegisterPath(Self);
end;

end.
