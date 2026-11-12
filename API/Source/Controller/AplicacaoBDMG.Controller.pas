unit AplicacaoBDMG.Controller;

interface

uses
  AplicacaoBDMG.Controller.Interfaces,
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Service.Interfaces;

type
  TAPIAplicacaoBDMGController = class(TInterfacedObject, IAPIAplicacaoBDMGController)
  private
    FConnection: IAPIAplicacaoBDMGConnection;
    FDAO: IAPIAplicacaoBDMGDAOFactory;
    FService: IAPIAplicacaoBDMGServiceFactory;
    function Connection: IAPIAplicacaoBDMGConnection;
  protected
    function DAO: IAPIAplicacaoBDMGDAOFactory;
    function Service: IAPIAplicacaoBDMGServiceFactory;
  public
    class function New: IAPIAplicacaoBDMGController;
  end;

implementation

uses
  AplicacaoBDMG.DAO.Connection.Factory,
  AplicacaoBDMG.Service.Factory;

function TAPIAplicacaoBDMGController.Connection: IAPIAplicacaoBDMGConnection;
begin
  if not Assigned(FConnection) then
    FConnection := TAPIAplicacaoBDMGConnectionFactory.New;
  Result := FConnection;
end;

function TAPIAplicacaoBDMGController.DAO: IAPIAplicacaoBDMGDAOFactory;
begin
  if not Assigned(FDAO) then
    FDAO := AplicacaoBDMG.DAO.Interfaces.Factory(Connection);
  Result := FDAO;
end;

class function TAPIAplicacaoBDMGController.New: IAPIAplicacaoBDMGController;
begin
  Result := Self.Create;
end;

function TAPIAplicacaoBDMGController.Service: IAPIAplicacaoBDMGServiceFactory;
begin
  if not Assigned(FService) then
  begin
    FService := TAPIAplicacaoBDMGServiceFactory.New;
    FService.DAO(DAO);
  end;
  Result := FService;
end;

end.
