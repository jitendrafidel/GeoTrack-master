//
//  EventViewController.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "GeoTrackEventViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "GMDCircleLoader.h"
#import "ServiceHandler.h"
#import "Constant.h"
#import "EventListCellTableViewCell.h"

@interface GeoTrackEventViewController (){
    UIStoryboard *storyBoard;
    
}

@property(weak)IBOutlet UISegmentedControl *segmentControl;

@end

@implementation GeoTrackEventViewController

-(void)changeBackButtonImage{
    UIImage* image3 = [UIImage imageNamed:@"BackHeaderImage.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width/2, image3.size.height/2);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem = mailbutton;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add custom back button image
    [self changeBackButtonImage];
    
    // Get the event for specific device and time
    [self getEventsForDevice:_strDevideID startDateTime:_strFromDate andEndDateTime:_strToDate];
    
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Add navigation bar header image
    //self.navigationItem.titleView = [Utilities getHeaderImageView:self.navigationItem];
    [self addTitleViewInBiggerText];
}

-(void)addTitleViewInBiggerText{
    
    NSLog(@"Fonts = %@",[UIFont fontNamesForFamilyName:@"Helvetica"]);
    
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Helvetica-Light" size:22];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor colorWithRed:204.0/255.0 green:25.0/255.0 blue:32.0/255.0 alpha:1.0]; // Change to desired color
        titleView.backgroundColor=[UIColor clearColor];
        titleView.text = @"EVENT DETAILS";
        titleView.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem setTitleView:titleView];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrAllEvents count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventListCellTableViewCell *eventCell;
    
    static NSString *newsCellIdentifier = @"eventCell";
    if (eventCell == nil) {
        eventCell = [[EventListCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsCellIdentifier];
    }
    
    // Keep the color in atlernet
    if (indexPath.row%2 == 0) {
        eventCell.backgroundColor = [UIColor whiteColor];
    }else{
        eventCell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    }
    
    NSString *strDateTime = [NSString stringWithFormat:@"%@ %@",[[_arrAllEvents objectAtIndex:indexPath.row] valueForKey:@"date"],[[_arrAllEvents objectAtIndex:indexPath.row] valueForKey:@"time"]];
    
    eventCell.lblDateTime.text = strDateTime;
    eventCell.lblStatus.text = [[_arrAllEvents objectAtIndex:indexPath.row] valueForKey:@"statusdesc"];
    eventCell.lblLatitude.text = [[_arrAllEvents objectAtIndex:indexPath.row] valueForKey:@"geopoint"];
    eventCell.lblspeedMHP.text = [[_arrAllEvents objectAtIndex:indexPath.row] valueForKey:@"speedh"];
    
    return eventCell;
}


#pragma mark -
#pragma mark - Get Event Details 

-(void)getEventsForDevice:(NSString *)deviceID startDateTime:(NSString *)startDate andEndDateTime:(NSString *)endDateTime{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.reachability.isReachable) {
        
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
        ServiceHandler *serviceHandler = [ServiceHandler singletonServiceHandlerInstance];
        
        [serviceHandler getDeviceInfoWithDevice:deviceID startDate:startDate endDate:endDateTime withSuccessBlock:^(id returnObject) {
            
            _arrAllEvents = [[NSArray alloc] initWithArray:(NSArray *)returnObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GMDCircleLoader hideFromView:self.view animated:YES];
                [tblViewEvents reloadData];
            });
            
        } andErrorBlock:^(NSError *error) {
            NSLog(@"Error At Device Fetch: %@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [GMDCircleLoader hideFromView:self.view animated:YES];
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:GeoTrack
                                                                                    message:error.userInfo[@"Message"]
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Ok", @"Ok action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Ok action");
                                           }];
                
                [errorAlert addAction:okAction];
                
                [self presentViewController:errorAlert animated:YES completion:nil];
            });
        }];
        
    } else {
        [GMDCircleLoader hideFromView:self.view animated:YES];
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:GeoTrack
                                                                            message:NETWORL_ALERT
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", @"Ok action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Ok action");
                                   }];
        
        [errorAlert addAction:okAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}

@end
