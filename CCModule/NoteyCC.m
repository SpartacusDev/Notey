#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import "NoteyCC.h"


typedef enum : int {
	OpenNotey,
	EnableNotey
} Action;


static BOOL _selected;
static HBPreferences *prefs = nil;
static Action action;

void prefsNotification() {
	if (!prefs) {
		prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
	}
	_selected = [prefs boolForKey:@"enabled" default:YES];
	if ([prefs integerForKey:@"implementationMethod" default:0] == 1) {
		action = OpenNotey;
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter postNotificationName:@"NOTEY_disable" object:nil];
	} else {
		action = EnableNotey;
	}
}

@interface NoteyCC ()

@end

@implementation NoteyCC

- (instancetype)init {
	self = [super init];
	if (self) {
		prefsNotification();
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsNotification, CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self selector:@selector(disable:) name:@"NOTEY_disable" object:nil];
	}
	return self;
}

//Return the icon of your module here
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}

//Return the color selection color of your module here
- (UIColor *)selectedColor {
	return UIColor.systemRedColor;
}

- (BOOL)isSelected {
	return _selected;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;

	[super refreshState];
	
	if (action == OpenNotey) {
		if (_selected == NO) {
			return;
		}
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.spartacus.noteyprefs/openNotey"), NULL, NULL, YES);
		_selected = NO;
		[super refreshState];
	} else if (action == EnableNotey) {
		[prefs setBool:_selected forKey:@"enabled"];
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, NULL, YES);
	}
}

- (void)disable:(NSNotification *)notification {
	_selected = NO;
	[super refreshState];
}

@end
