//
//  SZLoadingView.m
//  SZNetWorkRequester
//
//  Created by Stella on 15/4/23.
//  Copyright (c) 2015年 sunzhuo11. All rights reserved.
//

#import "SZLoadingView.h"
#import <Masonry/Masonry.h>

@interface SZLoadingView()

@end

@implementation SZLoadingView

+(SZLoadingView *)hud
{
    static SZLoadingView* hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] init];
    });
    return hud;
}

-(void)showLoadingOnController:(UIViewController *)controller fullScreen:(BOOL)fullScreen{
    if (self.view){
        [self.view removeFromSuperview];
    }
    [[NSBundle mainBundle] loadNibNamed:@"SZLoadingView" owner:self options:nil];
    if (fullScreen){
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    }else{
        [controller.view addSubview:self.view];
    }
    
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view.superview);
    }];
    
    [self doAnimateCycleWithRects:self.hudViews];
}

-(void)hideLoadingViewOnController:(UIViewController *)controller{
    [self.view removeFromSuperview];
}

- (void)doAnimateCycleWithRects:(NSArray *)rects {
    __weak typeof(self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf animateRect:rects[0] withDuration:0.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wSelf animateRect:rects[1] withDuration:0.25];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wSelf animateRect:rects[2] withDuration:0.2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wSelf animateRect:rects[3] withDuration:0.25];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wSelf animateRect:rects[4] withDuration:0.3];
                    });
                });
            });
        });
    });
    
    NSMutableArray *newRects = [[NSMutableArray alloc] init];
    for (UIView *view in rects) {
        [newRects insertObject:view atIndex:0];
    }
    rects = newRects;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf doAnimateCycleWithRects:rects];
    });
}

- (void)animateRect:(UIView *)rect withDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         rect.backgroundColor = [UIColor colorWithRed:204.0/255 green:115.0/255 blue:140.0/255 alpha:1];
                         rect.transform = CGAffineTransformMakeScale(1.9, 1.9);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              rect.backgroundColor = [UIColor colorWithRed:204.0/255 green:115.0/255 blue:140.0/255 alpha:0.2];
                                              rect.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL f) {
                                              
                                          }];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
