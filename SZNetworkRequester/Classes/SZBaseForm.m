//
//  SZBaseForm.m
//  Wardrobe
//
//  Created by Perry on 15/1/16.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import <objc/runtime.h>

#import "SZBaseForm.h"

@interface SZBaseForm()

@property(nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation SZBaseForm

-(instancetype)init
{
    if(self = [super init]){
        _parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString *)url {
    return @"";
}

-(NSString *)method {
    return SZDataRequestMethodGet;
}

-(NSString *)userHandledCodes {
    return @[];
}

-(void)buildParametes{
    [_parameters removeAllObjects];
    [self itemRuntimeProperties:[self class]];
}

-(void)itemRuntimeProperties:(Class)clazz
{
    if (clazz != [SZBaseForm class]){
        [self itemRuntimeProperties:class_getSuperclass(clazz)];
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [self valueForKey:propName];
        
        if([@"parameters" isEqualToString:propName] || [@"request" isEqualToString:propName]) {
            continue;
        }
        
        if(value){
            [_parameters setObject:value forKey:propName];
        }
    }
    
    free(properties);
}

@end
