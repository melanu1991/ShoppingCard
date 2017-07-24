#import "VAKUserInfoViewController.h"

@interface VAKUserInfoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *confirmationPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmationPasswordField;

@end

@implementation VAKUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)entryOrRegistrationButtonPressed:(UISegmentedControl *)sender {
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
