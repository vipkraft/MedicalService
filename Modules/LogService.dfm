object LogServiceModule: TLogServiceModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 298
  Width = 501
  object Connection: TFDConnection
    Params.Strings = (
      'DriverID=IB'
      'User_Name=sysdba'
      'Password=masterkey')
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    TxOptions.AutoStop = False
    TxOptions.DisconnectAction = xdRollback
    TxOptions.EnableNested = False
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 56
    Top = 24
  end
  object ExecuteScripts: TFDScript
    SQLScripts = <>
    Connection = Connection
    Transaction = ManualWriteTransaction
    ScriptOptions.MacroExpand = False
    Params = <>
    Macros = <>
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    ResourceOptions.ParamCreate = False
    ResourceOptions.ParamExpand = False
    Left = 277
    Top = 24
  end
  object ManualWriteTransaction: TFDTransaction
    Options.AutoStart = False
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Options.EnableNested = False
    Connection = Connection
    Left = 385
    Top = 128
  end
  object dsUpdateVerLogDB: TupAnyDataSet
    Connection = Connection
    Transaction = WriteTransaction
    UpdateTransaction = WriteTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvStrsTrim]
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'update or insert into PARAMS_SYS (TITLE, VERSTR)'
      'values ('#39'VERSION'#39', :NEW_VER)'
      'matching (TITLE)')
    Left = 277
    Top = 128
    ParamData = <
      item
        Name = 'NEW_VER'
        ParamType = ptInput
      end>
  end
  object LogDBScripts: TFDScript
    SQLScripts = <
      item
        Name = '1.00'
        SQL.Strings = (
          'create table PARAMS_SYS ('
          '    TITLE   varchar(20) not null,'
          '    VERSTR  varchar(10) not null'
          ');'
          ''
          
            'alter table PARAMS_SYS add constraint PK_PARAMS_SYS primary key ' +
            '(TITLE);')
      end
      item
        Name = '1.01'
        SQL.Strings = (
          'CREATE TABLE REG_SERVICES ('
          '    DATEON        TIMESTAMP NOT NULL,'
          '    SERVICE_NAME  VARCHAR(50),'
          '    COMMENT       BLOB SUB_TYPE 1 SEGMENT SIZE 80,'
          '    COLOR         INTEGER,'
          '    HWND          INTEGER'
          ');'
          ''
          'CREATE INDEX REG_SERVICES_IDX1 ON REG_SERVICES (DATEON);'
          ''
          
            'COMMENT ON TABLE REG_SERVICES IS '#39#1054#1089#1085#1086#1074#1085#1086#1081' '#1083#1086#1075' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' "'#1057#1077#1088#1074#1077 +
            #1088' '#1050#1057#1040#1052#1059'"'#39';'
          'COMMENT ON COLUMN REG_SERVICES.DATEON IS '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1089#1086#1073#1099#1090#1080#1103#39';'
          'COMMENT ON COLUMN REG_SERVICES.SERVICE_NAME IS '#39#1048#1084#1103' '#1089#1077#1088#1074#1080#1089#1072#39';'
          'COMMENT ON COLUMN REG_SERVICES.COMMENT IS '#39#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081#39';'
          'COMMENT ON COLUMN REG_SERVICES.COLOR IS '#39#1062#1074#1077#1090#39';'
          'COMMENT ON COLUMN REG_SERVICES.HWND IS '#39#1042#1083#1072#1076#1077#1083#1077#1094#39';')
      end
      item
        Name = '1.02'
        SQL.Strings = (
          'CREATE TABLE REG_FILES ('
          '    ID          BIGINT GENERATED BY DEFAULT AS IDENTITY,'
          '    DATEON      TIMESTAMP DEFAULT current_timestamp,'
          '    OWNER_NAME  VARCHAR(50),'
          '    XML_FILE    BLOB SUB_TYPE 1 SEGMENT SIZE 80,'
          '    ANSWER      BLOB SUB_TYPE 1 SEGMENT SIZE 80'
          ');'
          ''
          
            'ALTER TABLE REG_FILES ADD CONSTRAINT PK_REG_FILES PRIMARY KEY (I' +
            'D);'
          ''
          'CREATE INDEX REG_FILES_IDX1 ON REG_FILES (DATEON);'
          ''
          
            'COMMENT ON TABLE REG_FILES IS '#39#1056#1077#1075#1080#1089#1090#1088' '#1092#1072#1081#1083#1086#1074', '#1087#1086#1083#1091#1095#1077#1085#1085#1099#1093' '#1080#1083#1080' '#1087#1088 +
            #1080#1085#1103#1090#1099#1093' '#1087#1088#1080' '#1088#1072#1073#1086#1090#1077' '#1089' '#1087#1086#1088#1090#1072#1083#1086#1084' "'#1052#1077#1076#1080#1094#1080#1085#1072' '#1048#1058'"'#39';'
          ''
          'COMMENT ON COLUMN REG_FILES.ID IS '#39#1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#39';'
          'COMMENT ON COLUMN REG_FILES.DATEON IS '#39#1042#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099' '#1089' '#1092#1072#1081#1083#1086#1084#39';'
          
            'COMMENT ON COLUMN REG_FILES.OWNER_NAME IS '#39#1054#1073#1098#1077#1082#1090'-'#1074#1083#1072#1076#1077#1083#1077#1094', '#1088#1072#1073#1086 +
            #1090#1072#1074#1096#1080#1081' '#1089' '#1092#1072#1081#1083#1086#1084#39';'
          'COMMENT ON COLUMN REG_FILES.XML_FILE IS '#39'XML-'#1092#1072#1081#1083#39';'
          'COMMENT ON COLUMN REG_FILES.ANSWER IS '#39#1054#1090#1074#1077#1090' '#1089' '#1087#1086#1088#1090#1072#1083#1072' '#1085#1072' '#1092#1072#1081#1083#39';')
      end>
    Connection = Connection
    Params = <>
    Macros = <>
    Left = 277
    Top = 184
  end
  object SpecialScripts: TFDScript
    SQLScripts = <
      item
        Name = 'DropParamsSys'
        SQL.Strings = (
          'drop table PARAMS_SYS;')
      end>
    Connection = Connection
    Params = <>
    Macros = <>
    Left = 277
    Top = 240
  end
  object MetaInfoQuery: TFDMetaInfoQuery
    Connection = Connection
    UpdateTransaction = ReadOnlyTransaction
    MetaInfoKind = mkTableFields
    ObjectName = 'PARAMS_SYS'
    Left = 53
    Top = 152
  end
  object dsGetVerDB: TupAnyDataSet
    Connection = Connection
    Transaction = ReadOnlyTransaction
    UpdateTransaction = ReadOnlyTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvStrsTrim]
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      'select '
      '    PS.VERSTR'
      'from'
      '    PARAMS_SYS PS')
    Left = 56
    Top = 226
  end
  object WriteTransaction: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Connection
    Left = 384
    Top = 80
  end
  object ReadOnlyTransaction: TFDTransaction
    Options.ReadOnly = True
    Connection = Connection
    Left = 384
    Top = 184
  end
end