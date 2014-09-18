//
//  PINKPageLoadHelper.m
//  ASK
//
//  Created by Pinka on 14-7-17.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKPageLoadHelper.h"

@interface PINKPageLoadHelper ()

@property (nonatomic, strong) NSNumber *currentCompleteState;

@end

@implementation PINKPageLoadHelper

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _maxPage = NSIntegerMax;
        [self resetCount];
        
        @weakify(self);
        _completedSignal =
        [[RACObserve(self, currentPage)
         map:^id(id value) {
            @strongify(self);
            if (self.totalPage >= 0) {
                if (self.currentPage > self.maxPage) {
                    self->_currentPage = self.maxPage;
                    return @YES;
                } else if (self.currentPage > self.totalPage) {
                    self->_currentPage = self.totalPage;
                    return @YES;
                }
            }
            
            return @NO;
        }]
         throttle:MAXFLOAT
         valuesPassingTest:^BOOL(NSNumber *state) {
             if (!self.currentCompleteState) {
                 self.currentCompleteState = state;
                 return NO;
             } else
                 return [self.currentCompleteState isEqualToNumber:state];
        }];
    }
    
    return self;
}

- (void)resetCount
{
    _totalPage = -1;
    _currentCompleteState = nil;
    self.currentPage = 1;
}

- (void)plusCurrentPageAndSetTotalPage:(NSInteger)totalPage
{
    self.totalPage = totalPage;
    self.currentPage++;
}

@end
