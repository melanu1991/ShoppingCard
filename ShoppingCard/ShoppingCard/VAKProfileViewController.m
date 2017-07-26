#import "VAKProfileViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"

@interface VAKProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation VAKProfileViewController

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
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.profileView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(100.f, 100.f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.profileView.layer.mask = maskLayer;
    self.profileView.layer.shadowColor = [UIColor colorWithWhite:.5 alpha:1].CGColor;
    self.profileView.layer.shadowRadius = 4.0f;
    self.profileView.layer.shadowPath = CGPathCreateWithRect(CGRectMake(0, 0, 50, 50), NULL);
    self.profileView.layer.shadowOpacity = 1.0f;
    self.profileView.layer.shadowOffset = CGSizeMake(1, 1);
    if (self.user) {
        self.nameLabel.text = self.user.name;
    }
    else {
        self.nameLabel.text = VAKUnregistredUser;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelector:@selector(setStyleCircleForImage:) withObject:self.avatarImage afterDelay:0];
}

#pragma mark - Helpers

- (void)setStyleCircleForImage:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.0;
    imageView.clipsToBounds = YES;
}

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
