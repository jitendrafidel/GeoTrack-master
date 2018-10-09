//
//  LoginViewController.m
//  Schooltrac
//
//  Created by Rohini Pagar on 2/17/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *txtAccount;
@property (nonatomic, weak) IBOutlet UITextField *txtUser;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)btnLoginClicked:(id)sender{
    if ([_txtAccount.text length] ==0 || [_txtUser.text length] ==0 || [_txtPassword.text length] ==0)
    {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:GeoTrack
                                                                            message:aTextFiledAlert
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
    else
    {
        [self doLogin];
    }
}

-(void)doLogin{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.reachability.isReachable) {
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
        ServiceHandler *serviceHandler = [ServiceHandler singletonServiceHandlerInstance];
        [serviceHandler signInUserWithAccount:_txtAccount.text userName:_txtUser.text andPassword:_txtPassword.text withSuccessBlock:^(id returnObject) {
            
            NSString *version = (NSString *)returnObject;
            NSLog(@"Success Login Version : %@", version);
            
            //Store user details in db (NSUerDefaults) for other webservice calls.
            SetUserDefaultsForKey(ACCOUNT, _txtAccount.text);
            SetUserDefaultsForKey(USER, _txtUser.text);
            SetUserDefaultsForKey(PASSWORD, _txtPassword.text);
            
            //Perform UI operations on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [GMDCircleLoader hideFromView:self.view animated:YES];
                [self performSegueWithIdentifier:@"Go-App" sender:self];
            });
            
        } andErrorBlock:^(NSError *error) {
            
            NSLog(@"error Message: %@",error.userInfo[@"Message"]);
            
            //Perform UI operations on main thread
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
        //  DisplayAlert(NETWORL_ALERT);
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

@end
