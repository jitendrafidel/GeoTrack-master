//
//  EventListCellTableViewCell.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/23/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "EventListCellTableViewCell.h"

@implementation EventListCellTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSArray *arrNibs = [[NSBundle mainBundle]loadNibNamed:@"EventListCellTableViewCell" owner:self options:nil];
    self = [arrNibs firstObject];
    
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
