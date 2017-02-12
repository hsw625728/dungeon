//
//  AppDelegate.m
//  solitaryDongeon
//
//  Created by Devine Lu Linvega on 2015-02-27.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    if([AppDelegate canSync] == true)
    {
        [WCSession defaultSession].delegate = self;
        [[WCSession defaultSession] activateSession];
        [AppDelegate syncScore];
    }
    
    _guideURL = [[NSString alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _nickName = [[NSString alloc] init];
    _userDesc = [[NSString alloc] init];
    _nickName = [ user objectForKey:@"nickName"];
    _userDesc = [ user objectForKey:@"userDesc"];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(BOOL)canSync
{
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
    {
        return false;
    }

    if([WCSession isSupported] == false)
    {
        return false;
    }

    return true;
}

+(BOOL)shouldSync
{
    if([AppDelegate canSync] == false)
    {
        return false;
    }
    
    WCSession * session = [WCSession defaultSession];
    if(session.paired == true && session.watchAppInstalled == true)
    {
        return  true;
    }

    return false;
}

+(void) syncScore
{
    if([AppDelegate shouldSync] == false)
    {
        return;
    }
    int currentScore = [AppDelegate highScore];
    int contextScore = [AppDelegate scoreFromApplicationContext:[[WCSession defaultSession] receivedApplicationContext]];
    if(currentScore < contextScore)
    {
        [AppDelegate setHighScore:contextScore shouldSync:true];
        return;
    }

    [[WCSession defaultSession] updateApplicationContext:@{@"score" : @(currentScore)} error:nil];
}

+(void)didUpdateScore
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"highScoreUpdated" object:nil];
}

+(void)setHighScore:(int)score shouldSync:(BOOL)shouldSync
{
    int currentScore = [AppDelegate highScore];
    if (score > currentScore)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(score) forKey:@"score"];
        [defaults synchronize];
        [AppDelegate didUpdateScore];
        if(shouldSync == true)
        {
            [AppDelegate syncScore];
        }
    }
}

+(int)highScore
{
    int currentScore = 0;
    NSNumber * scoreValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];
    if(scoreValue != nil)
    {
        currentScore = [scoreValue intValue];
    }

    return currentScore;
}

+(int)scoreFromApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    NSNumber * scoreValue = [applicationContext objectForKey:@"score"];
    if(scoreValue != nil)
    {
        return [scoreValue intValue];
    }
    return 0;
}

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    [AppDelegate setHighScore:[AppDelegate scoreFromApplicationContext:applicationContext] shouldSync:true];
}
+(void) uploadScore
{
    
    //记录上传服务器
    //NSString *post=[NSString stringWithFormat:@"http://mengyoutu.cn/dungeon/dungeonrecord.php?deviceID=%@&nickName=%@&userDesc=%@&record=%@", \
    @"deviceID4",@"PangXie",@"This is my name4.", @"1234567890"];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *scoreStr = [NSString stringWithFormat:@"%i", [AppDelegate highScore]];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    NSString *post = [NSString stringWithFormat:@"deviceID=%@&nickName=%@&userDesc=%@&record=%@",idfv,appDelegate.nickName,appDelegate.userDesc, scoreStr];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://mengyoutu.cn/dungeon/dungeonrecord.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"& API  | %@", theReply);
}
@end
