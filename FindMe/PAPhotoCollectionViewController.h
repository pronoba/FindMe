//
//  PAPhotoCollectionViewController.h
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/8/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMItemModel;

@interface PAPhotoCollectionViewController : UIViewController


@property (nonatomic, strong) FMItemModel *currentItemModel;

- (instancetype)initWithItemModel:(FMItemModel *)itemModel;

@end
