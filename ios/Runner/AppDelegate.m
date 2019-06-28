#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    [GMSServices provideAPIKey:@"AIzaSyAkJoLjqnPwLQxBxCM5Atob-ydALkVbw_0"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
