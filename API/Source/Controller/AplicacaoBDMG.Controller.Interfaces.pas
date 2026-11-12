unit AplicacaoBDMG.Controller.Interfaces;

interface

uses
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Service.Interfaces;

type
  IAPIAplicacaoBDMGController = interface
    ['{0B17E8C9-5B5F-4053-8E52-C24F8B6D7E77}']
    function DAO: IAPIAplicacaoBDMGDAOFactory;
    function Service: IAPIAplicacaoBDMGServiceFactory;
  end;

function CreateController: IAPIAplicacaoBDMGController;

implementation

uses
  AplicacaoBDMG.Controller;

function CreateController: IAPIAplicacaoBDMGController;
begin
  Result := TAPIAplicacaoBDMGController.New;
end;

end.
