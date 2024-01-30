#import <Cephei/HBPreferences.h>
#import "FloatingButton.h"

#ifndef ScreenSize
#define ScreenSize UIScreen.mainScreen.bounds.size
#endif

#ifndef getSize
#define getSize \
int widthHeight; \
switch ([self.prefs integerForKey:@"size" default:Small]) { \
    case ExtraSmall: { \
        widthHeight = 25; \
        break; \
    } \
    case Small: { \
        widthHeight = 50; \
        break; \
    } \
    case Medium: { \
        widthHeight = 75; \
        break; \
    } \
    case Large: { \
        widthHeight = 100; \
        break; \
    } \
    default: { \
        NSLog(@"what"); \
        widthHeight = 50; \
        break; \
    } \
}
#endif


typedef enum : int{
    Top,
    Right,
    Bottom,
    Left
} Border;

typedef enum : int {
    ExtraSmall,
    Small,
    Medium,
    Large
} ButtonSize;

typedef enum : int {
    NotMoving,
    StoppedMoving,
    Moving
} IsMoving;

@interface NSNumber (Orientation)

- (BOOL)isPortrait;

@end

@implementation NSNumber (Orientation) 

- (BOOL)isPortrait {
    return self.intValue == UIDeviceOrientationUnknown || self.intValue == UIDeviceOrientationPortrait || self.intValue == UIDeviceOrientationPortraitUpsideDown;
}

@end


@interface FloatingButton () {
    IsMoving moving;
}

@property (nonatomic, strong) HBPreferences *prefs;

@end

@implementation FloatingButton

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self->moving = NotMoving;
        self.prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];

        if (![self.prefs objectForKey:@"orientation"])
            [self.prefs setObject:[NSNumber numberWithInteger:[UIDevice currentDevice].orientation] forKey:@"orientation"];
        if (![self.prefs objectForKey:@"position"])
            [self.prefs setObject:[NSNumber numberWithFloat:10.0] forKey:@"position"];
        if (![self.prefs objectForKey:@"border"])
            [self.prefs setObject:[NSNumber numberWithInteger:Top] forKey:@"border"];
        
        getSize
        
        switch (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue) {
            case Top:
                if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            10,
                            widthHeight,
                            widthHeight
                        )];
                    else {
                        CGFloat ratio = ScreenSize.height / ScreenSize.width;
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                            10,
                            widthHeight,
                            widthHeight
                        )];
                    }
                } else {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                        CGFloat ratio = ScreenSize.height / ScreenSize.width;
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                            10,
                            widthHeight,
                            widthHeight
                        )];
                    } else
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            10,
                            widthHeight,
                            widthHeight
                        )];
                }
                break;
            case Bottom:
                if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            ScreenSize.height - widthHeight - 10,
                            widthHeight,
                            widthHeight
                        )];
                    else {
                        CGFloat ratio = ScreenSize.height / ScreenSize.width;
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                            ScreenSize.height - widthHeight - 10,
                            widthHeight,
                            widthHeight
                        )];
                    }
                } else {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                        CGFloat ratio = ScreenSize.height / ScreenSize.width;
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                            ScreenSize.height - widthHeight - 10,
                            widthHeight,
                            widthHeight
                        )];
                    } else
                        [self setFrame:CGRectMake(
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            ScreenSize.height - widthHeight - 10,
                            widthHeight,
                            widthHeight
                        )];
                }
                break;
            case Right:
                if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                        [self setFrame:CGRectMake(
                            ScreenSize.width - widthHeight - 10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            widthHeight,
                            widthHeight
                        )];
                    else {
                        CGFloat ratio = ScreenSize.width / ScreenSize.height;
                        [self setFrame:CGRectMake(
                            ScreenSize.width - widthHeight - 10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                            widthHeight,
                            widthHeight
                        )];
                    }
                } else {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                        CGFloat ratio = ScreenSize.width / ScreenSize.height;
                        [self setFrame:CGRectMake(
                            ScreenSize.width - widthHeight - 10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                            widthHeight,
                            widthHeight
                        )];
                    } else
                        [self setFrame:CGRectMake(
                            ScreenSize.width - widthHeight - 10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            widthHeight,
                            widthHeight
                        )];
                }
                break;
            case Left:
                if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                        [self setFrame:CGRectMake(
                            10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            widthHeight,
                            widthHeight
                        )];
                    else {
                        CGFloat ratio = ScreenSize.width / ScreenSize.height;
                        [self setFrame:CGRectMake(
                            10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                            widthHeight,
                            widthHeight
                        )];
                    }
                } else {
                    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                        [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                        CGFloat ratio = ScreenSize.width / ScreenSize.height;
                        [self setFrame:CGRectMake(
                            10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                            widthHeight,
                            widthHeight
                        )];
                    } else
                        [self setFrame:CGRectMake(
                            10,
                            ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                            widthHeight,
                            widthHeight
                        )];
                }
                break;
            default:
                @throw [NSException exceptionWithName:@"Couldn't find this border" reason:@"How? Good question. Check your code." userInfo:nil];
        }

        UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        [self addGestureRecognizer:drag];

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)updateSize {
    getSize

    [self setFrame:CGRectMake(
        self.frame.origin.x,
        self.frame.origin.y,
        widthHeight,
        widthHeight
    )];
}

#pragma mark - Overriding parent methods

- (void)setFrame:(CGRect)frame {
    if (frame.origin.x + frame.size.width > ScreenSize.width)
        frame = CGRectMake(ScreenSize.width - self.frame.size.width - 10, frame.origin.y, self.frame.size.width, self.frame.size.height);
    if (frame.origin.y + frame.size.height > ScreenSize.height)
        frame = CGRectMake(frame.origin.x, ScreenSize.height - self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);

    if (self->moving == StoppedMoving) {
        if (
            (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue == Top && frame.origin.y != 10) ||
            (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue == Right && frame.origin.x != ScreenSize.width - frame.size.width - 10) ||
            (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue == Bottom && frame.origin.y != ScreenSize.height - frame.size.height - 10) ||
            (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue == Left && frame.origin.x != 10)
        ) {
            if ([NSNumber numberWithInteger:[UIDevice currentDevice].orientation].isPortrait)
                [self setPositionPortrait];
            else
                [self setPositionLandscape];
        }
        self->moving = NotMoving;
    }

    [super setFrame:frame];
}

#pragma mark - Handle Dragging

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    self->moving = Moving;
    CGPoint translation = [sender translationInView:self.superview];
	
	[self setFrame:CGRectMake(
		self.frame.origin.x + translation.x,
		self.frame.origin.y + translation.y,
		self.frame.size.width,
		self.frame.size.height
	)];

	if (sender.state == UIGestureRecognizerStateEnded) {
		if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
            [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
			[self setPositionPortrait];
		else 
			[self setPositionLandscape];

        [self.prefs setObject:[NSNumber numberWithInteger:[UIDevice currentDevice].orientation] forKey:@"orientation"];

        self->moving = StoppedMoving;

        return;
	}
    [sender setTranslation:CGPointMake(0, 0) inView:self.superview];
}

#pragma mark - Handle orientation changes

- (void)orientationChanged:(NSNotification *)sender {
    getSize

    switch (((NSNumber *)[self.prefs objectForKey:@"border"]).intValue) {
        case Top:
            if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        10,
                        widthHeight,
                        widthHeight
                    )];
                else {
                    CGFloat ratio = ScreenSize.height / ScreenSize.width;
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                        10,
                        widthHeight,
                        widthHeight
                    )];
                }
            } else {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    CGFloat ratio = ScreenSize.height / ScreenSize.width;
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                        10,
                        widthHeight,
                        widthHeight
                    )];
                } else
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        10,
                        widthHeight,
                        widthHeight
                    )];
            }
            break;
        case Bottom:
            if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        ScreenSize.height - widthHeight - 10,
                        widthHeight,
                        widthHeight
                    )];
                else {
                    CGFloat ratio = ScreenSize.height / ScreenSize.width;
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                        ScreenSize.height - widthHeight - 10,
                        widthHeight,
                        widthHeight
                    )];
                }
            } else {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    CGFloat ratio = ScreenSize.height / ScreenSize.width;
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                        ScreenSize.height - widthHeight - 10,
                        widthHeight,
                        widthHeight
                    )];
                } else
                    [self setFrame:CGRectMake(
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        ScreenSize.height - widthHeight - 10,
                        widthHeight,
                        widthHeight
                    )];
            }
            break;
        case Right:
            if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                    [self setFrame:CGRectMake(
                        ScreenSize.width - widthHeight - 10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        widthHeight,
                        widthHeight
                    )];
                else {
                    CGFloat ratio = ScreenSize.width / ScreenSize.height;
                    [self setFrame:CGRectMake(
                        ScreenSize.width - widthHeight - 10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                        widthHeight,
                        widthHeight
                    )];
                }
            } else {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    CGFloat ratio = ScreenSize.width / ScreenSize.height;
                    [self setFrame:CGRectMake(
                        ScreenSize.width - widthHeight - 10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                        widthHeight,
                        widthHeight
                    )];
                } else
                    [self setFrame:CGRectMake(
                        ScreenSize.width - widthHeight - 10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        widthHeight,
                        widthHeight
                    )];
            }
            break;
        case Left:
            if ([((NSNumber *)[self.prefs objectForKey:@"orientation"]) isPortrait]) {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown)
                    [self setFrame:CGRectMake(
                        10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        widthHeight,
                        widthHeight
                    )];
                else {
                    CGFloat ratio = ScreenSize.width / ScreenSize.height;
                    [self setFrame:CGRectMake(
                        10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue / ratio,
                        widthHeight,
                        widthHeight
                    )];
                }
            } else {
                if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || \
                    [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    CGFloat ratio = ScreenSize.width / ScreenSize.height;
                    [self setFrame:CGRectMake(
                        10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue * ratio,
                        widthHeight,
                        widthHeight
                    )];
                } else
                    [self setFrame:CGRectMake(
                        10,
                        ((NSNumber *)[self.prefs objectForKey:@"position"]).floatValue,
                        widthHeight,
                        widthHeight
                    )];
            }
            break;
        default:
            @throw [NSException exceptionWithName:@"Couldn't find this border" reason:@"How? Good question. Check your code." userInfo:nil];
    }

    [self.prefs setObject:[NSNumber numberWithInteger:[UIDevice currentDevice].orientation] forKey:@"orientation"];
}

- (void)setPositionPortrait {
	if (self.frame.origin.y <= UIScreen.mainScreen.bounds.size.height / 10) {  // Top
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				self.frame.origin.x,
				10,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

		if (self.frame.origin.x + self.frame.size.width >= 9 * UIScreen.mainScreen.bounds.size.width / 10)  // Top + Right
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					UIScreen.mainScreen.bounds.size.width - self.frame.size.width - 10,
					self.frame.origin.y,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
		else if (self.frame.origin.x < UIScreen.mainScreen.bounds.size.width / 10)  // Top + Left
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					10,
					self.frame.origin.y,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
        
        // I only care about it being at the top
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.x] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Top] forKey:@"border"];
	} else if (self.frame.origin.y + self.frame.size.height >= 9 * UIScreen.mainScreen.bounds.size.height / 10) {  // Bottom
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				self.frame.origin.x,
				UIScreen.mainScreen.bounds.size.height - self.frame.size.height - 10,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

		if (self.frame.origin.x + self.frame.size.width > 9 * UIScreen.mainScreen.bounds.size.width / 10)  // Bottom + Right
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					UIScreen.mainScreen.bounds.size.width - self.frame.size.width - 10,
					self.frame.origin.y,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
		else if (self.frame.origin.x < UIScreen.mainScreen.bounds.size.width / 10)  // Bottom + Left
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					10,
					self.frame.origin.y,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];

        // I only care about it being at the bottom
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.x] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Bottom] forKey:@"border"];
	} else if (self.frame.origin.x > UIScreen.mainScreen.bounds.size.width / 2) {  // Right
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				UIScreen.mainScreen.bounds.size.width - self.frame.size.width - 10,
				self.frame.origin.y,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

        // I only care about it being at the right
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.y] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Right] forKey:@"border"];
    } else {  // Left
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				10,
				self.frame.origin.y,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

        // I only care about it being at the left
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.y] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Left] forKey:@"border"];
    }
}

- (void)setPositionLandscape {
	if (self.frame.origin.x <= UIScreen.mainScreen.bounds.size.width / 10) {  // Left
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				10,
				self.frame.origin.y,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

		if (self.frame.origin.y + self.frame.size.height >= 9 * UIScreen.mainScreen.bounds.size.height / 10)  // Left + Bottom
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					self.frame.origin.x,
					UIScreen.mainScreen.bounds.size.height - self.frame.size.height - 10,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
		else if (self.frame.origin.y < UIScreen.mainScreen.bounds.size.height / 10)  // Left + Top
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					self.frame.origin.x,
					10,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];

        // I only care about it being at the left
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.y] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Left] forKey:@"border"];
	} else if (self.frame.origin.x + self.frame.size.width >= 9 * UIScreen.mainScreen.bounds.size.width / 10) {  // Right
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				UIScreen.mainScreen.bounds.size.width - self.frame.size.width - 10,
				self.frame.origin.y,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

		if (self.frame.origin.y + self.frame.size.height > 9 * UIScreen.mainScreen.bounds.size.height / 10)  // Right + Bottom
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					self.frame.origin.x,
					UIScreen.mainScreen.bounds.size.height - self.frame.size.height - 10,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
		else if (self.frame.origin.y < UIScreen.mainScreen.bounds.size.height / 10)  // Right + Top
			[UIView animateWithDuration:0.1 animations:^{
				[self setFrame:CGRectMake(
					self.frame.origin.x,
					10,
					self.frame.size.width,
					self.frame.size.height
				)];
			}];
        
        // I only care about it being at the right
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.y] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Right] forKey:@"border"];
	} else if (self.frame.origin.y > UIScreen.mainScreen.bounds.size.height / 2) {  // Bottom
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				self.frame.origin.x,
				UIScreen.mainScreen.bounds.size.height - self.frame.size.height - 10,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

        // I only care about it being at the bottom
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.x] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Bottom] forKey:@"border"];
    } else {  // Top
		[UIView animateWithDuration:0.1 animations:^{
			[self setFrame:CGRectMake(
				self.frame.origin.x,
				10,
				self.frame.size.width,
				self.frame.size.height
			)];
		}];

        // I only care about it being at the top
        [self.prefs setObject:[NSNumber numberWithFloat:self.frame.origin.x] forKey:@"position"];
        [self.prefs setObject:[NSNumber numberWithInteger:Top] forKey:@"border"];
    }
}

@end