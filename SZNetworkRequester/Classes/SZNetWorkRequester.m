//
//  SZNetWorkRequester.m
//  SZNetWorkRequester
//
//  Created by Stella on 15/1/12.
//  Copyright (c) 2015年 sunzhuo11. All rights reserved.
//

#import "SZNetWorkRequester.h"
#import "SVProgressHUD.h"
#import "WDAlertView.h"
#import "SZLoadingView.h"

@interface SZNetWorkRequester()

//当前正在请求的个数
@property (atomic) NSInteger requestCount;

@property (nonatomic, weak)SZViewController *target;

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

-(AFHTTPRequestOperation *)send:(SZBaseForm *)form parserClass:(Class)sourceClass target:(__weak SZViewController* )target UIReferance:(UIReferance)referance completion:(void (^)(id responseObject, NSError *error))block
{
    self.target = target;

    // 显示加载框
    [self beginLoadingWithReferance:referance Target:target];
    
    return [self.coreRequester send:form parserClass:sourceClass completion:^(id responseObject, NSError *error) {
        [self showErrorAlertMessageWithReferance:referance withForm:form target:target NetworkError:error SysError:responseObject];
        [self finishLoadingWithReferance:referance Target:target];
        
        if (block) {
            block(responseObject, error);
        }
    }];
}


-(void)beginLoadingWithReferance:(UIReferance)referance Target:(__weak SZViewController* )target{
    [[IQKeyboardManager sharedManager] resignFirstResponder];//把键盘收起来
    
    if ((referance & UIREFERANCE_LOADING) && target){
        if (self.requestCount == 0){
            [self.loadingView showLoadingOnController:target FullScreen:referance & UIREFERANCE_LOADING_FULLSCREEN];
        }
        self.requestCount++;
    }
    
}

-(void)finishLoadingWithReferance:(UIReferance)referance Target:(__weak SZViewController* )target{
    if ((referance & UIREFERANCE_LOADING) && target){
        self.requestCount--;
        if (self.requestCount <= 0){
            [self.loadingView hideLoadingViewOnController:target];
        }
    }
}

-(NSString *)getNetworkErrorDesc:(NSError *)error{
    NSString *codeStr = [NSString stringWithFormat:@"%ld",(long)error.code];
    NSString *message = NSLocalizedStringFromTable(codeStr, NetworkLocalizable, nil);
    // 如果没定义错误则显示未知异常
    if ([codeStr isEqualToString:message]) {
        message = NSLocalizedStringFromTable(@"Unknown", NetworkLocalizable, nil);
    }
    return message;
}

-(void)showErrorAlertMessageWithReferance:(UIReferance)referance withForm:(SZBaseForm *)form target:(__weak SZViewController *)target NetworkError:(NSError *)networkError SysError:(SZBaseData *)sysError{
    if (!target){
        return;
    }
    NSString *message = nil;
    if (networkError){
        // 如果是主动取消请求则不弹出错误
        if (networkError.code == CANCEL_REQUEST_ERROR_CODE){
            return;
        }
        message = [self getNetworkErrorDesc:networkError];
    }else{
        // 如果错误码为0表示成功则不弹出错误框
        if(sysError.code == ERROR_CODE_OK){
            return;
        }
        // 如果是需要用户自己处理的错误码则不弹出错误框
        if ([form givenRequest].userHandledCode){
            if ([[form givenRequest].userHandledCode containsObject:[NSString stringWithFormat:@"%ld", sysError.code]]){
                return;
            }
        }
        message = sysError.message;
    }

    if(referance & UIREFERANCE_ALERT){
        if (referance & UIREFERANCE_RETRY_WHEN_ALERT) {
            [WDAlertView showAlertWithRetry:message delegate:self];
        } else {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
}

-(void)cancel {
    [self.coreRequester cancel];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==ALERT_RETRY_TAG) {
        if (buttonIndex==1) {
            [self.target reloadRequest];
        }
    }
}

@end
