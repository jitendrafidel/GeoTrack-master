//
//  DevicePickeViewViewController.h
//  Schooltrac
//
//  Created by Vinod Jat on 2/23/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>
    -(void)deviceHasbeenSelected:(NSString *)strSelected;
@optional
@end

@interface DevicePickeViewViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
}

@property(weak)IBOutlet UIPickerView *pickeView;
@property (nonatomic, weak) id<PickerViewDelegate> delegate;
@property(strong)NSArray *arrDevice;
@property (weak, nonatomic) IBOutlet UIView *pickerBackgroundView;

-(IBAction)btnQuitPressed:(id)sender;
-(IBAction)btnSelectPressed:(id)sender;

@end
