#import <objc/runtime.h>
#import <dlfcn.h>
#import "NTActivator.h"

static LAActivator *_LASharedActivator;

@interface NTActivator ()

@end

@implementation NTActivator

+ (instancetype)sharedInstance {
	static NTActivator *sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

+ (void)load {
	void *la = dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	if (!la) {
		HBLogDebug(@"Failed to load libactivator");
		_LASharedActivator = nil;
	} else {
		_LASharedActivator = [LAActivator sharedInstance];
	}

	[self sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [_LASharedActivator registerListener:self forName:@"com.spartacus.noteyactivator"];
    }
    return self;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.spartacus.noteyprefs/openNotey"), NULL, NULL, YES);
}

@end