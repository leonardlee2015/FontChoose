//
//  CurrentTextInfoViewController.m
//  FontChoose
//
//  Created by 李南 on 16/1/21.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "CurrentTextInfoViewController.h"
#import "TextInfos.h"
#import "UIView+SetRect.h"
#import "UIColor+CustomColor.h"
#import "AppDelegate.h"

@interface CurrentTextInfoViewController ()
@property (nonatomic,readonly,weak)TextInfos *textInfos;
@property (nonatomic,strong)UITextView *textView;
@end

@implementation CurrentTextInfoViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加不可编辑文本框，显示当前cell中显示的文本格式信息。
    UITextView *textView = [[UITextView alloc]init];
    textView.editable = NO;
    textView.text = [self textfontInformation];
    textView.font = [UIFont fontWithName:@"Avenir-Black" size:17];
    [self.view addSubview:textView];
    _textView = textView;
    
    //设置 textView Auto layout.
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *textViewDic = @{@"textView": textView};
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[textView]-|"\
                               options:0\
                               metrics:nil\
                               views:textViewDic]];
    [self.view addConstraints:[NSLayoutConstraint\
                               constraintsWithVisualFormat:@"V:|-[textView]-|"\
                               options:0\
                               metrics:nil\
                               views:textViewDic]];
    
    // 添加用于把全部字体信息添加到剪贴板到导航栏按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"All" style:UIBarButtonItemStyleDone target:self action:@selector(copyAllInfos:)];
    self.navigationItem.rightBarButtonItem = item;
    
}
-(IBAction)copyAllInfos:(id)sender{

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Copy All Text Infos?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = [self textfontInformation];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"canncel" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];

}
-(NSString*)textfontInformation{
    NSMutableString *textInfos = [NSMutableString stringWithString:@""];
    
    for (NSInteger i=0; i<self.textInfos.count; i++) {
        
        [textInfos appendFormat:@"text %ld\n",i];
        
        [textInfos appendFormat:@"\t\ttext: %@\n",[self.textInfos textOfIndex:i]];
        
        NSString *fontName = @"font  name:";
        if ([self.textInfos designationStateOfIndex:i] == TextInfoStateDesignated) {
            fontName = [fontName stringByAppendingString:[NSString stringWithFormat:@" %@\n",[self.textInfos fontNameOfIndex:i]]];
        }else{
            fontName = [fontName stringByAppendingString:[NSString stringWithFormat:@" %@\n",self.currentFontName]];
        }
        [textInfos appendString:fontName];
        
        [textInfos appendFormat:@"\t\tsize: %ld\n\n",(NSInteger)[self.textInfos sizeOfIndex:i]];
        
    }
    
    
    return textInfos;
}

#pragma mark - Properties
@dynamic textInfos;
-(TextInfos *)textInfos{
    return [TextInfos shareTextInfos];
}
@end
