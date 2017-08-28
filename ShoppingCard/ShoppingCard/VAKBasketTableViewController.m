#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKRemovedTableViewCell.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "VAKNetManager.h"
#import "VAKNSDate+Formatters.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *goodsOfOrder;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VAKBasketTableViewController

#pragma mark - helpers

- (NSDictionary *)formattedDictionaryWithOrder:(Order *)order {
    NSArray *goods = order.goods.allObjects;
    NSMutableArray *arr = [NSMutableArray array];
    for (Good *good in goods) {
        [arr addObject:@{ @"id" : good.code }];
    }
    NSDictionary *info = @{ VAKID : order.orderId,
                            VAKCatalog : [arr copy],
                            VAKDate : [order.date formattedString:VAKDateFormat],
                            VAKStatus : order.status,
                            VAKUserId : order.user.userId };
    return info;
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:VAKRemovedTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKRemovedCellIdentifier];
    
    if (!self.order) {
        User *user = [VAKProfileViewController sharedProfile].user;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ AND status.integerValue == %ld", user, 0];
        NSArray *currentOrder = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
        if (currentOrder.count == 0) {
            Order *order = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:nil];
            order.status = @0;
            order.user = [VAKProfileViewController sharedProfile].user;
            NSString *date = [[NSDate date] formattedString:VAKDateFormat];
            order.date = [NSDate dateWithString:date format:VAKDateFormat];
            self.order = order;
            [[VAKCoreDataManager sharedManager] saveContext];
            [[VAKNetManager sharedManager] uploadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier] info:[self formattedDictionaryWithOrder:order] completion:nil];
        }
        else {
            self.order = currentOrder[0];
        }

        self.checkoutButton.backgroundColor = [UIColor colorWithRed:184.f/255.f green:233.f/255.f blue:134.f/255.f alpha:1.f];
        self.checkoutButton.layer.cornerRadius = 6.f;
        self.checkoutButton.layer.shadowOffset = CGSizeMake(5.f, 5.f);
        self.checkoutButton.layer.shadowOpacity = 0.7f;
        self.checkoutButton.layer.shadowRadius = 6.f;
        self.checkoutButton.layer.shadowColor = [UIColor grayColor].CGColor;

    }
    else {
        self.checkoutButton.hidden = YES;
    }
    
    self.goodsOfOrder = [self.order.goods allObjects];
}

#pragma mark - action

- (IBAction)checkoutButtonPressed:(UIButton *)sender {
    if (self.goodsOfOrder.count < 1) {
        [self alertWithTitle:@"Ошибка" message:@"Нельзя оформить заказ без наличия хотя бы одного товара!"];
        return;
    }
    else {
        NSString *pathToCurrentOrder = [NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKOrderIdentifier, self.order.orderId];
        NSString *date = [[NSDate date] formattedString:VAKDateFormat];
        self.order.date = [NSDate dateWithString:date format:VAKDateFormat];
        self.order.status = @1;
        
        NSArray *goods = [self.goodsOfOrder filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"count.integerValue > %ld", 0]];
        
        if (goods.count > 0) {
            self.order.goods = [NSSet setWithArray:goods];
            [[VAKNetManager sharedManager] updateRequestWithPath:pathToCurrentOrder info:[self formattedDictionaryWithOrder:self.order] completion:nil];
            [[VAKCoreDataManager sharedManager] saveContext];
        }
        else {
            [self alertWithTitle:@"Ошибка" message:@"Все товары из корзины отсутствуют на складе!"];
        }
    }
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    NSArray *arr = self.navigationController.viewControllers;
    if (arr.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsOfOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Good *currentGood = self.goodsOfOrder[indexPath.row];
    if (currentGood.count.integerValue > 0) {
        VAKCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKGoodCellIdentifier];
        cell.phoneId.text = currentGood.code.stringValue;
        cell.phoneName.text = currentGood.name;
        cell.phoneColor.text = currentGood.color;
        cell.basketButton.hidden = YES;
        cell.topConstraintIndicator.constant = cell.bounds.size.height / 2.f - cell.topConstraintIndicator.constant;

        [[VAKNetManager sharedManager] loadImageWithPath:currentGood.image completion:^(UIImage *image, NSError *error) {
            if (!error) {
                cell.phoneImage.image = image;
            }
        }];
        
        cell.phonePrice.text = currentGood.price.stringValue;
        return cell;
    }
    else {
        VAKRemovedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKRemovedCellIdentifier];
        cell.phoneId.text = currentGood.code.stringValue;
        cell.phoneName.text = currentGood.name;
        cell.phoneColor.text = currentGood.color;
        cell.phonePrice.text = @"Товар отсутствует на складе";

        [[VAKNetManager sharedManager] loadImageWithPath:currentGood.image completion:^(UIImage *image, NSError *error) {
            if (!error) {
                cell.phoneImage.image = image;
            }
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Good *good = self.goodsOfOrder[indexPath.row];
        [VAKCoreDataManager deleteGoodWithIdentifier:good.code orderId:self.order.orderId];
        self.goodsOfOrder = [self.order.goods allObjects];
        [[VAKNetManager sharedManager] updateRequestWithPath:[NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKOrderIdentifier, self.order.orderId] info:[self formattedDictionaryWithOrder:self.order] completion:nil];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
