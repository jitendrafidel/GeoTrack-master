//
//  EventViewController.h
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeoTrackEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblViewEvents;
}

@property(strong)NSString *strDevideID;
@property(strong)NSString *strFromDate;
@property(strong)NSString *strToDate;

@property(strong) NSArray *arrAllEvents;

@end
