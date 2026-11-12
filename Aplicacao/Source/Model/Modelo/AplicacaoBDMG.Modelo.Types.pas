unit AplicacaoBDMG.Modelo.Types;

interface

{$SCOPEDENUMS ON}

type
  TAplicacaoBDMGStatus = (Pendente, EmAndamento, Concluida);

  TAplicacaoBDMGStatusHelper = record helper for TAplicacaoBDMGStatus
  public
    function ToString: string;
    function Descricao: string;
    class function FromString(const AValue: string): TAplicacaoBDMGStatus; static;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  AplicacaoBDMG.Modelo.Exception;

const
  DESCRICOES: array[TAplicacaoBDMGStatus] of string = ('Pendente', 'Em andamento', 'Concluída');

function TAplicacaoBDMGStatusHelper.Descricao: string;
begin
  Result := DESCRICOES[Self];
end;

class function TAplicacaoBDMGStatusHelper.FromString(const AValue: string): TAplicacaoBDMGStatus;
var
  LOrdinal: Integer;
begin
  LOrdinal := GetEnumValue(TypeInfo(TAplicacaoBDMGStatus), AValue.Trim);
  if LOrdinal < 0 then
    raise EAplicacaoBDMGException.CreateFmt('Status "%s" desconhecido.', [AValue]);
  Result := TAplicacaoBDMGStatus(LOrdinal);
end;

function TAplicacaoBDMGStatusHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TAplicacaoBDMGStatus), Ord(Self));
end;

end.
