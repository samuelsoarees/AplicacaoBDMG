object AplicacaoBDMGViewLogin: TAplicacaoBDMGViewLogin
  Left = 0
  Top = 0
  ActiveControl = edtLogin
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Gerenciador de Tarefas - Acesso'
  ClientHeight = 410
  ClientWidth = 400
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 17
  object lblLogin: TLabel
    Left = 32
    Top = 120
    Width = 45
    Height = 17
    Caption = 'Usu'#225'rio'
    FocusControl = edtLogin
  end
  object lblSenha: TLabel
    Left = 32
    Top = 180
    Width = 36
    Height = 17
    Caption = 'Senha'
    FocusControl = edtSenha
  end
  object lblMensagem: TLabel
    Left = 32
    Top = 234
    Width = 336
    Height = 52
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2629320
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblServidor: TLabel
    Left = 32
    Top = 382
    Width = 336
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Servidor:'
    EllipsisPosition = epEndEllipsis
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    Color = 4406586
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 32
      Top = 20
      Width = 238
      Height = 30
      Caption = 'Gerenciador de Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Left = 32
      Top = 56
      Width = 232
      Height = 17
      Caption = 'Informe suas credenciais para acessar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13684944
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object aiAguarde: TActivityIndicator
      Left = 344
      Top = 36
      IndicatorColor = aicWhite
      IndicatorSize = aisSmall
    end
  end
  object edtLogin: TEdit
    Left = 32
    Top = 141
    Width = 336
    Height = 25
    MaxLength = 50
    TabOrder = 1
  end
  object edtSenha: TEdit
    Left = 32
    Top = 201
    Width = 336
    Height = 25
    PasswordChar = '*'
    TabOrder = 2
  end
  object btnEntrar: TButton
    Left = 32
    Top = 298
    Width = 336
    Height = 36
    Caption = 'Entrar'
    Default = True
    TabOrder = 3
    OnClick = btnEntrarClick
  end
  object btnSair: TButton
    Left = 32
    Top = 340
    Width = 336
    Height = 30
    Cancel = True
    Caption = 'Sair'
    ModalResult = 2
    TabOrder = 4
  end
end
