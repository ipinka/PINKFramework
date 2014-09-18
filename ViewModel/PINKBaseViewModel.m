//
//  PINKBaseViewModel.m
//  ASK
//
//  Created by Pinka on 14-7-11.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKBaseViewModel.h"

#import "PINKBaseRoute.h"

@interface PINKBaseViewModel ()

@end

@implementation PINKBaseViewModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _route = [self initialRoute];
    }
    
    return self;
}

- (void)didLoadViewModel
{
    
}

- (id<PINKRoute>)initialRoute
{
    return [[PINKBaseRoute alloc] init];
}

@end
