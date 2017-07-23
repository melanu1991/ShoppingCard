#import "VAKBasketTableViewController.h"
#import "VAKCustomTableViewCell.h"

@interface VAKBasketTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VAKBasketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"VAKCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"VAKCustomTableViewCell"];
}

- (void)backButtonPressed {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VAKCustomTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
