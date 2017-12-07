//
//  GoOutData.m
//  Macauto_Info
//
//  Created by SUNUP on 2017/11/17.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import "GoOutData.h"

@implementation GoOutData

-(void) setData_id:(NSString *)s_data_id
{
    data_id = s_data_id;
}

-(void) setEmp_no:(NSString *)s_emp_no
{
    emp_no = s_emp_no;
}

-(void) setEmp_name:(NSString *)s_emp_name
{
    emp_name = s_emp_name;
}

-(void) setStart_date:(NSString *)s_start_date
{
    start_date = s_start_date;
}

-(void) setEnd_date:(NSString *)s_end_date
{
    end_date = s_end_date;
}

-(void) setBack_date:(NSString *)s_back_date
{
    back_date = s_back_date;
}

-(void) setReason:(NSString *)s_reason
{
    reason = s_reason;
}

-(void) setLocation:(NSString *)s_location
{
    location = s_location;
}

-(void) setCar_type:(NSString *)s_car_type
{
    car_type = s_car_type;
}

-(void) setCar_no:(NSString *)s_car_no
{
    car_no = s_car_no;
}

-(void) setCar_or_moto:(NSString *)s_car_or_moto
{
    car_or_moto = s_car_or_moto;
}

-(void) setApp_sent_datetime:(NSString *)s_app_sent_datetime
{
    app_sent_datetime = s_app_sent_datetime;
}

-(void) setApp_sent_status:(NSString *)s_app_sent_status
{
    app_sent_status = s_app_sent_status;
}

-(NSString *) data_id {
    return data_id;
}

-(NSString *) emp_no {
    return emp_no;
}

-(NSString *) emp_name {
    return emp_name;
}

-(NSString *) start_date {
    return start_date;
}

-(NSString *) end_date {
    return end_date;
}

-(NSString *) back_date {
    return back_date;
}

-(NSString *) reason {
    return reason;
}

-(NSString *) location {
    return location;
}

-(NSString *) car_type {
    return car_type;
}

-(NSString *) car_no {
    return car_no;
}

-(NSString *) car_or_moto {
    return car_or_moto;
}

-(NSString *) app_sent_datetime {
    return app_sent_datetime;
}

-(NSString *) app_sent_status {
    return app_sent_status;
}

@end
