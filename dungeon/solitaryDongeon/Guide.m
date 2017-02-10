//
//  Menu.m
//  solitaryDongeon
//
//  Created by Devine Lu Linvega on 2015-03-12.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

#import "Guide.h"
#import "ViewController.h"
#import "User.h"
#import "AppDelegate.h"

@implementation Guide

-(void)viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"guide" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    _closeButton.backgroundColor = [UIColor blackColor];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize: 14];
    _closeButton.layer.cornerRadius = 4;
    _closeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _closeButton.layer.borderWidth = 1;
    _closeButton.titleLabel.text = @"关闭";
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)closeGuide:(id)sender {
    [self performSegueWithIdentifier:@"closeGuide" sender:self];
}



@end
