//
//  NSItemPhotoDataSource.m
//  FindMe
//
//  Created by Pronob Ashwin on 2/9/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//

#import "NSItemPhotoDataSource.h"
#import "FMModelManager.h"
#import "FMItemModel.h"
#import "FMPhotoObject.h"

@implementation NSItemPhotoDataSource

+ (instancetype)photoDataSource
{
    NSItemPhotoDataSource * itemPhotoDataSource = [[self alloc]init];
    
    return itemPhotoDataSource;
}

- (void)removeTag:(NSString *)tag
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];
    
    if ([itemModel.itemTags containsObject:tag]) {
        [itemModel.itemTags removeObject:tag];
    }
}

- (NSInteger)numberOfTagsForItem:(FMItemModel *)itemModel
{
    return [itemModel.itemTags count];
}


- (NSInteger)numberOfPhotosForItem:(FMItemModel *)itemModel
{
    NSArray *photosArray = itemModel.photoObjects;
    return [photosArray count];
}


- (UIImage *)imageForItem:(FMItemModel *)item atIndex:(NSInteger)row
{
    FMPhotoObject *photoObject = [item.photoObjects objectAtIndex:row];
    
    return photoObject.image;
}


- (void)addTagToNewItem:(NSString *)tagString
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];
    
    if (itemModel == nil) {
        itemModel = [[FMModelManager sharedManager] createNewModelWithName:@""];
    }
    
    [itemModel.itemTags addObject:tagString];
}

- (void)addImageToNewItem:(UIImage *)image
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];
    
    if (itemModel == nil) {
        itemModel = [[FMModelManager sharedManager] createNewModelWithName:@""];
    }
    
    FMPhotoObject *newPhotoObject = [[FMPhotoObject alloc] init];
    newPhotoObject.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    newPhotoObject.image = image;
    [itemModel.photoObjects addObject:newPhotoObject];
}

- (void)saveItemWithName:(NSString *)name
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];

    if (itemModel) {
        itemModel.itemName = name;
    }
}

@end
