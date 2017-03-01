//
//  SZBaseForm.h
//  SZNetWorkRequester
//
//  Created by Stella on 16/1/16.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZFileInfo.h"

#define SZDataRequestMethodGet @"GET"
#define SZDataRequestMethodPost @"POST"

@protocol SZRequestProtocol <NSObject>

/**
 返回请求地址

 @return 请求地址
 */
-(NSString *)url;


/**
 是否 GET 请求

 @return 请求方式
 */
-(BOOL)isGet;


/**
 获取上传文件信息

 @return 上传文件信息
 */
-(SZFileInfo *)file;

/**
 返回用户自处理 Code 列表

 @return 用户自处理 Code 列表
 */
-(NSArray *)userHandledCodes;


/**
 返回请求成功的错误编码

 @return 请求成功的错误编码
 */
-(NSString *)successCode;

/**
 请求加密方法
 */
-(void) encode;

@end

@interface SZBaseForm : NSObject <SZRequestProtocol>

-(void)buildParametesWithURL:(NSString *)url;
-(void)buildParametes;

-(NSMutableDictionary *) parameters;

@end
