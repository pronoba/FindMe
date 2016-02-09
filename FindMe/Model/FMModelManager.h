//
//  FMModelManager.h
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMItemModel.h"

@interface FMModelManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSMutableArray *itemArray;

- (NSArray *)searchForItemsWithTags:(NSString *) tags;
- (FMItemModel *)createNewModelWithName:(NSString *)modelName;
- (FMItemModel *)currentAddedModel;

- (NSData *)archiveModelManager;
+ (NSMutableArray *)unarchiveModelManager;
@end
