//
//  DashBoardViewController.h
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardViewController : UIViewController{
    IBOutlet UIButton *btnAllroute,*btnEvents,*btnGroupevent,*btnLogout;
}

-(IBAction)btnRoutePresssed:(id)sender;
-(IBAction)btnEventPresssed:(id)sender;
-(IBAction)btnGroupEventsPresssed:(id)sender;
-(IBAction)btnLogoutPresssed:(id)sender;

// Filter popup view
@property(weak)IBOutlet UIView *viewFilterMain;
@property(weak)IBOutlet UIView *viewFilterPopUp;
@property(weak)IBOutlet UIView *viewFilterImageBack;
@property(weak)IBOutlet UIImageView *imgViewRed;
@property(weak)IBOutlet UIButton *btnFromDate;
@property(weak)IBOutlet UIButton *btnToDate;
@property(weak)IBOutlet UIButton *btnDevice;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceViewYPoint;

-(IBAction)btnCloseEventFilterView:(id)sender;
-(IBAction)btnFromDatePressed:(id)sender;
-(IBAction)btnToDatePressed:(id)sender;
-(IBAction)btnSelectDevicePressed:(id)sender;
-(IBAction)btnOkPressed:(id)sender;

@end
