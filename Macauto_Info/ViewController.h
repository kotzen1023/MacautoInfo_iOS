//
//  ViewController.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSXMLParserDelegate, NSURLSessionDelegate> {
    
    IBOutlet UISearchBar *searchBar;

    
    __weak IBOutlet UIButton *btnMultiLines;
    __weak IBOutlet UIButton *btnTypeSelect;
    __weak IBOutlet UITableView *tableView;
    UILabel *activityLabel;
    UIActivityIndicatorView *activityIndicator;
    UIView *container;
    CGRect frame;
    
    
    UIScrollView *huiView;
    UIButton *btnBack;
    UILabel *lbl_title_header, *lbl_title_show;
    UILabel *lbl_content_header, *lbl_content_show;
    UILabel *lbl_time_header, *lbl_time_show;
    UILabel *lbl_doc_no_header, *lbl_doc_no_show;
    UILabel *lbl_part_no_header, *lbl_part_no_show;
    UILabel *lbl_model_no_header, *lbl_model_no_show;
    UILabel *lbl_machine_no_header, *lbl_machine_no_show;
    UILabel *lbl_plant_no_header, *lbl_plant_no_show;
    UILabel *lbl_announcer_header, *lbl_announcer_show;
}

@property NSMutableArray *notifyList;
@property NSMutableArray *filterNotifyList;
@property NSMutableArray *typeNotifyList;

@property NSMutableArray *updateList;

@property UIActivityIndicatorView *activityIndicator;

@property NSString *user_id;
@property NSString *uuid;
@property NSString *multi_lines;
@property int status_bar_height;
@property long unread_sp_count;

@property int current_select_type;
@property NSString *current_select_string;

- (IBAction)onTypeChange:(id)sender;
- (IBAction)onMultiLinesChange:(id)sender;


@end

