//
//  FMItemModel.h
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMItemModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, strong) NSMutableArray *itemTags;
@property (nonatomic, strong) NSMutableArray *photoObjects;

- (id)initWithItem:(NSString *)itemName;

- (NSData *)archiveItemModel;
+ (FMItemModel *)unarchiveItemModel;

@end
