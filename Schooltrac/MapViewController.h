//
//  MapViewController.h
//  Schooltrac
//
//  Created by Rohini Pagar on 2/17/16.
//  Copyright © 2016 BestSoft. All rights reserved.

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController{
    
}
@property(weak)IBOutlet UIView *viewMenu;
@property(weak)IBOutlet UIView *viewBack;
@property(weak)IBOutlet UIView *navigationView;

@property(strong) NSArray<NSString *> *deviceList;

-(IBAction)btnDashboardClicked:(id)sender;

-(IBAction)btnCameraPressed:(id)sender;
-(IBAction)btnRefreshPressed:(id)sender;

@end
