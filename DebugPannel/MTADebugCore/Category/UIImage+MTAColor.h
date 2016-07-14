
//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MTAColor)

+ (UIImage *)imageMTAWithColor:(UIColor *)color;
+ (UIImage *)imageMTAWithColor:(UIColor *)color path:(UIBezierPath *)path;
+ (UIImage *)imageMTAWithColor:(UIColor *)color size:(CGSize )size cornerRadius:(CGFloat)cornerRadius;

@end
