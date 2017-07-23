#import "VAKProfileTableViewController.h"

@interface VAKProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end

@implementation VAKProfileTableViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelector:@selector(setStyleCircleForImage:) withObject:self.avatarImage afterDelay:0];
}

- (void)setStyleCircleForImage:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.0;
    imageView.clipsToBounds = YES;
}

@end
