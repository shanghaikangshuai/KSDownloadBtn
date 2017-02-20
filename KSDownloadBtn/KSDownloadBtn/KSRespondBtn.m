//
//  KSRespondBtn.m
//  KSDownloadBtn
//
//  Created by 康帅 on 17/2/20.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "KSRespondBtn.h"
@interface KSRespondBtn()
@property(nonatomic,strong)CAShapeLayer *arrow;
@end
@implementation KSRespondBtn
-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        //添加监听方法
        [self addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        //在按钮上画下载箭头,方法：添加一个shapelayer
        [self drawArrow];
    }
    return self;
}
-(void)beginDownload{
    [self.arrow removeFromSuperlayer];
    if (_startAnimationBlock) {
        _startAnimationBlock();
    }
}
/*
 ** 返回箭头的画线路径
 */
-(UIBezierPath *)arrowLinePath{
    CGFloat startpoint=self.frame.size.width/3;
    CGFloat centerpoint=self.frame.size.height/2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(centerpoint, startpoint)];
    [path addLineToPoint:CGPointMake(centerpoint, 2*startpoint)];
    [path moveToPoint:CGPointMake(startpoint, centerpoint)];
    [path addLineToPoint:CGPointMake(centerpoint, 2*startpoint)];
    [path moveToPoint:CGPointMake(2*startpoint, centerpoint)];
    [path addLineToPoint:CGPointMake(centerpoint, 2*startpoint)];
    return path;
}
/*
 ** 在按钮上画下载箭头
 */
-(void)drawArrow{
    self.arrow=[CAShapeLayer layer];
    self.arrow.strokeColor=[UIColor whiteColor].CGColor;
    //箭头描线的宽度为按钮自身宽度的十分之一
    self.arrow.lineWidth=self.frame.size.width/10;
    //线条起点和终点的圆角处理
    self.arrow.lineCap=kCALineCapRound;
    //线条折点的圆角处理（本项目不涉及折点，可以不设）
//    self.arrow.lineJoin=kCALineCapRound;
    self.arrow.path=[self arrowLinePath].CGPath;
    [self.layer addSublayer:self.arrow];
}
@end
