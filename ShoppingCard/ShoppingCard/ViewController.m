#import "ViewController.h"
#import "VAKProfileTableViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Good+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"
#import "VAKBasketTableViewController.h"
#import "VAKUserInfoViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) VAKProfileTableViewController *profileVC;
@property (assign, nonatomic) BOOL isProfileVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Notification



#pragma mark - life cicle view

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [VAKCoreDataManager deleteAllEntity];
//    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] completion:^(id data, NSError *error) {
//        if (data) {
//            User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"id"]]];
//            user.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"name"]];
//            user.password = (NSString *)[VAKNetManager parserValueFromJSONValue:[data valueForKeyPath:@"psw"]];
//            user.address = @"";
//            user.phoneNumber = @"";
//            [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
//        }
//    }];
//    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKCatalogIdentifier] completion:^(id data, NSError *error) {
//        if (data) {
//            NSArray *arrayGoods = data;
//            for (id item in arrayGoods) {
//                Good *good = (Good *)[VAKCoreDataManager createEntityWithName:VAKGood identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"id"]]];
//                good.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"title"]];
//                NSString *price = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"price"]];
//                good.price = [NSNumber numberWithInteger:price.integerValue];
//                good.discount = @1;
//                good.image = @1;
//            }
//            [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
//            [self.tableView reloadData];
//        }
//    }];
//    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier] completion:^(id data, NSError *error) {
//        if (data) {
//            for (id item in data) {
//                Order *order = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"id"]]];
//                order.date = [NSDate dateWithString:item[@"date"] format:VAKDateFormat];
//                NSArray *arrayGoodsFromOrder = [item valueForKeyPath:@"catalog"];
//                NSArray *arrayGoodsFromDB = [VAKCoreDataManager allEntitiesWithName:VAKGood];
//                for (NSDictionary *goodFromOrder in arrayGoodsFromOrder) {
//                    NSNumber *number = goodFromOrder[@"id"];
//                    NSLog(@"%ld", number.integerValue);
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code.integerValue == %ld", number.integerValue];
//                    arrayGoodsFromDB = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:predicate];
//                }
//            }
//            [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
//            [self.tableView reloadData];
//        }
//    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProfileVC = YES;
    self.profileVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKProfileTableViewControllerIdentifier];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    [VAKCoreDataManager deleteAllEntity];
    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKCatalogIdentifier] completion:^(id data, NSError *error) {
        if (data) {
            NSArray *arrayGoods = data;
            for (id item in arrayGoods) {
                Good *good = (Good *)[VAKCoreDataManager createEntityWithName:VAKGood identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"id"]]];
                good.name = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"title"]];
                NSString *price = (NSString *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"price"]];
                good.price = [NSNumber numberWithInteger:price.integerValue];
                good.discount = @1;
                good.image = @1;
            }
            [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
            [self.tableView reloadData];
        }
    }];
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
}

- (IBAction)basketButtonPressed:(UIButton *)sender {
    VAKBasketTableViewController *vc = [[VAKBasketTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self showMenu];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self hideMenu];
            break;
        default:
            break;
    }
}

- (IBAction)profileButtonPressed:(UIBarButtonItem *)sender {
    if (self.isProfileVC) {
        [self showMenu];
    }
    else {
        [self hideMenu];
    }
}

- (void)showMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.profileVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addChildViewController:self.profileVC];
        [self.view addSubview:self.profileVC.view];
        self.isProfileVC = NO;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        self.profileVC.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.profileVC removeFromParentViewController];
        self.isProfileVC = YES;
    }];
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
