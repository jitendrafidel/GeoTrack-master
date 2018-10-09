//
//  AppDelegate.h
//  Schooltrac
//
//  Created by Rohini Pagar on 2/17/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)Reachability *reachability;

@end

