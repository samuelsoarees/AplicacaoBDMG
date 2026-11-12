unit AplicacaoBDMG.DAO.Base;

interface

uses
  FireDAC.Comp.Client,
  AplicacaoBDMG.DAO.Interfaces;

type
  TAPIAplicacaoBDMGDAOBase = class(TInterfacedObject)
  protected
    FConnection: IAPIAplicacaoBDMGConnection;

    function NovaQuery(const ASQL: string): TFDQuery;
  public
    constructor Create(AConnection: IAPIAplicacaoBDMGConnection); virtual;
  end;

implementation

constructor TAPIAplicacaoBDMGDAOBase.Create(AConnection: IAPIAplicacaoBDMGConnection);
begin
  FConnection := AConnection;
end;

function TAPIAplicacaoBDMGDAOBase.NovaQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := FConnection.Component;
    Result.SQL.Text := ASQL;
  except
    Result.Free;
    raise;
  end;
end;

end.
