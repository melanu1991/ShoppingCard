#import <UIKit/UIKit.h>

@interface VAKBasketTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberOfOrder;
@property (weak, nonatomic) IBOutlet UILabel *dateOfOrder;
@property (weak, nonatomic) IBOutlet UILabel *statusOfOrder;
@property (weak, nonatomic) IBOutlet UILabel *priceOfOrder;

@end
