#import "VAKDetailViewController.h"
#import "Order+CoreDataClass.h"
#import "Good+CoreDataClass.h"

@interface VAKDetailViewController ()

@end

@implementation VAKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
