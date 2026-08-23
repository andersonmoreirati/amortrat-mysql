object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Table1: TTable
    DatabaseName = 'c:\rec'
    TableName = 'pecas.DB'
    Left = 368
    Top = 200
    object Table1COD_CLI: TStringField
      FieldName = 'COD_CLI'
      Size = 4
    end
    object Table1CODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 2
    end
    object Table1COD_PROC: TStringField
      FieldName = 'COD_PROC'
      Size = 3
    end
    object Table1DESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 30
    end
    object Table1MATERIAL: TStringField
      FieldName = 'MATERIAL'
    end
    object Table1PRECO: TCurrencyField
      FieldName = 'PRECO'
    end
    object Table1DUREZA: TStringField
      FieldName = 'DUREZA'
      Size = 15
    end
    object Table1FIGURA: TGraphicField
      FieldName = 'FIGURA'
      BlobType = ftGraphic
    end
  end
  object Table2: TTable
    DatabaseName = 'c:\rec'
    TableName = 'pecas2.DB'
    Left = 400
    Top = 200
    object Table2COD_CLI: TStringField
      FieldName = 'COD_CLI'
      Size = 4
    end
    object Table2CODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 2
    end
    object Table2COD_PROC: TStringField
      FieldName = 'COD_PROC'
      Size = 3
    end
    object Table2DESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 30
    end
    object Table2MATERIAL: TStringField
      FieldName = 'MATERIAL'
    end
    object Table2PRECO: TCurrencyField
      FieldName = 'PRECO'
    end
    object Table2DUREZA: TStringField
      FieldName = 'DUREZA'
      Size = 15
    end
    object Table2FIGURA: TGraphicField
      FieldName = 'FIGURA'
      BlobType = ftGraphic
    end
  end
end
