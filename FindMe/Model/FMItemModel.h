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
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, strong) NSMutableArray *itemTags;
@property (nonatomic, strong) NSMutableArray *itemImages;

- (id)initWithItem:(NSString *)itemName;
- (id)initWithItem:(NSString *)itemName withDescription:(NSString *)itemDescription;

- (NSData *)archiveItemModel;
+ (FMItemModel *)unarchiveItemModel;

@end
