//
//  NSMutableAttributedString+setAttributes.m
//  FontChoose
//
//  Created by 李南 on 16/1/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "NSMutableAttributedString+setAttributes.h"

@implementation NSMutableAttributedString (setAttributes)
-(void)setAttributes:(NSDictionary<NSString *,id> *)attrs ranges:(NSArray<NSValue *> *)ranges{
    [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        [self setAttributes:attrs range:range];
    }];
}

-(void)setBackgroudColor:(UIColor *)color ranges:(NSArray<NSValue *> *)ranges{
    [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        
        [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
    }];
}
@end
