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
    self = [super init];
    if (self) {
        _itemName = itemName;
        _itemTags = [NSMutableArray array];
        _photoObjects = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - NSCopying & NSCoding

- (id)initWithCoder: (NSCoder *)decoder {
    
    if (self = [super init]) {
        NSLog(@"decoding item model");
        _itemName = [decoder decodeObjectForKey:@"itemName"];
        _itemTags = [decoder decodeObjectForKey:@"itemTags"];
        _photoObjects = [decoder decodeObjectForKey:@"itemImages"];
        NSLog(@"done item model decoding");
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)encoder {
    NSLog(@"encoding item model");
    [encoder encodeObject:_itemName forKey:@"itemName"];
    [encoder encodeObject:_itemTags forKey:@"itemTags"];
    [encoder encodeObject:_photoObjects forKey:@"itemImages"];
    NSLog(@"done item model encoding");
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
