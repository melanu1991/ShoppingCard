#import "ViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Good+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"
#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
        //Тут нада сначала с ордера извлекать все заказы а потом формировать полный перечень! И видимо нада перечислять заного все поля, потому что дата и статус затираются иначе (непонятная логика почему так!)
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentOrder.date];
        NSString *dateString = [NSString stringWithFormat:@"%ld.%ld.%ld", [components day], [components month], [components year]];
        NSDictionary *info = @{ VAKID : currentOrder.orderId,
                                VAKCatalog : @[ @{ @"id" : good.code } ],
                                VAKDate : dateString,
                                VAKStatus : currentOrder.status };
        [[VAKNetManager sharedManager] updateRequestWithPath:pathToCurrentOrder info:info completion:nil];
    }
    else {
        Order *openOrder = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:user.userId];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSString *dateString = [NSString stringWithFormat:@"%ld.%ld.%ld", [components day], [components month], [components year]];
        openOrder.date = [NSDate dateWithString:dateString format:VAKDateFormat];
        NSLog(@"%@", openOrder.date);
        openOrder.status = @0;
        [openOrder addGoodsObject:good];
        NSString *path = [NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier];
        NSDictionary *info = @{ VAKDate : dateString,
                                VAKStatus : @0,
                                VAKCatalog : @[ @{VAKID : good.code} ],
                                VAKID : user.userId };
        [[VAKNetManager sharedManager] uploadRequestWithPath:path info:info completion:nil];
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
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodAddToBasket:) name:VAKBasketButtonPressed object:nil];
}

#pragma mark - action

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:VAKBasketTableViewControllerIdentifier]) {
        UINavigationController *nc = [segue destinationViewController];
        VAKBasketTableViewController *vc = (VAKBasketTableViewController *)nc.topViewController;
        User *user = [VAKProfileViewController sharedProfile].user;
        NSArray *orderOfUser = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"user == %@ AND status == 0", user]];
        vc.order = (Order *)orderOfUser[0];
    }
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

#pragma mark - UITableViewDataSource

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
    NSString *path = [NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKCatalog, currentGood.code];
    [[VAKNetManager sharedManager] loadRequestWithPath:path completion:^(id data, NSError *error) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
