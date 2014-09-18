//
//  PINKViewModel.h
//  ASK
//
//  Created by Pinka on 14-7-14.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PINKRoute;

@protocol PINKViewModel <NSObject>

@property (nonatomic, assign, getter = isActive) BOOL active;

- (id<PINKRoute>)route;
- (void)didLoadViewModel;

@end

@protocol PINKViewModelInitialProtocol <NSObject>

- (id<PINKRoute>)initialRoute;

@end
