//
//  FMTagCollectionViewCell.h
//  FindMe
//
//  Created by Pronob Ashwin on 2/9/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTagCollectionViewCell;
@class FMItemModel;

@protocol FMTagCollectionViewCellDelegate <NSObject>

- (void)deleteCollectionViewCell:(FMTagCollectionViewCell *)tagCollectionViewCell;

@end



@interface FMTagCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *tagString;
@property (weak, nonatomic) id<FMTagCollectionViewCellDelegate> delegate;


- (void)assignTagsFrom:(FMItemModel *)itemModel forTagIndex:(NSInteger)tagIndex;

@end
