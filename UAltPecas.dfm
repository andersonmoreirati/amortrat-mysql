object Form1: TForm1
  Left = 516
  Top = 174
  Width = 324
  Height = 248
  Caption = 'Utilit'#225'rio para modifica'#231#227'o de BD'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 73
    Width = 123
    Height = 13
    Caption = 'Texto para altera'#231'ao:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 48
    Top = 152
    Width = 225
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'PROGRESSO...'
  end
  object barra: TProgressBar
    Left = 48
    Top = 168
    Width = 225
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 24
    Top = 88
    Width = 265
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 118
    Top = 114
    Width = 75
    Height = 25
    Caption = '&Alterar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object BTSair: TButton
    Left = 260
    Top = 197
    Width = 53
    Height = 15
    Caption = '&Sair'
    TabOrder = 3
    OnClick = BTSairClick
  end
  object StaticText1: TStaticText
    Left = 24
    Top = 8
    Width = 280
    Height = 17
    Caption = 'Adicione o texto para altera'#231#227'o do campo OBSERVA'#199#195'O '
    TabOrder = 4
  end
  object StaticText2: TStaticText
    Left = 36
    Top = 25
    Width = 251
    Height = 17
    Caption = 'da tabela PE'#199'AS. Ent'#227'o pressione o bot'#227'o alterar e '
    TabOrder = 5
  end
  object StaticText3: TStaticText
    Left = 80
    Top = 42
    Width = 153
    Height = 17
    Caption = 'aguarde o t'#233'rmino do processo.'
    TabOrder = 6
  end
  object DataSource1: TDataSource
    Left = 240
    Top = 48
  end
  object TBPecas: TTable
    DatabaseName = 'Amortrat'
    TableName = 'pecas.DB'
    Left = 272
    Top = 48
    object TBPecasCOD_CLI: TStringField
      FieldName = 'COD_CLI'
      Size = 4
    end
    object TBPecasCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 3
    end
    object TBPecasCOD_PROC: TStringField
      FieldName = 'COD_PROC'
      Size = 3
    end
    object TBPecasDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 30
    end
    object TBPecasMATERIAL: TStringField
      FieldName = 'MATERIAL'
    end
    object TBPecasPRECO: TCurrencyField
      FieldName = 'PRECO'
    end
    object TBPecasDUREZA: TStringField
      FieldName = 'DUREZA'
      Size = 15
    end
    object TBPecasFIGURA: TGraphicField
      FieldName = 'FIGURA'
      BlobType = ftGraphic
    end
    object TBPecasOBS: TStringField
      FieldName = 'OBS'
      Size = 30
    end
  end
end
