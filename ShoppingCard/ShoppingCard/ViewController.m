#import "ViewController.h"
#import "VAKCustomTableViewCell.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "VAKNetManager.h"
#import "Good+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"
#import "VAKProfileViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *basketItem;
@property (strong, nonatomic) NSArray *goodsSelectedOrder;

@end

@implementation ViewController

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

#pragma mark - Notification

- (void)goodAddToBasket:(NSNotification *)notification {
    User *user = [VAKProfileViewController sharedProfile].user;
    NSString *codeGood = notification.userInfo[VAKPhoneCode];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code.integerValue == %ld", codeGood.integerValue];
    NSArray *selectedGood = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:predicate];
    Good *good = selectedGood[0];
    predicate = [NSPredicate predicateWithFormat:@"user.userId.integerValue == %ld AND status == 0", user.userId.integerValue];
    selectedGood = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    if (selectedGood.count > 0) {
        Order *currentOrder = selectedGood[0];
        [currentOrder addGoodsObject:good];
        NSString *pathToCurrentOrder = [NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKOrderIdentifier, currentOrder.orderId];
        [[VAKNetManager sharedManager] updateRequestWithPath:pathToCurrentOrder info:[self formattedDictionaryWithOrder:currentOrder] completion:nil];
    }
    else {
        Order *openOrder = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:user.userId];
        NSString *date = [[NSDate date] formattedString:VAKDateFormat];
        openOrder.date = [NSDate dateWithString:date format:VAKDateFormat];
        openOrder.status = @0;
        [openOrder addGoodsObject:good];
        openOrder.user = user;
        [user addOrdersObject:openOrder];
        NSString *path = [NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier];
        [[VAKNetManager sharedManager] uploadRequestWithPath:path info:[self formattedDictionaryWithOrder:openOrder] completion:nil];
    }
    [[VAKCoreDataManager sharedManager] saveContext];
}

#pragma mark - life cycle view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodAddToBasket:) name:VAKBasketButtonPressed object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
}

#pragma mark - action

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [[VAKProfileViewController sharedProfile] showMenu];
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
        [[VAKProfileViewController sharedProfile] showMenu];
    }
    else {
        [[VAKProfileViewController sharedProfile] hideMenu];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithRed:57.f/255.f green:151.f/255.f blue:255.f/255.f alpha:1.f];
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
    cell.phoneColor.text = currentGood.color;
    cell.phonePrice.text = currentGood.price.stringValue;
    
    [[VAKNetManager sharedManager] loadImageWithPath:currentGood.image completion:^(UIImage *image, NSError *error) {
        if (!error) {
            cell.phoneImage.image = image;
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
