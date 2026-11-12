unit AplicacaoBDMG.View.Principal;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.WinXCtrls,
  AplicacaoBDMG.Modelo.Types,
  AplicacaoBDMG.Modelo.Tarefa,
  AplicacaoBDMG.Modelo.Estatisticas,
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGDadosPrincipal = record
    Tarefas: TObjectList<TAplicacaoBDMGModeloTarefa>;
    Estatisticas: TAplicacaoBDMGModeloEstatisticas;
  end;

  TAplicacaoBDMGViewPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    lblUsuario: TLabel;
    btnSair: TButton;
    pnlEstatisticas: TPanel;
    pnlCardTotal: TPanel;
    lblTotalValor: TLabel;
    lblTotalLegenda: TLabel;
    pnlCardMedia: TPanel;
    lblMediaValor: TLabel;
    lblMediaLegenda: TLabel;
    pnlCardConcluidas: TPanel;
    lblConcluidasValor: TLabel;
    lblConcluidasLegenda: TLabel;
    pnlAcoes: TPanel;
    btnAtualizar: TButton;
    btnNova: TButton;
    btnStatus: TButton;
    btnRemover: TButton;
    aiAguarde: TActivityIndicator;
    lvTarefas: TListView;
    sbStatus: TStatusBar;
    pmStatus: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure pmStatusPopup(Sender: TObject);
    procedure lvTarefasSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvTarefasCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FFactory: IAplicacaoBDMGServiceFactory;
    FTarefas: TObjectList<TAplicacaoBDMGModeloTarefa>;
    FOcupado: Boolean;

    function TarefaSelecionada: TAplicacaoBDMGModeloTarefa;
    function FormatarData(AData: TDateTime): string;

    procedure CriarMenuStatus;
    procedure MenuStatusClick(Sender: TObject);

    procedure Recarregar;
    procedure ExibirDados(const ADados: TAplicacaoBDMGDadosPrincipal);
    procedure ExibirTarefas(AIdSelecionado: Integer);
    procedure ExibirEstatisticas(AEstatisticas: TAplicacaoBDMGModeloEstatisticas);
    procedure LimparTela;

    procedure Ocupado(AValor: Boolean; const AMensagem: string = '');
    procedure Desocupar;
    procedure AtualizarAcoes;
    procedure TratarErro(AErro: Exception);
    procedure Reautenticar(const AAviso: string);
  public
    procedure Iniciar(const AFactory: IAplicacaoBDMGServiceFactory);
  end;

var
  AplicacaoBDMGViewPrincipal: TAplicacaoBDMGViewPrincipal;

implementation

uses
  AplicacaoBDMG.Modelo.Exception,
  AplicacaoBDMG.Utils.Async,
  AplicacaoBDMG.View.Login,
  AplicacaoBDMG.View.TarefaNova;

{$R *.dfm}

const
  HTTP_NOT_FOUND = 404;
  SEM_VALOR = '-';
  FORMATO_DATA = 'dd/mm/yyyy hh:nn';

  COR_STATUS: array[TAplicacaoBDMGStatus] of TColor = (clWindowText, $00A8611F, $004C821E);

procedure TAplicacaoBDMGViewPrincipal.AtualizarAcoes;
var
  LTemSelecao: Boolean;
begin
  LTemSelecao := TarefaSelecionada <> nil;

  btnAtualizar.Enabled := not FOcupado;
  btnNova.Enabled := not FOcupado;
  btnStatus.Enabled := (not FOcupado) and LTemSelecao;
  btnRemover.Enabled := (not FOcupado) and LTemSelecao;
  btnSair.Enabled := not FOcupado;
end;

procedure TAplicacaoBDMGViewPrincipal.btnAtualizarClick(Sender: TObject);
begin
  Recarregar;
end;

procedure TAplicacaoBDMGViewPrincipal.btnNovaClick(Sender: TObject);
begin
  case TAplicacaoBDMGViewTarefaNova.Executar(FFactory) of
    mrOk:
      Recarregar;
    mrAbort:
      Reautenticar('Sua sessão expirou. Informe suas credenciais novamente.');
  end;
end;

procedure TAplicacaoBDMGViewPrincipal.btnRemoverClick(Sender: TObject);
var
  LTarefa: TAplicacaoBDMGModeloTarefa;
  LService: IAplicacaoBDMGServiceTarefa;
  LId: Integer;
begin
  LTarefa := TarefaSelecionada;
  if not Assigned(LTarefa) then
    Exit;

  if Application.MessageBox(
       PChar(Format('Remover a tarefa "%s"?' + sLineBreak + 'Esta ação não pode ser desfeita.', [LTarefa.Titulo])),
       'Remover tarefa', MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) <> IDYES then
    Exit;

  LId := LTarefa.Id;
  LService := FFactory.Tarefa;
  Ocupado(True, 'Removendo tarefa...');

  TAplicacaoBDMGAsync.ExecutarProc(
    procedure
    begin
      LService.Remover(LId);
    end,
    procedure
    begin
      Recarregar;
    end,
    TratarErro,
    Desocupar);
end;

procedure TAplicacaoBDMGViewPrincipal.btnSairClick(Sender: TObject);
begin
  Reautenticar(EmptyStr);
end;

procedure TAplicacaoBDMGViewPrincipal.btnStatusClick(Sender: TObject);
var
  LPonto: TPoint;
begin
  LPonto := btnStatus.ClientToScreen(Point(0, btnStatus.Height));
  pmStatus.Popup(LPonto.X, LPonto.Y);
end;

procedure TAplicacaoBDMGViewPrincipal.CriarMenuStatus;
var
  LStatus: TAplicacaoBDMGStatus;
  LItem: TMenuItem;
begin
  for LStatus := Low(TAplicacaoBDMGStatus) to High(TAplicacaoBDMGStatus) do
  begin
    LItem := TMenuItem.Create(pmStatus);
    LItem.Caption := LStatus.Descricao;
    LItem.Tag := Ord(LStatus);
    LItem.RadioItem := True;
    LItem.OnClick := MenuStatusClick;
    pmStatus.Items.Add(LItem);
  end;
end;

procedure TAplicacaoBDMGViewPrincipal.Desocupar;
begin
  Ocupado(False);
end;

procedure TAplicacaoBDMGViewPrincipal.ExibirDados(const ADados: TAplicacaoBDMGDadosPrincipal);
var
  LSelecionada: TAplicacaoBDMGModeloTarefa;
  LIdSelecionado: Integer;
begin
  LIdSelecionado := 0;
  LSelecionada := TarefaSelecionada;
  if Assigned(LSelecionada) then
    LIdSelecionado := LSelecionada.Id;

  try
    lvTarefas.Items.Clear;
    FTarefas.Free;
    FTarefas := ADados.Tarefas;

    ExibirTarefas(LIdSelecionado);
    ExibirEstatisticas(ADados.Estatisticas);
  finally
    ADados.Estatisticas.Free;
  end;

  sbStatus.SimpleText := Format('%d tarefa(s) - atualizado às %s',
    [FTarefas.Count, FormatDateTime('hh:nn:ss', Now)]);
  AtualizarAcoes;
end;

procedure TAplicacaoBDMGViewPrincipal.ExibirEstatisticas(AEstatisticas: TAplicacaoBDMGModeloEstatisticas);
begin
  lblTotalValor.Caption := AEstatisticas.TotalTarefas.ToString;
  lblMediaValor.Caption := FormatFloat('0.00', AEstatisticas.MediaPrioridadePendentes);
  lblConcluidasValor.Caption := AEstatisticas.ConcluidasUltimos7Dias.ToString;
end;

procedure TAplicacaoBDMGViewPrincipal.ExibirTarefas(AIdSelecionado: Integer);
var
  LTarefa: TAplicacaoBDMGModeloTarefa;
  LItem: TListItem;
begin
  lvTarefas.Items.BeginUpdate;
  try
    for LTarefa in FTarefas do
    begin
      LItem := lvTarefas.Items.Add;
      LItem.Caption := LTarefa.Id.ToString;
      LItem.SubItems.Add(LTarefa.Titulo);
      LItem.SubItems.Add(LTarefa.Descricao);
      LItem.SubItems.Add(LTarefa.Status.Descricao);
      LItem.SubItems.Add(TAplicacaoBDMGModeloTarefa.DescricaoPrioridade(LTarefa.Prioridade));
      LItem.SubItems.Add(FormatarData(LTarefa.DataCriacao));
      LItem.SubItems.Add(FormatarData(LTarefa.DataConclusao));
      LItem.Data := LTarefa;

      if LTarefa.Id = AIdSelecionado then
      begin
        LItem.Selected := True;
        LItem.Focused := True;
      end;
    end;
  finally
    lvTarefas.Items.EndUpdate;
  end;

  if Assigned(lvTarefas.Selected) then
    lvTarefas.Selected.MakeVisible(False);
end;

function TAplicacaoBDMGViewPrincipal.FormatarData(AData: TDateTime): string;
begin
  if AData = 0 then
    Exit(SEM_VALOR);
  Result := FormatDateTime(FORMATO_DATA, AData);
end;

procedure TAplicacaoBDMGViewPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FOcupado;
end;

procedure TAplicacaoBDMGViewPrincipal.FormCreate(Sender: TObject);
begin
  FTarefas := TObjectList<TAplicacaoBDMGModeloTarefa>.Create(True);
  CriarMenuStatus;
  aiAguarde.Visible := False;
  LimparTela;
end;

procedure TAplicacaoBDMGViewPrincipal.FormDestroy(Sender: TObject);
begin
  FTarefas.Free;
end;

procedure TAplicacaoBDMGViewPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift <> [] then
    Exit;

  case Key of
    VK_F5:
      if btnAtualizar.Enabled then
        btnAtualizar.Click;
    VK_INSERT:
      if btnNova.Enabled then
        btnNova.Click;
    VK_DELETE:
      if btnRemover.Enabled then
        btnRemover.Click;
  end;
end;

procedure TAplicacaoBDMGViewPrincipal.Iniciar(const AFactory: IAplicacaoBDMGServiceFactory);
begin
  FFactory := AFactory;
  lblUsuario.Caption := Format('Usuário: %s', [FFactory.Session.Login]);
  Recarregar;
end;

procedure TAplicacaoBDMGViewPrincipal.LimparTela;
begin
  lvTarefas.Items.Clear;
  FTarefas.Clear;
  lblTotalValor.Caption := SEM_VALOR;
  lblMediaValor.Caption := SEM_VALOR;
  lblConcluidasValor.Caption := SEM_VALOR;
  sbStatus.SimpleText := EmptyStr;
  AtualizarAcoes;
end;

procedure TAplicacaoBDMGViewPrincipal.lvTarefasCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Assigned(Item.Data) then
    Sender.Canvas.Font.Color := COR_STATUS[TAplicacaoBDMGModeloTarefa(Item.Data).Status];
end;

procedure TAplicacaoBDMGViewPrincipal.lvTarefasSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  AtualizarAcoes;
end;

procedure TAplicacaoBDMGViewPrincipal.MenuStatusClick(Sender: TObject);
var
  LTarefa: TAplicacaoBDMGModeloTarefa;
  LService: IAplicacaoBDMGServiceTarefa;
  LStatus: TAplicacaoBDMGStatus;
  LId: Integer;
begin
  LTarefa := TarefaSelecionada;
  if (not Assigned(LTarefa)) or FOcupado then
    Exit;

  LStatus := TAplicacaoBDMGStatus(TMenuItem(Sender).Tag);
  if LStatus = LTarefa.Status then
    Exit;

  LId := LTarefa.Id;
  LService := FFactory.Tarefa;
  Ocupado(True, 'Atualizando status...');

  TAplicacaoBDMGAsync.Executar<TAplicacaoBDMGModeloTarefa>(
    function: TAplicacaoBDMGModeloTarefa
    begin
      Result := LService.AtualizarStatus(LId, LStatus);
    end,
    procedure(ATarefa: TAplicacaoBDMGModeloTarefa)
    begin
      ATarefa.Free;
      Recarregar;
    end,
    TratarErro,
    Desocupar);
end;

procedure TAplicacaoBDMGViewPrincipal.Ocupado(AValor: Boolean; const AMensagem: string);
begin
  FOcupado := AValor;
  aiAguarde.Visible := AValor;
  aiAguarde.Animate := AValor;

  if AValor then
  begin
    Screen.Cursor := crAppStart;
    sbStatus.SimpleText := AMensagem;
  end
  else
    Screen.Cursor := crDefault;

  AtualizarAcoes;

  if (not AValor) and lvTarefas.CanFocus then
    lvTarefas.SetFocus;
end;

procedure TAplicacaoBDMGViewPrincipal.pmStatusPopup(Sender: TObject);
var
  LTarefa: TAplicacaoBDMGModeloTarefa;
  LItem: TMenuItem;
begin
  LTarefa := TarefaSelecionada;
  for LItem in pmStatus.Items do
    LItem.Checked := Assigned(LTarefa) and (LItem.Tag = Ord(LTarefa.Status));
end;

procedure TAplicacaoBDMGViewPrincipal.Reautenticar(const AAviso: string);
begin
  FFactory.Session.Encerrar;
  LimparTela;
  Hide;

  if TAplicacaoBDMGViewLogin.Autenticar(FFactory, AAviso) then
  begin
    lblUsuario.Caption := Format('Usuário: %s', [FFactory.Session.Login]);
    Show;
    Recarregar;
  end
  else
    Close;
end;

procedure TAplicacaoBDMGViewPrincipal.Recarregar;
var
  LService: IAplicacaoBDMGServiceTarefa;
begin
  if FOcupado then
    Exit;

  LService := FFactory.Tarefa;
  Ocupado(True, 'Carregando tarefas...');

  TAplicacaoBDMGAsync.Executar<TAplicacaoBDMGDadosPrincipal>(
    function: TAplicacaoBDMGDadosPrincipal
    begin
      Result.Tarefas := LService.Listar;
      try
        Result.Estatisticas := LService.Estatisticas;
      except
        Result.Tarefas.Free;
        raise;
      end;
    end,
    procedure(ADados: TAplicacaoBDMGDadosPrincipal)
    begin
      ExibirDados(ADados);
    end,
    TratarErro,
    Desocupar);
end;

function TAplicacaoBDMGViewPrincipal.TarefaSelecionada: TAplicacaoBDMGModeloTarefa;
begin
  Result := nil;
  if Assigned(lvTarefas.Selected) then
    Result := TAplicacaoBDMGModeloTarefa(lvTarefas.Selected.Data);
end;

procedure TAplicacaoBDMGViewPrincipal.TratarErro(AErro: Exception);
var
  LMensagem: string;
  LNaoEncontrado: Boolean;
begin
  LMensagem := AErro.Message;

  if AErro is EAplicacaoBDMGNaoAutorizado then
  begin
    Reautenticar(LMensagem);
    Exit;
  end;

  LNaoEncontrado := (AErro is EAplicacaoBDMGException) and
    (EAplicacaoBDMGException(AErro).Status = HTTP_NOT_FOUND);

  sbStatus.SimpleText := LMensagem.Replace(sLineBreak, ' ');
  Application.MessageBox(PChar(LMensagem), PChar(Caption), MB_OK or MB_ICONERROR);

  if LNaoEncontrado then
    Recarregar;
end;

end.
