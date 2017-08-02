#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"
#import "VAKCustomTableViewCell.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Order *order;

@end

@implementation VAKBasketTableViewController

#pragma mark - life cycle uiviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKGoodTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKGoodCellIdentifier];
}

#pragma mark - action

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *user = [VAKProfileViewController sharedProfile].user;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ AND status == 0", user];
    NSArray *currentOrder = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:predicate];
    self.order = currentOrder[0];
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
