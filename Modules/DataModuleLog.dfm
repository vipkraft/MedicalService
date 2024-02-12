object DMLog: TDMLog
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 571
  Width = 866
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
    OnRestored = ConnectionRestored
    OnRecover = ConnectionRecover
    AfterConnect = ConnectionAfterConnect
    Left = 56
    Top = 24
  end
  object dsWriteServices: TupAnyDataSet
    Connection = Connection
    Transaction = WriteTransaction
    UpdateTransaction = WriteTransaction
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmFetched
    FormatOptions.AssignedValues = [fvStrsTrim]
    UpdateOptions.AssignedValues = [uvCheckReadOnly, uvUpdateNonBaseFields]
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.UpdateTableName = 'REG_SERVICES'
    SQL.Strings = (
      'insert into REG_SERVICES'
      '    (DATEON'
      '    ,SERVICE_NAME'
      '    ,COMMENT'
      '    ,COLOR'
      '    ,HWND) '
      'values'
      '    (:DATEON'
      '    ,:SERVICE_NAME'
      '    ,:COMMENT'
      '    ,:COLOR'
      '    ,:HWND)')
    Left = 56
    Top = 80
    ParamData = <
      item
        Name = 'DATEON'
        ParamType = ptInput
      end
      item
        Name = 'SERVICE_NAME'
        ParamType = ptInput
      end
      item
        Name = 'COMMENT'
        ParamType = ptInput
      end
      item
        Name = 'COLOR'
        ParamType = ptInput
      end
      item
        Name = 'HWND'
        ParamType = ptInput
      end>
  end
  object WriteTransaction: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Connection
    Left = 56
    Top = 184
  end
  object dsWriteFile: TupAnyDataSet
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
      'insert into REG_FILES'
      '    (OWNER_NAME'
      '    ,XML_FILE'
      '    ,ANSWER)'
      'values '
      '    (:OWNER_NAME'
      '    ,:XML_FILE'
      '    ,:ANSWER)')
    Left = 56
    Top = 136
    ParamData = <
      item
        Name = 'OWNER_NAME'
        ParamType = ptInput
      end
      item
        Name = 'XML_FILE'
        ParamType = ptInput
      end
      item
        Name = 'ANSWER'
        ParamType = ptInput
      end>
  end
end
