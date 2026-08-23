object F_Relat: TF_Relat
  Left = 439
  Top = 219
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Ger. de Relatórios'
  ClientHeight = 297
  ClientWidth = 234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox7: TGroupBox
    Left = 5
    Top = 1
    Width = 228
    Height = 53
    Caption = 'Escolha o tipo de relatório'
    TabOrder = 0
    object VrLabel1: TVrLabel
      Left = 8
      Top = 14
      Width = 25
      Height = 14
      Alignment = taLeftJustify
      ColorShadow = clSilver
      Style = lsNone
      Transparent = True
      Color = clBtnFace
      Caption = 'Tipos de relatórios'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object ETipo: TComboBox97
      Left = 9
      Top = 28
      Width = 211
      Height = 19
      Style = csOwnerDrawFixed
      Flat = True
      Ctl3D = False
      DropDownCount = 12
      ItemHeight = 13
      Items.Strings = (
        'Cliente'
        'Fornecedores'
        'A Pagar Vencidos'
        'A Receber Vencidos'
        'Titulos por Cliente'
        'Titulos por Fornecedores'
        'Rateio')
      ParentCtl3D = False
      TabOrder = 0
      OnChange = ETipoChange
    end
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 61
    Width = 228
    Height = 76
    Caption = 'Escolha o índice do relatório'
    TabOrder = 1
    object VrLabel2: TVrLabel
      Left = 8
      Top = 14
      Width = 40
      Height = 14
      Alignment = taLeftJustify
      ColorShadow = clSilver
      Style = lsNone
      Transparent = True
      Color = clBtnFace
      Caption = 'Índice'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object EIndice: TComboBox97
      Left = 9
      Top = 28
      Width = 211
      Height = 19
      Style = csOwnerDrawFixed
      Flat = True
      Ctl3D = False
      DropDownCount = 12
      ItemHeight = 13
      Items.Strings = (
        'CODIGO'
        'NOME')
      ParentCtl3D = False
      TabOrder = 0
    end
    object OpDecresce: TVrCheckLed
      Left = 101
      Top = 51
      Width = 101
      Height = 19
      Palette.Low = clGray
      Palette.High = 10485760
      CheckStyle = csRadioButton
      BiDiMode = bdLeftToRight
      Caption = 'Decrescente'
      ParentBiDiMode = False
      TabOrder = 1
    end
    object OpCresce: TVrCheckLed
      Left = 21
      Top = 49
      Width = 87
      Height = 18
      Checked = True
      Palette.Low = clGray
      Palette.High = 10485760
      CheckStyle = csRadioButton
      BiDiMode = bdLeftToRight
      Caption = 'Crescente'
      ParentBiDiMode = False
      TabOrder = 2
    end
  end
  object BTGravarS: TIAeverButton
    Left = 121
    Top = 267
    Width = 101
    Height = 25
    Cursor = crHandPoint
    Caption = '&Sair'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = BTGravarSClick
    OnEnter = BTGravarSEnter
    OnExit = BTGravarSExit
    ButtonAngle = 0
    ButtonWidth = 101
    ButtonHeight = 25
    CaptionAngle = 0
    ButtonColor = clSilver
    ButtonKind = bkRoundRect
    Transparent = False
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
    onMouseEnter = BTGravarSMouseEnter
    onMouseExit = BTGravarSMouseExit
  end
  object BTGravarA: TIAeverButton
    Left = 16
    Top = 267
    Width = 101
    Height = 25
    Cursor = crHandPoint
    Caption = '&Visualizar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = BTGravarAClick
    OnEnter = BTGravarAEnter
    OnExit = BTGravarAExit
    ButtonAngle = 0
    ButtonWidth = 101
    ButtonHeight = 25
    CaptionAngle = 0
    ButtonColor = clSilver
    ButtonKind = bkRoundRect
    Transparent = False
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckPressed
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
    onMouseEnter = BTGravarAMouseEnter
    onMouseExit = BTGravarAMouseExit
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 202
    Width = 228
    Height = 57
    Caption = 'Condição do período'
    TabOrder = 3
    object VrLabel3: TVrLabel
      Left = 8
      Top = 14
      Width = 57
      Height = 14
      Alignment = taLeftJustify
      ColorShadow = clSilver
      Style = lsNone
      Transparent = True
      Color = clBtnFace
      Caption = 'Começo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object VrLabel4: TVrLabel
      Left = 114
      Top = 15
      Width = 25
      Height = 14
      Alignment = taLeftJustify
      ColorShadow = clSilver
      Style = lsNone
      Transparent = True
      Color = clBtnFace
      Caption = 'Fim'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object ECodigoB: TEdit
      Left = 8
      Top = 29
      Width = 105
      Height = 20
      TabStop = False
      AutoSize = False
      CharCase = ecUpperCase
      Color = 16382457
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object EDataC: TDateEdit
      Left = 9
      Top = 30
      Width = 104
      Height = 18
      Hint = 
        'Para acessar o calendário pelo teclado pressione as teclas ALT +' +
        ' Seta / baixo!'
      BorderStyle = bsNone
      Color = clBtnFace
      DialogTitle = 'Selecione uma data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      CalendarStyle = csDialog
      YearDigits = dyFour
      TabOrder = 1
      OnEnter = EDataCEnter
      OnExit = EDataCExit
    end
    object Edit1: TEdit
      Left = 115
      Top = 29
      Width = 105
      Height = 20
      TabStop = False
      AutoSize = False
      CharCase = ecUpperCase
      Color = 16382457
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object EDataF: TDateEdit
      Left = 116
      Top = 30
      Width = 104
      Height = 18
      Hint = 
        'Para acessar o calendário pelo teclado pressione as teclas ALT +' +
        ' Seta / baixo!'
      BorderStyle = bsNone
      Color = clBtnFace
      DialogTitle = 'Selecione uma data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      CalendarStyle = csDialog
      YearDigits = dyFour
      TabOrder = 3
      OnEnter = EDataFEnter
      OnExit = EDataFExit
    end
  end
  object GroupBox3: TGroupBox
    Left = 5
    Top = 143
    Width = 228
    Height = 53
    Caption = 'Condição Cliente/Fornec/Rateio'
    TabOrder = 2
    object VrLabel7: TVrLabel
      Left = 8
      Top = 13
      Width = 89
      Height = 14
      Alignment = taLeftJustify
      ColorShadow = clSilver
      Style = lsNone
      Transparent = True
      Color = clBtnFace
      Caption = 'Começa com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object EComecaC: TEdit
      Left = 9
      Top = 28
      Width = 211
      Height = 19
      CharCase = ecUpperCase
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      MaxLength = 40
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnEnter = EComecaCEnter
      OnExit = EComecaCExit
    end
  end
  object RxGradientCaption1: TRxGradientCaption
    Captions = <>
    DefaultFont = False
    FormCaption = 'Ger. de Relatórios'
    FontInactiveColor = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    GradientInactive = True
    GradientSteps = 0
    HideDirection = hdRightToLeft
    StartColor = 15395562
    Left = 150
  end
  object TabEnter1: TTabEnter
    ClassNotAffected.Strings = (
      'TMemo'
      'TButton'
      'TBitBtn')
    Enabled = True
    Left = 115
  end
  object QCliente: TRxQuery
    SQL.Strings = (
      'Select * from CLIENTE order by NOME')
    Macros = <>
    Left = 117
    Top = 98
  end
  object DsCliente: TDataSource
    DataSet = QCliente
    Left = 149
    Top = 98
  end
  object QReceber: TRxQuery
    SQL.Strings = (
      'Select * from Receber ')
    Macros = <>
    Left = 117
    Top = 66
  end
  object DsReceber: TDataSource
    DataSet = QReceber
    Left = 149
    Top = 66
  end
  object QPagar: TRxQuery
    Active = True
    SQL.Strings = (
      'Select * from Pagar')
    Macros = <>
    Left = 117
    Top = 34
    object QPagarREFERENCIA: TStringField
      FieldName = 'REFERENCIA'
      Size = 12
    end
    object QPagarDATA: TDateField
      FieldName = 'DATA'
    end
    object QPagarDATAB: TDateField
      FieldName = 'DATAB'
    end
    object QPagarFORNECEDOR: TStringField
      FieldName = 'FORNECEDOR'
      Size = 6
    end
    object QPagarFORNECNOME: TStringField
      FieldName = 'FORNECNOME'
      Size = 30
    end
    object QPagarCONTABIL: TCurrencyField
      FieldName = 'CONTABIL'
    end
    object QPagarVALOR: TCurrencyField
      FieldName = 'VALOR'
    end
    object QPagarSN: TStringField
      FieldName = 'SN'
      Size = 1
    end
    object QPagarCONTA: TStringField
      FieldName = 'CONTA'
      Size = 8
    end
    object QPagarRATEIO: TStringField
      FieldName = 'RATEIO'
      Size = 8
    end
    object QPagarJUROS: TCurrencyField
      FieldName = 'JUROS'
    end
    object QPagarDESCONTO: TCurrencyField
      FieldName = 'DESCONTO'
    end
    object QPagarOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 30
    end
    object QPagarCOR: TStringField
      FieldName = 'COR'
    end
    object QPagarTIPOTITULO: TStringField
      FieldName = 'TIPOTITULO'
    end
  end
  object DSPagar: TDataSource
    DataSet = QPagar
    Left = 149
    Top = 34
  end
  object QTitCli: TRxQuery
    Active = True
    SQL.Strings = (
      'Select * from Receber')
    Macros = <>
    Left = 117
    Top = 160
    object QTitCliREFERENCIA: TStringField
      FieldName = 'REFERENCIA'
      Size = 12
    end
    object QTitCliDATA: TDateField
      FieldName = 'DATA'
    end
    object QTitCliCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 6
    end
    object QTitCliCLINOME: TStringField
      FieldName = 'CLINOME'
      Size = 40
    end
    object QTitCliCONTABIL: TCurrencyField
      FieldName = 'CONTABIL'
    end
    object QTitCliDESC_BANCO: TCurrencyField
      FieldName = 'DESC_BANCO'
    end
    object QTitCliATRASADO: TCurrencyField
      FieldName = 'ATRASADO'
    end
    object QTitCliDEPOSITO: TCurrencyField
      FieldName = 'DEPOSITO'
    end
    object QTitCliDEP_SEMCONF: TCurrencyField
      FieldName = 'DEP_SEMCONF'
    end
    object QTitCliVALOR: TCurrencyField
      FieldName = 'VALOR'
    end
    object QTitCliCONTA: TStringField
      FieldName = 'CONTA'
      Size = 8
    end
    object QTitCliOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 30
    end
    object QTitCliFLOATING: TStringField
      FieldName = 'FLOATING'
      Size = 2
    end
    object QTitCliTIPOTITULO: TStringField
      FieldName = 'TIPOTITULO'
      Size = 9
    end
    object QTitCliCOLUNAD: TStringField
      FieldName = 'COLUNAD'
      Size = 1
    end
    object QTitCliJUROS: TCurrencyField
      FieldName = 'JUROS'
    end
    object QTitCliDESCONTO: TCurrencyField
      FieldName = 'DESCONTO'
    end
    object QTitCliRATEIO: TStringField
      FieldName = 'RATEIO'
      Size = 7
    end
    object QTitCliDATAB: TDateField
      FieldName = 'DATAB'
    end
    object QTitCliCOR: TStringField
      FieldName = 'COR'
    end
  end
  object DsTitCli: TDataSource
    DataSet = QTitCli
    Left = 149
    Top = 160
  end
  object QTitFornec: TRxQuery
    Active = True
    SQL.Strings = (
      'Select * from Pagar')
    Macros = <>
    Left = 117
    Top = 130
  end
  object DSTitFornec: TDataSource
    DataSet = QTitFornec
    Left = 149
    Top = 130
  end
  object QRateio: TRxQuery
    Active = True
    SQL.Strings = (
      'Select * from Rateio')
    Macros = <>
    Left = 117
    Top = 194
    object QRateioCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 7
    end
    object QRateioDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
    end
  end
  object DSRateio: TDataSource
    DataSet = QRateio
    Left = 149
    Top = 194
  end
end
