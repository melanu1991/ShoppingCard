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

#pragma mark - Notification

- (void)goodAddToBasket:(NSNotification *)notification {
    User *user = [VAKProfileViewController sharedProfile].user;
    NSString *codeGood = notification.userInfo[VAKPhoneCode];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code.integerValue == %ld", codeGood.integerValue];
    NSArray *selectedGood = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:predicate];
    Good *good = selectedGood[0];
    predicate = [NSPredicate predicateWithFormat:@"orderId.integerValue == %ld AND status == 0", user.userId.integerValue];
    selectedGood = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    if (selectedGood.count > 0) {
        Order *currentOrder = selectedGood[0];
        [currentOrder addGoodsObject:good];
        NSString *pathToCurrentOrder = [NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKOrderIdentifier, currentOrder.orderId];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentOrder.date];
        NSString *dateString = [NSString stringWithFormat:@"%ld.%ld.%ld", [components day], [components month], [components year]];
        NSArray *goods = currentOrder.goods.allObjects;
        NSMutableArray *arr = [NSMutableArray array];
        for (Good *good in goods) {
            [arr addObject:@{ @"id" : good.code }];
        }
        NSDictionary *info = @{ VAKID : currentOrder.orderId,
                                VAKCatalog : [arr copy],
                                VAKDate : dateString,
                                VAKStatus : currentOrder.status,
                                VAKUserId : currentOrder.user.userId };
        [[VAKNetManager sharedManager] updateRequestWithPath:pathToCurrentOrder info:info completion:nil];
    }
    else {
        Order *openOrder = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:user.userId];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSString *dateString = [NSString stringWithFormat:@"%ld.%ld.%ld", [components day], [components month], [components year]];
        openOrder.date = [NSDate dateWithString:dateString format:VAKDateFormat];
        openOrder.status = @0;
        [openOrder addGoodsObject:good];
        openOrder.user = user;
        [user addOrdersObject:openOrder];
        NSString *path = [NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier];
        NSDictionary *info = @{ VAKID : openOrder.orderId,
                                VAKCatalog : @[],
                                VAKDate : dateString,
                                VAKStatus : openOrder.status,
                                VAKUserId : openOrder.user.userId };
        [[VAKNetManager sharedManager] uploadRequestWithPath:path info:info completion:nil];
    }
    [[VAKCoreDataManager sharedManager] saveContext];
}

#pragma mark - life cycle view

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.order) {
        self.menuItem.image = [UIImage imageNamed:@"arrowLeft.png"];
        self.title = [NSString stringWithFormat:@"№%@", self.order.orderId];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    else {
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeft];
        [self.view addGestureRecognizer:swipeRight];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodAddToBasket:) name:VAKBasketButtonPressed object:nil];
    }
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
    if (self.order) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if ([VAKProfileViewController sharedProfile].isProfileVC) {
            [[VAKProfileViewController sharedProfile] showMenu];
        }
        else {
            [[VAKProfileViewController sharedProfile] hideMenu];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.order) {
        self.goodsSelectedOrder = [self.order.goods allObjects];
        return self.goodsSelectedOrder.count;
    }
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
    [self loadAndSetImageForIndexPath:indexPath path:currentGood.image];
    if (self.order) {
        cell.basketButton.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - load and set image

- (void)loadAndSetImageForIndexPath:(NSIndexPath *)indexPath path:(NSString *)path {
    __block UIImage *image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:path];
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_sync(queue, ^{
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            });
            dispatch_sync(dispatch_get_main_queue(), ^{
                VAKCustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.phoneImage.image = image;
            });
        }];
        [task resume];
    });
}

#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
