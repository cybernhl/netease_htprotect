#import "HtprotectPlugin.h"
#import <RiskPerception/NTESRiskUniPerception.h>
#import <RiskPerception/NTESRiskUniConfiguration.h>
#import <RiskPerception/NTESRiskUniUtil.h>


@implementation HtprotectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"htprotect"
            binaryMessenger:[registrar messenger]];
  HtprotectPlugin* instance = [[HtprotectPlugin alloc] init];
  instance.channel = channel;
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
   
  } else if ([@"init" isEqualToString:call.method]) {
      [self init:call result:result];
  } else if ([@"setRoleInfo" isEqualToString:call.method]) {
      [self setRoleInfo:call result:result];
  } else if ([@"logOut" isEqualToString:call.method]) {
      [self logOut:call result:result];
  } else if ([@"getToken" isEqualToString:call.method]) {
      [self getToken:call result:result];
  } else if ([@"ioctl" isEqualToString:call.method]) {
      [self ioctl:call result:result];
  } else if ([@"registInfoReceiver" isEqualToString:call.method]) {
      [self registInfoReceiver:call result:result];
  } else if ([@"getDataSign" isEqualToString:call.method]) {
      [self getDataSign:call result:result];
  } else if ([@"safeCommToServer" isEqualToString:call.method]) {
      [self safeCommToServer:call result:result];
  } else if ([@"safeCommFromServer" isEqualToString:call.method]) {
      [self safeCommFromServer:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*) call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    NSString *productId = [arguments objectForKey:@"productId"];
    NSDictionary *params = [arguments objectForKey:@"params"];
    NSString *channel = [arguments objectForKey:@"channel"];
    NSString *gameKey = [arguments objectForKey:@"gameKey"];
    NSString *serverType = [arguments objectForKey:@"serverType"];
    NSDictionary *extDict = [params objectForKey:@"extData"];
    [NTESRiskUniConfiguration setChannel:channel];
    [NTESRiskUniConfiguration setServerType:[serverType integerValue]];
  
    [extDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [NTESRiskUniConfiguration setExtraData:obj forValue:key];
    }];
    
    [[NTESRiskUniPerception fomentBevelDeadengo] init:productId callback:^(int code, NSString * _Nonnull msg, NSString * _Nonnull content) {
        NSString *codeString = [NSString stringWithFormat:@"%d",code];
        resultDict(@{@"code":codeString ?:@""});
    }];
   
}

/// 设置角色信息
- (void)setRoleInfo:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    NSString *businessId = [arguments objectForKey:@"businessId"];
    NSString *roleId = [arguments objectForKey:@"roleId"];
    NSString *roleName = [arguments objectForKey:@"roleName"];
    
    NSString *roleAccount = [arguments objectForKey:@"roleAccount"];
    NSString *roleServer = [arguments objectForKey:@"roleServer"];
    NSString *serverId = [arguments objectForKey:@"serverId"];
    
    NSString *gameJson = [arguments objectForKey:@"gameJson"];

    [[NTESRiskUniPerception fomentBevelDeadengo] setRoleInfo:businessId roleId:roleId?:@"" roleName:roleName?:@"" roleAccount:roleAccount?:@"" roleServer:roleServer?:@"" serverId:[serverId intValue] gameJson:gameJson];
}

- (void)logOut:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    [[NTESRiskUniPerception fomentBevelDeadengo] logOut];
}

- (void)getToken:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    int timeout = [[arguments objectForKey:@"timeout"] intValue];
    NSString *businessId = [arguments objectForKey:@"businessId"];
    [[NTESRiskUniPerception fomentBevelDeadengo] getTokenAsync:businessId?:@"" withTimeout:timeout completeHandler:^(AntiCheatResult * _Nonnull result) {
        resultDict(@{@"code":@(result.code),@"token":result.token?:@""});
    }];
}

- (void)ioctl:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    int request = [[arguments objectForKey:@"request"] intValue];
    NSString *data = [arguments objectForKey:@"data"];
    NSString *result = [[NTESRiskUniPerception fomentBevelDeadengo] ioctl:request withData:data];
    resultDict(result?:@"");
}

- (void)registInfoReceiver:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    [[NTESRiskUniPerception fomentBevelDeadengo] registInfoReceiver:^(int type, NSString * _Nonnull info) {
        NSDictionary *dict = @{@"type":@(type),@"info":info?:@""};
        [self.channel invokeMethod:@"onCallBack" arguments:dict];
    }];
}

- (void)getDataSign:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    NSString *data = [arguments objectForKey:@"inputData"];
    NSString *dataSignString = [NTESRiskUniUtil getDataSign:data];
    resultDict(dataSignString?:@"");
}

- (void)safeCommToServer:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    int alg = [[arguments objectForKey:@"alg"] intValue];
    NSString *input = [arguments objectForKey:@"input"];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSString *dataSignString = [NTESRiskUniUtil safeCommToServer:alg withData:data error:&error];
    if (!error) {
        resultDict(@{@"msg":dataSignString?:@"",@"code":@(200)});
    } else {
        resultDict(@{@"msg":[error.userInfo objectForKey:@"NSLocalizedDescription"]?:@"",@"code":@(error.code)});
    }
   
}

- (void)safeCommFromServer:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    int alg = [[arguments objectForKey:@"alg"] intValue];
    int timeout = [[arguments objectForKey:@"timeout"] intValue];
    NSString *input = [arguments objectForKey:@"input"];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *dataSignData = [NTESRiskUniUtil safeCommFromServer:alg timeout:timeout withData:data error:&error];
    if (!error) {
        NSString *dataSignString = [[NSString alloc] initWithData:dataSignData encoding:NSUTF8StringEncoding];
        resultDict(@{@"msg":dataSignString?:@"",@"code":@(200)});
    } else {
        resultDict(@{@"msg":[error.userInfo objectForKey:@"NSLocalizedDescription"]?:@"",@"code":@(error.code)});
    }
   
}

@end
