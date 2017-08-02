#import "VAKOrdersTableViewController.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "VAKBasketTableViewCell.h"
#import "VAKProfileViewController.h"
#import "VAKNSDate+Formatters.h"
#import "ViewController.h"

@interface VAKOrdersTableViewController ()

@property (strong, nonatomic) NSArray *orders;

@end

@implementation VAKOrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKBasketTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKBasketCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *user = [VAKProfileViewController sharedProfile].user;
    self.orders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@", user]];
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKBasketTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VAKBasketCellIdentifier];
    Order *order = self.orders[indexPath.row];
    cell.numberOfOrder.text = [NSString stringWithFormat:@"Заказ №%@", order.orderId.stringValue];
    cell.dateOfOrder.text = [NSString stringWithFormat:@"Время заказа: %@", [order.date formattedString:VAKDateFormat]];
    NSString *status = nil;
    switch (order.status.integerValue) {
        case 0:
            status = @"Открыт";
            break;
        case 1:
            status = @"В ожидании отправки";
            break;
        case 2:
            status = @"Отклонен";
            break;
        case 3:
            status = @"Получен";
            break;
        default:
            break;
    }
    cell.statusOfOrder.text = [NSString stringWithFormat:@"Статус заказа: %@", status];
    NSUInteger price = 0;
    for (Good *good in order.goods) {
        price += good.price.integerValue;
    }
    cell.priceOfOrder.text = [NSString stringWithFormat:@"Сумма заказа: %ld руб.", price];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Order *order = self.orders[indexPath.row];
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:VAKViewControllerIdentifier];
    vc.order = order;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
