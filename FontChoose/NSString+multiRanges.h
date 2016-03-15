//
//  NSString+multiRanges.h
//  FontChoose
//
//  Created by 李南 on 16/1/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (multiRanges)
/**
 *  @brief find and return ranges of the occurrence of a given string within receiver.
 *
 *  @param aString the string to search for, this value must not be nil.
 *
 *  @return an array of NSValue convert from NSRange structure  giving the location 
 *  and length in the receiver of the first occurrence of aString
 */
-(nonnull NSArray<NSValue*>*)rangesOfString:(NSString* _Nonnull) aString;
@end
