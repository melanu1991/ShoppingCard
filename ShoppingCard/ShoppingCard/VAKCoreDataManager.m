#import "VAKCoreDataManager.h"
#import "User+CoreDataClass.h"
#import "Good+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "Constants.h"

@implementation VAKCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (VAKCoreDataManager *)sharedManager {
    static VAKCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VAKCoreDataManager alloc] init];
    });
    return manager;
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShoppingCard" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShoppingCard.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Save Context

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application Documents Directory

-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

@implementation VAKCoreDataManager (WorkWithCoreData)

+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:name inManagedObjectContext:[VAKCoreDataManager sharedManager].managedObjectContext];
    [request setEntity:description];
    [request setPredicate:predicate];
    NSArray *arrayEntities = [[VAKCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    return arrayEntities;
}

+ (void)deleteAllEntity {
    NSArray *goods = [VAKCoreDataManager allEntitiesWithName:VAKGood];
    NSArray *users = [VAKCoreDataManager allEntitiesWithName:VAKUser];
    NSArray *orders = [VAKCoreDataManager allEntitiesWithName:VAKOrder];
    for (Good *good in goods) {
        [[VAKCoreDataManager sharedManager].managedObjectContext deleteObject:good];
    }
    for (Order *order in orders) {
        [[VAKCoreDataManager sharedManager].managedObjectContext deleteObject:order];
    }
    for (User *user in users) {
        [[VAKCoreDataManager sharedManager].managedObjectContext deleteObject:user];
    }
    [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
}

+ (NSNumber *)generateIdentifier {
    NSNumber *identifier = [NSNumber numberWithInteger:arc4random_uniform(10000)];
    return identifier;
}

+ (Object *)createEntityWithName:(NSString *)name identifier:(NSNumber *)identifier {
    if ([name isEqualToString:VAKGood]) {
        Good *good = [NSEntityDescription insertNewObjectForEntityForName:VAKGood inManagedObjectContext:[VAKCoreDataManager sharedManager].managedObjectContext];
        if (identifier != nil) {
            good.code = identifier;
        }
        return good;
    }
    else if ([name isEqualToString:VAKOrder]) {
        Order *order = [NSEntityDescription insertNewObjectForEntityForName:VAKOrder inManagedObjectContext:[VAKCoreDataManager sharedManager].managedObjectContext];
        if (identifier != nil) {
            order.orderId = identifier;
        }
        else {
            order.orderId = [VAKCoreDataManager generateIdentifier];
        }
        return order;
    }
    User *user = [NSEntityDescription insertNewObjectForEntityForName:VAKUser inManagedObjectContext:[VAKCoreDataManager sharedManager].managedObjectContext];
    if (identifier != nil) {
        user.userId = identifier;
    }
    else {
        user.userId = [VAKCoreDataManager generateIdentifier];
    }
    return user;
}

+ (void)deleteGoodWithIdentifier:(NSNumber *)identifier orderId:(NSNumber *)orderId {
    NSArray *goods = [VAKCoreDataManager allEntitiesWithName:VAKGood predicate:[NSPredicate predicateWithFormat:@"code == %@", identifier]];
    Good *good = goods[0];
    NSArray *orders = [VAKCoreDataManager allEntitiesWithName:VAKOrder predicate:[NSPredicate predicateWithFormat:@"orderId == %@", orderId]];
    Order *order = orders[0];
    goods = [order.goods allObjects];
    NSMutableSet *newSetGoodsForOrder = [NSMutableSet set];
    for (Good *goodInOrder in goods) {
        if (![goodInOrder.code isEqualToNumber:good.code]) {
            [newSetGoodsForOrder addObject:goodInOrder];
        }
    }
    order.goods = [newSetGoodsForOrder copy];
    [[VAKCoreDataManager sharedManager].managedObjectContext save:nil];
}

+ (NSArray *)allEntitiesWithName:(NSString *)name {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:name inManagedObjectContext:[VAKCoreDataManager sharedManager].managedObjectContext];
    [request setEntity:description];
    NSArray *array = [[VAKCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    return array;
}

@end
