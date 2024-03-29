#import "UIColor+Alpha.h"


@implementation UIColor (Alpha)

+ (instancetype)colorWithHex:(NSString *)hex andAlpha:(CGFloat)alpha {
    return [[self hb_colorWithPropertyListValue:hex] colorWithAlphaComponent:alpha];
}

+ (instancetype)colorWithHexAndAlpha:(NSString *)hexAndAlpha {
    if (![hexAndAlpha containsString:@":"]) {
        return [self colorWithHex:hexAndAlpha andAlpha:1.0];
    }
    NSArray<NSString *> *hexAndAlphaArray = [hexAndAlpha componentsSeparatedByString:@":"];
    return [self colorWithHex:hexAndAlphaArray[0] andAlpha:hexAndAlphaArray[1].floatValue];
}

@end