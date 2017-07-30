#import "VAKProfileViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "VAKBasketTableViewController.h"

@interface VAKProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation VAKProfileViewController

#pragma mark - action

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:VAKBasketTableViewControllerIdentifier]) {
        UINavigationController *nc = [segue destinationViewController];
        VAKBasketTableViewController *vc = (VAKBasketTableViewController *)nc.topViewController;
        vc.user = self.user;
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
    
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.profileView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(150.f, 150.f)];
    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    cornerLayer.frame = self.profileView.bounds;
    cornerLayer.path = path.CGPath;
    self.profileView.layer.mask = cornerLayer;
    
    
    
    if (self.user) {
        self.nameLabel.text = self.user.name;
    }
    else {
        self.nameLabel.text = VAKUnregistredUser;
    }
}

#pragma mark - Helpers

- (void)showMenu:(UIViewController *)viewController {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [viewController addChildViewController:self];
        [viewController.view addSubview:self.view];
        self.profileVC = NO;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        self.profileVC = YES;
    }];
}

@end
