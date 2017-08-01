#import "VAKBasketTableViewController.h"
#import "VAKBasketTableViewCell.h"
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
}

#pragma mark - action

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderId == %@", self.user.userId];
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    return arrayOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKBasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKBasketCellIdentifier];
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@", self.user]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@", self.user]];
    Order *order = arrayOrders[indexPath.row];

}

@end
