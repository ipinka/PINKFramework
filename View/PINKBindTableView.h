//
//  PINKBindTableView.h
//  ASK
//
//  Created by Pinka on 14-7-15.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PINKBindCellProtocol;

typedef UITableViewCell *(^PINKBindTableViewCreateCellBlock)(NSIndexPath *indexPath);

@interface PINKBindTableView : UITableView

@property (nonatomic, getter = isAutoCheckDataSource) BOOL autoCheckDataSource;
@property (nonatomic, getter = isAutoDeselect) BOOL autoDeselect;
@property (nonatomic, getter = isAutoReload) BOOL autoReload;
@property (nonatomic, getter = isAutoCellHeight) BOOL autoCellHeight;

@property (nonatomic, readonly) id<UITableViewDataSource> realDataSource;
@property (nonatomic, readonly) id<UITableViewDelegate> realDelegate;

- (void)setDataSourceSignal:(RACSignal *)sourceSignal
           selectionCommand:(RACCommand *)selection
                  cellClass:(Class<PINKBindCellProtocol>)cellClass;

- (void)setDataSourceSignal:(RACSignal *)sourceSignal
           selectionCommand:(RACCommand *)selection
            createCellBlock:(PINKBindTableViewCreateCellBlock)createCellBlock;

@end

//以下是截获了的方法，继承子类时可以直接重写，但还是要调用super
@interface PINKBindTableView (UITableViewDataSourceIntercept)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PINKBindTableView (UITableViewDelegateIntercept)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
