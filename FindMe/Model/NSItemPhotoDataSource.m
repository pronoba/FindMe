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



- (NSInteger)numberOfPhotosForItem:(FMItemModel *)itemModel
{
    NSArray *photosArray = itemModel.itemImages;
    return [photosArray count];
}


- (UIImage *)imageForItem:(FMItemModel *)item atIndex:(NSInteger)row
{
    UIImage *image = [item.itemImages objectAtIndex:row];
    
    return image;
}

- (void)addImageToNewItem:(UIImage *)image
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];
    
    if (itemModel == nil) {
        itemModel = [[FMModelManager sharedManager] createNewModelWithName:@""];
    }
    
    [itemModel.itemImages addObject:image];
}

- (void)saveItemWithName:(NSString *)name
{
    FMItemModel *itemModel = [[FMModelManager sharedManager] currentAddedModel];

    if (itemModel) {
        itemModel.itemName = name;
    }
}

@end
