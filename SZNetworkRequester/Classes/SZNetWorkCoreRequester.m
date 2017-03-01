//
//  SZNetWorkCoreRequester.m
//  SZNetWorkRequester
//
//  Created by Stella on 15/7/15.
//  Copyright (c) 2015年 sunzhuo11. All rights reserved.
//

#import "SZNetWorkCoreRequester.h"

@implementation SZNetWorkCoreRequester

-(instancetype)init{
    if(self = [super init]){
        self.sessionManager = [AFHTTPSessionManager manager];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

-(AFHTTPRequestOperation *)send:(SZBaseForm *)form parserClass:(Class)sourceClass completion:(void (^)(id responseObject, NSError *error))block {
    if (form == nil){
        form = [[SZBaseForm alloc] init];
    }
    
    NSString *requestUrl = [form.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    void (^successBlock)(AFHTTPRequestOperation * __unused task, id responseObject)=^(AFHTTPRequestOperation * __unused task, id responseObject){
        NSLog(@"request:%@",task.request.URL);
        // 如果是xml或者json格式
        if([responseObject isKindOfClass:[NSXMLParser class]] || [responseObject isKindOfClass:[NSDictionary class]]){
            id dataBaseResult = [self parseDataWith:responseObject ResponseString:task.responseString Form:form parserClass:sourceClass];
            if (block){
                block(dataBaseResult, nil);
            }
        }else {
            if (block){
                block(responseObject, nil);
            }
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *__unused task, NSError *error) = ^(AFHTTPRequestOperation *__unused task, NSError *error) {
        NSLog(@"error request:%@",task.request.URL);
        if (block){
            block(nil, error);
        }
    };
    
    void (^fileBlock)(id<AFMultipartFormData> formData) =  ^(id<AFMultipartFormData> formData){
        if ( form.fileInfo ) {
            [formData appendPartWithFileData:form.fileInfo.content name:form.fileInfo.name fileName:form.fileInfo.fileName mimeType:form.fileInfo.mimeType];
        }
    };
    
    // 设置可接收的头类型
    [self setAcceptableContentTypesForForm:form];
    // 设置超时时间
    [self setTimeOutInterval];
    if([form givenRequest].isGet){
        return [self.requestOperationManager GET:requestUrl parameters:[form givenDict] success:successBlock failure:failureBlock];
    }else{
        return [self.requestOperationManager POST:requestUrl parameters:[form givenDict] constructingBodyWithBlock:fileBlock success:successBlock failure:failureBlock];
    }
}

-(id)parseDataWith:(id)responseObject ResponseString:(NSString *)responseString Form:(SZBaseForm *)form parserClass:(Class)sourceClass{
    NSDictionary *objectDict = responseObject;
    if (JSON == form.requestInfo.responseType) {
        objectDict = [responseObject objectForKey:@"data"];
    }
    return [sourceClass objectWithKeyValues:objectDict];
}

-(void)setTimeOutInterval{
    // 设置超时时间
    [self.requestOperationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestOperationManager.requestSerializer.timeoutInterval =TIMEOUT_INTERVAL;
    [self.requestOperationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

-(void)setAcceptableContentTypesForForm:(SZBaseForm *)form{
    self.requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestOperationManager.responseSerializer.acceptableContentTypes = [self.requestOperationManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain", @"application/json", nil]];
}

-(void)cancel{
    [self.requestOperationManager.operationQueue cancelAllOperations];
    //    [self.loadingView hideLoadingViewOnController:self.target];
}

@end
