//
//  PINKBaseViewController.h
//  ASK
//
//  Created by Pinka on 14-7-14.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PINKViewController.h"
#import "PINKViewModel.h"

@interface PINKBaseViewController : UIViewController<PINKViewController>

@property (nonatomic, strong) id<PINKViewModel> viewModel;

- (void)bindViewModel;

@end
