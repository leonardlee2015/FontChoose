//
//  TextInfoInputCell.m
//  FontChoose
//
//  Created by 李南 on 15/12/25.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "TextInfoInputCell.h"
#import "UIImage+BitMap.h"
#import "UIColor+CustomColor.h"
#import "NSObject+AlertMassage.h"
#import "UIView+SetRect.h"
#import <objc/runtime.h>

@interface UIBarButtonItem (textField)
@property (nonatomic,strong) UITextField *textField;
@end

@implementation UIBarButtonItem (textField)

@dynamic textField;
static NSString *const  textfieldIndentifer= @"text field";
-(UITextField *)textField{
    return  objc_getAssociatedObject(self, &textfieldIndentifer);
}

-(void)setTextField:(UITextField *)textField{
    objc_setAssociatedObject(self, &textfieldIndentifer, textField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface UITextField (text)
@property (nonatomic, assign) BOOL isText;
@end

@implementation UITextField (text)

@dynamic isText;
static NSString *const  isTextIndentifer= @"is text";
-(BOOL)isText{
    NSNumber *isText = objc_getAssociatedObject(self, &isTextIndentifer);
    return [isText boolValue];
}
-(void)setIsText:(BOOL)isText{
    objc_setAssociatedObject(self, &isTextIndentifer, [NSNumber numberWithBool:isText], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface TextInfoInputCell ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UILabel *textInfoNameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *sizeField;
@property (nonatomic, strong) UIImageView *submitImageView;
@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) NSDictionary <NSString*, UIImage*>*submitImageDic;
@end

@implementation TextInfoInputCell

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return  self;
}


NSString * const kTextField = @"text field";
NSString * const kTextFieldBackGround = @"text field background view";
NSString * const kSubmitedImage = @"submited image";
NSString * const kUnsubmitImage = @"no submit image";
-(void)setup{
    // 添加 textInfoNameLabel
    UILabel *textNameLabel = [[UILabel alloc]init];
    textNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textNameLabel.text = @"Text Info 1";
    textNameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:textNameLabel];
    self.textInfoNameLabel = textNameLabel;
    
    CGSize labelSize = textNameLabel.intrinsicContentSize;
    CGSize submitImageSize = CGSizeMake(labelSize.height, labelSize.height);
    UIImage *submitediImage = [[UIImage imageNamed:@"solidStar" size:submitImageSize]imageWithGradientTintColor:[UIColor customYellowColor]];
    UIImage *unSubmitImage = [[UIImage imageNamed:@"hollowStar" size:submitImageSize]imageWithGradientTintColor:[UIColor customYellowColor]];
    _submitImageDic = @{
                        kSubmitedImage:submitediImage,
                        kUnsubmitImage:unSubmitImage
                        };
    
    // 添加确定按钮
    UIImage *submitImage = _submitImageDic[kUnsubmitImage];
    UIImageView *submitImageView  = [[UIImageView alloc]initWithImage:submitImage];
    submitImageView.contentMode = UIViewContentModeScaleAspectFit;
    submitImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [submitImageView setContentHuggingPriority:UILayoutPriorityDefaultLow \
                                       forAxis:UILayoutConstraintAxisVertical];
    [submitImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh \
                                                     forAxis:UILayoutConstraintAxisVertical];

    
    
    [self.contentView addSubview:submitImageView];

    _submitImageView =  submitImageView;
    // 添加 text input text field .
    NSDictionary *textDic = [self createTextFieldWithName:@"text"];
    UITextField *textField = textDic[kTextField];
    textField.isText = YES;
    textField.placeholder = @"text";
    self.textField = textField;
    UIView *textFieldBackgroudView = textDic[kTextFieldBackGround];
    
    // 添加  size input text field.
    NSDictionary *sizeDic = [self createTextFieldWithName:@"size"];
    UITextField *sizeField = sizeDic[kTextField];
    sizeField.placeholder = @"font size";
    sizeField.isText = NO;
    // 设置 size field input view 外观。
    sizeField.keyboardType = UIKeyboardTypeNumberPad;
    sizeField.delegate = self;
    self.sizeField = sizeField;
    UIView *sizeFieldBackgroudView = sizeDic[kTextFieldBackGround];
    
    // 添加 cell separator view .
    UIView *separatorView = [[UIView alloc]init];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:separatorView];
    
    
    // 设置 cell constraints .
    
    NSString *vertialFormat = @"V:|-[textNameLabel]-(15)-[textFieldBackgroudView]-[sizeFieldBackgroudView]-(20)-[separatorView(==1)]|" ;
    [self.contentView addConstraints:[NSLayoutConstraint \
                                     constraintsWithVisualFormat:vertialFormat\
                                     options:0 \
                                     metrics:nil\
                                      views:NSDictionaryOfVariableBindings(textNameLabel,textFieldBackgroudView,sizeFieldBackgroudView,separatorView)]];
    [self.contentView addConstraints:[NSLayoutConstraint \
                                     constraintsWithVisualFormat:@"H:|-[textNameLabel]-[submitImageView]" \
                                     options:NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllTop\
                                      metrics:nil\
                                      views:NSDictionaryOfVariableBindings(textNameLabel,submitImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint \
                                     constraintsWithVisualFormat:@"H:|-(30)-[textFieldBackgroudView]-|"\
                                     options:0\
                                     metrics:nil\
                                      views:NSDictionaryOfVariableBindings(textFieldBackgroudView)]];
    [self.contentView addConstraints:[NSLayoutConstraint \
                                      constraintsWithVisualFormat:@"H:|-(30)-[sizeFieldBackgroudView]-|"\
                                      options:0\
                                      metrics:nil\
                                      views:NSDictionaryOfVariableBindings(sizeFieldBackgroudView)]];
    [self.contentView addConstraints:[NSLayoutConstraint \
                                      constraintsWithVisualFormat:@"H:|-[separatorView]-|"\
                                      options:0\
                                      metrics:nil\
                                      views:NSDictionaryOfVariableBindings(separatorView)]];
    


    
    // 为视图添加一个pach效果。

    /*
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipHandler:)];
    [swipGesture addTarget:self action:@selector(sss:)];
    [self addGestureRecognizer:swipGesture];
    //UISwipeGestureRecognizer *swipgesture2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sss:)];
    //swipgesture2.delegate = self;
    //[self addGestureRecognizer:swipgesture2];
    */

}

-(NSDictionary*)createTextFieldWithName:(NSString*)name{

    NSMutableDictionary *textFieldDic = [[NSMutableDictionary alloc]initWithCapacity:2];

    // 添加 textField textBackgroundView.
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:backgroundView];

    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = [NSString stringWithFormat:@"%@:",name];
    titleLabel.font = [UIFont systemFontOfSize:19];
    [backgroundView addSubview:titleLabel];
    
    UITextField *field = [[UITextField alloc]init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field addTarget:self action:@selector(editDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:field];
    
    
    // 为 textField 添加一个tool bar .
    UIToolbar *accessoryBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,SCREEN_SIZE.width , 50)];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"Canncel" \
                                                             style:UIBarButtonItemStylePlain \
                                                            target:self \
                                                            action:@selector(canncelInput:)];
    item1.textField = field;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]\
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace \
                              target:nil \
                              action:nil];
    item2.textField = field;
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]\
                              initWithTitle:@"Done" \
                              style:UIBarButtonItemStylePlain \
                              target:self \
                              action:@selector(doneInput:)];
    item3.textField =field;
    
    NSArray *items = @[
                       item1,
                       item2,
                       item3
                       ];
    
    [accessoryBar setItems:items];
    field.inputAccessoryView = accessoryBar;
    
    
    
    field.translatesAutoresizingMaskIntoConstraints = NO;
    [field setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    [field setContentHuggingPriority:UILayoutPriorityDefaultLow-1 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 设置  textfield  autolayout
    [backgroundView addConstraints:[NSLayoutConstraint \
                                  constraintsWithVisualFormat:@"H:|[titleLabel]-[field]|" \
                                  options:NSLayoutFormatAlignAllCenterY \
                                  metrics:nil \
                                  views:NSDictionaryOfVariableBindings(titleLabel,field)]];
    [backgroundView addConstraints:[NSLayoutConstraint \
                                   constraintsWithVisualFormat:@"V:|[field]|" \
                                    options:0 metrics:nil views:NSDictionaryOfVariableBindings(field)]];
    
    
    
    // 返回 textfiled 和 text field background view .
    [textFieldDic setObject:backgroundView forKey:kTextFieldBackGround];
    [textFieldDic setObject:field forKey:kTextField];
    
    return [textFieldDic copy];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.textInfoNameLabel.text = @"text %@";
    self.textField.text = @"";
    self.textField.enabled = YES;
    self.sizeField.enabled = YES;
    self.sizeField.text = @"";
    self.submitImageView.image = self.submitImageDic[kUnsubmitImage];
    
    _indexPath = nil;
    _inputTextInfo  = nil;

    
}
#pragma mark - Action.
-(IBAction)canncelInput:(UIBarButtonItem*)sender{
    [sender.textField resignFirstResponder];
}

-(IBAction)doneInput:(UIBarButtonItem*)sender{
    [sender.textField resignFirstResponder];

}

-(IBAction)editDidChange:(UITextField*)sender{
  
    if ([sender isText]) {
        _inputTextInfo.text = sender.text;
    }else{
        _inputTextInfo.textSize = [sender.text integerValue];
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *numberOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *checkedSet = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL isAvailable = [numberOnly isSupersetOfSet:checkedSet];
    return isAvailable;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.sizeField) {
        if (self.sizeField.text.length == 0) {
            return;
        }
        
        NSInteger number = [self.sizeField.text integerValue];
        if (number < 23 ) {
            self.inputTextInfo.textSize = 23;
            self.sizeField.text = [NSString stringWithFormat:@"23"];
        }
        
        if (number > 99) {
            
            self.inputTextInfo.textSize = 99;
            self.sizeField.text = [NSString stringWithFormat:@"99"];
        }
    }
}

#pragma mark - Open API
@synthesize inputTextInfo = _inputTextInfo;
-(InputTextInfo *)inputTextInfo{
    
    _inputTextInfo.text = self.textField.text;
    _inputTextInfo.textSize = [self.sizeField.text integerValue];
    
    return _inputTextInfo;
}

-(void)setInputTextInfo:(InputTextInfo *)inputTextInfo{
    if (inputTextInfo) {
        _inputTextInfo = inputTextInfo;
        
        self.textField.text = inputTextInfo.text;
        if (inputTextInfo.textSize >= 23) {
            self.sizeField.text = [NSString stringWithFormat:@"%ld", inputTextInfo.textSize];
        }

        self.submitImageView.image = inputTextInfo.isSubmited ? self.submitImageDic[kSubmitedImage]: self.submitImageDic[kUnsubmitImage];
    }
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    self.textInfoNameLabel.text = [NSString stringWithFormat:@"text %ld",(long)indexPath.row];
}

-(void)submitTextInfos{
    // if text field and size field both already input infomation,
    // enable input data. and change submited mask.
    // if not enable submit and show an alert massage.
    if (_textField.text.length > 0 && _sizeField.text.length > 0) {
        _textField.enabled =  NO;
        _sizeField.enabled = NO;
        _submitImageView.image = _submitImageDic[kSubmitedImage];
        
        self.inputTextInfo.submited = YES;
        
    }else{
        [self showAlertMassageTitile:@"Cannot Submit!" massage:@""];
    }
}
-(void)reEditTextInfos{
    _textField.enabled = YES;
    _sizeField.enabled = YES;
    _submitImageView.image = _submitImageDic[kUnsubmitImage];
    
    self.inputTextInfo.submited = NO;
}

-(void)resignAllFirstResponder{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];

    }
    if ([self.sizeField isFirstResponder]) {
        [self.sizeField resignFirstResponder];
    }
}
@end
