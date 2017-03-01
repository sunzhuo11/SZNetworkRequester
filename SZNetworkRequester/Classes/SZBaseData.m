//
//  SZBaseData.m
//  Wardrobe
//
//  Created by Perry on 15/1/14.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "SZBaseData.h"

@implementation SZBaseData

@synthesize code;
@synthesize message;

-(id)init{
    if (self = [super init]){
        code = 0;
    }
    return self;
}

@end
