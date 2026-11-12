unit AplicacaoBDMG.DAO.Interfaces;

interface

uses
  FireDAC.Comp.Client,
  System.Generics.Collections,
  AplicacaoBDMG.Modelo.Classes;

type
  IAPIAplicacaoBDMGConnection = interface
    ['{5F1B6C1A-6E0F-4E7B-9C0B-2B7B0A6C5D11}']
    function Component: TFDConnection;
    procedure Connect;
  end;

  IAPIAplicacaoBDMGDAOTarefa = interface
    ['{B4C2F2B3-0C0A-4B0E-9B0D-7D9A3C1E2F22}']
    function IdTarefa(AValue: Integer): IAPIAplicacaoBDMGDAOTarefa;
    function Tarefa(AValue: TAPIAplicacaoBDMGModeloTarefaNova): IAPIAplicacaoBDMGDAOTarefa;
    function Status(AValue: TAPIAplicacaoBDMGStatus): IAPIAplicacaoBDMGDAOTarefa;

    function Listar: TObjectList<TAPIAplicacaoBDMGModeloTarefa>;
    function Inserir: TAPIAplicacaoBDMGModeloTarefa;
    function AtualizarStatus: TAPIAplicacaoBDMGModeloTarefa;
    function Deletar: Boolean;
    function Estatisticas: TAPIAplicacaoBDMGModeloEstatisticas;
  end;

  IAPIAplicacaoBDMGDAOUsuario = interface
    ['{C7D3A4E5-1D1B-4C1F-8A1E-8E0B4D2F3A33}']
    function Login(const AValue: string): IAPIAplicacaoBDMGDAOUsuario;

    function Buscar: TAPIAplicacaoBDMGModeloUsuario;
  end;

  IAPIAplicacaoBDMGDAOFactory = interface
    ['{D8E4B5F6-2E2C-4D20-9B2F-9F1C5E3A4B44}']
    function Tarefa: IAPIAplicacaoBDMGDAOTarefa;
    function Usuario: IAPIAplicacaoBDMGDAOUsuario;
  end;

function Factory(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOFactory;

implementation

uses
  AplicacaoBDMG.DAO.Factory;

function Factory(AConnection: IAPIAplicacaoBDMGConnection): IAPIAplicacaoBDMGDAOFactory;
begin
  Result := TAPIAplicacaoBDMGDAOFactory.New(AConnection);
end;

end.
