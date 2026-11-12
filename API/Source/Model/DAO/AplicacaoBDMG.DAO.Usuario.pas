unit AplicacaoBDMG.DAO.Usuario;

interface

uses
  AplicacaoBDMG.DAO.Base,
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Modelo.Classes;

type
  TAPIAplicacaoBDMGDAOUsuario = class(TAPIAplicacaoBDMGDAOBase, IAPIAplicacaoBDMGDAOUsuario)
  private
    FLogin: string;
  protected
    function Login(const AValue: string): IAPIAplicacaoBDMGDAOUsuario;
    function Buscar: TAPIAplicacaoBDMGModeloUsuario;
  public
    class function New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOUsuario;
  end;

implementation

uses
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  AplicacaoBDMG.DAO.SQL;

function TAPIAplicacaoBDMGDAOUsuario.Buscar: TAPIAplicacaoBDMGModeloUsuario;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := NovaQuery(TAPIAplicacaoBDMGDAOSQL.GetSqlBuscarUsuario);
  try
    LQuery.ParamByName('login').AsString := FLogin;
    LQuery.Open;
    if LQuery.IsEmpty then
      Exit;

    Result := TAPIAplicacaoBDMGModeloUsuario.Create;
    try
      Result.id := LQuery.FieldByName('Id').AsInteger;
      Result.login := LQuery.FieldByName('Login').AsString;
      Result.senhaHash := LQuery.FieldByName('SenhaHash').AsString;
      Result.salt := LQuery.FieldByName('Salt').AsString;
      Result.ativo := LQuery.FieldByName('Ativo').AsBoolean;
    except
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAPIAplicacaoBDMGDAOUsuario.Login(const AValue: string): IAPIAplicacaoBDMGDAOUsuario;
begin
  Result := Self;
  FLogin := AValue;
end;

class function TAPIAplicacaoBDMGDAOUsuario.New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOUsuario;
begin
  Result := Self.Create(AConnection);
end;

end.
