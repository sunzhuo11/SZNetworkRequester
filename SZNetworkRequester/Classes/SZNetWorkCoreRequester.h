//
//  SZNetWorkCoreRequester.h
//  SZNetWorkRequester
//
//  Created by Stella on 15/7/15.
//  Copyright (c) 2015年 sunzhuo11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SZBaseForm.h"

@interface SZNetWorkCoreRequester : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

-(AFHTTPRequestOperation *)send:(SZBaseForm *)form parserClass:(Class)sourceClass completion:(void (^)(id responseObject, NSError *error))block;

-(void)cancel;

@end
