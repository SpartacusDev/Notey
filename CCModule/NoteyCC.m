#import <Cephei/HBPreferences.h>
#import "NoteyCC.h"


static BOOL _selected;
static HBPreferences *prefs = nil;

void prefsNotification() {
	if (!prefs) {
		prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
	}
	_selected = [prefs boolForKey:@"enabled" default:YES];
}

@interface NoteyCC ()

@end

@implementation NoteyCC

- (instancetype)init {
	self = [super init];
	if (self) {
		prefsNotification();
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsNotification, CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
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

	[prefs setBool:_selected forKey:@"enabled"];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, NULL, YES);
}

@end
