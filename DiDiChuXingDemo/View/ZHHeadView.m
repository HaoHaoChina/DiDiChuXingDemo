//
//  ZHHeadView.m
//  DiDiChuXingDemo
//
//  Created by monkey on 2019/11/6.
//  Copyright © 2019 XunFei. All rights reserved.
//

#import "ZHHeadView.h"

@implementation ZHHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)headView{
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    NSArray *xibArray = [nib instantiateWithOwner:nil options:nil];
    return xibArray[0];
    
}
@end
