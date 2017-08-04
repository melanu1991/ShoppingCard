#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"
#import "VAKCustomTableViewCell.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "VAKNetManager.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Order *order;

@end

@implementation VAKBasketTableViewController

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
    
    User *user = [VAKProfileViewController sharedProfile].user;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ AND status == 0", user];
    NSArray *currentOrder = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    self.order = currentOrder[0];
    
    UIButton *checkoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat pointX = self.view.bounds.size.width / 2.f;
    CGFloat pointY = self.view.bounds.size.height - 64.f - 9.f - 29.f;
    checkoutButton.frame = CGRectMake(0.f, 0.f, 278.f, 58.f);
    checkoutButton.center = CGPointMake(pointX, pointY);
    checkoutButton.backgroundColor = [UIColor colorWithRed:184.f/255.f green:233.f/255.f blue:134.f/255.f alpha:1.f];
    [checkoutButton setTitle:@"Оформить заказ" forState:UIControlStateNormal];
    [checkoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkoutButton setFont:[UIFont systemFontOfSize:20.f]];
    checkoutButton.layer.cornerRadius = 6.f;
    checkoutButton.layer.shadowOffset = CGSizeMake(5.f, 5.f);
    checkoutButton.layer.shadowOpacity = 0.7f;
    checkoutButton.layer.shadowRadius = 6.f;
    checkoutButton.layer.shadowColor = [UIColor grayColor].CGColor;
    [checkoutButton addTarget:self action:@selector(checkoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkoutButton];
}

#pragma mark - action

- (void)checkoutButtonPressed:(UIButton *)sender {
    NSString *pathToCurrentOrder = [NSString stringWithFormat:@"%@%@/%@", VAKLocalHostIdentifier, VAKOrderIdentifier, self.order.orderId];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.order.date];
    NSString *dateString = [NSString stringWithFormat:@"%ld.%ld.%ld", [components day], [components month], [components year]];
    NSArray *goods = self.order.goods.allObjects;
    NSMutableArray *arr = [NSMutableArray array];
    for (Good *good in goods) {
        [arr addObject:@{ @"id" : good.code }];
    }
    NSDictionary *info = @{ VAKID : self.order.orderId,
                            VAKCatalog : [arr copy],
                            VAKDate : dateString,
                            VAKStatus : @1,
                            VAKUserId : self.order.user.userId };
    [[VAKNetManager sharedManager] updateRequestWithPath:pathToCurrentOrder info:info completion:nil];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.order.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [self loadAndSetImageForIndexPath:indexPath path:currentGood.image];
    cell.phonePrice.text = currentGood.price.stringValue;
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

@end
