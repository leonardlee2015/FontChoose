//
//  InputTextInfos.h
//  FontChoose
//
//  Created by 李南 on 16/1/8.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextInfo : NSObject<NSCopying>
/**
 *  @brief text inputed, should not be nil or empty string.
 */
@property (nonnull, nonatomic,strong) NSString *text;
/**
 *  @brief text font size, if being not set or out of [23, 100]
 *      will be set to 23 innerly.
 */
@property (nonatomic, assign) NSInteger textSize;
/**
 *  @brief text color ,can be nil.
 */
@property (nonatomic, nullable, strong) UIColor *color;
/**
 *  @brief text info submited flag, if text is nil or empty, it
 *      could not be set and force to be NO.
 */
@property (nonatomic, assign, getter=isSubmited) BOOL submited;
/**
 *  @brief an convenience mathod to create a InputTextInfo with properties.
 *
 *  @param text  text inputed.
 *  @param size  size of text font.
 *  @param color color of text.
 *
 *  @return an instance of InputTextInfo.
 */
+(_Nullable instancetype)textInfoWithText:(NSString* _Nonnull)text size:(NSInteger)size color:(UIColor* _Nullable)color;
@end
