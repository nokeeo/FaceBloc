//
//  FBLCRenderingOptions.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "FBLCRenderingOptions.h"

@implementation FBLCRenderingOptions

- (instancetype)initWithTargetSize:(CGSize)targetSize shouldObscureFaces:(BOOL)shouldObscureFaces {
  self = [super init];
  if (self) {
    _targetSize = targetSize;
    _shouldObscureFaces = shouldObscureFaces;
  }
  
  return self;
}

+ (instancetype)optionsWithTargetSize:(CGSize)targetSize shouldObscureFaces:(BOOL)shouldObscureFaces {
  return [[self alloc] initWithTargetSize:targetSize shouldObscureFaces:shouldObscureFaces];
}

@end
