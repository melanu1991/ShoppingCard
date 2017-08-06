#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Object;

@interface VAKCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (VAKCoreDataManager *)sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@interface VAKCoreDataManager (WorkWithCoreData)

+ (Object *)createEntityWithName:(NSString *)name identifier:(NSNumber *)identifier;
+ (void)deleteGoodWithIdentifier:(NSNumber *)identifier orderId:(NSNumber *)orderId;
+ (void)deleteAllEntity;
+ (NSArray *)allEntitiesWithName:(NSString *)name;
+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate;
+ (NSNumber *)generateIdentifier;

@end
