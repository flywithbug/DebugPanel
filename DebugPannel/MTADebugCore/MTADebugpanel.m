//
//  MTADebugpanel.m
//  Artist
//
//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import "MTADebugpanel.h"
#import "MTADebugBar.h"

NSString *const errorMessage = @"数据模型不正确,请检查传入的数据模型是否为 MTADebugModel 模式";

@interface MTADebugpanel ()
@property (nonatomic, strong)  MTADebugBar *debugBar;
@property (nonatomic, copy)MTADebugErrorBlock block;
@property (nonatomic, strong) NSMutableArray *mutArrlist;
@end

@implementation MTADebugpanel

+(instancetype)shareInstance
{
    static MTADebugpanel *share;
    static dispatch_once_t onceFlag;
    dispatch_once(&onceFlag, ^{
        share = [MTADebugpanel new];
        share.mutArrlist = [NSMutableArray array];
    });
    return share;
}


- (void)startDebugBar:(BOOL)start
{
    if (start) {
        self.debugBar = [[MTADebugBar alloc]init];
    }
    else
    {
        self.debugBar = nil;
    }
    
}
- (void)startDebugBar:(BOOL)start methodModels:(NSArray *)arrlist;
{
    [self startDebugBar:start];
    [self addMethodModels:arrlist];
}

// 是否显示调试按钮
- (void)startDebugBar:(BOOL)start methodModels:(NSArray<MTADebugModel *> *)arrlist error:(MTADebugErrorBlock)errorBlock
{
    self.block = [errorBlock copy];
    [self startDebugBar:start methodModels:arrlist];
}

- (void)addMethodModels:(NSArray<MTADebugModel*> *)arrlist
{
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        __strong __typeof(self) strongSelf = weakSelf;

        for (id obj in arrlist) {
            if (![obj isKindOfClass:[MTADebugModel class]]) {
                if (strongSelf.block) {
                    strongSelf.block(errorMessage);
                }
                return ;
            }
        }
        [self.mutArrlist addObjectsFromArray:arrlist];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.debugBar setConetenDateWithBlock:^NSArray *{
                __strong __typeof(self) strongSelf = weakSelf;
                return [strongSelf.mutArrlist copy];
            }];
        });
        
    });
}

@end


