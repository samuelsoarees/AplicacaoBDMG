unit AplicacaoBDMG.View.TarefaNova;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGViewTarefaNova = class(TForm)
    lblTitulo: TLabel;
    edtTitulo: TEdit;
    lblDescricao: TLabel;
    mmoDescricao: TMemo;
    lblContador: TLabel;
    lblPrioridade: TLabel;
    cbbPrioridade: TComboBox;
    lblMensagem: TLabel;
    aiAguarde: TActivityIndicator;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmoDescricaoChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    FFactory: IAplicacaoBDMGServiceFactory;
    FOcupado: Boolean;

    function Validar: Boolean;
    procedure Ocupado(AValor: Boolean);
    procedure Desocupar;
    procedure ExibirMensagem(const AMensagem: string);
    procedure TratarErro(AErro: Exception);
  public
    class function Executar(const AFactory: IAplicacaoBDMGServiceFactory): TModalResult;
  end;

implementation

uses
  AplicacaoBDMG.Modelo.Exception,
  AplicacaoBDMG.Utils.Async;

{$R *.dfm}

procedure TAplicacaoBDMGViewTarefaNova.btnSalvarClick(Sender: TObject);
var
  LTitulo: string;
  LDescricao: string;
  LPrioridade: Integer;
  LService: IAplicacaoBDMGServiceTarefa;
begin
  if not Validar then
    Exit;

  LTitulo := Trim(edtTitulo.Text);
  LDescricao := Trim(mmoDescricao.Text);
  LPrioridade := PRIORIDADE_MINIMA + cbbPrioridade.ItemIndex;

  ExibirMensagem(EmptyStr);
  Ocupado(True);

  LService := FFactory.Tarefa;
  TAplicacaoBDMGAsync.Executar<TAplicacaoBDMGModeloTarefa>(
    function: TAplicacaoBDMGModeloTarefa
    begin
      Result := LService.Inserir(LTitulo, LDescricao, LPrioridade);
    end,
    procedure(ATarefa: TAplicacaoBDMGModeloTarefa)
    begin
      ATarefa.Free;
      ModalResult := mrOk;
    end,
    TratarErro,
    Desocupar);
end;

procedure TAplicacaoBDMGViewTarefaNova.Desocupar;
begin
  Ocupado(False);
end;

class function TAplicacaoBDMGViewTarefaNova.Executar(const AFactory: IAplicacaoBDMGServiceFactory): TModalResult;
var
  LView: TAplicacaoBDMGViewTarefaNova;
begin
  LView := TAplicacaoBDMGViewTarefaNova.Create(nil);
  try
    LView.FFactory := AFactory;
    Result := LView.ShowModal;
  finally
    LView.Free;
  end;
end;

procedure TAplicacaoBDMGViewTarefaNova.ExibirMensagem(const AMensagem: string);
begin
  lblMensagem.Caption := AMensagem;
end;

procedure TAplicacaoBDMGViewTarefaNova.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FOcupado;
end;

procedure TAplicacaoBDMGViewTarefaNova.FormCreate(Sender: TObject);
var
  LPrioridade: Integer;
begin
  edtTitulo.MaxLength := TITULO_TAMANHO_MAXIMO;
  mmoDescricao.MaxLength := DESCRICAO_TAMANHO_MAXIMO;

  for LPrioridade := PRIORIDADE_MINIMA to PRIORIDADE_MAXIMA do
    cbbPrioridade.Items.Add(TAplicacaoBDMGModeloTarefa.DescricaoPrioridade(LPrioridade));
  cbbPrioridade.ItemIndex := PRIORIDADE_PADRAO - PRIORIDADE_MINIMA;

  mmoDescricaoChange(mmoDescricao);
  Ocupado(False);
end;

procedure TAplicacaoBDMGViewTarefaNova.mmoDescricaoChange(Sender: TObject);
begin
  lblContador.Caption := Format('%d/%d', [Length(mmoDescricao.Text), DESCRICAO_TAMANHO_MAXIMO]);
end;

procedure TAplicacaoBDMGViewTarefaNova.Ocupado(AValor: Boolean);
begin
  FOcupado := AValor;
  edtTitulo.Enabled := not AValor;
  mmoDescricao.Enabled := not AValor;
  cbbPrioridade.Enabled := not AValor;
  btnSalvar.Enabled := not AValor;
  btnCancelar.Enabled := not AValor;
  aiAguarde.Visible := AValor;
  aiAguarde.Animate := AValor;
end;

procedure TAplicacaoBDMGViewTarefaNova.TratarErro(AErro: Exception);
begin
  if AErro is EAplicacaoBDMGNaoAutorizado then
  begin
    ModalResult := mrAbort;
    Exit;
  end;

  ExibirMensagem(AErro.Message);
  edtTitulo.SetFocus;
end;

function TAplicacaoBDMGViewTarefaNova.Validar: Boolean;
begin
  Result := False;

  if Trim(edtTitulo.Text).IsEmpty then
  begin
    ExibirMensagem('Informe o título da tarefa.');
    edtTitulo.SetFocus;
    Exit;
  end;

  if cbbPrioridade.ItemIndex < 0 then
  begin
    ExibirMensagem('Selecione a prioridade.');
    cbbPrioridade.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
