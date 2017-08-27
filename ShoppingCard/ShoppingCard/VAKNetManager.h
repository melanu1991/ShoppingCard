#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;

- (void)loadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion;
- (void)uploadRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion;
- (void)updateRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion;
- (void)deleteRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion;
- (void)loadImageWithPath:(NSString *)path completion:(void(^)(UIImage *image, NSError *error))completion;

@end
