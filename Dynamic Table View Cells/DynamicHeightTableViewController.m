//
//  DynamicHeightTableViewController.m
//  Dynamic Table View Cells
//
//  Created by Jure Zove on 07/06/15.
//  Copyright (c) 2015 Candy Code. All rights reserved.
//

#import "DynamicHeightTableViewController.h"
#import "DynamicTableViewCell.h"
#import "FlickrData.h"
#import "PhotoFetcher.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface DynamicHeightTableViewController ()

@property (nonatomic, strong) FlickrData *flickrData;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *tableRowHeights;

@end

@implementation DynamicHeightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading photos

- (void)reload {
    self.page = 1;
    __weak typeof(self) weakSelf = self;
    [[PhotoFetcher sharedFetcher] fetchFlickrImagesWithTags:@[@"bali"]
                                                    andPage:self.page
                                                    success:^(FlickrData *newData) {
                                                        if (weakSelf.page == 1)
                                                            weakSelf.flickrData = newData;
                                                        else
                                                            [weakSelf.flickrData appendPhotos:newData.photos];
                                                        
                                                        // Set default row heights to tableView.rowHeight
                                                        [weakSelf setDefaultRowHeights];
                                                        
                                                        [weakSelf.tableView reloadData];
                                                    } error:^(NSURLSessionDataTask *task, NSError *error) {
                                                        NSLog(@"Error: %@\n With url: %@", error, task.response.URL);
                                                    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flickrData.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    Photo *photo = self.flickrData.photos[indexPath.row];
    __weak DynamicTableViewCell *weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell.mainImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:photo.url]]
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.mainImageView.image = image;
                                           // Update table row heights
                                           NSInteger oldHeight = [weakSelf.tableRowHeights[indexPath.row] integerValue];
                                           NSInteger newHeight = (int)image.size.height;
                                           
                                           // Update table row height if image is in different size
                                           if (oldHeight != newHeight) {
                                               weakSelf.tableRowHeights[indexPath.row] = @(newHeight);
                                               // Try experimenting with different ways of reloading rows.
                                               // I found that calling beginUpdates and endUpdates results in the best animation/transition when resizing rows
                                               [weakSelf.tableView beginUpdates];
                                               
                                               // No need to call reloadRowsAtIndexPaths
                                               // [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                               [weakSelf.tableView endUpdates];
                                           }
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"Error: %@\nFetching image with url: %@", error, request.URL);
                                       }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableRowHeights[indexPath.row] integerValue];
}

#pragma mark - Updating row heights

- (void)setDefaultRowHeights {
    self.tableRowHeights = [NSMutableArray arrayWithCapacity:self.flickrData.photos.count];
    for (int i = 0; i < self.flickrData.photos.count; i++) {
        self.tableRowHeights[i] = @(self.tableView.rowHeight);
    }
}

@end
