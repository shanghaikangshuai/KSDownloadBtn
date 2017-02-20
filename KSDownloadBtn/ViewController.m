//
//  ViewController.m
//  KSDownloadBtn
//
//  Created by 康帅 on 17/2/20.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "ViewController.h"
#import "KSDownloadBtn.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KSDownloadBtn *btn=[[KSDownloadBtn alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    btn.center=self.view.center;
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
