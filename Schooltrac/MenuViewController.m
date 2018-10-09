//
//  MenuViewController.m
//  Schooltrac
//
//  Created by Rohini Pagar on 2/17/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "MenuViewController.h"

#import "LoginViewController.h"
#import "MenuCell.h"

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblMenu;

@end

@implementation MenuViewController
{
    NSArray *menuOptions, *menuImages;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuOptions =[[NSArray alloc] initWithObjects:@"HOME",
                                                    @"NEWSLETTER",
                                                    @"NOTICEBOARD",
                                                    @"ATTENDANCE",
                                                    @"SYLLABUS",
                                                    @"CHILD PROGRESS",
                                                    @"ACTIVITY CENTER",
                                                    @"POLLS",
                                                    @"SETTINGS",
                                                    @"LOGOUT",
                  nil];
    
    menuImages=[[NSArray alloc] initWithObjects:@"side_menu_home_icon.png",
                                                @"side_menu_newsletter_icon.png",
                                                @"side_menu_notice_board_icon.png",
                                                @"side_menu_attendance_icon.png",
                                                @"side_menu_syllabus_icon.png",
                                                @"side_menu_child_progress_icon.png",
                                                @"side_menu_activity_icon.png",
                                                @"side_menu_polls_icon.png",
                                                @"side_menu_setting_icon.png",
                                                @"",
                nil];
    
    [_tblMenu reloadData];
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

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftMenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.lblTitle.font=[UIFont fontWithName:@"OpenSans" size:14.0f];
    cell.lblTitle.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(MenuCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //get deviceId object from device list
    cell.lblTitle.text=[menuOptions objectAtIndex:indexPath.row];
    cell.imgIcon.image=[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            NSLog(@"Home");
            [self performSegueWithIdentifier:@"Go-Home" sender:self];
            break;
        case 9:
            NSLog(@"Logout");
            [self doLogout];
            break;
        default:
            break;
    }
}

-(void)doLogout{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //Clear user details in db (NSUerDefaults).
    SetUserDefaultsForKey(ACCOUNT, @"");
    SetUserDefaultsForKey(USER, @"");
    SetUserDefaultsForKey(PASSWORD, @"");
    
    UIStoryboard *main = [self storyboard];
    LoginViewController *loginViewController = [main instantiateInitialViewController];
    [appDelegate.window setRootViewController:loginViewController];
    
}
@end
