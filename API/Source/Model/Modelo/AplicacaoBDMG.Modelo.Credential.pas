unit AplicacaoBDMG.Modelo.Credential;

interface

uses
  GBSwagger.Model.Attributes;

type
  TAPIAplicacaoBDMGModeloCredential = class
  private
    Flogin: string;
    Fsenha: string;
  public
    [SwagRequired]
    [SwagProp('login', 'Login do usuário', True)]
    property login: string read Flogin write Flogin;

    [SwagRequired]
    [SwagProp('senha', 'Senha do usuário', True)]
    property senha: string read Fsenha write Fsenha;
  end;

implementation

end.
