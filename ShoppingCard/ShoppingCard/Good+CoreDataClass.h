#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object+CoreDataClass.h"

@class NSObject, Order;

@interface Good : Object

@property (nullable, nonatomic, copy) NSNumber *code;
@property (nullable, nonatomic, copy) NSNumber *discount;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, retain) NSSet<Order *> *order;

@end

@interface Good (CoreDataGeneratedAccessors)

- (void)addOrderObject:(Order *_Nullable)value;
- (void)removeOrderObject:(Order *_Nullable)value;
- (void)addOrder:(NSSet<Order *> *_Nullable)values;
- (void)removeOrder:(NSSet<Order *> *_Nullable)values;

@end
