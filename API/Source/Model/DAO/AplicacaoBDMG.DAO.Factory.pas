unit AplicacaoBDMG.DAO.Factory;

interface

uses
  AplicacaoBDMG.DAO.Interfaces;

type
  TAPIAplicacaoBDMGDAOFactory = class(TInterfacedObject, IAPIAplicacaoBDMGDAOFactory)
  private
    FConnection: IAPIAplicacaoBDMGConnection;
    FTarefa: IAPIAplicacaoBDMGDAOTarefa;
    FUsuario: IAPIAplicacaoBDMGDAOUsuario;
  protected
    function Tarefa: IAPIAplicacaoBDMGDAOTarefa;
    function Usuario: IAPIAplicacaoBDMGDAOUsuario;
  public
    constructor Create(AConnection: IAPIAplicacaoBDMGConnection);
    class function New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOFactory;
  end;

implementation

uses
  AplicacaoBDMG.DAO.Tarefa,
  AplicacaoBDMG.DAO.Usuario;

constructor TAPIAplicacaoBDMGDAOFactory.Create(AConnection: IAPIAplicacaoBDMGConnection);
begin
  FConnection := AConnection;
end;

class function TAPIAplicacaoBDMGDAOFactory.New(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOFactory;
begin
  Result := Self.Create(AConnection);
end;

function TAPIAplicacaoBDMGDAOFactory.Tarefa: IAPIAplicacaoBDMGDAOTarefa;
begin
  if not Assigned(FTarefa) then
    FTarefa := TAPIAplicacaoBDMGDAOTarefa.New(FConnection);
  Result := FTarefa;
end;

function TAPIAplicacaoBDMGDAOFactory.Usuario: IAPIAplicacaoBDMGDAOUsuario;
begin
  if not Assigned(FUsuario) then
    FUsuario := TAPIAplicacaoBDMGDAOUsuario.New(FConnection);
  Result := FUsuario;
end;

end.
