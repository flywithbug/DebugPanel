

//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//


#import "UIImage+MTAColor.h"

@implementation UIImage (MTAColor)

+ (UIImage *)imageMTAWithColor:(UIColor *)color
{
    return [self imageMTAWithColor:color path:nil];
}

+ (UIImage *)imageMTAWithColor:(UIColor *)color path:(UIBezierPath *)path
{
    CGRect rect = CGRectMake(0, 0, 3, 3);
    if (path) {
        rect = path.bounds;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (path) {
        [path fill];
    } else {
        CGContextFillRect(context, rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageMTAWithColor:(UIColor *)color size:(CGSize )size cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    return [self imageMTAWithColor:color path:path];
}

@end
