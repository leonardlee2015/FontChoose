//
//  InputTextInfos.m
//  FontChoose
//
//  Created by 李南 on 16/1/8.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "InputTextInfo.h"
#import "NSObject+AlertMassage.h"



@implementation InputTextInfo


BOOL _checkText(NSString *str){
    
    return (str && str.length > 0);
}






@synthesize submited = _submited;
-(void)setSubmited:(BOOL)submited{
    
    if (!submited) {
        _submited = submited;
    
    }
    else if (submited  && _checkText(self.text)) {
        _submited = submited;
    }else{
        [self showAlertMassageTitile:@"submit failed!" massage:@"text submit "];
    }
}

-(BOOL)isSubmited{
    
    if (!_checkText(self.text)) {
        _submited = NO;
    }
    
    return _submited;
}

+(instancetype)textInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color{
    InputTextInfo *textInfo = [[InputTextInfo alloc]init];
    if (textInfo) {
        textInfo.text = text;
        textInfo.textSize = size;
        textInfo.color = color;
    }
    return textInfo;
}

-(id)copyWithZone:(NSZone *)zone{
    // 为类 添加 copy 功能。
    InputTextInfo *textInfo = [[[self class] allocWithZone:zone]init];
    textInfo.text = self.text;
    textInfo.textSize = self.textSize;
    textInfo.color = self.color;
    textInfo.submited = self.isSubmited;
    
    return textInfo;
}

-(NSString *)description{
    NSMutableString *str = [NSMutableString stringWithString:[super description]];
    NSString *text = [NSString stringWithFormat:@"\n(NSString*) text: %@\n", self.text];
    NSString *textSize = [NSString stringWithFormat:@"(NSInteger)textSize: %ld\n", (long)self.textSize];
    NSString *submited = [NSString stringWithFormat:@"(BOOL)submited: %ld\n", (long)self.isSubmited];
    NSString *color = [NSString stringWithFormat:@"(UIColor*)color: %@\n", self.color];
    
    [str stringByAppendingString:text];
    [str stringByAppendingString:textSize];
    [str stringByAppendingString:color];
    [str stringByAppendingString:submited];
    
    return [str copy];
}


@end
