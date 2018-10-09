//
//  DeviceListCell.h
//  Schooltrac
//
//  Created by Vinod Jat on 2/22/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListCell : UITableViewCell

@property(weak)IBOutlet UILabel *lblDeviceID;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
