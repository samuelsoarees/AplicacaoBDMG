unit AplicacaoBDMG.Modelo.Session;

interface

uses
  JOSE.Core.JWT;

const
  CLAIM_ID_USUARIO = 'idUsuario';

type
  TAPIAplicacaoBDMGModeloSession = class(TJWTClaims)
  private
    function GetIdUsuario: Integer;
    function GetLogin: string;
  public
    property idUsuario: Integer read GetIdUsuario;
    property login: string read GetLogin;
  end;

implementation

uses
  System.JSON;

function TAPIAplicacaoBDMGModeloSession.GetIdUsuario: Integer;
begin
  Result := JSON.GetValue<Integer>(CLAIM_ID_USUARIO, 0);
end;

function TAPIAplicacaoBDMGModeloSession.GetLogin: string;
begin
  Result := Subject;
end;

end.
