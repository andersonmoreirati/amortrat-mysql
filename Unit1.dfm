object Form1: TForm1
  Left = 214
  Top = 146
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
  object Image1: TImage
    Left = 272
    Top = 272
    Width = 105
    Height = 105
  end
  object DBGrid1: TDBGrid
    Left = 80
    Top = 128
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBImage1: TDBImage
    Left = 448
    Top = 128
    Width = 201
    Height = 209
    DataField = 'FIGURA'
    DataSource = DataSource1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 80
    Top = 264
    Width = 113
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Table1: TTable
    Active = True
    DatabaseName = 'amortrat'
    TableName = 'pecas.DB'
    Left = 192
    Top = 56
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
      Size = 10
    end
    object Table1FIGURA: TGraphicField
      FieldName = 'FIGURA'
      BlobType = ftGraphic
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 232
    Top = 56
  end
  object ImageList1: TImageList
    Left = 120
    Top = 16
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 200
    Top = 304
  end
end
