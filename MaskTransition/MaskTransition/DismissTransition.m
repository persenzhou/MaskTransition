//
//  DismissTransition.m
//  MaskTransition
//
//  Created by Apple on 2017/8/7.
//  Copyright © 2017年 PS. All rights reserved.
//

#import "DismissTransition.h"
#import "ViewController.h"
@interface DismissTransition()<CAAnimationDelegate>
@property (nonatomic,weak) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation DismissTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    _transitionContext = transitionContext;
    
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    // 创建 startPath endPath
    CGRect touchRect = [toVC touchRect];

    // to view rect 角上的4个点
    CGFloat width = toVC.view.frame.size.width;
    CGFloat hieght = toVC.view.frame.size.height;
    
    CGPoint leftTop = toVC.view.frame.origin;
    CGPoint leftBottom = CGPointMake(leftTop.x,hieght);
    CGPoint rightTop = CGPointMake(width, leftTop.y);
    CGPoint rightBottom = CGPointMake(width, hieght);
    
    // 计算 touch point 离角上4个点的距离 获取最大作为 end path 的半径
    CGPoint touchPoint = CGPointMake(touchRect.origin.x + touchRect.size.width * 0.5, touchRect.origin.y + touchRect.size.height * 0.5);
    
    CGFloat leftTopDistance = [self pointDistancePoint1:leftTop point2:touchPoint];
    CGFloat leftBottomDistance = [self pointDistancePoint1:leftBottom point2:touchPoint];
    CGFloat rightTopDistance = [self pointDistancePoint1:rightTop point2:touchPoint];
    CGFloat rightBottomDistance = [self pointDistancePoint1:rightBottom point2:touchPoint];
    
    CGFloat radius = MAX(MAX(MAX(leftTopDistance, leftBottomDistance), rightTopDistance), rightBottomDistance);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:touchRect];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(touchPoint.x - radius, touchPoint.y - radius, radius * 2, radius * 2)];
    
    // 设置 mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = startPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    // mask 动画
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)endPath.CGPath;
    animation.toValue = (__bridge id)startPath.CGPath;
    animation.duration = [self transitionDuration:transitionContext];
    animation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [maskLayer  addAnimation:animation forKey:@"path"];
}

#pragma mark - ======== CAAnimationDelegate ========

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];

}

- (CGFloat)pointDistancePoint1:(CGPoint)point1 point2:(CGPoint)point2{
    
    CGFloat x = point1.x - point2.x;
    CGFloat y = point1.y - point2.y;
    return sqrt((x * x) + (y * y));
}


@end
