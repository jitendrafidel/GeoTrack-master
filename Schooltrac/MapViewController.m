//
//  MapViewController.m
//  Schooltrac
//
//  Created by Rohini Pagar on 2/17/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "Utilities.h"
#import "DeviceListCell.h"

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSIndexPath *selectedIndexpath;
}
@property (nonatomic, weak) IBOutlet UIView *deviceView;
@property (nonatomic, weak) IBOutlet UITableView *tblDevices;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet UIButton *btnDashBoard;
@property (nonatomic, weak) IBOutlet UIButton *btnLogout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceViewXPoint;

@end

@implementation MapViewController
{
    //NSArray<NSString *> *deviceList;
}

@synthesize deviceList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndexpath = nil;
    
    self.navigationController.navigationBarHidden = YES;
    
    // Set button fonts and colors
    _btnDashBoard.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    _btnLogout.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    
    self.navigationItem.titleView = [Utilities getHeaderImageView:self.navigationItem];
    
    self.tblDevices.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:22.0/255.0 alpha:1.0];
    
    // Add a user tracking button to the toolbar
    MKUserTrackingBarButtonItem *trackingItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    [self.navigationItem setRightBarButtonItem:trackingItem];
    // Need a delegate to receive -mapViewWillStartLocatingUser:
    self.mapView.delegate = self;
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in Schooltrac-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    // Get the last updated status of first device
    NSString *selectedDeviceId = [deviceList firstObject];
    [self getDataForSpecificDeviceID:selectedDeviceId];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideDeviceView)];
    [self.mapView addGestureRecognizer:singleFingerTap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - CLLocationDelegate Method
// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    [manager stopUpdatingLocation];
}

#pragma mark - MKMapViewDelegate Methods
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
        // Alert the user and send them to the settings to turn on location
    }
}

#pragma mark - Show Main Menu Page
- (IBAction)showMenu:(id)sender
{
    [self hideDeviceView];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        [revealViewController revealToggle:sender];
    }
}

-(IBAction)btnCameraPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"This feature is planed for next release" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(IBAction)btnRefreshPressed:(id)sender{
    //Get selected device Id
    NSString *selectedDeviceId = [deviceList objectAtIndex:selectedIndexpath.row];
    [self getDataForSpecificDeviceID:selectedDeviceId];
}

#pragma mark - Show Device List Page

-(IBAction)showDeviceList:(id)sender{
    if (_deviceViewXPoint.constant == 0.0f){
        [self hideDeviceView];
    }else{
        self.viewMenu.hidden = YES;
        self.viewBack.hidden = NO;
        
        _deviceViewXPoint.constant = 0.0f;
        [_deviceView setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.3f animations:^{
            [_deviceView layoutIfNeeded];
        }];
        
        [_tblDevices reloadData];
    }
}

-(void)hideDeviceView{
    if (_deviceViewXPoint.constant == 0.0f){
        
        self.viewMenu.hidden = NO;
        self.viewBack.hidden = YES;
        
        _deviceViewXPoint.constant = -225.0f;
        [_deviceView setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.3f animations:^{
            [_deviceView layoutIfNeeded];
        }];
    }
}

- (void)getDeviceList{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.reachability.isReachable) {
        
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
        ServiceHandler *serviceHandler = [ServiceHandler singletonServiceHandlerInstance];
        [serviceHandler getDeviceListWithSuccessBlock:^(id returnObject) {
            
            deviceList = [[NSArray alloc] initWithArray:(NSArray *)returnObject];
            
            // Get the last updated status of first device
            NSString *selectedDeviceId = [deviceList firstObject];
            [self getDataForSpecificDeviceID:selectedDeviceId];
            
            NSLog(@"Device List : %@",deviceList);
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

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [deviceList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"deviceCellID";
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor blackColor];
    
    if (selectedIndexpath == nil && indexPath.row == 0) {
        cell.lblDeviceID.textColor = [UIColor redColor];
    }else if (selectedIndexpath.row == indexPath.row){
        cell.lblDeviceID.textColor = [UIColor redColor];
    }else{
        cell.lblDeviceID.textColor = [UIColor whiteColor];
    }
    
    NSString *deviceId = [deviceList objectAtIndex:indexPath.row];
    cell.lblDeviceID.text = deviceId;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //get deviceId object from device list
    //NSString *deviceId = [deviceList objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //keep the selected Indexpath to show it on bold in device list
    selectedIndexpath = indexPath;
    
    //Get selected device Id
    NSString *selectedDeviceId = [deviceList objectAtIndex:indexPath.row];
    //NSLog(@"Selected DeviceId is : %@", selectedDeviceId);
    
    [self getDataForSpecificDeviceID:selectedDeviceId];
    
    [self hideDeviceView];
}

-(void)addPinOnTheMapview:(NSArray *)arrLocations{
    
    NSArray *latArray = [arrLocations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name == %@)",@"lastValidLatitude"]];
    
    NSArray *longArray = [arrLocations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name == %@)",@"lastValidLongitude"]];
    
    NSString *strLat = [[[latArray firstObject] valueForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strLong = [[[longArray firstObject] valueForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //set up zoom level
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .1f; //the zoom level in degrees
    zoom.longitudeDelta = .1f;//the zoom level in degrees
    
    
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude  =  [strLat doubleValue];
    pinCoordinate.longitude =  [strLong doubleValue];
    
    MKCoordinateRegion myRegion;
    myRegion.center = pinCoordinate;
    myRegion.span = zoom;
    
    [self.mapView setRegion:myRegion animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = pinCoordinate;
    
    NSString *selectedDeviceId = [deviceList objectAtIndex:selectedIndexpath.row];
    
    point.title = selectedDeviceId;
    point.subtitle = [NSString stringWithFormat:@"%@,%@",strLat,strLong];
    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:self.mapView.region animated:TRUE];
}

-(void)getDataForSpecificDeviceID:(NSString *)strDeviceID{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.reachability.isReachable) {
        
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
        ServiceHandler *serviceHandler = [ServiceHandler singletonServiceHandlerInstance];
        
        [serviceHandler getDeviceLastLatLongWithSuccessBlockWithDeviceID:strDeviceID andSuccess:^(id returnObject) {
            
            NSDictionary *TepRecord = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)returnObject];
            
            NSArray *arrFields = [[[TepRecord objectForKey:@"GTSResponse"] objectForKey:@"Record"] objectForKey:@"Field"];
            
            NSArray *filtered = [arrFields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name == %@ || name == %@)", @"lastValidLatitude",@"lastValidLongitude"]];

            [self addPinOnTheMapview:filtered];
            
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

- (IBAction)logoutClick:(id)sender {
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //Clear user details in db (NSUerDefaults).
    SetUserDefaultsForKey(ACCOUNT, @"");
    SetUserDefaultsForKey(USER, @"");
    SetUserDefaultsForKey(PASSWORD, @"");
    
    UIStoryboard *main = [self storyboard];
    LoginViewController *loginViewController = [main instantiateInitialViewController];
    [appDelegate.window setRootViewController:loginViewController];
}

- (IBAction)btnDashboardClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
