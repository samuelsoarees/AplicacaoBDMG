unit AplicacaoBDMG.Resources;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils;

type
  TAPIAplicacaoBDMGResources = class
  private
    FAPI_SECRETKEY: string;
    FAPI_TOKEN_EXPIRACAO: Integer;
    FDATABASE_HOST: string;
    FDATABASE_NAME: string;
    FDATABASE_USERNAME: string;
    FDATABASE_PASSWORD: string;
    FDATABASE_OSAUTHENT: Boolean;

    function ApplicationPath: string;
    function ResourceFile: string;
    function NovaChaveSecreta: string;

    procedure DefaultValues;
    procedure LoadConfig;
    procedure SaveConfig(const AFileName: string);
  public
    constructor Create;

    property API_SECRETKEY: string read FAPI_SECRETKEY write FAPI_SECRETKEY;
    property API_TOKEN_EXPIRACAO: Integer read FAPI_TOKEN_EXPIRACAO write FAPI_TOKEN_EXPIRACAO;
    property DATABASE_HOST: string read FDATABASE_HOST write FDATABASE_HOST;
    property DATABASE_NAME: string read FDATABASE_NAME write FDATABASE_NAME;
    property DATABASE_USERNAME: string read FDATABASE_USERNAME write FDATABASE_USERNAME;
    property DATABASE_PASSWORD: string read FDATABASE_PASSWORD write FDATABASE_PASSWORD;
    property DATABASE_OSAUTHENT: Boolean read FDATABASE_OSAUTHENT write FDATABASE_OSAUTHENT;
  end;

var
  APPRESOURCES: TAPIAplicacaoBDMGResources;

implementation

const
  JSON_FILE = 'AplicacaoBDMG_apiResources.json';

function TAPIAplicacaoBDMGResources.ApplicationPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

constructor TAPIAplicacaoBDMGResources.Create;
begin
  DefaultValues;
  LoadConfig;
end;

procedure TAPIAplicacaoBDMGResources.DefaultValues;
begin
  FAPI_SECRETKEY := EmptyStr;
  FAPI_TOKEN_EXPIRACAO := 3600;
  FDATABASE_HOST := 'localhost';
  FDATABASE_NAME := 'TarefasBDMG';
  FDATABASE_USERNAME := 'sa';
  FDATABASE_PASSWORD := EmptyStr;
  FDATABASE_OSAUTHENT := True;
end;

procedure TAPIAplicacaoBDMGResources.LoadConfig;
var
  LArquivo: TStringList;
  LJSONValue: TJSONValue;
  LJSON: TJSONObject;
begin
  if not FileExists(ResourceFile) then
  begin
    FAPI_SECRETKEY := NovaChaveSecreta;
    SaveConfig(ResourceFile);
    Exit;
  end;

  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(ResourceFile, TEncoding.UTF8);
    LJSONValue := TJSONObject.ParseJSONValue(LArquivo.Text);
    try
      if not (LJSONValue is TJSONObject) then
        raise Exception.CreateFmt('Arquivo de configuração inválido: %s', [ResourceFile]);

      LJSON := TJSONObject(LJSONValue);
      FAPI_SECRETKEY := LJSON.GetValue<string>('API_SECRETKEY', FAPI_SECRETKEY);
      FAPI_TOKEN_EXPIRACAO := LJSON.GetValue<Integer>('API_TOKEN_EXPIRACAO', FAPI_TOKEN_EXPIRACAO);
      FDATABASE_HOST := LJSON.GetValue<string>('DATABASE_HOST', FDATABASE_HOST);
      FDATABASE_NAME := LJSON.GetValue<string>('DATABASE_NAME', FDATABASE_NAME);
      FDATABASE_USERNAME := LJSON.GetValue<string>('DATABASE_USERNAME', FDATABASE_USERNAME);
      FDATABASE_PASSWORD := LJSON.GetValue<string>('DATABASE_PASSWORD', FDATABASE_PASSWORD);
      FDATABASE_OSAUTHENT := LJSON.GetValue<Boolean>('DATABASE_OSAUTHENT', FDATABASE_OSAUTHENT);
    finally
      LJSONValue.Free;
    end;
  finally
    LArquivo.Free;
  end;

  if FAPI_SECRETKEY.Trim.IsEmpty then
    raise Exception.CreateFmt('Informe a chave API_SECRETKEY no arquivo %s', [ResourceFile]);
end;

function TAPIAplicacaoBDMGResources.NovaChaveSecreta: string;
begin
  Result := (TGUID.NewGuid.ToString + TGUID.NewGuid.ToString)
    .Replace('{', EmptyStr).Replace('}', EmptyStr).Replace('-', EmptyStr).ToLower;
end;

function TAPIAplicacaoBDMGResources.ResourceFile: string;
begin
  Result := ApplicationPath + JSON_FILE;
end;

procedure TAPIAplicacaoBDMGResources.SaveConfig(const AFileName: string);
var
  LJSON: TJSONObject;
  LArquivo: TStringList;
begin
  LJSON := TJSONObject.Create;
  try
    LJSON
      .AddPair('API_SECRETKEY', FAPI_SECRETKEY)
      .AddPair('API_TOKEN_EXPIRACAO', TJSONNumber.Create(FAPI_TOKEN_EXPIRACAO))
      .AddPair('DATABASE_HOST', FDATABASE_HOST)
      .AddPair('DATABASE_NAME', FDATABASE_NAME)
      .AddPair('DATABASE_USERNAME', FDATABASE_USERNAME)
      .AddPair('DATABASE_PASSWORD', FDATABASE_PASSWORD)
      .AddPair('DATABASE_OSAUTHENT', TJSONBool.Create(FDATABASE_OSAUTHENT));

    LArquivo := TStringList.Create;
    try
      LArquivo.Text := LJSON.Format(2);
      LArquivo.SaveToFile(AFileName, TEncoding.UTF8);
    finally
      LArquivo.Free;
    end;
  finally
    LJSON.Free;
  end;
end;

initialization
  APPRESOURCES := TAPIAplicacaoBDMGResources.Create;

finalization
  APPRESOURCES.Free;

end.
