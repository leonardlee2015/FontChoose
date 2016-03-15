//
//  NSObject+AlertMassage.h
//  WheatherAppTest
//
//  Created by 李南 on 15/11/7.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AlertMassage)
/**
 *  @brief  show a AlertView
 *
 *  @param title   alert massage title
 *  @param massage alert massage
 */
-(void)showAlertMassageTitile:(NSString*)title massage:(NSString*)massage;
@end
