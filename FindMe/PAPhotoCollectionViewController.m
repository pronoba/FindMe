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
#import "NSItemPhotoDataSource.h"
#import "NYTPhotosViewController.h"

@interface PAPhotoCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                                UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) FMItemModel *currentItemModel;

@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;


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
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];
    return ([photoDataSource numberOfPhotosForItem:self.currentItemModel]);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [PAPhotoCollectionViewCell reuseIdentifier]
                                                                                     forIndexPath: indexPath];

    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    UIImage *photoImage = [photoDataSource imageForItem:self.currentItemModel atIndex:indexPath.row];
    
    if(photoImage) {
        [self setImageForCell:cell withImage:photoImage];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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

#pragma mark actions

- (IBAction)saveItemsPressed:(id)sender {
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    [photoDataSource saveItemWithName:self.tagsTextField.text];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetailSegue" sender:self];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    [photoDataSource addImageToNewItem:chosenImage];
    
    [self.photoCollectionView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
