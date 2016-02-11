//
//  FMPhotoObject.m
//  FindMe
//
//  Created by Pronob Ashwin on 2/8/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//

#import "FMPhotoObject.h"

@implementation FMPhotoObject


#pragma mark - NSCopying & NSCoding

- (id)initWithCoder: (NSCoder *)decoder {
    
    if (self = [super init]) {
        _placeholderImage = [decoder decodeObjectForKey:@"placeholderImage"];
        _attributedCaptionTitle = [decoder decodeObjectForKey:@"attributedCaptionTitle"];
        _attributedCaptionSummary = [decoder decodeObjectForKey:@"attributedCaptionSummary"];
        _attributedCaptionCredit = [decoder decodeObjectForKey:@"attributedCaptionCredit"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject:_placeholderImage forKey:@"placeholderImage"];
    [encoder encodeObject:_attributedCaptionTitle forKey:@"attributedCaptionTitle"];
    [encoder encodeObject:_attributedCaptionSummary forKey:@"attributedCaptionSummary"];
    [encoder encodeObject:_attributedCaptionCredit forKey:@"attributedCaptionCredit"];
}

#pragma mark - Archiver & Unarchiver

- (NSData *)archiveItemModel
{
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:modelData forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return modelData;
}

+ (FMPhotoObject *)unarchiveItemModel
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    FMPhotoObject *fmModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return fmModel;
}



@end
