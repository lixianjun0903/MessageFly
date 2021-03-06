//
//  PhoneNumChangeNextViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PhoneNumChangeNextViewController.h"
#import "GetCheckMaView.h"
#import "RegexKitLite.h"
@interface PhoneNumChangeNextViewController ()<GetCheckDelegate>
{
    UIScrollView *mainSC;
    UITextField *phoneTX;
    UITextField *checkMaTX;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)GetCheckMaView *getCheckView;
@end

@implementation PhoneNumChangeNextViewController
@synthesize getCheckView;
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"手机号修改" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 320);
    [self.view addSubview:mainSC];
    UIView *firstView = [MyControll createToolView4WithFrame:CGRectMake(0, 15, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"输入新手机号",@"验 证 码"]];
    [mainSC addSubview:firstView];
    
    phoneTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/2, 10, WIDTH/2-20, 30) text:nil placehold:@"输入新手机号" font:15];
    phoneTX.textAlignment = NSTextAlignmentRight;
    phoneTX.keyboardType =UIKeyboardTypeNumberPad;
    [firstView addSubview:phoneTX];
    
    checkMaTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 60, WIDTH/5*4-30 - 110, 30) text:nil placehold:@"输入验证码" font:15];
    //    checkMaTX.textAlignment = NSTextAlignmentRight;
    checkMaTX.keyboardType =UIKeyboardTypeNumberPad;
    [firstView addSubview:checkMaTX];
    
    getCheckView = [[GetCheckMaView alloc] initWithFrame:CGRectMake(WIDTH-100, 50, 90, 50)];
    getCheckView.delegate = self;
    [firstView addSubview:getCheckView];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 155, 260, 40) bgImageName:nil imageName:@"m23@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
}
-(void)buttonClick
{
    if (![self checkphone:phoneTX.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    [getCheckView startCheck];
}
-(void)getCheckMa
{
    if (![self checkPassWD:phoneTX.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@sendcode?mobile=%@&type=1",SERVER_URL,phoneTX.text];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [weakSelf showMsg:info[@"message"]];
                if ([[info[@"code"] stringValue] isEqualToString:@"1"]) {
                    
                }
                else
                {
                    [weakSelf.getCheckView stopClock];
                }
            }
            
        }
        else
        {
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
    
}
-(void)checkCheckMa
{
    NSString *url = [NSString stringWithFormat:@"%@rightcode?mobile=%@&code=%@",SERVER_URL,phoneTX.text,checkMaTX.text];
    
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                    [weakSelf goTonextPage];
                }
                else
                {
                    [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
                    
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
-(void)goTonextPage
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@updatemobile?uid=%@&token=%@&mobile=%@",SERVER_URL,uid,token,phoneTX.text];
    
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                    [weakSelf showMsg:@"手机号修改成功"];
                    [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                }
                else
                {
                    [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
                    
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
-(void)commit
{
    [self checkCheckMa];
    
}
-(void)GoBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  验证格式是否正确
-(BOOL)checkphone:(NSString *)passwd
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|7[7])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    if ([passwd isMatchedByRegex:MOBILE]) {
        return YES;
    }
    else if([passwd isMatchedByRegex:CM])
    {
        return YES;
    }
    else if ([passwd isMatchedByRegex:CU])
    {
        return YES;
    }
    return NO;
}
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * regexString = @"^[a-zA-Z0-9]{6,20}+$";
    BOOL isYes = [passwd isMatchedByRegex:regexString];
    return isYes;
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
