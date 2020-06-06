#import <UIKit/UIKit.h>

#import "BLREditorBottomNavigationView.h"

#import "BLRImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLREditorViewController : UIViewController <BLREditorBottomNavigationViewDelegate, BLRImageViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END
