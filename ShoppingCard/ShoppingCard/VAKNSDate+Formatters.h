#import <Foundation/Foundation.h>

extern NSString* const DATEFORMAT_RFC3339;

@interface NSDate (FMDateFormatters)

+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format locale:(NSLocale*)locale timezone:(NSTimeZone*)zone;
+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format;
+ (NSDate*)dateWithPosixString:(NSString*)dateString format:(NSString*)format;

- (NSString*)formattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone locale:(NSLocale*)locale;
- (NSString*)formattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone;
- (NSString*)formattedString:(NSString*)format withOptions:(void(^)(NSDateFormatter* formatter))optionsBlock;
- (NSString*)formattedString:(NSString*)format;

- (NSString*)posixFormattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone;
- (NSString*)posixFormattedString:(NSString*)format;

@end
