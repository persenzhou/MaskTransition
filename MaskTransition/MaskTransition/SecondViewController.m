//
//  SecondViewController.m
//  MaskTransition
//
//  Created by Apple on 2017/8/7.
//  Copyright © 2017年 PS. All rights reserved.
//

#import "SecondViewController.h"
#import "DismissTransition.h"
@interface SecondViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *percentTransition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenPan:)];
    gesture.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:gesture];
}

- (void)screenPan:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    CGFloat per = [gesture translationInView:self.view].x / self.view.bounds.size.width;
    
    per = MIN(MAX(0.0, per), 1.0);// 控制 per在 0.0 ～ 1.0 之间
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            _percentTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
        
            break;
        case UIGestureRecognizerStateChanged:
            [_percentTransition updateInteractiveTransition:per];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            if (per > 0.3) {
                [_percentTransition finishInteractiveTransition];
            }
            else
            {
                [_percentTransition cancelInteractiveTransition];
            }
            _percentTransition = nil;
            break;
        default:
            break;
    }
    
    
}


- (IBAction)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    return _percentTransition;
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return [[DismissTransition alloc] init];
    }
    
    return nil;
}



@end
