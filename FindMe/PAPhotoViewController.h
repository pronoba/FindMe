//
//  PAPhotoViewController.h
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/10/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMModelManager.h"

@interface PAPhotoViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

-(void)showImageforItem:(FMItemModel *)currentItemModel atIndex:(NSInteger)indexRow;

@end
