#import "VAKCustomTableViewCell.h"
#import "Constants.h"

@interface VAKCustomTableViewCell ()

@end

@implementation VAKCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.basketButton.layer.cornerRadius = 10.f;
    self.basketButton.layer.shadowOffset = CGSizeMake(5.f, 5.f);
    self.basketButton.layer.shadowOpacity = 0.7f;
    self.basketButton.layer.shadowRadius = 5.f;
    self.basketButton.layer.shadowColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)basketButtonPressed:(UIButton *)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.phoneId forKey:VAKPhoneCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:VAKBasketButtonPressed object:dic];
}

@end
