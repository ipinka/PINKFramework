//
//  PINKRoute.h
//  ASK
//
//  Created by Pinka on 14-7-14.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PINKViewModel;
@protocol PINKViewController;

@protocol PINKRoute <NSObject>

- (UIViewController<PINKViewController> *)viewControllerCreatedByViewModel:(id)viewModel;

- (void)setParentViewController:(UIViewController *)viewController;

//Navgation
- (void)pushViewModel:(id<PINKViewModel>)viewModel popCurrentViewModel:(BOOL)pop;

- (void)popCurrentViewModel;
- (void)popToViewModel:(id<PINKViewModel>)viewModel;
- (void)popToRootViewModel:(id<PINKViewModel>)viewModel;

- (NSArray *)viewModels;

//Modal
- (void)presentViewModel:(id<PINKViewModel>)viewModel completion:(RACCommand *)completion;

@end
