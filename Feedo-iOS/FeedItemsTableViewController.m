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
    APIConnector *connector;
    
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

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self initControls];
    
    [self initAPIConnector];
}
- (void)initControls
{
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlPulled)
                  forControlEvents:UIControlEventAllEvents];
}
- (void)initAPIConnector
{
    connector = [[APIConnector alloc] initWithHost:LOCAL_SERVER];
    [self loadFeedItems];
}

#pragma mark - Misc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadFeedItems
{
    [self.refreshControl beginRefreshing];
    
    [connector requestFeedItemsWithFeedID:self.feed.identifier WithCallback:^(NSArray *array, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if ( !error ) {
            feedItems = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                        message:error.localizedFailureReason
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }
        
    }];
}

#pragma mark - UI Events
- (void)refreshControlPulled
{
    [self loadFeedItems];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_IDENFIIER];
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:REUSABLE_CELL_IDENFIIER];
    }
    
    FDFeedItem *feedItem = [feedItems objectAtIndex:indexPath.row];
    cell.textLabel.text = feedItem.title;
    cell.detailTextLabel.text = feedItem.summary;
    
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
