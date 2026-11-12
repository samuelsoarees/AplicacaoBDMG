unit AplicacaoBDMG.View.Ping;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils;

type
  TAPIAplicacaoBDMGViewPing = class
  public
    class procedure Registry(const APrefixo: string);
  end;

implementation

uses
  AplicacaoBDMG.DAO.Interfaces,
  AplicacaoBDMG.DAO.Connection.Factory;

procedure Ping(AReq: THorseRequest; ARes: THorseResponse);
var
  LConnection: IAPIAplicacaoBDMGConnection;
begin
  if AReq.Query.ContainsKey('connect') then
  begin
    LConnection := TAPIAplicacaoBDMGConnectionFactory.New;
    LConnection.Connect;
  end;
  ARes.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'pong'));
end;

class procedure TAPIAplicacaoBDMGViewPing.Registry(const APrefixo: string);
begin
  THorse.Get(APrefixo + 'ping', Ping);
end;

end.
