#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import "Notey/NTWindow.h"


static HBPreferences *prefs;
static BOOL inLockscreen;
static NTWindow *window;


void prefsNotification() {
    if (inLockscreen) {
        return;
    }

    // Enabled:
    [window setHidden:![prefs boolForKey:@"enabled" default:YES]];

    // FloatingButton Size:
    [window.noteyButton updateSize];

    // Notey Size:
    [window updateSize];
}


%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig(application);

    inLockscreen = NO;

    static BOOL firstTime = YES;  // In case this is called more than once yk


    if (!firstTime || window) {
        return;
    }

    window = [NTWindow sharedInstance];
    
    [window makeKeyAndVisible];
    [window setHidden:![prefs boolForKey:@"enabled" default:YES]];

    firstTime = NO;
}

%end

%hook SBScreenWakeAnimationController

- (void)prepareToWakeForSource:(long long)arg1 timeAlpha:(double)arg2 statusBarAlpha:(double)arg3 delegate:(id)arg4 target:(id)arg5 completion:(id)arg6 {
    %orig(arg1, arg2, arg3, arg4, arg5, arg6);
    inLockscreen = YES;

    if (![prefs boolForKey:@"enabled" default:YES]) {
        return;
    }

    [window setHidden:YES];
}

- (void)prepareToWakeForSource:(long long)arg1 timeAlpha:(double)arg2 statusBarAlpha:(double)arg3 target:(id)arg4 completion:(id)arg5 {
    %orig(arg1, arg2, arg3, arg4, arg5);
    inLockscreen = YES;

    if (![prefs boolForKey:@"enabled" default:YES]) {
        return;
    }

    [window setHidden:YES];
}

%end

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
    %orig(arg1, arg2);
    inLockscreen = NO;

    if (![prefs boolForKey:@"enabled" default:YES]) {
        return;
    }

    [window setHidden:NO];
}

%end

%ctor {
    prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsNotification, CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
