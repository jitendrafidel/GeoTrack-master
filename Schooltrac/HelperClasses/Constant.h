//
//  Constant.h
//  Schooltrac
//
//  Created by Rohini Pagar on 17/02/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
#ifdef __OBJC__
#import "AppDelegate.h"
#import "APIHeader.h"
#import "AppMenu.h"
#import "GMDCircleLoader.h"
#import "DateHandler.h"
#import "ServiceHandler.h"
#import <SWRevealViewController/SWRevealViewController.h>

#endif

// alert view messages
#define aTextFiledAlert              @"All the fields are mandatory"
#define GeoTrack                @"GeoTrack"
#define aOkAlert                     @"Ok"
#define Invalid_Credentials @"Please enter correct details."
#define No_Data_Found @"No data found"
#define Select_route @"Please select route to view Photos"

#define IS_DEVICE_iPHONE_5 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f))
#define iPhone5ExHeight ((IS_DEVICE_iPHONE_5)?88:0)
#define iPhone5ExHalfHeight ((IS_DEVICE_iPHONE_5)?44:0)
#define iPhone5ImageSuffix (IS_DEVICE_iPHONE_5)?@"-i5":@""
#define iOS7 (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20:0)
#define iOS7ExHeight (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20:0)
#define IS_iOS_Version_7 (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?YES:NO)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/256.0f green:(g)/256.0f blue:(b)/256.0f alpha:1.0f]

#define kCustomGRBLColor [UIColor colorWithRed:58.0/256.0f green:156.0/256.0f blue:178.0/256.0f alpha:1.0f]
#define kCustomGRBLDarkColor [UIColor colorWithRed:37.0/256.0f green:106.0/256.0f blue:115.0/256.0f alpha:1.0f]
#define kCustomGRBLDarkAlphaColor [UIColor colorWithRed:37.0/256.0f green:106.0/256.0f blue:115.0/256.0f alpha:0.7f]



//=================== Check device ========================//
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE     UIUserInterfaceIdiomPhone
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone6plus  ([[UIScreen mainScreen] bounds].size.height == 1104)?TRUE:FALSE
//======================= Alerts ============================//

#define NETWORL_ALERT @"Your internet connection seems to be offline."


//====================== Font names =============================//

#define FONT_OPENSANSE_BOLD @"OpenSans-Bold"
#define FONT_OPENSANSE_REGULAR @"OpenSans"
#define FONT_OPENSANSE_SEMIBOLD @"OpenSans-Semibold"

//====================== GeoTrack =============================//

#define FILTER_TYPE_DEVICES 1
#define FILTER_TYPE_START_DATE 2
#define FILTER_TYPE_END_DATE 3

#endif /* Constant_h */

