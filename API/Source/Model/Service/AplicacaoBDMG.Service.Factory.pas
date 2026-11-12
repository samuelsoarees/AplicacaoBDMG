unit AplicacaoBDMG.Service.Factory;

interface

uses
  AplicacaoBDMG.Service.Interfaces,
  AplicacaoBDMG.DAO.Interfaces;

type
  TAPIAplicacaoBDMGServiceFactory = class(TInterfacedObject, IAPIAplicacaoBDMGServiceFactory)
  private
    FDAO: IAPIAplicacaoBDMGDAOFactory;
    FCredential: IAPIAplicacaoBDMGServiceCredential;
  protected
    function DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceFactory;
    function Credential: IAPIAplicacaoBDMGServiceCredential;
  public
    class function New: IAPIAplicacaoBDMGServiceFactory;
  end;

implementation

uses
  AplicacaoBDMG.Service.Credential;

function TAPIAplicacaoBDMGServiceFactory.Credential: IAPIAplicacaoBDMGServiceCredential;
begin
  if not Assigned(FCredential) then
  begin
    FCredential := TAPIAplicacaoBDMGServiceCredential.New;
    FCredential.DAO(FDAO);
  end;
  Result := FCredential;
end;

function TAPIAplicacaoBDMGServiceFactory.DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceFactory;
begin
  Result := Self;
  FDAO := AValue;
end;

class function TAPIAplicacaoBDMGServiceFactory.New: IAPIAplicacaoBDMGServiceFactory;
begin
  Result := Self.Create;
end;

end.
