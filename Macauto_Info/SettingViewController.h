//
//  SettingViewController.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/19.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnImgLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnTextLogout;

- (IBAction)btnImageAction:(id)sender;
- (IBAction)btnTextAction:(id)sender;

@property NSString *user_id;
@end
