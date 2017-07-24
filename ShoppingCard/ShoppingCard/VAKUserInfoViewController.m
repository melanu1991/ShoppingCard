#import "VAKUserInfoViewController.h"
#import "ViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "VAKCoreDataManager.m"
#import "VAKNetManager.h"

@interface VAKUserInfoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *confirmationPasswordStackView;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *paswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmationPasswordField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *registrationOrEntryController;

@end

@implementation VAKUserInfoViewController

#pragma mark - action

- (IBAction)entryOrRegistrationButtonPressed:(UISegmentedControl *)sender {
    self.confirmationPasswordStackView.hidden = !self.confirmationPasswordStackView.hidden;
}

- (IBAction)registrationOrEntryButtonPressed:(UIButton *)sender {
    if (self.loginField.text.length > 0 && self.paswordField.text.length > 0 && [self.paswordField.text isEqualToString:self.confirmationPasswordField.text]) {
        [VAKCoreDataManager deleteAllEntity];
        if (self.registrationOrEntryController.selectedSegmentIndex == 0) {
            
        }
        [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] completion:^(id data, NSError *error) {
            if (data) {
                User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"id"]]];
                user.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"name"]];
                user.password = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"psw"]];
                user.address = @"";
                user.phoneNumber = @"";
                [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
                ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKGoodViewControllerIdentifier];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}
- (IBAction)continueWithoutRegistrationButtonPressed:(UIButton *)sender {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKGoodViewControllerIdentifier];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.loginField]) {
        [self.paswordField becomeFirstResponder];
    }
    else if ([textField isEqual:self.paswordField]) {
        [self.confirmationPasswordField becomeFirstResponder];
    }
    else {
        [self.confirmationPasswordField resignFirstResponder];
    }
    return YES;
}

@end
