//
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppMenu : NSObject

+ (id)sharedAppMenu;

- (NSDictionary*)getPlistData;
void SetUserDefaultsForKey(NSString *key, id value);
void SetIntegerUserDefaultsForKey(NSString *key, NSInteger value);
NSString* StringFromUserDefaultsForKey(NSString *key);
NSInteger IntegerFromUserDefaultsForKey(NSString *key);
id ObjectFromUserDefaultsForKey(NSString *key);
BOOL IsDictionaryWithItems(id object);
void ArchiveObjectForKey(NSString *key, id value);
id UnArchiveObjectForKey(NSString *key);
BOOL IsValidString(NSString *value);
BOOL IsArrayWithItems(id object);
BOOL IsEmptyString(id object);
BOOL IsConnectedToNetwork();
BOOL isOS6();
BOOL isOS7();
BOOL isOS8();
NSString * encodeURL(NSURL * value);
NSDate* getDateFor(NSString * sourceString, NSString * format);
NSString* getStringFromDate(NSDate *sourceDate, NSString * format);
CGSize sizeForString(NSString *str,UIFont *font, CGFloat width);
NSString* removeHTML(NSString *str);
NSString* stringByStrippingHTML(NSString *inputString);
+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;
+ (float)iOSVersion;
void hitGoogleAnalyticsWithScreenName(NSString *screenName,NSString *categoty,NSString *action,NSString *label,NSString *customDimention);
void comscoreSHOWWithLabels(NSString *key,NSString *value);
void comscoreHIDEWithLabels(NSString *key,NSString *value);
NSString * getFilteredStringFromVariousSymbols(NSString * text);
@end
