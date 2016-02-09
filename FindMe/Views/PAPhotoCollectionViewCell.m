//
//  PAPhotoCollectionViewCell.m
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/9/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "PAPhotoCollectionViewCell.h"

@interface PAPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

@end

@implementation PAPhotoCollectionViewCell


+ (NSString *)reuseIdentifier
{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    
    return reuseIdentifier;
}

@end
