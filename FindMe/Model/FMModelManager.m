//
//  FMModelManager.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMModelManager.h"
#import "FMPhotoObject.h"
#import "Images.h"

@implementation FMModelManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static id sharedManager;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _itemArray = [FMModelManager unarchiveModelManager];
        _managedObjectContext = APPDELEGATE.managedObjectContext;
    }
    return self;
}


- (void)initialize
{
    for (FMItemModel *itemModel in self.itemArray) {
        for (FMPhotoObject *photoObject in itemModel.photoObjects) {
            NSInteger index = [itemModel.photoObjects indexOfObject:photoObject];
            NSString *uuid = [NSString stringWithFormat:@"%@:%ld", itemModel.itemName, (long)index];

            photoObject.image = [self readImagesFromDBForKey:uuid];
        }
    }
}

- (FMItemModel *)createNewModelWithName:(NSString *)modelName
{
    FMItemModel *model = [[FMItemModel alloc] initWithItem:modelName];
    [self.itemArray addObject:model];
    
    return model;
}

- (FMItemModel *)currentAddedModel
{
    FMItemModel *currentModel = [self.itemArray lastObject];
    
    if (currentModel && [currentModel.itemName isEqualToString:@""]) {
        return currentModel;
    }
    
    return nil;
}

- (NSArray *)searchForItemsWithTags:(NSString *) tags
{
    if (self.itemArray.count < 1) {
        return [NSArray array]; // returns empty array
    }

    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (FMItemModel *item in self.itemArray) {
        if ([item.itemName localizedCaseInsensitiveContainsString:tags]) {
            [searchArray addObject:item];
        } else {
            for (NSString *itemTags in item.itemTags) {
                if ([itemTags localizedCaseInsensitiveContainsString:tags]) {
                    [searchArray addObject:item];
                    break;
                }
            }
        }
    }
    
    return searchArray;
}


- (UIImage *)readImagesFromDBForKey:(NSString *)uuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Images"];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    UIImage *imageFromPhotoObject = nil;
    if (fetchedResults.count > 0) {
        Images *imageObject = [fetchedResults firstObject];
        NSData *dataFromImage = imageObject.image;
        imageFromPhotoObject = [UIImage imageWithData:dataFromImage];
    }
    
    
    return imageFromPhotoObject;
}


- (void)saveImagesForItemModel:(FMItemModel *)itemModel
{
    NSError *error;
    
    for (FMPhotoObject *photoObject in itemModel.photoObjects) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *options = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        NSData *imageData = UIImageJPEGRepresentation(photoObject.image, 1.0);
        NSInteger index = [itemModel.photoObjects indexOfObject:photoObject];
        NSString *uuid = [NSString stringWithFormat:@"%@:%ld", itemModel.itemName, (long)index];
        [options setValue:imageData forKey:@"image"];
        [options setValue:uuid forKey:@"uuid"];
        NSLog(@"saved entity %@", uuid);
        if ([self.managedObjectContext save:&error] == NO) {
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }
    }
    
    
}

#pragma mark save

- (NSData *)archiveModelManager
{
    NSLog(@"Begin ------");
    NSData *cafeMealTimeData = [NSKeyedArchiver archivedDataWithRootObject:self.itemArray];
    [[NSUserDefaults standardUserDefaults] setObject:cafeMealTimeData forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"------ End");
    return cafeMealTimeData;
}

+ (NSMutableArray *)unarchiveModelManager
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    NSMutableArray *itemArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (itemArray == nil) {
        itemArray = [NSMutableArray array];
    }
    
    return itemArray;
}

@end
