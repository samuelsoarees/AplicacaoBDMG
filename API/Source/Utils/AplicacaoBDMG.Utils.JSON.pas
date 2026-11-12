unit AplicacaoBDMG.Utils.JSON;

interface

uses
  System.JSON,
  System.Rtti,
  System.Generics.Collections,
  AplicacaoBDMG.Modelo.Exception;

type
  TAPIAplicacaoBDMGUtilsJSON = class
  private
    class var FContext: TRttiContext;

    class function IsDateTime(AProperty: TRttiProperty): Boolean;
    class function IsBoolean(AProperty: TRttiProperty): Boolean;
    class function IsRequired(AProperty: TRttiProperty): Boolean;
    class function IsSerializable(AProperty: TRttiProperty): Boolean;
    class function PropertyToJSON(AObject: TObject; AProperty: TRttiProperty): TJSONValue;
    class procedure JSONToProperty(AObject: TObject; AProperty: TRttiProperty; AValue: TJSONValue);
    class procedure RaiseTipoInvalido(AProperty: TRttiProperty; const ATipoEsperado: string);
  public
    class function ObjectToJSON(AObject: TObject): TJSONObject;
    class function ListToJSON<T: class>(AList: TObjectList<T>): TJSONArray;

    class procedure JSONToObject(AJSON: TJSONObject; AObject: TObject);
    class function StringToObject<T: class, constructor>(const AJSON: string): T;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  System.DateUtils,
  GBSwagger.Model.Attributes;

class function TAPIAplicacaoBDMGUtilsJSON.IsBoolean(AProperty: TRttiProperty): Boolean;
begin
  Result := AProperty.PropertyType.Handle = TypeInfo(Boolean);
end;

class function TAPIAplicacaoBDMGUtilsJSON.IsDateTime(AProperty: TRttiProperty): Boolean;
begin
  Result := (AProperty.PropertyType.Handle = TypeInfo(TDateTime)) or
    (AProperty.PropertyType.Handle = TypeInfo(TDate));
end;

class function TAPIAplicacaoBDMGUtilsJSON.IsRequired(AProperty: TRttiProperty): Boolean;
var
  LAttribute: TCustomAttribute;
begin
  Result := False;
  for LAttribute in AProperty.GetAttributes do
  begin
    if LAttribute is SwagRequired then
      Exit(True);
    if (LAttribute is SwagProp) and SwagProp(LAttribute).Required then
      Exit(True);
  end;
end;

class function TAPIAplicacaoBDMGUtilsJSON.IsSerializable(AProperty: TRttiProperty): Boolean;
begin
  Result := (AProperty.Visibility in [mvPublic, mvPublished]) and
    (AProperty.PropertyType.TypeKind in [tkInteger, tkInt64, tkFloat, tkEnumeration,
      tkUString, tkString, tkLString, tkWString]);
end;

class procedure TAPIAplicacaoBDMGUtilsJSON.JSONToObject(AJSON: TJSONObject; AObject: TObject);
var
  LProperty: TRttiProperty;
  LValue: TJSONValue;
begin
  for LProperty in FContext.GetType(AObject.ClassType).GetProperties do
  begin
    if (not IsSerializable(LProperty)) or (not LProperty.IsWritable) then
      Continue;

    LValue := AJSON.GetValue(LProperty.Name);
    if (not Assigned(LValue)) or (LValue is TJSONNull) then
    begin
      if IsRequired(LProperty) then
        raise EAplicacaoBDMGException.Validacao(CODIGO_REQUISICAO_INVALIDA,
          'A propriedade %s é obrigatória.', [LProperty.Name]);
      Continue;
    end;

    JSONToProperty(AObject, LProperty, LValue);
  end;
end;

class procedure TAPIAplicacaoBDMGUtilsJSON.JSONToProperty(AObject: TObject; AProperty: TRttiProperty;
  AValue: TJSONValue);
var
  LInteger: Int64;
  LFloat: Double;
  LBoolean: Boolean;
  LDateTime: TDateTime;
  LOrdinal: Integer;
begin
  case AProperty.PropertyType.TypeKind of
    tkInteger, tkInt64:
      begin
        if (not (AValue is TJSONNumber)) or (not TryStrToInt64(AValue.Value, LInteger)) then
          RaiseTipoInvalido(AProperty, 'um número inteiro');
        AProperty.SetValue(AObject, TValue.FromOrdinal(AProperty.PropertyType.Handle, LInteger));
      end;
    tkFloat:
      begin
        if IsDateTime(AProperty) then
        begin
          if not TryISO8601ToDate(AValue.Value, LDateTime, False) then
            RaiseTipoInvalido(AProperty, 'uma data no formato ISO 8601');
          AProperty.SetValue(AObject, TValue.From<TDateTime>(LDateTime));
        end
        else
        begin
          if (not (AValue is TJSONNumber)) or (not AValue.TryGetValue<Double>(LFloat)) then
            RaiseTipoInvalido(AProperty, 'um número');
          AProperty.SetValue(AObject, TValue.From<Double>(LFloat));
        end;
      end;
    tkEnumeration:
      begin
        if IsBoolean(AProperty) then
        begin
          if not AValue.TryGetValue<Boolean>(LBoolean) then
            RaiseTipoInvalido(AProperty, 'true ou false');
          AProperty.SetValue(AObject, TValue.From<Boolean>(LBoolean));
        end
        else
        begin
          LOrdinal := GetEnumValue(AProperty.PropertyType.Handle, AValue.Value.Trim);
          if (LOrdinal < 0) or (AValue is TJSONNumber) then
            RaiseTipoInvalido(AProperty, 'um dos valores: ' +
              string.Join(', ', TRttiEnumerationType(AProperty.PropertyType).GetNames));
          AProperty.SetValue(AObject, TValue.FromOrdinal(AProperty.PropertyType.Handle, LOrdinal));
        end;
      end;
  else
    begin
      if (not (AValue is TJSONString)) or (AValue is TJSONNumber) then
        RaiseTipoInvalido(AProperty, 'um texto');
      AProperty.SetValue(AObject, TValue.From<string>(AValue.Value));
    end;
  end;
end;

class function TAPIAplicacaoBDMGUtilsJSON.ListToJSON<T>(AList: TObjectList<T>): TJSONArray;
var
  LItem: T;
begin
  Result := TJSONArray.Create;
  try
    if Assigned(AList) then
      for LItem in AList do
        Result.AddElement(ObjectToJSON(LItem));
  except
    Result.Free;
    raise;
  end;
end;

class function TAPIAplicacaoBDMGUtilsJSON.ObjectToJSON(AObject: TObject): TJSONObject;
var
  LProperty: TRttiProperty;
begin
  Result := TJSONObject.Create;
  try
    if not Assigned(AObject) then
      Exit;

    for LProperty in FContext.GetType(AObject.ClassType).GetProperties do
    begin
      if IsSerializable(LProperty) and LProperty.IsReadable then
        Result.AddPair(LProperty.Name, PropertyToJSON(AObject, LProperty));
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TAPIAplicacaoBDMGUtilsJSON.PropertyToJSON(AObject: TObject; AProperty: TRttiProperty): TJSONValue;
var
  LValue: TValue;
begin
  LValue := AProperty.GetValue(AObject);
  case AProperty.PropertyType.TypeKind of
    tkInteger, tkInt64:
      Result := TJSONNumber.Create(LValue.AsInt64);
    tkFloat:
      begin
        if not IsDateTime(AProperty) then
          Exit(TJSONNumber.Create(LValue.AsExtended));

        if LValue.AsExtended = 0 then
          Result := TJSONNull.Create
        else
          Result := TJSONString.Create(DateToISO8601(LValue.AsExtended, False));
      end;
    tkEnumeration:
      begin
        if IsBoolean(AProperty) then
          Result := TJSONBool.Create(LValue.AsBoolean)
        else
          Result := TJSONString.Create(GetEnumName(LValue.TypeInfo, LValue.AsOrdinal));
      end;
  else
    Result := TJSONString.Create(LValue.AsString);
  end;
end;

class procedure TAPIAplicacaoBDMGUtilsJSON.RaiseTipoInvalido(AProperty: TRttiProperty; const ATipoEsperado: string);
begin
  raise EAplicacaoBDMGException.Validacao(CODIGO_REQUISICAO_INVALIDA,
    'A propriedade %s deve ser %s.', [AProperty.Name, ATipoEsperado]);
end;

class function TAPIAplicacaoBDMGUtilsJSON.StringToObject<T>(const AJSON: string): T;
var
  LJSONValue: TJSONValue;
begin
  LJSONValue := TJSONObject.ParseJSONValue(AJSON);
  try
    if not (LJSONValue is TJSONObject) then
      raise EAplicacaoBDMGException.Validacao(CODIGO_REQUISICAO_INVALIDA,
        'Corpo da requisição inválido: era esperado um objeto JSON. ' +
        'Consulte na documentação os parâmetros esperados pela API.');

    Result := T.Create;
    try
      JSONToObject(TJSONObject(LJSONValue), Result);
    except
      Result.Free;
      raise;
    end;
  finally
    LJSONValue.Free;
  end;
end;

end.
