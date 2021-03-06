//
//  Menu.h
//  solitaryDongeon
//
//  Created by Devine Lu Linvega on 2015-03-12.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

#import "ViewController.h"

@interface Menu : ViewController

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *castleView;
@property (weak, nonatomic) IBOutlet UILabel *thanksLabel;
@property (weak, nonatomic) IBOutlet UIButton *thanksButton;
@property (weak, nonatomic) IBOutlet UIButton *rankButton;
@property (weak, nonatomic) IBOutlet UIButton *infoSettingButton;

@property (weak, nonatomic) IBOutlet UIButton *packDesignButton;
@property (weak, nonatomic) IBOutlet UILabel *packDesignLabel;

@property (weak, nonatomic) IBOutlet UIButton *tutorialToggleButton;
@property (weak, nonatomic) IBOutlet UILabel *tutorialToggleLabel;

@end
