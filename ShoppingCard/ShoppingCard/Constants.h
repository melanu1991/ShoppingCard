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

static NSString * const VAKProfileViewControllerIdentifier = @"VAKProfileViewController";
static NSString * const VAKGoodViewControllerIdentifier = @"ViewController";

#pragma mark - UI identifier

static NSString * const VAKEntryButton = @"Entry";
static NSString * const VAKRegistrationButton = @"Registration";

#pragma mark - For works JSON

static NSString * const VAKApplicationJSON = @"application/json";
static NSString * const VAKContentType = @"Content-Type";

#pragma mark - default value for core data

static NSString * const VAKDefaultString = @"VAKDefaultString";

#pragma mark - constantf for parse from JSON in core data

static NSString * const VAKID = @"id";
static NSString * const VAKName =@"name";
static NSString * const VAKTitle =@"title";
static NSString * const VAKPrice =@"price";
static NSString * const VAKPassword =@"psw";
static NSString * const VAKDate = @"date";
static NSString * const VAKCatalog =@"catalog";
static NSString * const VAKPasswordFull = @"password";
static NSString * const VAKDiscount = @"discount";
static NSString * const VAKAddress = @"address";
static NSString * const VAKPhoneNumber = @"phoneNumber";
static NSString * const VAKStatus = @"status";
static NSString * const VAKColor = @"color";
static NSString * const VAKImage = @"image";

#pragma mark - UIAlertAction and UIAlertController

static NSString * const VAKError = @"Error";
static NSString * const VAKOK = @"OK";
static NSString * const VAKErrorMessage = @"Incorrect data entered";
static NSString * const VAKUserIsRegistrationMessage = @"Such user is registered";

#pragma mark - UIStoryboard identifier

static NSString * const VAKStoryboardName = @"Main";

#endif
