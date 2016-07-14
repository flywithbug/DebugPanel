//
//  MTADebugModel.h
//
//  Created by   on 16/7/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  @author Jack, 16-07-14 12:07:12
 *
 *  title: 显示名称
 *  selectorProperty: 调用的方法签名
 *  etc: 额外参数
 */
@interface MTADebugModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *etc;
@property (nonatomic, strong) NSString *selectorProperty;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;



+ (NSArray *)formatDefaultData;

@end
