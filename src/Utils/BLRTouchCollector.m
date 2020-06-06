//
//  BLRTouchCollector.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRPath.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation BLRPath {
  CGMutablePathRef _path;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _path = CGPathCreateMutable();
  }
  
  return self;
}

- (void)dealloc {
  CGPathRelease(_path);
}

- (void)addTouch:(UITouch *)touch inView:(UIView *)view {
  
}

- (void)clear {
  
}

@end
