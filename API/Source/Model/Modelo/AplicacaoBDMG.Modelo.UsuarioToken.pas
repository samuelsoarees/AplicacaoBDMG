unit AplicacaoBDMG.Modelo.UsuarioToken;

interface

uses
  GBSwagger.Model.Attributes;

type
  TAPIAplicacaoBDMGModeloUsuarioToken = class
  private
    Ftoken: string;
    FexpiraEm: Integer;
  public
    [SwagProp('token', 'Token JWT a ser enviado no header Authorization: Bearer <token>', False)]
    property token: string read Ftoken write Ftoken;
    [SwagProp('expiraEm', 'Validade do token em segundos', False)]
    property expiraEm: Integer read FexpiraEm write FexpiraEm;
  end;

implementation

end.
