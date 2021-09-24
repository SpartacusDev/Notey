#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <CepheiUI/UIColor+HBAdditions.h>
#import "NTYRootListController.h"


@interface NTYRootListController () {
	BOOL useCustomSize;
}

@property (nonatomic, strong) UIView *headerView;

@end


@implementation NTYRootListController

- (instancetype)init {
    self = [super init];

    if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor hb_colorWithPropertyListValue:@"#72309E"];
        appearanceSettings.navigationBarBackgroundColor = [UIColor hb_colorWithPropertyListValue:@"#850B1B"];
        appearanceSettings.statusBarStyle = UIStatusBarStyleLightContent;
		// appearanceSettings.tableViewBackgroundColor = [UIColor hb_colorWithPropertyListValue:@"#1A0003"];
		appearanceSettings.tableViewCellTextColor = [UIColor hb_colorWithPropertyListValue:@"#72309E"];
		// appearanceSettings.tableViewCellBackgroundColor = [UIColor hb_colorWithPropertyListValue:@"#1A0003"];
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self reloadSpecifiers];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	[headerView setBackgroundColor:[UIColor hb_colorWithPropertyListValue:@"#1A0003"]];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	[imageView setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/NoteyPrefs.bundle/banner.png"]];
	[imageView setContentMode:UIViewContentModeScaleAspectFill];
	[imageView setClipsToBounds:YES];

	[headerView addSubview:imageView];

	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	[imageView.topAnchor constraintEqualToAnchor:headerView.topAnchor].active = YES;
	[imageView.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor].active = YES;
	[imageView.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor].active = YES;
	[imageView.bottomAnchor constraintEqualToAnchor:headerView.bottomAnchor].active = YES;

	if ([self respondsToSelector:@selector(tableView)]) {
		[self.tableView setTableHeaderView:headerView];
	} else {
		[[self valueForKey:@"_table"] setTableHeaderView:headerView];
	}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		self->useCustomSize = ((NSNumber *)[self readPreferenceValue:[self specifierForID:@"customSize"]]).boolValue;
	}

	return _specifiers;
}

- (void)reloadSpecifiers {
	[super reloadSpecifiers];
	if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
		[self removeSpecifier:[self specifierForID:@"customSize"] animated:NO];
		[self removeSpecifier:[self specifierForID:@"width"] animated:NO];
		[self removeSpecifier:[self specifierForID:@"height"] animated:NO];
		return;
	}
	if (!self->useCustomSize) {
		[self removeSpecifier:[self specifierForID:@"width"] animated:YES];
		[self removeSpecifier:[self specifierForID:@"height"] animated:YES];
	}
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.spartacus.noteyprefs/updatedprefs"), NULL, NULL, YES);
	if ([specifier.properties[@"id"] isEqualToString:@"customSize"]) {
		self->useCustomSize = ((NSNumber *)value).boolValue;
		[self reloadSpecifiers];
	}
}

- (void)openGitHub {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/SpartacusDev/Notey"] options:[NSDictionary dictionary] completionHandler:NULL];
}

- (void)joinDiscord {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/mZZhnRDGeg"] options:[NSDictionary dictionary] completionHandler:NULL];
}

@end
