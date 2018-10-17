//
//  ViewController.m
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import "ViewController.h"
#import "NotifyItem.h"
#import "ThemeColor.h"


@interface ViewController ()

@property NSString *soapMessage;
@property NSString *currentElement;
@property NSMutableData *webResponseData;

@property NSString *elementStart;
@property NSString *elementValue;
@property NSString *elementEnd;

@property BOOL doc;
@property BOOL isNotifyList;
@property BOOL isRoomName;
@property BOOL isMsgTitle;

@property NotifyItem *item;
@property BOOL isFiltered;
@property BOOL is_item_press;

@property BOOL update;
@property ThemeColor *themeColor;
@property NSDate *today;
@property NSDateFormatter *dateFormat;


@end

@implementation ViewController
@synthesize activityIndicator;
@synthesize soapMessage, webResponseData, currentElement;
@synthesize user_id, uuid, multi_lines, status_bar_height, unread_sp_count;
@synthesize current_select_type;
@synthesize current_select_string;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    user_id = [defaults objectForKey:@"Account"];
    uuid = [defaults objectForKey:@"DeviceID"];
    multi_lines = [defaults objectForKey:@"MultiLines"];
    
    NSLog(@"multi_lines = %@", multi_lines);
    
    if ([multi_lines isEqualToString:@"true"]) {
        [btnMultiLines setImage:[UIImage imageNamed:@"less"] forState:normal];
    } else {
        [btnMultiLines setImage:[UIImage imageNamed:@"more"] forState:normal];
    }
    
    //set button text
    [btnTypeSelect setTitle:@"全部" forState:UIControlStateNormal];
    current_select_type = 0;
    current_select_string = @"全部";
    
    //init orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    //init list
    //_notifyList = [[NSMutableArray alloc] init];
    [self initSearchBar];
    
    [self initLoading];
    [self initItemShow];
    
    //if ([self initObserver] != nil) {
    //    NSLog(@"initObserver success!");
    //}
    
    
}


- (void) viewDidAppear:(BOOL)animated {
    
    NSLog(@"viewDidAppear");
    
    _today = [NSDate date];
    _dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    [super viewDidAppear:animated];
    
    [self showIndicator:true];
    
    [self sendHttpPost];
    
    //set filter = false
    _isFiltered = false;
    
    if ([self initObserver] != nil) {
        NSLog(@"initObserver success!");
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self deallocObserver];
    
    //remove orientation observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self showNotifyDetail:false];
    
    [_notifyList removeAllObjects];
    [_filterNotifyList removeAllObjects];
    [_typeNotifyList removeAllObjects];
    
    _notifyList = nil;
    _filterNotifyList = nil;
    _typeNotifyList = nil;
    
    _dateFormat = nil;
    
    [tableView reloadData];
    
    _update = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) orientationChanged:(NSNotification *)note{
    UIDevice *device = [UIDevice currentDevice];
    
    status_bar_height = self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height;
    
    int width = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    
    CGRect btnBackFrame = btnBack.frame;
    
    
    btnBackFrame.origin.x = width - 60;
    btnBackFrame.origin.y = 0;
    
    btnBack.frame = btnBackFrame;
    
    
    
    NSLog(@"status bar = %d, width = %d, height = %d", status_bar_height, width, height);
    huiView.contentSize = CGSizeMake(0, lbl_announcer_header.frame.origin.y + lbl_announcer_header.frame.size.height+50);
    
    CGSize background = CGSizeMake(width, height);
    CGRect backRect = CGRectMake(0, 0, width, height);
    
    if (_is_item_press) {
        NSLog(@"_is_item_press");
        huiView.frame = CGRectMake(0, status_bar_height, width, height);
    } else {
        huiView.frame = CGRectMake(width, status_bar_height, width, height);
    }
    //reset frame
    lbl_title_show.frame = CGRectMake(105, 30, self.view.bounds.size.width-105, 63);
    lbl_content_show.frame = CGRectMake(105, 98, self.view.bounds.size.width-105, 126);
    lbl_time_show.frame = CGRectMake(105, 229, self.view.bounds.size.width-105, 21);
    lbl_doc_no_show.frame = CGRectMake(105, 255, self.view.bounds.size.width-105, 42);
    lbl_part_no_show.frame = CGRectMake(105, 302, self.view.bounds.size.width-105, 42);
    lbl_model_no_show.frame = CGRectMake(105, 349, self.view.bounds.size.width-105, 42);
    lbl_machine_no_show.frame = CGRectMake(105, 396, self.view.bounds.size.width-105, 42);
    lbl_plant_no_show.frame = CGRectMake(105, 443, self.view.bounds.size.width-105, 42);
    lbl_announcer_show.frame = CGRectMake(105, 490, self.view.bounds.size.width-105, 42);
    
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"UIDeviceOrientationPortrait");
            
            /*if (_is_item_press) {
                NSLog(@"_is_item_press");
                huiView.frame = CGRectMake(0, status_bar_height, width, height);
            } else {
                huiView.frame = CGRectMake(width, status_bar_height, width, height);
            }*/
            
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            
            /*if (_is_item_press) {
                NSLog(@"_is_item_press");
                huiView.frame = CGRectMake(0, status_bar_height, width, height);
            } else {
                huiView.frame = CGRectMake(width, status_bar_height, width, height);
            }*/
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"UIDeviceOrientationLandscapeLeft");
            
            if (_is_item_press) {
                NSLog(@"_is_item_press");
                //huiView.frame = CGRectMake(0, status_bar_height, width, height);
                
                /*
                 huiView.frame = CGRectMake((self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
                 self.view.bounds.size.width,
                 self.view.bounds.size.height);                 */
                
                if (huiView.contentSize.height > height) {
                    background = CGSizeMake(width, huiView.contentSize.height);
                    backRect = CGRectMake(0, status_bar_height, width, huiView.contentSize.height);
                }
                
                //[lbl_title_show initWithFrame:CGRectMake(105, 30, self.view.bounds.size.width-105, 63)];
                
                
                
                //lbl_title_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, self.view.bounds.size.width-105, 63)];
                
            } /*else {
                huiView.frame = CGRectMake(width, status_bar_height, width, height);
            }*/
            
            
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"UIDeviceOrientationLandscapeRight");
            
            /*if (_is_item_press) {
                NSLog(@"_is_item_press");
                huiView.frame = CGRectMake(0, status_bar_height, width, height);
            } else {
                huiView.frame = CGRectMake(width, status_bar_height, width, height);
            }*/
            
            if (_is_item_press) {
                if (huiView.contentSize.height > height) {
                    background = CGSizeMake(width, huiView.contentSize.height);
                    backRect = CGRectMake(0, status_bar_height, width, huiView.contentSize.height);
                }
            }

            break;
            
        default:
            NSLog(@"default");
            /*if (_is_item_press) {
                NSLog(@"_is_item_press");
                huiView.frame = CGRectMake(0, status_bar_height, width, height);
            } else {
                huiView.frame = CGRectMake(width, status_bar_height, width, height);
            }*/
            break;
    };
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    long rowCount;
    if (_isFiltered) {
        rowCount = [_filterNotifyList count];
    } else {
        if (current_select_type == 0) {
            rowCount = [_notifyList count];
        } else {
            rowCount = [_typeNotifyList count];
        }
    }
    return rowCount;
    //return [mainArray count];
}

- (UITableViewCell * ) tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"notificationCell";
    
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.backgroundColor = [UIColor colorWithRed:(28/255.0) green:(28/255.0) blue:(28/255.0) alpha:1.0];
    
    
    //NotifyItem *item = [_notifyList objectAtIndex:indexPath.row];
    NotifyItem *item;
    
    if (_isFiltered) {
        item = [_filterNotifyList objectAtIndex:indexPath.row];
    } else {
        if (current_select_type == 0) {
            item = [_notifyList objectAtIndex:indexPath.row];
        } else {
            item = [_typeNotifyList objectAtIndex:indexPath.row];
        }
    }
    
    UILabel *subject = (UILabel *)[cell viewWithTag:100];
    
    if ([multi_lines isEqualToString:@"true"]) {
        [subject setLineBreakMode:NSLineBreakByWordWrapping];
        [subject setNumberOfLines:0];
    } else {
        [subject setLineBreakMode:NSLineBreakByTruncatingTail];
        [subject setNumberOfLines:1];
    }
    
    UILabel *day = (UILabel *)[cell viewWithTag:103];
    //subject.textColor = [UIColor colorWithRed:(120/255.0) green:(120/255.0) blue:(120/255.0) alpha:1.0];
    //subject.text = item.title;
    NSLog(@"%@-%@-%@", item.msg_code, item.msg_title, item.msg_content);
    
    if (item.msg_title == nil || [item.msg_title isEqualToString:@""]) {
        subject.text = [NSString stringWithFormat:@"%@", item.msg_code];
    } else {
        subject.text = [NSString stringWithFormat:@"%@", item.msg_title];
    }
    
    UILabel *time = (UILabel *) [cell viewWithTag:101];
    //time.textColor = [UIColor colorWithRed:(120/255.0) green:(120/255.0) blue:(120/255.0) alpha:1.0];
    NSString *todayDateString = [_dateFormat stringFromDate:_today];
    
    NSArray *end_split = [item.announce_date componentsSeparatedByString:@"T"];
    NSArray *time_split = [end_split[1] componentsSeparatedByString:@"+"];
    
    NSString *new_time = [time_split[0] substringToIndex:[time_split[0] length] - 3];
    
    if ([end_split[0] isEqualToString:todayDateString]) {
        day.text = NSLocalizedString(@"DATE_TODAY", nil);
    } else {
        NSString *year_string = [end_split[0] substringToIndex:[end_split[0] length] - 6];
        NSString *year_today = [todayDateString substringToIndex:[todayDateString length] - 6];
        if ([year_today isEqualToString:year_string]) { //same year
            day.text = [end_split[0] substringFromIndex:5];
        } else {
            day.text = end_split[0];
        }
        
    }
    
    time.text = new_time;
    
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:102];
    
    
    if ([item.sp isEqualToString:@"Y"]) {
        //NSLog(@"sp = Y");
        //UIImage *image = [UIImage imageNamed: @"star_green.png"];        [imageView setImage:image];
        //[cell.imageView setImage:[UIImage imageNamed:@"star_green.png"]];
        imageView.image = [UIImage imageNamed:@"star_green"];
        
    } else {
        //NSLog(@"sp = N");
        imageView.image = [UIImage imageNamed:@"new"];
        //[cell.imageView setImage:[UIImage imageNamed:@"new.png"]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    long rowCount = indexPath.row;
    //Products *pInfo = [self.productInfo objectAtIndex:rowCount];
    //[ConfirmButton setTitle:@"修改" forState:UIControlStateNormal];
    //NotifyItem *item = [_notifyList objectAtIndex:rowCount];
    NotifyItem *item;
    
    if (_isFiltered) {
        item = [_filterNotifyList objectAtIndex:rowCount];
        
        for (int i=0; i<_filterNotifyList.count; i++) {
            NotifyItem *temp = [_filterNotifyList objectAtIndex:i];
            if ([item.msg_id isEqualToString: temp.msg_id] &&
                [item.msg_code isEqualToString: temp.msg_code] &&
                [item.msg_title isEqualToString: temp.msg_title] &&
                [item.msg_content isEqualToString: temp.msg_content] &&
                [temp.sp isEqualToString:@"N"]) {
                [temp setReadSp:@"Y"];
                [self sendHttpPost2:temp.msg_id];
            }
            
            //set original list read
            for (int i=0; i<_notifyList.count; i++) {
                NotifyItem *temp = [_notifyList objectAtIndex:i];
                if ([item.msg_id isEqualToString: temp.msg_id] &&
                    [item.msg_code isEqualToString: temp.msg_code] &&
                    [item.msg_title isEqualToString: temp.msg_title] &&
                    [item.msg_content isEqualToString: temp.msg_content] &&
                    [temp.sp isEqualToString:@"N"]) {
                    [temp setReadSp:@"Y"];
                }
            }
        }
    } else {
        if (current_select_type == 0) {
            item = [_notifyList objectAtIndex:rowCount];
            
            for (int i=0; i<_notifyList.count; i++) {
                NotifyItem *temp = [_notifyList objectAtIndex:i];
                if ([item.msg_id isEqualToString: temp.msg_id] &&
                    [item.msg_code isEqualToString: temp.msg_code] &&
                    [item.msg_title isEqualToString: temp.msg_title] &&
                    [item.msg_content isEqualToString: temp.msg_content] &&
                    [temp.sp isEqualToString:@"N"]) {
                    [temp setReadSp:@"Y"];
                    [self sendHttpPost2:temp.msg_id];
                }
            }
        } else {
            item = [_typeNotifyList objectAtIndex:rowCount];
            
            for (int i=0; i<_typeNotifyList.count; i++) {
                NotifyItem *temp = [_typeNotifyList objectAtIndex:i];
                if ([item.msg_id isEqualToString: temp.msg_id] &&
                    [item.msg_code isEqualToString: temp.msg_code] &&
                    [item.msg_title isEqualToString: temp.msg_title] &&
                    [item.msg_content isEqualToString: temp.msg_content] &&
                    [temp.sp isEqualToString:@"N"]) {
                    [temp setReadSp:@"Y"];
                    [self sendHttpPost2:temp.msg_id];
                }
            }
            
            //set original list read
            for (int i=0; i<_notifyList.count; i++) {
                NotifyItem *temp = [_notifyList objectAtIndex:i];
                if ([item.msg_id isEqualToString: temp.msg_id] &&
                    [item.msg_code isEqualToString: temp.msg_code] &&
                    [item.msg_title isEqualToString: temp.msg_title] &&
                    [item.msg_content isEqualToString: temp.msg_content] &&
                    [temp.sp isEqualToString:@"N"]) {
                    [temp setReadSp:@"Y"];
                }
            }
        }
    }
    
    
    
    
    
    
    
    [UIView animateWithDuration:0.7 animations:^{
        //productName Label
        
        [self showNotifyDetail:true];
        
        
        
        self->huiView.contentSize = CGSizeMake(0, self->lbl_title_header.frame.origin.y + self->lbl_title_header.frame.size.height+50);
        
        self->lbl_title_show.frame = CGRectMake(105, 30, self.view.bounds.size.width-105, 63);
        
        if (item.msg_title == nil || [item.msg_title isEqualToString:@""]) {
            [self->lbl_title_show setText: [NSString stringWithFormat:@"%@", item.msg_code]];
        } else {
            [self->lbl_title_show setText: [NSString stringWithFormat:@"%@ %@", item.msg_code, item.msg_title]];
        }
        
    
        
        [self->lbl_content_show setText:item.msg_content];
        
        
        // convert to date
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // ignore +11 and use timezone name instead of seconds from gmt
        [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+08:00'"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Taiwan/Taipei"]];
        NSDate *dte = [dateFormat dateFromString:item.announce_date];
        
        // back to string
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        //[dateFormat2 setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
        [dateFormat2 setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [dateFormat2 setTimeZone:timeZone];
        NSString *dateString = [dateFormat2 stringFromDate:dte];
        NSLog(@"DateString: %@", dateString);
        
        
        [self->lbl_time_show setText: dateString];
        
        if (item.internal_doc_no != nil || ![item.internal_doc_no compare:@""]) {
            self->lbl_doc_no_header.hidden = true;
            self->lbl_doc_no_show.hidden = true;
        } else {
            self->lbl_doc_no_header.hidden = false;
            self->lbl_doc_no_show.hidden = false;
        }
        
        if (item.internal_part_no != nil || ![item.internal_part_no compare:@""]) {
            self->lbl_part_no_header.hidden = true;
            self->lbl_part_no_show.hidden = true;
        } else {
            self->lbl_part_no_header.hidden = false;
            self->lbl_part_no_show.hidden = false;
        }
        
        if (item.internal_model_no != nil || ![item.internal_model_no compare:@""]) {
            self->lbl_model_no_header.hidden = true;
            self->lbl_model_no_show.hidden = true;
        } else {
            self->lbl_model_no_header.hidden = false;
            self->lbl_model_no_show.hidden = false;
        }
        
        if (item.internal_machine_no != nil || ![item.internal_machine_no compare:@""]) {
            self->lbl_machine_no_header.hidden = true;
            self->lbl_machine_no_show.hidden = true;
        } else {
            self->lbl_machine_no_header.hidden = false;
            self->lbl_machine_no_show.hidden = false;
        }
        
        if (item.internal_plant_no != nil || ![item.internal_plant_no compare:@""]) {
            self->lbl_plant_no_header.hidden = true;
            self->lbl_plant_no_show.hidden = true;
        } else {
            self->lbl_plant_no_header.hidden = false;
            self->lbl_plant_no_show.hidden = false;
        }
        
        if (item.announcer != nil || ![item.announcer compare:@""]) {
            self->lbl_announcer_header.hidden = true;
            self->lbl_announcer_show.hidden = true;
        } else {
            self->lbl_announcer_header.hidden = false;
            self->lbl_announcer_show.hidden = false;
        }
        
        //[lbl_time_show setText: item.announce_date];
        
        
        self->huiView.contentSize = CGSizeMake(0, self->status_bar_height+self->lbl_announcer_header.frame.origin.y + self->lbl_announcer_header.frame.size.height+50);
        
    }];
    
    _is_item_press = true;
}

-(void) initSearchBar {
    //[self.view setBackgroundColor:[UIColor colorWithRed:(28/255.0) green:(28/255.0) blue:(28/255.0) alpha:1.0]];
    
    
    //init theme color
    _themeColor = [[ThemeColor alloc] init];
    //setup button localized
    //[btnSetup setTitle:NSLocalizedString(@"SETUP_SEARCH", nil) forState:UIControlStateNormal];
    
    //search bar
    searchBar.barTintColor = [UIColor colorWithRed:(121/255.0) green:(27/255.0) blue:(87/255.0) alpha:1.0];
    //set search bar text white
    for (UIView *subView in searchBar.subviews) {
        for (UIView *secondLevelSubview in subView.subviews) {
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                searchBarTextField.textColor = [UIColor blackColor];
            }
        }
    }
    
    
    _notifyList = [[NSMutableArray alloc] init];
    _filterNotifyList = [[NSMutableArray alloc] init];
    _typeNotifyList = [[NSMutableArray alloc] init];
    searchBar.delegate = self;
}

-(void) showIndicator:(BOOL)show {
    
    if (show) {
        container.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [activityIndicator startAnimating];
    } else {
        [activityIndicator stopAnimating];
        container.center = CGPointMake(-(self.view.frame.size.width), self.view.frame.size.height/2);
    }
}

-(void) showNotifyDetail:(BOOL)show {
    if (show) {
        huiView.frame = CGRectMake(0, self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    } else {
        huiView.frame = CGRectMake((self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,self.view.bounds.size.width,self.view.bounds.size.height);
    }
}

-(void) initLoading {
    //[tableView setSeparatorColor:[UIColor colorWithRed:(50/255.0) green:(50/255.0) blue:(50/255.0) alpha:1.0]];
    //[tableView setBackgroundColor:[UIColor colorWithRed:(28/255.0) green:(28/255.0) blue:(28/255.0) alpha:1.0]];
    
    container = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 110, 30)];
    activityLabel = [[UILabel alloc] init];
    //activityLabel.text = NSLocalizedString(@"DATA_LOADING", nil);
    activityLabel.text = NSLocalizedString(@"DATA_LOADING", nil);
    activityLabel.textColor = [UIColor brownColor];
    activityLabel.font = [UIFont boldSystemFontOfSize:17];
    [container addSubview:activityLabel];
    activityLabel.frame = CGRectMake(0, 3, 70, 25);
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [container addSubview:activityIndicator];
    activityIndicator.frame = CGRectMake(80, 0, 30, 30);
    activityIndicator.hidesWhenStopped = YES;
    
    [self.view addSubview:container];
    container.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    //self.view.backgroundColor = [UIColor whiteColor];
}

-(void) initItemShow {
    huiView = [[UIScrollView alloc] initWithFrame:CGRectMake(
                                                             (self.view.bounds.size.height), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
                                                             self.view.bounds.size.width,
                                                             self.view.bounds.size.height)];
    huiView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    huiView.alpha=1.0;
    //huiView.layer.cornerRadius = 10;
    [self.view addSubview: huiView];
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, 0, 60, 30)];
    [btnBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[btnBack setTitle:NSLocalizedString(@"BACK_TO_PAGE", nil) forState:UIControlStateNormal];
    [btnBack setTitle:NSLocalizedString(@"COMMON_BACK", nil) forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backPersonalMeeting:) forControlEvents:(UIControlEventTouchUpInside)];
    [huiView addSubview:btnBack];
    
    //ID
    lbl_title_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 80, 63)];
    [lbl_title_header setText: NSLocalizedString(@"MSG_TITLE", nil)];
    [huiView addSubview:lbl_title_header];
    
    lbl_title_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, self.view.bounds.size.width-105, 63)];
    lbl_title_show.numberOfLines = 0;
    [huiView addSubview:lbl_title_show];
    
    //content
    lbl_content_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 98, 80, 126)];
    [lbl_content_header setText:NSLocalizedString(@"MSG_CONTENT", nil)];
    [huiView addSubview:lbl_content_header];
    
    lbl_content_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 98, self.view.bounds.size.width-105, 126)];
    lbl_content_show.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_content_show.numberOfLines = 0;
    [huiView addSubview:lbl_content_show];
    
    //Start time (h: 30+21+5
    lbl_time_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 229, 80, 21)];
    //[lbl_time_header setTextColor:[UIColor whiteColor]];
    //[lbl_time_header setText: NSLocalizedString(@"MEETING_SHOW_DETAIL_START_TIME", nil)];
    [lbl_time_header setText:NSLocalizedString(@"MSG_TIME", nil)];
    [huiView addSubview:lbl_time_header];
    
    lbl_time_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 229, self.view.bounds.size.width-105, 21)];

    [huiView addSubview: lbl_time_show];
    //doc no
    lbl_doc_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 255, 80, 42)];
    [lbl_doc_no_header setText:NSLocalizedString(@"MSG_DOC_NO", nil)];
    [huiView addSubview:lbl_doc_no_header];
    
    lbl_doc_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 255, self.view.bounds.size.width-105, 42)];
    lbl_doc_no_show.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_doc_no_show.numberOfLines = 0;
    [huiView addSubview:lbl_doc_no_show];
    //part no
    lbl_part_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 302, 80, 42)];
    [lbl_part_no_header setText:NSLocalizedString(@"MSG_PART_NO", nil)];
    [huiView addSubview:lbl_part_no_header];
    
    lbl_part_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 302, self.view.bounds.size.width-105, 42)];
    lbl_part_no_show.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_part_no_show.numberOfLines = 0;
    [huiView addSubview:lbl_part_no_show];
    //model no
    lbl_model_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 349, 80, 42)];
    [lbl_model_no_header setText:NSLocalizedString(@"MSG_MODEL_NO", nil)];
    [huiView addSubview:lbl_model_no_header];
    
    lbl_model_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 349, self.view.bounds.size.width-105, 42)];
    [huiView addSubview:lbl_model_no_show];
    //machine no
    lbl_machine_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 396, 80, 42)];
    [lbl_machine_no_header setText:NSLocalizedString(@"MSG_MACHINE_NO", nil)];
    [huiView addSubview:lbl_machine_no_header];
    
    lbl_machine_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 396, self.view.bounds.size.width-105, 42)];
    [huiView addSubview:lbl_machine_no_show];
    //plant no
    lbl_plant_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 443, 80, 42)];
    [lbl_plant_no_header setText:NSLocalizedString(@"MSG_PLANT_NO", nil)];
    [huiView addSubview:lbl_plant_no_header];
    
    lbl_plant_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 443, self.view.bounds.size.width-105, 42)];
    [huiView addSubview:lbl_plant_no_show];
    //announcer
    lbl_announcer_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 490, 80, 42)];
    [lbl_announcer_header setText:NSLocalizedString(@"ANNOUNCER", nil)];
    [huiView addSubview:lbl_announcer_header];
    
    lbl_announcer_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 490, self.view.bounds.size.width-105, 42)];
    [huiView addSubview:lbl_announcer_show];
    
}

- (void) backPersonalMeeting:(id)sender
{
    [UIView animateWithDuration:0.7 animations:^{
        self->huiView.frame = CGRectMake((self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height);
    }];
    
    _is_item_press = false;
    [tableView reloadData];
}


/*
 #progma mark - search bar implementation
 */

- (void) searchTableList {
    
    [_filterNotifyList removeAllObjects];
    _filterNotifyList = nil;
    
    _filterNotifyList = [[NSMutableArray alloc] init];
    
    NSString *searchString = searchBar.text;
    
    NSLog(@"=============>searchTableList, searchString = %@", searchString);
    
    if (current_select_type == 0) {
    
        for (NotifyItem *tempItem in _notifyList) {
            NSLog(@"temp = %@", tempItem.msg_title);
            //NSComparisonResult result = [tempItem.result compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            if ([tempItem.msg_code containsString:searchString ] ||
                [tempItem.msg_title containsString:searchString] ||
                [tempItem.msg_content containsString:searchString] ||
                [tempItem.announce_date containsString:searchString]) {
                //if (result == NSOrderedSame) {
                
                NotifyItem *item = [[NotifyItem alloc] init];
                [item setMsg_id:tempItem.msg_id];
                [item setMsg_code:tempItem.msg_code];
                [item setMsg_title:tempItem.msg_title];
                [item setMsg_content:tempItem.msg_content];
                [item setAnnounce_date:tempItem.announce_date];
                [item setInternal_doc_no:tempItem.internal_doc_no];
                [item setInternal_part_no:tempItem.internal_part_no];
                [item setInternal_model_no:tempItem.internal_model_no];
                [item setInternal_plant_no:tempItem.internal_plant_no];
                [item setAnnouncer:tempItem.announcer];
                [item setIme_code:tempItem.ime_code];
                [item setReadSp:tempItem.sp];
                
                
                [_filterNotifyList addObject:item];
            }
        }
    } else {
        for (NotifyItem *tempItem in _typeNotifyList) {
            NSLog(@"temp = %@", tempItem.msg_title);
            //NSComparisonResult result = [tempItem.result compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            if ([tempItem.msg_code containsString:searchString ] ||
                [tempItem.msg_title containsString:searchString] ||
                [tempItem.msg_content containsString:searchString] ||
                [tempItem.announce_date containsString:searchString]) {
                //if (result == NSOrderedSame) {
                
                NotifyItem *item = [[NotifyItem alloc] init];
                [item setMsg_id:tempItem.msg_id];
                [item setMsg_code:tempItem.msg_code];
                [item setMsg_title:tempItem.msg_title];
                [item setMsg_content:tempItem.msg_content];
                [item setAnnounce_date:tempItem.announce_date];
                [item setInternal_doc_no:tempItem.internal_doc_no];
                [item setInternal_part_no:tempItem.internal_part_no];
                [item setInternal_model_no:tempItem.internal_model_no];
                [item setInternal_plant_no:tempItem.internal_plant_no];
                [item setAnnouncer:tempItem.announcer];
                [item setIme_code:tempItem.ime_code];
                [item setReadSp:tempItem.sp];
                
                
                [_filterNotifyList addObject:item];
            }
        }
    }
    
    NSLog(@"filter size = %lu", (unsigned long)[_filterNotifyList count]);
}


- (void) searchBar:(UISearchBar *)mySearchBar textDidChange:(nonnull NSString *)searchText
{
    
    
    if ([searchText length] == 0) {
        [mySearchBar resignFirstResponder];
        _isFiltered = false;
    } else {
        _isFiltered = true;
        
        
        [self searchTableList];
        
    }
    
    [tableView reloadData];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"Cancel click");
}


- (void) searchBarSearchButtonClicked:(UISearchBar *) mySearchBar {
    NSLog(@"search clicked");
    
    [mySearchBar resignFirstResponder];
    
    [self searchTableList];
    [tableView reloadData];
}

- (void) deallocObserver
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

- (id) initObserver
{
    self = [super init];
    if (!self) return nil;
    
    // Add this instance of TestClass as an observer of the TestNotification.
    // We tell the notification center to inform us of "TestNotification"
    // notifications using the receiveTestNotification: selector. By
    // specifying object:nil, we tell the notification center that we are not
    // interested in who posted the notification. If you provided an actual
    // object rather than nil, the notification center will only notify you
    // when the notification was posted by that particular object.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    return self;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"]) {
        //NSLog (@"Successfully received the test notification! title = %@ body = %@", [notification.object objectForKey:@"title"], [notification.object objectForKey:@"body"]);
        NSLog (@"Successfully received the test notification!");
        
        
        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
         
         _item = [[NotifyItem alloc] init];
         
         NSLog(@"title = %@", [notification.userInfo objectForKey:@"title"]);
         [_item setTitle:[notification.userInfo objectForKey:@"title"]];
         [_item setMsg:[notification.userInfo objectForKey:@"body"]];
         [_item setTime:strDate];
         [_notifyList addObject:_item];
         NSLog(@"msg num = %lu", (unsigned long)_notifyList.count);
         _item = nil;
         dateFormatter = nil;*/
        
        _update = false;
        
        [self sendHttpPost];
        
    }
}

- (NSMutableArray *) sendHttpPost {
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (_notifyList.count > 0 ) {
        [_notifyList removeAllObjects];
        [_filterNotifyList removeAllObjects];
    }
    
    
    
    _notifyList = nil;
    _filterNotifyList = nil;
    
    
    _notifyList = [[NSMutableArray alloc] init];
    
    //NSLog(@"user_id = %@", user_id);
    
    //first create the soap envelope
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<soap:Body>"
                   "<Message_get_list xmlns=\"http://tempuri.org/\">"
                   "<ime_code>%@</ime_code>"
                   "</Message_get_list>"
                   "</soap:Body>"
                   "</soap:Envelope>", user_id];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://60.249.239.47:9571/service.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"60.249.239.47" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/Message_get_list" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:theRequest];
    [dataTask resume];
    
    //if (connection)
    if(dataTask)
    {
        webResponseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    
    //_meeting_count = 0;
    _doc = false;
    _isNotifyList = false;
    _isRoomName = false;
    _isMsgTitle = false;
    
    //[NSThread detachNewThreadSelector:@selector(actIndicatorEnd) toTarget:self withObject:nil];
    return _notifyList;
}

- (NSMutableArray *) sendHttpPost2:(NSString *)message_id {
    _updateList = [[NSMutableArray alloc] init];
    
    NSLog(@"message_id = %@", message_id);
    NSLog(@"user_id = %@", user_id);
    //NSLog(@"interchange_ctrl_id = %@", interchange_ctrl_id);
    
    //first create the soap envelope
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<soap:Body>"
                   "<Message_Update_Read_Status xmlns=\"http://tempuri.org/\">"
                   "<message_id>%@</message_id>"
                   "<user_no>%@</user_no>"
                   "<ime_code>%@</ime_code>"
                   "</Message_Update_Read_Status>"
                   "</soap:Body>"
                   "</soap:Envelope>", message_id, user_id ,user_id];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://60.249.239.47:9571/service.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"60.249.239.47" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/Message_Update_Read_Status" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:theRequest];
    
    
    [dataTask resume];
    
    //if (connection)
    if(dataTask)
    {
        webResponseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
        //[activityIndicator stopAnimating];
        //container.center = CGPointMake(-(self.view.frame.size.width), self.view.frame.size.height/2);
    }
    
    return _updateList;
}

//Implement the connection delegate methods.
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"### handler 1");
    
    completionHandler(NSURLSessionResponseAllow);
    
    [self.webResponseData  setLength:0];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"=== didReceiveData ===");
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //_received_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"received = %@", _received_data);
    [self.webResponseData  appendData:data];
}

//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error == nil) {
        //success
        NSLog(@"Received %lu Bytes", (unsigned long)[webResponseData length]);
        NSString *theXML = [[NSString alloc] initWithBytes:
                            [webResponseData mutableBytes] length:[webResponseData length] encoding:NSUTF8StringEncoding];
        
        //NSLog(@"%@",theXML);
        
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        //NSLog(@"%@",theXML);
        
        
        NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
        
        //setting delegate of XML parser to self
        xmlParser.delegate = self;
        
        // Run the parser
        @try{
            unread_sp_count = 0;
            BOOL parsingResult = [xmlParser parse];
            NSLog(@"parsing result = %d",parsingResult);
            NSLog(@"notify_count = %ld", (unsigned long)_notifyList.count );
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = unread_sp_count
            ;
            
            //save badge to default
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (unread_sp_count >= 0) {
                NSString *unread_badge = [NSString stringWithFormat:@"%ld", unread_sp_count];
                [defaults setObject:unread_badge forKey:@"Badge"];
            }
            
            //for(int i=0;i<_personalMeetingList.count; i++) {
            //    MeetingItem *item = [_personalMeetingList objectAtIndex:i];
            //NSLog(@"<subject %03d> %@", i, item.subject);
            //}
            if (!_update)
                [tableView reloadData];
            //[activityIndicator stopAnimating];
            //container.center = CGPointMake(-(self.view.frame.size.width), self.view.frame.size.height/2);
            [self showIndicator:false];
            
        }
        @catch (NSException* exception)
        {
            NSString *message = NSLocalizedString(@"SERVER_ERROR", nil);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            int duration = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{[alert dismissViewControllerAnimated:YES completion:nil];});
            
            [activityIndicator stopAnimating];
            container.center = CGPointMake(-(self.view.frame.size.width), self.view.frame.size.height/2);
            return;
        }
        
        
    } else {
        NSString *message = NSLocalizedString(@"COMPLETE_ERROR", nil);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        int duration = 2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{[alert dismissViewControllerAnimated:YES completion:nil];});
        
        [activityIndicator stopAnimating];
        container.center = CGPointMake(-(self.view.frame.size.width), self.view.frame.size.height/2);
    }
    
    
    
}


//Implement the NSXmlParserDelegate methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
    //NSLog(@"didStartElement");
    //NSLog(@"<%@>", elementName);
    for(id key in attributeDict)
    {
        NSLog(@"attribute %@", [attributeDict objectForKey:key]);
    }
    _elementStart = elementName;
    
    if ([elementName isEqualToString:@"DocumentElement"]) {
        _doc = true;
    } else if ([elementName isEqualToString:@"fxs"]) {
        _isNotifyList = true;
        NSLog(@"<%@>", elementName);
        _item = [[NotifyItem alloc] init];
    } else if ([elementName isEqualToString:@"room_name"]) {
        _isRoomName = true;
    } else if ([elementName isEqualToString:@"message_title"]) {
        _isMsgTitle = true;
    } else if ([elementName isEqualToString:@"Message_Update_Read_StatusResponse"]) {
        _update = true;
    } else if([elementName isEqualToString:@"Message_Update_Read_StatusResult"]) {
        NSLog(@"<%@>", elementName);
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //if ([currentElement isEqualToString:@"CelsiusToFahrenheitResult"]) {
    //    self.resultLabel.text = string;
    //}
    //NSLog(@"foundCharacters %@", string);
    //_elementValue = string;
    //NSLog(@"value = %@", string);
    NSLog(@"value = %@, size = %ld", string, (unsigned long)string.length);
    if (_isRoomName) {
        
        //if (![string isEqualToString:@" "]) {
        _elementValue = [NSString stringWithFormat: @"%@%@", _elementValue, string];
        NSCharacterSet *dont = [NSCharacterSet characterSetWithCharactersInString:@"\n "];
        _elementValue = [[_elementValue componentsSeparatedByCharactersInSet:dont]componentsJoinedByString:@""];
        
        NSLog(@"_isRoomName = %@", _elementValue);
        //}
    } else if (_isMsgTitle) {
        
        _elementValue = [NSString stringWithFormat: @"%@%@", _elementValue, string];
        NSCharacterSet *dont = [NSCharacterSet characterSetWithCharactersInString:@"\n "];
        _elementValue = [[_elementValue componentsSeparatedByCharactersInSet:dont]componentsJoinedByString:@""];
        NSLog(@"_isMsgTitle = %@", _elementValue);
    }
    else {
        _elementValue = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Parsed Element : %@", currentElement);
    //NSLog(@"didEndElement");
    //NSLog(@"elementName %@", elementName);
    _elementEnd = elementName;
    //NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
    //NSLog(@"</%@>", elementName);
    
    if ([elementName isEqualToString:@"DocumentElement"]) {
        _doc = false;
    } else if ([elementName isEqualToString:@"fxs"]) {
        _isNotifyList = false;
        NSLog(@"</%@>", elementName);
        
        [_notifyList addObject:_item];
        _item = nil;
        
        
        
    } else if ([elementName isEqualToString:@"message_id"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setMsg_id:_elementValue];
        }
    } else if ([elementName isEqualToString:@"message_code"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setMsg_code:_elementValue];
        }
    } else if ([elementName isEqualToString:@"message_title"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setMsg_title:_elementValue];
            _isMsgTitle = false;
        }
    } else if ([elementName isEqualToString:@"message_content"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setMsg_content:_elementValue];
        }
    } else if ([elementName isEqualToString:@"announce_date"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setAnnounce_date:_elementValue];
        }
    } else if ([elementName isEqualToString:@"internal_doc_no"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setInternal_doc_no:_elementValue];
        }
    } else if ([elementName isEqualToString:@"internal_part_no"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setInternal_part_no:_elementValue];
        }
    } else if ([elementName isEqualToString:@"internal_model_no"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setInternal_model_no:_elementValue];
        }
    } else if ([elementName isEqualToString:@"internal_machine_no"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setInternal_machine_no:_elementValue];
        }
    } else if ([elementName isEqualToString:@"internal_plant_no"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setInternal_plant_no:_elementValue];
        }
    } else if ([elementName isEqualToString:@"announcer"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setAnnouncer:_elementValue];
        }
    } else if ([elementName isEqualToString:@"ime_code"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setIme_code:_elementValue];
        }
    } else if ([elementName isEqualToString:@"read_sp"]) {
        if (_doc && _isNotifyList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            
            [_item setReadSp:_elementValue];
            if ([[_item sp] isEqualToString:@"N"]) {
                unread_sp_count++;
            }
        }
    } else if ([elementName isEqualToString:@"Message_Update_Read_StatusResponse"]) {
        _update = false;
    } else if([elementName isEqualToString:@"Message_Update_Read_StatusResult"]) {
        NSLog(@"value = %@", _elementValue);
        NSLog(@"</%@>", elementName);
        
        if ([_elementValue isEqualToString:@"OK"]) {
            
            NSLog(@"update readSp success!");
            
            //load badge
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *unread_badge = [defaults objectForKey:@"Badge"];
            unread_sp_count = [unread_badge intValue];
            
            NSLog(@"current badge = %ld", unread_sp_count);
            if (unread_sp_count > 0) {
                
                
                unread_sp_count--;
                //[UIApplication sharedApplication].applicationIconBadgeNumber = unread_sp_count;
                
                //save badge to default
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (unread_sp_count > 0) {
                    NSString *unread_badge = [NSString stringWithFormat:@"%ld", unread_sp_count];
                    [defaults setObject:unread_badge forKey:@"Badge"];
                }
            }
        } else {
            NSLog(@"update readSp failed!");
        }
    }
}



-(id) initWithFrame:(CGRect)theFrame {
    if (self = [super init]) {
        frame = theFrame;
        self.view.frame = theFrame;
    }
    return self;
}

- (void) changeTableTypeList {
    
    [_typeNotifyList removeAllObjects];
    _typeNotifyList = nil;
    
    _typeNotifyList = [[NSMutableArray alloc] init];
    
    //NSString *searchString = searchBar.text;
    
    NSLog(@"changeTableTypeList");
    
    for (NotifyItem *tempItem in _notifyList) {
        NSLog(@"temp = %@", tempItem.msg_title);
        //NSComparisonResult result = [tempItem.result compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if ([tempItem.msg_title containsString:current_select_string]) {
            //if (result == NSOrderedSame) {
            
            NotifyItem *item = [[NotifyItem alloc] init];
            [item setMsg_id:tempItem.msg_id];
            [item setMsg_code:tempItem.msg_code];
            [item setMsg_title:tempItem.msg_title];
            [item setMsg_content:tempItem.msg_content];
            [item setAnnounce_date:tempItem.announce_date];
            [item setInternal_doc_no:tempItem.internal_doc_no];
            [item setInternal_part_no:tempItem.internal_part_no];
            [item setInternal_model_no:tempItem.internal_model_no];
            [item setInternal_plant_no:tempItem.internal_plant_no];
            [item setAnnouncer:tempItem.announcer];
            [item setIme_code:tempItem.ime_code];
            [item setReadSp:tempItem.sp];
            
            
            [_typeNotifyList addObject:item];
        }
    }
    
    NSLog(@"type size = %lu", (unsigned long)[_typeNotifyList count]);
}

- (IBAction)onTypeChange:(id)sender {
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"TYPE_SELECT_TITLE", nil)
                                                                  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnAll = [UIAlertAction actionWithTitle:@"全部"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
    {
        NSLog(@"btnAll");
        self->current_select_type = 0;
        self->current_select_string = @"全部";
        [self->btnTypeSelect setTitle:@"全部" forState:(UIControlStateNormal)];
        
        self->_isFiltered = false;
        [self->tableView reloadData];
    }];
    
    UIAlertAction* btnEquipAnomalous = [UIAlertAction actionWithTitle:@"設備異常"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
    {
        NSLog(@"btnEquipAnomalous");
        self->current_select_type = 1;
        self->current_select_string = @"設備異常";
        [self->btnTypeSelect setTitle:@"設備異常" forState:(UIControlStateNormal)];
        
        [self changeTableTypeList];
        
        self->_isFiltered = false;
        [self->tableView reloadData];
    }];
    
    UIAlertAction* btnQualAnomalous = [UIAlertAction actionWithTitle:@"品質異常"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            NSLog(@"btnQualAnomalous");
                                            self->current_select_type = 2;
                                            self->current_select_string = @"品質異常";
                                            [self->btnTypeSelect setTitle:@"品質異常" forState:(UIControlStateNormal)];
                                            
                                            [self changeTableTypeList];
                                            
                                            self->_isFiltered = false;
                                            [self->tableView reloadData];
                                        }];
    
    UIAlertAction* btnGaugeAnomalous = [UIAlertAction actionWithTitle:@"檢具異常"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           NSLog(@"btnGaugeAnomalous");
                                           self->current_select_type = 3;
                                           self->current_select_string = @"檢具異常";
                                           [self->btnTypeSelect setTitle:@"檢具異常" forState:(UIControlStateNormal)];
                                           
                                           [self changeTableTypeList];
                                           
                                           self->_isFiltered = false;
                                           [self->tableView reloadData];
                                       }];
    
    UIAlertAction* btnFixtureAnomalous = [UIAlertAction actionWithTitle:@"治具異常"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            NSLog(@"btnFixtureAnomalous");
                                            self->current_select_type = 4;
                                            self->current_select_string = @"治具異常";
                                            [self->btnTypeSelect setTitle:@"治具異常" forState:(UIControlStateNormal)];
                                            
                                            [self changeTableTypeList];
                                            
                                            self->_isFiltered = false;
                                            [self->tableView reloadData];
                                        }];
    
    UIAlertAction* btnStarvedFeeding = [UIAlertAction actionWithTitle:@"缺料異常"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action)
                                          {
                                              NSLog(@"btnStarvedFeeding");
                                              self->current_select_type = 5;
                                              self->current_select_string = @"缺料異常";
                                              [self->btnTypeSelect setTitle:@"缺料異常" forState:(UIControlStateNormal)];
                                              
                                              [self changeTableTypeList];
                                              
                                              self->_isFiltered = false;
                                              [self->tableView reloadData];
                                          }];
    
    [alert addAction:btnAll];
    [alert addAction:btnEquipAnomalous];
    [alert addAction:btnQualAnomalous];
    [alert addAction:btnGaugeAnomalous];
    [alert addAction:btnFixtureAnomalous];
    [alert addAction:btnStarvedFeeding];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onMultiLinesChange:(id)sender {
    
    
    if ([multi_lines isEqualToString:@"true"]) {
        multi_lines = @"false";
        NSLog(@"multi_lines = %@", multi_lines);
        
        [btnMultiLines setImage:[UIImage imageNamed:@"more"] forState:normal];
        [tableView setRowHeight:60];
        
    } else {
        multi_lines = @"true";
        NSLog(@"multi_lines = %@", multi_lines);
        
        
        [btnMultiLines setImage:[UIImage imageNamed:@"less"] forState:normal];
        [tableView setRowHeight:100];
        
    }
    
    [tableView reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:multi_lines forKey:@"MultiLines"];
}

/*- (IBAction)onMultiLinesChange:(id)sender {
    if ([multi_lines isEqualToString:@"true"]) {
        multi_lines = @"false";
        NSLog(@"multi_lines = %@", multi_lines);
        
        [btnMultiLines setImage:[UIImage imageNamed:@"more"] forState:normal];
        [tableView setRowHeight:60];
    } else {
        multi_lines = @"true";
        NSLog(@"multi_lines = %@", multi_lines);
        
        
        [btnMultiLines setImage:[UIImage imageNamed:@"less"] forState:normal];
        [tableView setRowHeight:100];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:multi_lines forKey:@"MultiLines"];
}*/
@end
