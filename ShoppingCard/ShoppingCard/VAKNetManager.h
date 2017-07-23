#import <Foundation/Foundation.h>

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;
+ (NSObject *)parserValueFromJSONValue:(NSObject *)value;

- (void)loadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion;

@end
