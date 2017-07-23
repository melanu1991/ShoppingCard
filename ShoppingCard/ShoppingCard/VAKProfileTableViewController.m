#import "VAKProfileTableViewController.h"
//#import "VAKProfileTableViewCell.h"

@interface VAKProfileTableViewController () /* <UITableViewDelegate, UITableViewDataSource> */
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end

@implementation VAKProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return 140.f;
//    }
//    return 44.f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    VAKProfileTableViewCell *cell = nil;
//    if (indexPath.row == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
//        cell.avatarImage.center = cell.center;
//        cell.avatarImage.backgroundColor = [UIColor redColor];
//    }
//    else {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
//        cell.nameLabel.text = @"Aleksey Veremeychik";
//    }
//    return cell;
//}

@end
