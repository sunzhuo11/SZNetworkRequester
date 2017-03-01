//
//  SZNetWorkRequester.m
//  SZNetWorkRequester
//
//  Created by Stella on 16/1/12.
//  Copyright (c) 2016年 sunzhuo11. All rights reserved.
//

#import "SZNetWorkRequester.h"
#import "SVProgressHUD.h"
#import "SZLoadingView.h"
#import "SZBaseData.h"

#define ALERT_RETRY_TAG 1314520

@interface SZNetWorkRequester()

//当前正在请求的个数
@property (atomic) NSInteger requestCount;

@property (nonatomic, weak)id<SZReloadProtocol> target;

@property (nonatomic) SZLoadingView *loadingView;

@property (nonatomic, strong)SZNetWorkCoreRequester *coreRequester;

@end

@implementation SZNetWorkRequester


-(instancetype)init{
  if(self = [super init]){
    self.coreRequester = [[SZNetWorkCoreRequester alloc] init];
    
    self.requestCount = 0;
    
    self.loadingView = [[SZLoadingView alloc] init];
  }
  return self;
}

-(NSURLSessionDataTask *)send:(SZBaseForm *)form parserClass:(Class)parserClass target:(__weak id<SZReloadProtocol> )target referance:(UIReferance)referance completion:(void (^)(id responseObject, NSError *error))block
{
  self.target = target;
  
  // 显示加载框
  [self beginLoadingWithReferance:referance target:target];
  
  return [self.coreRequester send:form parserClass:parserClass completion:^(id responseObject, NSError *error) {
    [self showErrorAlertMessageWithReferance:referance withForm:form target:target networkError:error sysError:responseObject];
    [self finishLoadingWithReferance:referance target:target];
    
    if (block) {
      block(responseObject, error);
    }
  }];
}


-(void)beginLoadingWithReferance:(UIReferance)referance target:(__weak id)target{

  if ((referance & UIREFERANCE_LOADING) && target && [target isKindOfClass:[UIViewController class]]){
    if (self.requestCount == 0){
      [self.loadingView showLoadingOnController:target fullScreen:referance & UIREFERANCE_LOADING_FULLSCREEN];
    }
    self.requestCount++;
  }
  
}

-(void)finishLoadingWithReferance:(UIReferance)referance target:(__weak id)target{
  if ((referance & UIREFERANCE_LOADING) && target && [target isKindOfClass:[UIViewController class]]){
    self.requestCount--;
    if (self.requestCount <= 0){
      [self.loadingView hideLoadingViewOnController:target];
    }
  }
}

-(NSString *)getNetworkErrorDesc:(NSError *)error{
  NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
  NSString *message = NSLocalizedStringFromTableInBundle(code, @"NetworkLocalizable", [NSBundle bundleForClass:[self class]], nil);
  // 如果没定义错误则显示未知异常
  if ([code isEqualToString:message]) {
    message = NSLocalizedStringFromTableInBundle(@"Unkown", @"NetworkLocalizable", [NSBundle bundleForClass:[self class]], nil);
  }
  return message;
}

-(void)showErrorAlertMessageWithReferance:(UIReferance)referance withForm:(SZBaseForm *)form target:(__weak id)target networkError:(NSError *)networkError sysError:(SZBaseData *)sysError{
  if (!target){
    return;
  }
  NSString *message = nil;
  if (networkError){
    // 如果是主动取消请求则不弹出错误
    if (networkError.code == -999){
      return;
    }
    message = [self getNetworkErrorDesc:networkError];
  }else{
    // 如果错误码为0表示成功则不弹出错误框
    if([sysError.code isEqualToString: form.successCode]){
      return;
    }
    // 如果是需要用户自己处理的错误码则不弹出错误框
    if (form.userHandledCodes){
      if ([form.userHandledCodes containsObject:sysError.code]){
        return;
      }
    }
    message = sysError.message;
  }
  
  if(referance & UIREFERANCE_ALERT){
    if (referance & UIREFERANCE_RETRY_WHEN_ALERT) {
      UIAlertView *alertView = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"Tips", nil)
                                message:message
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"Back", nil)
                                otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
      alertView.tag = ALERT_RETRY_TAG;
      [alertView show];
    } else {
      [SVProgressHUD showErrorWithStatus:message];
    }
  }
}

-(void)cancel {
  [self.coreRequester cancel];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (ALERT_RETRY_TAG == alertView.tag) {
    if (buttonIndex == 1) {
      [self.target reload];
    }
  }
}

@end
