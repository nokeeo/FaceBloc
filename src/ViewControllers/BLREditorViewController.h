#import <UIKit/UIKit.h>

#import "BLREditorBottomNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLREditorViewController : UIViewController <BLREditorBottomNavigationViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END
