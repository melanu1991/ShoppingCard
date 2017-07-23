#import "ViewController.h"
#import "VAKProfileTableViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "Good+CoreDataClass.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) VAKProfileTableViewController *profileVC;
@property (assign, nonatomic) BOOL isProfileVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProfileVC = YES;
    self.profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTableViewController"];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] completion:^(id data, NSError *error) {
        if (data) {
            User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"id"]]];
            user.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"name"]];
            user.password = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"password"]];
        }
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"VAKCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"VAKCustomTableViewCell"];
    [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
    NSLog(@"%@", [VAKCoreDataManager allEntitiesWithName:VAKUser]);
}

- (IBAction)basketButtonPressed:(UIButton *)sender {
    NSLog(@"Basket button pressed");
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self showMenu];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self hideMenu];
            break;
        default:
            break;
    }
}

- (IBAction)profileButtonPressed:(UIBarButtonItem *)sender {
    if (self.isProfileVC) {
        [self showMenu];
    }
    else {
        [self hideMenu];
    }
}

- (void)showMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.profileVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addChildViewController:self.profileVC];
        [self.view addSubview:self.profileVC.view];
        self.isProfileVC = NO;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.profileVC.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.profileVC removeFromParentViewController];
        self.isProfileVC = YES;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VAKCustomTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Did select row!!!");
}

@end
