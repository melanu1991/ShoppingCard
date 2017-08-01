#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"
#import "VAKBasketTableViewCell.h"
#import "VAKCustomTableViewCell.h"
#import "Constants.h"
#import "VAKNetManager.h"
#import "VAKNSDate+Formatters.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VAKBasketTableViewController

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKBasketTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKBasketCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
}

#pragma mark - action

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *user = [VAKProfileViewController sharedProfile].user;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderId == %@", user.userId];
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    return arrayOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.order) {
        VAKCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKGoodCellIdentifier];
        NSArray *arrayGoods = self.order.goods.allObjects;
        Good *currentGood = arrayGoods[indexPath.row];
        if (currentGood.count == 0) {
            cell.backgroundImage.image = [UIImage imageNamed:@"cell_background_removed"];
        }
        cell.phoneId.text = currentGood.code.stringValue;
        cell.phoneName.text = currentGood.name;
        cell.phoneColor.text = currentGood.color;
        cell.basketButton.hidden = YES;
        [[VAKNetManager sharedManager] loadRequestWithPath:currentGood.image completion:^(id data, NSError *error) {
            if (data) {
                __block UIImage *image = nil;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    NSDictionary *json = data;
                    NSString *pathToImage = json[VAKImage];
                    NSURL *url = [NSURL URLWithString:pathToImage];
                    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        dispatch_sync(queue, ^{
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                        });
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            cell.phoneImage.image = image;
                        });
                    }];
                    [task resume];
                });
            }
        }];
        cell.phonePrice.text = currentGood.price.stringValue;
        return cell;
    }
    else {
        User *user = [VAKProfileViewController sharedProfile].user;
        VAKBasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKBasketCellIdentifier];
        NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@", user]];
        Order *order = arrayOrders[indexPath.row];
        cell.numberOfOrder.text = order.orderId.stringValue;
        cell.dateOfOrder.text = [order.date formattedString:VAKDateFormat];
        cell.statusOfOrder.text = order.status.stringValue;
        NSUInteger priceOfOrder = 0;
        for (Good *good in order.goods) {
            priceOfOrder += good.price.integerValue;
        }
        cell.priceOfOrder.text = [NSString stringWithFormat:@"%ld", priceOfOrder];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = [VAKProfileViewController sharedProfile].user;
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@", user]];
    Order *order = arrayOrders[indexPath.row];

}

@end
