#import <CepheiUI/UIColor+HBAdditions.h>


@interface UIColor (Alpha)

+ (instancetype)colorWithHex:(NSString *)hex andAlpha:(CGFloat)alpha;
+ (instancetype)colorWithHexAndAlpha:(NSString *)hexAndAlpha;

@end