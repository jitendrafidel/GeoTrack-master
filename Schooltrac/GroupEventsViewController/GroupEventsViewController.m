//
//  GroupEventsViewController.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "GroupEventsViewController.h"
#import "Utilities.h"

@interface GroupEventsViewController ()

@end

@implementation GroupEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add header view
    self.navigationItem.titleView = [Utilities getHeaderImageView:self.navigationItem];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
