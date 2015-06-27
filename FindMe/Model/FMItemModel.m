//
//  FMItemModel.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMItemModel.h"

@implementation FMItemModel

- (id)initWithItem:(NSString *)itemName withDescription:(NSString *)itemDescription
{
    self = [super init];
    if (self) {
        _itemName = itemName;
        _itemDescription = itemDescription;
        _itemTags = [NSArray array];
        _itemImages = [NSArray array];
    }
    
    return self;
}

@end
