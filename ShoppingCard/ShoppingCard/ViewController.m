#import "ViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Good+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"
#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Notification



#pragma mark - life cycle view

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
}

- (IBAction)basketButtonPressed:(UIButton *)sender {
    VAKBasketTableViewController *vc = [[VAKBasketTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [[VAKProfileViewController sharedProfile] showMenu:self];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [[VAKProfileViewController sharedProfile] hideMenu];
            break;
        default:
            break;
    }
}

- (IBAction)profileButtonPressed:(UIBarButtonItem *)sender {
    if ([VAKProfileViewController sharedProfile].isProfileVC) {
        [[VAKProfileViewController sharedProfile] showMenu:self];
    }
    else {
        [[VAKProfileViewController sharedProfile] hideMenu];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *allGoods = [VAKCoreDataManager allEntitiesWithName:VAKGood];
    return allGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKGoodCellIdentifier];
    NSArray *allGoods = [VAKCoreDataManager allEntitiesWithName:VAKGood];
    Good *currentGood = allGoods[indexPath.row];
    cell.phoneId.text = currentGood.code.stringValue;
    cell.phoneName.text = currentGood.name;
    cell.phoneColor.text = @"Black";
    cell.phoneImage.backgroundColor = [UIColor redColor];
    cell.phonePrice.text = currentGood.price.stringValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
