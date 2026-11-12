unit AplicacaoBDMG.Service.Interfaces;

interface

uses
  System.JSON,
  System.Generics.Collections,
  AplicacaoBDMG.Modelo.Types,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Modelo.Estatisticas;

type
  IAplicacaoBDMGSession = interface
    ['{5B0C0B5E-7A3F-4C55-9B8E-2B1D8E0A6F11}']
    function Login: string;
    function Token: string;
    function Autenticado: Boolean;
    procedure Iniciar(const ALogin, AToken: string);
    procedure Encerrar;
  end;

  IAplicacaoBDMGServiceRequest = interface
    ['{C1E3F2A4-8D57-4B0B-A2C6-93F4D7E15A22}']
    function Get(const AResource: string): TJSONValue;
    function Post(const AResource: string; ABody: TJSONObject): TJSONValue;
    function Patch(const AResource: string; ABody: TJSONObject): TJSONValue;
    procedure Delete(const AResource: string);
  end;

  IAplicacaoBDMGServiceAuth = interface
    ['{0E7A9D63-41C2-4F7E-8B15-6A2C3D9F4B33}']
    procedure Login(const ALogin, ASenha: string);
  end;

  IAplicacaoBDMGServiceTarefa = interface
    ['{7F2D4C18-9E6B-4A31-B5D0-1C8E7A3F6D44}']
    function Listar: TObjectList<TAplicacaoBDMGModeloTarefa>;
    function Inserir(const ATitulo, ADescricao: string; APrioridade: Integer): TAplicacaoBDMGModeloTarefa;
    function AtualizarStatus(AId: Integer; AStatus: TAplicacaoBDMGStatus): TAplicacaoBDMGModeloTarefa;
    procedure Remover(AId: Integer);
    function Estatisticas: TAplicacaoBDMGModeloEstatisticas;
  end;

  IAplicacaoBDMGServiceFactory = interface
    ['{A94B6E20-3C1D-4E8F-9A72-5D0B1F6C8E55}']
    function BaseURL: string;
    function Session: IAplicacaoBDMGSession;
    function Auth: IAplicacaoBDMGServiceAuth;
    function Tarefa: IAplicacaoBDMGServiceTarefa;
  end;

implementation

end.
