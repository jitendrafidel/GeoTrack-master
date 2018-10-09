//
//  ServiceHandler.h
//  Schooltrac
//
//  Created by Netstratum on 2/16/16.
//  Copyright © 2016 Rakesh palotra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACCOUNT @"account"
#define USER @"user"
#define PASSWORD @"password"

typedef void(^SuccessBlock)(id returnObject);

typedef void(^ErrorBlock)(NSError *error);

@interface ServiceHandler : NSURLSession

+(ServiceHandler *)singletonServiceHandlerInstance;

-(void)signInUserWithAccount:(NSString *)account
                    userName:(NSString *)userName
                 andPassword:(NSString *)password
            withSuccessBlock:(SuccessBlock)successBlk
               andErrorBlock:(ErrorBlock)errorBlk;

-(void)getDeviceListWithSuccessBlock:(SuccessBlock)successBlk
                       andErrorBlock:(ErrorBlock)errorBlk;

-(void)getDeviceLastLatLongWithSuccessBlockWithDeviceID:(NSString *)deviceID andSuccess:(SuccessBlock)successBlk andErrorBlock:(ErrorBlock)errorBlk;

-(void)getDeviceInfoWithDevice:(NSString *)deviceID
                    startDate:(NSString *)startDate
                 endDate:(NSString *)endDate
            withSuccessBlock:(SuccessBlock)successBlk
               andErrorBlock:(ErrorBlock)errorBlk;

@end
