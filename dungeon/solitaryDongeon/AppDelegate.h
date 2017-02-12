//
//  AppDelegate.h
//  solitaryDongeon
//
//  Created by Devine Lu Linvega on 2015-02-27.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WatchConnectivity;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *guideURL;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *userDesc;

+(void) syncScore;
+(void)didUpdateScore;
+(void)setHighScore:(int)score shouldSync:(BOOL)shouldSync;
+(int)highScore;
+(void) uploadScore;

@end

