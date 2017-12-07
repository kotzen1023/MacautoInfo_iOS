//
//  WhoGoesOutViewController.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/11/17.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoGoesOutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSXMLParserDelegate, NSURLSessionDelegate> {
    
    __weak IBOutlet UITableView *tableView;
    
    //__weak IBOutlet UIButton *btnRangeSelect;
    UILabel *activityLabel;
    UIActivityIndicatorView *activityIndicator;
    UIView *container;
    CGRect frame;
    
    UIScrollView *huiView;
    UIButton *btnBack;
    UILabel *lbl_emp_no_header, *lbl_emp_no_show;
    UILabel *lbl_emp_name_header, *lbl_emp_name_show;
    UILabel *lbl_start_date_header, *lbl_start_date_show;
    UILabel *lbl_end_date_header, *lbl_end_date_show;
    UILabel *lbl_back_date_header, *lbl_back_date_show;
    UILabel *lbl_reason_header, *lbl_reason_show;
    UILabel *lbl_location_header, *lbl_location_show;
    UILabel *lbl_car_type_header, *lbl_car_type_show;
    UILabel *lbl_car_no_header, *lbl_car_no_show;
    UILabel *lbl_car_or_moto_header, *lbl_car_or_moto_show;
    UILabel *lbl_app_sent_datetime_header, *lbl_app_sent_datetime_show;
    UILabel *lbl_app_sent_status_header, *lbl_app_sent_status_show;
}

@property NSMutableArray *originalList;
@property NSMutableArray *filterList;
@property NSMutableArray *typeList;

@property NSMutableArray *updateList;

@property UIActivityIndicatorView *activityIndicator;

@property int status_bar_height;

@property int current_select_type;
@property NSString *current_select_string;

- (IBAction)btnBack:(id)sender;
//- (IBAction)btnRangeChange:(id)sender;


@end
