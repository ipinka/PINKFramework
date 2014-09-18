//
//  PINKBindCellProtocol.h
//  ASK
//
//  Created by Pinka on 14-7-15.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PINKBindCellProtocol <NSObject>

- (void)bindCellViewModel:(id)viewModel indexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)cellHeight;

@end
