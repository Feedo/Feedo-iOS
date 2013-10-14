//
//  DetailViewController.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "FeedItemsTableViewController.h"

#import "FeedItemDetailsViewController.h"

@interface FeedItemsTableViewController ()
{
    NSMutableArray *feedItems;
}
- (void)configureView;
@end

@implementation FeedItemsTableViewController

#pragma mark - Managing the detail item

- (void)setFeed:(FDFeed*)newFeed
{
    if ( _feed != newFeed) {
        _feed = newFeed;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.feed) {
        self.title = self.feed.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
    APIConnector *connector = [[APIConnector alloc] initWithHost:@"http://localhost:9292"];
    [connector requestFeedItemsWithFeedID:self.feed.identifier WithCallback:^(NSArray *array, NSError *error) {
        if ( !error ) {
            feedItems = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    FDFeedItem *feedItem = [feedItems objectAtIndex:indexPath.row];
    cell.textLabel.text = feedItem.title;
    
    return cell;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FDFeedItem *feedItem = feedItems[indexPath.row];
        
        [[segue destinationViewController] setFeedItem:feedItem];
    }
}

@end
