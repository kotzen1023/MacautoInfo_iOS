//
//  WhoGoesOutViewController.m
//  Macauto_Info
//
//  Created by SUNUP on 2017/11/17.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import "WhoGoesOutViewController.h"
#import "GoOutData.h"


@interface WhoGoesOutViewController ()
@property NSString *soapMessage;
@property NSString *currentElement;
@property NSMutableData *webResponseData;

@property NSString *elementStart;
@property NSString *elementValue;
@property NSString *elementEnd;

@property BOOL doc;
@property BOOL isOriginalList;
@property BOOL isEmpName;
@property BOOL isReason;
@property BOOL isLocation;

@property GoOutData *item;
@property BOOL isFiltered;
@property BOOL is_item_press;

//@property BOOL update;
//@property ThemeColor *themeColor;
@property NSDate *today;
@property NSDateFormatter *dateFormat;
@end

@implementation WhoGoesOutViewController
@synthesize activityIndicator;
@synthesize soapMessage, webResponseData, currentElement;
@synthesize status_bar_height;
@synthesize current_select_type;
//@synthesize current_select_string;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    
    //init orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    //init list
    //_notifyList = [[NSMutableArray alloc] init];
    //[self initSearchBar];
    
    [self initLoading];
    [self initItemShow];
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
    
    //set button text
    //[btnRangeSelect setTitle:@"今天" forState:UIControlStateNormal];
    current_select_type = 0;
    //current_select_string = @"今天";
    
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
    
    //[self showNotifyDetail:false];
    
    [_originalList removeAllObjects];
    [_filterList removeAllObjects];
    [_typeList removeAllObjects];
    
    _originalList = nil;
    _filterList = nil;
    _typeList = nil;
    
    _dateFormat = nil;
    
    [tableView reloadData];
    
    //_update = false;
    
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
    huiView.contentSize = CGSizeMake(0, lbl_car_or_moto_header.frame.origin.y + lbl_car_or_moto_header.frame.size.height+50);
    
    CGSize background = CGSizeMake(width, height);
    CGRect backRect = CGRectMake(0, 0, width, height);
    
    if (_is_item_press) {
        NSLog(@"_is_item_press");
        huiView.frame = CGRectMake(0, status_bar_height, width, height);
    } else {
        huiView.frame = CGRectMake(width, status_bar_height, width, height);
    }
    //reset frame
    lbl_emp_no_show.frame = CGRectMake(105, 30, self.view.bounds.size.width-105, 21);
    lbl_emp_name_show.frame = CGRectMake(105, 56, self.view.bounds.size.width-105, 21);
    lbl_start_date_show.frame = CGRectMake(105, 82, self.view.bounds.size.width-105, 21);
    lbl_end_date_show.frame = CGRectMake(105, 108, self.view.bounds.size.width-105, 21);
    lbl_back_date_show.frame = CGRectMake(105, 134, self.view.bounds.size.width-105, 21);
    lbl_reason_show.frame = CGRectMake(105, 160, self.view.bounds.size.width-105, 105);
    lbl_location_show.frame = CGRectMake(105, 270, self.view.bounds.size.width-105, 63);
    lbl_car_type_show.frame = CGRectMake(105, 338, self.view.bounds.size.width-105, 21);
    lbl_car_no_show.frame = CGRectMake(105, 364, self.view.bounds.size.width-105, 21);
    lbl_car_or_moto_show.frame = CGRectMake(105, 390, self.view.bounds.size.width-105, 21);
    
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
        rowCount = [_filterList count];
    } else {
        if (current_select_type == 0) {
            rowCount = [_originalList count];
        } else {
            rowCount = [_typeList count];
        }
    }
    return rowCount;
    //return [mainArray count];
}

- (UITableViewCell * ) tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"whoGoesOutCell";
    
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.backgroundColor = [UIColor colorWithRed:(28/255.0) green:(28/255.0) blue:(28/255.0) alpha:1.0];
    
    
    //NotifyItem *item = [_notifyList objectAtIndex:indexPath.row];
    GoOutData *item;
    
    if (_isFiltered) {
        item = [_filterList objectAtIndex:indexPath.row];
    } else {
        if (current_select_type == 0) {
            item = [_originalList objectAtIndex:indexPath.row];
        } else {
            item = [_typeList objectAtIndex:indexPath.row];
        }
    }
    
    UILabel *name = (UILabel *)[cell viewWithTag:100];
    //UILabel *day = (UILabel *)[cell viewWithTag:103];
    //subject.textColor = [UIColor colorWithRed:(120/255.0) green:(120/255.0) blue:(120/255.0) alpha:1.0];
    //subject.text = item.title;
    NSLog(@"%@", item.emp_name);
    
    name.text = [NSString stringWithFormat:@" %3ld %@", (long)indexPath.row+1,  item.emp_name];
    
    UILabel *reason = (UILabel *) [cell viewWithTag:101];
    
    reason.text = [NSString stringWithFormat:@"%@", item.reason];
    
    UILabel *location = (UILabel *) [cell viewWithTag:102];
    
    location.text = [NSString stringWithFormat:@"%@", item.location];
    
    /*UILabel *time = (UILabel *) [cell viewWithTag:102];
    
    NSString *todayDateString = [_dateFormat stringFromDate:_today];
    
    NSArray *time_split = [item.start_date componentsSeparatedByString:@" "];
    
    
    if ([time_split[0] isEqualToString:todayDateString]) {
        time.text = NSLocalizedString(@"DATE_TODAY", nil);
    } else {
        NSString *year_string = [time_split[0] substringToIndex:[time_split[0] length] - 6];
        NSString *year_today = [todayDateString substringToIndex:[todayDateString length] - 6];
        if ([year_today isEqualToString:year_string]) { //same year
            time.text = [time_split[0] substringFromIndex:5];
        } else {
            time.text = time_split[0];
        }
        
    }*/
    
    
    
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long rowCount = indexPath.row;
    //Products *pInfo = [self.productInfo objectAtIndex:rowCount];
    //[ConfirmButton setTitle:@"修改" forState:UIControlStateNormal];
    //NotifyItem *item = [_notifyList objectAtIndex:rowCount];
    GoOutData *item;
    
    item = [_originalList objectAtIndex:rowCount];
    
    
    
    
    
    
    
    [UIView animateWithDuration:0.7 animations:^{
        //productName Label
        
        [self showNotifyDetail:true];
        
        
        
        huiView.contentSize = CGSizeMake(0, lbl_emp_no_header.frame.origin.y + lbl_emp_no_header.frame.size.height+50);
        
        lbl_emp_no_show.frame = CGRectMake(105, 30, self.view.bounds.size.width-105, 21);
        [lbl_emp_no_show setText: item.emp_no];
        
        
        
        [lbl_emp_name_show setText: item.emp_name];
        
        /*
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
         */
        
        
        [lbl_start_date_show setText: item.start_date];
        
        [lbl_end_date_show setText: item.end_date];
        
        [lbl_back_date_show setText: item.back_date];
        /*if (item.back_date != nil || ![item.back_date compare:@""]) {
            lbl_back_date_header.hidden = true;
            lbl_back_date_show.hidden = true;
        } else {
            lbl_back_date_header.hidden = false;
            lbl_back_date_show.hidden = false;
            
        }*/
        
        [lbl_reason_show setText: item.reason];
        [lbl_location_show setText: item.location];
        
        [lbl_car_type_show setText: item.car_type];
        
        /*if (item.car_type != nil || ![item.car_type compare:@""]) {
            lbl_car_type_header.hidden = true;
            lbl_car_type_show.hidden = true;
        } else {
            lbl_car_type_header.hidden = false;
            lbl_car_type_show.hidden = false;
            
        }*/
        
        [lbl_car_no_show setText: item.car_no];
        
        /*if (item.car_no != nil || ![item.car_no compare:@""]) {
            lbl_car_no_header.hidden = true;
            lbl_car_no_show.hidden = true;
        } else {
            lbl_car_no_header.hidden = false;
            lbl_car_no_show.hidden = false;
            
        }*/
        
        [lbl_car_or_moto_show setText: item.car_or_moto];
        
        /*if (item.car_or_moto != nil || ![item.car_or_moto compare:@""]) {
            lbl_car_or_moto_header.hidden = true;
            lbl_car_or_moto_show.hidden = true;
        } else {
            lbl_car_or_moto_header.hidden = false;
            lbl_car_or_moto_show.hidden = false;
            
        }*/
        
        
        
        //[lbl_time_show setText: item.announce_date];
        
        
        huiView.contentSize = CGSizeMake(0, status_bar_height+lbl_car_or_moto_header.frame.origin.y + lbl_car_or_moto_header.frame.size.height+50);
        
    }];
    
    _is_item_press = true;
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
    [btnBack addTarget:self action:@selector(backWoGoesOut:) forControlEvents:(UIControlEventTouchUpInside)];
    [huiView addSubview:btnBack];
    
    //emp no
    lbl_emp_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 80, 21)];
    [lbl_emp_no_header setText: NSLocalizedString(@"WHO_GOES_OUT_EMP_NO", nil)];
    [huiView addSubview:lbl_emp_no_header];
    
    lbl_emp_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_emp_no_show];
    
    //emp name
    lbl_emp_name_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 56, 80, 21)];
    [lbl_emp_name_header setText:NSLocalizedString(@"WHO_GOES_OUT_EMP_NAME", nil)];
    [huiView addSubview:lbl_emp_name_header];
    
    lbl_emp_name_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 56, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_emp_name_show];
    
    //Start time (h: 30+21+5
    lbl_start_date_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 82, 80, 21)];
    //[lbl_time_header setTextColor:[UIColor whiteColor]];
    //[lbl_time_header setText: NSLocalizedString(@"MEETING_SHOW_DETAIL_START_TIME", nil)];
    [lbl_start_date_header setText:NSLocalizedString(@"WHO_GOES_OUT_START_TIME", nil)];
    [huiView addSubview:lbl_start_date_header];
    
    lbl_start_date_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 82, self.view.bounds.size.width-105, 21)];
    
    [huiView addSubview: lbl_start_date_show];
    //end time
    lbl_end_date_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 108, 80, 21)];
    [lbl_end_date_header setText:NSLocalizedString(@"WHO_GOES_OUT_END_TIME", nil)];
    [huiView addSubview:lbl_end_date_header];
    
    lbl_end_date_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 108, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_end_date_show];
    //back time
    lbl_back_date_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 134, 80, 21)];
    [lbl_back_date_header setText:NSLocalizedString(@"WHO_GOES_OUT_BACK_TIME", nil)];
    [huiView addSubview:lbl_back_date_header];
    
    lbl_back_date_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 134, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_back_date_show];
    //reason
    lbl_reason_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 80, 105)];
    [lbl_reason_header setText:NSLocalizedString(@"WHO_GOES_OUT_REASON", nil)];
    [huiView addSubview:lbl_reason_header];
    
    lbl_reason_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 160, self.view.bounds.size.width-105, 105)];
    lbl_reason_show.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_reason_show.numberOfLines = 0;
    [huiView addSubview:lbl_reason_show];
    //location
    lbl_location_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 270, 80, 63)];
    [lbl_location_header setText:NSLocalizedString(@"WHO_GOES_OUT_LOCATION", nil)];
    [huiView addSubview:lbl_location_header];
    
    lbl_location_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 270, self.view.bounds.size.width-105, 63)];
    lbl_location_show.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_location_show.numberOfLines = 0;
    [huiView addSubview:lbl_location_show];
    //car type
    lbl_car_type_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 338, 80, 21)];
    [lbl_car_type_header setText:NSLocalizedString(@"WHO_GOES_OUT_CAR_TYPE", nil)];
    [huiView addSubview:lbl_car_type_header];
    
    lbl_car_type_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 338, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_car_type_show];
    //car no
    lbl_car_no_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 364, 80, 21)];
    [lbl_car_no_header setText:NSLocalizedString(@"WHO_GOES_OUT_CAR_NO", nil)];
    [huiView addSubview:lbl_car_no_header];
    
    lbl_car_no_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 364, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_car_no_show];
    //car or moto
    lbl_car_or_moto_header = [[UILabel alloc] initWithFrame:CGRectMake(5, 390, 80, 21)];
    [lbl_car_or_moto_header setText:NSLocalizedString(@"WHO_GOES_OUT_CAR_OR_MOTO", nil)];
    [huiView addSubview:lbl_car_or_moto_header];
    
    lbl_car_or_moto_show = [[UILabel alloc] initWithFrame:CGRectMake(105, 390, self.view.bounds.size.width-105, 21)];
    [huiView addSubview:lbl_car_or_moto_show];
    
}

- (void) backWoGoesOut:(id)sender
{
    [UIView animateWithDuration:0.7 animations:^{
        huiView.frame = CGRectMake((self.view.bounds.size.width), self.topLayoutGuide.length-self.navigationController.navigationBar.frame.size.height,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height);
    }];
    
    _is_item_press = false;
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
        
        //_update = false;
        
        [self sendHttpPost];
        
    }
}

- (NSMutableArray *) sendHttpPost {
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (_originalList.count > 0 ) {
        [_originalList removeAllObjects];
        [_filterList removeAllObjects];
    }
    
    
    
    _originalList = nil;
    _filterList = nil;
    
    
    _originalList = [[NSMutableArray alloc] init];
    
    //NSLog(@"user_id = %@", user_id);
    
    //first create the soap envelope
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<soap:Body>"
                   "<getDataBySelect xmlns=\"http://it.macauto.com/\">"
                   "<select>%d</select>"
                   "</getDataBySelect>"
                   "</soap:Body>"
                   "</soap:Envelope>", current_select_type];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://60.249.239.47:9572/WhoisoutSOAP/services/GetWhoGoesOutServiceImpl"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"60.249.239.47" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://it.macauto.com/getDataBySelect" forHTTPHeaderField:@"SOAPAction"];
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
    _isOriginalList = false;
    _isEmpName = false;
    _isReason = false;
    _isLocation = false;
    
    
    //[NSThread detachNewThreadSelector:@selector(actIndicatorEnd) toTarget:self withObject:nil];
    return _originalList;
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
        //NSLog(@"=========== 1 ===========");
        
    
        
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        //theXML = [theXML stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        //NSLog(@"%@",theXML);
        //NSLog(@"=========== 2 ===========");
        
        NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //NSString* newStr = [NSString stringWithUTF8String:[myData bytes]];
        
        //NSLog(@"%@",newStr);
        //NSLog(@"=========== 3 ===========");
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
        
        //setting delegate of XML parser to self
        xmlParser.delegate = self;
        
        // Run the parser
        @try{
            //unread_sp_count = 0;
            BOOL parsingResult = [xmlParser parse];
            NSLog(@"parsing result = %d",parsingResult);
            NSLog(@"goout_count = %ld", (unsigned long)_originalList.count );
            /*
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
            //}*/
            //if (!_update)
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
    NSLog(@"<%@>", elementName);
    for(id key in attributeDict)
    {
        NSLog(@"attribute %@", [attributeDict objectForKey:key]);
    }
    _elementStart = elementName;
    
    if ([elementName isEqualToString:@"getDataBySelectResponse"]) {
        _doc = true;
    } else if ([elementName containsString:@"getDataBySelectReturn"]) {
        _isOriginalList = true;
        NSLog(@"<%@>", elementName);
        _item = [[GoOutData alloc] init];
    } else if ([elementName containsString:@"emp_name"]) {
        _isEmpName = true;
        _elementValue = @"";
    } else if ([elementName containsString:@"location"]) {
        _isLocation = true;
        _elementValue = @"";
    } else if ([elementName containsString:@"reason"]) {
        _isReason = true;
        _elementValue = @"";
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
    
    /*NSData *myData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t *rawBytes = [myData bytes];
    
    for (int i=0; i< string.length; i++) {
        NSLog(@"%02x", rawBytes[i]);
    }*/
    
    if (_isEmpName || _isLocation || _isReason) {
        //if (![string isEqualToString:@" "]) {
        _elementValue = [NSString stringWithFormat: @"%@%@", _elementValue, string];
        NSCharacterSet *dont = [NSCharacterSet characterSetWithCharactersInString:@"\n "];
        _elementValue = [[_elementValue componentsSeparatedByCharactersInSet:dont]componentsJoinedByString:@""];
        

        //}
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
    NSLog(@"</%@>", elementName);
    
    
    if ([elementName isEqualToString:@"getDataBySelectResponse"]) {
        _doc = false;
    } else if ([elementName containsString:@"getDataBySelectReturn"]) {
        _isOriginalList = false;
        NSLog(@"</%@>", elementName);
        
        [_originalList addObject:_item];
        _item = nil;
    } else if ([elementName containsString:@"app_sent_datetime"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setApp_sent_datetime:_elementValue];
        }
    } else if ([elementName containsString:@"app_sent_status"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setApp_sent_status:_elementValue];
        }
    } else if ([elementName containsString:@"back_date"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setBack_date:_elementValue];
        }
    } else if ([elementName containsString:@"car_no"]) {
        if (_doc && _isOriginalList) {
            
            if ([_elementValue containsString:_item.back_date]) {
                [_item setCar_no:@"N"];
            } else {
                NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
                [_item setCar_no:_elementValue];
            }
        }
    } else if ([elementName containsString:@"car_or_moto"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setCar_or_moto:_elementValue];
        }
    } else if ([elementName containsString:@"car_type"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setCar_type:_elementValue];
        }
    } else if ([elementName containsString:@"car_type"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setCar_type:_elementValue];
        }
    } else if ([elementName containsString:@"emp_name"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setEmp_name:_elementValue];
        }
        _isEmpName = false;
    } else if ([elementName containsString:@"emp_no"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setEmp_no:_elementValue];
        }
    } else if ([elementName containsString:@"end_date"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setEnd_date:_elementValue];
        }
    } else if ([elementName containsString:@"id"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setData_id:_elementValue];
        }
    } else if ([elementName containsString:@"location"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setLocation:_elementValue];
        }
        _isLocation = false;
    } else if ([elementName containsString:@"reason"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setReason:_elementValue];
        }
        _isReason = false;
    } else if ([elementName containsString:@"start_date"]) {
        if (_doc && _isOriginalList) {
            NSLog(@"<%@>%@</%@>", _elementStart, _elementValue, _elementEnd);
            [_item setStart_date:_elementValue];
        }
    }
    
    /*if ([elementName isEqualToString:@"DocumentElement"]) {
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
    } */
}

-(id) initWithFrame:(CGRect)theFrame {
    if (self = [super init]) {
        frame = theFrame;
        self.view.frame = theFrame;
    }
    return self;
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*- (IBAction)btnRangeChange:(id)sender {
    
    int selected = current_select_type;
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"TYPE_SELECT_TITLE", nil)
                                                                  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnToday = [UIAlertAction actionWithTitle:@"今天"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"btnToday");
                                 current_select_type = 0;
                                 current_select_string = @"今天";
                                 [btnRangeSelect setTitle:@"今天" forState:(UIControlStateNormal)];
                                 
                                 if (selected != current_select_type) {
                                     [_originalList removeAllObjects];
                                     _originalList = nil;
                                     [tableView reloadData];
                                     
                                     [self showIndicator:true];
                                 
                                     [self sendHttpPost];
                                 }
                                 //_isFiltered = false;
                                 //[tableView reloadData];
                             }];
    
    UIAlertAction* btnWeek = [UIAlertAction actionWithTitle:@"近7天"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            NSLog(@"btnWeek");
                                            current_select_type = 1;
                                            current_select_string = @"近7天";
                                            [btnRangeSelect setTitle:@"近7天" forState:(UIControlStateNormal)];
                                            
                                            if (selected != current_select_type) {
                                                [_originalList removeAllObjects];
                                                _originalList = nil;
                                                [tableView reloadData];
                                                
                                                [self showIndicator:true];
                                                
                                                [self sendHttpPost];
                                            }
                                            //[self changeTableTypeList];
                                            
                                            //_isFiltered = false;
                                            //[tableView reloadData];
                                        }];
    
    UIAlertAction* btnFifteenDays = [UIAlertAction actionWithTitle:@"近15天"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           NSLog(@"btnFifteen");
                                           current_select_type = 2;
                                           current_select_string = @"近15天";
                                           [btnRangeSelect setTitle:@"近15天" forState:(UIControlStateNormal)];
                                           
                                           if (selected != current_select_type) {
                                               [_originalList removeAllObjects];
                                               _originalList = nil;
                                               [tableView reloadData];
                                               
                                               [self showIndicator:true];
                                               
                                               [self sendHttpPost];
                                           }
                                           //[self changeTableTypeList];
                                           
                                           //[tableView reloadData];
                                       }];
    
    UIAlertAction* btnThirtyDays = [UIAlertAction actionWithTitle:@"近30天"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            NSLog(@"btnThirty");
                                            current_select_type = 3;
                                            current_select_string = @"近30天";
                                            [btnRangeSelect setTitle:@"近30天" forState:(UIControlStateNormal)];
                                            
                                            if (selected != current_select_type) {
                                                [_originalList removeAllObjects];
                                                _originalList = nil;
                                                [tableView reloadData];
                                                
                                                [self showIndicator:true];
                                                
                                                [self sendHttpPost];
                                            }
                                            //[self changeTableTypeList];
                                            
                                            //_isFiltered = false;
                                            //[tableView reloadData];
                                        }];
    
    
    
    [alert addAction:btnToday];
    [alert addAction:btnWeek];
    [alert addAction:btnFifteenDays];
    [alert addAction:btnThirtyDays];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}*/



@end
