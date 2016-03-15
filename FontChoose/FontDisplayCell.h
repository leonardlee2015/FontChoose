//
//  FontDisplayCell.h
//  FontChoose
//
//  Created by 李南 on 15/12/3.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"

@class FontDisplayCell;
@protocol FontDisplayCellDelegate <NSObject>
@required
-(void)displayCell:(FontDisplayCell* _Nonnull)cell didSelectedHoldlerView:(UIView* _Nonnull)view ofIndex:(NSInteger)index;
-(void)displayCell:(FontDisplayCell* _Nonnull)cell didSelectedTextView:(UIView* _Nonnull)view ofIndex:(NSInteger)index;

@end

@class TextInfos;
@interface cellEntity : NSObject
@property(nonatomic,weak)TextInfos *textInfos;
@property(nonatomic,assign) NSInteger currentSize;
@property(nonatomic,copy,nonnull) NSString *currentFontName;
@property(nonatomic,strong,nullable) NSArray<NSString*>*fontSearchStrs;
@end
@interface FontDisplayCell : SWRevealTableViewCell
#ifdef OLD
/** content is displayed in cell which to show how
 *  the font looked.
 *
 */
@property (nonnull,nonatomic,copy) NSString *displayedText;
/** 
 *  size of content is displayed in cell.
 */
@property (nonatomic,assign) NSInteger displayedSize;
/**
 *  @brief  font name this label display.
 */
@property (nonnull,nonatomic,copy) NSString *fontName;
#endif

@property (nonatomic,weak)id<FontDisplayCellDelegate> delegate;
@property (nonatomic,readonly,nullable) cellEntity * entity;
-(void)configCellByEntity:(cellEntity* _Nonnull)entity;
-(void)reloadContainerView;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
