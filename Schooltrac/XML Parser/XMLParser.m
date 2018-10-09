//
//  XMLParser.m
//  Schooltrac
//
//  Created by  Rocks on 2/16/16.
//  Copyright © 2016 Rohini Pagar. All rights reserved.
//

#import "XMLParser.h"
#import "XMLReader.h"
#import "TBXML.h"
#import "XMLDictionary.h"


#define UndefinedErrorMsg @"Unknown error"
#define NotFoundDataMsg @"Data not available"

#define SUCCESS @"success"
#define ErrorDomain @"com.schooltrac.fidelIT.rohini"

@implementation XMLParser

-(NSError *)getGenericEerror
{
    NSDictionary *errorMessage = @{@"Message":UndefinedErrorMsg};
    return [NSError errorWithDomain:ErrorDomain
                               code:1111
                           userInfo:errorMessage];
}

-(NSError *)getEmptyDataEerror
{
    NSDictionary *errorMessage = @{@"Message":NotFoundDataMsg};
    return [NSError errorWithDomain:ErrorDomain
                               code:404
                           userInfo:errorMessage];
}

-(NSError *)parseServerError:(TBXMLElement *)errorDetail
{
    
    NSString *errorCode = [TBXML valueOfAttributeNamed:@"code" forElement:errorDetail];
    errorCode = [[errorCode componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    NSString *serverMessage = [TBXML textForElement:errorDetail];
    
    NSUInteger statusCode = [errorCode integerValue];
    NSDictionary *message = @{@"Message":serverMessage};
    
    return [NSError errorWithDomain:ErrorDomain
                               code:statusCode
                           userInfo:message];
}


-(void)parseLoginServiceResponse:(NSData *)xml
                withSuccessBlock:(SuccessParseBlock)parseSuccess
                   andErrorBlock:(ErrorParseBlock)parseError
{
    /*
     <?xml version='1.0' encoding='UTF­8' standalone='no' ?>
     
     <GTSResponse command="version" result="success">
     
     <Version>
     
     <![CDATA[E2.5.9­B21]]>
     
     </Version>
     
     </GTSResponse>
     */
    
    NSString *strResponseXML=[[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
    NSLog(@"XML Login Response: %@", strResponseXML);
    
    TBXML * XML = [[TBXML alloc] initWithXMLData:xml];
    
    TBXMLElement *GTSResponse = XML.rootXMLElement;
    
    if (GTSResponse)
    {
        NSString * result = [TBXML valueOfAttributeNamed:@"result" forElement:GTSResponse];
        
        if ([result isEqualToString:SUCCESS]) {
            
            //Success response from server
            TBXMLElement *version = [TBXML childElementNamed:@"Version" parentElement:GTSResponse];
            if (version) {
                NSString *versionData = [TBXML textForElement:version];
                parseSuccess(versionData);
            } else {
                parseError([self getGenericEerror]);
            }
            
        } else {
            
            //Error from server
            TBXMLElement *errorDetail = [TBXML childElementNamed:@"Message" parentElement:GTSResponse];
            
            NSError *error;
            if (errorDetail) {
                //parse server error
                error = [self parseServerError:errorDetail];
                
            } else {
                
                //undefined error so send generic / default error.
                error = [self getGenericEerror];
            }
            
            parseError(error);
        }
    }else{
        parseError([self getGenericEerror]);
    }
}

-(void)parseEventListingData:(NSData *)xml
            withSuccessBlock:(SuccessParseBlock)parseSuccess
               andErrorBlock:(ErrorParseBlock)parseError{

        TBXML * XML = [[TBXML alloc] initWithXMLData:xml];
    
        TBXMLElement *GTSResponse = XML.rootXMLElement;
    
        if (GTSResponse){
            NSString * result = [TBXML valueOfAttributeNamed:@"result" forElement:GTSResponse];
            if ([result isEqualToString:SUCCESS]) {
                
                NSString *strResponseXML = [[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:strResponseXML];
                NSArray *ArrResponse = [[[xmlDoc objectForKey:@"Report"] objectForKey:@"ReportBody"] objectForKey:@"BodyRow"];
                
                NSMutableArray *mutArrResponseObj = [[NSMutableArray alloc]init];
                
                for (int i = 0; i < [ArrResponse count]; i++) {
                    NSArray *arrBodyColumn = [[ArrResponse objectAtIndex:i] objectForKey:@"BodyColumn"];
                    NSMutableDictionary *dictMain = [[NSMutableDictionary alloc]init];
                    for (int k = 0; k < [arrBodyColumn count]; k++) {
                        NSMutableDictionary *dictTemp = [arrBodyColumn objectAtIndex:k];
                        [dictMain setValue:[dictTemp valueForKey:@"__text"] forKey:[dictTemp valueForKey:@"_id"]];
                    }
                    @try {
                        [mutArrResponseObj addObject:dictMain];
                    }@catch (NSException *exception) {
                        // Exception occure
                    }
                }
                
                if ([mutArrResponseObj count]) {
                        parseSuccess(mutArrResponseObj);
                    } else {
                        //Send empty response error
                        parseError([self getEmptyDataEerror]);
                    }
        
                }else{
                    //Error from server
                    TBXMLElement *errorDetail = [TBXML childElementNamed:@"Message" parentElement:GTSResponse];
        
                    NSError *error;
                    if(errorDetail){
                        //parse server error
                        error = [self parseServerError:errorDetail];
        
                    }else{
        
                        //undefined error so send generic / default error.
                        error = [self getGenericEerror];
                    }
                    
                    parseError(error);
                }
        } else {
            parseError([self getGenericEerror]);
        }
}

-(void)parseDeviceServiceResponse:(NSData *)xml
                 withSuccessBlock:(SuccessParseBlock)parseSuccess
                    andErrorBlock:(ErrorParseBlock)parseError
{
    /*
     <GTSResponse command="dbget" result="success">
        <RecordKey table="Device">
        <Field name="accountID" primaryKey="true"><![CDATA[piloto]]></Field>
        <Field name="deviceID" primaryKey="true"><![CDATA[867844001569253]]></Field>
        </RecordKey>
     
        <RecordKey table="Device">
        <Field name="accountID" primaryKey="true"><![CDATA[piloto]]></Field>
        <Field name="deviceID" primaryKey="true"><![CDATA[867844001574089]]></Field>
        </RecordKey>
     </GTSResponse>
     */
    
    NSString *strResponseXML=[[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
    NSLog(@"XML Device Response: %@", strResponseXML);
    
    
    
    TBXML * XML = [[TBXML alloc] initWithXMLData:xml];
    
    TBXMLElement *GTSResponse = XML.rootXMLElement;
    
    if (GTSResponse)
    {
        NSString * result = [TBXML valueOfAttributeNamed:@"result" forElement:GTSResponse];
        
        if ([result isEqualToString:SUCCESS]) {
            
            NSMutableArray<NSString *> *deviceList = [NSMutableArray new];
            
            //Success response from server
            TBXMLElement *recordKey = [TBXML childElementNamed:@"RecordKey" parentElement:GTSResponse];
            while (recordKey) {
                TBXMLElement *field = [TBXML childElementNamed:@"Field" parentElement:recordKey];
                while (field) {
                    NSString * result = [TBXML valueOfAttributeNamed:@"name" forElement:field];
                    if ([result isEqualToString:@"deviceID"]) {
                        NSString *deviceID = [TBXML textForElement:field];
                        [deviceList addObject:deviceID];
                        //break inner while once get desired Field value.
                        break;
                    }else {
                        field = [TBXML nextSiblingNamed:@"Field" searchFromElement:field];
                    }
                }
                recordKey = [TBXML nextSiblingNamed:@"RecordKey" searchFromElement:recordKey];
            }
            
            if ([deviceList count]) {
                parseSuccess(deviceList);
            } else {
                //Send empty response error
                parseError([self getEmptyDataEerror]);
            }
            
        } else {
            
            //Error from server
            TBXMLElement *errorDetail = [TBXML childElementNamed:@"Message" parentElement:GTSResponse];
            
            NSError *error;
            if (errorDetail) {
                //parse server error
                error = [self parseServerError:errorDetail];
                
            } else {
                
                //undefined error so send generic / default error.
                error = [self getGenericEerror];
            }
            
            parseError(error);
        }
    } else {
        parseError([self getGenericEerror]);
    }
}


-(void)parseLatLongServiceResponse:(NSData *)xml
                  withSuccessBlock:(SuccessParseBlock)parseSuccess
                     andErrorBlock:(ErrorParseBlock)parseError{
/*
<GTSResponse command="dbget" result="success">
<Record table="Device">
<Field name="accountID" primaryKey="true">
<![CDATA[piloto]]>
</Field>
<Field name="deviceID" primaryKey="true">
<![CDATA[867844002293069]]>
</Field>
<Field name="groupID"></Field>
<Field name="equipmentType"></Field>
<Field name="equipmentStatus"></Field>
<Field name="vehicleMake"></Field>
<Field name="vehicleModel"></Field>
<Field name="vehicleYear">0</Field>
<Field name="vehicleID"></Field>
<Field name="licensePlate"></Field>
<Field name="licenseExpire">0</Field>
<Field name="insuranceExpire">0</Field>
<Field name="driverID"></Field>
<Field name="driverStatus">0</Field>
<Field name="fuelCapacity">0.0</Field>
<Field name="fuelEconomy">0.0</Field>
<Field name="fuelRatePerHour">0.0</Field>
<Field name="fuelCostPerLiter">0.0</Field>
<Field name="fuelTankProfile"></Field>
<Field name="speedLimitKPH">0.0</Field>
<Field name="planDistanceKM">0.0</Field>
<Field name="installTime">0</Field>
<Field name="resetTime">0</Field>
<Field name="expirationTime">0</Field>
<Field name="uniqueID" alternateKeys="altIndex">
<![CDATA[867844002293069]]>
</Field>*/
    
    NSMutableDictionary *deviceSpecs = [NSMutableDictionary new];
    
    NSString *strResponseXML=[[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
    NSLog(@"XML LatLong Response: %@", strResponseXML);
    
    NSError *parseErr = nil;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:strResponseXML error:&parseErr];
    NSLog(@" %@", xmlDictionary);

    if ([[xmlDictionary allKeys] count]) {
        parseSuccess(xmlDictionary);
    } else {
        //Send empty response error
        parseError([self getEmptyDataEerror]);
    }
    
    TBXML * XML = [[TBXML alloc] initWithXMLData:xml];
    
    TBXMLElement *GTSResponse = XML.rootXMLElement;
    
   /* if (GTSResponse)
    {
        NSString * result = [TBXML valueOfAttributeNamed:@"result" forElement:GTSResponse];
        
        if ([result isEqualToString:SUCCESS]) {
            
            //Success response from server
            TBXMLElement *record = [TBXML childElementNamed:@"Record" parentElement:GTSResponse];
            while (record) {
                TBXMLElement *field = [TBXML childElementNamed:@"Field" parentElement:record];
                while (field) {
                    NSString * result = [TBXML valueOfAttributeNamed:@"name" forElement:field];
                    if ([result isEqualToString:@"lastValidLatitude"]) {
                        NSString *latLogList = [TBXML textForElement:field];
                        [deviceSpecs setValue:latLogList forKey:@"lastValidLatitude"];
                        
                        //[latLogList addObject:deviceID];
                        //break inner while once get desired Field value.
                        break;
                    }else if ([result isEqualToString:@"lastValidLongitude"]){
                        NSString *latLogList = [TBXML textForElement:field];
                        [deviceSpecs setValue:latLogList forKey:@"lastValidLatitude"];
                         break;
                    }
                    }
                
                if ([[deviceSpecs allKeys] count]) {
                    parseSuccess(xmlDictionary);
                } else {
                    //Send empty response error
                    parseError([self getEmptyDataEerror]);
                }
                
                
            }
        }else {
            
            //Error from server
            TBXMLElement *errorDetail = [TBXML childElementNamed:@"Message" parentElement:GTSResponse];
            
            NSError *error;
            if (errorDetail) {
                //parse server error
                error = [self parseServerError:errorDetail];
                
            } else {
                
                //undefined error so send generic / default error.
                error = [self getGenericEerror];
            }
            
            parseError(error);
        }
    } else {
        parseError([self getGenericEerror]);
    }*/
}

@end
