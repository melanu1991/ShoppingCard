#import <UIKit/UIKit.h>

@class User;

@interface VAKProfileViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (assign, nonatomic, getter = isProfileVC) BOOL profileVC;

+ (instancetype)sharedProfile;

- (void)showMenu:(UIViewController *)viewController;
- (void)hideMenu;

@end
