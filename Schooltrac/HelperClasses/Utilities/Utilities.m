//
//  Utilities.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/19/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(UIImageView *)getHeaderImageView:(UINavigationItem *)navigationItem{
    
    UIImage *logo = [UIImage imageNamed:@"logo-header.png"];
    UIView *viewH = [[UIView alloc]initWithFrame:navigationItem.titleView.frame];
    viewH.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage: logo];
    imageView.frame = CGRectMake(20, 0, 15, 15);
    return [[UIImageView alloc] initWithImage:logo];
}

@end
