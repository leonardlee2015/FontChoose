//
//  UIImage+BitMap.m
//  FontChoose
//
//  Created by 李南 on 15/12/8.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "UIImage+BitMap.h"

@implementation UIImage (BitMap)
+(UIImage *)imageNamed:(NSString *)name size:(CGSize)size{
    // get source image from bundle.
    UIImage *sourceImage = [UIImage imageNamed:name];
    // get bitmap image with sipecified size.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *destinationImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return destinationImage;
}

+(UIImage *)ovalImageBySize:(CGSize)size color:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [color set];
    // 根据size 绘制一个bezier path.
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    [path addClip];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)dashLineAddImageBySize:(CGSize)size{
    // 获取最短边
    CGFloat shortWidth = size.width<size.height?size.width:size.height;
    
    // 绘图
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat pattern[] = {2,2,2,2,2,2,2,2};
    [path setLineDash:pattern count:8 phase:0];
    path.lineWidth = 2;
    
    CGFloat halfWidth = path.lineWidth/2;
    
    // 绘制虚线边框
    [path moveToPoint:CGPointMake(halfWidth, halfWidth)];
    [path addLineToPoint:CGPointMake(halfWidth+shortWidth/3, halfWidth)];
    [path moveToPoint:CGPointMake(halfWidth, halfWidth)];
    [path addLineToPoint:CGPointMake(halfWidth, shortWidth/3+halfWidth)];
    
    [path moveToPoint:CGPointMake(size.width-halfWidth, halfWidth)];
    [path addLineToPoint:CGPointMake(size.width-halfWidth-shortWidth/3, halfWidth)];
    [path moveToPoint:CGPointMake(size.width-halfWidth, halfWidth)];
    [path addLineToPoint:CGPointMake(size.width-halfWidth, shortWidth/3+halfWidth)];
    
    [path moveToPoint:CGPointMake(halfWidth, size.height-halfWidth)];
    [path addLineToPoint:CGPointMake(halfWidth, size.height-halfWidth-shortWidth/3)];
    [path moveToPoint:CGPointMake(halfWidth, size.height-halfWidth)];
    [path addLineToPoint:CGPointMake(halfWidth+shortWidth/3, size.height-halfWidth)];
    
    [path moveToPoint:CGPointMake(size.width-halfWidth, size.height-halfWidth)];
    [path addLineToPoint:CGPointMake(size.width-halfWidth-shortWidth/3, size.height-halfWidth)];
    [path moveToPoint:CGPointMake(size.width-halfWidth, size.height-halfWidth)];
    [path addLineToPoint:CGPointMake(size.width-halfWidth, size.height-halfWidth-shortWidth/3)];
    
    //  绘制虚线加号
    [path moveToPoint:CGPointMake(size.width/2, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width/2, size.height/2 - shortWidth/3)];
    [path moveToPoint:CGPointMake(size.width/2, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width/2, size.height/2 + shortWidth/3)];
    [path moveToPoint:CGPointMake(size.width/2, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width/2 - shortWidth/3, size.height/2)];
    [path moveToPoint:CGPointMake(size.width/2, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width/2 + shortWidth/3, size.height/2)];
    
    //  绘制image.
    [[UIColor lightGrayColor]setStroke];
    [path stroke];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
