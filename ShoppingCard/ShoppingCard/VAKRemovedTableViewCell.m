#import "VAKRemovedTableViewCell.h"

@implementation VAKRemovedTableViewCell

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
};

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneColor.transform = CGAffineTransformMakeRotation([self degreesToRadians:3.f]);
    self.phoneName.transform = CGAffineTransformMakeRotation([self degreesToRadians:3.f]);
    self.phoneId.transform = CGAffineTransformMakeRotation([self degreesToRadians:3.f]);
    self.phonePrice.transform = CGAffineTransformMakeRotation([self degreesToRadians:3.f]);
    self.removeButton.transform = CGAffineTransformMakeRotation([self degreesToRadians:3.f]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)removeButtonPressed:(UIButton *)sender {
    NSLog(@"remove button pressed!!!");
}

@end
