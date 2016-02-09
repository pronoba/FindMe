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

- (NSInteger)numberOfPhotosForItem:(FMItemModel *)itemModel;

- (UIImage *)imageForItem:(FMItemModel *)item atIndex:(NSInteger)row;
- (void)addImageToNewItem:(UIImage *)image;

- (void)saveItemWithName:(NSString *)name;
@end
