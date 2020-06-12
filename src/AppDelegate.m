// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "AppDelegate.h"

#import "FBLCRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  if (@available(ios 13.0, *)) {
    // No-op scene configuration
  } else {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    FBLCRootViewController *rootViewController = [[FBLCRootViewController alloc] init];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window = window;
    [window makeKeyAndVisible];
  }

  return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)) {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
    didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)) {
  // Called when the user discards a scene session.
  // If any sessions were discarded while the application was not running, this will be called shortly after
  // application:didFinishLaunchingWithOptions. Use this method to release any resources that were specific to the
  // discarded scenes, as they will not return.
}

@end
