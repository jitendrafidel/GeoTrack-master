//
//
//  Copyright (c) 2014 . All rights reserved.
//

#import "AppMenu.h"
#import "Constant.h"
#import "Reachability.h"
#import "AppDelegate.h"

#define MENUPLIST @"menuItem.plist"

@implementation AppMenu

+ (id)sharedAppMenu {
    static AppMenu *sharedAppMenuObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppMenuObj = [[self alloc] init];
    });
    return sharedAppMenuObj;
}

- (id)init {
    if (self = [super init]) {
        [self createMenuItemPlist];
    }
    return self;
}

- (NSString*)getDocumentsDirPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString*)getPlistPath{
    NSString *path = [[self getDocumentsDirPath] stringByAppendingPathComponent:MENUPLIST];
    return path;

}

- (void)createMenuItemPlist{
    
    NSString * path = [self getPlistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *data;
    if (![fileManager fileExistsAtPath: path])
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSDictionary alloc] init];
    }
    else
    {
         // If the file  exist, create dictionary with existing file content
        data = [[NSDictionary alloc] initWithContentsOfFile: path];
    }
    
    [data writeToFile: path atomically:YES];
}

- (NSDictionary*)getPlistData{
    NSString * path = [self getPlistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path]){
        return [[NSDictionary alloc] initWithContentsOfFile: path];
    }
    return nil;
}
void SetUserDefaultsForKey(NSString *key, id value){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([value isKindOfClass:[NSString class]]){
        [defaults setValue:value forKey:key];
    }else{
        [defaults setObject:value forKey:key];
    }
    
    [defaults synchronize];
}
void SetIntegerUserDefaultsForKey(NSString *key, NSInteger value){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:value forKey:key];
    
    [defaults synchronize];
}
NSString* StringFromUserDefaultsForKey(NSString *key){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key];
}
NSInteger IntegerFromUserDefaultsForKey(NSString *key){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}
id ObjectFromUserDefaultsForKey(NSString *key){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
void ArchiveObjectForKey(NSString *key, id value){
    SetUserDefaultsForKey(key, [NSKeyedArchiver archivedDataWithRootObject:value]);
}
id UnArchiveObjectForKey(NSString *key){
    if (ObjectFromUserDefaultsForKey(key) == NULL) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:ObjectFromUserDefaultsForKey(key)];
}
BOOL IsValidString(NSString *value)
{
    if(value == nil || [value isKindOfClass:[NSString class]] == NO || [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 )
    {
        return NO;
    }
    else return YES;
}
BOOL IsArrayWithItems(id object) {
    return ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) ? [object count] > 0 : FALSE;
}

BOOL IsDictionaryWithItems(id object) {
    return ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) ? [object count] > 0 : FALSE;
}


BOOL IsEmptyString(id object){
    return (object == nil || [object isEqual:[NSNull null]] || [object isKindOfClass:[NSString class]] == NO || ([object isKindOfClass:[NSString class]] && [[(NSString*)object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0));
}

BOOL IsConnectedToNetwork()
{
    Reachability *reachability = [(AppDelegate *)[[UIApplication sharedApplication] delegate] reachability];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    return (remoteHostStatus == NotReachable || reachability.connectionRequired)?NO:YES;
    
}


BOOL isOS6()
{
    if([[[UIDevice currentDevice]  systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice]  systemVersion] floatValue] <= 7.0)
    {
        return TRUE;
    }
    return FALSE;
}

BOOL isOS7()
{
    if([[[UIDevice currentDevice]  systemVersion] floatValue] >= 7.0)
    {
        return TRUE;
    }
    return FALSE;
}

BOOL isOS8()
{
    if([[[UIDevice currentDevice]  systemVersion] floatValue] >= 8.0)
    {
        return TRUE;
    }
    return FALSE;
}
NSString * encodeURL(NSURL * value)
{
    if (value == nil)
        return @"";
    
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value.absoluteString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    return result;
}

+ (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(568, 320);
    }
    else{
        size = CGSizeMake(320, 568);
    }
    if (!application.statusBarHidden && [AppMenu iOSVersion] < 7.0) {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}


NSDate* getDateFor(NSString * sourceString, NSString * format)
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    NSLocale * usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    [df setDateFormat:format];
    NSDate * date = [df dateFromString:sourceString];
    return date;
}
NSString* getStringFromDate(NSDate *sourceDate, NSString * format)
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    NSLocale * usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    [df setDateFormat:format];
    NSString * dateString = [df stringFromDate:sourceDate];
    return dateString;
}
CGSize sizeForString(NSString *str,UIFont *font, CGFloat width){
    CGSize size = CGSizeZero;
     #if (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
        //iOS 6.0
        size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
     #else
        //iOS 7
        CGRect frame = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
    
    #endif
    return size;
}


NSString* removeHTML(NSString *str){
    
    static NSRegularExpression *regexp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:kNilOptions error:nil];
    });
    
    return [regexp stringByReplacingMatchesInString:str
                                            options:kNilOptions
                                            range:NSMakeRange(0, str.length)
                                            withTemplate:@""];
    
}



NSString* stringByStrippingHTML(NSString *inputString)
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
}

NSString * getFilteredStringFromVariousSymbols(NSString * text)
{
    text = [text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    text = [text stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    text = [text stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&#x39;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&#x92;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&#x96;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    text = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    text = [text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    text = [text stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];
    text = [text stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    text = [text stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    text = [text stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"‘"];
    text = [text stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"’"];
    text = [text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"_"];
    text = [text stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
    text = [text stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    text = [text stringByReplacingOccurrencesOfString:@"\\" withString:@"\\"];
    
    return text;
}

@end
