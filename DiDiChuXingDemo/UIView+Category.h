//
//  UIView+Category.h
//  Test
//
//  Created by monkey on 17/6/16.
//  Copyright © 2017年 monkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

#pragma mark - 控件Frame的扩展
/** 获取控件的左边框 */
- (CGFloat)left;
- (void)setLeft:(CGFloat)x;
/** 获取控件的上边框 */
- (CGFloat)top;
- (void)setTop:(CGFloat)y;
/** 获取控件的右边框 */
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
/** 获取控件的下边框 */
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;
/** 获取控件的中心点 x */
- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
/** 获取控件的中心点Y */
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;
/** 获取控件的长度 */
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
/** 获取控件的长度 */
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
/** 获取控件的二维坐标系中的点 */
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
/** 获取控件的大小 */
- (CGSize)size;
- (void)setSize:(CGSize)size;



@end
