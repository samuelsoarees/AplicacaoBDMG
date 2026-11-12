unit AplicacaoBDMG.Service.Interfaces;

interface

uses
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.Modelo.Classes;

type
  IAPIAplicacaoBDMGServiceCredential = interface
    ['{E9F5C6A7-3F3D-4E31-8C30-A02D6F4B5C55}']
    function DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceCredential;
    function Credential(AValue: TAPIAplicacaoBDMGModeloCredential): IAPIAplicacaoBDMGServiceCredential;

    function Execute: TAPIAplicacaoBDMGModeloUsuarioToken;
  end;

  IAPIAplicacaoBDMGServiceFactory = interface
    ['{FA06D7B8-4A4E-4F42-9D41-B13E7A5C6D66}']
    function DAO(AValue: IAPIAplicacaoBDMGDAOFactory): IAPIAplicacaoBDMGServiceFactory;
    function Credential: IAPIAplicacaoBDMGServiceCredential;
  end;

implementation

end.
