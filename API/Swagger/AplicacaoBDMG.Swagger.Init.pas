unit AplicacaoBDMG.Swagger.Init;

interface

uses
  Horse.GBSwagger,
  GBSwagger.Model.Interfaces,
  AplicacaoBDMG.Modelo.Classes,
  AplicacaoBDMG.View.API;

implementation

initialization
  Swagger
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    .BasePath(PrefixoURL)
    .Info
      .Title('API de Tarefas')
      .Description('Serviço REST para gerenciamento de tarefas - Teste prático Desenvolvedor Delphi. ' +
        'Faça login em /auth/login e informe "Bearer <token>" no botão Authorize.')
      .Version('1.0.0')
    .&End
  .&End;

  Swagger
    .Config
      .ClassPrefixes('TAPIAplicacaoBDMGModelo')
      .Language('pt-BR')
    .&End
    .&Register
      .SchemaOnError(TAPIAplicacaoBDMGModeloError)
    .&End;

end.
