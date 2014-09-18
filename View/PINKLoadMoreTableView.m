//
//  PINKLoadMoreTableView.m
//  ASK
//
//  Created by Pinka on 14-7-16.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKLoadMoreTableView.h"

#import "MessageInterceptor.h"

@interface PINKLoadMoreTableView ()<UITableViewDataSource>
{
    NSInteger _numberOfRowsInLastSection;
    NSInteger _numberOfSections;
    
    UIView *_realTableFooterView;
    UIView *_userTableFooterView;
}

@end

@implementation PINKLoadMoreTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self p_InitialPINKLoadMoreTableView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self p_InitialPINKLoadMoreTableView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self p_InitialPINKLoadMoreTableView];
    }
    
    return self;
}

- (void)p_InitialPINKLoadMoreTableView
{
    _realTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    _realTableFooterView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Overwrite setTableFooterView
- (void)setTableFooterView:(UIView *)tableFooterView
{
    _userTableFooterView = tableFooterView;
    [self reloadRealTableFooterView];
}

- (void)reloadRealTableFooterView
{
    [_realTableFooterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat yOffset = 0.0;
    if (!_compeled) {
        _loadingTableFooterView.left    = 0.0;
        _loadingTableFooterView.top     = 0.0;
        _loadingTableFooterView.width   = _realTableFooterView.width;
        _loadingTableFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [_realTableFooterView addSubview:_loadingTableFooterView];
        
        yOffset = _loadingTableFooterView.bottom;
    }
    
    if (_userTableFooterView) {
        _userTableFooterView.left   = 0.0;
        _userTableFooterView.top    = yOffset;
        _userTableFooterView.width  = _realTableFooterView.width;
        _userTableFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [_realTableFooterView addSubview:_userTableFooterView];
        
        yOffset += _userTableFooterView.bottom;
    }
    
    _realTableFooterView.height = yOffset;
    super.tableFooterView = nil;
    super.tableFooterView = _realTableFooterView;
}

- (void)setLoadingTableFooterView:(UIView *)loadingTableFooterView
{
    _loadingTableFooterView = loadingTableFooterView;
    [self reloadRealTableFooterView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    _numberOfSections = [super numberOfSectionsInTableView:tableView];
    
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = [super tableView:tableView numberOfRowsInSection:section];
    if (section == (_numberOfSections - 1)) {
        _numberOfRowsInLastSection = number;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == (_numberOfSections-1)) &&
        (indexPath.row == (_numberOfRowsInLastSection - 1)) &&
        !_compeled) {
        [_loadMoreCommand execute:self];
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Properties
- (void)setLoadMoreCommand:(RACCommand *)loadMoreCommand
{
    _loadMoreCommand = loadMoreCommand;
    RAC(self, loading) = _loadMoreCommand.executing;
    [_loadMoreCommand execute:self];
}

- (void)setCompeled:(BOOL)compeled
{
    _compeled = compeled;
    
    [self reloadRealTableFooterView];
}

- (void)setLoading:(BOOL)loading
{
    if (_loading && !loading) {
        [self reloadData];
    }
    _loading = loading;
}

@end
