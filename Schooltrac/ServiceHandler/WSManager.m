//
//  WSManager.m
//  Suvi
//
//  Created by Gagan on 6/4/13.
//
//

#import "WSManager.h"
#import "Constant.h"
@implementation WSManager
@synthesize webData;
@synthesize callBackObject,shouldShowProgress;

-(void)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara postData:(NSDictionary *)dictPostData withCallback: (void (^)(id))callback
{
    
    strPostURL=[NSString stringWithFormat:@"%@",postURL];
    self.webData = [[NSMutableData alloc]init];
    postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:postURL];
    [postRequest setTimeoutInterval:10.0];
    [postRequest setHTTPMethod:@"GET"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData  *body = [[NSMutableData alloc] init];
    
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //[postRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    for (NSString *theKey in [dictPostPara allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostPara objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (NSString *theKey in [dictPostData allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"pic.png\"\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[dictPostData objectForKey:theKey]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postRequest setHTTPBody:body];
    [self startRequest];
    callbackBlock = callback;
}

-(id)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject andRequestType:(WS_REQUEST_TYPE)wsRequestType
{
    return self;
}
-(void)startASIRequest
{
    
}
-(void)stopASIRequest
{
    
}
-(void)startRequest
{
    activitycount++;
  //  [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
}

-(void)stopRequest
{
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
//[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }
    
    [connection cancel];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
       // [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }
    
    callbackBlock((id)[NSDictionary dictionaryWithObject:(id)[NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"] forKey:@"error"]);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
     //   [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;//rakesh
    }

    NSError *err;
    id objectResponse = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableContainers error:&err];

    if (objectResponse)
    {
        
        callbackBlock(objectResponse);
    }
    else
    {
        NSString *strData = [[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
        callbackBlock((id)[NSDictionary dictionaryWithObject:strData forKey:@"error"]);
    }
}
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (shouldShowProgress)
    {
        if (successSelector)
        {
//            float  progess= (float)totalBytesWritten / totalBytesExpectedToWrite;
//            DLog(@"%f",progess);
//            NSString *strData = [[NSString alloc]initWithFormat:@"%f",progess];
            //[callBackObject performSelector:successSelector withObject:(id)[NSDictionary dictionaryWithObject:strData forKey:@"progress"]];
        }
    }
}
@end
