#import "EncipherPlugin.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
@implementation EncipherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"encipher"
            binaryMessenger:[registrar messenger]];
  EncipherPlugin* instance = [[EncipherPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"encrypt" isEqualToString:call.method]) {
      if ([[call.arguments objectForKey:@"type"] integerValue]==0) {
          result([self firstMd5:[call.arguments objectForKey:@"raw"] salt:[call.arguments objectForKey:@"salt"] count:[call.arguments objectForKey:@"repeat"]] );
      }else{
          result([self secondMd5:[call.arguments objectForKey:@"raw"] count:[call.arguments objectForKey:@"repeat"]]);
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - 第一种MD5加密
- (NSString *)firstMd5:(NSString *)password salt:(NSString *)salt count:(NSString *)count
{
    NSString *md5Str;
    if ([password length]==0) {
        return password;
    }else{
        md5Str = [NSString stringWithFormat:@"%@{%@}", password, salt];
    }
    NSString *pwdName;
    pwdName =  [self md5:md5Str];
    for (int i = 0; i < [count integerValue] - 1; i++) {
        pwdName = [self md5:pwdName];
    }
    return [pwdName lowercaseString];
}

#pragma mark - md5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 第二种MD5加密
- (NSString *)secondMd5:(NSString *)str count:(NSString *)count
{
    NSString *pwdName;
    pwdName = [self md5:str];
    for (int i = 0; i < [count integerValue] - 1; i ++) {
        pwdName = [self md5:pwdName];
    }
    return pwdName;
}

@end
