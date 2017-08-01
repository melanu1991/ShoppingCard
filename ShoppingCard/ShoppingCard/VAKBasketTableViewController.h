#import <UIKit/UIKit.h>

@class User, Order;

@interface VAKBasketTableViewController : UITableViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Order *order;

@end
