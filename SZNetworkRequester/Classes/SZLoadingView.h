//
//  SZLoadingView.h
//  SZNetWorkRequester
//
//  Created by Stella on 15/4/23.
//  Copyright (c) 2015年 sunzhuo11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLoadingView : UIView

+(SZLoadingView *)hud;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hudViews;

-(void)showLoadingOnController:(UIViewController *)controller fullScreen:(BOOL)fullScreen;
-(void)hideLoadingViewOnController:(UIViewController *)controller;

@end
