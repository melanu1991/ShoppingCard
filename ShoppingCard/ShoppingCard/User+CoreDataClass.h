#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface User : NSManagedObject

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *_Nullable)value;
- (void)removeOrdersObject:(Order *_Nullable)value;
- (void)addOrders:(NSSet<Order *> *_Nullable)values;
- (void)removeOrders:(NSSet<Order *> *_Nullable)values;

@end
