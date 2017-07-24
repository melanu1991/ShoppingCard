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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKBasketTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKBasketCellIdentifier];
    [VAKCoreDataManager deleteAllEntity];
    [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier] completion:^(id data, NSError *error) {
        if (data) {
            for (id item in data) {
                Order *order = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:(NSNumber *)[VAKNetManager parserValueFromJSONValue:[item valueForKeyPath:@"id"]]];
                order.date = [NSDate dateWithString:item[@"date"] format:VAKDateFormat];
                NSArray *arrayGoodsFromOrder = [item valueForKeyPath:@"catalog"];
                NSArray *arrayGoodsFromDB = [VAKCoreDataManager allEntitiesWithName:VAKGood];
                for (NSDictionary *goodFromOrder in arrayGoodsFromOrder) {
                    NSNumber *number = goodFromOrder[@"id"];
                    NSLog(@"%ld", number.integerValue);
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code.integerValue == %ld", number.integerValue];
                    arrayGoodsFromDB = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:predicate];
                }
            }
            [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
            [self.tableView reloadData];
        }
    }];
}

- (void)backButtonPressed {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKBasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKBasketCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
