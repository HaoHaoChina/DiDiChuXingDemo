//
//  ViewController.m
//  DiDiChuXingDemo
//
//  Created by monkey on 2019/11/6.
//  Copyright © 2019 XunFei. All rights reserved.
//

#import "ViewController.h"
#import "ZHHeadView.h"
#import "ZHScollView.h"
#import "UIView+Category.h"
#import "ZHTableViewCell.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define KCellHeight 150                       //cell高度
#define kSectionCount 10                    //cell高度
#define kHeadViewHeight 100                     //headerView的高度
#define kSectionFootViewHeight 5                     //分区FootView的高度
#define kStartY (kScreenHeight - KCellHeight - kSectionFootViewHeight)  //默认列表内容开始的offSet.y值
#define kEndY (20)   //列表上滑后吸附在顶端的offSet.y值
#define kCriticalY (kScreenHeight*0.5) //决定是上滑还是下滑的临界点y值
#define kContentInsetTopValue (kStartY)


static NSString *cellID = @"cellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong)ZHHeadView     *headView;
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)UIView     *taxiView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (@available(iOS 11.0, *))
    {
        
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

    self.myScrollView.contentSize = CGSizeMake(2 * kScreenWidth, kScreenHeight);
    self.myScrollView.backgroundColor = UIColor.clearColor;
    [self.myScrollView addSubview:self.tableView];
    [self.myScrollView addSubview:self.taxiView];
    

    [self.view addSubview:self.headView];

}

#pragma  mark -- btnClick
- (void)btnClick:(UIButton *)btn{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.headView.bottomLine setCenterX:btn.center.x];
        
    }];

    [self.myScrollView setContentOffset:CGPointMake((btn.tag - 200) * kScreenWidth, 0) animated:NO];
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offSetY = offset.y;
        NSLog(@"observeValueForKeyPath>>>> %f",offSetY);
        
        
        //位于临界点与列表顶部之间
        if ((offSetY > -kCriticalY) && (offSetY <= 0))
        {
            
            
            if (self.headView.top == 0)
            {
                [UIView animateWithDuration:.15 animations:^{
                    self.headView.top = -kHeadViewHeight;
                }];
                
            }
            
            return;
            
        }
        
        //位于临界点的下部
        if (offSetY < -kCriticalY)
        {
            
            if (self.headView.top == -kHeadViewHeight)
            {
                [UIView animateWithDuration:.15 animations:^{
                    self.headView.top = 0;
                }];
                
            }
            return;

        }
        
        //第一个cell上滑超出列表
        if (offSetY > 0)
        {
            
        }
        
        
    }
    
}

#pragma mark - scrollView结束拖动调用（有无减速都会调用）
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat tableContenOffsetY = scrollView.contentOffset.y;
    BOOL decelerate = (velocity.y != 0);  //velocity.y = 0 表示无减速
    BOOL isUp = velocity.y > 0;  //velocity.y > 0 表示向上，velocity.y < 0表示向下
    
    NSLog(@"scrollViewDidEndDragging>>>>> %f  %s %s ",tableContenOffsetY,(isUp)?"上":"下", (decelerate)?"是":"否");
    
    
    //有减速
    if (decelerate)
    {
        
        //禁止惯性滚动
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollTableViewWithOffSetY:tableContenOffsetY withVelocity:velocity];
        });
        
        return;

    }
    
    //无减速
    if (!decelerate)
    {
        
        [self scrollTableViewWithOffSetY:tableContenOffsetY withVelocity:velocity];
        
    }
    
}

#pragma  mark -- 根据tableView最终偏移量来确定其在顶部还是在底部
- (void)scrollTableViewWithOffSetY:(CGFloat)offSetY withVelocity:(CGPoint)velocity {
    
    CGFloat contentInsetTop = self.tableView.contentInset.top;
    
    //位于临界点的下部
    if (offSetY < -kCriticalY)
    {
        
        
        if (offSetY != -kStartY)
        {
            
            [self.tableView setContentOffset:CGPointMake(0,-kStartY) animated:YES];

        }
        return;
        
    }
    //位于临界点与列表顶部之间
    if ((offSetY >= -kCriticalY) && (offSetY <= 0))
    {
        
        if (contentInsetTop == kEndY)
        {
            self.tableView.contentInset = UIEdgeInsetsMake(kContentInsetTopValue, 0, 0, 0);
        }
        
        [self.tableView setContentOffset:CGPointMake(0,-kEndY) animated:YES];

        return;
        
    }
    //第一个cell上滑超出列表
    if (offSetY > 0)
    {
        


        //向下移动
        if ((velocity.y <0))
        {
            self.tableView.contentInset = UIEdgeInsetsMake(kEndY, 0, 0, 0 );

        }
        //向上移动
        if (velocity.y >0)
        {
            
        }
        
    }
    
}


#pragma  mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma  mark -- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    head.backgroundColor = [UIColor grayColor];
    return head;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *foot = [[UIView alloc]initWithFrame:(CGRect){{0,0},{self.tableView.width,0}}];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSectionFootViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma  mark -- 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, self.myScrollView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = KCellHeight;
        _tableView.separatorColor = [UIColor cyanColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZHTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.contentInset = UIEdgeInsetsMake(kContentInsetTopValue, 0, 0, 0);
        
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, CGFLOAT_MIN)];
        headV.backgroundColor = [UIColor greenColor];
        _tableView.tableHeaderView = headV;
        
        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth - 20, CGFLOAT_MIN)];
        footV.backgroundColor = [UIColor blueColor];
        _tableView.tableFooterView = footV;
        //添加监听
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    }
    
    return _tableView;
    
}
- (ZHHeadView *)headView{
    
    if (!_headView) {
        _headView = [ZHHeadView headView];
        _headView.frame = (CGRect){{0,0},{kScreenWidth,kHeadViewHeight}};
        _headView.backgroundColor = [UIColor yellowColor];
        [_headView.fastCarBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.taxiCarBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _headView;
    
}
- (UIView *)taxiView{
    
    if (!_taxiView) {
        
        _taxiView = [[UIView alloc]initWithFrame:CGRectMake(10 + kScreenWidth, kScreenHeight - 100 - 10, kScreenWidth - 20, 100)];
        _taxiView.backgroundColor = [UIColor orangeColor];

    }
    
    return _taxiView;
    
}


@end
