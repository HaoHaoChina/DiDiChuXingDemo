//
//  ZHScollView.m
//  DiDiChuXingDemo
//
//  Created by monkey on 2019/11/6.
//  Copyright © 2019 XunFei. All rights reserved.
//

#import "ZHScollView.h"

@implementation ZHScollView
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    
    NSInteger index = self.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = self.subviews[index];
    
    CGPoint p = [self convertPoint:point toView:view];
    
    if (p.y<0) {
        return nil;
    }
    
    return [super hitTest:point
                withEvent:event];
}

@end
