//
//  MTADebugMethodBridge.h
//  Artist
//
//  Created by Jack on 16/7/12.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTADebugModel.h"

@interface MTADebugMethodBridge : UITableViewCell

- (BOOL)handleSelectorProperty:(MTADebugModel *)modelProperty;

@end
