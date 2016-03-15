//
//  DimissAnimator.m
//  FontChoose
//
//  Created by 李南 on 15/12/7.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "DimissAnimator.h"
#import <pop/POP.h>
@implementation DimissAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    toView.userInteractionEnabled  = YES;
    [containerView addSubview:toView];
    
    UIView *dimissView = [containerView viewWithTag:10001];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // 执行动画
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.duration = [self transitionDuration:transitionContext];
    alphaAnim.toValue = @(0.f);
    
    POPBasicAnimation *scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnim.duration = [self transitionDuration:transitionContext];
    scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)];
    [scaleAnim setCompletionBlock:^(POPAnimation *anim , BOOL completion) {
        [transitionContext completeTransition:completion];
    }];
    
    [dimissView pop_addAnimation:alphaAnim forKey:nil];
    [fromView pop_addAnimation:scaleAnim forKey:nil ];
    
}
@end
