//
//  SZNetWorkCoreRequester.m
//  SZNetWorkRequester
//
//  Created by Stella on 16/7/15.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
//

#import "SZNetWorkCoreRequester.h"
#import <MJExtension/MJExtension.h>

@implementation SZNetWorkCoreRequester

-(instancetype)init{
  if(self = [super init]){
    self.sessionManager = [AFHTTPSessionManager manager];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  }
  return self;
}

-(NSURLSessionDataTask *)send:(SZBaseForm *)form parserClass:(Class)sourceClass completion:(void (^)(id responseObject, NSError *error))block {
  
  if (!form) { form = [[SZBaseForm alloc] init]; }
  
  NSString *requestUrl = [form.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  void (^success)(NSURLSessionDataTask * __unused task, id responseObject)=^(NSURLSessionDataTask * __unused task, id responseObject){
    id dataBaseResult = [sourceClass mj_objectWithKeyValues:responseObject];
    if (block){
      block(dataBaseResult, nil);
    }
  };
  
  void (^failure)(NSURLSessionDataTask *__unused task, NSError *error) = ^(NSURLSessionDataTask *__unused task, NSError *error) {
    if (block){
      block(nil, error);
    }
  };
  
  void (^file)(id<AFMultipartFormData> formData) =  ^(id<AFMultipartFormData> formData){
    if ( form.file ) {
      [formData appendPartWithFileData:form.file.content name:form.file.name fileName:form.file.fileName mimeType:form.file.mimeType];
    }
  };
  
  // 设置可接收的头类型
  [self setAcceptableContentTypesForForm:form];
  // 设置超时时间
  [self setTimeOutInterval];
  if(form.isGet){
    return [self.sessionManager GET:requestUrl parameters:form.parameters success:success failure:failure];
  }else{
    return [self.sessionManager POST:requestUrl parameters:form.parameters constructingBodyWithBlock:file success:success failure:failure];
  }
}

-(void)setTimeOutInterval{
  // 设置超时时间
  [self.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
  self.sessionManager.requestSerializer.timeoutInterval = 60;
  [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

-(void)setAcceptableContentTypesForForm:(SZBaseForm *)form{
  self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
  self.sessionManager.responseSerializer.acceptableContentTypes = [self.sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain", @"application/json", nil]];
}

-(void)cancel{
  [self.sessionManager.operationQueue cancelAllOperations];
}

@end
