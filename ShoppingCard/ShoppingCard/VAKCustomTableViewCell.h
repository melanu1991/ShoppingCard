#import <UIKit/UIKit.h>

@interface VAKCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneName;
@property (weak, nonatomic) IBOutlet UILabel *phoneColor;
@property (weak, nonatomic) IBOutlet UILabel *phoneId;
@property (weak, nonatomic) IBOutlet UILabel *phonePrice;
@property (weak, nonatomic) IBOutlet UIButton *basketButton;

@end
