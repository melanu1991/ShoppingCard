#import "VAKNetManager.h"

@interface VAKNetManager ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation VAKNetManager

+ (instancetype)sharedManager {
    static VAKNetManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _session;
}

- (void)uploadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
        else {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(json, nil);
            });
        }
    }] resume];
}

- (void)loadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
        else {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(json, nil);
            });
        }
    }] resume];
}

+ (NSObject *)parserValueFromJSONValue:(NSObject *)value {
    NSObject *result = value;
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)value;
        if ([arr[0] isKindOfClass:[NSString class]]) {
            result = (NSString *)arr[0];
        }
        else if ([arr[0] isKindOfClass:[NSNumber class]]) {
            result = (NSNumber *)arr[0];
        }
    }
    return result;
}

@end
