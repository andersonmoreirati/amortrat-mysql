object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 245
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 232
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 159
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Properties.Strings = (
      'RawStringEncoding=DB_CP')
    DisableSavepoints = False
    HostName = 'amortrat.com.br'
    Port = 3306
    Database = 'amortrat_dev'
    User = 'amortrat_dev'
    Password = 'Amortrat8141'
    Protocol = 'mysql'
    LibraryLocation = 'D:\AMORTRAT\mysql\code\libmysql.dll'
    Left = 344
    Top = 104
  end
  object ZTable1: TZTable
    Connection = ZConnection1
    Left = 360
    Top = 16
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    CachedUpdates = True
    Params = <>
    Left = 200
  end
end
