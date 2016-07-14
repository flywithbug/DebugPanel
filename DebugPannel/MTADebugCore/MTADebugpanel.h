//
//  MTADebugpanel.h
//  Artist
//
//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTADebugModel.h"

typedef void (^MTADebugErrorBlock)(NSString *errMsg);


@interface MTADebugpanel : NSObject

//初始化单例
+(instancetype)shareInstance;

/**
 *  @author Jack, 16-07-11 15:07:48
 *
 *  调试方法列表配置
 *
 *  @param start      是否开启调试按钮
 *  @param arrlist    数组元素必须是 MTADebugModel
 *  @param errorBlock 检查传入数据是否符号要求
 */
- (void)startDebugBar:(BOOL)start methodModels:(NSArray<MTADebugModel*> *)arrlist error:(MTADebugErrorBlock)errorBlock;
- (void)startDebugBar:(BOOL)start methodModels:(NSArray<MTADebugModel*> *)arrlist;
- (void)startDebugBar:(BOOL)start;

/**
 *  @author Jack, 16-07-12 17:07:38
 *
 *  添加新的测试方法
 *
 *  @param arrlist 方法 model list
 */
- (void)addMethodModels:(NSArray<MTADebugModel*> *)arrlist;


@end
