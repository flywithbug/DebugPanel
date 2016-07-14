//
//  AppDelegate.m
//  DebugPannel
//
//  Created by Jack on 16/7/14.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "AppDelegate.h"
#import "MTADebugpanel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self performSelector:@selector(doJobsAfterFinishLaunching) withObject:nil afterDelay:0];
    return YES;
}

- (void)doJobsAfterFinishLaunching
{
    NSMutableArray *arrlist = [NSMutableArray array];
    
    MTADebugModel *item = [[MTADebugModel alloc]init];
    item.title = @"一键线上";
    item.selectorProperty = @"changeOnlineServer";
    item.etc = @{@"host":@"http://www.baidu.com"};
    [arrlist addObject:item];
    
    item = [[MTADebugModel alloc]init];
    item.title = @"一键测试";
    item.selectorProperty = @"changeTestServer";
    item.etc = @{@"host":@"http://www.sohu.com"};
    [arrlist addObject:item];
    
    item = [[MTADebugModel alloc]init];
    item.title = @"调试面板";
    item.selectorProperty = @"showDebugPanel";
    //    item.etc = @{@"a":@"b"};
    [arrlist addObject:item];
    
    item = [[MTADebugModel alloc]init];
    item.title = @"打开 URL";
    item.selectorProperty = @"OpenSchemeURL";
    //    item.etc = @{@"c":@"d"};
    [arrlist addObject:item];
    
    [[MTADebugpanel shareInstance]startDebugBar:YES methodModels:arrlist error:^(NSString *errMsg) {
        NSLog(@"%@",errMsg);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
