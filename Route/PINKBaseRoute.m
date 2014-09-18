//
//  PINKBaseRoute.m
//  ASK
//
//  Created by Pinka on 14-7-16.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKBaseRoute.h"

#import "PINKViewController.h"

@interface PINKBaseRoute ()

@property (nonatomic, weak) UIViewController *parentViewController;

+ (NSString *)viewControllerNameFromViewModel:(id)viewModel;

@end

@implementation PINKBaseRoute

- (void)setParentViewController:(UIViewController *)parentViewController
{
    _parentViewController = parentViewController;
}

- (void)pushViewModel:(id<PINKViewModel>)viewModel popCurrentViewModel:(BOOL)pop
{
    if (pop) {
        [_parentViewController.navigationController popViewControllerAnimated:NO];
    }
    
    [_parentViewController.navigationController pushViewController:[self viewControllerCreatedByViewModel:viewModel]
                                                          animated:YES];
}

- (void)popCurrentViewModel
{
    [_parentViewController.navigationController popViewControllerAnimated:YES];
}

- (void)popToViewModel:(id<PINKViewModel>)viewModel
{
    for (UIViewController<PINKViewController> *vc in _parentViewController.navigationController.viewControllers)
        if (vc.viewModel == viewModel)
            [_parentViewController.navigationController popToViewController:vc animated:YES];
}

- (void)popToRootViewModel:(id<PINKViewModel>)viewModel
{
    [_parentViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)viewModels
{
    NSArray *viewModels =
    [_parentViewController.navigationController.viewControllers linq_select:^id(id<PINKViewController> vc) {
        return vc.viewModel;
    }];
    
    return viewModels;
}

- (void)presentViewModel:(id<PINKViewModel>)viewModel completion:(RACCommand *)completion
{
    [_parentViewController presentViewController:[self viewControllerCreatedByViewModel:viewModel]
                                        animated:YES
                                      completion:^{
                                          [completion execute:self];
                                      }];
}

- (UIViewController<PINKViewController> *)viewControllerCreatedByViewModel:(id)viewModel
{
    Class vcClass = NSClassFromString([self.class viewControllerNameFromViewModel:viewModel]);
    UIViewController<PINKViewController> *vc = [[vcClass alloc] initWithViewModel:viewModel];
    
    return vc;
}

#pragma mark - Private Method
+ (NSString *)viewControllerNameFromViewModel:(id)viewModel
{
    NSString *viewModelName = NSStringFromClass([viewModel class]);
    NSString *viewName = [viewModelName substringToIndex:viewModelName.length-5];
    
    return [viewName stringByAppendingString:@"Controller"];
}

@end
