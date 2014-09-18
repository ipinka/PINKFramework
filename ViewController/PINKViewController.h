//
//  PINKViewController.h
//  ASK
//
//  Created by Pinka on 14-7-14.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PINKViewModel;

@protocol PINKViewController <NSObject>

- (instancetype)initWithViewModel:(id<PINKViewModel>)viewModel;

- (id<PINKViewModel>)viewModel;

@end
