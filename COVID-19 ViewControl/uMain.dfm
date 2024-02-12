object Form5: TForm5
  Left = 0
  Top = 0
  Caption = #1056#1077#1075#1080#1089#1090#1088' COVID-19'
  ClientHeight = 809
  ClientWidth = 1089
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1089
    Height = 809
    ActivePage = tsUpload
    Align = alClient
    TabOrder = 0
    object tsUpload: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1074#1099#1075#1088#1091#1079#1082#1077
      object pConfigView: TPanel
        Left = 0
        Top = 0
        Width = 1081
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object cxBtnRefresh: TcxButton
          Left = 5
          Top = 5
          Width = 75
          Height = 23
          Align = alLeft
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 0
          OnClick = cxBtnRefreshClick
        end
        object cxLblDataBy: TcxLabel
          AlignWithMargins = True
          Left = 389
          Top = 5
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Caption = #1087#1086':'
          Properties.Alignment.Vert = taVCenter
          AnchorY = 17
        end
        object cxDtEFrom: TcxDateEdit
          Left = 258
          Top = 5
          Align = alLeft
          TabOrder = 2
          Width = 121
        end
        object cxLblDataFrom: TcxLabel
          AlignWithMargins = True
          Left = 90
          Top = 5
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'./'#1088#1077#1076#1072#1082'./'#1074#1099#1075#1088#1091#1079#1082#1080' '#1089':'
          Properties.Alignment.Vert = taVCenter
          AnchorY = 17
        end
        object cxDtEBy: TcxDateEdit
          Left = 414
          Top = 5
          Align = alLeft
          TabOrder = 4
          Width = 121
        end
        object cxBtnRepeatUpload: TcxButton
          Left = 979
          Top = 5
          Width = 97
          Height = 23
          Align = alRight
          Caption = #1055#1077#1088#1077#1074#1099#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 5
          OnClick = cxBtnRepeatUploadClick
        end
        object cxCheckBox1: TcxCheckBox
          AlignWithMargins = True
          Left = 550
          Top = 5
          Margins.Left = 15
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1074#1099#1075#1088#1091#1078#1077#1085#1085#1099#1077
          Properties.OnEditValueChanged = cxCheckBox1PropertiesEditValueChanged
          State = cbsChecked
          TabOrder = 6
          Width = 203
        end
        object btnGetRecord: TcxButton
          Left = 882
          Top = 5
          Width = 97
          Height = 23
          Align = alRight
          Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100
          TabOrder = 7
          OnClick = btnGetRecordClick
        end
        object btnDel: TcxButton
          Left = 785
          Top = 5
          Width = 97
          Height = 23
          Align = alRight
          Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1088#1077#1075'.'
          TabOrder = 8
          OnClick = btnDelClick
        end
      end
      object cxGridCovid19: TcxGrid
        Left = 0
        Top = 33
        Width = 1081
        Height = 568
        Align = alTop
        TabOrder = 1
        object cxGridCovid19DBTableView: TMyGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          OnFocusedRecordChanged = cxGridCovid19DBTableViewFocusedRecordChanged
          DataController.DataSource = DataSourceCOVID19
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.CellAutoHeight = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          Styles.OnGetContentStyle = cxGridCovid19DBTableViewStylesGetContentStyle
          Bands = <
            item
            end>
          UseFilterPeriod = False
          NotNull = False
          object GridCovid19DB_ID: TMyGridDBColumn
            DataBinding.FieldName = 'COVID_ID'
            Options.Editing = False
            Width = 97
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColRepeatUpload: TMyGridDBColumn
            Caption = #1055#1077#1088#1077#1074#1099#1075#1088#1091#1079#1080#1090#1100
            DataBinding.FieldName = 'IS_REPEAT_UPLOAD'
            Options.Editing = False
            Width = 49
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColDateEdit: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
            DataBinding.FieldName = 'DATE_LAST_EDIT'
            Options.Editing = False
            Width = 98
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridCovid19DateUpload: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DATE_SEND'
            Options.Editing = False
            Width = 88
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColDateEditSended: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' ('#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1086#1075#1086')'
            DataBinding.FieldName = 'DATE_LAST_EDIT_SENDED'
            Options.Editing = False
            Width = 122
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColResSended: TMyGridDBColumn
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1086#1090#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'SEND_STATUS'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Items = <
              item
                ImageIndex = 0
              end
              item
                Description = #1054#1090#1087#1088#1072#1074#1083#1077#1085
                Value = 0
              end
              item
                Description = #1054#1096#1080#1073#1082#1072' '#1074' '#1092#1072#1081#1083#1077
                Value = 1
              end
              item
                Description = #1054#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077
                Value = 2
              end>
            Options.Editing = False
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColTypeSend: TMyGridDBColumn
            Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'TYPE_SENDED_TITLE'
            Options.Editing = False
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColMessage: TMyGridDBColumn
            Caption = #1054#1090#1074#1077#1090
            DataBinding.FieldName = 'MESSAGE'
            Options.Editing = False
            Options.AutoWidthSizable = False
            Width = 540
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColDateDoc: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DATEDOC'
            Options.Editing = False
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19ColTitle: TMyGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'TITLE'
            Options.Editing = False
            Width = 137
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
            NotNullValue = False
          end
          object cxGridCovid19DBUIN: TMyGridDBColumn
            Caption = #1059#1048' '#1074' '#1088#1077#1075#1080#1089#1090#1088#1077
            DataBinding.FieldName = 'UIN'
            PropertiesClassName = 'TcxTextEditProperties'
            Options.Editing = False
            Width = 127
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridCovid19DB_UIN_Last: TMyGridDBColumn
            DataBinding.FieldName = 'UIN_LAST'
            Visible = False
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridCovid19DB_IsAnswered: TMyGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1077#1085' '#1086#1090#1074#1077#1090
            DataBinding.FieldName = 'IS_ANSWERED'
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridCovid19DBlast_Send_title: TMyGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076#1085#1077#1077' '#1091#1076#1072#1095#1085#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
            DataBinding.FieldName = 'last_Send_title'
            Options.Editing = False
            Width = 113
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridCovid19DBPARENT_DOC_COVID: TMyGridDBColumn
            Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'PARENT_DOC_COVID'
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 14
            Position.RowIndex = 0
            NotNullValue = False
          end
        end
        object cxGridCovid19Level: TcxGridLevel
          GridView = cxGridCovid19DBTableView
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 601
        Width = 1081
        Height = 180
        Align = alClient
        Caption = #1048#1089#1090#1086#1088#1080#1103' '#1074#1099#1075#1088#1091#1079#1082#1080
        TabOrder = 2
        object cxGridHistoryUpload: TcxGrid
          Left = 2
          Top = 15
          Width = 1077
          Height = 163
          Align = alClient
          TabOrder = 0
          object MyGridDBHistoryUpload: TMyGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DataSourceHistoryUpload
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.CellAutoHeight = True
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            Bands = <
              item
              end>
            UseFilterPeriod = False
            NotNull = False
            object MyGridDBHistoryUploadDATE_SEND: TMyGridDBColumn
              Caption = #1076#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
              DataBinding.FieldName = 'DATE_SEND'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadUIN: TMyGridDBColumn
              Caption = #1059#1048' '#1074' '#1088#1077#1075#1080#1089#1090#1088#1077
              DataBinding.FieldName = 'UIN'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 1
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadIS_REPEAT_UPLOAD: TMyGridDBColumn
              Caption = #1055#1077#1088#1077#1074#1099#1075#1088#1091#1079#1080#1090#1100
              DataBinding.FieldName = 'IS_REPEAT_UPLOAD'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 2
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadDATE_LAST_EDIT: TMyGridDBColumn
              Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1074#1099#1075#1088#1091#1078#1077#1085#1086#1075#1086
              DataBinding.FieldName = 'DATE_LAST_EDIT'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 3
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadMESSAGE: TMyGridDBColumn
              Caption = #1054#1090#1074#1077#1090
              DataBinding.FieldName = 'MESSAGE'
              Options.Editing = False
              Width = 354
              Position.BandIndex = 0
              Position.ColIndex = 4
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadUIN_SYNC: TMyGridDBColumn
              Caption = #1059#1048' '#1089#1080#1085#1093#1088#1086#1085#1085#1099#1081
              DataBinding.FieldName = 'UIN_SYNC'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 5
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadSEND_STATUS: TMyGridDBColumn
              Caption = #1057#1090#1072#1090#1091#1089' '#1086#1090#1087#1088#1072#1074#1082#1080
              DataBinding.FieldName = 'SEND_STATUS'
              Options.Editing = False
              Width = 61
              Position.BandIndex = 0
              Position.ColIndex = 6
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadTYPE_SEND_TITLE: TMyGridDBColumn
              Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080
              DataBinding.FieldName = 'TYPE_SEND_TITLE'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 7
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadTYPE_SEND_COD: TMyGridDBColumn
              Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1082#1086#1076
              DataBinding.FieldName = 'TYPE_SEND_COD'
              Options.Editing = False
              Width = 60
              Position.BandIndex = 0
              Position.ColIndex = 8
              Position.RowIndex = 0
              NotNullValue = False
            end
            object MyGridDBHistoryUploadIS_ANSWERED: TMyGridDBColumn
              DataBinding.FieldName = 'IS_ANSWERED'
              Position.BandIndex = 0
              Position.ColIndex = 9
              Position.RowIndex = 0
              NotNullValue = False
            end
          end
          object cxGridLevelHistoryUpload: TcxGridLevel
            GridView = MyGridDBHistoryUpload
          end
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1079#1072#1087#1088#1086#1089#1072#1084
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1081
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object btnRefreshGet: TcxButton
          Left = 5
          Top = 5
          Width = 75
          Height = 23
          Align = alLeft
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btnRefreshGetClick
        end
        object cxLabel1: TcxLabel
          AlignWithMargins = True
          Left = 389
          Top = 5
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Caption = #1087#1086':'
          Properties.Alignment.Vert = taVCenter
          AnchorY = 17
        end
        object cxDateGetFrom: TcxDateEdit
          Left = 258
          Top = 5
          Align = alLeft
          TabOrder = 2
          Width = 121
        end
        object cxLabel2: TcxLabel
          AlignWithMargins = True
          Left = 90
          Top = 5
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'./'#1088#1077#1076#1072#1082'./'#1074#1099#1075#1088#1091#1079#1082#1080' '#1089':'
          Properties.Alignment.Vert = taVCenter
          AnchorY = 17
        end
        object cxDateGetBy: TcxDateEdit
          Left = 414
          Top = 5
          Align = alLeft
          TabOrder = 4
          Width = 121
        end
        object cxButton2: TcxButton
          Left = 979
          Top = 5
          Width = 97
          Height = 23
          Align = alRight
          Caption = #1055#1077#1088#1077#1079#1072#1087#1088#1086#1089#1080#1090#1100
          TabOrder = 5
          OnClick = cxBtnRepeatUploadClick
        end
      end
      object GridCOVID19Get: TcxGrid
        Left = 0
        Top = 33
        Width = 1081
        Height = 568
        Align = alTop
        TabOrder = 1
        object GridDBCOVID19Get: TMyGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          OnFocusedRecordChanged = GridDBCOVID19GetFocusedRecordChanged
          DataController.DataSource = DataSourceCOVID19Get
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.CellAutoHeight = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          Bands = <
            item
            end>
          UseFilterPeriod = False
          NotNull = False
          object GridDBCOVID19Get_CovidID: TMyGridDBColumn
            DataBinding.FieldName = 'COVID_ID'
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_IsRepUpload: TMyGridDBColumn
            Caption = #1055#1077#1088#1077#1074#1099#1075#1088#1091#1079#1080#1090#1100
            DataBinding.FieldName = 'IS_REPEAT_UPLOAD'
            Options.Editing = False
            Width = 49
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_DateLastEdit: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
            DataBinding.FieldName = 'DATE_LAST_EDIT'
            Options.Editing = False
            Width = 98
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_DateSend: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DATE_SEND'
            Options.Editing = False
            Width = 88
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_DateLastEditSended: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' ('#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1086#1075#1086')'
            DataBinding.FieldName = 'DATE_LAST_EDIT_SENDED'
            Options.Editing = False
            Width = 122
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19GetSendStatus: TMyGridDBColumn
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1086#1090#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'SEND_STATUS'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Items = <
              item
                ImageIndex = 0
              end
              item
                Description = #1054#1090#1087#1088#1072#1074#1083#1077#1085
                Value = 0
              end
              item
                Description = #1054#1096#1080#1073#1082#1072' '#1074' '#1092#1072#1081#1083#1077
                Value = 1
              end
              item
                Description = #1054#1096#1080#1073#1082#1072' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077
                Value = 2
              end>
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_TypeSendedTitle: TMyGridDBColumn
            Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'TYPE_SENDED_TITLE'
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_Message: TMyGridDBColumn
            Caption = #1054#1090#1074#1077#1090
            DataBinding.FieldName = 'MESSAGE'
            Options.Editing = False
            Options.AutoWidthSizable = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_DateDoc: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DATEDOC'
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_Title: TMyGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'TITLE'
            Options.Editing = False
            Width = 81
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_UIN: TMyGridDBColumn
            Caption = #1059#1048' '#1074' '#1088#1077#1075#1080#1089#1090#1088#1077
            DataBinding.FieldName = 'UIN'
            PropertiesClassName = 'TcxTextEditProperties'
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBCOVID19Get_UinLast: TMyGridDBColumn
            DataBinding.FieldName = 'UIN_LAST'
            Visible = False
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
            NotNullValue = False
          end
        end
        object GridLevelCOVID19Get: TcxGridLevel
          GridView = GridDBCOVID19Get
        end
      end
      object GridGetHistory: TcxGrid
        Left = 0
        Top = 601
        Width = 1081
        Height = 180
        Align = alClient
        TabOrder = 2
        object GridDBGetHistory: TMyGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSourceGetHistory
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.CellAutoHeight = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          Bands = <
            item
            end>
          UseFilterPeriod = False
          NotNull = False
          object GridDBGetHistory_DateSend: TMyGridDBColumn
            Caption = #1076#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DATE_SEND'
            Options.Editing = False
            Width = 72
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistory_UIN: TMyGridDBColumn
            Caption = #1059#1048' '#1074' '#1088#1077#1075#1080#1089#1090#1088#1077
            DataBinding.FieldName = 'UIN'
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistoryDateLastEdit: TMyGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1074#1099#1075#1088#1091#1078#1077#1085#1086#1075#1086
            DataBinding.FieldName = 'DATE_LAST_EDIT'
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistoryMessage: TMyGridDBColumn
            Caption = #1054#1090#1074#1077#1090
            DataBinding.FieldName = 'MESS_B'
            Options.Editing = False
            Width = 485
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistoryUINSync: TMyGridDBColumn
            Caption = #1059#1048' '#1089#1080#1085#1093#1088#1086#1085#1085#1099#1081
            DataBinding.FieldName = 'UIN_SYNC'
            Options.Editing = False
            Width = 69
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistorySendStatus: TMyGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1086#1090#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'SEND_STATUS'
            Options.Editing = False
            Width = 72
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistoryTypeSendTitle: TMyGridDBColumn
            Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'TYPE_SEND_TITLE'
            Options.Editing = False
            Width = 72
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
            NotNullValue = False
          end
          object GridDBGetHistoryTypeSendCod: TMyGridDBColumn
            Caption = #1058#1080#1087' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1082#1086#1076
            DataBinding.FieldName = 'TYPE_SEND_COD'
            Options.Editing = False
            Width = 74
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
            NotNullValue = False
          end
        end
        object GridLevelGetHistory: TcxGridLevel
          GridView = GridDBGetHistory
        end
      end
    end
  end
  object MSSQLConnection: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL'
      'Server=188.170.186.5,1433'
      'User_Name=sa'
      'Password=Sa1512')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 84
    Top = 232
  end
  object Transaction: TFDTransaction
    Connection = MSSQLConnection
    Left = 84
    Top = 296
  end
  object dsCOVID19: TupAnyDataSet
    Connection = MSSQLConnection
    Transaction = Transaction
    UpdateTransaction = Transaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID'
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'SELECT '
      '    a.id COVID_ID'
      '    , a.NUMBER'
      '    , a.TITLE'
      '    , a.DATEDOC '
      '    , a.DATE_LAST_EDIT'
      '    , a.DATE_UPLOAD'
      '    , rec.IS_ANSWERED'
      '    , rec.UIN UIN_LAST'
      
        '    , (SELECT cu.UIN FROM MIS_KSAMU.dbo.COVID_UIN cu WHERE cu.ow' +
        'ner = a.id) UIN'
      '    , rec.DATE_SEND'
      '    , rcts.TITLE TYPE_SENDED_TITLE'
      '    , rec.IS_REPEAT_UPLOAD'
      '    , rec.DATE_LAST_EDIT DATE_LAST_EDIT_SENDED'
      '    , rec.ID'
      '    , rec.SEND_STATUS'
      '    , rec.MESS_B'
      '    , rec.MESSAGE'
      '    , LSA.CODE AS last_Send_code, LSA.TITLE last_Send_title'
      '    , a.PARENT_DOC_COVID'
      '    FROM MIS_KSAMU.dbo.DOC_COVID a '
      
        '    LEFT JOIN MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec ON rec.OWNER ' +
        '= a.ID '
      
        '    left JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rcts ON rcts.ID ' +
        '= rec.TYPE_SENDED'
      
        '    LEFT JOIN MIS_KSAMU.dbo.COVID_Last_Applied_Action lsa ON lsa' +
        '.OWNER = a.ID'
      
        'WHERE (rec.ID = (SELECT TOP 1 rec1.ID from MIS_KSAMU.dbo.REG_EXT' +
        'ERNAL_COVID rec1'
      
        '                left JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rcts' +
        '1 ON rcts1.ID = rec1.TYPE_SENDED'
      
        '                WHERE rec1.owner = a.id AND (rec1.TYPE_SENDED is' +
        ' null '
      
        '                                             or rcts1.code != 3)' +
        '  --or rcts1.code in (1, 2, 4, 5, 6))'
      '                ORDER BY rec1.DATE_SEND DESC)'
      '    OR (rec.ID IS NULL AND 1 = :SHOW_ALL)'
      '    )    '
      
        '    AND ((a.DATE_LAST_EDIT >= :DATE_FROM AND a.DATE_LAST_EDIT <=' +
        ' :DATE_BY) '
      
        '        OR (rec.DATE_SEND >= :DATE_FROM AND rec.DATE_SEND <= :DA' +
        'TE_BY))')
    Left = 268
    Top = 320
    ParamData = <
      item
        Name = 'SHOW_ALL'
        ParamType = ptInput
      end
      item
        Name = 'DATE_FROM'
        ParamType = ptInput
      end
      item
        Name = 'DATE_BY'
        ParamType = ptInput
      end>
  end
  object DataSourceCOVID19: TDataSource
    DataSet = dsCOVID19
    Left = 268
    Top = 368
  end
  object dsHistoryUpload: TupAnyDataSet
    Connection = MSSQLConnection
    Transaction = Transaction
    UpdateTransaction = Transaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID'
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'SELECT '
      '    rec.ID'
      '    , rec.IS_REPEAT_UPLOAD'
      '    , rec.DATE_SEND'
      '    , rec.UIN'
      '    , rec.MESS_B'
      '    , rec.MESSAGE '
      '    , rec.DATE_LAST_EDIT'
      '    , rec.UIN_SYNC'
      '    , rec.SEND_STATUS'
      '    , rcts.CODE TYPE_SEND_CODE'
      '    , rcts.TITLE TYPE_SEND_TITLE '
      '    , rec.IS_ANSWERED'
      '    from MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec '
      
        '    left JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rcts ON rcts.ID ' +
        '= rec.TYPE_SENDED'
      '    WHERE rec.OWNER = :OWNER'
      
        '         --and (rec.TYPE_SENDED is null or rcts.CODE in (1, 2, 4' +
        ', 5, 6))'
      '    ORDER BY rec.DATE_SEND')
    Left = 228
    Top = 424
    ParamData = <
      item
        Name = 'OWNER'
        ParamType = ptInput
      end>
  end
  object DataSourceHistoryUpload: TDataSource
    DataSet = dsHistoryUpload
    Left = 228
    Top = 472
  end
  object dsCOVID19Get: TupAnyDataSet
    Connection = MSSQLConnection
    Transaction = Transaction
    UpdateTransaction = Transaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID'
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'SELECT '
      '    a.id COVID_ID'
      '    , a.NUMBER'
      '    , a.TITLE'
      '    , a.DATEDOC '
      '    , a.DATE_LAST_EDIT'
      '    , a.DATE_UPLOAD'
      '    , rec.UIN UIN_LAST'
      
        '    , (SELECT TOP 1 rc.UIN FROM MIS_KSAMU.dbo.REG_EXTERNAL_COVID' +
        ' rc WHERE rc.OWNER = a.id ORDER BY rc.UIN desc) UIN'
      '    , rec.DATE_SEND'
      '    , rcts.TITLE TYPE_SENDED_TITLE'
      '    , rec.IS_REPEAT_UPLOAD'
      '    , rec.DATE_LAST_EDIT DATE_LAST_EDIT_SENDED'
      '    , rec.ID'
      '    , rec.SEND_STATUS'
      '    , rec.MESS_B'
      '    , rec.MESSAGE'
      '    FROM MIS_KSAMU.dbo.DOC_COVID a '
      
        '    inner JOIN MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec ON rec.OWNER' +
        ' = a.ID '
      
        '    inner JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rcts ON rcts.ID' +
        ' = rec.TYPE_SENDED  '
      'WHERE rcts.code = 3'
      
        '     AND (rec.ID = (SELECT TOP 1 rec1.ID from MIS_KSAMU.dbo.REG_' +
        'EXTERNAL_COVID rec1'
      '                WHERE rec1.owner = a.id'
      
        '                ORDER BY isnull(rec1.DATE_SEND, CAST('#39'31.12.9999' +
        #39' AS date)) DESC'
      '                )'
      '         )    '
      
        '    AND ((a.DATE_LAST_EDIT >= :DATE_FROM AND a.DATE_LAST_EDIT <=' +
        ' :DATE_BY) '
      
        '        OR (rec.DATE_SEND >= :DATE_FROM AND rec.DATE_SEND <= :DA' +
        'TE_BY)'
      '        OR rec.DATE_SEND IS null'
      '        )')
    Left = 484
    Top = 328
    ParamData = <
      item
        Name = 'DATE_FROM'
        ParamType = ptInput
      end
      item
        Name = 'DATE_BY'
        ParamType = ptInput
      end>
  end
  object DataSourceCOVID19Get: TDataSource
    DataSet = dsCOVID19Get
    Left = 484
    Top = 376
  end
  object dsCreateRequest: TupAnyDataSet
    Connection = MSSQLConnection
    Transaction = Transaction
    UpdateTransaction = Transaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID'
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      
        'INSERT INTO MIS_KSAMU.dbo.REG_EXTERNAL_COVID (ID, OWNER, TYPE_SE' +
        'NDED)'
      
        '    VALUES (:ID, :OWNER, (SELECT ID FROM MIS_KSAMU.dbo.REF_COVID' +
        '_TYPE_SEND WHERE CODE = :SEND_CODE))')
    Left = 476
    Top = 224
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'OWNER'
        ParamType = ptInput
      end
      item
        Name = 'SEND_CODE'
        ParamType = ptInput
      end>
  end
  object DataSourceGetHistory: TDataSource
    DataSet = dsGetHistory
    Left = 596
    Top = 448
  end
  object dsGetHistory: TupAnyDataSet
    Connection = MSSQLConnection
    Transaction = Transaction
    UpdateTransaction = Transaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvSE2Null, fvStrsTrim]
    FormatOptions.StrsEmpty2Null = True
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID'
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'SELECT '
      '    rec.ID'
      '    , rec.IS_REPEAT_UPLOAD'
      '    , rec.DATE_SEND'
      '    , rec.UIN'
      '    , cast(rec.MESS_B as varchar(7500)) MESS_B'
      '    , rec.MESSAGE '
      '    , rec.DATE_LAST_EDIT'
      '    , rec.UIN_SYNC'
      '    , rec.SEND_STATUS'
      '    , rcts.CODE TYPE_SEND_CODE'
      '    , rcts.TITLE TYPE_SEND_TITLE '
      '    from MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec '
      
        '    left JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rcts ON rcts.ID ' +
        '= rec.TYPE_SENDED'
      '    WHERE rec.OWNER = :OWNER'
      '         and rcts.CODE in (3 ,4)'
      '    ORDER BY rec.DATE_SEND')
    Left = 596
    Top = 400
    ParamData = <
      item
        Name = 'OWNER'
        ParamType = ptInput
      end>
  end
end
