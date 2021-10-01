#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import "Notey/NTWindow.h"


static HBPreferences *prefs;
static BOOL inLockscreen;
static BOOL inCC;
static NTWindow *window;


static void prefsNotification() {
    if (inLockscreen) {
        return;
    }

    // Hide Notey:
    if ([prefs integerForKey:@"implementationMethod" default:0] != 0) {
        if ([prefs integerForKey:@"implementationMethod" default:0] == 2 && inCC) {
            [window.noteyButton setHidden:![prefs boolForKey:@"enabled" default:YES]];
        } else {
            [window.noteyButton setHidden:YES];
        }
    } else {
        [window.noteyButton setHidden:![prefs boolForKey:@"enabled" default:YES]];
    }

    // FloatingButton Size:
    [window.noteyButton updateSize];

    // Notey Size:
    [window updateSize];
}

static void openNotey() {
    if (inLockscreen) {
        return;
    }
    [window showNotey:nil];
}


%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig(application);

    inLockscreen = NO;
    inCC = NO;

    static BOOL firstTime = YES;  // In case this is called more than once yk


    if (!firstTime || window) {
        return;
    }

    window = [NTWindow sharedInstance];
    
    [window makeKeyAndVisible];
    if ([prefs integerForKey:@"implementationMethod" default:0] != 0) {
        if ([prefs integerForKey:@"implementationMethod" default:0] == 2 && inCC) {
            [window.noteyButton setHidden:![prefs boolForKey:@"enabled" default:YES]];
        } else {
            [window.noteyButton setHidden:YES];
        }
    } else {
        [window.noteyButton setHidden:![prefs boolForKey:@"enabled" default:YES]];
    }

    firstTime = NO;
}

%end

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig(animated);
    inLockscreen = YES;

    if (![prefs boolForKey:@"enabled" default:YES]) {
        return;
    }

    [window setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig(animated);
    inLockscreen = NO;

    if (![prefs boolForKey:@"enabled" default:YES]) {
        return;
    }

    [window setHidden:NO];
}

%end

%hook SBControlCenterController  // Thank you 0xkuj!

- (void)_willPresent {
	%orig;
	inCC = YES;

    if ([prefs integerForKey:@"implementationMethod" default:0] != 2 || \
        inLockscreen) {
        return;
    }

    [window.noteyButton setHidden:![prefs boolForKey:@"enabled" default:YES]];
}

- (void)_willDismiss {
	%orig;
	inCC = NO;

	if ([prefs integerForKey:@"implementationMethod" default:0] != 2 || \
        inLockscreen) {
        return;
    }

    [window.noteyButton setHidden:YES];
}

%end

%ctor {
    prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];

    if (![prefs boolForKey:@"actuallyEnabled" default:YES]) return;
    
    %init;
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsNotification, CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)openNotey, CFSTR("com.spartacus.noteyprefs/openNotey"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
