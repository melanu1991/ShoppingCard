#import "VAKCustomTableViewCell.h"

@interface VAKCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *buttonBasket;

@end

@implementation VAKCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buttonBasket.layer.cornerRadius = 10.f;
    self.buttonBasket.layer.shadowOffset = CGSizeMake(5.f, 5.f);
    self.buttonBasket.layer.shadowOpacity = 0.7f;
    self.buttonBasket.layer.shadowRadius = 5.f;
    self.buttonBasket.layer.shadowColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)basketButtonPressed:(UIButton *)sender {
    NSLog(@"Basket pressed!!!");
}

@end
