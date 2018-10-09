//
//  WSManager.h
//  Suvi
//
//  Created by Gagan on 6/4/13.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    WS_REQ_NONE,
    ASI_GET_SYNC,
    ASI_GET_ASYNC,
    ASI_GET_BG,
    ASI_POST_SYNC,
    ASI_POST_ASYNC,
    ASI_POST_BG
}
WS_REQUEST_TYPE;

@interface WSManager : NSObject<NSURLConnectionDelegate>
{
    SEL successSelector;
    SEL failureSelector;
    NSURLConnection *connection;
    NSMutableURLRequest *postRequest;
    NSString *strPostURL;
    NSInteger activitycount;
    void (^ callbackBlock)(NSString *response);
}

@property (nonatomic,strong) NSMutableData *webData;
@property (strong) NSObject *callBackObject;
@property (nonatomic,readwrite) BOOL shouldShowProgress;

-(void)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara postData:(NSDictionary *)dictPostData withCallback:(void (^)(id))callback;
-(void)startRequest;
-(void)stopRequest;

-(id)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject andRequestType:(WS_REQUEST_TYPE)wsRequestType;
-(void)startASIRequest;
-(void)stopASIRequest;

@end
