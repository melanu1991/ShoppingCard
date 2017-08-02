#import "VAKProfileViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "VAKBasketTableViewController.h"
#import "VAKCoreDataManager.h"

@interface VAKProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation VAKProfileViewController

#pragma mark - actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:VAKBasketIdentifier]) {
        UINavigationController *nc = segue.destinationViewController;
        VAKBasketTableViewController *basketVC = (VAKBasketTableViewController *)nc.topViewController;
        NSArray *orders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@ AND status == 0", self.user]];
        Order *currentOrder = (Order *)orders[0];
//        basketVC.order = currentOrder;
    }
}

#pragma mark - Singleton

+ (instancetype)sharedProfile {
    static VAKProfileViewController *sharedProfile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:VAKStoryboardName bundle:nil];
        sharedProfile = [storyboard instantiateViewControllerWithIdentifier:VAKProfileViewControllerIdentifier];
        sharedProfile.profileVC = YES;
    });
    return sharedProfile;
}

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 10.f;
    self.avatarImage.layer.contents = (__bridge id)[UIImage imageNamed:@"avatar.png"].CGImage;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 75.f;
    
    self.profileView.layer.cornerRadius = 100.f;
    
    self.profileView.layer.shadowColor = [UIColor cyanColor].CGColor;
    self.profileView.layer.shadowRadius = 13.f;
    self.profileView.layer.shadowOpacity = 0.1f;
    self.profileView.layer.shadowOffset = CGSizeMake(30.f, 0.f);
    
    if (self.user) {
        self.nameLabel.text = self.user.name;
    }
    else {
        self.nameLabel.text = VAKUnregistredUser;
    }
}

#pragma mark - Helpers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMenu];
}

- (void)showMenu:(UIViewController *)viewController {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.view];
        self.profileVC = NO;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.profileVC = YES;
    }];
}

@end
