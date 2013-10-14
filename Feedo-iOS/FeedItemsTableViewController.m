//
//  DetailViewController.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "FeedItemsTableViewController.h"

@interface FeedItemsTableViewController ()
- (void)configureView;
@end

@implementation FeedItemsTableViewController

#pragma mark - Managing the detail item

- (void)setFeedItem:(FDFeed*)newFeedItem
{
    if (_feedItem != newFeedItem) {
        _feedItem = newFeedItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.feedItem) {
        self.title = self.feedItem.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
