#import "VAKOrdersTableViewController.h"
#import "Constants.h"
#import "VAKCoreDataManager.h"
#import "Order+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "VAKBasketTableViewCell.h"
#import "VAKProfileViewController.h"

@interface VAKOrdersTableViewController ()

@end

@implementation VAKOrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:VAKBasketTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VAKBasketCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    return cell;
}

@end
