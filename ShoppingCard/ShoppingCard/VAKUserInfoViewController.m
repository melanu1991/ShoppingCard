#import "VAKUserInfoViewController.h"
#import "ViewController.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "VAKCoreDataManager.h"
#import "VAKNetManager.h"
#import "VAKProfileViewController.h"

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
    if (self.registrationOrEntryController.selectedSegmentIndex == 1) {
        self.loginField.text = @"Igor";
        self.paswordField.text = @"qwe";
    }
    else {
        self.loginField.text = @"";
        self.paswordField.text = @"";
    }
}

- (IBAction)registrationOrEntryButtonPressed:(UIButton *)sender {
    User *user = nil;
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKGoodViewControllerIdentifier];
    if (self.loginField.text.length > 0 && self.paswordField.text.length > 0 && ([self.paswordField.text isEqualToString:self.confirmationPasswordField.text] || self.registrationOrEntryController.selectedSegmentIndex == 1)) {
        if (self.registrationOrEntryController.selectedSegmentIndex == 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.loginField.text];
            NSArray *arrayUsers = [VAKCoreDataManager allEntitiesWithName:VAKUser predicate:predicate];
            if (arrayUsers.count == 0) {
                user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:nil];
                user.name = self.loginField.text;
                user.password = self.paswordField.text;
                NSDictionary *info = @{ VAKID : user.userId,
                                        VAKName : user.name,
                                        VAKPassword : user.password };
                [[VAKNetManager sharedManager] uploadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] info:info completion:nil];
                [[VAKCoreDataManager sharedManager] saveContext];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self alertActionWithTitle:VAKError message:VAKUserIsRegistrationMessage];
            }
        }
        else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND password == %@", self.loginField.text, self.paswordField.text];
            NSArray *arrayUsers = [VAKCoreDataManager allEntitiesWithName:VAKUser predicate:predicate];
            if (arrayUsers.count > 0) {
                user = arrayUsers[0];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self alertActionWithTitle:VAKError message:VAKErrorMessage];
            }
        }
    }
    else {
        [self alertActionWithTitle:VAKError message:VAKErrorMessage];
    }
    [VAKProfileViewController sharedProfile].user = user;
}

#pragma mark - helpers method

- (void)alertActionWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:VAKOK style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.loginField] && self.registrationOrEntryController.selectedSegmentIndex == 0) {
        [self.paswordField becomeFirstResponder];
    }
    else if ([textField isEqual:self.loginField] && self.registrationOrEntryController.selectedSegmentIndex == 1) {
        self.paswordField.returnKeyType = UIReturnKeyDone;
        [self.paswordField becomeFirstResponder];
    }
    else if ([textField isEqual:self.paswordField] && self.registrationOrEntryController.selectedSegmentIndex == 0) {
        [self.confirmationPasswordField becomeFirstResponder];
    }
    else {
        [self.confirmationPasswordField resignFirstResponder];
        [self.paswordField resignFirstResponder];
    }
    return YES;
}

@end
