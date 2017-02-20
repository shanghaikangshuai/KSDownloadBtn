//
//  KSDownloadBtn.m
//  KSDownloadBtn
//
//  Created by 康帅 on 17/2/20.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "KSDownloadBtn.h"
#import "KSRespondBtn.h"

@interface KSDownloadBtn()<CAAnimationDelegate>{
    //移动的距离，配合速率设置
    CGFloat _wave_move_width;
    //上升的速度
    CGFloat _offsety_scale;
    //根据进度计算(波峰所在位置的y坐标)
    CGFloat _wave_offsety;
    //偏移,animation
    CGFloat _wave_offsetx;
    CADisplayLink *_waveDisplaylink;
}
@property (nonatomic, strong) KSRespondBtn *respondBtn;
@property (nonatomic, strong) UIView *animationView;
@end
@implementation KSDownloadBtn

/*
 ** 重写initWithFrame构造方法，并做一些其他初始化工作
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        //设置背景色
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.animationView];
        [self addSubview:self.respondBtn];
        [self initView];
    }
    return self;
}

/*
 ** 初始化波浪所需的参数
 */
-(void)initView{
    _wave_Amplitude = self.frame.size.height/20;
    _wave_Cycle = 2*M_PI/(self.frame.size.width * .9);
    _wave_h_distance = 2*M_PI/_wave_Cycle * .65;
    _wave_v_distance = _wave_Amplitude * .2;
    _wave_move_width = 0.5;
    _wave_scale = 0.5;
    _offsety_scale = 0.01;
    _topColor = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:1];
    _bottomColor = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:.3];
    _wave_offsety = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
    CGRect rect = self.frame;
    rect.size.height = rect.size.width;
    self.borderPath  = [UIBezierPath bezierPathWithOvalInRect:rect];
    //经验证，groupTableViewBackgroundColor这种颜色属性再iphone5中不能正常显示。为了通用，建议使用   underPageBackgroundColor    这个色调和上面的差不多（但是后者苹果iOS7以后已经不建议使用了）。
    self.border_fillColor = [UIColor groupTableViewBackgroundColor];
    [self KS_startWave];
}

/*
 ** 开始刷新波浪
 */
- (void)KS_startWave {
    if (!_waveDisplaylink) {
        //每一帧执行动画的刷新
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeoff)];
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/*
 ** 结束刷新波浪
 */
- (void)KS_stopWave {
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
}

/*
 ** 每过一帧执行一次
 */
- (void)changeoff {
    _wave_offsetx += _wave_move_width*_wave_scale;
    [self setNeedsDisplay];
    
    //偏移较小的时候加速
    if (_wave_offsety < 5.0) {
        _offsety_scale += 1.0;
    }
    
    if (_wave_offsety <= 0.01) {
        [self KS_checkAnimation];
        [self KS_endAnimation];
        [self KS_stopWave];
        NSLog(@"finish");
    }
}

/*
 ** 具体描绘波形
 */
-(void)KS_drawWaveColor:(UIColor *)color offsetX:(CGFloat)offsetx offsetY:(CGFloat)offsety{
    CGFloat end_offY = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
    if (_wave_offsety != end_offY) {
        if (end_offY < _wave_offsety) {
            _wave_offsety = MAX(_wave_offsety-=(_wave_offsety - end_offY)*_offsety_scale, end_offY);
        } else {
            _wave_offsety = MIN(_wave_offsety+=(end_offY-_wave_offsety)*_offsety_scale, end_offY);
        }
    }
    
    UIBezierPath *wave = [UIBezierPath bezierPath];
    for (float next_x= 0.f; next_x <= self.frame.size.width; next_x ++) {
        //正弦函数，绘制波形
        CGFloat next_y = _wave_Amplitude * sin(_wave_Cycle*next_x + _wave_offsetx + offsetx/self.bounds.size.width*2*M_PI) + _wave_offsety + offsety;
        if (next_x == 0) {
            [wave moveToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
        } else {
            [wave addLineToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
        }
    }
    [wave addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [color set];
    [wave fill];
}

/*
 ** 勾号动画
 */
-(void)KS_checkAnimation{
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
    
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = self.frame.size.width/10;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    //这个可以起到判断不同anim的方法：KVO
    [checkAnimation setValue:@"KS_checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
    
}
/*
 ** 波形结束后的雷达放大动画
 */
- (void)KS_endAnimation {
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    _animationView.backgroundColor = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:1];
    // 为了不影响缩小后的效果，提前将振动波视图缩小
    _animationView.transform = CGAffineTransformMakeScale(.9, .9);
    // 视图缩小动画
    [UIView animateWithDuration: .9
                          delay: 1.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _animationView.transform = CGAffineTransformMakeScale(.9, .9);
                         
                     }
                     completion:^(BOOL finished) {
                         // 震动波效果
                         [UIView animateWithDuration: 2.1
                                          animations:^{
                                              _animationView.transform = CGAffineTransformMakeScale(3, 3);
                                              _animationView.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [_animationView removeFromSuperview];
                                          }];
                         //弹簧震动效果
                         [UIView animateWithDuration: 1.f
                                               delay: 0.2
                              usingSpringWithDamping: 0.4
                               initialSpringVelocity: 0
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // 视图瞬间增大一倍
                                              self.transform = CGAffineTransformMakeScale(1.8, 1.8);
                                              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
}
#pragma drawRect
-(void)drawRect:(CGRect)rect{
    if (_borderPath) {
        if (_border_fillColor) {
            [_border_fillColor setFill];
            [_borderPath fill];
        }

        [_borderPath addClip];
    }
    //绘制前后两个波形图
    [self KS_drawWaveColor:_topColor offsetX:0 offsetY:0];
    [self KS_drawWaveColor:_bottomColor offsetX:_wave_h_distance offsetY:_wave_v_distance];
}
#pragma 懒加载
-(KSRespondBtn *)respondBtn{
    if(!_respondBtn){
        _respondBtn=[[KSRespondBtn alloc]initWithFrame:self.frame];
        _respondBtn.backgroundColor=[UIColor clearColor];
        __weak typeof (self) weakself=self;
        _respondBtn.startAnimationBlock=^(){
            NSLog(@"click");
            [weakself setProgress:1.0];
        };
    }
    return _respondBtn;
}
-(UIView *)animationView{
    if (!_animationView) {
        _animationView=[[UIView alloc]initWithFrame:self.frame];
        _animationView.backgroundColor=[UIColor clearColor];
        _animationView.layer.cornerRadius=_animationView.frame.size.width/2;
    }
    return _animationView;
}
@end
