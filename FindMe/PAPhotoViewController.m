//
//  PAPhotoViewController.m
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/10/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "PAPhotoViewController.h"

@interface PAPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation PAPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoScrollView.minimumZoomScale=0.5;
    self.photoScrollView.maximumZoomScale=6.0;
    self.photoScrollView.delegate = self;
    self.imageView.image = self.image;

    [self.photoScrollView setContentSize:self.imageView.frame.size];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)showImageforItem:(FMItemModel *)currentItemModel atIndex:(NSInteger)indexRow;
{
    UIImage *photoImage = [currentItemModel.itemImages objectAtIndex:indexRow];
    self.image = photoImage;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

@end
