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
#import "FMPhotoObject.h"
#import "FSAddCollectionViewCell.h"
#import "FMTagCollectionViewCell.h"


static NSString * const addCellIdentifier = @"addCell";
static NSString * const tagCellIdentifier = @"tagCell";

@interface PAPhotoCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FMTagCollectionViewCellDelegate,
                                                UIImagePickerControllerDelegate, UINavigationControllerDelegate, NYTPhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;


@end

@implementation PAPhotoCollectionViewController


- (instancetype)initWithItemModel:(FMItemModel *)itemModel
{
    self = [super init];
    
    if (self)
    {
        _currentItemModel = itemModel;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_currentItemModel == nil) {
        _currentItemModel = [[FMModelManager sharedManager] currentAddedModel];
        self.currentIndexPath = nil;
        
        if (_currentItemModel == nil) {
            _currentItemModel = [[FMModelManager sharedManager] createNewModelWithName:@""];
        }
        [self startCameraControllerFromViewController:self usingDelegate:self];
    } else {
        [self.photoCollectionView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tagsTextField.text = self.currentItemModel.itemName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetCollectionView {
    [self.photoCollectionView deselectItemAtIndexPath:self.currentIndexPath animated:YES];
    [self.photoCollectionView reloadData];
}


- (void)refreshCurrentCell
{
    [self.photoCollectionView performBatchUpdates:^{
        [self.photoCollectionView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
    } completion:nil];
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(170, 170);
    }

    NSString *tag = [self.currentItemModel.itemTags objectAtIndex:indexPath.row];
    CGSize labelSize = [tag sizeWithAttributes:NULL];
    
    return CGSizeMake(labelSize.width + 80, 36);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];
    if (section == 0) {
        return ([photoDataSource numberOfPhotosForItem:self.currentItemModel] + 1);
    }
    
    return [photoDataSource numberOfTagsForItem:self.currentItemModel];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    if (indexPath.section == 0) {
        
        if (indexPath.row == [photoDataSource numberOfPhotosForItem:self.currentItemModel]) {
            FSAddCollectionViewCell *cell = (FSAddCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:addCellIdentifier forIndexPath:indexPath];
            cell.borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.borderView.layer.borderWidth = 2.0;
            
            return cell;
        }
        
        
        PAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [PAPhotoCollectionViewCell reuseIdentifier]
                                                                                    forIndexPath: indexPath];
        
        UIImage *photoImage = [photoDataSource imageForItem:self.currentItemModel atIndex:indexPath.row];
        
        if(photoImage) {
            [self setImageForCell:cell withImage:photoImage];
        }
        
        return cell;
    }
    
    // tags section
    
    FMTagCollectionViewCell *cell = (FMTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:tagCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;

}

- (void)configureCell:(FMTagCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell assignTagsFrom:self.currentItemModel forTagIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


#pragma mark actions

- (IBAction)saveItemsPressed:(id)sender {
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    [photoDataSource saveItemWithName:self.tagsTextField.text];
    
    [self.tagsTextField resignFirstResponder];

    [photoDataSource persistModelManager:self.currentItemModel];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];
    
    // Add pressed
    if (indexPath.row == [photoDataSource numberOfPhotosForItem:self.currentItemModel]) {
        
        self.currentIndexPath = nil;

        [self showActionSheet];
        
        return;
    }

    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.currentItemModel.photoObjects];
    photosViewController.delegate = self;
    
    [self presentViewController:photosViewController animated:YES completion:nil];
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

- (void)showTagAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Tag"
                                          message:@"Tag this shit..."
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Tag";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tagTextField = alertController.textFields.firstObject;

        NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];
        [photoDataSource addTagToNewItem:tagTextField.text];
        [self.photoCollectionView reloadData];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showActionSheet
{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add a detail"
                                          message:@"Tag or take a photo"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionTag = [UIAlertAction actionWithTitle:@"Add a Tag" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showTagAlert];
    }];

    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"Add a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startCameraControllerFromViewController:self usingDelegate:self];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    
    [alertController addAction:actionTag];
    [alertController addAction:actionPhoto];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark FMTagCollectionViewCellDelegate

- (void)deleteCollectionViewCell:(FMTagCollectionViewCell *)tagCollectionViewCell;
{
    NSItemPhotoDataSource *photoDataSource = [NSItemPhotoDataSource photoDataSource];

    [self.photoCollectionView performBatchUpdates: ^{
        [photoDataSource removeTag:tagCollectionViewCell.tagString];
        NSIndexPath *indexPath = [self.photoCollectionView indexPathForCell:tagCollectionViewCell];
        [self.photoCollectionView deleteItemsAtIndexPaths: @[indexPath]];
    } completion:nil];
}

@end
