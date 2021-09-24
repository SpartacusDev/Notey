#import <Cephei/HBPreferences.h>
#import "NoteyRootViewController.h"
#import "Notey.h"
#import "NSString+StackOverflowAlignment.h"
#import "UIColor+Alpha.h"


@interface UITableView (iLikeReorderingWithoutEditing)

- (void)_setAllowsReorderingWhenNotEditing:(BOOL)arg1;

@end


@interface NoteyRootViewController ()

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *notes;

@end

@implementation NoteyRootViewController

+ (instancetype)sharedInstance {
    static NoteyRootViewController *shared = nil;
    if (!shared) {
        shared = [[NoteyRootViewController alloc] init];
    }
    return shared;
}

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self.tableView _setAllowsReorderingWhenNotEditing:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    self.notes = [[prefs objectForKey:@"notes"] mutableCopy];
    if (!self.notes) {
        self.notes = [NSMutableArray array];
        [prefs setObject:self.notes forKey:@"notes"];
    }

    UIBarButtonItem *plus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newNote:)];
    [self.navigationItem setRightBarButtonItem:plus];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    [self.view setBackgroundColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"backgroundColor" default:@"#3C0008"]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    self.notes = [[prefs objectForKey:@"notes"] mutableCopy];
    if (!self.notes) {
        self.notes = [NSMutableArray array];
        [prefs setObject:self.notes forKey:@"notes"];
    }
    
    [self.tableView reloadData];
}

- (void)newNote:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title for the New Note:" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"A new note!"];
    }];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.notes addObject:[@{
            @"title": [alert.textFields.firstObject.text isEqualToString:@""] ? @"A new note!" : alert.textFields.firstObject.text,
            @"text": @""
        } mutableCopy]];
        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
        [prefs setObject:self.notes forKey:@"notes"];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:add];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];

    [cell.textLabel setText:self.notes[indexPath.row][@"title"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"backgroundColor" default:@"#3C0008"]]];
    [cell.textLabel setTextColor:[UIColor colorWithHexAndAlpha:[prefs objectForKey:@"textColor" default:@"#ffffff"]]];
    [cell.textLabel setTextAlignment:[cell.textLabel.text getTextDirection]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:[prefs floatForKey:@"titleFontSize" default:17]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notey *note = [[Notey alloc] initWithNoteNumber:indexPath.row];
    [self.navigationController pushViewController:note animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObject:self.notes[indexPath.row]];
        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
        [prefs setObject:self.notes forKey:@"notes"];
        [tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableDictionary *temp = self.notes[sourceIndexPath.row];
    [self.notes removeObjectAtIndex:sourceIndexPath.row];
    [self.notes insertObject:temp atIndex:destinationIndexPath.row];
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.spartacus.noteyprefs"];
    [prefs setObject:self.notes forKey:@"notes"];
}

@end