#import "VAKDataStorageUpdater.h"
#import "VAKCoreDataManager.h"
#import "VAKNetManager.h"
#import "Constants.h"
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "VAKNSDate+Formatters.h"

@implementation VAKDataStorageUpdater

+ (void)updateData {
    [VAKCoreDataManager deleteAllEntity];
    dispatch_group_t downloadGroup = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_enter(downloadGroup);
        [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKProfileIdentifier] completion:^(id data, NSError *error) {
            if (data) {
                NSArray *arrayUsers = data;
                for (NSDictionary *userInfo in arrayUsers) {
                    User *user = (User *)[VAKCoreDataManager createEntityWithName:VAKUser identifier:userInfo[VAKID]];
                    user.name = userInfo[VAKName];
                    user.password = userInfo[VAKPassword];
                    user.address = userInfo[VAKAddress];
                    user.phoneNumber = userInfo[VAKPhoneNumber];
                }
                [[VAKCoreDataManager sharedManager] saveContext];
                dispatch_group_leave(downloadGroup);
            }
        }];
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(downloadGroup);
        [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKCatalogIdentifier] completion:^(id data, NSError *error) {
            if (data) {
                NSArray *arrayPhones = data;
                for (NSDictionary *phoneInfo in arrayPhones) {
                    Good *phone = (Good *)[VAKCoreDataManager createEntityWithName:VAKGood identifier:phoneInfo[VAKID]];
                    phone.name = phoneInfo[VAKTitle];
                    phone.price = phoneInfo[VAKPrice];
                    phone.color = phoneInfo[VAKColor];
                    phone.discount = phoneInfo[VAKDiscount];
                    phone.count = phoneInfo[VAKCount];
                    phone.image = phoneInfo[VAKImage];
                }
                [[VAKCoreDataManager sharedManager] saveContext];
                dispatch_group_leave(downloadGroup);
            }
        }];
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(downloadGroup);
        [[VAKNetManager sharedManager] loadRequestWithPath:[NSString stringWithFormat:@"%@%@", VAKLocalHostIdentifier, VAKOrderIdentifier] completion:^(id data, NSError *error) {
            if (data) {
                NSArray *arrayOrders = data;
                for (NSDictionary *orderInfo in arrayOrders) {
                    Order *order = (Order *)[VAKCoreDataManager createEntityWithName:VAKOrder identifier:orderInfo[VAKID]];
                    order.date = [NSDate dateWithString:orderInfo[VAKDate] format:VAKDateFormat];
                    order.status = orderInfo[VAKStatus];
                    NSNumber *userIdOfOrder = orderInfo[VAKUserId];
                    NSArray *currentUser = [VAKCoreDataManager allEntitiesWithName:VAKUser predicate:[NSPredicate predicateWithFormat:@"userId == %@", userIdOfOrder]];
                    User *user = (User *)currentUser[0];
                    order.user = user;
                    [user addOrdersObject:order];
                    NSArray *phones = orderInfo[VAKCatalog];
                    for (NSDictionary *goodInfo in phones) {
                        NSArray *arrayOfPhone = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:[NSPredicate predicateWithFormat:@"code == %@", goodInfo[VAKID]]];
                        Good *currentPhone = (Good *)arrayOfPhone[0];
                        [order addGoodsObject:currentPhone];
                        [currentPhone addOrderObject:order];
                    }
                }
                [[VAKCoreDataManager sharedManager] saveContext];
                dispatch_group_leave(downloadGroup);
            }
        }];
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
    });
}

@end
