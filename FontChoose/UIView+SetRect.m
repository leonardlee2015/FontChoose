//
//  UIView+SetRect.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/1.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "UIView+SetRect.h"

@implementation UIView (SetRect)
-(CGPoint)origin{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)ViewOrigin{
    
    self.frame = CGRectMake(ViewOrigin.x, ViewOrigin.y,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

-(CGSize)size{
    return self.frame.size;
}
-(void)setSize:(CGSize)ViewSize{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), ViewSize.width, ViewSize.height);
}

-(CGFloat)x{
    return self.frame.origin.x;

}
-(void)setX:(CGFloat)viewOriginX{
    
    self.frame = CGRectMake(viewOriginX, self.y, self.width, self.height  );
}

-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)viewOriginY{
    self.frame = CGRectMake(self.x, viewOriginY, self.width, self.height);
    
}

-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)viewSizeWidth{
    self.frame = CGRectMake(self.x, self.y, viewSizeWidth, self.height);
}

-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)viewSizeHeight{
    self.frame = CGRectMake(self.x, self.y, self.width
                            , viewSizeHeight);
}
-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterX:(CGFloat)viewCenterX{
    self.center = CGPointMake(viewCenterX, self.centerY);
}
-(CGFloat)centerY{
    return self.center.y;
}
-(void)setCenterY:(CGFloat)viewCenterY{
    self.center = CGPointMake(self.centerX, viewCenterY);
}
-(CGPoint)boundsCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
