//
//  MTADebugBar.h
//  Artist
//
//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTADebugModel.h"



/**
 *  @author Jack, 16-07-11 14:07:50
 *
 *  debugBar 的数据源
 *
 *  @param arrlist MTADebugModel 格式的数据
 */
typedef NSArray<MTADebugModel *> * (^MTADebugDataSourceBlock)();

@interface MTADebugBar : UIWindow
- (void)setConetenDateWithBlock:(MTADebugDataSourceBlock) block;
@end
