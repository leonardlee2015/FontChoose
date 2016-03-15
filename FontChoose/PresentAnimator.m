//
//  PresentAnimator.m
//  FontChoose
//
//  Created by 李南 on 15/12/7.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "PresentAnimator.h"
#import "UIColor+CustomColor.h"
#import "UIView+SetRect.h"
#import <pop/POP.h>

@implementation PresentAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIView *containerView = transitionContext.containerView;
    // 添加半透明遮罩
    UIView *dimissView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    dimissView.backgroundColor = [UIColor customGrayColor];
    dimissView.tag = 10001;
    
    dimissView.alpha = 0.f;
    [containerView addSubview:dimissView];
    
    // 修改presention view.
    UIView *toView  = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.frame = CGRectInset(toView.frame,52.f, 144.f);
    //toView.transform = CGAffineTransformMakeScale(0, 0);
    toView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:toView];
    
    POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)];
    scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)];
    [scaleAnim setCompletionBlock:^(POPAnimation *anim, BOOL completion) {
        [transitionContext completeTransition:completion];
    }];
    scaleAnim.springBounciness = 10;
    scaleAnim.springSpeed = 6;
    
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(0.5);
    alphaAnim.duration = [self transitionDuration:transitionContext];
    

    
    [toView pop_addAnimation:scaleAnim forKey:nil];
    
    [dimissView pop_addAnimation:alphaAnim forKey:nil];

    
}
@end
