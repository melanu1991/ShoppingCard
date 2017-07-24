#import "VAKUserInfoViewController.h"
#import "ViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "VAKCoreDataManager.h"
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
        [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] completion:^(id data, NSError *error) {
            if (data) {
                ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKGoodViewControllerIdentifier];
                NSArray *arrayUsers = data;
                for (id item in arrayUsers) {
                    User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"id"]]];
                    user.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"name"]];
                    user.password = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"psw"]];
                    user.address = @"";
                    user.phoneNumber = @"";
                }
                if (self.registrationOrEntryController.selectedSegmentIndex == 0) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.loginField.text];
                    NSArray *arrayUsers = [VAKCoreDataManager allEntitiesWithName:VAKUser predicate:predicate];
                    if (arrayUsers.count == 0) {
                        User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:nil];
                        user.name = self.loginField.text;
                        user.password = self.paswordField.text;
                        user.address = @"";
                        user.phoneNumber = @"";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else {
                        [self alertActionWithTitle:@"Error" message:@"Such user is registered"];
                    }
                }
                else {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND password == %@", self.loginField.text, self.paswordField.text];
                    NSArray *arrayUsers = [VAKCoreDataManager allEntitiesWithName:VAKUser predicate:predicate];
                    if (arrayUsers.count > 0) {
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else {
                        [self alertActionWithTitle:@"Error" message:@"Incorrect data entered"];
                    }
                }
                [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
            }
        }];
    }
    else {
        [self alertActionWithTitle:@"Error" message:@"Incorrect data entered"];
    }
}
- (IBAction)continueWithoutRegistrationButtonPressed:(UIButton *)sender {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKGoodViewControllerIdentifier];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - helpers method

- (void)alertActionWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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
