#import "NSString+StackOverflowAlignment.h"


@implementation NSString (StackOverflowAlignment)

- (NSInteger)getTextDirection {
	if (self.length) {
		NSArray *rtlLanguages = @[@"ar", @"he"];
		NSString *lang = CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)self, CFRangeMake(0, self.length)));
		if ([rtlLanguages containsObject:lang]) {
			return NSTextAlignmentRight;
		}
	}
	return NSTextAlignmentLeft;
}

@end