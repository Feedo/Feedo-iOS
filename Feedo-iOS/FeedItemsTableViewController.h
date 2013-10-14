//
//  DetailViewController.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDFeed.h"

@interface FeedItemsTableViewController : UITableViewController

@property (strong, nonatomic) FDFeed* feedItem;

@end
