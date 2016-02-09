//
//  PAPhotoCollectionViewCell.h
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/9/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


+ (NSString *)reuseIdentifier;
@end
