#import "VAKNSDate+Formatters.h"

@implementation NSDate (FMDateFormatters)

- (NSString*)formattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone locale:(NSLocale*)locale {
    NSDateFormatter *formatter = NSDateFormatter.new;
    if (locale)
        formatter.locale = locale;
    formatter.dateFormat = format;
    if (zone)
        formatter.timeZone = zone;
    return [formatter stringFromDate:self];
}
- (NSString*)formattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone {
    return [self formattedString:format withTimeZone:zone locale:NSLocale.currentLocale];
}
- (NSString*)formattedString:(NSString*)format withOptions:(void(^)(NSDateFormatter* formatter))optionsBlock {
    __block NSDateFormatter *formatter = NSDateFormatter.new;
    [formatter setDateFormat:format];
    optionsBlock(formatter);
    return [formatter stringFromDate:self];
}
+ (NSTimeZone*)posixTimeZone {
    return [NSTimeZone timeZoneForSecondsFromGMT:0];
}
- (NSString*)formattedString:(NSString*)format {
    return [self formattedString:format withTimeZone:nil locale:NSLocale.currentLocale];
}
- (NSString*)posixFormattedString:(NSString*)format withTimeZone:(NSTimeZone*)zone {
    NSLocale* posixLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    return [self formattedString:format withTimeZone:zone locale:posixLocale];
}
- (NSString*)posixFormattedString:(NSString*)format {
    NSLocale* posixLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    return [self formattedString:format withTimeZone:self.class.posixTimeZone locale:posixLocale];
}
+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format {
    return [self dateWithString:dateString format:format locale:NSLocale.currentLocale timezone:nil];
}
+ (NSDate*)dateWithPosixString:(NSString*)dateString format:(NSString*)format {
    return [self dateWithString:dateString
                         format:format
                         locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]
                       timezone:self.class.posixTimeZone];
}
+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format locale:(NSLocale*)locale timezone:(NSTimeZone*)zone {
    if (!dateString || !format) return nil;
    NSDateFormatter *formatter = NSDateFormatter.new;
    if (locale)
        formatter.locale = locale;
    formatter.dateFormat = format;
    if (zone)
        formatter.timeZone = zone;
    return [formatter dateFromString:dateString];
}

@end
