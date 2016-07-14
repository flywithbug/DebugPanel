//
//  MTADebugModel.m
//
//  Created by   on 16/7/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MTADebugModel.h"


NSString *const kMTADebugModelTitle = @"title";
NSString *const kMTADebugModelEtc = @"etc";
NSString *const kMTADebugModelSelector = @"selector";


@interface MTADebugModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MTADebugModel

@synthesize title = _title;
@synthesize etc = _etc;
@synthesize selectorProperty = _selectorProperty;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.title = [self objectOrNilForKey:kMTADebugModelTitle fromDictionary:dict];
            self.etc = [self objectOrNilForKey:kMTADebugModelEtc fromDictionary:dict];
            self.selectorProperty = [self objectOrNilForKey:kMTADebugModelSelector fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kMTADebugModelTitle];
    [mutableDict setValue:self.etc forKey:kMTADebugModelEtc];
    [mutableDict setValue:self.selectorProperty forKey:kMTADebugModelSelector];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.title = [aDecoder decodeObjectForKey:kMTADebugModelTitle];
    self.etc = [aDecoder decodeObjectForKey:kMTADebugModelEtc];
    self.selectorProperty = [aDecoder decodeObjectForKey:kMTADebugModelSelector];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_title forKey:kMTADebugModelTitle];
    [aCoder encodeObject:_etc forKey:kMTADebugModelEtc];
    [aCoder encodeObject:_selectorProperty forKey:kMTADebugModelSelector];
}

- (id)copyWithZone:(NSZone *)zone
{
    MTADebugModel *copy = [[MTADebugModel alloc] init];
    
    if (copy) {

        copy.title = [self.title copyWithZone:zone];
        copy.etc = [self.etc copyWithZone:zone];
        copy.selectorProperty = [self.selectorProperty copyWithZone:zone];
    }
    
    return copy;
}


+ (NSArray *)formatDefaultData
{
    NSMutableArray *arrlist = [NSMutableArray array];
    return arrlist;
}


@end
