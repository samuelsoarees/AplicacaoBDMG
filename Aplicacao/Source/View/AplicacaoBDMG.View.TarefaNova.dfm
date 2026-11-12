object AplicacaoBDMGViewTarefaNova: TAplicacaoBDMGViewTarefaNova
  Left = 0
  Top = 0
  ActiveControl = edtTitulo
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Nova tarefa'
  ClientHeight = 384
  ClientWidth = 460
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitulo: TLabel
    Left = 24
    Top = 20
    Width = 42
    Height = 17
    Caption = 'T'#237'tulo *'
    FocusControl = edtTitulo
  end
  object lblDescricao: TLabel
    Left = 24
    Top = 78
    Width = 57
    Height = 17
    Caption = 'Descri'#231#227'o'
    FocusControl = mmoDescricao
  end
  object lblContador: TLabel
    Left = 236
    Top = 212
    Width = 200
    Height = 15
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0/500'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object lblPrioridade: TLabel
    Left = 24
    Top = 226
    Width = 68
    Height = 17
    Caption = 'Prioridade *'
    FocusControl = cbbPrioridade
  end
  object lblMensagem: TLabel
    Left = 24
    Top = 284
    Width = 412
    Height = 38
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2629320
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object edtTitulo: TEdit
    Left = 24
    Top = 41
    Width = 412
    Height = 25
    TabOrder = 0
  end
  object mmoDescricao: TMemo
    Left = 24
    Top = 99
    Width = 412
    Height = 110
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = mmoDescricaoChange
  end
  object cbbPrioridade: TComboBox
    Left = 24
    Top = 247
    Width = 200
    Height = 25
    Style = csDropDownList
    TabOrder = 2
  end
  object aiAguarde: TActivityIndicator
    Left = 24
    Top = 336
    IndicatorSize = aisSmall
  end
  object btnSalvar: TButton
    Left = 228
    Top = 332
    Width = 100
    Height = 32
    Caption = 'Salvar'
    Default = True
    TabOrder = 3
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 336
    Top = 332
    Width = 100
    Height = 32
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 4
  end
end
