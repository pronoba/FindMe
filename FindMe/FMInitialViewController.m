//
//  FMInitialViewController.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMInitialViewController.h"
#import "FMModelManager.h"

@implementation FMInitialViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FMModelManager *modelManager = [FMModelManager sharedManager];
    [modelManager initialize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
