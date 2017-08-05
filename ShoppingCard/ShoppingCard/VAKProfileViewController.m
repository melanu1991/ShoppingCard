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
@property (weak, nonatomic) IBOutlet UIView *helperView;

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
    
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 10.f;
    self.avatarImage.layer.contents = (__bridge id)[UIImage imageNamed:@"avatar.png"].CGImage;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 75.f;
    
    self.profileView.layer.cornerRadius = 100.f;
    
    self.profileView.layer.shadowColor = [UIColor colorWithRed:78.f/255.f green:215.f/255.f blue:235.f/255.f alpha:1.f].CGColor;
    self.profileView.layer.shadowRadius = 13.f;
    self.profileView.layer.shadowOpacity = 0.1f;
    self.profileView.layer.shadowOffset = CGSizeMake(30.f, 0.f);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.profileView.bounds;
    UIColor *firstColor = [UIColor colorWithRed:36.f/255.f green:67.f/255.f blue:243.f/255.f alpha:1.f];
    UIColor *secondColor = [UIColor colorWithRed:86.f/255.f green:255.f/255.f blue:162.f/255.f alpha:1.f];
    gradientLayer.colors = @[(__bridge id)firstColor.CGColor, (__bridge id)secondColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.f, 0.f);
    gradientLayer.endPoint = CGPointMake(1.f, 1.f);
    gradientLayer.cornerRadius = 100.f;
    [self.profileView.layer insertSublayer:gradientLayer atIndex:0];
//    CAGradientLayer *gradientHelperLayer = [CAGradientLayer layer];
//    gradientHelperLayer.frame = self.helperView.bounds;
//    gradientHelperLayer.colors = @[(__bridge id)firstColor.CGColor, (__bridge id)secondColor.CGColor];
//    gradientHelperLayer.startPoint = CGPointMake(0.f, 0.f);
//    gradientHelperLayer.endPoint = CGPointMake(1.f, 1.f);
//    [self.helperView.layer insertSublayer:gradientHelperLayer atIndex:0];
    
    self.nameLabel.text = self.user.name;
}

#pragma mark - Helpers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self hideMenu];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMenu];
}

- (void)showMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.view];
        self.profileVC = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.profileVC = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    }];
}

@end
