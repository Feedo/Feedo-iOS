//
//  MasterViewController.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "FeedsTableViewController.h"

#import "FeedItemsTableViewController.h"

@interface FeedsTableViewController () {
    APIConnector *connector;
    
    NSMutableArray *feeds;
}
@end

@implementation FeedsTableViewController

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initControls];
    
    [self initAPIConnector];
}
- (void)initControls
{
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    /* UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton; */
    
    [self.refreshControl addTarget:self
                              action:@selector(refreshControlPulled)
                    forControlEvents:UIControlEventAllEvents];
}
- (void)initAPIConnector
{
    connector = [[APIConnector alloc] initWithHost:@"http://localhost:9292"];
    [self loadFeeds];
}

#pragma mark - Misc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFeeds
{
    [self.refreshControl beginRefreshing];
    
    [connector requestFeedsWithCallback:^(NSArray *items, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if ( !error ) {
            feeds = [NSMutableArray arrayWithArray:items];
            [self.tableView reloadData];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:error.description
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }
    }];
}
- (void)addFeed
{
    if (!feeds) {
        feeds = [[NSMutableArray alloc] init];
    }
    
    // TODO add request for url and add at server side
    NSAssert(NO, @"Not implemented.");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UI Events
- (void)refreshControlPulled
{
    [self loadFeeds];
}
- (void)addButtonPreseed:(id)sender
{
    [self addFeed];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_IDENFIIER
                                                            forIndexPath:indexPath];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:REUSABLE_CELL_IDENFIIER];
    }

    FDFeed *feed = feeds[indexPath.row];
    cell.textLabel.text = [feed title];
    [cell.imageView setImageWithURL:[NSURL URLWithString:feed.faviconUrl] placeholderImage:nil];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [feeds removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FDFeed *feed = feeds[indexPath.row];
        [[segue destinationViewController] setFeed:feed];
    }
}

@end
