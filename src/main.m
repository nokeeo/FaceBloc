//
//  main.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char* argv[]) {
  NSString* appDelegateClassName;
  @autoreleasepool {
    // Setup code that might create autoreleased objects goes here.
    appDelegateClassName = NSStringFromClass([AppDelegate class]);
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
