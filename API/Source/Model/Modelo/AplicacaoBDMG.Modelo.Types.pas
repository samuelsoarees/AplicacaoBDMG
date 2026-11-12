unit AplicacaoBDMG.Modelo.Types;

interface

{$SCOPEDENUMS ON}

type
  TAPIAplicacaoBDMGStatus = (Pendente, EmAndamento, Concluida);

  TAPIAplicacaoBDMGStatusHelper = record helper for TAPIAplicacaoBDMGStatus
  public
    function ToString: string;
    class function FromString(const AValue: string): TAPIAplicacaoBDMGStatus; static;
    class function ValoresAceitos: string; static;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  AplicacaoBDMG.Modelo.Exception;

class function TAPIAplicacaoBDMGStatusHelper.FromString(const AValue: string): TAPIAplicacaoBDMGStatus;
var
  LOrdinal: Integer;
begin
  LOrdinal := GetEnumValue(TypeInfo(TAPIAplicacaoBDMGStatus), AValue.Trim);
  if LOrdinal < 0 then
    raise EAplicacaoBDMGException.Validacao('STATUS_INVALIDO',
      'Status "%s" inválido. Valores aceitos: %s.', [AValue, ValoresAceitos]);
  Result := TAPIAplicacaoBDMGStatus(LOrdinal);
end;

function TAPIAplicacaoBDMGStatusHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TAPIAplicacaoBDMGStatus), Ord(Self));
end;

class function TAPIAplicacaoBDMGStatusHelper.ValoresAceitos: string;
var
  LStatus: TAPIAplicacaoBDMGStatus;
begin
  Result := EmptyStr;
  for LStatus := Low(TAPIAplicacaoBDMGStatus) to High(TAPIAplicacaoBDMGStatus) do
  begin
    if not Result.IsEmpty then
      Result := Result + ', ';
    Result := Result + LStatus.ToString;
  end;
end;

end.
