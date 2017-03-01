//
//  SZBaseForm.m
//  SZNetWorkRequester
//
//  Created by Stella on 16/1/16.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
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

-(NSMutableDictionary *) parameters {
  return _parameters;
}

-(NSString *)url {
  return @"";
}

-(BOOL)isGet {
  return YES;
}

-(NSArray *)userHandledCodes {
  return @[];
}

-(NSString *)successCode {
  return @"";
}

-(void) encode {
  
}

-(SZFileInfo *)file {
  return nil;
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
    
    if([@"parameters" isEqualToString:propName]) {
      continue;
    }
    
    if(value){
      [_parameters setObject:value forKey:propName];
    }
  }
  
  free(properties);
}

@end
