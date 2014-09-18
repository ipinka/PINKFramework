//
//  PINKBaseViewModel.h
//  ASK
//
//  Created by Pinka on 14-7-11.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "RVMViewModel.h"

#import "PINKViewModel.h"
#import "PINKRoute.h"

@interface PINKBaseViewModel : RVMViewModel<PINKViewModel, PINKViewModelInitialProtocol>

@property (nonatomic, strong, readonly) id<PINKRoute> route;

@end
