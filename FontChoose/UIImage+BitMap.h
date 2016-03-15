//
//  UIImage+BitMap.h
//  FontChoose
//
//  Created by 李南 on 15/12/8.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BitMap)
/**
 *  @brief  get a image with specified size.
 *
 *  @param name image name.
 *  @param size size of image.
 *
 *  @return an image having specified name by the size wo giving. 
 */
+(UIImage*)imageNamed:(NSString *)name size:(CGSize)size;
/**
 *  @brief  create an oval image by the specified size and color
 *
 *  @param size  size for the oval
 *  @param color color for the oval.
 *
 *  @return an oval image.
 */
+(UIImage*)ovalImageBySize:(CGSize)size color:(UIColor*)color;
/**
 *  @brief  create an dash line add image.
 *
 *  @param size size of the image.
 *
 *  @return dash line add image by specified size.
 */
+(UIImage*)dashLineAddImageBySize:(CGSize)size;
/**
 *  @brief  get image with specified time color.
 *
 *  @param tintColor the tint color of destination image.
 *
 *  @return image with specified time color.
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
/**
 *  @brief  get image with specified time color and 
 *  retain source image's gradient
 *
 *  @param tintColor the tint color of destination image.
 *
 *  @return image with specified time color.
 */
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
