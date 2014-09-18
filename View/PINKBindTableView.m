//
//  PINKBindTableView.m
//  ASK
//
//  Created by Pinka on 14-7-15.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKBindTableView.h"

#import "MessageInterceptor.h"

#import "PINKBindCellProtocol.h"

typedef NS_OPTIONS(NSInteger, PINKBindTableView_DataSource_MethodType) {
    PINKBindTableView_DataSource_MethodType_numberOfSectionsInTableView  = 1 << 0,
    PINKBindTableView_DataSource_MethodType_numberOfRowsInSection        = 1 << 1,
    PINKBindTableView_DataSource_MethodType_cellForRowAtIndexPath        = 1 << 2,
};


typedef NS_OPTIONS(NSInteger, PINKBindTableView_Delegate_MethodType) {
     PINKBindTableView_Delegate_MethodType_heightForRowAtIndexPath  = 1 << 0,
};

@interface PINKBindTableView ()<UITableViewDataSource, UITableViewDelegate>
{
    MessageInterceptor *_dataSourceInterceptor;
    MessageInterceptor *_delegateInterceptor;
    
    PINKBindTableView_DataSource_MethodType _dataSourceMethodType;
    PINKBindTableView_Delegate_MethodType _delegateMethodType;
}

/**
 *  tableData为nil时，若dataSource或delegate实现了对应方法，则调用。
 */
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) RACCommand *didSelectedCommand;
@property (nonatomic, unsafe_unretained) Class<PINKBindCellProtocol> cellClass;
@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, copy) PINKBindTableViewCreateCellBlock createCellBlock;

@property (nonatomic, strong) UITableViewCell<PINKBindCellProtocol> *cacheCell;

@end

@implementation PINKBindTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self p_InitPINKBindTableView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self p_InitPINKBindTableView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self p_InitPINKBindTableView];
    }
    
    return self;
}

#pragma mark - Private Initialize
- (void)p_InitPINKBindTableView
{
    _autoCheckDataSource = YES;
    _autoDeselect = YES;
    _autoReload = YES;
    
    _dataSourceInterceptor = [[MessageInterceptor alloc] init];
    _dataSourceInterceptor.middleMan = self;
    _dataSourceInterceptor.receiver = [super dataSource];
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
    
    _delegateInterceptor = [[MessageInterceptor alloc] init];
    _delegateInterceptor.middleMan = self;
    _delegateInterceptor.receiver = [super delegate];
    [super setDelegate:(id<UITableViewDelegate>)_delegateInterceptor];
}

#pragma mark - Overwrite DataSource
- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (_dataSourceInterceptor) {
        _dataSourceInterceptor.receiver = dataSource;
        //UITableViewDataSource有类似缓存机制优化，所以先设置nil
        [super setDataSource:nil];
        [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
        
        [self updateDataSourceMethodType];
    } else {
        [super setDataSource:dataSource];
    }
}

- (id<UITableViewDataSource>)realDataSource
{
    if (_dataSourceInterceptor) {
        return _dataSourceInterceptor.receiver;
    } else {
        return [super dataSource];
    }
}

#pragma mark - Overwrite Delegate
- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if (_delegateInterceptor) {
        _delegateInterceptor.receiver = delegate;
        
        [super setDelegate:nil];
        [super setDelegate:(id<UITableViewDelegate>)_delegateInterceptor];
    } else {
        [super setDelegate:delegate];
    }
}

- (id<UITableViewDelegate>)realDelegate
{
    if (_delegateInterceptor) {
        return _delegateInterceptor.receiver;
    } else {
        return [super delegate];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_tableData &&
        _dataSourceMethodType & PINKBindTableView_DataSource_MethodType_numberOfSectionsInTableView) {
        return [_dataSourceInterceptor.receiver numberOfSectionsInTableView:tableView];
    } else
        return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_tableData &&
        _dataSourceMethodType & PINKBindTableView_DataSource_MethodType_numberOfRowsInSection) {
        return [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    } else
        return [_tableData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_tableData &&
        _dataSourceMethodType & PINKBindTableView_DataSource_MethodType_cellForRowAtIndexPath) {
        return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier];
        if (!cell) {
            if (_cellClass) {
                cell = [[(Class)_cellClass alloc] init];
            } else if (_createCellBlock) {
                cell = _createCellBlock(indexPath);
            }
        }
        [(id<PINKBindCellProtocol>)cell bindCellViewModel:_tableData[indexPath.section][indexPath.row]
                                                indexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_autoDeselect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (_tableData && _didSelectedCommand) {
        [_didSelectedCommand execute:_tableData[indexPath.section][indexPath.row]];
    }
    
    if ([_delegateInterceptor.receiver respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegateInterceptor.receiver tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_autoCellHeight && _cacheCell) {
        [_cacheCell bindCellViewModel:_tableData[indexPath.section][indexPath.row]
                            indexPath:indexPath];
        return [_cacheCell cellHeight];
    }
    
    if (_delegateMethodType & PINKBindTableView_Delegate_MethodType_heightForRowAtIndexPath) {
        return [_delegateInterceptor.receiver tableView:tableView
                                heightForRowAtIndexPath:indexPath];
    }
    
    return tableView.rowHeight;
}

#pragma mark - 缓存DataSource方法
- (void)updateDataSourceMethodType
{
    _dataSourceMethodType = 0;
    
    if ([_dataSourceInterceptor.receiver respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        _dataSourceMethodType |= PINKBindTableView_DataSource_MethodType_numberOfSectionsInTableView;
    }
    
    if ([_dataSourceInterceptor.receiver respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        _dataSourceMethodType |= PINKBindTableView_DataSource_MethodType_numberOfRowsInSection;
    }
    
    if ([_dataSourceInterceptor.receiver respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        _dataSourceMethodType |= PINKBindTableView_DataSource_MethodType_cellForRowAtIndexPath;
    }
}

#pragma mark - 缓存Delegate方法
- (void)updateDelegateMethodType
{
    _delegateMethodType = 0;
    
    if ([_delegateInterceptor.receiver respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        _delegateMethodType |= PINKBindTableView_Delegate_MethodType_heightForRowAtIndexPath;
    }
}

#pragma mark - API
- (void)setDataSourceSignal:(RACSignal *)sourceSignal
           selectionCommand:(RACCommand *)selection
                  cellClass:(Class<PINKBindCellProtocol>)cellClass
{
    self.cellClass = cellClass;
    self.createCellBlock = nil;
    self.didSelectedCommand = selection;
    [self configCellReuseIdentifierAndCellHeight];
    
    @weakify(self);
    [sourceSignal subscribeNext:^(NSArray *source) {
        @strongify(self);
        self.tableData = source;
        [self reloadData];
    }];
}

- (void)setDataSourceSignal:(RACSignal *)sourceSignal
           selectionCommand:(RACCommand *)selection
            createCellBlock:(PINKBindTableViewCreateCellBlock)createCellBlock
{
    self.cellClass = nil;
    self.createCellBlock = createCellBlock;
    self.didSelectedCommand = selection;
    [self configCellReuseIdentifierAndCellHeight];
    
    @weakify(self);
    [sourceSignal subscribeNext:^(NSArray *source) {
        @strongify(self);
        self.tableData = source;
        [self reloadData];
    }];
}

- (void)configCellReuseIdentifierAndCellHeight
{
    UITableViewCell *oneCell = nil;
    if (_cellClass) {
        oneCell = [[(Class)_cellClass alloc] init];
    } else if (_createCellBlock) {
        oneCell = _createCellBlock([NSIndexPath indexPathForRow:0 inSection:0]);
    }
    _cellReuseIdentifier = oneCell.reuseIdentifier;
    self.rowHeight = oneCell.frame.size.height;
    
    if (_autoCellHeight &&
        [oneCell respondsToSelector:@selector(cellHeight)]) {
        _cacheCell = (UITableViewCell<PINKBindCellProtocol> *)oneCell;
    }
}

#pragma mark - Properties
- (void)setTableData:(NSArray *)tableData
{
    if (_autoCheckDataSource &&
        tableData.count &&
        ![tableData[0] isKindOfClass:[NSArray class]]) {
        _tableData = @[tableData];
    } else {
        _tableData = tableData;
    }
}

- (void)setAutoCellHeight:(BOOL)autoCellHeight
{
    _autoCellHeight = autoCellHeight;
    
    if (_autoCellHeight) {
        if (_cellClass) {
            _cacheCell = [[(Class)_cellClass alloc] init];
        } else if (_createCellBlock) {
            _cacheCell = (UITableViewCell<PINKBindCellProtocol> *)_createCellBlock([NSIndexPath indexPathForRow:0 inSection:0]);
        }
    } else {
        _cacheCell = nil;
    }
}

@end
