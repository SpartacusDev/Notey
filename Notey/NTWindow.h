#import <UIKit/UIKit.h>
#import "FloatingButton.h"


@interface NTWindow : UIWindow

@property (nonatomic, strong, readonly) FloatingButton *noteyButton;
@property (nonatomic, strong, readonly) UINavigationController *noteyNavCont;

+ (instancetype)sharedInstance;
- (void)updateSize;

@end