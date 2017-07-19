#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface VAKCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (VAKCoreDataManager *)sharedManager;
+ (NSManagedObjectContext *)managedObjectContext;
+ (void)setupCoreDataStorageName:(NSString *)name;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
