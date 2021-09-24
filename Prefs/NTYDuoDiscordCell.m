#import "NTYDuoDiscordCell.h"


@interface NTYDuoDiscordCell ()

@end

@implementation NTYDuoDiscordCell

+ (NSString *)_urlForUsername:(NSString *)user {
    return @"https://discord.gg/mZZhnRDGeg";
}

- (void)handleLeftTap:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:nil]] options:[NSDictionary dictionary] completionHandler:NULL];
}

- (void)handleRightTap:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:nil]] options:[NSDictionary dictionary] completionHandler:NULL];
}

@end