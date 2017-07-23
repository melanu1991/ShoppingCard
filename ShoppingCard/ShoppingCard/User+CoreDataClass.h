#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object+CoreDataClass.h"

@class Order;

@interface User : Object


@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *_Nullable)value;
- (void)removeOrdersObject:(Order *_Nullable)value;
- (void)addOrders:(NSSet<Order *> *_Nullable)values;
- (void)removeOrders:(NSSet<Order *> *_Nullable)values;

@end
