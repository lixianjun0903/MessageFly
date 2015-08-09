//
//  OrderDetailOnViewController.m
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "OrderDetailOnViewController.h"
#import "AddTimeViewController.h"
#import "ReplyInfoViewController.h"
#import "PicSCView.h"
#import "SoundBtn.h"
#import "OrderListTableViewCell.h"
#import "LunBoTuViewController.h"
@interface OrderDetailOnViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UILabel *contentLabel;
    UIView *bgView;
    UIView *firstView;
    UIView *secView;
    UIView *thirdView;
    UIView *picSCView;
    SoundBtn *soundBtn;
    UIView *soundView;
    UIView *contentView;
    UIView *picView;
    
    UILabel *moneyLabel;
    UILabel *endTimeLabel;
    UILabel *placeLabel;
    UILabel *stausLabel;
    int mpage;
    UIView *footerView;
    
    UIButton *numOfSeeBtn;
    UIImageView *eye;
    
    UIButton *commitBtn;
}
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation OrderDetailOnViewController
@synthesize _tableView;
-(void)viewDidDisappear:(BOOL)animated
{
    [soundBtn stopPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mpage =0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"信息详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 80, 30) bgImageName:nil imageName:nil title:@"延长时间" selector:@selector(prelong) target:self];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self makeUI];
    [self createBottomView];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViewcontroll) name:ADDTIME object:nil];
}
-(void)reloadSubViewcontroll
{
    [self loadData];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)prelong
{
    AddTimeViewController *vc = [[AddTimeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tid = _tid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)makeUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-60-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 525)];
    bgView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 345)];
    firstView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:firstView];
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"详情" font:15];
    [firstView addSubview:tishi4];
    
    
    
    eye = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-90, 0, 15, 40) imageName:@"16@2x_22"];
    eye.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:eye];
    
    numOfSeeBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-70, 0, 65, 40) bgImageName:nil imageName:nil title:@"浏览次" selector:nil target:self];
    numOfSeeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [numOfSeeBtn setTitleColor:[UIColor colorWithRed:0.54f green:0.59f blue:0.67f alpha:1.00f] forState:UIControlStateNormal];
    [firstView addSubview:numOfSeeBtn];
    
    soundView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 95)];
    [firstView addSubview:soundView];
    
    UIView*line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [soundView addSubview:line3];
    
    UILabel *tishi5 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"语音" font:14];
    tishi5.textColor = [UIColor lightGrayColor];
    [soundView addSubview:tishi5];
    
    soundBtn = [[SoundBtn alloc]initWithFrame:CGRectMake((WIDTH-200)/2, 35, 200, 50)];
    [soundView addSubview:soundBtn];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, WIDTH, 90)];
    [firstView addSubview:contentView];
    
    UIView*line4 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line4.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [contentView addSubview:line4];
    
    UILabel *tishi6 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"文字" font:14];
    tishi6.textColor = [UIColor lightGrayColor];
    [contentView addSubview:tishi6];
    
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 45) title:@"" font:15];
    [contentView addSubview:contentLabel];
    
    picView =[[UIView alloc]initWithFrame:CGRectMake(0, 235, WIDTH, 110)];
    [firstView addSubview:picView];
    
    UIView*line5 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line5.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [picView addSubview:line5];
    
    UILabel *tishi7 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"图片" font:14];
    tishi7.textColor = [UIColor lightGrayColor];
    [picView addSubview:tishi7];
    
    CGFloat picWidth = (WIDTH-40-30)/4;
    picSCView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, picWidth)];
    [picView addSubview:picSCView];
    
    secView = [MyControll createToolView4WithFrame:CGRectMake(0, 365, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"酬      金:",@"剩余时长:",@"投放地址:",@"已抢/发布:"]];
    [bgView addSubview:secView];
    
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-20, 40) title:@"" font:15];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:moneyLabel];
    endTimeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 40, WIDTH/2-20, 40) title:@"" font:15];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:endTimeLabel];
    placeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 80, WIDTH/2-20, 40) title:@"" font:15];
    placeLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:placeLabel];
    stausLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 120, WIDTH/2-20, 40) title:@"" font:15];
    stausLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:stausLabel];
    
    thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 535, WIDTH, 40)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:thirdView];
    
    UILabel *t = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"抢单人" font:15];
    [thirdView addSubview:t];
    UIView *l = [[UIView alloc]initWithFrame:CGRectMake(20, 39, WIDTH-20, 1)];
    l.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [thirdView addSubview:l];
    
    
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton * loadMoreBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 40) bgImageName:nil imageName:nil title:@"查看全部" selector:@selector(loadMoreClick) target:self];
    loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:loadMoreBtn];
    UIView *ll = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    ll.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [footerView addSubview:ll];
}
-(void)loadMoreClick
{
    [self loadData];
}
-(void)createBottomView
{
    UIImageView *bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT-64-60, WIDTH, 60) imageName:@"17@2x_20"];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    commitBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 8, 260, 44) bgImageName:nil imageName:@"o1@2x" title:nil selector:@selector(endClick) target:self];
    [bottomView addSubview:commitBtn];
}
-(void)endClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要结束发布该信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        NSString *token = [user objectForKey:@"token"];
        [self StartLoading];
        NSString *url = [NSString stringWithFormat:@"%@endorder?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_tid];
        __weak typeof(self) weakSelf=self;
        _sfManager = [ServerFetcherManager sharedServerManager];
        [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (dic&&dic.count>0) {
                        if ([[dic[@"code"]stringValue]isEqualToString:@"1"]) {
                            [weakSelf showMsg:@"结束订单发布成功"];
                            commitBtn.enabled = NO;
                            [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                            [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                        }
                        else
                        {
                            [weakSelf showMsg:dic[@"message"]];
                        }
                    }
                }
            }
            else
            {
                [weakSelf StopLoading];
                [weakSelf showMsg:@"请检查你的网络"];
            }
        }];

    }
}
-(void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@myorderinfo?uid=%@&token=%@&tid=%@&limit=10&page=%d",SERVER_URL,uid,token,_tid,mpage+1];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic&&dic.count>0) {
                    NSString *code = [dic[@"code"] stringValue];
                    if (!code) {
                        weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [weakSelf refreshUI];
                    }
                    else
                    {
                        [weakSelf showMsg:dic[@"message"]];
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:@"uid"];
                        [user removeObjectForKey:@"token"];
                        [user removeObjectForKey:@"flag"];
                        [user synchronize];
                    }
                }
            }
        }
        else
        {
            [weakSelf StopLoading];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];

}
-(void)refreshUI
{
    [numOfSeeBtn setTitle:[NSString stringWithFormat:@"浏览%@次",self.dataDic[@"view"]] forState:UIControlStateNormal];
    CGSize size = [MyControll getSize:numOfSeeBtn.titleLabel.text Font:13 Width:WIDTH/2 Height:20];
    numOfSeeBtn.frame = CGRectMake(WIDTH-size.width-10, 0, size.width+5, 40);
    eye.frame = CGRectMake(WIDTH-size.width-30, 0, 15, 40);
    
    float height = 40;
    if (![self.dataDic[@"radio"] isEqualToString:@""]) {
        [soundBtn loadVoiceData:self.dataDic];
        height = soundView.frame.origin.y+soundView.frame.size.height+10;
    }
    else
    {
        soundView.hidden = YES;
    }
    if (![self.dataDic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:self.dataDic[@"text"] Font:15 Width:WIDTH-40 Height:1000];
        contentLabel.frame = CGRectMake(20, 35, WIDTH-40, sizeOfcontent.height+5);
        contentLabel.text = self.dataDic[@"text"];
        contentView.frame = CGRectMake(0, height, WIDTH, contentLabel.frame.origin.y+contentLabel.frame.size.height);
        height =contentView.frame.origin.y+contentView.frame.size.height+10;
    }
    else
    {
        contentView.hidden = YES;
    }
    NSArray *picArray = self.dataDic[@"image"];
    CGFloat picWidth = (WIDTH-40-30)/4;
    CGFloat picHeight = 0;
    if (picArray.count>0) {
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(20+(picWidth+10)*(i%4), i/4*(picWidth+10) + 40, picWidth, picWidth) imageName:nil];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
            imageView.tag = 200+i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPhoto:)]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [picView addSubview:imageView];
        }
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        picView.frame = CGRectMake(0, height, WIDTH, picHeight+40);
        height = height+picView.frame.size.height;
        
    }
    else
    {
        picView.hidden = YES;
    }
    firstView.frame = CGRectMake(0, 10, WIDTH, height);
    secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, WIDTH, 160);
    thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, WIDTH, 40);
    bgView.frame = CGRectMake(0, 0, WIDTH, thirdView.frame.origin.y+thirdView.frame.size.height);
    NSLog(@"%f",bgView.frame.size.height);
    moneyLabel.text = [NSString stringWithFormat:@"%@元/人",self.dataDic[@"money"]];
    endTimeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"lestime"]];
    placeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"address"]];
    stausLabel.text = [NSString stringWithFormat:@"%@/%@",self.dataDic[@"count"],self.dataDic[@"num"]];
    
    NSArray *array = self.dataDic[@"list"];
    if (array&&array.count>0) {
        [self.dataArray addObjectsFromArray:array];
        mpage++;
    }
     [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[OrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return bgView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count<10) {
        footerView.hidden = YES;
        return 0.01;
    }
    else
    {
        footerView.hidden = NO;
        return 40;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return bgView.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyInfoViewController *vc = [[ReplyInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tid = self.dataArray[indexPath.row][@"uid"];
    vc.detailId = self.dataDic[@"id"];
    vc.moneyNum = self.dataDic[@"money"];
    vc.ifBottom = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkPhoto:(UIGestureRecognizer *)sender
{
    NSArray *picArray = self.dataDic[@"image"];
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:picArray atIndex:(int)(sender.view.tag-200)];
    [self presentViewController:vc animated:NO completion:nil];
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