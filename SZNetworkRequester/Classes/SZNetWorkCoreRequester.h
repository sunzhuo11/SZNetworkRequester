//
//  SZNetWorkCoreRequester.h
//  SZNetWorkRequester
//
//  Created by Stella on 16/7/15.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SZBaseForm.h"

@interface SZNetWorkCoreRequester : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

-(NSURLSessionDataTask *)send:(SZBaseForm *)form parserClass:(Class)sourceClass completion:(void (^)(id responseObject, NSError *error))block;

-(void)cancel;

@end
