object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
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
  object DBGrid1: TDBGrid
    Left = 24
    Top = 8
    Width = 503
    Height = 229
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
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
    Left = 400
    Top = 8
  end
  object ZTable1: TZTable
    Left = 320
  end
end
