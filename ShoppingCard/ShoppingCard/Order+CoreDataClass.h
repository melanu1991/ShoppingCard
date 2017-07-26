#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object+CoreDataClass.h"

@class Good, User;

@interface Order : Object

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSNumber *orderId;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, retain) NSSet<Good *> *goods;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(Good *_Nullable)value;
- (void)removeGoodsObject:(Good *_Nullable)value;
- (void)addGoods:(NSSet<Good *> *_Nullable)values;
- (void)removeGoods:(NSSet<Good *> *_Nullable)values;

@end
