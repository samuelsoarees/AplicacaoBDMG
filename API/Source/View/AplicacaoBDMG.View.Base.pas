unit AplicacaoBDMG.View.Base;

interface

uses
  Horse,
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  AplicacaoBDMG.Modelo.Classes,
  AplicacaoBDMG.Controller.Interfaces;

type
  THorseRequest = Horse.THorseRequest;
  THorseResponse = Horse.THorseResponse;

  TAPIAplicacaoBDMGViewBase<T: class, constructor> = class
  private
    FRequest: THorseRequest;
    FResponse: THorseResponse;
    FController: IAPIAplicacaoBDMGController;
  protected
    FModel: T;
    FList: TObjectList<T>;

    function Request: THorseRequest;
    function Session: TAPIAplicacaoBDMGModeloSession;
    function Controller: IAPIAplicacaoBDMGController;

    function FromBody<M: class, constructor>(AValidate: Boolean = True): M;
    procedure ValidateModel(AValue: TObject);

    function Response: THorseResponse; overload;
    function Response(AValue: T): THorseResponse; overload;
    function Response(AValue: TObjectList<T>): THorseResponse; overload;
    function ResponseOf<M: class>(AValue: M; AOwner: Boolean = True): THorseResponse;
  public
    constructor Create(ARequest: THorseRequest; AResponse: THorseResponse); virtual;
    destructor Destroy; override;
  end;

implementation

uses
  GBSwagger.Validator.Interfaces,
  AplicacaoBDMG.Modelo.Exception,
  AplicacaoBDMG.Utils.JSON;

function TAPIAplicacaoBDMGViewBase<T>.Controller: IAPIAplicacaoBDMGController;
begin
  if not Assigned(FController) then
    FController := CreateController;
  Result := FController;
end;

constructor TAPIAplicacaoBDMGViewBase<T>.Create(ARequest: THorseRequest; AResponse: THorseResponse);
begin
  FRequest := ARequest;
  FResponse := AResponse;
end;

destructor TAPIAplicacaoBDMGViewBase<T>.Destroy;
begin
  FModel.Free;
  FList.Free;
  inherited;
end;

function TAPIAplicacaoBDMGViewBase<T>.FromBody<M>(AValidate: Boolean): M;
begin
  Result := TAPIAplicacaoBDMGUtilsJSON.StringToObject<M>(FRequest.Body);
  if AValidate then
  begin
    try
      ValidateModel(Result);
    except
      Result.Free;
      raise;
    end;
  end;
end;

function TAPIAplicacaoBDMGViewBase<T>.Request: THorseRequest;
begin
  Result := FRequest;
end;

function TAPIAplicacaoBDMGViewBase<T>.Response: THorseResponse;
begin
  Result := FResponse;
end;

function TAPIAplicacaoBDMGViewBase<T>.Response(AValue: TObjectList<T>): THorseResponse;
begin
  Result := FResponse;
  Result.Send<TJSONArray>(TAPIAplicacaoBDMGUtilsJSON.ListToJSON<T>(AValue));
end;

function TAPIAplicacaoBDMGViewBase<T>.Response(AValue: T): THorseResponse;
begin
  Result := FResponse;
  Result.Send<TJSONObject>(TAPIAplicacaoBDMGUtilsJSON.ObjectToJSON(AValue));
end;

function TAPIAplicacaoBDMGViewBase<T>.ResponseOf<M>(AValue: M; AOwner: Boolean): THorseResponse;
begin
  Result := FResponse;
  try
    Result.Send<TJSONObject>(TAPIAplicacaoBDMGUtilsJSON.ObjectToJSON(AValue));
  finally
    if AOwner then
      AValue.Free;
  end;
end;

function TAPIAplicacaoBDMGViewBase<T>.Session: TAPIAplicacaoBDMGModeloSession;
begin
  Result := FRequest.Session<TAPIAplicacaoBDMGModeloSession>;
end;

procedure TAPIAplicacaoBDMGViewBase<T>.ValidateModel(AValue: TObject);
begin
  try
    SwaggerValidator.Validate(AValue);
  except
    on E: Exception do
      raise EAplicacaoBDMGException.Validacao(CODIGO_REQUISICAO_INVALIDA, E.Message);
  end;
end;

end.
