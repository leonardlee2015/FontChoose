//
//  NSObject+AlertMassage.m
//  WheatherAppTest
//
//  Created by 李南 on 15/11/7.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "NSObject+AlertMassage.h"
#import <UIKit/UIKit.h>
@implementation NSObject (AlertMassage)
-(void)showAlertMassageTitile:(NSString *)title massage:(NSString *)massage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title \
                                                        message:massage \
                                                       delegate:nil \
                                              cancelButtonTitle:@"OK" \
                                              otherButtonTitles: nil];
    [alertView show];
}
@end
