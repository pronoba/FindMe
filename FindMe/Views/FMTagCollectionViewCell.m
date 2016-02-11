//
//  FMTagCollectionViewCell.m
//  FindMe
//
//  Created by Pronob Ashwin on 2/9/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//

#import "FMTagCollectionViewCell.h"
#import "FMItemModel.h"

@interface FMTagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *tagTextLabel;


@end

@implementation FMTagCollectionViewCell

- (void)awakeFromNib
{
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
}



- (void)assignTagsFrom:(FMItemModel *)itemModel forTagIndex:(NSInteger)tagIndex
{
    self.tagString = [itemModel.itemTags objectAtIndex:tagIndex];
    self.tagTextLabel.text = self.tagString;
}


- (IBAction)deleteTagPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteCollectionViewCell:)]) {
        [self.delegate deleteCollectionViewCell:self];
    }
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attr = [layoutAttributes copy];
    
    CGSize size = [self.tagTextLabel sizeThatFits:CGSizeMake(CGRectGetWidth(layoutAttributes.frame),CGFLOAT_MAX)];
    CGRect newFrame = attr.frame;
    newFrame.size.width = size.width;
    attr.frame = newFrame;
    return attr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tagTextLabel.preferredMaxLayoutWidth = _tagTextLabel.bounds.size.width;
}


@end
