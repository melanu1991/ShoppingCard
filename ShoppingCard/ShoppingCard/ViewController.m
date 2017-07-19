#import "ViewController.h"
#import "VAKProfileTableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) VAKProfileTableViewController *profileVC;
@property (assign, nonatomic) BOOL isProfileVC;

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
        self.profileVC.view.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addChildViewController:self.profileVC];
        [self.view addSubview:self.profileVC.view];
        self.isProfileVC = NO;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.profileVC.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.profileVC removeFromParentViewController];
        self.isProfileVC = YES;
    }];
}

@end
