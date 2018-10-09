//
//  MapViewNavigationBar.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/22/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "MapViewNavigationBar.h"

@implementation MapViewNavigationBar

-(id)initNaviagtionBar{
    
    self = [super init];
    
    NSArray *arrNibs = [[NSBundle mainBundle]loadNibNamed:@"MapViewNavigationBar" owner:self options:nil];
    
    self = [arrNibs firstObject];
    
    return self;
}

@end
