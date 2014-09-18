//
//  PINKPageLoadHelper.h
//  ASK
//
//  Created by Pinka on 14-7-17.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINKPageLoadHelper : NSObject

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger maxPage;

@property (nonatomic, strong) RACSignal *completedSignal;

- (void)resetCount;
- (void)plusCurrentPageAndSetTotalPage:(NSInteger)totalPage;

@end
