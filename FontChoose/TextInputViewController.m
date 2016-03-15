//
//  TextInputViewController.m
//  FontChoose
//
//  Created by 李南 on 15/12/3.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "TextInputViewController.h"
#import "UIColor+CustomColor.h"
#import "FontStyleDisplayViewController.h"
#import "UIView+SetRect.h"
#import "UIImage+BitMap.h"
#import "TextInfos.h"
#import "AppDelegate.h"

@interface TextInputViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSString * text;
@property (nonatomic,assign) NSInteger textSize;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *textInputField;
@property (weak, nonatomic) IBOutlet UITextField *fontSizeField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *canncelButton;
@property (weak, nonatomic) IBOutlet UIView *sperator;
@property (weak,nonatomic,readonly) TextInfos *textInfos;
@end

@implementation TextInputViewController
@synthesize textInfos = _textInfos;

-(void)viewDidLoad{
    [super viewDidLoad];
    // 设置 主view外观。
    //self.view.layer.cornerRadius = 8.f;
    //self.view.backgroundColor = [UIColor CustomBlueColor];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unregisterFistResponder:)];
    [self.view addGestureRecognizer:gesture];
    // 设置输入视图
    //[self addDoneButton];
    [self configInputView];
    
}

-(void)configInputView{
    // 设置 sperator
    self.sperator.userInteractionEnabled = NO;
    self.sperator.backgroundColor = [UIColor lightGrayColor];
    // 设置containerView
    self.containerView.layer.cornerRadius = 6;
    self.containerView.backgroundColor = [UIColor whiteColor];
    //self.containerView.backgroundColor = [UIColor clearColor];
    //self.containerView.layer.borderColor = [UIColor customGrayColor].CGColor;
    //self.containerView.layer.borderWidth = 2.f;
    //self.containerView.userInteractionEnabled = NO;
    // 设置 button 外观
    self.doneButton.layer.cornerRadius = 4.f;
    self.doneButton.backgroundColor = [UIColor CustomBlueColor];
    self.doneButton.tintColor = [UIColor whiteColor];
    //self.doneButton.layer.borderColor = [UIColor customGrayColor].CGColor;
    //self.doneButton.layer.borderWidth = 1;
    //self.doneButton.backgroundColor = [UIColor whiteColor];
    
    self.canncelButton.layer.cornerRadius = 4.f;
    self.canncelButton.backgroundColor = [UIColor CustomBlueColor];
    self.canncelButton.tintColor = [UIColor whiteColor];
    //self.canncelButton.layer.borderColor = [UIColor customGrayColor].CGColor;
    //self.canncelButton.layer.borderWidth = 1;
    //self.canncelButton.backgroundColor = [UIColor whiteColor];
    
    // 设置 textInputField & fontSizeField
    // textInputField 键盘为任意
    // fontSizeField 键盘为数字，且输入限定为数字，且应在［23 ～ 80］范围内。
    self.fontSizeField.keyboardType = UIKeyboardTypeNumberPad;
    self.fontSizeField.returnKeyType = UIReturnKeyDone;
    
    /*
    UILabel *label = [[UILabel alloc]init];
    label.text = @"size:";
    label.frame = CGRectMake(0, 0, 50, 50);
    //NSAttributedString * str = [[NSAttributedString alloc]initWithString:label.text attributes:label.font];

    self.fontSizeField.leftView = label;
    self.fontSizeField.leftViewMode = UITextFieldViewModeAlways;
     */
    self.fontSizeField.delegate = self;
    
}

#pragma mark - Action.
- (IBAction)doneInput:(id)sender {
    
    [self.textInfos pushInfoText:self.textInputField.text size:[self.fontSizeField.text floatValue]];
    // 找出上一个视图，并在dismisss 当前视图后刷新table view
    FontStyleDisplayViewController *vc;
    for (UIViewController *tempVC in ((UINavigationController*)self.presentingViewController).viewControllers) {
        if ([tempVC isMemberOfClass:[FontStyleDisplayViewController class]]) {
            vc = (FontStyleDisplayViewController*)tempVC;
        }
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (vc) {
            [vc.tableView reloadData];
            
        }
    }];
}
- (IBAction)canncelInput:(id)sender {
    FontStyleDisplayViewController *vc;
    for (UIViewController *tempVC in ((UINavigationController*)self.presentingViewController).viewControllers) {
        if ([tempVC isMemberOfClass:[FontStyleDisplayViewController class]]) {
            vc = (FontStyleDisplayViewController*)tempVC;
        }
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (vc) {
            vc.wordToDisplay = @"";
            vc.fontSize = 23;
            [vc.tableView reloadData];
        }

    }];
}

-(IBAction)unregisterFistResponder:(id)sender{
    if (self.fontSizeField.isFirstResponder) {
        [self.fontSizeField resignFirstResponder];
        
    }
    
    if (self.textInputField.isFirstResponder) {
        [self.textInputField resignFirstResponder];
    }
}

- (IBAction)resignFirstResponder:(UITextField*)sender {
    [sender resignFirstResponder];
}
#pragma mark - Properties
-(TextInfos *)textInfos{
    return [TextInfos shareTextInfos];
}
@end
