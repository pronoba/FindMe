//
//  FMModelManager.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMModelManager.h"

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
    }
    
    return self;
}

- (void)createNewModelWithName:(NSString *)modelName
{
    FMItemModel *model = [[FMItemModel alloc] initWithItem:modelName];
    [self.itemArray addObject:model];
}

- (FMItemModel *)currentAddedModel
{
    return [self.itemArray firstObject];
}

- (NSArray *)searchForItemsWithTags:(NSString *) tags
{
    if (self.itemArray.count < 1) {
        return [NSArray array]; // returns empty array
    }

    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (FMItemModel *item in self.itemArray) {
        if ([item.itemTags containsObject:tags]) {
            [searchArray addObject:item];
        }
    }
    
    return searchArray;
}

#pragma mark save

- (NSData *)archiveModelManager
{
    NSData *cafeMealTimeData = [NSKeyedArchiver archivedDataWithRootObject:self.itemArray];
    [[NSUserDefaults standardUserDefaults] setObject:cafeMealTimeData forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
