unit AplicacaoBDMG.DAO.Connection.SQLServer;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Param,
  FireDAC.DApt,
  FireDAC.Phys.MSSQL,
  FireDAC.ConsoleUI.Wait,
  AplicacaoBDMG.DAO.Interfaces;

type
  TAPIAplicacaoBDMGConnectionSQLServer = class(TInterfacedObject, IAPIAplicacaoBDMGConnection)
  private
    FConnection: TFDConnection;
  protected
    function Component: TFDConnection;
    procedure Connect;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IAPIAplicacaoBDMGConnection;

    class procedure ConfigurarPool;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  AplicacaoBDMG.Resources;

const
  CONNECTION_DEF_NAME = 'APLICACAOBDMG_SQLSERVER_POOL';
  DRIVER_ID = 'MSSQL';
  POOL_MAXIMO_CONEXOES = 50;

function TAPIAplicacaoBDMGConnectionSQLServer.Component: TFDConnection;
begin
  Connect;
  Result := FConnection;
end;

class procedure TAPIAplicacaoBDMGConnectionSQLServer.ConfigurarPool;
var
  LParams: TStringList;
begin
  if FDManager.IsConnectionDef(CONNECTION_DEF_NAME) then
    Exit;

  LParams := TStringList.Create;
  try
    LParams.Values['Server'] := APPRESOURCES.DATABASE_HOST;
    LParams.Values['Database'] := APPRESOURCES.DATABASE_NAME;
    if APPRESOURCES.DATABASE_OSAUTHENT then
      LParams.Values['OSAuthent'] := 'Yes'
    else
    begin
      LParams.Values['OSAuthent'] := 'No';
      LParams.Values['User_Name'] := APPRESOURCES.DATABASE_USERNAME;
      LParams.Values['Password'] := APPRESOURCES.DATABASE_PASSWORD;
    end;
    LParams.Values['ApplicationName'] := 'AplicacaoBDMG_api';
    LParams.Values['ODBCAdvanced'] := 'TrustServerCertificate=yes';
    LParams.Values['Pooled'] := 'True';
    LParams.Values['POOL_MaximumItems'] := POOL_MAXIMO_CONEXOES.ToString;

    FDManager.SilentMode := True;
    FDManager.AddConnectionDef(CONNECTION_DEF_NAME, DRIVER_ID, LParams);
    FDManager.Active := True;
  finally
    LParams.Free;
  end;
end;

procedure TAPIAplicacaoBDMGConnectionSQLServer.Connect;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;
end;

constructor TAPIAplicacaoBDMGConnectionSQLServer.Create;
begin
  FConnection := TFDConnection.Create(nil);
  FConnection.ConnectionDefName := CONNECTION_DEF_NAME;
  FConnection.LoginPrompt := False;
end;

destructor TAPIAplicacaoBDMGConnectionSQLServer.Destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TAPIAplicacaoBDMGConnectionSQLServer.New: IAPIAplicacaoBDMGConnection;
begin
  Result := Self.Create;
end;

end.
