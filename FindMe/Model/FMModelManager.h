//
//  FMModelManager.h
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMItemModel.h"
#import "AppDelegate.h"
@import CoreData;

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface FMModelManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSArray *)searchForItemsWithTags:(NSString *) tags;
- (FMItemModel *)createNewModelWithName:(NSString *)modelName;
- (FMItemModel *)currentAddedModel;

- (void)saveImagesForItemModel:(FMItemModel *)itemModel;
- (void)initialize;
- (NSData *)archiveModelManager;
+ (NSMutableArray *)unarchiveModelManager;
@end
