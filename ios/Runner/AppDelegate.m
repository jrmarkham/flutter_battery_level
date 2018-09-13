#import <Flutter/Flutter.h>
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                           methodChannelWithName:@"samples.flutter.io/battery"
                                           binaryMessenger:controller];
    
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result){
        if([@"getBatteryLevel" isEqualToString:call.method]){
            int batteryLevel = [self getBatteryLevel];
            if(batteryLevel == -1){
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                           message:@"Battery no cheese"
                                           details:nil]);
            }else{
                result(@(batteryLevel));
            }
            
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel{
    UIDevice* device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;
    if(device.batteryState == UIDeviceBatteryStateUnknown){
        return -1;
    }else{
        return (int) (device.batteryLevel * 100);
    }
}
@end
