object frmViewFile: TfrmViewFile
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1092#1072#1081#1083#1072
  ClientHeight = 681
  ClientWidth = 882
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object HtmlViewer: THtmlViewer
    Left = 0
    Top = 0
    Width = 882
    Height = 681
    BorderStyle = htFocused
    DefBackground = clInactiveBorder
    DefFontColor = clBlack
    DefFontName = 'Arial Narrow'
    DefFontSize = 16
    DefPreFontName = 'Arial'
    HistoryMaxCount = 0
    HtOptions = [htPrintTableBackground, htPrintMonochromeBlack, htShowVScroll]
    NoSelect = False
    PrintMarginBottom = 2.000000000000000000
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintScale = 1.000000000000000000
    Align = alClient
    TabOrder = 0
    OnKeyDown = HtmlViewerKeyDown
    Touch.InteractiveGestures = [igPan]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
  end
  object Connection: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=WIN1251'
      'DriverID=IB')
    LoginPrompt = False
    Left = 632
    Top = 136
  end
  object ReadTransaction: TFDTransaction
    Options.ReadOnly = True
    Connection = Connection
    Left = 632
    Top = 264
  end
  object DataSet: TupAnyDataSet
    Connection = Connection
    Transaction = ReadTransaction
    UpdateTransaction = ReadTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvStrsTrim]
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'select'
      '    cast(RF.XML_FILE as blob) "FILE"    '
      'from'
      '    REG_FILES RF'
      'where'
      '    RF.DATEON = :DATEON '
      '    and RF.OWNER_NAME = :OWNER_NAME')
    Left = 632
    Top = 200
    ParamData = <
      item
        Name = 'DATEON'
        ParamType = ptInput
      end
      item
        Name = 'OWNER_NAME'
        ParamType = ptInput
      end>
  end
  object FindDialog: TFindDialog
    OnFind = FindDialogFind
    Left = 520
    Top = 360
  end
end
