#ifndef Constants_h
#define Constants_h

#pragma mark - Localhost

static NSString * const VAKCatalogIdentifier = @"catalog";
static NSString * const VAKOrderIdentifier = @"order";
static NSString * const VAKProfileIdentifier = @"profile";
static NSString * const VAKLocalHostIdentifier = @"http://localhost:3000/";

#pragma mark - Entity

static NSString * const VAKUser = @"User";
static NSString * const VAKGood = @"Good";
static NSString * const VAKOrder = @"Order";

#pragma mark - TableViewCell

static NSString * const VAKGoodCellIdentifier = @"VAKGoodCellIdentifier";
static NSString * const VAKBasketCellIdentifier = @"VAKBasketCellIdentifier";
static NSString * const VAKGoodTableViewCellIdentifier = @"VAKCustomTableViewCell";
static NSString * const VAKBasketTableViewCellIdentifier = @"VAKBasketTableViewCell";

#pragma mark - Date Format

static NSString * const VAKDateFormat = @"dd.MM.yyyy";

#pragma mark - Notification

static NSString * const VAKBasketButtonPressed = @"VAKBasketButtonPressed";
static NSString * const VAKPhoneCode = @"VAKPhoneCode";
static NSString * const VAKUserAuthorization = @"VAKUserAuthorization";

#pragma mark - Controllers identifier

static NSString * const VAKProfileTableViewControllerIdentifier = @"VAKProfileTableViewController";
static NSString * const VAKGoodViewControllerIdentifier = @"ViewController";

#pragma mark - UI identifier

static NSString * const VAKEntryButton = @"Entry";
static NSString * const VAKRegistrationButton = @"Registration";

#endif
