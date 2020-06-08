#import "BLRImagePipeline.h"

#import "BLRImageGeometryData.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

static CGRect ConvertNormalizedFrameToImageSpace(CGSize imageSize, CGRect normalizedFrame) {
  return CGRectMake(CGRectGetMinX(normalizedFrame) * imageSize.width,
                    CGRectGetMinY(normalizedFrame) * imageSize.height,
                    CGRectGetWidth(normalizedFrame) * imageSize.width,
                    CGRectGetHeight(normalizedFrame) * imageSize.height);
}

static void ObfuscateFacialFeatures(CGContextRef context, CGSize imageSize, BLRImageGeometryData *metadata) {
  CGContextSaveGState(context);
  
  CGContextScaleCTM(context, 1, -1);
  CGContextTranslateCTM(context, 0, -imageSize.height);
  CGContextSetFillColorWithColor(context, UIColor.redColor.CGColor);
  for (VNDetectedObjectObservation *observation in metadata.faceObservations) {
    CGRect boundingBox = ConvertNormalizedFrameToImageSpace(imageSize, observation.boundingBox);
    CGContextFillRect(context, boundingBox);
  }
  
  CGContextRestoreGState(context);
}

static void DrawPaths(CGContextRef contextRef, NSArray<UIBezierPath *> *paths) {
  CGContextSaveGState(contextRef);
  
  CGContextSetFillColorWithColor(contextRef, UIColor.redColor.CGColor);
  for(UIBezierPath *path in paths) {
    CGContextAddPath(contextRef, path.CGPath);
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    CGContextSetLineWidth(contextRef, 100);
    CGContextStrokePath(contextRef);
  }
  
  CGContextRestoreGState(contextRef);
}

static void CallCompletionBlock(BLRImagePipelineCompletion completion, UIImage *image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    completion(image);
  });
}

#pragma mark -

@implementation BLRImagePipelineOptions

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

#pragma mark -

@implementation BLRImagePipeline

- (void)processImage:(UIImage *)image withMetaData:(BLRImageGeometryData *)metadata options:(BLRImagePipelineOptions *)options completion:(BLRImagePipelineCompletion)completion {
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    CGSize imageSize = image.size;
    UIGraphicsImageRendererFormat *rendererFormat = [[UIGraphicsImageRendererFormat alloc] init];
    rendererFormat.scale = image.scale;
    
    UIGraphicsImageRenderer *imageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:image.size format:rendererFormat];
    UIImage *renderedImage = [imageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
      CGContextRef context = rendererContext.CGContext;
      
      if (options.shouldObscureFaces) {
        ObfuscateFacialFeatures(context, imageSize, metadata);
      }
      
      DrawPaths(context, metadata.obfuscationPaths);
    }];

    CIImage *blockImage = [CIImage imageWithCGImage:renderedImage.CGImage];
    CIImage *originalImage = [CIImage imageWithCGImage:image.CGImage];

    CIFilter *compositeFilter = [CIFilter filterWithName:@"CISourceAtopCompositing" withInputParameters:@{
      @"inputImage" : blockImage,
      @"inputBackgroundImage" : originalImage,
    }];

    UIImage *finalImage = [UIImage imageWithCIImage:compositeFilter.outputImage];
    CallCompletionBlock(completion, finalImage);
  });
}

@end
