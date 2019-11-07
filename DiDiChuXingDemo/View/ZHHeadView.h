//
//  ZHHeadView.h
//  DiDiChuXingDemo
//
//  Created by monkey on 2019/11/6.
//  Copyright © 2019 XunFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *fastCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *taxiCarBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

+ (instancetype)headView;

@end

NS_ASSUME_NONNULL_END
