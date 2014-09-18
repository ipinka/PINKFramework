//
//  PINKLoadMoreTableView.h
//  ASK
//
//  Created by Pinka on 14-7-16.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKBindTableView.h"

@interface PINKLoadMoreTableView : PINKBindTableView

@property (nonatomic, getter = isCompleted) BOOL compeled;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, strong) RACCommand *loadMoreCommand;

@property (nonatomic, strong) UIView *loadingTableFooterView;

@end
