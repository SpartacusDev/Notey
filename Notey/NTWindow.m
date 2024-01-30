#import <Cephei/HBPreferences.h>
#import "NTWindow.h"
#import "NTViewController.h"
#import "NoteyRootViewController.h"

#ifndef bundlePath
#if TARGET_OS_SIMULATOR
    #define bundlePath @"/opt/simject/com.spartacus.notey.bundle/"
#else
    #define bundlePath @"/Library/MobileSubstrate/DynamicLibraries/com.spartacus.notey.bundle/"
#endif
#endif


@interface NTWindow ()

@property (nonatomic, strong, readwrite) FloatingButton *noteyButton;
@property (nonatomic, strong, readwrite) UINavigationController *noteyNavCont;

@end

@implementation NTWindow

+ (instancetype)sharedInstance {
    static NTWindow *sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [[self alloc] initWithFrame:UIScreen.mainScreen.bounds];
	});
	return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NTViewController *rootVC = [[NTViewController alloc] init];
        [rootVC.view setBackgroundColor:UIColor.clearColor];
        [self setRootViewController:rootVC];

        self.noteyButton = [[FloatingButton alloc] init];
        [self.noteyButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[bundlePath stringByAppendingString:@"Icon.png"]]] forState:UIControlStateNormal];
    
        [self setWindowLevel:UIWindowLevelAlert + 2];
        [self.noteyButton addTarget:self action:@selector(showNotey:) forControlEvents:UIControlEventTouchUpInside];
        [self.rootViewController.view addSubview:self.noteyButton];

        self.noteyNavCont = [[UINavigationController alloc] initWithRootViewController:[NoteyRootViewController sharedInstance]];
    }
    return self;
}

- (void)updateSize {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    if ([prefs boolForKey:@"customSize" default:NO]) {
        self.noteyNavCont.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.noteyNavCont setPreferredContentSize:CGSizeMake(
            [prefs floatForKey:@"notesWidth" default:100.0],
            [prefs floatForKey:@"notesHeight" default:100.0]
        )];
    } else {
        self.noteyNavCont.modalPresentationStyle = UIModalPresentationAutomatic;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *orig = [super hitTest:point withEvent:event];
    if (self.rootViewController.presentedViewController || orig.class == FloatingButton.class) {
        return orig;
    }
    return nil;
}

- (void)showNotey:(UIButton *)sender {
    [self updateSize];

    [self.rootViewController presentViewController:self.noteyNavCont animated:YES completion:NULL];
}

- (BOOL)_isSecure {
    return NO;
}

@end