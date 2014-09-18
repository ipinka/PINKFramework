//
//  PINKBaseRoute+PrivateMethod.h
//  DoctorAnswer
//
//  Created by Pinka on 14-8-22.
//  Copyright (c) 2014年 Pinka. All rights reserved.
//

#import "PINKBaseRoute.h"

@interface PINKBaseRoute (PrivateMethod)

@property (nonatomic, weak) UIViewController *parentViewController;

+ (NSString *)viewControllerNameFromViewModel:(id)viewModel;

@end
