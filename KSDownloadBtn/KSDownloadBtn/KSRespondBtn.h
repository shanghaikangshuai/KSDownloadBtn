//
//  KSRespondBtn.h
//  KSDownloadBtn
//
//  Created by 康帅 on 17/2/20.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSRespondBtn : UIButton
/*
 ** 点击事件的block监听
 */
@property(nonatomic,strong)void(^startAnimationBlock)();
@end
