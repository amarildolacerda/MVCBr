object MVCBrService: TMVCBrService
  OldCreateOrder = False
  DisplayName = 'MVCBr Service'
  AfterInstall = ServiceAfterInstall
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 388
  Width = 518
end
