//
//  DevicePickeViewViewController.m
//  Schooltrac
//
//  Created by Vinod Jat on 2/23/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

#import "DevicePickeViewViewController.h"

@interface DevicePickeViewViewController (){
    NSString *strSelectedItem;
}

@end

@implementation DevicePickeViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
//    self.pickeView.layer.cornerRadius = 10.0;
//    self.pickeView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.pickeView.layer.borderWidth = 1.0;
    
    self.pickerBackgroundView.layer.cornerRadius = 10.0;
    self.pickerBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pickerBackgroundView.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UIPickerView Datasource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_arrDevice count];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(strSelectedItem == nil && row == 0){
        strSelectedItem = [_arrDevice firstObject];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[_arrDevice objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(strSelectedItem == nil && row == 0){
        strSelectedItem = [_arrDevice firstObject];
    }
    
    return [_arrDevice objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    strSelectedItem = [_arrDevice objectAtIndex:row];
    //_lblSelectedDevice.text = strSelectedOption;
}

-(IBAction)btnQuitPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnSelectPressed:(id)sender{
    if([self.delegate respondsToSelector:@selector(deviceHasbeenSelected:)]){
        [self.delegate deviceHasbeenSelected:strSelectedItem];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
