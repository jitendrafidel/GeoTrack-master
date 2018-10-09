//
//  DashBoardViewController.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "DashBoardViewController.h"
#import "MapViewController.h"
#import "Utilities.h"
#import "GeoTrackEventViewController.h"
#import "GroupEventsViewController.h"
#import "HSDatePickerViewController.h"
#import "DevicePickeViewViewController.h"
#import "LoginViewController.h"

@interface DashBoardViewController ()<HSDatePickerViewControllerDelegate,PickerViewDelegate,UIAlertViewDelegate>{
    UIStoryboard *storyBoard;
    NSArray<NSString *> *deviceList;
    BOOL isFromDateSeleted;
    NSArray *arrButtons;
}

@property (nonatomic, strong) NSDate *selectedToDate;
@property (nonatomic, strong) NSDate *selectedFromDate;

@end

@implementation DashBoardViewController

-(void)getDeviceList{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.reachability.isReachable){
        
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
        ServiceHandler *serviceHandler = [ServiceHandler singletonServiceHandlerInstance];
        [serviceHandler getDeviceListWithSuccessBlock:^(id returnObject) {
            
            deviceList = [[NSArray alloc] initWithArray:(NSArray *)returnObject];
            
            NSLog(@"Device List : %@", deviceList);
            dispatch_async(dispatch_get_main_queue(), ^{
                [GMDCircleLoader hideFromView:self.view animated:YES];
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

-(void)addHeaderViewLogoImage{
    self.navigationItem.titleView = [Utilities getHeaderImageView:self.navigationItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    isFromDateSeleted = NO;
    
    self.deviceViewYPoint.constant = 2000.0;

    arrButtons = [[NSArray alloc]initWithObjects:btnAllroute,btnEvents,btnGroupevent,btnLogout,nil];
    
    //Add header view logo image
    [self addHeaderViewLogoImage];
    
    //Get device list
    [self getDeviceList];
    
    //NSLog(@"Fnts = %@",[UIFont fontNamesForFamilyName:@"Open Sans"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getdeviceInfo{
    
}

#pragma mark - 
#pragma mark - Action Methods

-(IBAction)btnRoutePresssed:(id)sender{
    UIButton *btnsender = (UIButton *)sender;
    [btnsender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"all-routs-icon-active1.png"]] forState:UIControlStateNormal];
    
    // Deselect previously
    [self updateButtonImages:btnsender];
    
    MapViewController *mapView = [storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
    mapView.deviceList = deviceList;
    [self.navigationController pushViewController:mapView animated:YES];
}

-(IBAction)btnEventPresssed:(id)sender{
    
    UIButton *btnsender = (UIButton *)sender;
    [btnsender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"events-icon-active1.png"]] forState:UIControlStateNormal];
    
    // Setup default selected values for validations
    NSDateFormatter *dateFormaterDateOnle = [NSDateFormatter new];
    dateFormaterDateOnle.dateFormat = @"dd/MM/yyyy";
    NSString *strDate = [dateFormaterDateOnle stringFromDate:[NSDate date]];
    [self.btnFromDate setTitle:strDate forState:UIControlStateNormal];
    [self.btnToDate setTitle:strDate forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormater = [self getDateFormatter];
    NSString *strDateSelected = [dateFormater stringFromDate:[NSDate date]];
    self.selectedFromDate = [dateFormater dateFromString:strDateSelected];
    self.selectedToDate = [dateFormater dateFromString:strDateSelected];
    
    // Deselect previously
    [self updateButtonImages:btnsender];
    
    self.deviceViewYPoint.constant = 0.0;
    
    [self.viewFilterMain setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.viewFilterMain layoutIfNeeded];
    }];
}

-(IBAction)btnGroupEventsPresssed:(id)sender{
    UIButton *btnsender = (UIButton *)sender;
    [btnsender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"group-event-icon-active1.png"]] forState:UIControlStateNormal];
    
    // Deselect previously
    [self updateButtonImages:btnsender];
    
    GroupEventsViewController *groupEventVC = [storyBoard instantiateViewControllerWithIdentifier:@"GroupEventsViewController"];
    [self.navigationController pushViewController:groupEventVC animated:YES];
}

-(IBAction)btnLogoutPresssed:(id)sender{
//    UIButton *btnsender = (UIButton *)sender;
//    [btnsender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"log-out-icon-active1.png"]] forState:UIControlStateNormal];
//    
//    // Deselect previously
//    [self updateButtonImages:btnsender];

    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Do you really want to logout ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag=501;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==501) {
        if (buttonIndex==1) {
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //Clear user details in db (NSUerDefaults).
            SetUserDefaultsForKey(ACCOUNT, @"");
            SetUserDefaultsForKey(USER, @"");
            SetUserDefaultsForKey(PASSWORD, @"");
            
            UIStoryboard *main = [self storyboard];
            LoginViewController *loginViewController = [main instantiateInitialViewController];
            [appDelegate.window setRootViewController:loginViewController];
        }
    }
}

-(void)updateButtonImages:(UIButton *)btnSelected{

    for (int i = 0; i < [arrButtons count]; i++) {
        UIButton *btn = [arrButtons objectAtIndex:i];
        if(![btnSelected isEqual:btn]){
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Dicon%d.png",(i+1)]] forState:UIControlStateNormal];
        }
    }

}

-(IBAction)btnCloseEventFilterView:(id)sender{

    self.deviceViewYPoint.constant = 936.0;
    
    [self.viewFilterMain setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.viewFilterMain layoutIfNeeded];
    }];
}

-(IBAction)btnFromDatePressed:(id)sender{
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
    hsdpvc.delegate = self;
    isFromDateSeleted = YES;
    
    if (self.selectedFromDate) {
        hsdpvc.date = self.selectedFromDate;
    }else{
        NSDateFormatter *dateFormater = [self getDateFormatter];
        NSString *strDateSelected = [dateFormater stringFromDate:[NSDate date]];
        self.selectedFromDate = [dateFormater dateFromString:strDateSelected];
    }
    
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

-(IBAction)btnToDatePressed:(id)sender{
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
    hsdpvc.delegate = self;

    isFromDateSeleted = NO;
    
    if (self.selectedToDate) {
        hsdpvc.date = self.selectedToDate;
    }else{
        NSDateFormatter *dateFormater = [self getDateFormatter];
        NSString *strDateSelected = [dateFormater stringFromDate:[NSDate date]];
        self.selectedToDate = [dateFormater dateFromString:strDateSelected];
    }
    
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

-(IBAction)btnSelectDevicePressed:(id)sender{
    
    //UIButton *btnSender = (UIButton *)sender;
    
    DevicePickeViewViewController *devicepicker = [[DevicePickeViewViewController alloc] init];
    devicepicker.delegate = self;
    devicepicker.arrDevice = deviceList;
    
    [self presentViewController:devicepicker animated:YES completion:nil];
}

-(IBAction)btnOkPressed:(id)sender{
    
    NSDateFormatter *dateFormater = [self getDateFormatter];
    
    NSString *strFromDate = [dateFormater stringFromDate:_selectedFromDate];
    NSString *strToDate = [dateFormater stringFromDate:_selectedToDate];
    
    // Applyt validation before API call
    if([[_btnDevice.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0 || [_btnDevice.titleLabel.text isEqualToString:@"Select Device"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please select device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }else if ([[strFromDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please select start date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if ([[strToDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please select end date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else{
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"yyyy/MM/dd,HH:mm:ss";
        
        GeoTrackEventViewController *eventVC = [storyBoard instantiateViewControllerWithIdentifier:@"GeoTrackEventViewController"];
        eventVC.strDevideID = _btnDevice.titleLabel.text;
        eventVC.strFromDate = [dateFormater stringFromDate:_selectedFromDate];
        eventVC.strToDate = [dateFormater stringFromDate:_selectedToDate];
        [self.navigationController pushViewController:eventVC animated:YES];
    }
}

-(NSDateFormatter *)getDateFormatter{
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return dateFormater;
}

#pragma mark - HSDatePickerViewControllerDelegate

-(void)hsDatePickerPickedDate:(NSDate *)date{
    
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [self getDateFormatter];
    
    NSString *strDateSelected = [dateFormater stringFromDate:date];
    
    NSDateFormatter *dateFormaterDateOnle = [NSDateFormatter new];
    dateFormaterDateOnle.dateFormat = @"dd/MM/yyyy";
    
    NSString *strDate = [dateFormaterDateOnle stringFromDate:date];

    if(isFromDateSeleted){
        [self.btnFromDate setTitle:strDate forState:UIControlStateNormal];
        self.selectedFromDate = [dateFormater dateFromString:strDateSelected];
    }else{
        [self.btnToDate setTitle:strDate forState:UIControlStateNormal];
        self.selectedToDate = [dateFormater dateFromString:strDateSelected];
    }
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
}

-(void)deviceHasbeenSelected:(NSString *)strSelected{
    [_btnDevice setTitle:strSelected forState:UIControlStateNormal];
}

@end
