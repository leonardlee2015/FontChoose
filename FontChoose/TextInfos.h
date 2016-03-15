//
//  TextInfos.h
//  FontChoose
//
//  Created by ltm on 16/3/5.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger,TextInfoState){
    TextInfoStateNoneState,
    TextInfoStateDesignated,
    TextInfoStateCompare
};

@interface TextInfos : NSObject
/*!
 *  @brief  the number of text infos's count;
 */
@property(nonatomic,readonly)NSInteger count;
/*!
 *  @brief  index
 */
@property(nonatomic,readonly)NSInteger currentIndex;

+(nullable TextInfos*)shareTextInfos;
/**
 *  clear all Text infos;
 */
-(void)clearTextInfos;
/*!
 *  @brief  push a new text info into back of text info queues;
 *
 *  @param text text
 *  @param size size
 *
 *  @since 0.0.1
 */
-(void)pushInfoText:(nonnull NSString*)text size:(float)size;
/*!
 *  @brief  get text contents in speacified index;
 *
 *  @param index index of text info;
 *
 *  @return text in designated text info;
 */
-(NSString* _Nonnull)textOfIndex:(NSInteger)index;
/*!
 *  @brief  get size of designated position of Text Infos;
 *
 *  @param index index of text info;
 *
 *  @return text size in designated text info;
 */
-(float)sizeOfIndex:(NSInteger)index;
/*!
 *  @brief  get font name of specified text info.
 *
 *  @param index index of pecieied text info;
 *
 *  @return font name of specified text info.
 */
-(nullable NSString*)fontNameOfIndex:(NSInteger)index;
-(TextInfoState)designationStateOfIndex:(NSInteger)index;
/*!
 *  @brief  designate text font to text info;
 *
 *  @param index    index of sepcified text info;
 *  @param fontName font name of designate font;
 */
-(void)commitTextIndex:(NSInteger)index byFontNmae:(nonnull NSString*)fontName;
/*!
 *  @brief compare specified text shapes in defferents fonts;
 *
 *  @param index index of text info;
 */
-(void)compareTextInfoWithIndex:(NSInteger)index;
/*!
 *  @brief  Delete specified position text info.
 *
 *  @param index specified text info's index.
 */
-(void)deleteTextInfoAtIndex:(NSInteger)index;
/*!
 *  @brief  insert new text info into text info queues.
 *
 *  @param text  text of text info.
 *  @param size  <#size description#>
 *  @param index specified index of new text info.
 */
-(void)insertText:(nonnull NSString*)text size:(NSInteger)size index:(NSInteger)index;
@end
