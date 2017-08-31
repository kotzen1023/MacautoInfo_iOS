//
//  NotifyItem.m
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import "NotifyItem.h"

@implementation NotifyItem

-(void) setMsg_id:(NSString *)s_msg_id
{
    msg_id = s_msg_id;
}

-(void) setMsg_code:(NSString *)s_msg_code
{
    msg_code = s_msg_code;
}

-(void) setMsg_title:(NSString *)s_msg_title
{
    msg_title = s_msg_title;
}

-(void) setMsg_content:(NSString *)s_msg_content
{
    msg_content = s_msg_content;
}

-(void) setAnnounce_date:(NSString *)s_announce_date
{
    announce_date = s_announce_date;
}

-(void) setInternal_doc_no:(NSString *)s_internal_doc_no
{
    internal_doc_no = s_internal_doc_no;
}

-(void) setInternal_part_no:(NSString *)s_internal_part_no
{
    internal_part_no = s_internal_part_no;
}

-(void) setInternal_model_no:(NSString *)s_internal_model_no{
    internal_model_no = s_internal_model_no;
}

-(void) setInternal_machine_no:(NSString *)s_internal_machine_no
{
    internal_machine_no = s_internal_machine_no;
}

-(void) setInternal_plant_no:(NSString *)s_internal_plant_no
{
    internal_plant_no = s_internal_plant_no;
}

-(void) setAnnouncer:(NSString *)s_announcer
{
    announcer = s_announcer;
}

-(void) setIme_code:(NSString *)s_ime_code
{
    ime_code = s_ime_code;
}

-(void) setReadSp:(NSString *)s_sp
{
    sp = s_sp;
}

-(NSString *) msg_id {
    return msg_id;
}

-(NSString *) msg_code {
    return msg_code;
}

-(NSString *) msg_title {
    return msg_title;
}

-(NSString *) msg_content {
    return msg_content;
}

-(NSString *) announce_date {
    return announce_date;
}

-(NSString *) internal_doc_no {
    return internal_doc_no;
}

-(NSString *) internal_part_no {
    return internal_part_no;
}

-(NSString *) internal_model_no {
    return internal_model_no;
}

-(NSString *) internal_machine_no {
    return internal_machine_no;
}

-(NSString *) internal_plant_no {
    return internal_plant_no;
}

-(NSString *) announcer {
    return announcer;
}

-(NSString *) ime_code {
    return ime_code;
}

-(NSString *) sp {
    return sp;
}

@end
