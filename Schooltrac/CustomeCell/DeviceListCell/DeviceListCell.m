//
//  DeviceListCell.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/22/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSArray *arrNibs = [[NSBundle mainBundle]loadNibNamed:@"DeviceListCell" owner:self options:nil];
    
    @try {
        self = [arrNibs firstObject];
    }
    @catch (NSException *exception) {
        // Excepion ocure 
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
