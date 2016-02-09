//
//  FMItemModel.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMItemModel.h"

@implementation FMItemModel


- (id)initWithItem:(NSString *)itemName
{
    self = [self initWithItem:itemName withDescription:@""];
    return self;
}

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


#pragma mark - NSCopying & NSCoding

- (id)initWithCoder: (NSCoder *)decoder {
    
    if (self = [super init]) {
        _itemName = [decoder decodeObjectForKey:@"itemName"];
        _itemDescription = [decoder decodeObjectForKey:@"itemDescription"];
        _itemTags = [decoder decodeObjectForKey:@"itemTags"];
        _itemImages = [decoder decodeObjectForKey:@"itemImages"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject:_itemName forKey:@"itemName"];
    [encoder encodeObject:_itemDescription forKey:@"itemDescription"];
    [encoder encodeObject:_itemTags forKey:@"itemTags"];
    [encoder encodeObject:_itemImages forKey:@"itemImages"];
}

#pragma mark - Archiver & Unarchiver

- (NSData *)archiveItemModel
{
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:modelData forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return modelData;
}

+ (FMItemModel *)unarchiveItemModel
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    FMItemModel *fmItemModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return fmItemModel;
}




@end
