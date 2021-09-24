#import <Cephei/HBPreferences.h>
#import "Notey.h"
#import "NSString+StackOverflowAlignment.h"
#import "UIColor+Alpha.h"


@interface Notey () {
    BOOL iWannaStopEditing;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableDictionary *note;
@property (assign) int noteNumber;

@end

@implementation Notey

- (instancetype)initWithNoteNumber:(int)noteNumber {
    self = [super init];
    if (self) {
        self.noteNumber = noteNumber;
        self->iWannaStopEditing = NO;

        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
        self.note = [((NSArray *)[prefs objectForKey:@"notes"])[noteNumber] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];

    self.title = self.note[@"title"];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(
        5,
        5,
        self.view.frame.size.width - 10,
        self.view.frame.size.height - 10
    )];
    [self.textView setDelegate:self];
    [self.textView setText:[self.note[@"text"] isEqual:@""] ? @" " : self.note[@"text"]];
    [self.textView setBackgroundColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"backgroundColor" default:@"#3C0008"]]];
    [self.textView setTextColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"textColor" default:@"#ffffff"]]];
    [self.textView setFont:[UIFont systemFontOfSize:[prefs floatForKey:@"noteFontSize" default:20]]];
    [self.textView setTextAlignment:[self.textView.text getTextDirection]];

    self.textView.translatesAutoresizingMaskIntoConstraints = NO;

    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(allowKeyboardDismiss:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        self.textView.inputAccessoryView = keyboardToolbar;
    }

    [self.view addSubview:self.textView];

    [self.textView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:5].active = YES;
    [self.textView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:5].active = YES;
    [self.textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:5].active = YES;   
    [self.textView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:5].active = YES;   


    UIBarButtonItem *changeTitle = [[UIBarButtonItem alloc] initWithTitle:@"Edit Title" style:UIBarButtonItemStylePlain target:self action:@selector(changeTitle:)];
    [self.navigationItem setRightBarButtonItem:changeTitle];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(allowKeyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)changeTitle:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Title" message:@"Please enter the new title" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setText:self.title];
        [textField setPlaceholder:@"A new note!"];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.note[@"title"] = [alert.textFields.firstObject.text isEqualToString:@""] ? @"A new note!" : alert.textFields.firstObject.text;
        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
        NSMutableArray<NSMutableDictionary *> *notes = [[prefs objectForKey:@"notes"] mutableCopy];
        notes[self.noteNumber] = self.note;
        [prefs setObject:notes forKey:@"notes"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = self.note[@"title"];
        });
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    [self.view setBackgroundColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"backgroundColor" default:@"#3C0008"]]];
    
    if ([self.textView.text isEqualToString:@" "]) [self.textView setText:@""];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.note[@"text"] = self.textView.text;

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    NSMutableArray<NSMutableDictionary *> *notes = [[prefs objectForKey:@"notes"] mutableCopy];
    notes[self.noteNumber] = self.note;
    [prefs setObject:notes forKey:@"notes"];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)allowKeyboardDismiss:(id)sender {
    self->iWannaStopEditing = YES;
    [self.textView endEditing:YES];
}

@end