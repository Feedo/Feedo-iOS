//
//  APIConnector.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

#import "Constants.h"
#import "FDFeed.h"
#import "FDFeedItem.h"

@interface APIConnector : NSObject

+ (APIConnector *)instance;

- (id)initWithHost:(NSString*)host;

- (void)requestFeedsWithCallback:(void (^)(NSArray* items, NSError *error))callback;
- (void)requestFeedItemsWithFeedID:(int)feedId
                      WithCallback:(void (^)(NSArray *array, NSError *error))callback;
- (void)addFeedFromURL:(NSString *)url
          WithCallback:(void (^)(NSArray *items, NSError *error))callback;
- (void)addFeed:(FDFeed *)feed
   WithCallback:(void (^)(NSArray *items, NSError *error))callback;
- (void)deleteFeed:(FDFeed *)feed
      WithCallback:(void (^)(NSArray *items, NSError *error))callback;

@property (nonatomic) NSString* hostUrl;

@end
