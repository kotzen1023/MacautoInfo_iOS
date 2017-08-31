//
//  ThemeColor.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeColor : NSObject
{
    UIColor *default_color_button;
    UIColor *default_color_background;
}

-(UIColor *) getDefault_color_button;
-(UIColor *) getDefault_color_background;

@end
