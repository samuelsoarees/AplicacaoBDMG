unit AplicacaoBDMG.View.API;

interface

uses
  Horse,
  Horse.Jhonson,
  Horse.JWT,
  Horse.CORS,
  Horse.GBSwagger,
  System.JSON,
  System.SysUtils,
  AplicacaoBDMG.Resources,
  AplicacaoBDMG.Modelo.Classes;

const
  VERSAO = 'v1';
  API_PORT = 9090;

function PrefixoURL: string;
procedure CreateServer;
procedure StartServer;
procedure StopServer;

implementation

uses
  AplicacaoBDMG.Middleware.Exception,
  AplicacaoBDMG.DAO.Connection.Factory,
  AplicacaoBDMG.View.Ping,
  AplicacaoBDMG.View.Auth,
  AplicacaoBDMG.View.Tarefa;

function PrefixoURL: string;
begin
  Result := Format('%s/', [VERSAO]);
end;

procedure ResponderNaoAutorizado(const AResponse: THorseResponse; const AMessage: string;
  const AStatus: THTTPStatus);
begin
  AResponse
    .Send<TJSONObject>(CriarJSONErro('Token de acesso ausente, inválido ou expirado.', 'NAO_AUTORIZADO'))
    .Status(AStatus);
end;

procedure HabilitarAutenticacao;
var
  LOnResponse: TOnResponse;
begin
  LOnResponse := ResponderNaoAutorizado;

  Swagger
    .AddBearerSecurity
      .AddCallback(HorseJWT(APPRESOURCES.API_SECRETKEY,
          THorseJWTConfig.New
            .IsRequiredSubject(True)
            .IsRequiredExpirationTime(True)
            .SessionClass(TAPIAplicacaoBDMGModeloSession)
            .OnResponse(LOnResponse)));
end;

procedure CreateServer;
begin
  TAPIAplicacaoBDMGConnectionFactory.Configurar;

  THorse
    .Use(CORS)
    .Use(HorseSwagger(PrefixoURL + 'swagger/doc/html', PrefixoURL + 'swagger/doc/json'));

  HabilitarAutenticacao;

  THorse
    .Use(Jhonson)
    .Use(AplicacaoBDMGException);

  TAPIAplicacaoBDMGViewPing.Registry(PrefixoURL);
  TAPIAplicacaoBDMGViewAuth.Registry;
  TAPIAplicacaoBDMGViewTarefa.Registry;
end;

procedure StartServer;
begin
  THorse.Listen(API_PORT,
    procedure
    begin
      Writeln(Format('API de Tarefas em execução na porta %d', [THorse.Port]));
      Writeln(Format('Swagger: http://localhost:%d/%sswagger/doc/html', [THorse.Port, PrefixoURL]));
      Writeln('Pressione ENTER para encerrar.');
      Readln;
      StopServer;
    end);
end;

procedure StopServer;
begin
  THorse.StopListen;
end;

end.
