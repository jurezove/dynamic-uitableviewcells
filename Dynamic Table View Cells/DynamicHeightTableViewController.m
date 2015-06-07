//
//  DynamicHeightTableViewController.m
//  Dynamic Table View Cells
//
//  Created by Jure Zove on 07/06/15.
//  Copyright (c) 2015 Candy Code. All rights reserved.
//

#import "DynamicHeightTableViewController.h"
#import "DynamicTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface DynamicHeightTableViewController ()

@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *tableRowHeights;
@property (nonatomic, strong) NSMutableArray *imageURLs;

@end

static NSString *kStaticDropBoxURL = @"https://dl.dropboxusercontent.com/u/25733120/Zonda/";

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
    static int kNumberOfImages = 20;
    self.imageURLs = [NSMutableArray arrayWithCapacity:kNumberOfImages];
    // A set of uploaded images on my public dropbox folder
    for (int i = 0; i <= kNumberOfImages; i++) {
        self.imageURLs[i] = [NSString stringWithFormat:@"%@%d.jpg", kStaticDropBoxURL, i];
    }
    
    [self setDefaultRowHeights];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    NSString *imageURL = self.imageURLs[indexPath.row];
    __weak DynamicTableViewCell *weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell.mainImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]
                              placeholderImage:[UIImage new]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.mainImageView.image = image;
                                           // Update table row heights
                                           NSInteger oldHeight = [weakSelf.tableRowHeights[indexPath.row] integerValue];
                                           NSInteger newHeight = (int)image.size.height;
                                           
                                           if (image.size.width > CGRectGetWidth(weakCell.mainImageView.bounds)) {
                                               CGFloat ratio = image.size.height / image.size.width;
                                               newHeight = CGRectGetWidth(self.view.bounds) * ratio;
                                           }
                                           
                                           // Update table row height if image is in different size
                                           if (oldHeight != newHeight) {
                                               weakSelf.tableRowHeights[indexPath.row] = @(newHeight);
                                               // Try experimenting with different ways of reloading rows.
                                               // I found that calling beginUpdates and endUpdates results in the best animation/transition when resizing rows
                                               [weakSelf.tableView beginUpdates];
                                               
                                               // No need to call reloadRowsAtIndexPaths
                                               [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    self.tableRowHeights = [NSMutableArray arrayWithCapacity:self.imageURLs.count];
    for (int i = 0; i < self.imageURLs.count; i++) {
        self.tableRowHeights[i] = @(self.tableView.rowHeight);
    }
}

@end
