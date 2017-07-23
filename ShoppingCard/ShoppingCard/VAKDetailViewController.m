#import "VAKDetailViewController.h"

@interface VAKDetailViewController ()

@end

@implementation VAKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
