//
//  EventListCellTableViewCell.h
//  Schooltrac
//
//  Created by Vinod Jat on 2/23/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCellTableViewCell : UITableViewCell{
    
}

@property(weak)IBOutlet UILabel *lblDateTime;
@property(weak)IBOutlet UILabel *lblStatus;
@property(weak)IBOutlet UILabel *lblLatitude;
@property(weak)IBOutlet UILabel *lblspeedMHP;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
