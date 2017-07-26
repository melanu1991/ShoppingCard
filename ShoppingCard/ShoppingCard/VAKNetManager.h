#import <Foundation/Foundation.h>

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;
+ (NSObject *)parserValueFromJSONValue:(NSObject *)value;

- (void)loadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion;
- (void)uploadRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion;
- (void)updateRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion;
- (void)deleteRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion;

@end
