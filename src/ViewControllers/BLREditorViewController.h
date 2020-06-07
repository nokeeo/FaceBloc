#import <UIKit/UIKit.h>

#import "BLREditorBottomNavigationView.h"

#import "BLRImageView.h"

@protocol BLREditorViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BLREditorViewController : UIViewController <BLREditorBottomNavigationViewDelegate, BLRImageViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@property(nonatomic, nullable, weak) id<BLREditorViewControllerDelegate> delegate;

@end

@protocol BLREditorViewControllerDelegate <NSObject>

- (void)editorViewControllerDidCancelEditing:(BLREditorViewController *)editorViewController;

- (void)editorViewController:(BLREditorViewController *)editorViewController didFinishEditingWithFinalImage:(UIImage *)finalImage;

@end

NS_ASSUME_NONNULL_END
