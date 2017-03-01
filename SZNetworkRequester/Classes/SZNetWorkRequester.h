//
//  SZNetWorkRequester.h
//  SZNetWorkRequester
//
//  Created by Stella on 16/1/12.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZNetWorkCoreRequester.h"

#define SYS_ERROR_CODE 10000

@protocol SZReloadProtocol <NSObject>

/**
 重新请求
 */
-(void)reload;

@end

typedef enum UIReferance {
  UIREFERANCE_NOT_ALERT=1, //出错不提示
  UIREFERANCE_ALERT=2, //出错强提示
  
  UIREFERANCE_NOT_LOADING=4, // 不显示加载
  UIREFERANCE_LOADING=8, // 显示加载
  UIREFERANCE_LOADING_FULLSCREEN=16, // 全屏加载
  
  UIREFERANCE_NOTING_WHEN_ALERT=32, // 出错不做任何事情
  UIREFERANCE_RETRY_WHEN_ALERT=64, // 出错重试
  
  UIREFERANCE_BACKGOURND_DEFAULT=(UIREFERANCE_NOT_ALERT|UIREFERANCE_NOT_LOADING|UIREFERANCE_NOTING_WHEN_ALERT),
  UIREFERANCE_FOREGROUND_DEFAULT=(UIREFERANCE_ALERT|UIREFERANCE_LOADING|UIREFERANCE_NOTING_WHEN_ALERT)
} UIReferance;

@interface SZNetWorkRequester : NSObject

-(NSURLSessionDataTask *)send:(SZBaseForm *)form parserClass:(Class)parserClass target:(__weak id<SZReloadProtocol> )target referance:(UIReferance)referance completion:(void (^)(id responseObject, NSError *error))block;

-(void)cancel;

@end
