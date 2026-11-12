unit AplicacaoBDMG.Resources;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils;

type
  TAplicacaoBDMGResources = class
  private
    FAPI_URL: string;
    FAPI_TIMEOUT: Integer;

    function ResourceFile: string;

    procedure DefaultValues;
    procedure LoadConfig;
  public
    constructor Create;

    property API_URL: string read FAPI_URL;
    property API_TIMEOUT: Integer read FAPI_TIMEOUT;
  end;

var
  APPRESOURCES: TAplicacaoBDMGResources;

implementation

const
  JSON_FILE = 'AplicacaoBDMG_appResources.json';
  API_URL_PADRAO = 'http://localhost:9090/v1';
  API_TIMEOUT_PADRAO = 15000;

constructor TAplicacaoBDMGResources.Create;
begin
  DefaultValues;
  LoadConfig;
end;

procedure TAplicacaoBDMGResources.DefaultValues;
begin
  FAPI_URL := API_URL_PADRAO;
  FAPI_TIMEOUT := API_TIMEOUT_PADRAO;
end;

procedure TAplicacaoBDMGResources.LoadConfig;
var
  LArquivo: TStringList;
  LJSONValue: TJSONValue;
begin
  if not FileExists(ResourceFile) then
    Exit;

  LArquivo := TStringList.Create;
  try
    try
      LArquivo.LoadFromFile(ResourceFile, TEncoding.UTF8);
    except
      on E: EStreamError do
        Exit;
    end;

    LJSONValue := TJSONObject.ParseJSONValue(LArquivo.Text);
    try
      if not (LJSONValue is TJSONObject) then
        Exit;

      FAPI_URL := LJSONValue.GetValue<string>('API_URL', FAPI_URL).Trim.TrimRight(['/']);
      FAPI_TIMEOUT := LJSONValue.GetValue<Integer>('API_TIMEOUT', FAPI_TIMEOUT);
    finally
      LJSONValue.Free;
    end;
  finally
    LArquivo.Free;
  end;

  if FAPI_URL.IsEmpty then
    FAPI_URL := API_URL_PADRAO;
  if FAPI_TIMEOUT <= 0 then
    FAPI_TIMEOUT := API_TIMEOUT_PADRAO;
end;

function TAplicacaoBDMGResources.ResourceFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + JSON_FILE;
end;

initialization
  APPRESOURCES := TAplicacaoBDMGResources.Create;

finalization
  APPRESOURCES.Free;

end.
