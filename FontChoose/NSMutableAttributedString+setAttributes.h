//
//  NSMutableAttributedString+setAttributes.h
//  FontChoose
//
//  Created by 李南 on 16/1/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (setAttributes)
-(void)setAttributes:(NSDictionary<NSString *,id> * _Nonnull)attrs ranges:(NSArray<NSValue*>* _Nonnull)ranges;
-(void)setBackgroudColor:(UIColor* _Nonnull)color ranges:(NSArray<NSValue*> *_Nonnull)ranges;
@end
