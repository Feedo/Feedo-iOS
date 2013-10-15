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
    // main navigation bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.906 green:0.545 blue:0.141 alpha:1]; /*#e78b24*/
    // nav items
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addButtonPreseed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // pull-to-refresh target
    [self.refreshControl addTarget:self
                              action:@selector(refreshControlPulled)
                    forControlEvents:UIControlEventAllEvents];
}
- (void)initAPIConnector
{
    connector = [APIConnector instance];
    [self loadFeeds];
}

#pragma mark - Misc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadUIWithFeeds:(NSArray *)items
{
    feeds = [NSMutableArray arrayWithArray:items];
    [self reloadUI];
}
- (void)reloadUI
{
    [self.tableView reloadData];
}
- (void)loadFeeds
{
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Getting feeds from %@...", PREF_SERVER]];
    
    [connector requestFeedsWithCallback:^(NSArray *items, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if ( !error ) {
            [self reloadUIWithFeeds:items];
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
- (void)addFeed
{
    if (!feeds) {
        feeds = [[NSMutableArray alloc] init];
    }
    
    // TODO add request for url and add at server side
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Feed" message:@"Please enter a url to the feed" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)addFeedRequest:(NSString *)feedUrl
{
    // block-save references
    __block FeedsTableViewController *blockSelf = self;
    __block NSMutableArray *blockFeeds = feeds;
    
    [connector addFeedFromURL:feedUrl WithCallback:^(NSArray *items, NSError *error) {
        if ( !error ) {
            // insert into array
            [blockFeeds addObjectsFromArray:items];
            
            // insert into view
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:blockFeeds.count-1
                                                        inSection:0];
            [blockSelf.tableView insertRowsAtIndexPaths:@[indexPath]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ( [buttonTitle isEqualToString:@"Add"] ) {
        NSString *feedUrl = [alertView textFieldAtIndex:0].text;
        
        if ( ![feedUrl hasPrefix:@"http://"] && ![feedUrl hasPrefix:@"https://"] ) {
            feedUrl = [NSString stringWithFormat:@"http://%@", feedUrl];
        }
        
        [self addFeedRequest:feedUrl];
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *input = [[alertView textFieldAtIndex:0] text];
    if ( input ) {
        // validate url
        return [self isValidUrl:input];
    }
    
    return NO;
}

#pragma mark - Helpers
- (BOOL)isValidUrl:(NSString *)url
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];

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
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_IDENFIIER
                                                       forIndexPath:indexPath];
    if ( !cell ) {
        cell = [[FDFeedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:REUSABLE_CELL_IDENFIIER];
    }

    FDFeed *feed = feeds[indexPath.row];
    cell.titleLabel.text = [feed title];
    cell.descriptionLabel.text = [feed description];
    
    [cell.feedImage setImageWithURL:[NSURL URLWithString:feed.faviconUrl]
                   placeholderImage:nil];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FDFeed *feed = [feeds objectAtIndex:indexPath.row];
        [connector deleteFeed:feed WithCallback:^(NSArray *items, NSError *error) {
            
            if ( !error ) {
                [feeds removeObject:feed];
                [tableView deleteRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                            message:error.localizedFailureReason
                                           delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil] show];
            }
        }];
        
    } /* else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    } */
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
