//
//  UIView+SetRect.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/1.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
@interface UIView (SetRect)

/**
 *  @author ctd.leonard, 15-09-02 00:09:40
 *
 *  @brief  capsulation of  self.frame.size
 */
@property (nonatomic, assign) CGSize size;
/**
 *  @author ctd.leonard, 15-09-02 00:09:40
 *
 *  @brief  capsulation of  self.frame.origin.
 */
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, readonly) CGPoint boundsCenter;
@end
