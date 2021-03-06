//
//  KSDownloadBtn.h
//  KSDownloadBtn
//
//  Created by 康帅 on 17/2/20.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSDownloadBtn : UIView
//振幅，a
@property (nonatomic, assign) CGFloat wave_Amplitude;
//周期，w
@property (nonatomic, assign) CGFloat wave_Cycle;
//两个波水平之间偏移
@property (nonatomic, assign) CGFloat wave_h_distance;
//两个波竖直之间偏移
@property (nonatomic, assign) CGFloat wave_v_distance;
//水波速率
@property (nonatomic, assign) CGFloat wave_scale;
//前方波纹颜色
@property (nonatomic, strong) UIColor *topColor;
//后方波纹颜色
@property (nonatomic, strong) UIColor *bottomColor;
//y = asin(wx+φ) + k
//进度,计算k
@property (nonatomic, assign) CGFloat progress;
//边界path，水波的容器
@property (nonatomic, strong) UIBezierPath *borderPath;
//容器填充色
@property (nonatomic, strong) UIColor *border_fillColor;
@end
