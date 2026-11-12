object AplicacaoBDMGViewPrincipal: TAplicacaoBDMGViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 660
  ClientWidth = 1120
  Color = clWhite
  Constraints.MinHeight = 520
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1120
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = 4406586
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 16
      Top = 14
      Width = 204
      Height = 25
      Caption = 'Gerenciador de Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object lblUsuario: TLabel
      Left = 716
      Top = 19
      Width = 296
      Height = 17
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Usu'#225'rio:'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnSair: TButton
      Left = 1024
      Top = 13
      Width = 80
      Height = 30
      Hint = 'Encerrar a sess'#227'o e voltar para o login'
      Anchors = [akTop, akRight]
      Caption = 'Sair'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnSairClick
    end
  end
  object pnlEstatisticas: TPanel
    Left = 0
    Top = 56
    Width = 1120
    Height = 104
    Align = alTop
    BevelOuter = bvNone
    Color = 16118770
    Padding.Left = 16
    Padding.Top = 12
    Padding.Right = 16
    Padding.Bottom = 12
    ParentBackground = False
    TabOrder = 1
    object pnlCardTotal: TPanel
      AlignWithMargins = True
      Left = 16
      Top = 12
      Width = 270
      Height = 80
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object lblTotalValor: TLabel
        Left = 16
        Top = 6
        Width = 12
        Height = 37
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4406586
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object lblTotalLegenda: TLabel
        Left = 16
        Top = 50
        Width = 93
        Height = 17
        Caption = 'Total de tarefas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlCardMedia: TPanel
      AlignWithMargins = True
      Left = 298
      Top = 12
      Width = 270
      Height = 80
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object lblMediaValor: TLabel
        Left = 16
        Top = 6
        Width = 12
        Height = 37
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2629320
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object lblMediaLegenda: TLabel
        Left = 16
        Top = 50
        Width = 225
        Height = 17
        Caption = 'M'#233'dia de prioridade das pendentes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlCardConcluidas: TPanel
      AlignWithMargins = True
      Left = 580
      Top = 12
      Width = 270
      Height = 80
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object lblConcluidasValor: TLabel
        Left = 16
        Top = 6
        Width = 12
        Height = 37
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5014046
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object lblConcluidasLegenda: TLabel
        Left = 16
        Top = 50
        Width = 190
        Height = 17
        Caption = 'Conclu'#237'das nos '#250'ltimos 7 dias'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object pnlAcoes: TPanel
    Left = 0
    Top = 160
    Width = 1120
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object btnAtualizar: TButton
      Left = 16
      Top = 12
      Width = 110
      Height = 32
      Hint = 'Buscar novamente as tarefas e as estat'#237'sticas (F5)'
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
    object btnNova: TButton
      Left = 134
      Top = 12
      Width = 120
      Height = 32
      Hint = 'Adicionar uma nova tarefa (Insert)'
      Caption = 'Nova tarefa'
      TabOrder = 1
      OnClick = btnNovaClick
    end
    object btnStatus: TButton
      Left = 262
      Top = 12
      Width = 150
      Height = 32
      Hint = 'Alterar o status da tarefa selecionada'
      Caption = 'Alterar status'
      DropDownMenu = pmStatus
      Style = bsSplitButton
      TabOrder = 2
      OnClick = btnStatusClick
    end
    object btnRemover: TButton
      Left = 420
      Top = 12
      Width = 110
      Height = 32
      Hint = 'Remover a tarefa selecionada (Delete)'
      Caption = 'Remover'
      TabOrder = 3
      OnClick = btnRemoverClick
    end
    object aiAguarde: TActivityIndicator
      Left = 1080
      Top = 16
      Anchors = [akTop, akRight]
      IndicatorSize = aisSmall
    end
  end
  object lvTarefas: TListView
    AlignWithMargins = True
    Left = 16
    Top = 216
    Width = 1088
    Height = 413
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 12
    Align = alClient
    Columns = <
      item
        Caption = 'Id'
        Width = 55
      end
      item
        Caption = 'T'#237'tulo'
        Width = 250
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 290
      end
      item
        Caption = 'Status'
        Width = 110
      end
      item
        Caption = 'Prioridade'
        Width = 110
      end
      item
        Caption = 'Criada em'
        Width = 125
      end
      item
        Caption = 'Conclu'#237'da em'
        Width = 125
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
    OnCustomDrawItem = lvTarefasCustomDrawItem
    OnSelectItem = lvTarefasSelectItem
  end
  object sbStatus: TStatusBar
    Left = 0
    Top = 641
    Width = 1120
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pmStatus: TPopupMenu
    OnPopup = pmStatusPopup
    Left = 936
    Top = 168
  end
end
