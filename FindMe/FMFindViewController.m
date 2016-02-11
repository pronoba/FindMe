//
//  FMFindViewController.m
//  FindMe
//
//  Created by Pronob Ashwin on 6/24/15.
//  Copyright (c) 2015 Pronob Ashwin. All rights reserved.
//

#import "FMFindViewController.h"
#import "FMModelManager.h"
#import "FMPhotoObject.h"
#import "NYTPhotosViewController.h"
#import "PAPhotoCollectionViewController.h"

@interface FMFindViewController() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *searchArray;
@end

@implementation FMFindViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar sizeToFit];
    
    FMModelManager *fmModelManager = [FMModelManager sharedManager];

    self.searchArray = fmModelManager.itemArray;
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"viewSegue"]) {
        FMItemModel *selectedItem = [self.searchArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        PAPhotoCollectionViewController *photoViewController = segue.destinationViewController;
        photoViewController.currentItemModel = selectedItem;
    }
}


#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchForText:(NSString *)searchText
{
    FMModelManager *fmModelManager = [FMModelManager sharedManager];
    
    self.searchArray = [fmModelManager searchForItemsWithTags:searchText];
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.searchArray == nil) || (self.searchArray.count == 0)) {
        return 0;
    }
    
    return self.searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCell"];
    }
    
    FMItemModel *item = [self.searchArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemName;

    FMPhotoObject *photoObject = [item.photoObjects firstObject];
    cell.imageView.image = photoObject.image;
    // Code omitted to configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"viewSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}


@end
