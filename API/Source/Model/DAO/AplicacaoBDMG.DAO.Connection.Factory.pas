unit AplicacaoBDMG.DAO.Connection.Factory;

interface

uses
  AplicacaoBDMG.DAO.Interfaces;

type
  TAPIAplicacaoBDMGDriver = (SQLServer);

  TAPIAplicacaoBDMGConnectionFactory = class
  public
    class procedure Configurar(ADriver: TAPIAplicacaoBDMGDriver = TAPIAplicacaoBDMGDriver.SQLServer);
    class function New(ADriver: TAPIAplicacaoBDMGDriver = TAPIAplicacaoBDMGDriver.SQLServer): IAPIAplicacaoBDMGConnection;
  end;

implementation

uses
  System.SysUtils,
  AplicacaoBDMG.DAO.Connection.SQLServer;

class procedure TAPIAplicacaoBDMGConnectionFactory.Configurar(ADriver: TAPIAplicacaoBDMGDriver);
begin
  case ADriver of
    TAPIAplicacaoBDMGDriver.SQLServer:
      TAPIAplicacaoBDMGConnectionSQLServer.ConfigurarPool;
  else
    raise ENotSupportedException.Create('Driver de banco de dados não suportado.');
  end;
end;

class function TAPIAplicacaoBDMGConnectionFactory.New(ADriver: TAPIAplicacaoBDMGDriver): IAPIAplicacaoBDMGConnection;
begin
  case ADriver of
    TAPIAplicacaoBDMGDriver.SQLServer:
      Result := TAPIAplicacaoBDMGConnectionSQLServer.New;
  else
    raise ENotSupportedException.Create('Driver de banco de dados não suportado.');
  end;
end;

end.
