//
//  ServiceHandler.m
//  Schooltrac
//
//  Created by Netstratum on 2/16/16.
//  Copyright © 2016 Rakesh palotra. All rights reserved.
//

#import "ServiceHandler.h"

#import "XMLParser.h"
#import "AppMenu.h"

#define backgroundSessionIdentifier     @"com.bestsoft.rohini_pagar.schooltrac.backSessionIdentifier"

@interface ServiceHandler ()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@property (readonly, nonatomic, copy) NSString *taskDescriptionForSessionTasks;
@property (readwrite, nonatomic, strong) NSLock *lock;

@end

@implementation ServiceHandler

static ServiceHandler *manager;

+(ServiceHandler *)singletonServiceHandlerInstance
{
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        manager = [[ServiceHandler alloc] initWithSession];
        
    });
    return manager;
}

-(instancetype)initWithSession{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self = [self initWithSessionConfiguration:configuration];
    
    if (!self) {
        return nil;
    }
    return self;
}


- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    _sessionConfiguration = configuration;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
    
    _session = [NSURLSession sessionWithConfiguration:_sessionConfiguration
                                             delegate:self
                                        delegateQueue:_operationQueue];
    
    return self;
}


-(NSURLRequest *)makeGETRequest:(NSString *)xmlMsg
{
    //NSURL *url = [NSURL URLWithString:@"http://54.201.157.3:8080/track/Service"];
    NSURL *url = [NSURL URLWithString:@"http://54.201.157.3:8080/track/Service"];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[xmlMsg length]];
    
    [request addValue:@"text/xml; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //[req addValue:[NSString stringWithFormat:@"http://tempuri.org/%@",webMethod] forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"54.201.157.3" forHTTPHeaderField:@"Host"];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody: [xmlMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:600];
    
    return [request copy];
}

-(NSURLRequest *)makePOSTRequest:(NSString *)xmlMsg
{
    //NSURL *url = [NSURL URLWithString:@"http://54.201.157.3:8080/track/Service"];
    NSURL *url = [NSURL URLWithString:@"http://54.201.157.3:8080/track/Service"];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[xmlMsg length]];
    
    [request addValue:@"text/xml; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //[req addValue:[NSString stringWithFormat:@"http://tempuri.org/%@",webMethod] forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"54.201.157.3" forHTTPHeaderField:@"Host"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [xmlMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:600];
    
    return [request copy];
}

-(void)signInUserWithAccount:(NSString *)account userName:(NSString *)userName andPassword:(NSString *)password withSuccessBlock:(SuccessBlock)successBlk andErrorBlock:(ErrorBlock)errorBlk
{
    /*
     <GTSRequest command="version">
     
     <Authorization account="piloto" user="admin" password="12345678"/>
     
     </GTSRequest>
     */
    
    NSString *xmlMessage =[NSString stringWithFormat:@"<GTSRequest command=\"version\">\
                                                        <Authorization account=\"%@\" user=\"%@\" password=\"%@\"/>\
                                                        </GTSRequest>",account,userName,password];
    
    
    NSURLRequest *request = [self makePOSTRequest:xmlMessage];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"ErrorDescription: %@", [error localizedDescription]);
            errorBlk(error);
        }else{
            //XML Parsing
            XMLParser *parser = [[XMLParser alloc] init];
            [parser parseLoginServiceResponse:data withSuccessBlock:^(id parseObject) {
                successBlk(parseObject);
            } andErrorBlock:^(NSError *parseError) {
                errorBlk(parseError);
            }];
        }
    }];
    
    [dataTask resume];
    
}

-(void)getDeviceInfoWithDevice:(NSString *)deviceID
                     startDate:(NSString *)startDate
                       endDate:(NSString *)endDate
              withSuccessBlock:(SuccessBlock)successBlk
                 andErrorBlock:(ErrorBlock)errorBlk{
    
    NSString *account   =(StringFromUserDefaultsForKey(ACCOUNT));
    NSString *user      =(StringFromUserDefaultsForKey(USER));
    NSString *password  =(StringFromUserDefaultsForKey(PASSWORD));
    
    NSString *xmlMessage =[NSString stringWithFormat:@"<GTSRequest command=\"report\">\
                           <Authorization account=\"%@\" user=\"%@\" password=\"%@\"/>\
                           <Report name=\"EventDetail\">\
                           <Device>%@</Device>\
                           <TimeFrom timezone=\"GMT-05:00\">%@</TimeFrom>\
                           <TimeTo timezone=\"GMT-05:00\">%@</TimeTo>\
                           </Report>\
                           </GTSRequest>",account, user, password, deviceID,startDate,endDate];
    
    NSURLRequest *request = [self makePOSTRequest:xmlMessage];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"ErrorDescription: %@", [error localizedDescription]);
            errorBlk(error);
        }else{
            //XML Parsing
            XMLParser *parser = [[XMLParser alloc] init];
            [parser parseEventListingData:data withSuccessBlock:^(id parseObject) {
                successBlk(parseObject);
            } andErrorBlock:^(NSError *parseError) {
                errorBlk(parseError);
            }];
        }
    }];
    
    [dataTask resume];

}

-(void)getDeviceListWithSuccessBlock:(SuccessBlock)successBlk
                       andErrorBlock:(ErrorBlock)errorBlk
{
    
    NSString *account   =(StringFromUserDefaultsForKey(ACCOUNT));
    NSString *user      =(StringFromUserDefaultsForKey(USER));
    NSString *password  =(StringFromUserDefaultsForKey(PASSWORD));
    
    NSString *xmlMessage =[NSString stringWithFormat:@"<GTSRequest command=\"dbget\">\
                                                        <Authorization account=\"%@\" user=\"%@\" password=\"%@\"/>\
                                                        <RecordKey table=\"Device\" partial=\"true\">\
                                                        <Field name=\"accountID\">%@</Field>\
                                                        </RecordKey>\
                                                        </GTSRequest>",account, user, password, account];
    
    
    NSURLRequest *request = [self makePOSTRequest:xmlMessage];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"ErrorDescription: %@", [error localizedDescription]);
            errorBlk(error);
        }else{
            //XML Parsing
            XMLParser *parser = [[XMLParser alloc] init];
            [parser parseDeviceServiceResponse:data withSuccessBlock:^(id parseObject) {
                successBlk(parseObject);
            } andErrorBlock:^(NSError *parseError) {
                errorBlk(parseError);
            }];
        }
    }];
    
    [dataTask resume];
}


-(void)getDeviceLastLatLongWithSuccessBlockWithDeviceID:(NSString *)deviceID andSuccess:(SuccessBlock)successBlk andErrorBlock:(ErrorBlock)errorBlk
{
    
    NSString *account   =(StringFromUserDefaultsForKey(ACCOUNT));
    NSString *user      =(StringFromUserDefaultsForKey(USER));
    NSString *password  =(StringFromUserDefaultsForKey(PASSWORD));
    
    
    
    NSString *xmlMessage =[NSString stringWithFormat:@"<GTSRequest command=\"dbget\">\
                           <Authorization account=\"%@\" user=\"%@\" password=\"%@\"/>\
                           <Record table=\"Device\">\
                           <Field name=\"accountID\">%@</Field>\
                           <Field name=\"deviceID\">%@</Field>\
                           </Record>\
                           </GTSRequest>",account, user, password, account,deviceID];
    
    
    NSURLRequest *request = [self makePOSTRequest:xmlMessage];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"ErrorDescription: %@", [error localizedDescription]);
            errorBlk(error);
        }else{
            //XML Parsing
            XMLParser *parser = [[XMLParser alloc] init];
            
            [parser parseLatLongServiceResponse:data withSuccessBlock:^(id parseObject) {
                successBlk(parseObject);
            } andErrorBlock:^(NSError *parseError) {
                errorBlk(parseError);
            }];
            
//            [parser parseDeviceServiceResponse:data withSuccessBlock:^(id parseObject) {
//                successBlk(parseObject);
//            } andErrorBlock:^(NSError *parseError) {
//                errorBlk(parseError);
//            }];
        }
    }];
    
    [dataTask resume];
}



#pragma mark - NSURLSessionDelegate Methods

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    NSLog(@"Error: %@", [error localizedDescription]);
}

/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    
}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    NSLog(@"Background task completed");
}


#pragma mark - NSURLSessionTaskDelegate Methods

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
}

#pragma mark - NSURLSessionDataDelegate Methods

/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
}

/* Notification that a data task has become a download task.  No
 * future messages will be sent to the data task.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
}

/* Invoke the completion routine with a valid NSCachedURLResponse to
 * allow the resulting data to be cached, or pass nil to prevent
 * caching. Note that there is no guarantee that caching will be
 * attempted for a given resource, and you should not rely on this
 * message to receive the resource data.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    
}


# pragma mark - URLSession Download Delegate Methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"Temp downloaded file Path: %@", [location absoluteString]);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.prgView setProgress:progress];
    });
}

@end
