//
//  UIColor+multiRanges.m
//  FontChoose
//
//  Created by 李南 on 16/1/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "NSString+multiRanges.h"

@implementation NSString (multiRanges)
-(NSArray<NSValue *> *)rangesOfString:(NSString *)aString{
    NSMutableArray<NSValue*>* array = [NSMutableArray array];
    
    NSRange tempRange = NSMakeRange(0, 0);
    
    while (self.length > (tempRange.location + tempRange.length)) {
        NSInteger nowStartLocation = tempRange.location + tempRange.length;
        tempRange = [self rangeOfString:aString options:NSCaseInsensitiveSearch range:NSMakeRange(nowStartLocation, self.length-nowStartLocation)];
        
        if (tempRange.location != NSNotFound) {
            [array addObject:[NSValue valueWithRange:tempRange]];
        
        }else{
            break;
        }
        
    }
    return [array copy];
}
@end
