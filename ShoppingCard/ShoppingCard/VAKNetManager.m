#import "VAKNetManager.h"
#import "Constants.h"

@interface VAKNetManager ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *configuration;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;

@end

@implementation VAKNetManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static VAKNetManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Lazy getters

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:self.configuration];
    }
    return _session;
}

- (NSURLSessionConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _configuration;
}

#pragma mark - Method for works with url-content

- (void)uploadRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion {
    self.url = [NSURL URLWithString:path];
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    [self.request setValue:VAKApplicationJSON forHTTPHeaderField:VAKContentType];
    self.request.HTTPMethod = @"POST";
    self.request.HTTPBody = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
    [[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        }
    }] resume];
}

- (void)loadRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion {
    self.url = [NSURL URLWithString:path];
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    self.request.HTTPMethod = @"GET";
    [[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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

- (void)updateRequestWithPath:(NSString *)path info:(NSDictionary *)info completion:(void(^)(id data, NSError *error))completion {
    self.url = [NSURL URLWithString:path];
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    [self.request setValue:VAKApplicationJSON forHTTPHeaderField:VAKContentType];
    self.request.HTTPMethod = @"PUT";
    self.request.HTTPBody = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
    [[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@", error);
        }
    }] resume];
}

- (void)deleteRequestWithPath:(NSString *)path completion:(void(^)(id data, NSError *error))completion {
    self.url = [NSURL URLWithString:path];
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    self.request.HTTPMethod = @"DELETE";
    [[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@", error);
        }
    }] resume];
}

- (void)loadImageWithPath:(NSString *)path completion:(void (^)(UIImage *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:path];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
           completion(image, error); 
        });
    }];
    [task resume];
}

@end
