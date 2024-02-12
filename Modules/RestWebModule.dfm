object RestWM: TRestWM
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Enabled = False
      Name = 'waDefault'
    end
    item
      Name = 'waReturnJwtToken'
      PathInfo = '/rest_service'
      OnAction = RestWMwaReturnJwtTokenAction
    end>
  Height = 245
  Width = 326
end
