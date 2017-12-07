//
//  AppDelegate.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Firebase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, UISearchBarDelegate, FIRMessagingDelegate> {
    Boolean is_actived;
}

@property (strong, nonatomic) UIWindow *window;


@end

