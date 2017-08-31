//
//  NotifyItem.h
//  Macauto_Info
//
//  Created by SUNUP on 2017/7/18.
//  Copyright © 2017年 Macauto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyItem : NSObject {
    NSString *msg_id;
    NSString *msg_code;
    NSString *msg_title;
    NSString *msg_content;
    NSString *announce_date;
    NSString *internal_doc_no;
    NSString *internal_part_no;
    NSString *internal_model_no;
    NSString *internal_machine_no;
    NSString *internal_plant_no;
    NSString *announcer;
    NSString *ime_code;
    NSString *sp;
}

-(void) setMsg_id:(NSString *) s_msg_id;
-(void) setMsg_code:(NSString *) s_msg_code;
-(void) setMsg_title:(NSString *) s_msg_title;
-(void) setMsg_content:(NSString *) s_msg_content;
-(void) setAnnounce_date:(NSString *) s_announce_date;
-(void) setInternal_doc_no:(NSString *) s_internal_doc_no;
-(void) setInternal_part_no:(NSString *) s_internal_part_no;
-(void) setInternal_model_no:(NSString *) s_internal_model_no;
-(void) setInternal_machine_no:(NSString *) s_internal_machine_no;
-(void) setInternal_plant_no:(NSString *) s_internal_plant_no;
-(void) setAnnouncer:(NSString *) s_announcer;
-(void) setIme_code:(NSString *) s_ime_code;
-(void) setReadSp:(NSString *) s_sp;

-(NSString *) msg_id;
-(NSString *) msg_code;
-(NSString *) msg_title;
-(NSString *) msg_content;
-(NSString *) announce_date;
-(NSString *) internal_doc_no;
-(NSString *) internal_part_no;
-(NSString *) internal_model_no;
-(NSString *) internal_machine_no;
-(NSString *) internal_plant_no;
-(NSString *) announcer;
-(NSString *) ime_code;
-(NSString *) sp;

@end
