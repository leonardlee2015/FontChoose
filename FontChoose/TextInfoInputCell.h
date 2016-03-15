//
//  TextInfoInputCell.h
//  FontChoose
//
//  Created by 李南 on 15/12/25.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "SWRevealTableViewCell.h"
#import <UIKit/UIKit.h>
#import "InputTextInfo.h"

@protocol TextInfoInputCellDelegate <NSObject>



@end

@interface TextInfoInputCell : SWRevealTableViewCell
/**
 *  @brief inputTextInfo.
 */
@property (nonatomic, strong,nonnull) InputTextInfo* inputTextInfo;
@property (nonatomic, strong,nonnull) NSIndexPath *indexPath;
/**
 *  @brief submit textInfo.
 */
-(void)submitTextInfos;
/**
 *  @brief reedit textInfo.
 */
-(void)reEditTextInfos;
/**
 *  @brief reign all text field responder.
 */
-(void)resignAllFirstResponder;

@end
