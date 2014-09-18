//
//  PINKBaseViewController.m
//  ASK
//
//  Created by Pinka on 14-7-14.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "PINKBaseViewController.h"
#import "PINKBaseRoute.h"

@interface PINKBaseViewController ()

@end

@implementation PINKBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewModel didLoadViewModel];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.viewModel.active = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithViewModel:(id<PINKViewModel>)viewModel
{
    self = [super init];
    
    if (self) {
        _viewModel = viewModel;
        [_viewModel.route setParentViewController:self];
    }
    
    return self;
}

- (void)bindViewModel
{
    
}

@end
