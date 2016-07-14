//
//  MTADebugMethodBridge.m
//  Artist
//
//  Created by Jack on 16/7/12.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import "MTADebugMethodBridge.h"

@implementation MTADebugMethodBridge

- (BOOL)handleSelectorProperty:(MTADebugModel *)modelProperty
{
    if (modelProperty && modelProperty.title && modelProperty.selectorProperty.length) {
        SEL selector = [self selectorForMethod:modelProperty.selectorProperty];
        if (!selector || ![self respondsToSelector:selector]) {
            return NO;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:modelProperty];
        NSLog(@"%@",modelProperty);
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}



- (SEL)selectorForMethod:(NSString *)method {
    if ([method length] == 0) return nil;
    NSString *objcMethod = [[@"debugapi_" stringByAppendingString:method] stringByAppendingString:@":"];
    return NSSelectorFromString(objcMethod);
}


@end
