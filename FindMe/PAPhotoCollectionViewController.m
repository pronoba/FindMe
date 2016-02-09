//
//  PAPhotoCollectionViewController.m
//  FiveHundresPixels
//
//  Created by Pronob Ashwin on 6/8/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMGlobalDefines.h"
#import "PAPhotoCollectionViewController.h"
#import "FMModelManager.h"
#import "PAPhotoCollectionViewCell.h"
#import "PAPhotoViewController.h"

@interface PAPhotoCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                                UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) FMItemModel *currentItemModel;
@end

@implementation PAPhotoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[FMModelManager sharedManager] createNewModelWithName:@"New Model"];
    self.currentItemModel = [[FMModelManager sharedManager] currentAddedModel];
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

-(void)setImageForCell:(PAPhotoCollectionViewCell *)cell withImage:(UIImage *)image
{
    cell.photoImageView.image = image;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         cell.photoImageView.alpha = 1.0;
                     }
                     completion:nil];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    FMModelManager *modelManager = [FMModelManager sharedManager];
    return [modelManager.itemArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"photoCell";
    __block PANetworkManager *networkManager = [PANetworkManager sharedManager];
    __block PAPhotoModel *photoModel = [networkManager.photoArray objectAtIndex:indexPath.row];
    
    UIImage *photoImage = [networkManager.imageCache objectForKey:[photoModel.imageURL absoluteString]];
    
    if(photoImage) {
        [self setImageForCell:cell withImage:photoImage];
    } else {
        cell.photoImageView.image = nil;
        cell.photoImageView.alpha = 0.0;
        WeakSelf weakSelf = self;
        
        [networkManager downloadImageFromURL:photoModel.imageURL withCompletion:^(NSData *imageData, NSError *error) {
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    if (cell) {
                        [strongSelf setImageForCell:cell withImage:image];
                    }
                }
            });
            if (networkManager) {
                [networkManager.imageCache setObject:image forKey:[photoModel.imageURL absoluteString]];
            }
        }];
    }
    
    
    return cell;}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    FMModelManager *networkManager = [PANetworkManager sharedManager];
    if ([networkManager.photoArray count]) {
        return 1;
    }
    
    return 0;
}

- (NSIndexPath *)getCurrentIndexPath
{
    NSArray *indexPathArray = [self.photoCollectionView indexPathsForSelectedItems];
    if (indexPathArray.count > 0) {
        NSIndexPath *indexPath = [indexPathArray objectAtIndex:0];
        return indexPath;
    }
    
    return nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // unwrap the controller if it's embedded in the nav controller.
    UIViewController *destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[PAPhotoViewController class]])
    {
        PAPhotoViewController *photoViewController = (PAPhotoViewController *)destVC;
        
        NSIndexPath *indexPath = [self getCurrentIndexPath];

        if (indexPath != nil) {
            [photoViewController showImageforItem:self.currentItemModel atIndex:indexPath.row];
        }
        
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetailSegue" sender:self];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
