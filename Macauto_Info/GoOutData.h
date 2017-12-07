//
//  GoOutData.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/11/17.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoOutData : NSObject {
    NSString *data_id;
    NSString *emp_no;
    NSString *emp_name;
    NSString *start_date;
    NSString *end_date;
    NSString *back_date;
    NSString *reason;
    NSString *location;
    NSString *car_type;
    NSString *car_no;
    NSString *car_or_moto;
    NSString *app_sent_datetime;
    NSString *app_sent_status;
}

-(void) setData_id:(NSString *) s_data_id;
-(void) setEmp_no:(NSString *) s_emp_no;
-(void) setEmp_name:(NSString *) s_emp_name;
-(void) setStart_date:(NSString *) s_start_date;
-(void) setEnd_date:(NSString *) s_end_date;
-(void) setBack_date:(NSString *) s_back_date;
-(void) setReason:(NSString *) s_reason;
-(void) setLocation:(NSString *) s_location;
-(void) setCar_type:(NSString *) s_car_type;
-(void) setCar_no:(NSString *) s_car_no;
-(void) setCar_or_moto:(NSString *) s_car_or_moto;
-(void) setApp_sent_datetime:(NSString *) s_app_sent_datetime;
-(void) setApp_sent_status:(NSString *) s_app_sent_status;

-(NSString *) data_id;
-(NSString *) emp_no;
-(NSString *) emp_name;
-(NSString *) start_date;
-(NSString *) end_date;
-(NSString *) back_date;
-(NSString *) reason;
-(NSString *) location;
-(NSString *) car_type;
-(NSString *) car_no;
-(NSString *) car_or_moto;
-(NSString *) app_sent_datetime;
-(NSString *) app_sent_status;

@end
