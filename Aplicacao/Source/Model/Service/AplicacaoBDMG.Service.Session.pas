unit AplicacaoBDMG.Service.Session;

interface

uses
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGServiceSession = class(TInterfacedObject, IAplicacaoBDMGSession)
  private
    FLogin: string;
    FToken: string;
  public
    class function New: IAplicacaoBDMGSession;

    function Login: string;
    function Token: string;
    function Autenticado: Boolean;
    procedure Iniciar(const ALogin, AToken: string);
    procedure Encerrar;
  end;

implementation

uses
  System.SysUtils;

function TAplicacaoBDMGServiceSession.Autenticado: Boolean;
begin
  Result := not FToken.IsEmpty;
end;

procedure TAplicacaoBDMGServiceSession.Encerrar;
begin
  FLogin := EmptyStr;
  FToken := EmptyStr;
end;

procedure TAplicacaoBDMGServiceSession.Iniciar(const ALogin, AToken: string);
begin
  FLogin := ALogin;
  FToken := AToken;
end;

function TAplicacaoBDMGServiceSession.Login: string;
begin
  Result := FLogin;
end;

class function TAplicacaoBDMGServiceSession.New: IAplicacaoBDMGSession;
begin
  Result := Self.Create;
end;

function TAplicacaoBDMGServiceSession.Token: string;
begin
  Result := FToken;
end;

end.
