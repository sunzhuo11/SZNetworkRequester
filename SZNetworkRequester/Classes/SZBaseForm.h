//
//  SZBaseForm.h
//  Wardrobe
//
//  Created by Perry on 15/1/16.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SZDataRequestMethodGet @"GET"
#define SZDataRequestMethodPost @"POST"

@protocol SZRequestProtocol <NSObject>

-(NSString *)url;
-(NSString *)method;
-(NSString *)userHandledCodes;

@end

@interface SZBaseForm : NSObject <SZRequestProtocol>

-(void)buildParametesWithURL:(NSString *)url;
-(void)buildParametes;

@end
