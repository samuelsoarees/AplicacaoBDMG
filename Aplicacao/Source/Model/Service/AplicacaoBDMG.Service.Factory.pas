unit AplicacaoBDMG.Service.Factory;

interface

uses
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGServiceFactory = class(TInterfacedObject, IAplicacaoBDMGServiceFactory)
  private
    FBaseURL: string;
    FSession: IAplicacaoBDMGSession;
    FRequest: IAplicacaoBDMGServiceRequest;
  public
    constructor Create(const ABaseURL: string; ATimeout: Integer);
    class function New(const ABaseURL: string; ATimeout: Integer): IAplicacaoBDMGServiceFactory;

    function BaseURL: string;
    function Session: IAplicacaoBDMGSession;
    function Auth: IAplicacaoBDMGServiceAuth;
    function Tarefa: IAplicacaoBDMGServiceTarefa;
  end;

implementation

uses
  AplicacaoBDMG.Service.Session,
  AplicacaoBDMG.Service.Request,
  AplicacaoBDMG.Service.Auth,
  AplicacaoBDMG.Service.Tarefa;

function TAplicacaoBDMGServiceFactory.Auth: IAplicacaoBDMGServiceAuth;
begin
  Result := TAplicacaoBDMGServiceAuth.New(FRequest, FSession);
end;

function TAplicacaoBDMGServiceFactory.BaseURL: string;
begin
  Result := FBaseURL;
end;

constructor TAplicacaoBDMGServiceFactory.Create(const ABaseURL: string; ATimeout: Integer);
begin
  FBaseURL := ABaseURL;
  FSession := TAplicacaoBDMGServiceSession.New;
  FRequest := TAplicacaoBDMGServiceRequest.New(ABaseURL, ATimeout, FSession);
end;

class function TAplicacaoBDMGServiceFactory.New(const ABaseURL: string;
  ATimeout: Integer): IAplicacaoBDMGServiceFactory;
begin
  Result := Self.Create(ABaseURL, ATimeout);
end;

function TAplicacaoBDMGServiceFactory.Session: IAplicacaoBDMGSession;
begin
  Result := FSession;
end;

function TAplicacaoBDMGServiceFactory.Tarefa: IAplicacaoBDMGServiceTarefa;
begin
  Result := TAplicacaoBDMGServiceTarefa.New(FRequest);
end;

end.
