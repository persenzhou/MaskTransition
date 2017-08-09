//
//  ViewController.m
//  MaskTransition
//
//  Created by Apple on 2017/8/7.
//  Copyright © 2017年 PS. All rights reserved.
//

#import "ViewController.h"
#import "ShowTransition.h"
@interface ViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic,assign) CGRect touchRect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
#pragma mark - ======== Public ========

- (IBAction)push:(UITapGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self.view];
    
    CGFloat size = 40;
    _touchRect = CGRectMake(touchPoint.x - size/2, touchPoint.y - size/2, size, size);
    
    // push
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return [[ShowTransition alloc] init];
    }
    
    return nil;
}


@end
