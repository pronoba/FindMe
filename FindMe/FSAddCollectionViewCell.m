//
//  FSAddCollectionViewCell.m
//  CoPilot
//
//  Created by Pronob Ashwin on 6/29/15.
//  Copyright © 2015 FreeSkies. All rights reserved.
//

#import "FSAddCollectionViewCell.h"


@interface FSAddCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *addButtonLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation FSAddCollectionViewCell



- (void)animateActivityIndicatorOnCell:(BOOL)animating
{
    if (animating) {
        self.addButtonLabel.hidden = YES;
        [self.activityIndicator startAnimating];
        self.userInteractionEnabled = NO;
        return;
    }

    self.addButtonLabel.hidden = NO;
    [self.activityIndicator stopAnimating];
    self.userInteractionEnabled = YES;
}

@end
