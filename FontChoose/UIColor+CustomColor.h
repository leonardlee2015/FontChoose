//
//  UIColor+CustomColor.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/10.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (CustomColor)
+ (UIColor *)customGrayColor;
+ (UIColor *)customRedColor;
+ (UIColor *)customYellowColor;
+ (UIColor *)customGreenColor;
+ (UIColor *)customRandomColor;
+(UIColor*)CustomBlueColor;
+(UIColor*)colorWithIntRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
@end
