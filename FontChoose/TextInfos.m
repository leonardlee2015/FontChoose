//
//  TextInfos.m
//  FontChoose
//
//  Created by ltm on 16/3/5.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "TextInfos.h"

static NSString * const kState = @"state";
static NSString * const kText = @"text";
static NSString * const kSize = @"size";
static NSString * const kFont = @"font";
static NSString * const kColor = @"color";

@interface TextInfos ()

@end
@implementation TextInfos{
    NSMutableArray <NSMutableDictionary*>*_textInfos;
}
+(TextInfos *)shareTextInfos{
    static TextInfos *textInfos;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         <#Description#>
         */
        textInfos = [[TextInfos alloc]initWithArray];
    });
    
    return textInfos;
}
-(instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use [TextInfos shareTextInfos] mathods to get the signal instance of TextInfo" userInfo:nil];
}
-(instancetype)initWithArray{
    self = [super init];
    if (self) {
        _textInfos = [NSMutableArray array];
    }
    return self;
}

@dynamic count;
@dynamic currentIndex;
-(NSInteger)count{
    return [_textInfos count];
}
-(NSInteger)currentIndex{
    __block NSInteger firstCompareIndex = -1;
    __block NSInteger firstNoneIndex = -1;
    
    [_textInfos enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[kState] integerValue] == TextInfoStateCompare) {
            firstCompareIndex = idx;
            *stop = YES;
        }
        if ((firstNoneIndex==-1) && ([obj[kState] integerValue]==TextInfoStateNoneState)) {
            firstNoneIndex = idx;
        }
    }];
    
    if ((firstCompareIndex==-1)&&(firstNoneIndex!=-1)) {
        [self compareTextInfoWithIndex:firstNoneIndex];
        firstCompareIndex = firstNoneIndex ;
    }
    return firstCompareIndex;
}
-(void)clearTextInfos{
    [_textInfos removeAllObjects];
}
-(void)pushInfoText:(NSString *)text size:(float)size{
    NSMutableDictionary *textInfo = @{
                                      kText: text,
                                      kSize: size>=6?@(size):@6.f,
                                      kState: @(TextInfoStateNoneState),
                                      kFont:[NSNull null],
                                      kColor:[NSNull null]
                                      }.mutableCopy;
    [_textInfos addObject:textInfo];
}
-(NSString *)textOfIndex:(NSInteger)index{
    return _textInfos[index][kText];
}
-(float)sizeOfIndex:(NSInteger)index{
    return [_textInfos[index][kSize] floatValue];
}
-(NSString *)fontNameOfIndex:(NSInteger)index{
    return _textInfos[index][kFont];
}
-(TextInfoState)designationStateOfIndex:(NSInteger)index{
    return [_textInfos[index][kState] integerValue];
}

-(void)commitTextIndex:(NSInteger)index byFontNmae:(NSString *)fontName{
    _textInfos[index][kState] = @(TextInfoStateDesignated);
    _textInfos[index][kFont] = fontName;
}
-(void)compareTextInfoWithIndex:(NSInteger)index{
    _textInfos[index][kState] = @(TextInfoStateCompare);
    _textInfos[index][kFont] = [NSNull null];
    [_textInfos enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx!=index) \
            && ([_textInfos[idx][kState] integerValue] == TextInfoStateCompare)) {
            _textInfos[idx][kState] = @(TextInfoStateNoneState);
        }
    }];
}
-(void)deleteTextInfoAtIndex:(NSInteger)index{
    [_textInfos removeObjectAtIndex:index];
}

-(void)insertText:(NSString *)text size:(NSInteger)size index:(NSInteger)index{
    NSMutableDictionary *textInfo = @{
                                      kText: text,
                                      kSize: size>=6?@(size):@6.f,
                                      kState: @(TextInfoStateNoneState),
                                      kFont:[NSNull null],
                                      kColor:[NSNull null]
                                      }.mutableCopy;
  
    [_textInfos insertObject:textInfo atIndex:index];
}
@end
