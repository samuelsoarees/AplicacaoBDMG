unit AplicacaoBDMG.Modelo.Usuario;

interface

type
  TAPIAplicacaoBDMGModeloUsuario = class
  private
    Fid: Integer;
    Flogin: string;
    FsenhaHash: string;
    Fsalt: string;
    Fativo: Boolean;
  public
    function SenhaConfere(const ASenha: string): Boolean;
    class function GerarHash(const ASalt, ASenha: string): string;

    property id: Integer read Fid write Fid;
    property login: string read Flogin write Flogin;
    property senhaHash: string read FsenhaHash write FsenhaHash;
    property salt: string read Fsalt write Fsalt;
    property ativo: Boolean read Fativo write Fativo;
  end;

implementation

uses
  System.Hash,
  System.SysUtils;

class function TAPIAplicacaoBDMGModeloUsuario.GerarHash(const ASalt, ASenha: string): string;
begin
  Result := THashSHA2.GetHashString(ASalt + ASenha, THashSHA2.TSHA2Version.SHA256);
end;

function TAPIAplicacaoBDMGModeloUsuario.SenhaConfere(const ASenha: string): Boolean;
begin
  Result := SameText(GerarHash(Fsalt, ASenha), FsenhaHash);
end;

end.
