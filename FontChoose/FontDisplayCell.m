//
//  FontDisplayCell.m
//  FontChoose
//
//  Created by 李南 on 15/12/3.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "FontDisplayCell.h"
#import "TextInfos.h"
#import "NSObject+AlertMassage.h"
#import "UIImage+BitMap.h"
#import "UIView+SetRect.h"
#import "NSString+multiRanges.h"
#import "NSMutableAttributedString+setAttributes.h"
#import "UIColor+CustomColor.h"


//#define TEST
@implementation cellEntity

@end

@interface FontDisplayCell ()
@property (weak, nonatomic) IBOutlet UILabel *fontNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textDIsplayedLabel;
@property (weak, nonatomic) IBOutlet UIView *textContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ContainerVIewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewVerticalConstraint;
@property (nonatomic,strong) NSArray<NSLayoutConstraint*>*scrollViewHAxisConstraints;

@property (nonatomic,assign)NSInteger currentFontSize;
@property (nonatomic,strong,nonnull)NSString *currentFontName;
@property (weak,nonatomic) TextInfos *textInfos;
@end
@implementation FontDisplayCell
#pragma mark - Initialization Mathods
- (void)awakeFromNib {
    // Initialization code
    
}

-(void)configCellByEntity:(cellEntity *)entity{
    self.currentFontName = entity.currentFontName;
    self.currentFontSize = entity.currentSize;
    self.textInfos = entity.textInfos;
    
    // 如果fontSearchStrs不为空(search mode)，font name 对应search段背景色变成黄色。
    if (entity.fontSearchStrs && entity.fontSearchStrs.count > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:entity.currentFontName];
        [str addAttributes:@{\
                             NSFontAttributeName:[UIFont systemFontOfSize:13]\
                             } \
                     range:NSMakeRange(0, str.length)];
        
        [entity.fontSearchStrs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray* ranges = [entity.currentFontName rangesOfString:obj];
            
            [str setBackgroudColor:[UIColor customYellowColor] ranges:ranges];
        }];
        
        self.fontNameLabel.attributedText = [str copy];
    }
    
    [self reloadContainerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadContainerView{

    //  清除旧的约束和子视图
    [self.textContainerView removeConstraints:self.textContainerView.constraints];
    //self.textContainerView.translatesAutoresizingMaskIntoConstraints =NO;
    [self.textContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    // 绘制新的子view和约束
    // 当textInfos为空，使用 字体名字作为text
    if (self.textInfos.count==0) {
        UIButton *buttun = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttun setBackgroundColor:[UIColor clearColor]];
        buttun.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:self.currentFontName attributes:@{NSFontAttributeName:[UIFont fontWithName:self.currentFontName size:self.currentFontSize]}];
        [buttun setAttributedTitle:str forState:UIControlStateNormal];
        [buttun addTarget:self action:@selector(selectedHolderButton:) forControlEvents:UIControlEventTouchUpInside];
        buttun.titleLabel.numberOfLines = 1;
        
        [self.textContainerView addSubview:buttun];
        //[self addConstraintToSigleSubView:buttun];
        [self setSubviewsConstaintsOfView:self.textContainerView];

        
    }else{
        for (NSInteger i=0; i<self.textInfos.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.titleLabel.numberOfLines = 1;
            // 当前被选择比对的 label 背景为白色，其他背景色为透明。
            if (self.textInfos.currentIndex == i) {
                [button setBackgroundColor:[UIColor colorWithIntRed:255 green:228 blue:49 alpha:1.f]];
            
            }else{
                [button setBackgroundColor:[UIColor clearColor]];
            }
            
            [button addTarget:self action:@selector(selectedTextButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //  select correct attributes of text in current view.
            NSDictionary *atrributedDic;
            if (TextInfoStateDesignated != [self.textInfos designationStateOfIndex:i]) {
                atrributedDic = @{
                                  NSFontAttributeName:[UIFont fontWithName:self.currentFontName size:[self.textInfos sizeOfIndex:i]]
                                  };
                
            }else{
                atrributedDic = @{
                                  NSFontAttributeName:[UIFont fontWithName:[self.textInfos fontNameOfIndex:i] size:[self.textInfos sizeOfIndex:i]]
                                  };
                
            }
            NSString *text = [self.textInfos textOfIndex:i];
            NSAttributedString *str = [[NSAttributedString alloc]initWithString:text  attributes:atrributedDic];
            [button setAttributedTitle:str forState:UIControlStateNormal];
            [self.textContainerView addSubview:button];
            
            
        }
        
        
        
        //  设置 holder view.
        UIButton *lastButton = self.textContainerView.subviews.lastObject;
        lastButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        CGSize imageSize = CGSizeMake(60, lastButton.intrinsicContentSize.height);
        [button setBackgroundImage:[UIImage dashLineAddImageBySize:imageSize] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedHolderButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.textContainerView addSubview:button];
        
        [self setSubviewsConstaintsOfView:self.textContainerView];
        
    }
    
    
    // 修改 container scroll view 和 text container view Horizontial constraints.
    
    [self setContainterViewWidthConstraint];
    
}

-(void)setSubviewsConstaintsOfView:(UIView* _Nonnull)view{
    NSArray<UIButton*> *subViews = view.subviews;
    
    //  获取最高子视图指针和高度
    __block NSInteger maxHeight = 0;
    __block NSInteger HighestIndex = 0;
    [subViews enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.intrinsicContentSize.height > maxHeight) {
            maxHeight = obj.intrinsicContentSize.height;
            HighestIndex = idx;
        }
    }];
    
    for (int i=0; i < subViews.count; i++) {
        // 设置水平方向约束
        // 第一个视图，设置leading 约束
        // 最后一个视图，设置trailing 约束，且不为唯一子视图时 设置  leading 和前一视图 trailing 的距离约束。
        // 中间视图，设置  leading 和前一视图 trailing 的距离约束。
        if (0 == i) {
            [view addConstraint:[NSLayoutConstraint\
                                                  constraintWithItem:subViews[i]\
                                                  attribute:NSLayoutAttributeLeading\
                                                  relatedBy:NSLayoutRelationEqual\
                                                  toItem:view\
                                                  attribute:NSLayoutAttributeLeading\
                                                  multiplier:1.f\
                                                   constant:0]];
        }
        if ((subViews.count-1) == i){
            [view addConstraint:[NSLayoutConstraint\
                                                  constraintWithItem:subViews[i]\
                                                  attribute:NSLayoutAttributeTrailing\
                                                  relatedBy:NSLayoutRelationEqual\
                                                  toItem:view\
                                                  attribute:NSLayoutAttributeTrailing\
                                                  multiplier:1.f\
                                                   constant:0]];

            
        }
        if ((i > 0) && (subViews.count > 1)) {
            [view addConstraint:[NSLayoutConstraint\
                                                   constraintWithItem:subViews[i] \
                                                   attribute:NSLayoutAttributeLeading\
                                                   relatedBy:NSLayoutRelationEqual\
                                                   toItem:subViews[i-1]\
                                                   attribute:NSLayoutAttributeTrailing\
                                                   multiplier:1.f\
                                                   constant:0]];
        }
        
        // 设置垂直方向约束
        // 最高视图设置 与父视图 top，bottom约束
        // 其他视图设置与最高视图 bottom约束
        if (HighestIndex == i) {
            [view addConstraint:[NSLayoutConstraint\
                                constraintWithItem:subViews[i] \
                                attribute:NSLayoutAttributeTop\
                                relatedBy:NSLayoutRelationEqual\
                                toItem:view\
                                attribute:NSLayoutAttributeTop\
                                multiplier:1.f\
                                 constant:0]];
            [view addConstraint:[NSLayoutConstraint \
                                constraintWithItem:subViews[i] \
                                attribute:NSLayoutAttributeBottom\
                                relatedBy:NSLayoutRelationEqual\
                                toItem:view\
                                attribute:NSLayoutAttributeBottom\
                                multiplier:1.f\
                                 constant:0]];
        }else{
            [view addConstraint:[NSLayoutConstraint\
                                constraintWithItem:subViews[i]\
                                attribute:NSLayoutAttributeCenterY\
                                relatedBy:NSLayoutRelationEqual\
                                toItem:subViews[HighestIndex]\
                                attribute:NSLayoutAttributeCenterY\
                                multiplier:1.f\
                                 constant:0]];
        }
        
        
    }
}

-(void)setContainterViewWidthConstraint{
    
    // remove all text container view width constraint and scroll view
    // horizontial constraints before operations.
    [self.containerScrollView removeConstraint:self.ContainerVIewWidthConstraint];
    self.ContainerVIewWidthConstraint = nil;
    
    if (self.scrollViewHAxisConstraints.count > 0) {
        [self.contentView removeConstraints:self.scrollViewHAxisConstraints];
        self.scrollViewHAxisConstraints = nil;
        
    }
    if (self.scrollViewVerticalConstraint) {
        [self.contentView removeConstraint:self.scrollViewVerticalConstraint];
        self.scrollViewVerticalConstraint = nil;
    }
    // 获取textContainerView 所有子views的intrinsic 宽度。
    NSArray <UIButton*> *subButton = self.textContainerView.subviews;
    __block CGFloat intrinsicWidth = 0.f;
    
    CGFloat intrinsicWidth2 = 0.f;
    [subButton enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        intrinsicWidth += obj.intrinsicContentSize.width;
        
    }];
    
    for (UIButton* button in subButton) {
        intrinsicWidth2 += button.intrinsicContentSize.width;
    }
    
    // if intrinsicWidth bigger than contentView with - 16
    
    if (intrinsicWidth >= (self.contentView.width - 2 *8)) {
        self.scrollViewHAxisConstraints = [NSLayoutConstraint\
                                           constraintsWithVisualFormat:@"|-[scrollView]-|" options:0\
                                           metrics:nil\
                                           views:@{@"scrollView":self.containerScrollView}];
        [self.contentView addConstraints:self.scrollViewHAxisConstraints];
        
        //CGFloat multiplier = (intrinsicWidth/*+ 30*subButton.count*/) / (self.contentView.width - 2 * 8);
        
        CGFloat multiplier =  (self.contentView.width - 2 * 8)/(intrinsicWidth/*+ 30*subButton.count*/) ;
        self.ContainerVIewWidthConstraint = [NSLayoutConstraint \
                                             constraintWithItem:self.containerScrollView \
                                             attribute:NSLayoutAttributeWidth\
                                             relatedBy:NSLayoutRelationEqual\
                                             toItem:self.textContainerView\
                                             attribute:NSLayoutAttributeWidth\
                                             multiplier: multiplier\
                                             constant:0];
        [self.containerScrollView addConstraint:self.ContainerVIewWidthConstraint];
    
    }else{
        self.scrollViewVerticalConstraint = [NSLayoutConstraint\
                                             constraintWithItem:self.containerScrollView\
                                             attribute:NSLayoutAttributeCenterX\
                                             relatedBy:NSLayoutRelationEqual\
                                             toItem:self.contentView\
                                             attribute:NSLayoutAttributeCenterX\
                                             multiplier:1.f\
                                             constant:0];
        [self.contentView addConstraint:self.scrollViewVerticalConstraint];
        
        self.ContainerVIewWidthConstraint = [NSLayoutConstraint \
                                             constraintWithItem:self.textContainerView\
                                             attribute:NSLayoutAttributeWidth\
                                             relatedBy:NSLayoutRelationEqual\
                                             toItem:self.containerScrollView\
                                             attribute:NSLayoutAttributeWidth\
                                             multiplier:1.f\
                                             constant:0];
        
        [self.containerScrollView addConstraint:self.ContainerVIewWidthConstraint];
        
        
    }

}

-(IBAction)selectedTextButton:(UIButton*)sender{
    NSInteger index = [self.textContainerView.subviews indexOfObject:sender];
    // 修改button背景颜色 当前白色，其他背景颜色为透明。
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    [self.textContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sender != obj ) {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
    
    // 修改mode state.
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayCell:didSelectedTextView:ofIndex:)]) {
        [self.delegate displayCell:self didSelectedTextView:sender ofIndex:index];
    }
}

-(IBAction)selectedHolderButton:(UIButton*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayCell:didSelectedHoldlerView:ofIndex:)]) {
        [self.delegate displayCell:self didSelectedHoldlerView:sender ofIndex:0];
    }
}
#pragma mark - Properties setter and getter
@synthesize currentFontSize = _currentFontSize;
@dynamic delegate;
-(NSInteger)currentFontSize{
    if (_currentFontSize<=0) {
        _currentFontSize = 23;
    }
    return _currentFontSize;
}
-(void)setCurrentFontSize:(NSInteger)currentFontSize{
    if (_currentFontSize>0 && _currentFontSize<100) {
        _currentFontSize = currentFontSize;
    }
    else{
        //[self showAlertMassageTitile:@"Wrong Input" massage:@"current font size must in 1 ~99"];
    }
}

-(void)setCurrentFontName:(NSString *)currentFontName{
    _currentFontName = currentFontName;
    self.fontNameLabel.text = currentFontName;
}


-(NSArray<NSLayoutConstraint *> *)scrollViewHAxisConstraints{
    if (!_scrollViewHAxisConstraints) {
        _scrollViewHAxisConstraints = [NSArray array];
    }
    return _scrollViewHAxisConstraints;
}

#ifdef OLD
-(void)setDisplayedSize:(NSInteger )displayedSize{
    if (displayedSize < 23) {
        _displayedSize = 23;
        
    }else{
        
        _displayedSize = displayedSize;
    }
    [self setTextDIsplayedLabelFont];
}
-(NSInteger)displayedSize{
    if (!_displayedSize) {
        _displayedSize = 23;
    }
    return _displayedSize;
    
}

-(void)setFontName:(NSString *)fontName{
    _fontName = fontName;
    self.fontNameLabel.text = self.fontName;
    
    if (!self.displayedText || self.displayedText.length==0) {
        self.textDIsplayedLabel.text = _fontName;
    
    }
    [self setTextDIsplayedLabelFont];
    
}

-(void)setDisplayedText:(NSString *)displayedText{
    _displayedText = displayedText;
    
    if (_displayedText.length==0 && self.fontName.length>0) {
        self.textDIsplayedLabel.text = self.fontName;
    }
    else{
        self.textDIsplayedLabel.text = _displayedText;
    
    
    }
}

-(void)setTextDIsplayedLabelFont{
    UIFont *font;
    if (self.fontName) {
        font = [UIFont fontWithName:self.fontName size:self.displayedSize];
    }
    if (!font) {
        font = [UIFont systemFontOfSize:self.displayedSize];
    }
    
    self.textDIsplayedLabel.font = font;
}
#endif

@end
