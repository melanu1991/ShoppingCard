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
+ (void)deleteEntityWithName:(NSString *)name identifier:(NSNumber *)identifier;
+ (void)deleteAllEntity;
+ (NSArray *)allEntitiesWithName:(NSString *)name;
+ (NSNumber *)generateIdentifier;

@end
