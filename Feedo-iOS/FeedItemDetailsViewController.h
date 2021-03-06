//
//  DetailViewController.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDFeedItem.h"

@interface FeedItemDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, retain) FDFeedItem* feedItem;

@end
