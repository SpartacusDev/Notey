#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <CepheiUI/UIColor+HBAdditions.h>
#import <Cephei/HBRespringController.h>
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
		appearanceSettings.navigationBarTintColor = [UIColor hb_colorWithPropertyListValue:@"#cfc12d"];
        appearanceSettings.navigationBarBackgroundColor = [UIColor hb_colorWithPropertyListValue:@"#850B1B"];
        appearanceSettings.statusBarStyle = UIStatusBarStyleLightContent;
		appearanceSettings.translucentNavigationBar = YES;
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

	UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
	[self.navigationItem setRightBarButtonItem:respringButton];
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
	if (((NSNumber *)[self readPreferenceValue:[self specifierForID:@"implementationMethod"]]).intValue == 1) {
		[self removeSpecifier:[self specifierForID:@"visible"] animated:YES];
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/activator"]) {
		[self removeSpecifier:[self specifierForID:@"activator"] animated:NO];
	}
	if ([(NSNumber *)[self readPreferenceValue:[self specifierForID:@"enable"]] boolValue] == YES) {
		[self removeSpecifier:[self specifierForID:@"position options"] animated:NO];
		[self removeSpecifier:[self specifierForID:@"position"] animated:NO];
		[self removeSpecifier:[self specifierForID:@"border"] animated:NO];
	}
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
	if ([specifier.properties[@"id"] isEqualToString:@"enable"]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention all passengers!" message:@"In order to completely disable/enable the tweak you have to respring. Would you like to do so now?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *respringNow = [UIAlertAction actionWithTitle:@"Respring Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
			[self respring:nil];
		}];
		UIAlertAction *notNow = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){}];
		[alert addAction:respringNow];
		[alert addAction:notNow];
		[self presentViewController:alert animated:YES completion:NULL];
	}
	if ([specifier.properties[@"id"] isEqualToString:@"customSize"] || [specifier.properties[@"id"] isEqualToString:@"implementationMethod"]) {
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

- (void)respring:(nullable id)sender {
	[HBRespringController respring];
}

@end
