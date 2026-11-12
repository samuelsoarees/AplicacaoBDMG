unit AplicacaoBDMG.View.Login;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  AplicacaoBDMG.Service.Interfaces;

type
  TAplicacaoBDMGViewLogin = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    aiAguarde: TActivityIndicator;
    lblLogin: TLabel;
    edtLogin: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    lblMensagem: TLabel;
    btnEntrar: TButton;
    btnSair: TButton;
    lblServidor: TLabel;
    procedure btnEntrarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FFactory: IAplicacaoBDMGServiceFactory;
    FOcupado: Boolean;

    procedure Ocupado(AValor: Boolean);
    procedure Desocupar;
    procedure ExibirMensagem(const AMensagem: string);
    procedure TratarErro(AErro: Exception);
  public
    class function Autenticar(const AFactory: IAplicacaoBDMGServiceFactory;
      const AAviso: string = ''): Boolean;
  end;

implementation

uses
  AplicacaoBDMG.Utils.Async;

{$R *.dfm}

class function TAplicacaoBDMGViewLogin.Autenticar(const AFactory: IAplicacaoBDMGServiceFactory;
  const AAviso: string): Boolean;
var
  LView: TAplicacaoBDMGViewLogin;
begin
  LView := TAplicacaoBDMGViewLogin.Create(nil);
  try
    LView.FFactory := AFactory;
    LView.Ocupado(False);
    LView.lblServidor.Caption := Format('Servidor: %s', [AFactory.BaseURL]);
    LView.ExibirMensagem(AAviso);
    Result := LView.ShowModal = mrOk;
  finally
    LView.Free;
  end;
end;

procedure TAplicacaoBDMGViewLogin.btnEntrarClick(Sender: TObject);
var
  LLogin: string;
  LSenha: string;
  LAuth: IAplicacaoBDMGServiceAuth;
begin
  LLogin := Trim(edtLogin.Text);
  LSenha := edtSenha.Text;

  if LLogin.IsEmpty then
  begin
    ExibirMensagem('Informe o usuário.');
    edtLogin.SetFocus;
    Exit;
  end;

  if LSenha.IsEmpty then
  begin
    ExibirMensagem('Informe a senha.');
    edtSenha.SetFocus;
    Exit;
  end;

  ExibirMensagem(EmptyStr);
  Ocupado(True);

  LAuth := FFactory.Auth;
  TAplicacaoBDMGAsync.ExecutarProc(
    procedure
    begin
      LAuth.Login(LLogin, LSenha);
    end,
    procedure
    begin
      ModalResult := mrOk;
    end,
    TratarErro,
    Desocupar);
end;

procedure TAplicacaoBDMGViewLogin.Desocupar;
begin
  Ocupado(False);
end;

procedure TAplicacaoBDMGViewLogin.ExibirMensagem(const AMensagem: string);
begin
  lblMensagem.Caption := AMensagem;
end;

procedure TAplicacaoBDMGViewLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FOcupado;
end;

procedure TAplicacaoBDMGViewLogin.Ocupado(AValor: Boolean);
begin
  FOcupado := AValor;
  edtLogin.Enabled := not AValor;
  edtSenha.Enabled := not AValor;
  btnEntrar.Enabled := not AValor;
  btnSair.Enabled := not AValor;
  aiAguarde.Visible := AValor;
  aiAguarde.Animate := AValor;

  if AValor then
    btnEntrar.Caption := 'Entrando...'
  else
    btnEntrar.Caption := 'Entrar';
end;

procedure TAplicacaoBDMGViewLogin.TratarErro(AErro: Exception);
begin
  ExibirMensagem(AErro.Message);
  edtSenha.Clear;
  edtSenha.SetFocus;
end;

end.
