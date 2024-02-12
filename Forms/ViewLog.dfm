object frmViewLog: TfrmViewLog
  Left = 0
  Top = 0
  Caption = #1051#1086#1075
  ClientHeight = 538
  ClientWidth = 886
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcLog: TcxPageControl
    Left = 0
    Top = 0
    Width = 886
    Height = 538
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tabLog
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 534
    ClientRectLeft = 4
    ClientRectRight = 882
    ClientRectTop = 24
    object tabLog: TcxTabSheet
      Caption = #1051#1086#1075
      ImageIndex = 0
      OnShow = tabLogShow
      object grLog: TcxGrid
        Left = 0
        Top = 30
        Width = 878
        Height = 480
        Align = alClient
        TabOrder = 0
        object grLogView: TMyGridDBTableView
          OnKeyDown = grLogViewKeyDown
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.CopyCaptionsToClipboard = False
          OptionsBehavior.CopyRecordsToClipboard = False
          OptionsBehavior.IncSearch = True
          OptionsBehavior.CopyPreviewToClipboard = False
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.ColumnsQuickCustomizationReordering = qcrEnabled
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderFilterButtonShowMode = fbmButton
          OptionsView.Indicator = True
          OptionsView.BandHeaders = False
          Bands = <
            item
            end>
          UseFilterPeriod = False
          NotNull = False
          object colServiceName: TMyGridDBColumn
            Caption = #1048#1084#1103' '#1089#1077#1088#1074#1080#1089#1072
            DataBinding.FieldName = 'SERVICE_NAME'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 168
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
            NotNullValue = False
          end
          object colHWND: TMyGridDBColumn
            Caption = 'ID'
            DataBinding.FieldName = 'HWND'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
            NotNullValue = False
          end
          object colComments: TMyGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'COMMENT'
            HeaderAlignmentHorz = taCenter
            Width = 454
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
            NotNullValue = False
          end
          object colDateon: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1073#1099#1090#1080#1103
            DataBinding.FieldName = 'DATEON'
            HeaderAlignmentHorz = taCenter
            Width = 130
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
            NotNullValue = False
          end
          object colColor: TMyGridDBColumn
            Caption = #1062#1074#1077#1090
            DataBinding.FieldName = 'COLOR'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
            NotNullValue = False
          end
        end
        object grLogLevel: TcxGridLevel
          GridView = grLogView
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 878
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object butRefreshLog: TcxButton
          Left = 309
          Top = 3
          Width = 78
          Height = 24
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 0
          OnClick = butRefreshLogClick
        end
        object teLogDateEnd: TcxDateEdit
          Left = 178
          Top = 4
          Properties.DateButtons = [btnClear, btnNow, btnToday]
          Properties.Kind = ckDateTime
          TabOrder = 1
          Width = 124
        end
        object teLogDateStart: TcxDateEdit
          Left = 26
          Top = 4
          Properties.DateButtons = [btnClear, btnNow, btnToday]
          Properties.Kind = ckDateTime
          TabOrder = 2
          Width = 124
        end
        object cxLabel1: TcxLabel
          Left = 155
          Top = 5
          Caption = #1087#1086
          Transparent = True
        end
        object cxLabel2: TcxLabel
          Left = 8
          Top = 5
          Caption = #1057
          Transparent = True
        end
      end
    end
    object tabFiles: TcxTabSheet
      Caption = #1051#1086#1075' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      OnShow = tabFilesShow
      object grFiles: TcxGrid
        Left = 0
        Top = 30
        Width = 878
        Height = 480
        Align = alClient
        TabOrder = 0
        object grFilesView: TMyGridDBTableView
          PopupMenu = PopupMenuFiles
          OnKeyDown = grFilesViewKeyDown
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.CopyCaptionsToClipboard = False
          OptionsBehavior.CopyRecordsToClipboard = False
          OptionsBehavior.IncSearch = True
          OptionsBehavior.CopyPreviewToClipboard = False
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.ColumnsQuickCustomizationReordering = qcrEnabled
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderFilterButtonShowMode = fbmButton
          OptionsView.Indicator = True
          OptionsView.BandHeaders = False
          Bands = <
            item
            end>
          UseFilterPeriod = False
          NotNull = False
          object grFilesViewDATEON: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1073#1099#1090#1080#1103
            DataBinding.FieldName = 'DATEON'
            HeaderAlignmentHorz = taCenter
            Width = 130
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
            NotNullValue = False
          end
          object grFilesViewOWNER: TMyGridDBColumn
            Caption = #1048#1084#1103' '#1089#1077#1088#1074#1080#1089#1072
            DataBinding.FieldName = 'OWNER'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 168
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
            NotNullValue = False
          end
          object grFilesViewFILE: TMyGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'FILE'
            OnGetProperties = grFilesViewFILEGetProperties
            HeaderAlignmentHorz = taCenter
            Width = 454
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
            NotNullValue = False
          end
          object grFilesViewANSWER: TMyGridDBColumn
            Caption = #1054#1090#1074#1077#1090
            DataBinding.FieldName = 'ANSWER'
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
            NotNullValue = False
          end
        end
        object grFilesLevel: TcxGridLevel
          GridView = grFilesView
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 878
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object butRefreshFiles: TcxButton
          Left = 569
          Top = 3
          Width = 78
          Height = 24
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 0
          OnClick = butRefreshFilesClick
        end
        object teFilesDateEnd: TcxDateEdit
          Left = 178
          Top = 4
          Properties.DateButtons = [btnClear, btnNow, btnToday]
          Properties.Kind = ckDateTime
          TabOrder = 1
          Width = 124
        end
        object teFilesDateStart: TcxDateEdit
          Left = 26
          Top = 4
          Properties.DateButtons = [btnClear, btnNow, btnToday]
          Properties.Kind = ckDateTime
          TabOrder = 2
          Width = 124
        end
        object cxLabel3: TcxLabel
          Left = 155
          Top = 5
          Caption = #1087#1086
          Transparent = True
        end
        object cxLabel4: TcxLabel
          Left = 8
          Top = 5
          Caption = #1057
          Transparent = True
        end
        object teFilesSearch: TcxTextEdit
          Left = 320
          Top = 4
          TabOrder = 5
          Width = 233
        end
      end
    end
  end
  object PopupMenuFiles: TPopupMenu
    Left = 660
    Top = 272
    object N1: TMenuItem
      Caption = #1055#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1072#1081#1083
      OnClick = N2Click
    end
  end
  object EditRepository: TcxEditRepository
    Left = 360
    Top = 406
    object TextEditPhone: TcxEditRepositoryMaskItem
      Properties.Alignment.Horz = taCenter
      Properties.MaskKind = emkRegExprEx
      Properties.EditMask = '\d-\d\d\d- \d\d\d - \d\d - \d\d'
      Properties.MaxLength = 0
      Properties.UseLeftAlignmentOnEditing = False
    end
    object EditRepositoryMemoItem1: TcxEditRepositoryMemoItem
      Properties.ScrollBars = ssVertical
      Properties.VisibleLineCount = 2
    end
    object EditRepositoryMemoItem2: TcxEditRepositoryMemoItem
      Properties.ScrollBars = ssVertical
      Properties.VisibleLineCount = 2
    end
    object EditRepositoryMemoItem3: TcxEditRepositoryMemoItem
      Properties.ScrollBars = ssVertical
      Properties.VisibleLineCount = 3
    end
    object EditRepositoryMemoItem4: TcxEditRepositoryMemoItem
      Properties.ScrollBars = ssVertical
      Properties.VisibleLineCount = 4
    end
    object EditRepositoryMemoItem5: TcxEditRepositoryMemoItem
      Properties.ScrollBars = ssVertical
      Properties.VisibleLineCount = 5
    end
  end
  object LogConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=LOG')
    LoginPrompt = False
    Transaction = ReadOnlyTransaction
    UpdateTransaction = ReadOnlyTransaction
    Left = 428
    Top = 176
  end
  object ReadOnlyTransaction: TFDTransaction
    Options.ReadOnly = True
    Connection = LogConnection
    Left = 428
    Top = 240
  end
  object DataSourceLog: TDataSource
    DataSet = dsLog
    Left = 532
    Top = 352
  end
  object DataSourceLogFiles: TDataSource
    DataSet = dsLogFiles
    Left = 636
    Top = 352
  end
  object dsLog: TupAnyDataSet
    Connection = LogConnection
    Transaction = ReadOnlyTransaction
    UpdateTransaction = ReadOnlyTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'select '
      '    RS.DATEON'
      '    ,RS.SERVICE_NAME'
      '    ,RS.COLOR'
      '    ,RS.HWND'
      '    ,RS.COMMENT '
      'from '
      '    REG_SERVICES RS'
      'where '
      '    RS.DATEON between :DATESTART and :DATEEND'
      'order by '
      '    RS.DATEON')
    Left = 148
    Top = 176
    ParamData = <
      item
        Name = 'DATESTART'
        ParamType = ptInput
      end
      item
        Name = 'DATEEND'
        ParamType = ptInput
      end>
  end
  object dsLogFiles: TupAnyDataSet
    Connection = LogConnection
    Transaction = ReadOnlyTransaction
    UpdateTransaction = ReadOnlyTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'select'
      '    RF.ID'
      '    ,RF.DATEON "DATEON"'
      '    ,RF.OWNER_NAME "OWNER"'
      '    ,left(RF.XML_FILE, 1000) "FILE"'
      '    ,left(RF.ANSWER, 1000) "ANSWER"'
      'from'
      '    REG_FILES RF'
      'order by'
      '    RF.DATEON')
    Left = 148
    Top = 232
  end
  object dsGetFile: TupAnyDataSet
    Connection = LogConnection
    Transaction = ReadOnlyTransaction
    UpdateTransaction = ReadOnlyTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'select'
      '    RF.XML_FILE "FILE"    '
      'from'
      '    REG_FILES RF'
      'where'
      '    RF.ID = :ID')
    Left = 148
    Top = 288
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
end
