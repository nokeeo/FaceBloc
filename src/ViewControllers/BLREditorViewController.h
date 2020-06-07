#import <UIKit/UIKit.h>

#import "BLREditorBottomNavigationView.h"

#import "BLRImageViewController.h"

@protocol BLREditorViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BLREditorViewController : UIViewController <BLREditorBottomNavigationViewDelegate, BLRImageViewControllerDelegate>

@property(nonatomic, nullable, weak) id<BLREditorViewControllerDelegate> delegate;

- (instancetype)initWithImageURL:(nullable NSURL *)imageURL;

@end

@protocol BLREditorViewControllerDelegate <NSObject>

- (void)editorViewControllerDidCancelEditing:(BLREditorViewController *)editorViewController;

- (void)editorViewController:(BLREditorViewController *)editorViewController didFinishEditingWithFinalImage:(UIImage *)finalImage;

@end

NS_ASSUME_NONNULL_END
