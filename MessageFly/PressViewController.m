//
//  PressViewController.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PressViewController.h"
#import "LeftView.h"
#import "RightView.h"
#import "RightViewController.h"
@interface PressViewController ()<UIScrollViewDelegate>
{
    UIScrollView *mainSC;
    UIImageView *navImageView;
    RightView *rightView;
    LeftView *leftView;
}
@end

@implementation PressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"发布" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self createNav];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)createNav
{
    navImageView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 40) imageName:@"o2@2x"];
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    
    NSArray *nameArray = @[@"应急呼",@"急寻人"];
    for (int i = 0; i<2; i++) {
        UIButton *btn =[MyControll createButtonWithFrame:CGRectMake(WIDTH/2*i, 0, WIDTH/2, 40) bgImageName:nil imageName:nil title:nameArray[i] selector:@selector(navClick:) target:self];
        btn.tag = 100+i;
        if (i==0) {
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithRed:0.16f green:0.72f blue:0.93f alpha:1.00f] forState:UIControlStateSelected];
        [navImageView addSubview:btn];
    }
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake((WIDTH/2-(WIDTH/2-80))/2+0*WIDTH/2, 38, WIDTH/2-80, 2)];
    bottomLine.tag = 102;
    bottomLine.backgroundColor = [UIColor colorWithRed:0.16f green:0.72f blue:0.93f alpha:1.00f];
    [navImageView addSubview:bottomLine];
}
-(void)navClick:(UIButton *)sender
{
    int index = (int)sender.tag-100;
    for (int i=0; i<2; i++) {
        UIButton *btn = (UIButton *)[navImageView viewWithTag:100+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    UIView *bottomLine = [navImageView viewWithTag:102];
    [UIView animateWithDuration:0.2 animations:^{
        bottomLine.frame =CGRectMake((WIDTH/2-(WIDTH/2-80))/2+index*WIDTH/2, 38, WIDTH/2-80, 2);
        mainSC.contentOffset = CGPointMake(WIDTH*index, 0);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *bottomLine = [navImageView viewWithTag:102];
    
    CGPoint point = scrollView.contentOffset;
    bottomLine.frame = CGRectMake((WIDTH/2-(WIDTH/2-80))/2+point.x/2, 38, WIDTH/2-80, 2);
    UIButton *btn1 = (UIButton *)[navImageView viewWithTag:100+0];
    UIButton *btn2 = (UIButton *)[navImageView viewWithTag:100+1];
    if (point.x>WIDTH/2) {
        btn2.selected = YES;
        btn1.selected = NO;
    }
    else
    {
        btn2.selected = NO;
        btn1.selected = YES;
        [self.view endEditing:YES];
    }
}
-(void)makeUI
{
    
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT-40-64-50)];
    mainSC.showsHorizontalScrollIndicator = NO;
    mainSC.bounces = NO;
    mainSC.pagingEnabled = YES;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(2*WIDTH, HEIGHT-40-64-50);
    [self.view addSubview:mainSC];
    
    
    
    leftView = [[LeftView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, mainSC.frame.size.height)];
    leftView.delegate = self;
    leftView.sc = mainSC;
    [mainSC addSubview:leftView];
    rightView = [[RightView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, mainSC.frame.size.height)];
    [mainSC addSubview:rightView];
    
    RightViewController *vc =[[RightViewController alloc]init];
    vc.sc = mainSC;
    [self addChildViewController:vc];
    CGRect rect = vc.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = WIDTH;
    rect.size.height =mainSC.frame.size.height;
    vc.view.frame = rect;
    [rightView addSubview:vc.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end