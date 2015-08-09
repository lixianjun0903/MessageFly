//
//  OrderDetailDidForSearchViewController.m
//  MessageFly
//
//  Created by xll on 15/4/14.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "OrderDetailDidForSearchViewController.h"
#import "PicSCView.h"
#import "ReplyViewController.h"
#import "SoundBtn.h"
#import "LoginViewController.h"
#import "ReplyForQiangDanTableViewCell.h"
#import "LunBoTuViewController.h"
#import "SelfHonestViewController.h"
#import "InChargeViewController.h"
#import "MoveView.h"
@interface OrderDetailDidForSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    UIButton *headView;
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UIView * infoView;
    
    UILabel *contentLabel;
    UIView *bgView;
    UIView *firstView;
    UIView *secView;
    SoundBtn *soundBtn;
    UIView *soundView;
    UIView *contentView;
    UIView *picView;
    UIView *otherView;
    UILabel *lostTime;
    UILabel *finalPlace;
    
    UILabel *moneyLabel;
    UILabel *endTimeLabel;
    UILabel *placeLabel;
    UILabel *stausLabel;
    int mpage;
    UIView *footerView;
    
    UIButton *commitBtn;
    
    UILabel *name;
    UILabel *sex;
    UILabel *age;
    UILabel *jiguanLabel;
    MoveView *moveView;
    UILabel *heightLabel;
    UILabel *weightLabel;
}
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation OrderDetailDidForSearchViewController
@synthesize _tableView;
-(void)viewDidDisappear:(BOOL)animated
{
    [soundBtn stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"信息详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self makeUI];
    if (_type == 1) {
        [self createBottomView];
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 40, 30) bgImageName:nil imageName:nil title:@"回复" selector:@selector(reply) target:self];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    else
    {
        _tableView.frame =CGRectMake(0, 0, WIDTH, HEIGHT-64);
    }
    [self loadData];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViewcontroll) name:REPLYREFFRESH object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)reloadSubViewcontroll
{
    mpage = 0;
    [self loadData];
}
-(void)reply
{
    ReplyViewController *vc = [[ReplyViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.detailID = _tid;
    vc.rid = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tousu
{
    InChargeViewController *vc = [[InChargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tid = self.dataDic[@"uid"];
    vc.detailID =self.dataDic[@"id"];
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
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 525+130)];
    bgView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    
    
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    infoView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:infoView];
    infoView.userInteractionEnabled = YES;
    [infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"发布人信息" font:15];
    [infoView addSubview:tishi1];
    
    UIButton *tousuBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-60, 0, 50, 40) bgImageName:nil imageName:@"tousu" title:nil selector:@selector(tousu) target:self];
    [firstView addSubview:tousuBtn];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [infoView addSubview:line];
    
    //    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 50, 60, 60) imageName:@"picdefault@2x"];
    headView = [MyControll createButtonWithFrame:CGRectMake(20, 50, 60, 60) bgImageName:nil imageName:@"picdefault@2x" title:nil selector:@selector(headClick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius=30;
    [infoView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 50, WIDTH-90-50, 20) title:@"" font:16];
    [infoView addSubview:nameLabel];
    
    UILabel * tishi2 = [MyControll createLabelWithFrame:CGRectMake(90, 70, 70, 20) title:@"联系电话:" font:13];
    tishi2.textColor = [UIColor lightGrayColor];
    [infoView addSubview:tishi2];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(90, 90, 70, 20) title:@"发单诚信" font:13];
    tishi3.textColor = [UIColor lightGrayColor];
    [infoView addSubview:tishi3];
    
    phoneLabel = [MyControll createLabelWithFrame:CGRectMake(160, 70, WIDTH-160-50, 20) title:@"" font:13];
    phoneLabel.textColor = [UIColor lightGrayColor];
    [infoView addSubview:phoneLabel];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-50, 50, 1, 60)];
    line2.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [infoView addSubview:line2];
    
    UIButton *contactBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-45, 40, 40, 80) bgImageName:nil imageName:@"o14" title:nil selector:@selector(contactClick) target:self];
    [infoView addSubview:contactBtn];
    
    
    
    
    
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, WIDTH, 550)];
    firstView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:firstView];
   
    
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"详情" font:15];
    [firstView addSubview:tishi4];
    
    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    lin.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:lin];
    
    name = [MyControll createLabelWithFrame:CGRectMake(20, 50, WIDTH/2-25, 20) title:@"姓名：" font:13];
    [firstView addSubview:name];
    sex = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2+5, 50, WIDTH/2-25, 20) title:@"性别：" font:13];
    [firstView addSubview:sex];
    
    age = [MyControll createLabelWithFrame:CGRectMake(20, 70, WIDTH/2-25, 20) title:@"年龄" font:13];
    [firstView addSubview:age];
    
    jiguanLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2+5, 70, WIDTH/2-25, 20) title:@"籍贯：" font:13];
    [firstView addSubview:jiguanLabel];
    CGSize ssss = [MyControll getSize:@"籍贯：" Font:13 Width:1000 Height:20];
    float www =jiguanLabel.frame.origin.x+ssss.width;
    moveView = [[MoveView alloc]initWithFrame:CGRectMake(www, 70, WIDTH-www-5, 20)];
    [firstView addSubview:moveView];
    
    heightLabel = [MyControll createLabelWithFrame:CGRectMake(20, 90, WIDTH/2-25, 20) title:@"身高：" font:13];
    [firstView addSubview:heightLabel];
    
    weightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2+5, 90, WIDTH/2-25, 20) title:@"体重" font:13];
    [firstView addSubview:weightLabel];
    
    
    soundView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 95)];
    [firstView addSubview:soundView];
    
    UIView*line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [soundView addSubview:line3];
    
    UILabel *tishi5 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"语音" font:14];
    tishi5.textColor = [UIColor lightGrayColor];
    [soundView addSubview:tishi5];
    
    soundBtn = [[SoundBtn alloc]initWithFrame:CGRectMake((WIDTH-200)/2, 35, 200, 50)];
    [soundView addSubview:soundBtn];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 215, WIDTH, 90)];
    [firstView addSubview:contentView];
    
    UIView*line4 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line4.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [contentView addSubview:line4];
    
    UILabel *tishi6 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"文字" font:14];
    tishi6.textColor = [UIColor lightGrayColor];
    [contentView addSubview:tishi6];
    
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 45) title:@"" font:15];
    [contentView addSubview:contentLabel];
    
    picView =[[UIView alloc]initWithFrame:CGRectMake(0, 315, WIDTH, 110)];
    [firstView addSubview:picView];
    
    UIView*line5 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line5.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [picView addSubview:line5];
    
    UILabel *tishi7 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"图片描述" font:14];
    tishi7.textColor = [UIColor lightGrayColor];
    [picView addSubview:tishi7];
    
    otherView = [[UIView alloc]initWithFrame:CGRectMake(0, 435, WIDTH, 140)];
    [firstView addSubview:otherView];
    
    UIView *lll = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    lll.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [otherView addSubview:lll];
    
    UILabel *tt1 =[MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"失踪时间" font:14];
    tt1.textColor = [UIColor lightGrayColor];
    [otherView addSubview:tt1];
    
    lostTime = [MyControll createLabelWithFrame:CGRectMake(20, 40, WIDTH-30, 20) title:nil font:14];
    [otherView addSubview:lostTime];
    
    UIView *lll1 = [[UIView alloc]initWithFrame:CGRectMake(20, 70, WIDTH-20, 1)];
    lll1.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [otherView addSubview:lll1];
    
    UILabel *tt2 = [MyControll createLabelWithFrame:CGRectMake(20, 80, 150, 20) title:@"最后确认位置" font:14];
    tt2.textColor = [UIColor lightGrayColor];
    [otherView addSubview:tt2];
    
    finalPlace = [MyControll createLabelWithFrame:CGRectMake(20, 110, WIDTH-30, 20) title:nil font:14];
    [otherView addSubview:finalPlace];
    
    
    secView = [MyControll createToolView4WithFrame:CGRectMake(0, 445 +140+120, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"酬      金:",@"剩余时长:",@"投放地址:",@"已抢/发布:"]];
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
    
}
-(void)headClick
{
    SelfHonestViewController *vc = [[SelfHonestViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = self.dataDic[@"uid"];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)contactClick
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",self.dataDic[@"mobile"]];
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
-(void)createBottomView
{
    UIImageView  * bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT-60-64, WIDTH, 60) imageName:@"17@2x_20"];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    commitBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 8, 260, 44) bgImageName:nil imageName:@"o15@2x" title:nil selector:@selector(qiangClick) target:self];
    [bottomView addSubview:commitBtn];
}
-(void)qiangClick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (uid&&token) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定取消抢单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 900;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您没有登录，请先登录后操作，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 902;
        [alert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 902)
    {
        if (buttonIndex == 1) {
            LoginViewController  *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(alertView.tag == 900)
    {
        if (buttonIndex == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *uid = [user objectForKey:@"uid"];
            NSString *token = [user objectForKey:@"token"];
            [self StartLoading];
            NSString *url = [NSString stringWithFormat:@"%@canclemorder?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,self.dataDic[@"id"]];
            __weak typeof(self) weakSelf=self;
            _sfManager = [ServerFetcherManager sharedServerManager];
            [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
                if (isSuccess) {
                    [weakSelf StopLoading];
                    if (data && data.length>0) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if (dic&&dic.count>0) {
                            if ([[dic[@"code"] stringValue]isEqualToString:@"1"]) {
                                [weakSelf showMsg:@"订单取消成功"];
                                [[NSNotificationCenter defaultCenter]postNotificationName:MyQRELOADVC object:nil];
                                [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
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
}
-(void)loadData
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@successorder2?uid=%@&token=%@&id=%@&limit=10&page=%d",SERVER_URL,uid,token,_tid,mpage+1];
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
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
    nameLabel.text = self.dataDic[@"name"];
    phoneLabel.text = self.dataDic[@"mobile"];
    for (int i= 0; i<5; i++) {
        if (i<[self.dataDic[@"sendcerity"] intValue]) {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(160+18*i, 90, 16, 20) imageName:@"m16@2x_14"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [infoView addSubview:star];
        }
        else
        {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(160+18*i, 90, 16, 20) imageName:@"m16@2x_16"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [infoView addSubview:star];
        }
    }
    
    
    name.text = [NSString stringWithFormat:@"姓名：%@",self.dataDic[@"name"]];
    if ([self.dataDic[@"sex"] isEqualToString:@"0"]) {
        sex.text = @"性别：女";
    }
    else
    {
        sex.text = @"性别：男";
    }
    age.text = [NSString stringWithFormat:@"年龄：%@岁",self.dataDic[@"age"]];
//    jiguanLabel.text = [NSString stringWithFormat:@"籍贯：%@",self.dataDic[@"oaddress"]];
     [moveView config:self.dataDic[@"oaddress"] withFont:13 withTime:5];
    heightLabel.text = [NSString stringWithFormat:@"身高：%@cm",self.dataDic[@"height"]];
    weightLabel.text = [NSString stringWithFormat:@"体重：%@kg",self.dataDic[@"weight"]];
    
    int time = [self.dataDic[@"ltime"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *str = [MyControll dayLabelForMessage:date];
    lostTime.text = str;
    finalPlace.text = self.dataDic[@"lastw"];
    
    
    float height = 120;
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
    otherView.frame = CGRectMake(0, height, WIDTH, 140);
    
    firstView.frame = CGRectMake(0, 130, WIDTH, height+140);
    secView.frame = CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, WIDTH, 160);
    bgView.frame = CGRectMake(0, 0, WIDTH, secView.frame.origin.y+secView.frame.size.height+10);
    NSLog(@"%f",bgView.frame.size.height);
    moneyLabel.text = [NSString stringWithFormat:@"%@元/人",self.dataDic[@"money"]];
    endTimeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"ltime"]];
    placeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"address"]];
    stausLabel.text = [NSString stringWithFormat:@"%@/%@",self.dataDic[@"count"],self.dataDic[@"num"]];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *array = self.dataDic[@"replyinfo"];
    if (array.count!=0) {
        for (int i = 0; i<array.count; i++) {
            NSMutableDictionary *dic = array[i][@"myreply"];
            [dic setObject:@"myreply" forKey:@"whosereply"];
            [self.dataArray addObject:dic];
            NSArray *arr = array[i][@"othereply"];
            if (arr.count!=0) {
                for (int j = 0; j<arr.count; j++) {
                    NSMutableDictionary *d = arr[j];
                    [d setObject:@"otherreply" forKey:@"whosereply"];
                    [self.dataArray addObject:d];
                }
            }
        }
    }
    
    [_tableView reloadData];
}
-(void)checkPhoto:(UIGestureRecognizer *)sender
{
    NSArray *picArray = self.dataDic[@"image"];
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:picArray atIndex:(int)(sender.view.tag-200)];
     [self presentViewController:vc animated:NO completion:nil];
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
    ReplyForQiangDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ReplyForQiangDanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    CGFloat height = 40;
    if (![dic[@"radio"] isEqualToString:@""]) {
        //        [playSoundView loadVoiceData:self.dataDic];
        height =  height+95;
    }
    else
    {
        
    }
    if (![dic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
        height =height+(35+sizeOfcontent.height+5)+10;
    }
    else
    {
        
    }
    NSArray *picArray =dic[@"image"];
    CGFloat picWidth = (sWIDTH-40-30)/4;
    CGFloat picHeight = 0;
    if (picArray.count != 0 ) {
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        height = height+picHeight+40;
    }
    else
    {
        picView.hidden = YES;
    }
    height =height+5;
    
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return bgView.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
