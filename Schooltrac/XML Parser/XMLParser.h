//
//  XMLParser.h
//  Schooltrac
//
//  Created by  Rocks on 2/16/16.
//  Copyright © 2016 Rohini Pagar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessParseBlock)(id parseObject);

typedef void(^ErrorParseBlock)(NSError *parseError);

@interface XMLParser : NSObject
-(void)parseLoginServiceResponse:(NSData *)xml
                withSuccessBlock:(SuccessParseBlock)parseSuccess
                   andErrorBlock:(ErrorParseBlock)parseError;

-(void)parseDeviceServiceResponse:(NSData *)xml
                 withSuccessBlock:(SuccessParseBlock)parseSuccess
                    andErrorBlock:(ErrorParseBlock)parseError;

-(void)parseLatLongServiceResponse:(NSData *)xml
                 withSuccessBlock:(SuccessParseBlock)parseSuccess
                    andErrorBlock:(ErrorParseBlock)parseError;

-(void)parseEventListingData:(NSData *)xml
                  withSuccessBlock:(SuccessParseBlock)parseSuccess
                     andErrorBlock:(ErrorParseBlock)parseError;


@end
