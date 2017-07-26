#import "ViewController.h"
#import "VAKCustomTableViewCell.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Good+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"
#import "VAKBasketTableViewController.h"
#import "VAKProfileViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Notification



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
}

#pragma mark - action

- (IBAction)basketButtonPressed:(UIButton *)sender {
    VAKBasketTableViewController *vc = [[VAKBasketTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

@end
