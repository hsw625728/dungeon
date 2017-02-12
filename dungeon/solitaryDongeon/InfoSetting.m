//
//  InfoSetting.m
//  Donsol
//
//  Created by HANSHAOWEN on 17/2/12.
//  Copyright © 2017年 Devine Lu Linvega. All rights reserved.
//

#import "InfoSetting.h"
#import "ViewController.h"
#import "AppDelegate.h"

@implementation InfoSetting

-(void)viewDidLoad
{
    _closeButton.backgroundColor = [UIColor blackColor];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize: 14];
    _closeButton.layer.cornerRadius = 4;
    _closeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _closeButton.layer.borderWidth = 1;
    _closeButton.titleLabel.text = @"关闭";
    
    
    _returnButton.backgroundColor = [UIColor blackColor];
    _returnButton.titleLabel.font = [UIFont systemFontOfSize: 14];
    _returnButton.layer.cornerRadius = 4;
    _returnButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _returnButton.layer.borderWidth = 1;
    _returnButton.titleLabel.text = @"确定";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _nameField.text = appDelegate.nickName;
    _descField.text = appDelegate.userDesc;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)closeInfoSetting:(id)sender {
    [self performSegueWithIdentifier:@"closeInfoSetting" sender:self];
}
- (IBAction)returnInfoSettign:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.nickName = _nameField.text;
    appDelegate.userDesc = _descField.text;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:appDelegate.nickName forKey:@"nickName"];
    [user setObject:appDelegate.userDesc forKey:@"userDesc"];
    
    [self performSegueWithIdentifier:@"closeInfoSetting" sender:self];
    [AppDelegate uploadScore];
}



@end
