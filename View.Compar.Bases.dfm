object ViewComparacaoBase: TViewComparacaoBase
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Comparador de Registros'
  ClientHeight = 720
  ClientWidth = 817
  Color = cl3DLight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 175
    Top = 8
    Width = 467
    Height = 30
    Caption = 'Comparador de Registros entre Bases de Dados:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 589
    Width = 103
    Height = 21
    Caption = 'Base original:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 645
    Width = 108
    Height = 21
    Caption = 'Base ajustada:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblDiferenca: TLabel
    Left = 552
    Top = 589
    Width = 4
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object ListaCompara: TStringGrid
    Left = 17
    Top = 54
    Width = 784
    Height = 529
    Color = clDefault
    FixedColor = clBlack
    RowCount = 1
    FixedRows = 0
    GradientStartColor = clSilver
    TabOrder = 0
    OnDrawCell = ListaComparaDrawCell
  end
  object EdtBase1: TEdit
    Left = 16
    Top = 616
    Width = 401
    Height = 23
    Enabled = False
    TabOrder = 1
  end
  object EdtBase2: TEdit
    Left = 16
    Top = 672
    Width = 401
    Height = 23
    Enabled = False
    TabOrder = 4
  end
  object BtnBase1: TButton
    Left = 423
    Top = 616
    Width = 34
    Height = 23
    Caption = '...'
    TabOrder = 2
    OnClick = BtnBase1Click
  end
  object BtnBase2: TButton
    Left = 423
    Top = 672
    Width = 34
    Height = 23
    Caption = '...'
    TabOrder = 5
    OnClick = BtnBase2Click
  end
  object Panel1: TPanel
    Left = 552
    Top = 616
    Width = 249
    Height = 79
    Cursor = crHandPoint
    BevelOuter = bvNone
    Caption = 'Comparar Registros'
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    OnClick = Panel1Click
    OnMouseEnter = Panel1MouseEnter
    OnMouseLeave = Panel1MouseLeave
  end
end
