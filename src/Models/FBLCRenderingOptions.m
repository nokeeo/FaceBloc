// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

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
