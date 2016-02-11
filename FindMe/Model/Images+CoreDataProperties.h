//
//  Images+CoreDataProperties.h
//  FindMe
//
//  Created by Pronob Ashwin on 2/11/16.
//  Copyright © 2016 Pronob Ashwin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Images.h"

NS_ASSUME_NONNULL_BEGIN

@interface Images (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
