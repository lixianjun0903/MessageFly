//
//  LunBoTuViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "LunBoTuViewController.h"
#import "SizeImageView.h"
@interface LunBoTuViewController ()<UIAlertViewDelegate,UIScrollViewDelegate>
{
    UIImage *tempImage;
}
@end

@implementation LunBoTuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.backgroundColor = [UIColor blackColor];
    mainSC.delegate = self;
    mainSC.showsHorizontalScrollIndicator = NO;
    mainSC.pagingEnabled = YES;
    [self.view addSubview:mainSC];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float contentoffset = mainSC.contentOffset.x;
    int index = (contentoffset + 5)/WIDTH;
    SizeImageView *imageView = (SizeImageView *)[mainSC viewWithTag:100+index];
    if (imageView.isLoad) {
        
    }
    else
    {
        [imageView getImageFromURL:picArray[index]];
        imageView.isLoad = YES;
    }
    
}
-(void)picShow:(NSArray *)dataArray atIndex:(int)page
{
    picArray = [NSMutableArray arrayWithArray:dataArray];
    for (int i =0; i<dataArray.count; i++) {
        SizeImageView *imageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, mainSC.frame.size.width, mainSC.frame.size.height)];
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
        imageView.tag = 100+i;
        [mainSC addSubview:imageView];
    }
    SizeImageView *imageView = (SizeImageView *)[mainSC viewWithTag:100+page];
    [imageView getImageFromURL:picArray[page]];
    imageView.isLoad = YES;
    
    mainSC.contentSize = CGSizeMake(mainSC.frame.size.width*dataArray.count, mainSC.frame.size.height);
    mainSC.contentOffset = CGPointMake(page*mainSC.frame.size.width, 0);
}
-(void)tap:(UIGestureRecognizer *)sender
{
//     [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *tempView = (SizeImageView *)sender.view;
        tempImage = tempView.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        if (tempImage != nil) {
            UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil,nil);
        }
    }
    
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
