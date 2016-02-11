//
//  FSAddCollectionViewCell.h
//  CoPilot
//
//  Created by Pronob Ashwin on 6/29/15.
//  Copyright © 2015 FreeSkies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAddCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *borderView;


- (void)animateActivityIndicatorOnCell:(BOOL)animating;

@end
