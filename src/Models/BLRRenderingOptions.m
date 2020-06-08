//
//  BLRRenderingOptions.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRRenderingOptions.h"

@implementation BLRRenderingOptions

- (instancetype)initWithShouldObscureFaces:(BOOL)shouldObscureFaces {
  self = [super init];
  if (self) {
    _shouldObscureFaces = shouldObscureFaces;
  }
  
  return self;
}

+ (instancetype)optionsWithShouldObscureFaces:(BOOL)shouldObscureFaces {
  return [[self alloc] initWithShouldObscureFaces:shouldObscureFaces];
}

@end
