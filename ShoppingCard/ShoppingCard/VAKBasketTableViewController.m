#import "VAKBasketTableViewController.h"
#import "VAKBasketTableViewCell.h"
#import "Constants.h"
#import "VAKNetManager.h"
#import "VAKNSDate+Formatters.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VAKBasketTableViewController

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKBasketTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKBasketCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodAddToBasket:) name:VAKBasketButtonPressed object:nil];
}

#pragma mark - Notification

- (void)goodAddToBasket:(NSNotification *)notification {
    NSNumber *codeGood = notification.userInfo[VAKPhoneCode];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code.integerValue == %ld", codeGood.integerValue];
    NSArray *selectedGood = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:predicate];
    
}

#pragma mark - action

- (void)backButtonPressed {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder];
    return arrayOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKBasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKBasketCellIdentifier];
    NSArray *arrayOrders = [VAKCoreDataManager allEntitiesWithName:VAKOrder];
    Order *order = arrayOrders[indexPath.row];
    cell.numberOfOrder.text = order.orderId.stringValue;
    cell.dateOfOrder.text = [order.date formattedString:VAKDateFormat];
    cell.statusOfOrder.text = @"Unknow";
    cell.priceOfOrder.text = @"Unknow";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
