//
//  NSItemPhotoDataSource.h
//  FindMe
//
//  Created by Pronob Ashwin on 2/9/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FMItemModel;

@interface NSItemPhotoDataSource : NSObject


+ (instancetype)photoDataSource;
- (void)persistModelManager:(FMItemModel *)itemModel;
- (NSInteger)numberOfTagsForItem:(FMItemModel *)itemModel;
- (NSInteger)numberOfPhotosForItem:(FMItemModel *)itemModel;
- (void)removeTag:(NSString *)tag;
- (UIImage *)imageForItem:(FMItemModel *)item atIndex:(NSInteger)row;
- (void)addImageToNewItem:(UIImage *)image;
- (void)addTagToNewItem:(NSString *)tagString;
- (void)saveItemWithName:(NSString *)name;
- (void)removeItemAtIndex:(NSInteger)index;
@end
